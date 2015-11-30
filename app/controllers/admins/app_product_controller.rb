# encoding: utf-8
class Admins::AppProductController < ApplicationController
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
    sortsql = sortids.collect{ |sortid| "tb#{sortid}.cms_sort_id!=0" }.join(" and ")
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
                    .includes( :cms_info_product )
                    .joins( joins )
                    .where( search )
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

  def price_config_data
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
    p_0_father_id = 885      #时段
    p_1_father_id =889       #场地

    p_0 = CmsSort.where(:father_id=>p_0_father_id).order("sort_order")
    p_1  = CmsSort.where(:father_id=>p_1_father_id).order("sort_order")
    data ={:p_0=>p_0,:p_1=>p_1}
    render :json=>data
  end

  def price_data
    week_day= params[:week_day]
    content_id= params[:content_id]
    data =  CmsInfoProductPrice.where(:cms_content_id=>content_id,:week_day=>week_day)
    render :json=> data
  end



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
        current_week_day =  price_item[:week_day]||week_day
        if current_week_day.nil?
          msg="星期参数不正确"
          throw :valid_error
        end

        if price_item[:p_0].blank? || price_item[:p_1].blank?
          msg ="参数p 必须有数据"
          throw :valid_error
        end

        item = CmsInfoProductPrice.where(:cms_content_id=>content_id,:week_day=>current_week_day,:p_0=>price_item[:p_0],:p_1=>price_item[:p_1],:p_2=>0,:p_3=>0,:p_4=>0   ).first
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

    render :json=>{:success=>msg.nil?,:count=> buf.length,:msg=>msg,:item_length=> buf}

  end


  def price_packages_config_data
=begin
套餐
=end
    #t_father_id =926 #套餐
    #@price_config_one_dimensional=CmsSort.where(:father_id=>y_father_id).order("sort_order")
    p_0_father_id = 926      #时段
    p_0 = CmsSort.where(:father_id=>p_0_father_id).order("sort_order")
    data ={:p_0=>p_0}
    render :json=>data
  end

  def price_packages_data
    p_0_father_id =926 #套餐
    content_id= params[:content_id]
    expr =  CmsInfoProductPrice.where(:cms_content_id=>content_id)
    expr =   expr.where("p_0 in (select id from cms_sorts where father_id=?)",p_0_father_id )

    render :json=> expr
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
        expr_dic ={:p_0=>0,:p_1=>0,:p_2=>0,:p_3=>0,:p_4=>0,:week_day=>nil}

        expr = CmsInfoProductPrice.where(:cms_content_id=>content_id)

        expr_dic.each_pair do |key,value|
          expr_dic[key]=price_item[key] if price_item.include? key
        end
        expr = expr.where(expr_dic)

        item =expr.first

        if item.nil?
          item = CmsInfoProductPrice.new
          item.update_attributes(price_item)
          item[:cms_content_id] = content_id
          item[:num]= price_item[:num]||1
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
    render :json=>{:success=>msg.nil?,:count=> buf.length,:msg=>msg}
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
        format.html { redirect_to url_for :action =>"index",:sort_id=>params[:sort_id], notice: '添加成功.' }
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
        format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '修改成功.' }
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
      format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '删除成功.' }
      format.json { head :no_content }
    end
  end
end
