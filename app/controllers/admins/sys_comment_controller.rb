# encoding: utf-8
class Admins::SysCommentController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end

  def index
    app_module_info
    # 内容列表
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?
    search = " cms_content_comments.project_info_id = #{admin_info.project_info_id}"
    search += " and cms_content_comments.typenum = 2"
    search += " and cms_contents.title like '%#{params[:title]}%' " if !params[:title].blank?
    join = "join cms_contents on cms_contents.id = cms_content_comments.cms_content_id"
    #join += " join cms_contents_cms_sorts on cms_contents_cms_sorts.cms_content_id=cms_contents.id"
    #join += " join cms_contents_cms_sorts on cms_contents_cms_sorts.cms_content_id=cms_contents.id"
    #join += " join cms_sorts on cms_sorts.id = cms_contents_cms_sorts.cms_sort_id"
    join += " join cms_sorts on cms_sorts.id = (select min(cms_contents_cms_sorts.cms_sort_id) from cms_contents_cms_sorts where cms_contents_cms_sorts.cms_content_id=cms_contents.id)"
    
    # print "Hello, ", search
    # Rails.logger.info joins.inspect
    @content_items = CmsContentComment
    .select("cms_content_comments.id, cms_sorts.cnname, cms_sorts.id as sort_id, cms_contents.title, cms_content_comments.content, cms_content_comments.admin_reply, cms_content_comments.created_at")
    .joins( join )
    .where( search )
    .order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @content_items }
    end



  end

  def show
    @content_item = CmsContentComment.find(params[:id])
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @content_item }
    end
  end

  def edit
    app_module_info
    @content_item = CmsContentComment.find(params[:id])
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @content_item }
    end

  end

  def update
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = CmsContentComment.find(params[:cms_content_comment][:id])
    respond_to do |format|
      if @content_item.update_attributes(:admin_reply=>params[:cms_content_comment][:admin_reply])
      	format.html { redirect_to url_for :action =>"index" ,:page=>params[:page], notice: '修改成功.' }
      	format.json { head :no_content }
      else
	format.html { render action: "edit" }
      end
    end
  end

end
