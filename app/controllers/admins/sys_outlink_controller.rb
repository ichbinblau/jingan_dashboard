# encoding: utf-8
class Admins::SysOutlinkController < ApplicationController
  before_filter:authenticate_admin_user!
  def index
  end

  def mapview
    params[:appnum] = admin_info[:project_num]
    check_login()
    @sport_record_num = CmsContentComment.where( :project_info_id => admin_info.project_info_id, :typenum => 1)
    @repair_record_num = CmsContentComment.where( :project_info_id => admin_info.project_info_id, :typenum => 2)
  end

  def cus_mapview
    params[:appnum] = admin_info[:project_num]
    check_login()
    # @shops = ShopContent.joins(:cms_sorts).joins(:cms_info_shop) \
    #         .where( :project_info_id => admin_info.project_info_id ) \
    #         .where( cms_sorts: { id: [1602] } )
  end

  def poi_mapview
    params[:appnum] = admin_info[:project_num]
    check_login()
    # Rails.logger.info "123123"
    @cfg_info = PlugincfgInfo.find params[:cfg_id]
    @fields_info = JSON.parse(@cfg_info.configs)["fields"]
    @father_sort_id = @cfg_info.cms_sorts[0].id.to_s
  end

  def poi_mapview_shops
    fathers = CmsSort.where(:project_info_id => admin_info.project_info_id , :father_id => params[:father_sort_id]).each do |item|
      item[:children] = []
    end
    sorts = CmsSort.where(:father_id =>fathers.collect{|item| item.id })
    # 为父分类添加子分类
    sorts.each do |item|
      fathers.each do |fitem|
        if fitem.id == item.father_id
          fitem[:children].push item.id
        end
      end
    end
    # Rails.logger.info sorts.to_json
    @shops = ShopContent.joins(:cms_sorts).joins(:cms_info_shop) \
            .includes(:cms_sorts) \
            .where( :project_info_id => admin_info.project_info_id ) \
            .where( cms_sorts: { id: sorts.collect{|item| item.id } } ).each do |item|
              item[:sorts] = item.cms_sorts.collect{|item| item.id }
            end
    render json: {  :shops => @shops \
                  , :father_sorts => fathers \
                  , :sorts => CmsSort.where(:father_id =>fathers.collect{|item| item.id }) }
  end

  def cus_mapview_shops
    fathers = CmsSort.where(:project_info_id => admin_info.project_info_id , :father_id => 1602).each do |item|
      item[:children] = []
    end
    sorts = CmsSort.where(:father_id =>fathers.collect{|item| item.id })
    # 为父分类添加子分类
    sorts.each do |item|
      fathers.each do |fitem|
        if fitem.id == item.father_id
          fitem[:children].push item.id
        end
      end
    end
    # Rails.logger.info sorts.to_json
    @shops = ShopContent.joins(:cms_sorts).joins(:cms_info_shop) \
            .includes(:cms_sorts) \
            .where( :project_info_id => admin_info.project_info_id ) \
            .where( cms_sorts: { id: sorts.collect{|item| item.id } } ).each do |item|
              item[:sorts] = item.cms_sorts.collect{|item| item.id }
            end
    render json: {  :shops => @shops \
                  , :father_sorts => fathers \
                  , :sorts => CmsSort.where(:father_id =>fathers.collect{|item| item.id }) }
  end
  def call
    render json: callApi( params[:method] , params , params[:version] ,true)
  end
end
