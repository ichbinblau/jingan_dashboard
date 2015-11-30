# encoding: utf-8
class Admins::SysSportlogController < ApplicationController
  before_filter :authenticate_admin_user!
  layout "admins/_global",:only => [:index ]
  # To change this template use File | Settings | File Templates.


  def admin_info
    AdminUser.select("admin_users.email ,admin_users.project_info_id, project_infos.*")
    .joins(" left join project_infos on( admin_users.project_info_id = project_infos.id)").find(current_admin_user.id)
  end


  # 内容列表
  def index
    # 这里修改id
     project_info_id = admin_info.project_info_id
     page= params[:page]
     pageSize = params[:per_page]

     @content_items = CmsContentComment
                         .includes(:user_info,:cms_content)
                         .joins("c INNER JOIN cms_contents AS a ON c.cms_content_id = a.id")
                         .where("c.project_info_id =?  && c.typenum = 1 AND a.type =? ",project_info_id,"ShopContent")
                         .order("updated_at DESC")
                         .select("c.*")
                         .paginate(:page => page, :per_page => pageSize)

     respond_to do |format|
       format.html # index.html.erb
       format.json { render json: @content_items }
     end

  end


# 修改状态
 def edit




 end





end