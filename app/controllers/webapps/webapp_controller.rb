# encoding: utf-8
require 'json'
class Webapps::WebappController < ApplicationController
  def main
    # 为用户在app内登录
    Rails.logger.info "use session: "+(!session[:access_token].blank? && session[:appnum] == params[:appnum]).to_s

    # 如果不是本app，则清除session
    session_clear() if session[:appnum] != params[:appnum]
    return render :text => 'no such app' if !check_login()
    
    @modules = getModulesInfo(session[:project_info_id])

    redirect_to url_for :controller => @modules.at(0)[:tname], :action => "index" , :module_id => @modules.at(0)[:id]
    # Rails.logger.info @modules.to_s

  end

  # 访问服务端api的代理
  def callapi
    render :text => callApi(params['method'] , params)
  end
  private
end
