# encoding: utf-8
class Admins::AppActivityController < ApplicationController
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
    search = " #{sortsql} and cms_contents.project_info_id = #{admin_info.project_info_id}"
    search += " and title like '%#{params[:words]}%'" if !params[:words].blank?
    joins = ""
    joins2 = ""
    sortids.each do |sortid|
      joins += " left join cms_contents_cms_sorts tb#{sortid} on( cms_contents.id=tb#{sortid}.cms_content_id and tb#{sortid}.cms_sort_id='#{sortid}' ) "
    end

    Rails.logger.info("joins-----------------"+joins.to_s)
    Rails.logger.info("search-----------------"+search.to_s)
    # Rails.logger.info joins.inspect
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_items = ActivityContent
    .includes( :cms_info_activity )
    .joins( joins )
    .where( search )
    .order("cms_contents.id DESC").paginate(:page => params[:page], :per_page => params[:per_page])
    if   admin_info.project_info_id==63
      activityindex=0
      @content_items.each do |activityinfo|
        sortidinfo=CmsSortsPlugincfgInfos.joins("join cms_sorts on cms_sorts.id =cms_sorts_plugincfg_infos.cms_sort_id join cms_contents_cms_sorts on cms_contents_cms_sorts.cms_sort_id=cms_sorts.id").where("cms_contents_cms_sorts.cms_content_id=#{activityinfo[:id]} and cms_sorts.cnname='活动详细' ").first()
        if sortidinfo!=nil
          @content_items[activityindex][:sort_father_id]=sortidinfo.plugincfg_info_id.to_i()
        else
          @content_items[activityindex][:sort_father_id]="0"
        end
        activityindex=activityindex+1
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupon_contents }
    end

  end

  def show
    @content_item = ActivityContent.includes(:cms_content_img).find(params[:id])
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
    @content_item = ActivityContent.new
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
    @content_item = ActivityContent.includes(:cms_content_img).includes(:shop_contents).find(params[:id])
    @content_item.project_info_id = admin_info.project_info_id

  end

  def create
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ActivityContent.new(params[:activity_content])
    @content_item.project_info_id = admin_info.project_info_id
    respond_to do |format|
      if @content_item.save
        if  admin_info.project_info_id==63
          @sort0=CmsSort.new(:cnname => "活动详细",:project_info_id => 63,:name => "活动详细",:cms_sort_type_id=>4)
          @sort0.save
          @sort1=CmsSort.new(:cnname => "赛事指南",:project_info_id => 63,:father_id => @sort0.id,:name => "赛事指南",:cms_sort_type_id=>4)
          @sort1.save
          @sort2=CmsSort.new(:cnname => "最新消息",:project_info_id => 63,:father_id => @sort0.id,:name => "最新消息",:cms_sort_type_id=>4)
          @sort2.save
          @sort3=CmsSort.new(:cnname => "图片",:project_info_id => 63,:father_id => @sort0.id,:name => "图片",:cms_sort_type_id=>4)
          @sort3.save
          @sort4=CmsSort.new(:cnname => "报名",:project_info_id => 63,:father_id => @sort0.id,:name => "报名",:cms_sort_type_id=>4)
          @sort4.save
          @content_sort=CmsContentsCmsSort.new(:cms_content_id => @content_item.id,:cms_sort_id => @sort0.id)
          @content_sort.save
          @pluinfo=PlugincfgInfo.new(:plugincfg_type_id=>1,:project_info_id=>63,:name=>"活动详细zhx",:show_name=>"活动详细",:configs=>"{ \"order\" : 1 }")
          @pluinfo.save
          @sortplu=CmsSortsPlugincfgInfos.new(:cms_sort_id=>@sort0.id,:plugincfg_info_id=>@pluinfo.id)
          @sortplu.save
        end

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
    @content_item = ActivityContent.find(params[:activity_content][:id])
    respond_to do |format|
      if @content_item.update_attributes(params[:activity_content])
        if  admin_info.project_info_id==63
          @sort0=CmsSort.new(:cnname => "活动详细",:project_info_id => 63,:name => "活动详细",:cms_sort_type_id=>4)
          @sort0.save
          @sort1=CmsSort.new(:cnname => "赛事指南",:project_info_id => 63,:father_id => @sort0.id,:name => "赛事指南",:cms_sort_type_id=>4)
          @sort1.save
          @sort2=CmsSort.new(:cnname => "最新消息",:project_info_id => 63,:father_id => @sort0.id,:name => "最新消息",:cms_sort_type_id=>4)
          @sort2.save
          @sort3=CmsSort.new(:cnname => "图片",:project_info_id => 63,:father_id => @sort0.id,:name => "图片",:cms_sort_type_id=>4)
          @sort3.save
          @sort4=CmsSort.new(:cnname => "报名",:project_info_id => 63,:father_id => @sort0.id,:name => "报名",:cms_sort_type_id=>4)
          @sort4.save
          @content_sort=CmsContentsCmsSort.new(:cms_content_id => @content_item.id,:cms_sort_id => @sort0.id)
          @content_sort.save
          @pluinfo=PlugincfgInfo.new(:plugincfg_type_id=>1,:project_info_id=>63,:name=>"活动详细zhx",:show_name=>"活动详细",:configs=>"{ \"order\" : 1 }")
          @pluinfo.save
          @sortplu=CmsSortsPlugincfgInfos.new(:cms_sort_id=>@sort0.id,:plugincfg_info_id=>@pluinfo.id)
          @sortplu.save
        end
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
    @content_item = ActivityContent.find(params[:id])

    @content_sort=CmsContentsCmsSort.joins("join cms_sorts on cms_contents_cms_sorts.cms_sort_id=cms_sorts.id").where("cms_contents_cms_sorts.cms_content_id = #{@content_item.id} and cms_sorts.cnname = '活动详细'").first()

    Rails.logger.info("joins-----------------"+@content_sort[:cms_content_id].to_s)
    if @content_sort!=nil

      #CmsContentsCmsSort.destroy_all(["cms_content_id=#{@content_sort[:cms_content_id]} and cms_sort_id=#{@content_sort[:cms_sort_id]}"])

      #@content_sorts=CmsContentsCmsSort.where("cms_content_id=#{@content_sort[:cms_content_id]} and cms_sort_id=#{@content_sort[:cms_sort_id]}").first()
      #@content_sorts.destroy

      @sort0=CmsSort.where("cnname = '活动详细' and project_info_id = 63 and id = #{@content_sort[:cms_sort_id]} and cms_sort_type_id=4").first()
      @sort0.destroy
      @sort1=CmsSort.where("cnname = '赛事指南' and project_info_id = 63 and father_id = #{@sort0.id} and name = '赛事指南' and cms_sort_type_id=4").first()
      @sort1.destroy
      @sort2=CmsSort.where("cnname = '最新消息' and project_info_id = 63 and father_id = #{@sort0.id} and name = '最新消息' and cms_sort_type_id=4").first()
      @sort2.destroy
      @sort3=CmsSort.where("cnname = '图片' and project_info_id = 63 and father_id = #{@sort0.id} and name = '图片' and cms_sort_type_id=4").first()
      @sort3.destroy
      @sort4=CmsSort.where("cnname = '报名' and project_info_id = 63 and father_id = #{@sort0.id} and name = '报名' and cms_sort_type_id=4").first()
      @sort4.destroy
    end

    @pluinfo=PlugincfgInfo.where("plugincfg_type_id=1 and project_info_id=63 and name='活动详细zhx' and show_name='活动详细'").first()

    @pluinfo.destroy
    #@sortplu=CmsSortsPlugincfgInfos.where("cms_sort_id=#{@sort0.id} and plugincfg_info_id=#{@pluinfo.id}").first()
    #@sortplu.destroy
    @content_item.destroy

    respond_to do |format|
      format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '删除成功.' }
      format.json { head :no_content }
    end
  end
end
