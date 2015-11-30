class Admins::SysSignupController < ApplicationController
  before_filter :authenticate_admin_user!

  def perpage
    20
  end

  #def admin_info
  #  AdminUser.select("admin_users.email ,admin_users.project_info_id, project_infos.*")
  #  .joins(" left join project_infos on( admin_users.project_info_id = project_infos.id)").find(current_admin_user.id)
  #end

  def index
    app_module_info
    project_info_id = admin_info.project_info_id
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?

    joins = "c1 left join user_signup_infos c2 on c1.user_signup_id=c2.id "
    #joins += "left join cms_contents c3 on c1.cms_content_id=c3.id"
    where = "c1.project_info_id=#{admin_info.project_info_id}"    

    if !params[:title].blank?
      where += " and c1.title like '%#{params[:title].gsub(/\s+/,"")}%'"
    end

    @content_items = ActSignupOrder
                    .joins( joins )
                    .select("c1.*, c2.username, c2.gender, c2.age, c2.address, c2.phone")
                    .where( where )
                    .order("created_at DESC").paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @content_items }
    end
  end

end
