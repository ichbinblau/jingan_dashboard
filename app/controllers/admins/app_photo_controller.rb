# encoding: utf-8
class Admins::AppPhotoController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  def index
    app_module_info
    # 内容列表
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?
    sortids = @sort_id.to_s.split(",")
    sortsql = sortids.collect{|sortid| "tb#{sortid}.cms_sort_id!=0" }.join(" and ")
    search = " #{sortsql} and project_info_id = #{admin_info.project_info_id}"
    search += " and title like '%#{params[:words]}%'" if !params[:words].blank?
    joins = ""
    sortids.each do |sortid|
      joins += " left join cms_contents_cms_sorts tb#{sortid} on( cms_contents.id=tb#{sortid}.cms_content_id and tb#{sortid}.cms_sort_id='#{sortid}' ) "
    end
    # Rails.logger.info joins.inspect
    @content_items = NewsContent
                    .includes( :cms_info_news )
                    .joins( joins )
                    .where( search )
                    .order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupon_contents }
    end

  end

  def show
    @content_item = NewsContent.includes(:cms_content_img).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def new
    app_module_info
    @content_item = NewsContent.new
    @content_item.project_info_id = admin_info.project_info_id
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def edit
    app_module_info
    @content_item = NewsContent.includes(:cms_content_img).find(params[:id])
    @content_item.project_info_id = admin_info.project_info_id

  end

  def create
    app_module_info
    @content_item = NewsContent.new(params[:news_content])
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
    @content_item = NewsContent.find(params[:news_content][:id])
    respond_to do |format|
      if @content_item.update_attributes(params[:news_content])
        format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '修改成功.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    app_module_info
    @content_item = NewsContent.find(params[:id])
    @content_item.destroy

    respond_to do |format|
      format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '删除成功.' }
      format.json { head :no_content }
    end
  end
end
