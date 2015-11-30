# encoding: utf-8
require 'time'
require "open-uri"
require File.expand_path('../../../lib/web_api_tools/api_call_helper', __FILE__)
require File.expand_path('../../../lib/request_context', __FILE__)

class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  around_filter :request_context
  #class alias
  T = WebApiTools::ApiCallHelper

  # error code
  ERROR_CODE_SERVER=3
  ERROR_CODE_NOT_FIND=1103011
  ERROR_CODE_FIELD_VALID=110001
  ERROR_COD_FIELD_EMPTY_OR_NULL=110201
  ERROR_COD_FIELD_TYPE=110202

  # To change this template use File | Settings | File Templates.
  @@method_regex = /(?<version>[\d\._\/]+)?(?<method>(?<resource>.+)[.\/](?<name>[^\/.]+))/
  @@url_regex =/(?<version>[\d_\.]+)?[\/]?(?<method>(?<resource>.+)[\/.](?<name>[^\/.]+))/
  @@test_method_regex = /^[\d.\/]+/
  @@proxy_address = "http://211.138.248.114" #'http://callback.api.nowapp.cn'
  # @@proxy_address = "http://api.nowapp.cn" #'http://callback.api.nowapp.cn'

  #动态执行的委托列表
  @@eval_delegates_cache = {}


  def request_context
    begin
      RequestContext.begin_request
      yield
    ensure
      RequestContext.end_request
    end
  end


  def index
    url_value = params[:url_value]
    if url_value.blank?
      render :json => "not find"
      return
    end

    exec_time_start, url_source, f, ex = Time.now, request.path, request.POST, nil

    if url_source.index("/oauth/token")==0
      # to_proxy("/oauth/token")
      token
      return
    elsif url_source.index("/api")==0
      errorMsg, apiInfoM, apiVersion, apiMethod = T.url_parse_api_info(url_value, f)

      if apiInfoM.nil?
        to_proxy(url_source, url_value, apiVersion, apiMethod)
        return
      end

      apiKey, sig, accessToken, callId = f[:api_key], f[:sig], f[:access_token], f[:call_id]
      execM, error=nil, nil
      begin
        apiM, user_entity = apiInfoM.api_web_info, WebApiTools::OauthUserEntity.new(:access_token => accessToken)
        #身份验证
        if apiM.is_authorization !=false
          raise "api_key not found" if (projectAppM = ProjectApp.where("api_key=?", apiKey).first).nil?
          raise "sig验证错误"+apiMethod if generation_sign(apiKey, callId, apiMethod, projectAppM.api_secret)!=sig
          user_entity.project_info_id, user_entity.project_app_id= projectAppM.project_info_id, projectAppM.id

          oauthTokenM = UserOauthTokenOrder.where("access_token=?", accessToken).first
          raise "oauth token not found" if  oauthTokenM.nil?
          user_entity.device_id, user_entity.user_info_id= oauthTokenM.user_device_id, oauthTokenM.user_info_id
        else
          user_entity.device_id, user_entity.user_info_id = 0 , 0
        end

        execM =T.create_exec_entity(apiInfoM.api_web_info_version[:is_traces])
        execM[:logger] = logger

        #存储上下文 这样可以全局使用
        rc = RequestContext.instance
        rc.exec_entity, rc.params, rc.user_entity, rc.api_entity =execM, f, user_entity, apiInfoM

        # Rails.logger.info "---------------"+execM.to_json
        # Rails.logger.info "---------------"+f
        # Rails.logger.info "---------------"+user_entity
        # Rails.logger.info "---------------"+apiInfoM
        data = T.call_api_by_entity(execM, f, user_entity, apiInfoM)

          #rescue Exception => e
          #  fn= cache_Object[:fn]
          #  error, ex  = {:error_num => ERROR_CODE_SERVER, :error_msg =>e.message},e
          #  logger.error e.message+'\r\n'+  e.backtrace.join('\r\n')
          #ensure

      rescue Exception => e
        error, ex = {:error_num => ERROR_CODE_SERVER, :error_msg => e.message}, e
        logger.error e.message+'\r\n'+ e.backtrace.join('\r\n')
      ensure


      end


      begin
        if !execM.nil?

          #单位 毫秒
          exec_time_span =(Time.now-exec_time_start)*1000
          if accessToken.blank? || accessToken.nil?
            accessToken = "null"
          end
          logM= SysApiCallLog.new(
              :method => apiMethod,
              :api_version => apiVersion,
              :params => request.POST.inspect,
              :error_num => "",
              :error_msg => "",
              :ip_address => request.remote_ip,
              :exec_millisecond => exec_time_span,
              :access_token => accessToken,
          )


          if user_entity.nil? || user_entity.project_app_id.nil?
            logM[:project_app_id], logM[:project_info_id], logM[:user_info_id] = 0 , 0 , 0
          else
            logM[:project_app_id], logM[:project_info_id], logM[:user_info_id] = user_entity.project_app_id, user_entity.project_info_id, user_entity.user_info_id 
          end

          error = execM[:errors][0] if !execM[:errors].nil? && execM[:errors].length>0
          logM[:error_msg], logM[:error_num] = error[:error_msg], error[:error_num] if !error.nil?

          logM[:exec_trace]= execM[:traces].to_json if execM[:traces].length>0
          logM[:exec_result]=""
          #logM[:exec_result]= execM[:result].to_json
          
          logM.save
        end
      rescue Exception => e
        error, ex = {:error_num => ERROR_CODE_SERVER, :error_msg => e.message}, e
        logger.error e.message+'\r\n'+ e.backtrace.join('\r\n')
      end


      apiInfoM.api_web_info_version[:is_traces]

      form_data = {}
      request.POST.each do |key, value|
        if "ActionDispatch::Http::UploadedFile" == value.class.to_s
          form_data[key]=value.inspect
        else
          # if "ActiveSupport::HashWithIndifferentAccess" == value.class.to_s
          #   Rails.logger.info value.class.to_s
          #   value.each do |key1 ,value1|
          #     if "ActionDispatch::Http::UploadedFile" == value1.class.to_s
          #       form_data[key][key1.to_sym] = value1.inspect
          #     else
          #       Rails.logger.info key
          #       Rails.logger.info key1

          #       form_data[key][key1.to_s] = value1
          #     end
          #   end
          # else
            form_data[key] = value
          # end
        end
      end
      output ={
          :source => "rails",
          :apiVersion => apiVersion,
          :method => apiMethod,
          :context => f[:context],
          :params => form_data,
          :duration => exec_time_span,
          :id => 0,
          :data => nil,
          :success => error.nil?,
          :time => Time.now.to_s,
          :auth => apiM.is_authorization
      }

      unless  execM.nil?
        if apiInfoM.api_web_info_version[:is_traces] || f[:is_debug]
          output[:traces]= execM[:traces]
          output[:user_info_id]= user_entity.user_info_id unless user_entity.nil?
        end
      end



      if !ex.nil? && f[:is_debug]
        output[:exception] = ex.message+'\r\n'+ ex.backtrace.join('\r\n')
      end

      unless   apiInfoM.nil?

        #api_web_info_version
        apiVersionM = apiInfoM.api_web_info_version

        output[:main_version], output[:sub_version] =apiVersionM.main_version, apiVersionM.sub_version
      end


      if !error.nil?
        output[:errors] = [error]

      elsif !logM.nil? && !logM[:log_error].nil?
        output[:errors] = [logM[:log_error]]
        output[:success] = false
      end

      output[:data] = data if error.nil? && !data.nil?
      render :json => output
    end
  end


  private

  def to_proxy (rawUrl="/api/", url_value=nil, version="", method="", appendForm={})

    toUrl= @@proxy_address+rawUrl
    # toUrl= @@proxy_address

    #request.content_type
    form_data = {}
    request.POST.each do |key, value|
      form_data[key]=value
    end
    # form_data["apiversion"]=version
    # form_data["method"]=method

    if !appendForm.nil?
      appendForm.each do |key, value|
        form_data[key]=value
      end
    end

    logger.info("to_proxy->toURL:"+toUrl)
    logger.info("to_proxy->postData:"+request.POST.to_json)

    uri = URI(toUrl)
    res = Net::HTTP.post_form(uri, form_data)
    logger.info("to_proxy->post_form.res: "+ res.to_json)
    logger.info("to_proxy->post_form.res.body: "+res.body)
    render :text => res.body
  end


  def generation_sign apiKey, callId, method, apiSecret
    str = "api_key=#{apiKey}call_id=#{callId}method=#{method}#{apiSecret}"
    md5_value = Digest::MD5.hexdigest(str)
    logger.info("generation_sign=> str: #{str}  md5: #{md5_value} ")
    md5_value
  end


  def token
    f = request.POST

    grant_type, client_id, sig, call_id, api_method, push_apn_token, device_number = f["grant_type"], f["client_id"], f["sig"], f["call_id"], f["method"], f["push_apn_token"], f["devicenumber"]
    begin

      logger.info("token=> api_method:#{api_method} ")
      logger.info("token=> params:#{f.to_json} ")

      throw "not find method" if api_method!="token"
      projectAppM = ProjectApp.where("api_key=? ", client_id,).first
      throw "not find app" if projectAppM.nil?
      throw "not set app" if projectAppM.api_secret.blank?
      throw "sign check error" if generation_sign(client_id, call_id, api_method, projectAppM.api_secret)!= sig

      is_login = 0
      case grant_type
        when "device"
          #getDeviceToken(push_apn_token,device_number, "", "", projectAppM )
          deviceM = UserDevice.where("device_num=?", device_number).first


          if deviceM.nil?
            deviceM = UserDevice.new(:type => 1, :device_num => device_number, :moble_model => params[:moble_model]||'', :os_type => params[:os_type]||'' , :os_version => params[:os_version]||'', :created_at => Time.now)
            deviceM.save
          end
          userDeviceM=UserDevicesUserInfo
          .joins("LEFT join  user_infos on  user_devices_user_infos.user_info_id=user_infos.id")
          .where("user_devices_user_infos.user_device_id=? and user_infos.project_info_id=?", deviceM.id, projectAppM.project_info_id)
          .select("user_devices_user_infos.*").first

          # 无论有没有这个设备，获取新token的时候都新生成用户
          # if userDeviceM.nil?
          userInfoM = UserInfo.new(:project_info_id => projectAppM.project_info_id, :user_group_id => 1, :user_role_id => 1, :nickname => "", :created_at => Time.now)
          userInfoM.save
          userDeviceM = UserDevicesUserInfo.create(:user_device_id => deviceM.id, :user_info_id => userInfoM.id)
          userDeviceM.save
          # else
          #   userInfoM = UserInfo.find(userDeviceM.user_info_id)

          # end

          if !push_apn_token.blank?
            push_android_token=''
            ActiveRecord::Base.connection.execute("update user_infos set push_apn_token='' where push_apn_token='#{push_apn_token}' ")
          else
            #23位
            token = Digest::MD5.hexdigest("#{projectAppM.id}#{userInfoM.id}#{Time.now}")
            push_android_token = (projectAppM.project_info_id.to_s + token.to(15)).rjust(23, "0")
            ActiveRecord::Base.connection.execute("update user_infos set push_android_token='' where push_android_token='#{push_android_token}'")
          end

          userInfoM.push_apn_token= push_apn_token
          userInfoM.push_android_token= push_android_token
          userInfoM.save


          oauthToken = UserOauthTokenOrder.create(:user_info_id => userInfoM.id, :project_app_id => projectAppM.id, :user_device_id => userDeviceM.id, :access_token => token, :expiresin => 87063, :created_at => Time.now)
          oauthToken.save
        # end
        when "new_user"

          deviceM = UserDevice.where("device_num=?", device_number).first


          if deviceM.nil?
            deviceM = UserDevice.new(:type => 1, :device_num => device_number, :moble_model => params[:moble_model]||'', :os_type => params[:os_type]||'' , :os_version => params[:os_version]||'', :created_at => Time.now)
            deviceM.save
          end

          #userDeviceM=UserDevicesUserInfo
          #.joins("LEFT join  user_infos on  user_devices_user_infos.user_info_id=user_infos.id")
          #.where("user_devices_user_infos.user_device_id=? and user_infos.project_info_id=?", deviceM.id,projectAppM.project_info_id)
          #.select("user_devices_user_infos.*").first




          userInfoM = UserInfo.new(:project_info_id => projectAppM.project_info_id, :user_group_id => 1, :user_role_id => 1, :nickname => "", :created_at => Time.now)
          userInfoM.save

          userDeviceM = UserDevicesUserInfo.create(:user_device_id => deviceM.id, :user_info_id => userInfoM.id)
          userDeviceM.save

          if !push_apn_token.blank?
            push_android_token=''
            ActiveRecord::Base.connection.execute("update user_infos set push_apn_token='' where push_apn_token='#{push_apn_token}' ")
          else
            #23位
            token = Digest::MD5.hexdigest("#{projectAppM.id}#{userInfoM.id}#{Time.now}")
            push_android_token = (projectAppM.project_info_id.to_s + token.to(15)).rjust(23, "0")
            ActiveRecord::Base.connection.execute("update user_infos set push_android_token='' where push_android_token='#{push_android_token}'")
          end
          userInfoM.push_apn_token= push_apn_token
          userInfoM.push_android_token= push_android_token
          userInfoM.save

          oauthToken = UserOauthTokenOrder.create(:user_info_id => userInfoM.id, :project_app_id => projectAppM.id, :user_device_id => userDeviceM.id, :access_token => token, :expiresin => 87063, :created_at => Time.now)
          oauthToken.save

        when "password"
          user_name, password=f["username"], f["password"]
          password = Digest::MD5.hexdigest(password)
          userM = UserInfo.where("name=? and  password=?").first
          if userM.nil?
            throw "not such user"
          else
            oauthToken = UserOauthTokenOrder.new(:user_info_id => userM.id, :project_app_id => projectAppM.id, :user_device_id => device_number, :access_token => token, :expiresin => 87063, :created_at => Time.now)
            oauthToken.save
            is_login=1
          end
      end
      render :json => {:access_token => token, :push_android_token => push_android_token , :expires_in => 87063, :is_loging => is_login, :refresh_token => 0, :scope => 0}

    rescue Exception => e

      logger.error e.message
      logger.error e.backtrace.join("\n")
      render :json => {:Error => e.to_s+"\r\n"+e.backtrace.join("\n")}
    ensure

    end


  end


end
