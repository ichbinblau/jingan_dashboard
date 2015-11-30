# encoding: utf-8

class WebApiTools::TradeOrderLockedAttrService < WebApiTools::TradeOrderService

  attr_accessor :cms_content_product_details_lockcfgs

  def valid_locked_items
    errors = @errors
    if   product_items.length == 0
      errors << {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "锁定的项目集合数量必须大于0"}
      return false
    end

    @cms_content_product_details_lockcfgs =[]
    current_locked_mode=1

    #查找锁定信息


    #设置
    @product_contents.each_index do |buy_index|
      buy_product_content, product_item = @product_contents[buy_index], @product_items[buy_index]
      product_id, price_id, num = product_item[:product_id], product_item[:price_id], product_item[:num]
      product_info, product_price_info =buy_product_content[:cms_info_product], buy_product_content[:cms_info_product_price]


      filters = T.find_CmsContentProductDetailsLockcfgs(product_id, act_buy_order[:check_time], [product_price_info])


      user_records = T.find_locked_CmsContentProductDetails_by_created_source(product_price_info, filters, current_locked_mode, 0)
      admin_records = T.find_locked_CmsContentProductDetails_by_created_source(product_price_info, filters, current_locked_mode, 1)

      @traces  <<  {:tag=>"valid_locked_items",:msg=> "filters:#{filters.length}  user_records:#{user_records.length}  admin_records:#{admin_records.length} "  }

      admin_locked_records =admin_records.select { |r| r[:locked] }
      if admin_locked_records.length!=0
        errors << {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "此项目被管理员锁定"}
        return false
      end

      user_locked_records=user_records
      #产生锁定 以及产品信息 这里不保存  最后保存
      #判断锁定信息是否存在，存在的话更新 否则 添加
      #设置 锁定信息 begin

      locked_M= nil
      if user_locked_records.nil? || user_locked_records.length==0
        locked_M = CmsContentProductDetailsLockcfg.new
        locked_M.attr_copy(:cms_info_product_price=>product_price_info )
        locked_M[:cms_content_id]= product_id
        locked_M[:order_now]=0
        locked_M[:date]=@act_buy_order[:check_time]
        locked_M[:json_property]=''
        locked_M[:cms_sort_id]= @cms_sort[:id]
        locked_M[:order_limit]= product_price_info[:num]
        locked_M[:locked]=0
        locked_M[:created_at]=Time.now

        #attr_copy

        #elsif  user_locked_records.length>1
        #  errors << {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "用户设置的锁定有效信息条数>1,无法找到需要修改的目标"}
        #  throw :valid_error
      else
        locked_M = user_locked_records[0]
      end

      locked_value = locked_M[:order_limit] - locked_M[:order_now]-num
      if locked_value< 0 #先前检验过了
        #errors << {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "产品剩余数量不足.限制:#{locked_M[:order_limit]} 已有:#{locked_M[:order_now]},当前购买数量#{num} "}
        errors << {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "产品已被锁定,无法售卖 "}
        #raise ActiveRecord::Rollback
        return false
      else
        locked_M[:order_now]=locked_M[:order_now]+num
        locked_M[:locked]=1 if locked_value==0
      end
      @cms_content_product_details_lockcfgs << locked_M
    end
  end

  def valid_records
    #super if defined?(super)
    status = super
    logger.info("valid_records => #{status}")
    if status
      valid_locked_items
      @errors.length ==0
    end
  end


  def on_save_records (dic)
    #    arg = {:key=> :cms_content_product_details,:data=> @cms_content_product_details,:before=>true }
    fn_tag="TradeOrderLockedAttrService_on_save_records";

    if dic[:key] == :cms_content_product_details && dic[:before]==true
      @cms_content_product_details.each_index do |index|
        product_detail, locked_cfg =@cms_content_product_details[index], @cms_content_product_details_lockcfgs[index]
        locked_cfg.save
        traces << {:tag=>fn_tag,:msg=>"@locked_cfg",:data=>locked_cfg }

        traces << {:tag=>fn_tag,:msg=>"@locked_cfg.id",:data=>locked_cfg[:id] }

        product_detail[:cms_content_product_details_lockcfg_id]=locked_cfg[:id]
      #  product_detail.save
        traces << {:tag=>fn_tag,:msg=>"@cms_content_product_detail",:data=>product_detail }
       # logger.info("on_save_records @cms_content_product_details.save #{product_detail.to_json} ")
      end
    end


  end


end