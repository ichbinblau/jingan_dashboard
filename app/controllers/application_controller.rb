# encoding: utf-8
require "browser"
class ApplicationController < ActionController::Base
  protect_from_forgery

  # 登录转向
  def after_sign_in_path_for(resource_or_scope)
    Rails.logger.info("eclogger: return_to - "+params['return_to'].to_s)
  
    sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')

    if !params['return_to'].blank?
      params['return_to']
    else
      stored_location_for(resource_or_scope) || request.referer || root_path
    end
  end

  # 登出转向
  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end


  ##########################################################################################
  # webapps 用到的
  ##########################################################################################
  def admin_info (admin_uer_id = nil)
    # Rails.logger.info "....."+session[:admin_user_id].to_s
    adminuserid = admin_uer_id || session[:admin_user_id] || current_admin_user.id
    AdminUser.select("admin_users.email ,admin_users.project_info_id, project_infos.*")
    .joins(" left join project_infos on( admin_users.project_info_id = project_infos.id)").find( adminuserid )
  end
  def getModuleDatas (module_id)
    module_info = @modules.select{|v| v[:id].to_s == module_id.to_s }.first
    main_sort = CmsSortsPlugincfgInfos.select("cms_sorts.*").joins(" left join cms_sorts on (cms_sorts_plugincfg_infos.cms_sort_id = cms_sorts.id)").where(:plugincfg_info_id => module_info[:id]).all

    # 获取模块信息、分类信息
    # module_info = PlugincfgInfo.select("plugincfg_infos.*,plugincfg_types.name as tname").joins(:plugincfg_type).find( params[:module_id] )
    # main_sort = CmsSortsPlugincfgInfos.select(" cms_sorts.* ,cms_sorts.id as id ").joins(" left join cms_sorts on (cms_sorts_plugincfg_infos.cms_sort_id = cms_sorts.id)").where(:plugincfg_info_id => module_info[:id]).order("sort_order").all
    channels = CmsSort.where(" father_id in (#{main_sort.collect {|x| x[:id] }.join(",")})").order("sort_order").all
    if channels.blank?
      channels = CmsSort.where(" id in (#{main_sort.collect {|x| x[:id] }.join(",")})").order("sort_order").all
      properties = []
    else
      properties = []
      # @properties = CmsSort.where(" father_id in (#{@channels.collect {|x| x[:id] }.join(",")}) ").order("sort_order").all
      channels.each_index do |index|
        list = CmsSort.where("father_id = '#{channels[index][:id]}'").order("sort_order").all
        if list.length > 0
          channels[index][:sort_list] = list
          properties.push( channels[index] ) 
        end
      end
    end
    sorts = {}
    if properties.blank?
      channels.each do |item|
        sorts[item[:cnname]] = item[:id]
      end
    else
      properties.each_index do |index|
        properties[index][:sort_list].each do |item|
          sorts[item[:cnname]] = item[:id]
        end
      end
    end

    sort_id = params[:sort_id].blank? ? channels.first[:id] : params[:sort_id]
    item_list = callApi( "content.getlistbytype" , { :sortid => sort_id } ,"1.0" )["ListByType"]
    return {
      :channels => channels,
      :sort_id => sort_id,
      :item_list => item_list,
    }
  end

  # 获取模块信息
  def getModulesInfo( project_id )
    modules_info = []
    modules = PlugincfgInfo.select("plugincfg_infos.*,plugincfg_types.name as tname").joins(:plugincfg_type).where(:project_info_id => project_id,"plugincfg_types.plugincfg_sort_id"=>1).all
    # Rails.logger.info "browser : "+browser.to_s
    if !modules.blank?
      modules.each do |md|
        if md[:tname].to_s != "pcmain" || !browser.mobile?
          module_info = md
          module_info.configs = JSON.parse(md[:configs]);
          module_info[:type_configs] = JSON.parse(md.plugincfg_type[:configs]);
          module_info[:cms_sorts] = md.cms_sorts;
          modules_info.push(module_info)
        end
      end
    end
    modules_info.sort_by { |v| v.configs["order"].to_s }
  end

  def callApi(method , params ,version ,raw = false)
    call_id = rand(9999999999).to_s
    Rails.logger.info "call api :#{session[:api_key]}"

    sign = Digest::MD5.hexdigest "api_key=#{session[:api_key]}call_id=#{call_id}method=#{method}#{session[:api_secret]}"
    method.sub!( "." , "/" )
    options = {
      :body => {
        :access_token => session[:access_token],
        :api_key => session[:api_key],
        # :apiversion => version,
        :format => "json",
        :sig => sign,
        :call_id => call_id,
        # :method => method,
      }
    }
    options[:body].merge! params
    Rails.logger.info "call api : /api/#{version}/#{method} - #{options.inspect}"
    res = Partay.post("/api/#{version}/#{method}", options)
    Rails.logger.info "api res : #{res}"
    result = res.headers["content-type"].include?( "json" ) ? res : JSON.parse( res.to_s )
    Rails.logger.info "api result :"+result.inspect
    return raw ? result : result["data"] if !result["data"].blank?
  end

  # 初始化app，获取token，（查询key和secret，device_id）
  def initApp(appnum)
    if appnum.blank?
      return false
    end
    # 获取webapp的apikey
    appinfo = ProjectInfo.joins("left join project_apps on (project_infos.id=project_apps.project_info_id)")
    .where("project_infos.project_num = #{appnum} and project_apps.phonetype='webapp'")
    .select("project_apps.api_key,project_apps.api_secret,project_apps.project_info_id").first;
    # Rails.logger.info "appinfo: " + appinfo.to_s

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
      return true
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
      :body => {
        :grant_type => "device",
        :devicenumber => session[:device_number],
        :client_id => session[:api_key],
        :call_id => call_id,
        :method => method,
        :sig => sign
      }
    }
    result = JSON.parse( Partay.post('/oauth/token', options).to_s )
    Rails.logger.info "get token options : "+options.to_s
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
  # webapps 用到的 - end
  ##########################################################################################

  # 压缩文件夹
  def compress(path, archive = nil, excludes = [], suffixes= [])
    require 'zip/zip'
    require 'zip/zipfilesystem'

    path.sub!(%r[/$],'')
    archive = File.join(path,File.basename(path))+'.zip' if archive.nil?
    FileUtils.rm archive, :force=>true

    excludes = excludes.collect {|x| path + '/' + x }

    Zip::ZipFile.open(archive, 'w') do |zipfile|
      Dir["#{path}/**/{*,.*}" ].reject{|f| f==archive || suffixes.any? {|s|f.end_with?(s)} || excludes.any? {|r|f.index(r)==0} }.each do |file|
        zipfile.add(file.sub(path+'/',''),file)
      end
    end
  end
  def get_file_contents( url , path )
    uri = URI(url)
    http = Net::HTTP.new(uri.host)
    http.start() { |http|
     req = Net::HTTP::Get.new(uri.path+"?"+uri.query)
     response = http.request(req)
     # tempfile = Tempfile.new(path)
     # tempfile = File.new(path)
     # tempfile.binmode
     # Rails.logger.info response.body
     File.open(path,'w') do |f|
       f.binmode
       f.write response.body
     end
     # return response.body
     # attachment = Attachment.new(:uploaded_data => LocalFile.new(tempfile.path))
     # attachement.save
  }
  end
  ##########################################################################################
  # admins 用到的
  ##########################################################################################

  def app_module_info
    @admin_info = admin_info
    # 获取模块信息、分类信息
    @module_info = PlugincfgInfo.select("plugincfg_infos.*,plugincfg_types.name as tname").joins(:plugincfg_type).find( params[:module_id] )
    @field_configs = JSON.parse @module_info.configs
    
    @main_sort = CmsSortsPlugincfgInfos.select(" cms_sorts.* ,cms_sorts.id as id ").joins(" left join cms_sorts on (cms_sorts_plugincfg_infos.cms_sort_id = cms_sorts.id)").where(:plugincfg_info_id => @module_info[:id]).order("sort_order").all
    if @main_sort.size > 0
      @main_sortid = @main_sort.first[:id]
      default_sort_id = 0
      @channels = CmsSort.where(" father_id in (#{@main_sort.collect {|x| x[:id] }.join(",")})").order("sort_order").all
      if @channels.blank?
        @channels = CmsSort.where(" id in (#{@main_sort.collect {|x| x[:id] }.join(",")})").order("sort_order").all
        @properties = []
      else
        @properties = []
        # @properties = CmsSort.where(" father_id in (#{@channels.collect {|x| x[:id] }.join(",")}) ").order("sort_order").all
        @channels.each_index do |index|
          list = CmsSort.where("father_id = '#{@channels[index][:id]}'").order("sort_order").all
          if list.length > 0
            @channels[index][:sort_list] = list
            @properties.push( @channels[index] )
          end
        end
      end
      @sorts = {}
      if @properties.blank?
        @channels.each do |item|
          @sorts[item[:cnname]] = item[:id].to_s
          default_sort_id = item[:id].to_s if 0 == default_sort_id
        end
      else
        @properties.each_index do |index|
          @properties[index][:sort_list].each do |item|
            @sorts[item[:cnname]] = item[:id]
            default_sort_id = item[:id].to_s if 0 == default_sort_id
          end
        end
      end
      
      @sort_id = params[:sort_id].blank? ? default_sort_id : params[:sort_id]
    end
    
    @baidu_key = CONFIG_WEBAPP['key']['ditu_baidu']
  end
  ##########################################################################################
  # 文件操作
  ##########################################################################################
  def getdirfiles (inpath = nil)
    # 设置初始值
    initconfig
    if inpath.blank?
      nowpath = @basepath
    else
      nowpath = @basepath + inpath +"/"
    end
    # 循环目录
    files = []
    Dir.foreach(nowpath) do |file|
      if file[0,1] != '.'
        fileinfo = { }
        fileinfo[:path] = inpath + "/" + file
        fileinfo[:isdir] = File.directory?(nowpath+file)
        fileinfo[:size] = File.size?(fileinfo[:path])
        fileinfo[:name] = file.to_s
        fileinfo[:ext] = File.extname(file)[1..-1] if !fileinfo[:isdir]
        files.push( fileinfo )
      end
    end
    files.sort_by! {|a| a[:name]}
    return files
  end
  def get_file_contents( url , path )
    uri = URI(url)
    http = Net::HTTP.new(uri.host)
    http.start() { |http|
      req = Net::HTTP::Get.new(uri.path+"?"+uri.query)
      response = http.request(req)
      # tempfile = Tempfile.new(path)
      # tempfile = File.new(path)
      # tempfile.binmode
      # Rails.logger.info response.body
      File.open(path,'w') do |f|
        f.binmode
        f.write response.body
      end
      # return response.body
      # attachment = Attachment.new(:uploaded_data => LocalFile.new(tempfile.path))
      # attachement.save
  }
  end
  def getRandCode(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""  
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }  
    return newpass
  end

  # 新的webapp与老的链接规则不同
  def check_mobileapp_redirect(mid)
    if @appinfo.id >= 225
      md = PlugincfgInfo.select("plugincfg_infos.*,plugincfg_types.name as tname").joins(:plugincfg_type).find(mid)
      module_info = md
      module_info.configs = JSON.parse(md[:configs]);
      module_info[:type_configs] = JSON.parse(md.plugincfg_type[:configs]);
      module_info[:cms_sorts] = md.cms_sorts;
      md = module_info
      # Rails.logger.info md.to_json
      pageconfig = md[:configs]["page_id"].nil? ? md[:type_configs]["page_id"] : md[:configs]["page_id"]
      # Rails.logger.info (url_for controller:'framework' , action: 'index')+'#'+pageconfig.to_s % { :sortid => md[:cms_sorts].first.id , :title => md[:show_name] }
      return (url_for controller:'framework' ,action: 'index')+'#'+pageconfig.to_s % { :sortid => md[:cms_sorts].first.id , :title => md[:show_name] }
    end
  end
end
  ##########################################################################################
  # admins 用到的 - end
  ##########################################################################################


class Partay
  include HTTParty
  base_uri CONFIG_WEBAPP['api_url']
end
