# encoding: utf-8
require 'time'
require "open-uri"
require 'net/http'
class Webapis::WikiController < ActionController::Base
  before_filter:authenticate_admin_user! , :only => [:index, :search_api_list , ]
  before_filter:check_auth  , :only => [:index, :search_api_list , ]
  def check_auth
    sign_out :admin_user if admin_info.project_info_id != -1
  end
  def index
    @api_types = ApiWebType.all
    @api_resources = ApiWebResource.all
    @project_infos = ProjectInfo.includes(:project_app).limit(20).find(:all,:order => "id desc")
    @api_cores = ApiWebInfo.where(:project_info_id => nil).order("uri_resource")
    @content_items = ApiWebInfo.where(:project_info_id => nil)
    # Rails.logger.info callApi( "content.getlistbytype" , { :sortid => 1 } ,"1.0" )
  end
  def search_api_list
    words = params[:words]
    @items = ApiWebInfo.limit(20).where("uri_resource like '%#{words}%' and (project_info_id is NULL or project_info_id='#{params[:project_info_id]}')")
    render json: @items
  end
  # 项目信息
  def get_proj_info
    result = { :success =>false }
    return render :json => result if params[:id].blank? 

    result = ProjectApp.find(params[:id])
                      .to_json( :include =>{:project_info =>{:include =>[:admin_user , :cms_sort]} } )
    render :json => result
  end
  # 项目api列表
  def get_proj_apis
    result = { :success =>false }
    return render :json => result if params[:id].blank? 
    result = ApiWebInfo.where("project_info_id = #{params[:id]}").order("uri_resource desc").all
    render :json => result
  end
# 项目触发器列表
  def get_proj_triggers
    result = { :success =>false }
    return render :json => result if params[:id].blank? 
    result = ApiWebInfoTrigger.where("project_info_id = #{params[:id]}").all
    render :json => result
  end
  def get_trigger
    result = ApiWebInfoTrigger.find(params[:id]).to_json(:include =>:api_web_info)
    render :json => result
  end
  def add_trigger
    @content_item = ApiWebInfoTrigger.new params[:trigger]
    @content_item.save
    render json: @content_item
  end
  def edit_trigger
    @content_item = ApiWebInfoTrigger.find(params[:trigger][:id])
    @content_item.update_attributes(params[:trigger])
    render json: @content_item
  end
  def remove_trigger
    @content_item = ApiWebInfoTrigger.find(params[:id])
    @content_item.destroy
    render json: {:success =>true}
  end
# 项目转发器列表
  def get_proj_resenders
    result = { :success =>false }
    return render :json => result if params[:id].blank? 
    result = ApiUriCallConfig.where("project_info_id = #{params[:id]}").all
    render :json => result
  end
  def get_resender
    result = ApiUriCallConfig.find(params[:id])
    render :json => result
  end
  def add_resender
    @content_item = ApiUriCallConfig.new params[:resender]
    @content_item.save
    render json: @content_item
  end
  def edit_resender
    @content_item = ApiUriCallConfig.find(params[:resender][:id])
    @content_item.update_attributes(params[:resender])
    render json: @content_item
  end
  def remove_resender
    @content_item = ApiUriCallConfig.find(params[:id])
    @content_item.destroy
    render json: {:success =>true}
  end
  # api信息
  def get_api_info
    result = { :success =>false }
    return render :json => result if params[:id].blank? 
    result = ApiWebInfo.find(params[:id]).to_json(:include =>:api_web_info_versions)
    render :json => result
  end
  def add_api
    @content_item = ApiWebInfo.new params[:api]
    @content_item.save
    render json: @content_item
  end
  def add_api_version
    @content_item = ApiWebInfoVersion.new params[:api_version]
    @content_item.save
    render json: @content_item
  end
  def edit_api
    @content_item = ApiWebInfo.find(params[:api][:id])
    @content_item.update_attributes(params[:api])
    render json: @content_item

  end
  def edit_api_version
    @content_item = ApiWebInfoVersion.find(params[:api_version][:id])
    @content_item.update_attributes(params[:api_version])
    render json: @content_item
  end
  def remove_api
    @content_item = ApiWebInfo.find(params[:id])
    @content_item.destroy
    render json: {:success =>true}
  end
  def remove_api_version
    @content_item = ApiWebInfoVersion.find(params[:id])
    @content_item.destroy
    render json: {:success =>true}
  end
  def get_proj_list
    words = params[:words]
    @project_infos = ProjectInfo.limit(10).where("project_num like '%#{words}%' or name like '%#{words}%' or cnname like '%#{words}%' or id like '%#{words}%' or description like '%#{words}%'")
    render json: @project_infos
  end
  # 项目信息
  def get_proj_app
    return render :json => result if params[:id].blank? 

    result = ProjectApp.where(:project_info_id => params[:id])
    render :json => result
  end
  def admin_info
    adminuserid = current_admin_user.id
    AdminUser.select("admin_users.email ,admin_users.project_info_id, project_infos.*")
    .joins(" left join project_infos on( admin_users.project_info_id = project_infos.id)").find( adminuserid )
  end
  def init_api 
    #session_clear()
    Rails.logger.info "token: "+session[:access_token].to_s
    initApp params[:appnum] if session[:appnum] != params[:appnum]
    return render :json => {:access_token => session[:access_token]}
  end
  def call_api
    result =callApi( params[:method], params ,params[:version] ,true)
    Rails.logger.info result
    return render :json => result
  end
  def pretty_json 
    render text: JSON.pretty_generate(JSON.parse(params[:json]))
  end
  ##########################################################################################
  # api wiki 用到的工具方法 - end
  ##########################################################################################
  def callApi(method , params ,version ,raw = false)
    call_id = rand(9999999999).to_s
    Rails.logger.info "call api :#{session[:api_key]}"

    sign = Digest::MD5.hexdigest "api_key=#{session[:api_key]}call_id=#{call_id}method=#{method}#{session[:api_secret]}"
    method.sub!( "." , "/" )
    options = {
        :access_token => session[:access_token],
        :api_key => session[:api_key],
        # :apiversion => version,
        :format => "json",
        :is_debug => true,
        :sig => sign,
        :call_id => call_id,
        # :method => method,
    }
    options.merge! params
    Rails.logger.info "call api (#{Rails.env.to_s} - #{request.host}) : #{session[:appnum]}.#{request.host}/api/#{version}/#{method} - #{options.inspect}"
    res = ""
    url = Rails.env.to_s == "development" ? request.host : "#{session[:appnum]}.cloudapi.nowapp.cn"
    Rails.logger.info "url: "+url

    # 上传表单    
    #require 'rest_client'
    #filename = ""
    #options.each_pair do |key ,val|
    #  if val.to_s[0,22] == "#<ActionDispatch::Http"
    #    filename = val.original_filename
    #    File.open("tmp/#{filename}", "wb") do |f|
    #      f.write(val.read)
    #    end
    #    #options[key] = File.new(val.tempfile.path)
    #    options[key] = File.new( "tmp/#{filename}" )
    #  end
    #end
    #Rails.logger.info options.to_s
    #res = RestClient.post(url+":"+request.port.to_s+"/api/#{version}/#{method}" ,options)
    #File.unlink  "tmp/#{filename}"

    Net::HTTP.start(url , request.port) do |http|
      req = Net::HTTP::Post.new("/api/#{version}/#{method}")
      req.set_form_data(options)
      res = http.request(req)
    end
    #uri = URI("http://#{url}:#{request.port}/api/#{version}/#{method}")
    #res = Net::HTTP.post_form(uri, options)
    Rails.logger.info "api res.body : #{res.body}"
    Rails.logger.info "api res : #{res.to_s}"
    result = res["content-type"].to_s.include?( "json" ) ? res.body : JSON.parse( res.body )
    # Rails.logger.info "api result :"+result
    return raw ? result : result["data"] #if !result["data"].blank?
  end

  #def each_object (form_name, obj,&fn)
  #  current = obj
  #  case   current
  #    when String || Integer
  #      fn.call form_name,current
  #
  #    when Hash
  #      current.each_pair do |key,value|
  #         key ="#{form_name}[#{key}]"
  #         each_object (key,value,*fn)
  #      end
  #    when Array
  #      current.each do |item|
  #        each_object (form_name,item,*fn)
  #      end
  #  end
  #end



  # 初始化app，获取token，（查询key和secret，device_id）
  def initApp(appnum)
    #session_clear
    if appnum.blank?
      return false
    end
    Rails.logger.info appnum.to_s
    # 获取webapp的apikey
    appinfo = ProjectInfo.joins("left join project_apps on (project_infos.id=project_apps.project_info_id)")
                          .where("project_infos.project_num = #{appnum} ")
                          .select("project_apps.api_key,project_apps.api_secret,project_apps.project_info_id").first;

    if appinfo.blank?
      return false
    end
    # 获取token
    session[:appnum] = appnum;
    session[:api_key] = appinfo.api_key;
    session[:api_secret] = appinfo.api_secret;
    session[:project_info_id] = appinfo.project_info_id;
    session[:device_number] = "webapp_"+rand(999999999).to_s
    if session[:access_token] = getToken
      Rails.logger.info "access_token: " + session[:access_token]
      return {:access_token => session[:access_token] }
    else
      return false
    end
  end

  def getToken
    method = "token"
    call_id = rand(9999999999).to_s
    sign = Digest::MD5.hexdigest "api_key=" + session[:api_key] + "call_id=" + call_id + "method=" + method + session[:api_secret]
    # Rails.logger.info "signstr:"+"api_key=" + session[:api_key] + "call_id=" + call_id + "method=" + method + session[:api_secret]
    options = {
      :grant_type => "device",
      :devicenumber => session[:device_number],
      :client_id => session[:api_key],
      :call_id => call_id,
      :method => method,
      :sig => sign
    }
    res = ""
    url = Rails.env.to_s == "development" ? request.host : "#{session[:appnum]}.cloudapi.nowapp.cn"
    Rails.logger.info "url: "+url
    Net::HTTP.start(url, request.port) do |http|
      req = Net::HTTP::Post.new("/oauth/token")
      req.set_form_data(options)
      res = http.request(req)
    end
    # result = JSON.parse( Partay.post('/oauth/token', options) )
    Rails.logger.info "get token options : "+options.to_s
    result = JSON.parse( res.body )
    Rails.logger.info "get token result : "+result.to_s
    return result["access_token"]
  end

  def get_app_info

    render :text => 'no such app' if !check_login()
    @appinfo = ProjectApp.where(:project_info_id => session[:project_info_id] , :phonetype => 'webapp').first
    @modules = getModulesInfo(session[:project_info_id])
    Rails.logger.info "modules : "+@modules.to_s

  end

  def check_login
    if (!session[:access_token].blank? && session[:appnum] == params[:appnum]) || initApp(params[:appnum])
      Rails.logger.info "login success ; session: " + session.to_s
      return true
    else
      Rails.logger.info " login error ,no such app."
      return false
    end
  end

  def session_clear
    Rails.logger.info " clear_session."
    session[:access_token] = "";
    session[:appnum] = "";
    session[:api_key] = "";
    session[:api_secret] = "";
    session[:project_info_id] = "";
    session[:device_number] = "";
  end

  ##########################################################################################
  # api wiki 用到的工具方法 - end
  ##########################################################################################
end
