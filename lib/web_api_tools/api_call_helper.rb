# encoding: utf-8
class WebApiTools::ApiVersionEntity
  attr_accessor :sub_version, :main_version, :api_web_info, :api_web_info_version, :api_version, :api_resources, :url_value
end

class WebApiTools::OauthUserEntity
  attr_accessor :device_id, :project_info_id, :project_app_id, :user_info_id, :access_token

  def initialize(access_token=nil)
    @access_token =access_token

  end

end


class WebApiTools::ApiCallHelper
#  include "error_define"

  T =self


  # static declare
  @@eval_delegates_cache = Hash.new
  @@global_count = 0


  # static method
  class << self

    def create_exec_entity(is_trace=false)
      {:traces => [], :debugs => [], :errors => [], :is_trace => is_trace}
    end

    def url_parse_api_info(url_value, params)
      # data 返回值
      # user=>  project_info_id user_info_id project_app_id  token device_id
      #return error, entity
      f = params
      version_match= /^[\d]+[\w.]+/.match(url_value)

      if version_match.length>0
        apiVersion = version_match[0]
        apiMethod = url_value[(apiVersion.length+1)..url_value.length]
      elsif !f.nil?
        apiVersion = f[:version] unless f[:version].nil?
        apiMethod = f[:method]|| url_value
      else
        return "未找到api,url:null"
      end


      apiM = ApiWebInfo.where("uri_resource=?  ", apiMethod.gsub(".", "/")).first

      return "未找到api,url:#{apiMethod}", nil, apiVersion, apiMethod if apiM.nil?

      main_version = /^\d+\.\d+/.match(apiVersion)[0]
      sub_version = apiVersion == sub_version ? '' : (apiVersion[main_version.length+1 .. apiVersion.length]||'')
      apiVersionModels = apiM.api_web_info_versions

      apiVersionM = apiVersionModels.find { |vm| vm.main_version ==Float(main_version) && vm.sub_version == sub_version }
      #缺省版本
      apiVersionM = apiVersionModels.find { |vm| vm.main_version == Float(main_version) && vm.is_default_version } if apiVersionM.nil?

      return "没有合适版本api可以使用主版本：#{main_version}  子版本:#{sub_version}", nil, apiVersion, apiMethod if apiVersionM.nil?

      # :sub_version,:main_version,:api_web_info,:api_web_info_version,:api_version,:api_resources,:url_value
      entity = WebApiTools::ApiVersionEntity.new
      entity.api_web_info, entity.api_web_info_version, entity.main_version, entity.sub_version, entity.api_version, entity.api_resources, entity.url_value = apiM, apiVersionM, main_version, sub_version, apiVersion, apiMethod, url_value

      return nil, entity, apiVersion, apiMethod
    end


    def call_api_by_entity(exec_entity, params, user_entity, api_entity)
      logger = Rails.logger

      exec_entity = create_exec_entity if exec_entity.nil?
      fn, p, data = get_fn_from_api_version(api_entity.api_web_info_version), params, nil

      if !fn.nil?
        data = fn.call(exec_entity, params, user_entity, api_entity)
        #exec_entity[:result] = data  if !exec_entity.nil? && !exec_entity.has_key?("result")
        logger.info("call_api_by_entity=>fn_call: result is null?   #{data.nil?}")

        call_api_by_parent_id(api_entity.api_web_info.id, data, user_entity, exec_entity)

      else
        logger.info("call_api_by_entity=>fn:null")
      end
      data
    end


    def call_api_by_url(url_value, params, user_entity, api_entity=nil, exec_entity=nil)
      logger = Rails.logger

      exec_entity = create_exec_entity if exec_entity.nil?

      if api_entity.nil?
        errorMsg, api_entity, apiVersion, apiMethod = url_parse_api_info(url_value, params)
        raise errorMsg unless errorMsg.nil?
      end

      fn, p = get_fn_from_api_version(api_entity.api_web_info_version), params

      if !fn.nil?
        data = fn.call(exec_entity, params, user_entity, api_entity)
        logger.info("call_api_by_url=>fn_call:  url:#{url_value}")
      else
        logger.info("call_api_by_url=>fn:null   url:#{url_value}")
      end

      return data, api_entity, apiVersion, apiMethod
    end


    def call_api_by_parent_id (parent_api_id, params, user_entity, exec_entity, depth = 0)

      logger = Rails.logger

      ApiWebInfoTrigger.where("api_web_info_id=? and enabled=1", parent_api_id).each do |r|

        if r[:project_info_id] == user_entity.project_info_id
          logger.info("call_api_by_parent_id=>url:#{r.call_url} process:true ")

          data, api_entity = call_api_by_url(r.call_url, params, user_entity, nil, exec_entity)

          # 测试
          #  send_uri_task_by_config( {:name=> 'current_user_222222'},user_entity,api_entity)
          raise "调用超过最大次数#{depth }" if  depth>20

          call_api_by_parent_id(api_entity.api_web_info.id, data, user_entity, exec_entity, depth=+1)
        end
        logger.info("call_api_by_parent_id=>url:#{r.call_url} process:false ")


      end

    end


    def generation_sign apiKey, callId, method, apiSecret
      str = "api_key=#{apiKey}call_id=#{callId}method=#{method}#{apiSecret}"
      Digest::MD5.hexdigest(str)
      #logger.debug("generation_sign=> str: #{str}  md5: #{md5_value} ")
      #md5_value
    end


    def now
      Time.now
    end

    def db_exec(sql_text)
      ActiveRecord::Base.connection.execute(sql_text)
    end


    protected

    def get_fn_from_api_version(api_web_info_version)
      logger, tag, fn = Rails.logger, "get_fn_from_api_version", nil
      logger.info("get_fn_from_api_version=>@@eval_delegates_cache length: "+@@eval_delegates_cache.length.to_s)

      cache_key = api_web_info_version.id.to_s

      #logger.info("#{tag}=>cache_key:#{cache_key} ")

      cache_Object = @@eval_delegates_cache[cache_key] if  @@eval_delegates_cache.has_key?(cache_key)

      is_change = cache_Object.nil? || cache_Object[:updated_at]!= api_web_info_version[:updated_at]

      logger.debug("get_fn_from_api_version=>is_change:#{is_change}  key=#{cache_key} update_at:#{api_web_info_version[:updated_at]}")

      if is_change
        cache_Object ={}
        #logger.debug("process_handler=> mysql-bit:"+ api_web_info_version.is_handler_eval.class.name)
        #{apiModel.is_handler_delegate}

        if api_web_info_version.is_handler_eval
          logger.info("#{tag}=>create_eval_fn: ")
          #fn.call(exec_entity, params, user_entity, api_entity)
          script =" fn = Proc.new {|exec_entity,params,user_entity,api_entity|
                #{api_web_info_version.handler_eval}
           }"
          logger.info("#{tag}=>eval_script:? ")

          eval script


          logger.info("#{tag}=>++@@global_count: #{(++@@global_count)}")
        elsif api_web_info_version.is_handler_delegate == true
          #反射 调用模块方法
        end

        if !fn.nil?
          cache_Object[:updated_at], cache_Object[:fn]= api_web_info_version[:updated_at], fn

          @@eval_delegates_cache[cache_key] = cache_Object

          logger.info("@@eval_delegates_cache length: "+@@eval_delegates_cache.length.to_s)
        else
          logger.debug("#{tag}=>is_change.fn:null")
        end

      else
        fn= cache_Object[:fn]
      end

      return fn
    end


    # sendToHttp
    # sendToSortPlugins

    public

    def send_uri_task_by_config (params, user_entity, api_entity)

      logger = Rails.logger
      logger.info "send_uri_task_by_config=>api_entity:" +api_entity.to_json


      task = WebApiTools::UriPushTask.new
      task.load_uri_config(:api_uri_call_config_id => 1)
      .each { |item| item.params=params }
      .save_job { |job, item|
        job[:api_web_info_id]= api_entity.api_web_info.id
        job[:api_web_info_version_id]= api_entity.api_web_info_version.id
        job[:project_info_id] = user_entity.project_info_id
        job[:user_info_id] = user_entity.user_info_id
      }
      .send_task

      #表单 和当前项目
      #查看下温馨配置
      #uri = URI(toUrl)
      #res = Net::HTTP.post_form(uri, form_data)
    end


    public


    def get_time


      Time.now
    end


    # Util_API

    def get_locked_keys
      s_keys = []
      0.upto 4 do |n|
        s_keys << "p_#{n}".to_sym
      end
      s_keys

    end

    def get_locked_item_uni_key(item)
      get_locked_keys.map { |key| "#{key}=#{item[key]||0}" }.join('|')
    end


    def find_CmsContentProductDetailsLockcfgs(content_id, date, locked_items=nil)
      #锁定（过滤）说明 s

      #locked_items =  JSON.parse =>[]
      #  set  append_where
      if !locked_items.nil? && locked_items.length!=0
        locked_p_items, keys, row_buf=[], get_locked_keys, []
        locked_items.each do |item|
          row_buf.clear
          keys.each do |key|
            #value = item.include?(key) ? (item[key]||0) : 0
            value =  (item[key]||0)
            row_buf << " #{key}=#{value} "
          end
          locked_p_items << "(#{row_buf.join(' AND ')} )"
        end
        append_where =" AND (#{locked_p_items.join(' OR ') })"
      else
        append_where =""
      end

      lock_items = CmsContentProductDetailsLockcfg.where("cms_content_id =:content_id  and ( ((end_date is null  and date=:date) or (:date between `date` and `end_date` ))  #{append_where} )", :content_id => content_id, :date => date)

    end


    def to_date(input, default_value=nil)


      if input.blank?
        return (default_value.nil?) ? nil : default_value
      end

      case input
        when String
          Date.parse input
        when Date
          input
        when Time
          Date.parse(input.strftime('%Y-%m-%d'))
        else
          default_value
      end
    end


    def to_f(input, default_value=nil)

      if input.blank?
        return (default_value.nil?) ? nil : default_value
      end

      case input
        when Float
          input
        when String
          input.to_f
        when BigDecimal
          input.to_f
        else
          default_value
      end

    end

    def to_i(input,default_value=nil)
      if input.blank?
        return (default_value.nil?) ? nil : default_value
      end
      case input
        when Integer
          input
        else
          input.to_i
      end
    end


    def json_parse(value)
      JSON.parse(value, {:symbolize_names => true})
    end

    def to_time(input, default_value=nil)

      if input.blank?
        return (default_value.nil?) ? nil : default_value
      end

      case input
        when String
          Time.parse(input)
        when Date
          input.to_datetime
        when Time
          input
        else
          default_value
      end

    end


    #从购买信息中获取产品内容的信息
    def get_product_contents_by_buy(buy_items)
      logger =Rails.logger
      fn_tag = "get_product_contents_by_buy"
      buy_items.map do |buy_item|
        # product_id,price_id,num,price = buy_item[:product_id],buy_item[:price_id],buy_item[:num],buy_item[:price]
        product_id, price_id= buy_item[:product_id], buy_item[:price_id]
        product_content_M = ProductContent.find(product_id)
        logger.info("#{fn_tag} #{product_content_M.to_json}")


        product_content_M[:cms_info_product]= product_content_M.cms_info_product

        product_content_M[:cms_info_product_price] = CmsInfoProductPrice.where("cms_content_id=?  and id=?", product_id, price_id).first
        product_content_M
      end
    end


    def find_locked_CmsContentProductDetails_by_created_source(price_item, locked_items, locked_mode=1,created_source=0)
      #created_source=0 用户  created_source=1 管理者
      #locked_items= table => cms_content_product_details_lockcfgs
      price_uni_key = T.get_locked_item_uni_key(price_item)
      data = []
      if locked_mode == 1
        locked_items.each do |item|
          if item[:created_source]==created_source #用户订单创建
            item_uni_key = T.get_locked_item_uni_key(item)
            data<<item if (price_uni_key==price_uni_key)
          end
        end
      elsif  locked_mode == 2
        locked_items.each do |item|
          data<<item  if item[:created_source]==created_source
        end
      end
      data
    end




    def product_is_locked_by_buy(buy_items, locked_items, locked_mode=1)

      #filters = lock_items.select do  |lock_item|
      #  #created_source=0   用户创建        =1管理员创建
      #  #用户创建需要管理锁定  管理员不锁定
      #  created_source == 1 || (created_source == 0 &&  (lock_item[:order_limit]-lock_item[:order_now])<=0)
      #  #locked  需要详细判断
      #locked_mode=1 判断价格属性  2=产品内容
      #buy_items={:cms_info_product_price:,:num}  x
      #locked_items=> table=>  cms_content_product_details_lockcfgs
      logger = Rails.logger
      fn_tag = "product_is_locked_by_buy"
      error= nil
      catch :valid_error do

        logger.info("#{fn_tag}  :buy_items.length:#{buy_items.length}  locked_items.length:#{locked_items.length} locked_mode:#{locked_mode}")

        buy_items.each do |exists_record|

          logger.info("#{fn_tag}  buy_items.each")

          price_record, num = exists_record[:cms_info_product_price], exists_record[:num]

          if locked_mode==1
            exists_record_key = T.get_locked_item_uni_key(price_record)
            logger.info("#{fn_tag}:  lock_record_key=#{lock_record_key} ")


          end

          locked_items.each do |locked_record|
            if locked_mode==1
               lock_record_key = T.get_locked_item_uni_key(exists_record)
               next if lock_record_key != exists_record_key
            end

            if  locked_record[:locked]
              error = {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "产品被锁定，无法售卖"}
              throw :valid_error
              els

              locked_value = locked_record[:order_limit] - locked_record[:order_now]-num
              logger.info("#{fn_tag}  locked_value:#{locked_value} order_limit:#{locked_record[:order_limit]} order_now#{locked_record[:order_now]} num:#{num}")

              if locked_value< 0 #先前检验过了
                error= {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "产品剩余数量不足"}
                throw :valid_error
              end
            end

          end
        end
      end
      error
    end


    ##############################test begin###################################### #
    def find_ProductContent(content_id)
      item = ProductContent.find(content_id).load_record_relations
    end

    def find_ProductContent_2(content_id)

      shop_id = 13502
      items = ProductContent
      .joins("inner join product_contents_shop_contents b on cms_contents.id=b.product_content_id ")
      .where("b.`shop_content_id` =? ", shop_id).order("id").each { |content_item| content_item.load_record_relations }
    end


    def find_CmsInfoCoupon(content_id)
      item = CouponContent.find(content_id)
      item[:cms_info_coupon]= item.cms_info_coupon
      item[:cms_sorts]= item.cms_sorts

=begin
#item = CmsInfoCoupon.where(:cms_content_id => content_id).first
      #item[:content_info]= item.cms_content
      #item[:sorts] = item.cms_sorts
      item[:product_info]= item.cms_info_product
      item[:sorts]= item.cms_contents_cms_sorts.includes(:cms_sort).each do |r_sort_item|
        r_sort_item[:sort_info]=r_sort_item.cms_sort
      end
=end
      item
    end


    def wade_orders_add_lock_order (exec_entity, params, user_entity, api_entity)

      #call_api_by_url(url_value, params, user_entity, api_entity=nil, exec_entity=nil)
      #T.wade_orders_add_lock_order(exec_entity, params, user_entity, api_entity)
      #产品的类型 1：产品带属性（酒店）带时间 2：产品带属性不带时间（京东）3：产品部带属性（蒂丽雪斯（走原来的接口））

=begin 修改说明
1.删除
  a.locked_items = params[:locked_items]说明上取消  新加 product_items
  b.params[:price]
2.增加
  a.params[:product_items]
  b.params[:must_price]
=end

      errors = exec_entity[:errors]
      user_info_id = user_entity.user_info_id
      project_info_id = user_entity.project_info_id


      logger=Rails.logger
      default_date =Date.parse("1991-01-01")
      extended_json = params[:extended_json]

      product_items =params[:product_items]

      content_id = params[:cms_content_id]
      sort_id=params[:sort_id].to_i
      product_type = params[:product_type]
      payment_type= params[:payment_type].to_i
      send_type= params[:send_type].to_i
      user_consignee_id = params[:user_consignee_id].to_i
      fare_price=T.to_f(params[:fare_price])
      product_price=T.to_f(params[:product_price])
      must_price =T.to_f(params[:must_price])

      remarks = params[:remarks]||''
      product_num = params[:product_num].to_i
      act_status_type_id= params[:act_status_type_id]
      user_name= params[:user_name]||''
      phone = params[:phone]||''
      people_num = params[:people_num].to_i
      about_time=T.to_time(params[:about_time], default_date)
      check_time=T.to_date(params[:check_time], default_date)
      departure_time = T.to_time(params[:departure_time], default_date)

      success=false
      buy_order_M=nil


=begin
检查锁定
1.产品标识——单个
2.属性检索—— 多属性组合 检索

添加锁定
1.给价格 id * 数量
2.复制价格 id 的 p_0-p_n的属性到锁定表

锁定模式判断  locked_mode=[]
is_locked_product_attr
is_locked_product
1.产品——是属性锁定   相同产品多条锁定记录
2.产品——非属性锁定
=end
      #锁定模式

      locked_modes=[1]

      errors = []
      check_time = Date.parse('2013-10-20')
      user_info_id = 7
      project_info_id=78
      content_id =14182
      sort_id= 529
      payment_type=4
      send_type=2
      act_status_type_id = 4
      price=50

      #[price_id=1 , num=1 ]
      product_items = '[
    { "product_id":14182, "price_id":1 , "num":1,"price":null },
    { "product_id":14182, "price_id":2 , "num":1,"price":null },
    { "product_id":14182, "price_id":3 , "num":1,"price":null }
]'

      case product_items
        when String
          product_items= T.json_parse(product_items)
      end


      #这里要对产品价格唯一性处理 暂时没做 相同产品相同价格 数量

      catch :valid_error do

        if check_time< Date.current
          errors << {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "订单时间必须大于当天 "}
          throw :valid_error
        end

        if locked_modes.include? 1
          current_locked_mode = 1

          if !locked_items.blank?
            case locked_items
              when String
                locked_items = T.json_parse(locked_items)
            end
            if   locked_items.length == 0
              errors << {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "锁定的项目集合数量必须大于0"}
              throw :valid_error
            end
          else
            errors << {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "必须有锁定的项目"}
            throw :valid_error
          end
        end

        sort_M = CmsSort.find(sort_id)

        content_info= ProductContent.find(content_id)
        project_info_id = content_info[:project_info_id]
        project_info = ProjectInfo.find(project_info_id)


        #锁定（过滤）说明 s
        #filters = lock_items.select do  |lock_item|
        #  #created_source=0   用户创建        =1管理员创建
        #  #用户创建需要管理锁定  管理员不锁定
        #  created_source == 1 || (created_source == 0 &&  (lock_item[:order_limit]-lock_item[:order_now])<=0)
        #  #locked  需要详细判断


        #查找锁定信息
        filters = T.find_CmsContentProductDetailsLockcfgs(content_id, check_time, locked_items)

        #查找提交过来的产品信息
        product_contents = T.get_product_contents_by_buy(product_items)

        #验证锁定 begin


        valid_items =[]
        product_contents.each_index do |buy_index|
          buy_product_content, product_item =product_contents[buy_index], product_items[buy_index]

          valid_items << {:num => product_item[:num], :cms_info_product_price => buy_product_content[:cms_info_product_price]}
        end

        valid_error = T.product_is_locked_by_buy(valid_items, filters, current_locked_mode)
        if !valid_error.nil?
          errors << valid_error
          throw :valid_error
        end

        #计算产品总价格
        if product_price.nil?
          total_money=0
          product_contents.each_index do |buy_index|
            buy_product_content, product_item =product_contents[buy_index], product_items[buy_index]
            product_id, price_id, num, product_item_price = product_item[:product_id], product_item[:price_id], product_item[:num], product_item[:product_price]
            product_info, product_price_info =buy_product_content[:cms_info_product], buy_product_content[:cms_info_product_price]

            product_item_price = product_price_info[:price]||product_item_price
            total_money+=(product_item_price*num)
          end
          product_price = total_money
        end


        buy_order_M = ActBuyOrder.new
        buy_order_M[:created_at]=Time.now
        buy_order_M[:user_info_id]= user_info_id
        buy_order_M[:project_companie_id]= project_info[:project_companie_id]
        buy_order_M[:project_info_id]= project_info_id
        buy_order_M[:act_status_type_id] = act_status_type_id # 2:购物车状态,3:等待确认收货地址,4:等待支付,5:支付完成,6:货已送达
        buy_order_M[:payment_type]=payment_type
        buy_order_M[:send_type]=send_type
        buy_order_M[:user_consignee_id]=user_consignee_id

        #product_price
        buy_order_M[:product_price] = product_price
        #运费金额
        buy_order_M[:fare_price]= fare_price

        buy_order_M[:must_price] =must_price
        buy_order_M[:people_num] = people_num
        buy_order_M[:about_time]=about_time
        buy_order_M[:check_time]=check_time
        buy_order_M[:cms_content_id]= content_id
        buy_order_M[:product_num]= product_num
        buy_order_M[:order_number]= Random.rand(2147483648)

        buy_order_M[:remarks]=remarks
        buy_order_M[:departure_time]=departure_time
        buy_order_M[:user_name]=user_name
        buy_order_M[:phone]=phone
        buy_order_M[:json_property]=extended_json ||''
        buy_order_M.save

        buy_order_log_M = ActBuyOrderLog.new
        buy_order_log_M[:project_info_id]=project_info_id
        buy_order_log_M.attr_copy(buy_order_M)
        buy_order_log_M.save

        locked_records, product_detail_records = [], []

        #设置
        product_contents.each_index do |buy_index|

          buy_product_content, product_item =product_contents[buy_index], product_items[buy_index]

          product_id, price_id, num, product_item_price = product_item[:product_id], product_item[:price_id], product_item[:num], product_item[:product_price]

          product_info, product_price_info =buy_product_content[:cms_info_product], buy_product_content[:cms_info_product_price]

          product_item_price = product_price_info[:price]||product_item_price

          #产生锁定 以及产品信息 这里不保存  最后保存
          #判断锁定信息是否存在，存在的话更新 否则 添加
          #设置 锁定信息 begin
          user_locked_records = T.find_user_locked_CmsContentProductDetails(product_price_info, filters, current_locked_mode)
          locked_M= nil
          if user_locked_records.nil? || user_locked_records.length==0
            locked_M = CmsContentProductDetailsLockcfg.new
            locked_M[:cms_content_id]= product_id
            locked_M[:order_now]=0
            locked_M[:date]=check_time
            locked_M[:json_property]=extended_json||''
            locked_M[:cms_sort_id]= sort_M.id
            locked_M[:order_limit]= sort_M[:order_limit]
            locked_M[:order_now]=lock_M[:order_now]+num
            locked_M[:locked]=0
            #elsif  user_locked_records.length>1
            #  errors << {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "用户设置的锁定有效信息条数>1,无法找到需要修改的目标"}
            #  throw :valid_error
          else
            locked_M = user_locked_records[0]
          end

          locked_value = value = locked_M[:order_limit] - locked_M[:order_now]
          if locked_value< 0 #先前检验过了
            errors << {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "产品剩余数量不足"}
            throw :valid_error
          else
            if locked_value==0
              lock_M[:locked]=1
            end
            #设置 锁定信息 end

            #lock_M.save
            product_detail_M = CmsContentProductDetail.new
            .attr_copy(:cms_content => buy_product_content, :cms_info_product => product_info, :act_buy_order => buy_order_M,
                       :cms_content_product_details_lockcfg => locked_M)
            product_detail_M[:price]=product_item_price

            product_detail_M.save
          end

        end
        success= true

      end

      data = {:success => success, :buy_order_id => (buy_order_M.nil?) ? nil : buy_order_M.id}


      render :json => data

    end


    def wade_orders_add_option_order(exec_entity, params, user_entity, api_entity)

      #产品的类型 1：产品带属性（酒店）带时间 2：产品带属性不带时间（京东）3：产品部带属性（蒂丽雪斯（走原来的接口））
      default_date =Date.parse("1991-01-01")

      user_info_id = user_entity.user_info_id
      locked_json = params[:locked_json]
      content_id = params[:cms_content_id]
      sort_id=params[:sort_id].to_i
      product_type = params[:product_type]
      payment_type= params[:payment_type].to_i
      send_type= params[:send_type].to_i
      user_consignee_id = params[:user_consignee_id].to_i
      fare_price=params[:fare_price].to_i
      ##需要修改

      price =T.to_f(params[:price])

      remarks = params[:remarks]||''
      product_num = params[:product_num].to_i
      act_status_type_id= params[:act_status_type_id]
      user_name= params[:user_name]||''
      phone = params[:phone]||''
      people_num = params[:people_num].to_i
      about_time=T.to_time(params[:about_time], default_date)
      check_time=T.to_date(params[:check_time], default_date)
      departure_time = T.to_time(params[:departure_time], default_date)

      success=false
      buy_order_M=nil

#
#    check_time = Date.parse( '2013-9-27')
#    user_info_id = 7
#    project_info_id=78
#    content_id =14182
#    sort_id=  529
#    payment_type=4
#    send_type=2
#    act_status_type_id = 4
#
#
#    locked_json= '[{
#    "time_id":"886",
#    "area_id":"890",
#    "time_title":"",
#    "area_title":"",
#    "people_id":"",
#    "people_name":""
#},{
#    "time_id":"886",
#    "area_id":"904",
#    "time_title":"",
#    "area_title":"",
#    "people_id":"",
#    "people_name":""
#}]'
      catch :valid_error do


        if check_time< Date.current
          exec_entity[:errors] << {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "订单时间必须大于当天 "}
          throw :valid_error
        end


        sort_M = CmsSort.find(sort_id)


        lock_infos=JSON.parse(locked_json) if !locked_json.blank?
        coupon_item = CmsInfoCoupon.includes(:cms_content, :cms_info_product, :cms_contents_cms_sorts).where("cms_content_id =? ", content_id).first

        content_info= coupon_item.cms_content
        product_info= coupon_item.cms_info_product
        project_info_id = content_info[:project_info_id]
        project_info = ProjectInfo.find(project_info_id)

        ##查询 locks
        #filters = T.find_CmsContentProductDetailsLockcfgs(content_id, check_time).each do |item|
        #
        #  record = nil
        #  record = JSON.parse(item[:json_property]) if !item[:json_property].blank?
        #  if  (!item[:end_date].nil? && check_time<=item[:end_date] && item[:locked]==1) || (item[:date]==check_time && item[:locked]==1)
        #    exec_entity[:errors] << {:error_num=> ERROR_CODE_VALID_FAILS, :error_msg=>"product is locked" }
        #    throw :valid_error
        #  end
        #
        #
        #  logger.info("lock_test:  begin  ")
        #  unless record.nil?
        #    lock_infos.each do |lock_record|
        #      record.each do |exists_record|
        #        if  lock_record['time_id'].to_s ==exists_record['time_id'].to_s && lock_record['area_id'].to_s ==exists_record['area_id'].to_s
        #          exec_entity[:errors] <<  {:error_num=> ERROR_CODE_VALID_FAILS, :error_msg=>"product is locked " }
        #          throw :valid_error
        #        end
        #
        #      end
        #
        #      logger.info("lock_test:  lock_record :#{lock_record['time_id']}  ")
        #    end
        #
        #  end
        #
        #  logger.info("lock_test:  end  ")
        #
        #end

        if  price.blank?
          price = product_info[:price]
        elsif  price < 0
          raise "价格不能小于0"
        end

        real_money =price *product_num

        buy_order_M = ActBuyOrder.new
        buy_order_M[:created_at]=Time.now
        buy_order_M[:user_info_id]= user_info_id
        buy_order_M[:project_companie_id]= project_info[:project_companie_id]
        buy_order_M[:project_info_id]= project_info_id
        buy_order_M[:act_status_type_id] = act_status_type_id # 2:购物车状态,3:等待确认收货地址,4:等待支付,5:支付完成,6:货已送达
        buy_order_M[:payment_type]=payment_type
        buy_order_M[:send_type]=send_type
        buy_order_M[:user_consignee_id]=user_consignee_id
        buy_order_M[:product_price] = real_money
        buy_order_M[:fare_price]= fare_price
        buy_order_M[:must_price] =real_money-fare_price
        buy_order_M[:people_num] = people_num
        buy_order_M[:about_time]=about_time
        buy_order_M[:check_time]=check_time
        buy_order_M[:cms_content_id]= content_id
        buy_order_M[:product_num]= product_num
        buy_order_M[:order_number]= Random.rand(2147483648)
        buy_order_M[:remarks]=remarks
        buy_order_M[:departure_time]=departure_time
        buy_order_M[:user_name]=user_name
        buy_order_M[:phone]=phone
        buy_order_M.save


        lock_M = CmsContentProductDetailsLockcfg.new
        lock_M[:cms_content_id]= content_id
        lock_M[:locked]=1
        lock_M[:order_now]=1
        lock_M[:date]=Date.current
        lock_M[:json_property]=locked_json
        lock_M[:cms_sort_id]= sort_M.id
        lock_M[:order_limit]= sort_M[:order_limit]
        lock_M.save


        buy_order_log_M = ActBuyOrderLog.new
        buy_order_log_M[:project_info_id]=project_info_id
        buy_order_log_M.attr_copy(buy_order_M)
        buy_order_log_M.save

        product_detail_M = CmsContentProductDetail.new
        .attr_copy(:cms_content => content_info, :cms_info_product => product_info, :act_buy_order => buy_order_M)
        product_detail_M[:price]=price
        product_detail_M.save

        success= true
      end

      data = {:success => success, :buy_order_id => (buy_order_M.nil?) ? nil : buy_order_M.id}


    end


    #######################################################################

    #alias :old :new

    #def StaticMethod4
    #   "Test.StaticMethod4"
    #end

  end
end

class WebApiTools::MyClass


  def show

    @name=[Time.now] if @name.nil?
    @name
  end

end