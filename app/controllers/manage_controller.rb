# encoding: utf-8
class ManageController < ApplicationController
  before_filter:authenticate_admin_user!

  def appstate
    if current_admin_user.id != 1
      respond_to do |format|
        format.json{ render :json => {"error" => "您没有查看权限！"} }
      end
      return
    end
    # puts current_user.id
  	# 初始化查询条件
  	per_page = 10
  	query_apps_where = []
  	if (params[:app_state].present?)
  		query_apps_where .push( " app_state = '#{params[:app_state]}'" )
  	end
  	if (params[:phonetype].present?)
  		query_apps_where .push( " phonetype = '#{params[:phonetype]}'" )
  	end

  	# 执行查询
  	@apps = ProjectApp.includes("project_info").where(query_apps_where.join(" and ")).includes("project_app_state_log").
		  	includes("project_app_upload").order("id desc").
		  	paginate(:page => params[:page] , :per_page => per_page)

    respond_to do |format|
      format.html
      format.json{ render :json => current_admin_user.id }
    end
  end
end
