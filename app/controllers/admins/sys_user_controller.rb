# encoding: utf-8
class Admins::SysUserController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  def app_module_info
    @admin_info = admin_info
    @module_info = PlugincfgInfo.select("plugincfg_infos.*,plugincfg_types.name as tname").joins(:plugincfg_type).find( params[:module_id] )
  end

  def index
    app_module_info
    # 内容列表
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    search = " project_info_id = #{admin_info.project_info_id}"
    search += " and (phone_number like '%#{params[:words]}%' or nickname like '%#{params[:words]}%')" if !params[:words].blank?

    print "Hello, ", JSON.parse(@module_info[:configs])
    @content_items = UserInfo.where( search ).order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page])

    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    # Rails.logger.info @coupon_contents.inspect
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupon_contents }
    end
  end

  def show
    @content_item = UserInfo.find(params[:id])

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
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = UserInfo.new
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
    @content_item = UserInfo.find(params[:id])
    @content_item.project_info_id = admin_info.project_info_id

  end

  def create
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = UserInfo.new(params[:user_info])
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
    @content_item = UserInfo.find(params[:user_info][:id])
    print "zhxaa"+ Digest::MD5.hexdigest(params[:user_info][:password].to_s )
    print "zhxaabb"+ @content_item.password
    if @content_item.password != Digest::MD5.hexdigest(params[:user_info][:password] )
      params[:user_info][:password]=Digest::MD5.hexdigest(params[:user_info][:password])
    end
    respond_to do |format|
      if @content_item.update_attributes(params[:user_info])
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
    @content_item = UserInfo.find(params[:id])
    @content_item.destroy

    respond_to do |format|
      format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '删除成功.' }
      format.json { head :no_content }
    end
  end
end



