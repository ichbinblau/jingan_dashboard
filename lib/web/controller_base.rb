# encoding: utf-8
class ControllerBase < ApplicationController

  before_filter :init

  def init
        #@current_user =admin_info
    @role_id=8
  end

  def _admin_info
    #AdminUser.select("admin_users.email ,admin_users.project_info_id, project_infos.*")
    #.joins(" left join project_infos on( admin_users.project_info_id = project_infos.id)").find(current_admin_user.id)

  end









  # To change this template use File | Settings | File Templates.



end