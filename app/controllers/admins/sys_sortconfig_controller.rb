# encoding: utf-8
class Admins::SysSortconfigController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end

  def app_module_info
    @admin_info = admin_info
  end

  def index
    app_module_info
    # return render :json => @admin_info
  end

  def ssort
    app_module_info
    sorts = CmsSort.where :project_info_id => @admin_info.project_info_id
    sorts.each do |item|
        item[:pId] = item.father_id
        item[:name] = item.cnname
        item[:sub_items] = sorts.select{|x| x.father_id == item.id }
    end

    Rails.logger.info sorts.to_json

    return render :json => sorts
  end

  # 获取子分类结构
  def get_sort(sorts , father_id = 0)
    newsort = []
    sorts.each do |item|
      if item.father_id == father_id
        item[:pId] = item.father_id
        item[:name] = item.cnname
        item[:sub_items] = sorts.select{|x| x.father_id == item.id }
        item[:open] = true if item[:sub_items].size > 0
        newsort.push item
      end
    end
    return newsort
  end

  def modify_sort
    app_module_info
    sort = CmsSort.find params[:sort_id]
    unless sort.blank?
      sort.father_id = params[:father_id] unless params[:father_id].blank?
      unless params[:name].blank?
        sort.cnname = params[:name] 
        sort.name = params[:name] 
      end
      sort.save
      top_sort_id = find_top_sort_id( sort.id )
      sort.top_sort_id = (top_sort_id == sort.id) ? 0 : top_sort_id
      sort.save
      set_subitem_top_sort_id(sort.id , top_sort_id)
      return render :json => {:success => true}
    end
  end

  def add_sort
    app_module_info
    newsort = { :father_id => params[:father_id] , :name => params[:name] , :cnname => params[:name] ,:project_info_id => @admin_info.project_info_id}
    newsort[:top_sort_id] = find_top_sort_id( params[:father_id] )
    sort = CmsSort.new newsort
    sort.save
    return render :json => {:success => true , :id => sort.id}
  end

  def remove_sort
    app_module_info
    sort = CmsSort.find params[:sort_id]
    sort.destroy
    return render :json => { :success => true }
  end
  def set_subitem_top_sort_id(sort_id , top_id)
    subsort = CmsSort.where(:father_id => sort_id)
    return if subsort.size == 0
    if top_id == 0
      top_id = sort_id
    end
    subsort.each do |item|
      item.top_sort_id = top_id
      item.save
      set_subitem_top_sort_id(item.id , top_id)
    end
  end

  def find_top_sort_id(sort_id)
    if sort_id == 0
      return 0
    end
    sort = CmsSort.find sort_id
    if sort.father_id != 0
      return find_top_sort_id(sort.father_id)
    else
      return sort_id
    end
  end
end
