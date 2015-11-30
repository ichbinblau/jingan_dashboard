# encoding: utf-8
class Admins::SysDeliveryController < ApplicationController
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

    joins = "left join user_consignees on act_ship_orders.user_consignee_id=user_consignees.id"
    where = "act_ship_orders.project_info_id=#{admin_info.project_info_id} "

    if !params[:title].blank?
      where += " and act_ship_orders.title like '%#{params[:title].gsub(/\s+/,"")}%'"
    end

    @content_items = ActShipOrder
                    .select("act_ship_orders.*, user_consignees.consignee_name, user_consignees.consignee_address, user_consignees.consignee_zip, user_consignees.phone, user_consignees.remarks")
                    .joins( joins )
                    .where( where )
                    .order("created_at DESC").paginate(:page => params[:page], :per_page => params[:per_page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @content_items }
    end
  end

end
