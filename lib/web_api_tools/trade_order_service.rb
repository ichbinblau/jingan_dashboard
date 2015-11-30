# encoding: utf-8
class WebApiTools::TradeOrderService
  # To change this template use File | Settings | File Templates.
  T = WebApiTools::ApiCallHelper

  #加载
  attr_accessor  :params, :user_info_id,:project_info_id

  #save
  attr_accessor :act_buy_order, :act_buy_order_log, :cms_content_product_details

  #context
  attr_accessor :product_contents, :product_items, :cms_sort, :project_info, :errors, :traces,:logger

  def initialize(dic)
    #@project_info_id, @params,  @user_info_id,@traces = project_info_id, params, user_info_id ,traces||[]
    @logger =Rails.logger
    dic.each_pair do |key,value |
      #instance_variable_defined?
      sym_key ="@#{key}".to_sym
      instance_variable_set(sym_key,value)
    end

      #params,user_info_id,project_info_id,traces=[]
    #user_entity.user_info_id
    #user_entity.project_info_id
    #exec_entity[:traces]
  end


  #def initialize(params)
  #  @params =params
  #  @traces=[]
  #  @logger =Rails.logger
  #end


protected


public

  def save_records( &block)
    fn_tag = "save_records"

    #logger.info("save_records block.nil #{block.nil?}")
    #arg ={}
    #block.call arg
    #return block.nil?

    ######################################
    arg = {:key => :act_buy_order, :data => act_buy_order, :before => true}
    on_save_records(arg,&block)
    yield arg   unless block.nil?
    @act_buy_order.save

    traces << {:tag=>fn_tag,:msg=>"@act_buy_order.save. id=#{@act_buy_order[:id]}"  }
    arg[:before]=false
    on_save_records(arg,&block)
    yield arg   unless block.nil?
    ######################################
    @act_buy_order_log[:act_buy_order_id] = @act_buy_order[:id]

    arg = {:key => :act_buy_order_log, :data => act_buy_order_log, :before => true}
    on_save_records(arg,&block)
    yield arg   unless block.nil?
    @act_buy_order_log.save
    traces << {:tag=>fn_tag,:msg=>"@act_buy_order_log.save. id=#{@act_buy_order_log[:id]}"  }
    arg[:before]=false
    on_save_records(arg,&block)
    yield arg   unless block.nil?

    ######################################

    arg = {:key => :cms_content_product_details, :data => @cms_content_product_details, :before => true}


    traces << {:tag=>fn_tag,:msg=>"@cms_content_product_details_item.save. before:true"  }
    on_save_records(arg,&block)

    yield arg   unless block.nil?
    @cms_content_product_details.each do |item|
      item[:act_buy_order_id]= @act_buy_order[:id]
      item.save
      traces << {:tag=>fn_tag,:msg=>"@cms_content_product_details_item.save. id=#{item[:id]}"  }
    end
    arg[:before]=false
    traces << {:tag=>fn_tag,:msg=>"@cms_content_product_details_item.save. before:false"  }
    on_save_records(arg,&block)
    yield arg   unless block.nil?
    ######################################

  end

  def valid_records()
    @errors=[] if @errors.nil?

    if act_buy_order[:check_time]< Date.current
      @errors << {:error_num => ERROR_CODE_VALID_FAILS, :error_msg => "订单时间必须大于当天 "}
    end
    @errors.length==0
  end

  #构建加载记录数据
  def builder_records()
    #exec_entity, params, user_entity, api_entity
    #call_api_by_url(url_value, params, user_entity, api_entity=nil, exec_entity=nil)
    #T.wade_orders_add_lock_order(exec_entity, params, user_entity, api_entity)
    #产品的类型 1：产品带属性（酒店）带时间 2：产品带属性不带时间（京东）3：产品部带属性（蒂丽雪斯（走原来的接口））

=begin 修改说明
1.删除
  a.locked_items = params[:locked_items]说明上取消  新加 product_items
2.增加
  a.params[:product_items] => json []
  b.params[:must_price]
3.修改
  a.from price =>  params[:product_price]
=end

    #@errors = exec_entity[:errors]
    #user_info_id = user_entity.user_info_id
    #project_info_id = user_entity.project_info_id


    title= params[:title]
    product_items= params[:product_items]
    default_date =Date.parse("1991-01-01")
    extended_json = params[:extended_json]
    content_id = params[:cms_content_id]
    sort_id=params[:sort_id].to_i
    product_type = params[:product_type]
    payment_type= params[:payment_type].to_i
    send_type= params[:send_type].to_i
    user_consignee_id = params[:user_consignee_id].to_i
    fare_price=T.to_f(params[:fare_price], 0)
    product_price=T.to_f(params[:product_price])
    must_price =T.to_f(params[:must_price])
    remarks = params[:remarks]||''
    act_status_type_id= params[:act_status_type_id]
    user_name= params[:user_name]||''
    phone = params[:phone]||''
    people_num = params[:people_num].to_i
    about_time=T.to_time(params[:about_time], default_date)
    check_time=T.to_date(params[:check_time], default_date)
    departure_time = T.to_time(params[:departure_time], default_date)
    product_num = params[:product_num].to_i



#    product_items = '[
#    { "product_id":14182, "price_id":1 , "num":1,"price":null },
#    { "product_id":14182, "price_id":2 , "num":1,"price":null },
#    { "product_id":14182, "price_id":3 , "num":1,"price":null }
#]'

    case product_items
      when String
        product_items= T.json_parse(product_items)
    end
    @product_items= product_items

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

    #check_time = Date.parse('2013-10-20')
    #user_info_id = 7
    #project_info_id=78
    #sort_id= 529
    #payment_type=4
    #send_type=2
    #act_status_type_id = 4
    #price=50


    #这里要对产品价格唯一性处理 暂时没做 相同产品相同价格 数量

    #catch :valid_error do



    @cms_sort = sort_M = CmsSort.find(sort_id)  unless sort_id.blank?

    @project_info= ProjectInfo.find(project_info_id)

    #查找提交过来的产品信息
    @product_contents = T.get_product_contents_by_buy(product_items)

    #计算产品总价格 产品总数
    if   product_price.nil? || product_num.nil?
      total_money, total_product=0, 0
      product_contents.each_index do |buy_index|
        buy_product_content, product_item =product_contents[buy_index], product_items[buy_index]

        product_id, price_id, num, product_item_price = product_item[:product_id], product_item[:price_id], product_item[:num], product_item[:product_price]
        product_info, product_price_info =buy_product_content[:cms_info_product], buy_product_content[:cms_info_product_price]
        product_item_price = product_price_info[:price]||product_item_price
        total_money+=(product_item_price*num)
        total_product+=num
      end

      product_price = total_money if product_price.nil?
      product_num=total_product if product_num.nil?
    end

    #因为可以是多个产品 所以兼容以前 取第一个
    cms_content_id = product_items[0][:product_id] if product_items.length!=0

    logger.info("cms_content_id=>#{cms_content_id}  check_time=#{check_time}")

    #ActiveRecord::Base.transaction do   end
    @act_buy_order = buy_order_M = ActBuyOrder.new
    buy_order_M[:created_at]=Time.now
    buy_order_M[:user_info_id]= user_info_id
    buy_order_M[:project_companie_id]= project_info[:project_companie_id]
    buy_order_M[:project_info_id]= project_info_id
    buy_order_M[:act_status_type_id] = act_status_type_id # 2:购物车状态,3:等待确认收货地址,4:等待支付,5:支付完成,6:货已送达
    buy_order_M[:payment_type]=payment_type
    buy_order_M[:send_type]=send_type
    buy_order_M[:user_consignee_id]=user_consignee_id
    buy_order_M[:product_price] = product_price
    buy_order_M[:fare_price]= fare_price||0 #运费金额
    buy_order_M[:must_price] =must_price||product_price #应付
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
    buy_order_M[:cms_content_id]=cms_content_id
    buy_order_M[:title]=title
    buy_order_M[:cms_sort_id]= sort_id

    logger.info("buy_order_M=>#{buy_order_M.to_json}    cms_content_id=#{cms_content_id}")


    @act_buy_order_log = buy_order_log_M = ActBuyOrderLog.new
    buy_order_log_M.attr_copy(buy_order_M)



    @cms_content_product_details = []
    #设置
    product_contents.each_index do |buy_index|

      buy_product_content, product_item =product_contents[buy_index], product_items[buy_index]

      product_id, price_id, num, product_item_price = product_item[:product_id], product_item[:price_id], product_item[:num], product_item[:product_price]

      product_info, product_price_info =buy_product_content[:cms_info_product], buy_product_content[:cms_info_product_price]
      logger.info("product_contents_each_index index=#{buy_index}  #{product_price_info.to_json}")
      product_item_price = product_price_info[:price]||product_item_price

      product_detail_M = CmsContentProductDetail.new
      .attr_copy(:cms_content => buy_product_content, :cms_info_product => product_info, :act_buy_order => buy_order_M,:cms_info_product_price=> product_price_info )
      product_detail_M[:price]=product_item_price
      @cms_content_product_details << product_detail_M
    end

    self

  end

  def show
    @id=9

    id=7
    [@id, id]

  end

  protected

  def on_save_records(p,&block)

  end


end
