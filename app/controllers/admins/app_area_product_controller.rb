# encoding: utf-8
class Admins::AppAreaProductController < ApplicationController
  before_filter:authenticate_admin_user!

  T= WebApiTools::ApiCallHelper

  def perpage
    20
  end


  def index
    app_module_info
    # 内容列表
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?
    sortids = @sort_id.to_s.split(",")
    sortsql = sortids.collect { |sortid| "tb#{sortid}.cms_sort_id!=0" }.join(" and ")
    search = " #{sortsql} and project_info_id = #{admin_info.project_info_id}"
    search += " and title like '%#{params[:words]}%'" if !params[:words].blank?
    joins = ""
    sortids.each do |sortid|
      joins += " left join cms_contents_cms_sorts tb#{sortid} on( cms_contents.id=tb#{sortid}.cms_content_id and tb#{sortid}.cms_sort_id='#{sortid}' ) "
    end
    # Rails.logger.info joins.inspect
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_items = ProductContent
                    .includes(:cms_info_product)
                    .joins(joins)
                    .where(search)
                    .order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupon_contents }
    end

  end

  def show
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ProductContent.includes(:cms_content_img).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def new
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ProductContent.new
    @content_item.project_info_id = admin_info.project_info_id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def edit
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ProductContent.includes(:cms_content_img).find(params[:id])
    @content_item.project_info_id = admin_info.project_info_id
    @content_id =params[:id]
  end

  def locked_create
    if params[:cms_content_id].blank?
      msg = "cms_content_id 不能为空"
    else
      r = CmsContentProductDetailsLockcfg.new
      # r.update_attributes(request.params)
      r[:created_source]= 1
      r[:cms_content_id]= params[:cms_content_id]
      r[:cms_sort_id]= params[:cms_sort_id]||0
      r[:p_0]= params[:p_0]
      r[:p_1]= params[:p_1]
      r[:date]= params[:date]
      r[:end_date]= params[:end_date]
      r[:locked]= params[:locked]||1
      r[:order_limit]= params[:order_limit]||0
      r[:order_now]= params[:order_now]||0

      logger.info(r.to_json)
      r.save
    end
    render :json => {:success => !r.nil?, :msg => msg}
  end

  def locked_items_by_date
    #:cms_content_id=>content_id,:locked=>1
    date = T.to_date(params[:date])
    cms_content_id = params[:id]

    expr = CmsContentProductDetailsLockcfg.where("locked=1 and  cms_content_id=:cms_content_id  and  ((date=:date) OR (:date between date and end_date)  )",
                                                 :cms_content_id => cms_content_id, :date => date)
    render :json => expr
  end

  def locked_index
    render :json => get_admin_locked_infos(params[:id])
  end

  def locked_update
    if params[:id].blank?
      msg = "id 不能为空"
    else
      r = CmsContentProductDetailsLockcfg.find(params[:id])
      if r.nil?
        msg = "记录不存在"
      else
        r[:p_0]= params[:p_0]
        r[:p_1]= params[:p_1]
        r[:date]= params[:date]
        r[:end_date]= params[:end_date]
        r[:locked]= params[:locked]
        #r.update_attributes(params)
        success =r.save
      end
    end
    render :json => {:success => success, :msg => msg}
  end

  def locked_destroy
    if params[:id].blank?
      msg = "id 不能为空"
    else
      r = CmsContentProductDetailsLockcfg.find(params[:id])
      if r.nil?
        msg = "记录不存在"
      else
        success= r.destroy
      end
    end
    render :json => {:success => success, :msg => msg}

  end


  def area_edit
    #items  = get_price_packages_config_data(params[:id])
    #logger.info("::get_price_packages_config_data::"+items.length.to_s)
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    logger.info @content_distitle.to_s
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    content_id =@content_id =params[:id]

    p_0, p_1 = get_price_config_data (content_id)
    @area_config ={:p_0 => p_0, :p_1 => p_1}
    @package_config = {:p_0 => get_price_packages_config_data(content_id)}

  end


  def price_packages_config_data
    sort_items = get_price_packages_config_data (params[:id])
    data ={:p_0 => sort_items}
    render :json => data
  end

  def price_data
    data =get_price_data(params[:id], params[:week_day])
    render :json => data
  end

  def price_packages_data
    render :json => get_price_packages_data(params[:id])
  end

  def price_config_data
    content_id = params[:id]
    p_0, p_1 = get_price_config_data (content_id)
    data ={:p_0 => p_0, :p_1 => p_1}
    render :json => data
  end

  def price_admin_locked_infos
    render :json => get_admin_locked_infos(params[id])
  end

  def price_admin_locked_save
    content_id=params[:id]
    data = T.json_parse(params[:data])
    buf = []
    data.each do |d|
      if d.id.nil?
        r = CmsContentProductDetailsLockcfg.new
        r[:cms_content_id]= content_id
        r[:created_source]= 1
      else
        r=CmsContentProductDetailsLockcfg.find(d.id)
      end
      r.update_attributes(d)
      buf << r
    end
    buf.each { |b| b.save }
    render :json => buf
  end

  #A.查询订单数据 游泳馆 场地   已支付、待支付、取消（用户取消、自动取消、管理员取消）

  #B.查询场地 预约状态 锁定情况
  #需求
  #1.列表显示 检索已锁定信息(管理员设置和预约锁定 )
  #2.点击预定详细
  #   显示订单列表  查询条件-日期 状态（已支付） 产品标识  分类（p_0,p_1）
  #3.点击锁定详细 设置锁定信息
  #约束
  #1.指定日期
  #2.场地(分类)、时间（分类）

  protected

  def get_admin_locked_infos(content_id)
    CmsContentProductDetailsLockcfg.where(:cms_content_id => content_id, :created_source => 1)
  end


  def price_packages_father
    # p_0_father_id = 926 #套餐
    p_0_father_id = CmsSort.where(:cnname => "属性-时段套餐", :project_info_id => admin_info.project_info_id).first.id
  end

  def get_price_config_data (content_id)
=begin
1.判断是是羽毛球场馆
羽毛球 - 955
篮球 - 956
兵乓球 - 957
游泳 - 958
足球 - 959
网球 - 960
=end
    #t_father_id =926 #套餐
    #@price_config_one_dimensional=CmsSort.where(:father_id=>y_father_id).order("sort_order")


    #时段             场地
    p_0_father_id, p_1_father_id = time_area_fathers

    sort_items = CmsSort.joins("inner join cms_contents_cms_sorts b  on cms_sorts.id=b.cms_sort_id")
    .where("cms_content_id=?  and cms_sorts.father_id in (#{p_0_father_id},#{p_1_father_id}) ", content_id)
    .select("distinct cms_sorts.*")
    .order("sort_order")
    .all

    p_0 =sort_items.select { |sort_item| sort_item[:father_id] == p_0_father_id }
    p_1 =sort_items.select { |sort_item| sort_item[:father_id] == p_1_father_id }
    [p_0, p_1]
  end

  def time_area_fathers
    #p_0_father_id = 885      #时段
    #p_1_father_id =889       #场地
    # p_0_father_id, p_1_father_id = 885, 889
    p_0_father_id,p_1_father_id = CmsSort.where(:cnname => "属性-时段" , :project_info_id => admin_info.project_info_id).first.id , CmsSort.where(:cnname => "属性-场地", :project_info_id => admin_info.project_info_id).first.id
  end


  def get_price_data (content_id, week_day)
    #时段             场地
    p_0_father_id, p_1_father_id = time_area_fathers

    #                            .joins(" a
    #inner join cms_contents_cms_sorts b  on a.cms_content_id=b.cms_content_id
    #inner join cms_sorts c  on c.id=b.cms_sort_id")
    data = CmsInfoProductPrice
    .where(:cms_content_id => content_id, :week_day => week_day)
    .where("p_0 in (
  select cms_sorts.id from cms_sorts
  inner join cms_contents_cms_sorts   on cms_sorts.id=cms_contents_cms_sorts.cms_sort_id
  where cms_content_id=cms_info_product_prices.cms_content_id and  cms_sorts.father_id in (?)
)", p_0_father_id)
    .where("p_1 in (
  select cms_sorts.id from cms_sorts
  inner join cms_contents_cms_sorts   on cms_sorts.id=cms_contents_cms_sorts.cms_sort_id
  where cms_content_id=cms_info_product_prices.cms_content_id and  cms_sorts.father_id in (?)
) ", p_1_father_id)


  end


  def get_price_packages_config_data(content_id)
    #套餐
    p_0_father_id = price_packages_father

    sort_items = CmsSort.joins("inner join cms_contents_cms_sorts b  on cms_sorts.id=b.cms_sort_id")
    .where("cms_content_id=?  and cms_sorts.father_id in (#{p_0_father_id}) ", content_id)
    .order("sort_order")
  end

  def get_price_packages_data(content_id)
    #套餐
    p_0_father_id =price_packages_father


    data = CmsInfoProductPrice
    .where(:cms_content_id => content_id)
    .where("p_0 in (
  select cms_sorts.id from cms_sorts
  inner join cms_contents_cms_sorts   on cms_sorts.id=cms_contents_cms_sorts.cms_sort_id
  where cms_content_id=cms_info_product_prices.cms_content_id and  cms_sorts.father_id in (?)
)", p_0_father_id)

    #expr =  CmsInfoProductPrice.where(:cms_content_id=>content_id)
    #                          .where("p_0 in (select id from cms_sorts where father_id=?)",p_0_father_id )
  end


  public


  def price_set
    content_id= params[:content_id]
    week_day= params[:week_day]
    price_items =T.json_parse(params[:price_items])
    msg = nil
    buf = []
    catch :valid_error do
      if price_items.length == 0
        msg = "未提交数据"
        throw :valid_error
      end

      if params[:content_id].blank?
        msg = "内容标识错误"
        throw :valid_error
      end

      price_items.each do |price_item|
        current_week_day = price_item[:week_day]||week_day
        if current_week_day.nil?
          msg="星期参数不正确"
          throw :valid_error
        end

        if price_item[:p_0].blank? || price_item[:p_1].blank?
          msg ="参数p 必须有数据"
          throw :valid_error
        end

        item = CmsInfoProductPrice.where(:cms_content_id => content_id, :week_day => current_week_day, :p_0 => price_item[:p_0], :p_1 => price_item[:p_1], :p_2 => 0, :p_3 => 0, :p_4 => 0).first
        if item.nil?
          item = CmsInfoProductPrice.new
          item[:cms_content_id] = content_id
          item[:p_0]= price_item[:p_0]
          item[:p_1]= price_item[:p_1]
          item[:num]= price_item[:num]||1
          item[:week_day]= price_item[:week_day]
        end
        item[:price]=price_item[:price]
        buf << item
      end
    end

    if msg.nil?
      buf.each do |item|
        item.save
      end
    end

    render :json => {:success => msg.nil?, :count => buf.length, :msg => msg, :item_length => buf}

  end

  def price_packages_set
    content_id= params[:content_id]
    price_items =T.json_parse(params[:price_items])
    msg = nil
    buf = []
    catch :valid_error do
      if price_items.length == 0
        msg = "未提交数据"
        throw :valid_error
      end

      if params[:content_id].blank?
        msg = "内容标识错误"
        throw :valid_error
      end

      price_items.each do |price_item|
        expr_dic ={:p_0 => 0, :p_1 => 0, :p_2 => 0, :p_3 => 0, :p_4 => 0, :week_day => nil}

        expr = CmsInfoProductPrice.where(:cms_content_id => content_id)

        expr_dic.each_pair do |key, value|
          expr_dic[key]=price_item[key] if price_item.include? key
        end
        expr = expr.where(expr_dic)

        item =expr.first

        if item.nil?

          item = CmsInfoProductPrice.new

          if price_item[:price].blank?
            price_item[:price]=-1
          end
          price_item[:cms_content_id] = content_id
          price_item[:num]= price_item[:num]||1
          item.update_attributes(price_item)

        end
        item[:price]=price_item[:price]
        buf << item
      end
    end

    if msg.nil?
      buf.each do |item|
        item.save
      end
    end
    render :json => {:success => msg.nil?, :count => buf.length, :msg => msg}
  end


  def create
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ProductContent.new(params[:product_content])
    @content_item.project_info_id = admin_info.project_info_id
    respond_to do |format|
      if @content_item.save
        format.html { redirect_to url_for :action => "index", :sort_id => params[:sort_id], notice: '添加成功.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ProductContent.find(params[:product_content][:id])
    respond_to do |format|
      if @content_item.update_attributes(params[:product_content])
        format.html { redirect_to url_for :action => "index", :page => params[:page], :sort_id => params[:sort_id], notice: '修改成功.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ProductContent.find(params[:id])
    @content_item.destroy

    respond_to do |format|
      format.html { redirect_to url_for :action => "index", :page => params[:page], :sort_id => params[:sort_id], notice: '删除成功.' }
      format.json { head :no_content }
    end
  end


end
