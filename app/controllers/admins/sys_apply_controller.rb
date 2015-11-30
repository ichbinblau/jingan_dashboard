# encoding: utf-8
class Admins::SysApplyController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  def index
    app_module_info
    # 内容列表
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?
    search = " project_info_id = #{admin_info.project_info_id}"
    search += " and (text1 like '%#{params[:words]}%'  or text2 like '%#{params[:words]}%' or text3 like '%#{params[:words]}%' or text4 like '%#{params[:words]}%' or text5 like '%#{params[:words]}%' or text6 like '%#{params[:words]}%' or text7 like '%#{params[:words]}%' or text8 like '%#{params[:words]}%' or text9 like '%#{params[:words]}%' or text10 like '%#{params[:words]}%')" if !params[:words].blank?

    # Rails.logger.info joins.inspect
    @content_items = CmsInfoApply
    .where( search )
    .order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page])

    @title_item = ActApply
    .where( " project_info_id = #{admin_info.project_info_id}" )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupon_contents ,json:@title_item}
    end



  end

  def show
    @content_item = CmsInfoApply.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def new
    app_module_info
    search = " project_info_id = #{admin_info.project_info_id}"
    @title_item = ActApply.where( search )
    @content_item = CmsInfoApply.new
    @content_item.project_info_id = admin_info.project_info_id
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def edit
    app_module_info
    search = " project_info_id = #{admin_info.project_info_id}"
    @title_item = ActApply.where( search )
    @content_item = CmsInfoApply.find(params[:id])
    @content_item.project_info_id = admin_info.project_info_id

  end

  def create
    app_module_info
    @content_item = CmsInfoApply.new(params[:cms_info_apply])
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
    print "Hello, ", params[:cms_info_apply]
    @content_item = CmsInfoApply.find(params[:cms_info_apply][:id])
    respond_to do |format|
      if @content_item.update_attributes(params[:cms_info_apply])
        format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '修改成功.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    app_module_info
    @content_item = CmsInfoApply.find(params[:id])
    @content_item.destroy

    respond_to do |format|
      format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '删除成功.' }
      format.json { head :no_content }
    end
  end
end
