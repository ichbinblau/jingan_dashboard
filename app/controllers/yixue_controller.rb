# encoding: utf-8
class YixueController < ApplicationController
  before_filter :get_appinfo
  # 考试题目界面
  def subject
    if (params[:sort_id].blank? && params[:father_id].blank?) || !params[:father_id].blank?
      params[:father_id] = @project_cfg["subjects_sort"]["sort_id"] if params[:sort_id].blank? && params[:father_id].blank?
      subject_sorts
    else
      @counts = NewsContent.select("count(*)").joins(:cms_sorts).where(cms_sorts: { id: [params[:sort_id]] } ).first["count(*)"]
      render action: "subjects"
    end
  end

  def subject_sorts
    @sorts = CmsSort.where(:father_id => params[:father_id])
    respond_to do |format|
      format.html { render action: "subject_sorts" }
      format.json { render json: @sorts }
    end
  end

  def subjects
    # 处理参数
    params[:perpage] = 10 if params[:perpage].blank?
    params[:page] = 1 if params[:page].blank?
    offset = params[:perpage].to_i * (params[:page].to_i - 1)
    limit = params[:perpage]
    items = NewsContent.joins(:cms_sorts).where(cms_sorts: { id: [params[:sort_id]] } ).limit(limit).offset(offset)
    # 处理、格式化结果
    order = "ABCDEFGHIJKL"
    @subjects = items.collect do |item|
      t = JSON.parse item.content
      t[:subject] = item.title
      options = t["options"]
      t["options"] = {}
      options = options.split("\n")
      # t["options"] = options
      options.each_with_index.map{|v,k| t["options"][order[k]] = v.strip }
      t[:id] = item.id
      t[:des] = item.abstract
      t
    end
    respond_to do |format|
      format.json { render json: @subjects }
    end
  end


  def news
    if !params[:item_id].blank?
      @news = NewsContent.find params[:item_id]
      @sort_id = params[:sort_id]
      render :news_item
    elsif !params[:sort_id].blank?
      @sort = CmsSort.find params[:sort_id]
      @news = NewsContent.includes(:cms_sorts).where cms_sorts: { id: [ params[:sort_id] ] }
      render :news_list
    else
      @sorts = CmsSort.where(:father_id => @project_cfg["news_sort"]["sort_id"])
    end
  end

  def trainshow
    user = UserInfo.find session[:user_id]
    user_config = {"buy_sort_id" => []}
    user_config = JSON.parse(user.description) unless user.description.blank?
    @sign_config = @project_cfg["train_sorts"][params[:sign].to_s]
    sign_sorts = @sign_config["sub_sort_ids"]
    @sorts_select = CmsSort.where(:id => sign_sorts)
    Rails.logger.info "......"+sign_sorts.to_json
    Rails.logger.info "......"+user_config["buy_sort_id"].to_json
    if !user_config["buy_sort_id"].nil? && user_config["buy_sort_id"].size > 0
      sign_sorts.each do |item|
        if user_config["buy_sort_id"].include? item
          return redirect_to "/#{params[:appnum]}/yixue/subject?&father_id=#{item}"
        end
      end
    end
  end
  def check_code
    action = SysCodeAction.where(:code => params[:code],:enabled => true).first
    if !action
      return render :json => {:success => false , :msg =>"验证码有误，请核对"}
    end
    sort = CmsSort.where :father_id => action.data , :id => params[:sort_id] 
    if sort.blank?
      return render :json => {:success => false , :msg =>"验证码权限有误，请核对！"}
    end
    action.enabled = false
    action.save
    user = UserInfo.find session[:user_id]
    user_config = {"buy_sort_id" => []}
    user_config = JSON.parse(user.description) unless user.description.blank?
    user_config["buy_sort_id"].push params[:sort_id].to_i
    user.description = user_config.to_json
    user.save
    render :json => {:success => true}
  end
  def fake_login
    user = UserInfo.where( :push_android_token => params[:weixin_id],  :project_info_id => @projectinfo.id )
    if user.blank?
      newuser = { :project_info_id =>  @projectinfo.id , :push_android_token => params[:weixin_id] }
      user = UserInfo.new newuser
      user.save
    else
      user = user.first
    end
    session[:user_id] = user.id
    redirect_to "/#{params[:appnum]}/yixue/trainshow?&sign=#{params[:sign]}"
    # render :json => user.to_json
  end

  def get_appinfo
    unless params[:appnum].blank?
      @projectinfo = ProjectInfo.where( :project_num => params[:appnum] ).first
      @project_cfg = JSON.parse @projectinfo.app_config
    end
  end
  # ========================================
  def train
  	init_api
    # Rails.logger.info callApi "content/sorts",{}, "1.0"
    @configs = {
      "1" => {
        :title => "顺序练习",
      },
      "2" => {
        :title => "随机练习",
      },
      "3" => {
        :title => "章节练习",
      },
      "4" => {
        :title => "我的收藏",
      },
      "5" => {
        :title => "我的错题",
      },
    }
    render :layout => "yixuebs"
  end

  def review
    params[:type] = 4 if params[:type] = 1
    params[:type] = 5 if params[:type] = 2
  	train
  end

  def init_api 
    #session_clear()
    params[:appnum] = "866386381"
    session_clear if session[:appnum] != params[:appnum]
    Rails.logger.info "token: "+session.to_s
    initApp params[:appnum] if session[:appnum] != params[:appnum]
    # return render :json => {:access_token => session[:access_token]}
  end

  def call_api
    # init_api
    Rails.logger.info "session:"+session.to_json
    result = callApi( params[:method], params ,params[:version] ,true)
    return render :json => result
  end

  ##########################################################################################
  # api wiki 用到的工具方法 - end
  ##########################################################################################
  def callApi(method , params ,version ,raw = false)
    call_id = rand(9999999999).to_s
    # Rails.logger.info "call api :#{session[:api_key]}"

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
    Rails.logger.info "call api (#{Rails.env.to_s} - #{request.host}) : #{session[:appnum]}.#{request.host}:#{request.port}/api/#{version}/#{method} - #{options.inspect}"
    res = ""
    url = Rails.env.to_s == "development" ? request.host : "#{session[:appnum]}.cloudapi.nowapp.cn"
    # Rails.logger.info "url: "+url

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
      Rails.logger.info "session: "+session.to_s
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