# encoding: utf-8
class Admins::SysStatusController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  def app_module_info
    @admin_info = admin_info
  end
  # select * from report_date_projects cl 
  # left join report_date_projects an on(cl.`old_time` = an.`old_time` and cl.`time_type` = an.`time_type` and cl.`project_info_id` = an.`project_info_id` and cl.project_app_id = an.`project_app_id` and an.`report_key`='ActivationNum') 
  # left join report_date_projects apn on(cl.`old_time` = apn.`old_time` and cl.`time_type` = apn.`time_type` and cl.`project_info_id` = apn.`project_info_id` and cl.project_app_id = apn.`project_app_id` and apn.`report_key`='ApplyNum') 
  # left join report_date_projects dn  on(cl.`old_time` = dn.`old_time` and cl.`time_type` = dn.`time_type` and cl.`project_info_id` = dn.`project_info_id` and cl.project_app_id = dn.`project_app_id`  and dn.`report_key`='DownNum')
  # left join report_date_projects bn  on(cl.`old_time` = bn.`old_time` and cl.`time_type` = bn.`time_type` and cl.`project_info_id` = bn.`project_info_id` and cl.project_app_id = bn.`project_app_id` and bn.`report_key`='BriskNum') 
  # left join report_date_projects un  on(cl.`old_time` = un.`old_time` and cl.`time_type` = un.`time_type` and cl.`project_info_id` = un.`project_info_id` and cl.project_app_id = un.`project_app_id` and un.`report_key`='UserNum') 
  # where cl.`time_type` =3 and cl.project_info_id = 9 and cl.report_key='ClickNum'
  def index
    app_module_info
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    @project_info_id = @admin_info.project_info_id
    @project_apps = ProjectApp.where(:project_info_id => @project_info_id)
    @project_app_info = params[:project_app_id].blank? ? @project_apps.select{ |item|  item[:phonetype] == 'android' }.first : @project_apps.select { |item| item[:id].to_s == params[:project_app_id] }.first 
    params[:project_app_id] = @project_app_info[:id].to_s

    Rails.logger.info @project_app_info.inspect

    params[:time_type] = params[:time_type].blank? ? "2" : params[:time_type]
    @time_type_nav = [
      { :value => 1, :text => "日" },
      { :value => 2, :text => "周" },
      { :value => 3, :text => "月" }
    ]
    params[:view_type] = params[:view_type].blank? ? "1" : params[:view_type]
    @view_type_nav = [
      { :value => 1, :text => "曲线图" },
      { :value => 2, :text => "表格" }
    ]

    @report_info = ReportDateProject.select("cl.* ,cl.report_value clv, an.report_value anv ,apn.report_value apnv ,dn.report_value dnv ,bn.report_value bnv ,un.report_value unv ") \
                      .order("old_time desc") \
                      .joins("cl left join report_date_projects an on(cl.`old_time` = an.`old_time` and cl.`time_type` = an.`time_type` and cl.`project_info_id` = an.`project_info_id` and cl.project_app_id = an.`project_app_id` and an.`report_key`='ActivationNum') \
                              left join report_date_projects apn on(cl.`old_time` = apn.`old_time` and cl.`time_type` = apn.`time_type` and cl.`project_info_id` = apn.`project_info_id` and cl.project_app_id = apn.`project_app_id` and apn.`report_key`='ApplyNum') \
                              left join report_date_projects dn  on(cl.`old_time` = dn.`old_time` and cl.`time_type` = dn.`time_type` and cl.`project_info_id` = dn.`project_info_id` and cl.project_app_id = dn.`project_app_id`  and dn.`report_key`='DownNum') \
                              left join report_date_projects bn  on(cl.`old_time` = bn.`old_time` and cl.`time_type` = bn.`time_type` and cl.`project_info_id` = bn.`project_info_id` and cl.project_app_id = bn.`project_app_id` and bn.`report_key`='BriskNum') \
                              left join report_date_projects un  on(cl.`old_time` = un.`old_time` and cl.`time_type` = un.`time_type` and cl.`project_info_id` = un.`project_info_id` and cl.project_app_id = un.`project_app_id` and un.`report_key`='UserNum') ") \
                      .where("cl.`time_type` = #{params[:time_type]} and cl.project_app_id = #{params[:project_app_id]} and cl.report_key='ClickNum'") \
                      .paginate(:page => params[:page], :per_page => params[:per_page])

    @report_photo_view = [ {:name =>"活跃用户",:data =>[] }  ,{:name =>"新增用户",:data =>[] },{:name =>"优惠申请",:data =>[] } ]
    @report_info.each do |item| 
      # @report_photo_view[0][:data].push( [ item.old_time.strftime("%Y-%m-%d") , item[:unv] ] )
      @report_photo_view[0][:data].push( [ item.old_time.strftime("%Y-%m-%d") , item[:bnv] ] )
      @report_photo_view[1][:data].push( [ item.old_time.strftime("%Y-%m-%d") , item[:anv] ] )
      @report_photo_view[2][:data].push( [ item.old_time.strftime("%Y-%m-%d") , item[:apnv] ])
    end

    Rails.logger.info @report_photo_view.inspect
  end

end
