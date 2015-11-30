# encoding: utf-8
class Admins::AppPoiController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  def getGoogleBaiduGps
    # http://map.yanue.net/gpsApi.php?lat=22.502412986242&lng=113.93832783228
    url = URI::encode("http://map.yanue.net/gpsApi.php?lat=#{params[:lat]}&lng=#{params[:lng]}")
    info = Net::HTTP.get_response(URI.parse(url)).body
    render text: info
  end

  def index
    app_module_info
    # 显示区域选择
    areas = []
    params[:now_city] = 301;
    @city = SysLocationInfo.find(params[:now_city]);
    @districts = SysLocationInfo.where(:father_id => params[:now_city]);
    if !params[:now_district].blank?
      @district = SysLocationInfo.find(params[:now_district]);
      @areas = SysLocationInfo.where(:father_id => params[:now_district]);
      if params[:now_area].blank?
        @areas.each{|item| areas.push item.id}
      else
        areas.push params[:now_area]
      end
    else
      districts = @districts.collect{|item| item.id}
      areas=SysLocationInfo.where(:father_id => districts).collect{|item| item.id}
    end


    # 分类列表
    sorts = []
    if @properties.blank? #一级频道
      if @channels.count == 1 #单分类
        sorts.push @channels[0][:id]
      else  #频道
        if params[:sort_id].blank?
          @channels.each{|item| sorts.push item.id}
        else
          sorts.push params[:sort_id]
        end
      end
    else  #二级分类
      if params[:sort_id].blank?
        @properties.each do |item|
          item[:sort_list].each do |it|
            sorts.push it.id
          end
        end
      else
        if @properties.collect{|item| item.id.to_s }.include? params[:sort_id] #选中为一级分类则需要显示下级子分类所有内容
          @properties.select{|item| item.id.to_s == params[:sort_id]}.first[:sort_list].each do |item|
            sorts.push item.id
          end
        else
          sorts.push params[:sort_id]
        end
      end
    end

    # Rails.logger.info joins.inspect
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end

    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?
    
    if params[:now_district].blank?
      para = {
        cms_sorts: {id: sorts }
      }
    else
      para = {
        sys_location_infos: {id: areas} ,
        cms_sorts: {id: sorts }
      }
    end
    @content_items = ShopContent
                    .includes( :cms_info_shop )
                    .includes( :sys_location_infos )
                    .includes( :cms_sorts )
                    .where( para )
                    .order("cms_contents.id DESC").paginate(:page => params[:page], :per_page => params[:per_page])
    # Rails.logger.info @content_items.count.inspect
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupon_contents }
    end
  end

  def show
    @content_item = ShopContent.includes(:cms_content_img).find(params[:id])

    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def new
    app_module_info
    @selector_sorts = CmsSort.where :project_info_id => admin_info.project_info_id
    @selector_sorts.each do |item|
        item[:pId] = item.father_id
        item[:name] = item.cnname
        item[:sub_items] = @selector_sorts.select{|x| x.father_id == item.id }
    end

    # Rails.logger.info configs.to_json
    # 区域选择
    @select_locations = SysLocationInfo.where(:id => params[:now_area])
    sorts = []
    @sorts.each{ |key ,val| sorts.push val }
    @select_sorts = CmsSort.where(id: sorts)


    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ShopContent.new
    @content_item.project_info_id = admin_info.project_info_id
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def edit
    app_module_info
    @selector_sorts = CmsSort.where :project_info_id => admin_info.project_info_id
    @selector_sorts.each do |item|
        item[:pId] = item.father_id
        item[:name] = item.cnname
        item[:sub_items] = @selector_sorts.select{|x| x.father_id == item.id }
    end

    # 区域选择
    @select_locations = SysLocationInfo.where(:id => params[:now_area])
    sorts = []
    @sorts.each{ |key ,val| sorts.push val }
    @select_sorts = CmsSort.where(id: sorts)


    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ShopContent.find(params[:id])
    @content_item.project_info_id = admin_info.project_info_id

  end

  def create
    app_module_info

    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    # content是混合内容的情况
    params[:shop_content][:content] = params[:json_content].to_json if @field_configs["fields"] != nil

    @content_item = ShopContent.new(params[:shop_content])
    @content_item.project_info_id = admin_info.project_info_id
    respond_to do |format|
      if @content_item.save
        format.html { redirect_to url_for :action =>"index",:sort_id=>params[:sort_id] , :now_district => params[:now_district] , :now_area => params[:now_area], notice: '添加成功.' }
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
    # content是混合内容的情况
    params[:shop_content][:content] = params[:json_content].to_json if @field_configs["fields"] != nil
    
    @content_item = ShopContent.find(params[:shop_content][:id])
    respond_to do |format|
      if @content_item.update_attributes(params[:shop_content])
        format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id] , :now_district => params[:now_district] , :now_area => params[:now_area], notice: '修改成功.' }
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
    @content_item = ShopContent.find(params[:id])
    @content_item.destroy

    respond_to do |format|
      format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id] , :now_district => params[:now_district] , :now_area => params[:now_area], notice: '删除成功.' }
      format.json { head :no_content }
    end
  end
end
