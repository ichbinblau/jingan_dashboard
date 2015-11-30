# encoding: utf-8
class Admins::SysUserSortController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end

  def index
    app_module_info
    # 内容列表
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?
    search="project_info_id=#{admin_info.project_info_id}"
    if !params[:username].blank?
        search += " and char_value_0 = '#{params[:username]}'"
    end
    @content_items = UserSortInfo
                    .where(search)
                    .order("valid_status DESC , id desc").paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupon_contents }
    end
  end

  def edit
    app_module_info

    content_item = UserSortInfo.find(params[:id])
    if content_item.valid_status!=1
      content_item.update_attributes(:valid_status=>1)
    else
      content_item.update_attributes(:valid_status=>2)
    end
    respond_to do |format|
      format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '修改成功.' }
      format.json { head :no_content }
    end
  end

end
