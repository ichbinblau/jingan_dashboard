# encoding: utf-8
require 'fileutils'
class EceditorController < ApplicationController
  def index
    initconfig
    @dir = params[:dir] if !params[:dir].blank?
    if @dir.blank?
      @dir = cookies[:project].blank? ? "js" : cookies[:project]
    end
    @dirs = getdirfiles("")
    Rails.logger.info @dirs.inspect
  end

  def testPushServer
    require 'rubygems'
    require 'mqtt'
    require 'json'
    pushData = {
      # subscribe->{"granted":[0]}{"cmd":"subscribe","retain":false,"qos":1,"dup":false,"length":35,"subscriptions":[{"topic":"ecloud/0000112f92db1594dd6284c","qos":0}],"messageId":2}
        "device_token" => "0000112f92db1594dd6284c",
        "title" => "title",
        "badge" => 1,
        "custom"  => {
          "type" => "chat",
          "contentid" => 123123,
          "msg_type" => "msg_type",
          "sender_name" => "sender_name",
          "avatar" => "avatar",
          "image" => "image",
          "sound" => "sound",
          "content" => "content",
          "created_at" => "created_at",
        },
        "sound" => "siren.aiff",
        "siren.aiff" => Time.now + 60*60
      }.to_json

      MQTT::Client.connect('android.push.nowapp.cn',1884) do |client|
          client.publish("androidPush",pushData)
      end
  end

  def test
    # require 'simplecov-json'
    # SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
    # text = SimpleCov::Formatter::JSONFormatter '{"abc":1}'
    # SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
    # text = 

    # {"failing_features":[],"features":["  Scenario: One Failing Feature\n    When  I run cucumber -r ../../../lib -r features/step_definitions -f Cucumber::Formatter::JSON features/one_failure.feature\n    Then  the output should contain \"output['status_counts']['failed']\" set to \"1\"\n    And  the output should contain \"output['status_counts']['passed']\" set to \"1\"\n    And  the output should contain \"output['status_counts']['undefined']\" set to \"1\"\n    And  the output should contain \"output['status_counts']['pending']\" set to \"1\"\n    And  the output should contain the failing feature\n      \"\"\"\n        Scenario: Failing\n          Given failing   # features/step_definitions/steps.rb:1\n            FAIL (RuntimeError)\n            ./features/step_definitions/steps.rb:2:in `/failing/'\n            features/one_failure.feature:4:in `Given failing'\n\n      \"\"\"\n","  Scenario: Multiple Failing Features\n    When  I run cucumber -r ../../../lib -r features/step_definitions -f Cucumber::Formatter::JSON features/multiple_failures.feature\n    Then  the output should contain \"output['status_counts']['failed']\" set to \"3\"\n    And  the output should contain \"output['status_counts']['passed']\" set to \"1\"\n    And  the output should contain the failing feature\n      \"\"\"\n        Scenario: Failing\n          Given failing   # features/step_definitions/steps.rb:1\n            FAIL (RuntimeError)\n            ./features/step_definitions/steps.rb:2:in `/failing/'\n            features/multiple_failures.feature:4:in `Given failing'\n\n      \"\"\"\n    And  the output should contain the failing feature\n      \"\"\"\n        Scenario: Failing2\n          Given failing    # features/step_definitions/steps.rb:1\n            FAIL (RuntimeError)\n            ./features/step_definitions/steps.rb:2:in `/failing/'\n            features/multiple_failures.feature:7:in `Given failing'\n\n      \"\"\"\n    And  the output should contain the failing feature\n      \"\"\"\n        Scenario: Failing3\n          Given failing    # features/step_definitions/steps.rb:1\n            FAIL (RuntimeError)\n            ./features/step_definitions/steps.rb:2:in `/failing/'\n            features/multiple_failures.feature:10:in `Given failing'\n\n      \"\"\"\n","  Scenario: All Features Passing\n    When  I run cucumber -r ../../../lib -r features/step_definitions -f Cucumber::Formatter::JSON features/all_passing.feature\n    Then  the output should contain \"output['status_counts']['passed']\" set to \"2\"\n    And  the output should contain no failing features\n"],"status_counts":{"passed":35}}

  end
  def pretty_json 
    render text: JSON.pretty_generate(JSON.parse(params[:json]))
  end
  def editor
    initconfig
    @file = params[:file]
    @ext = params[:file].blank?  ? "javascript" :  File.extname(@basepath+params[:file])[1..-1]
    @ext = case @ext
            when "js" then 'javascript'
            when "rb" then 'ruby'
            when "htm" then 'html'
            else @ext
            end
    if %w{png gif bmp jpg jpeg}.include? @ext
      @str = ""
      @ext = "javascript"
      @image_url = @baseurl + params[:file]
    else
      @str = params[:file].blank?  ? "" :  IO.read( @basepath+params[:file] )
    end
    render "mobile_page" if @ext == "json" and ( @file[-10..-1] == "_page.json" or @file.split("/")[-1][0,5] == "page_" )
  end

  def downCoffee
    initconfig
    send_file "public/config/config.zip",
              :content_type => "application/zip",
              :filename => "config.zip"
  end

  def downApk
    initconfig
    send_file "public/app/apk/latest/yundongjingan.apk",
              :content_type => "application/apk",
              :filename => "yundongjingan.apk"
  end

  def downIpa
    initconfig
    send_file "public/app/yundongjingan.ipa",
              :content_type => "application/ipa",
              :filename => "yundongjingan.ipa"
  end

  def downJs
    buildProjJs params[:project]
    # 打包下载
    tmp_fname = getRandCode(10)
    tmp_file = Tempfile.new(tmp_fname)
    compress(@basepath+params[:project],tmp_file.path)
    send_file tmp_file.path ,
              :content_type => "application/zip",
              :filename => "config.zip"
  end

  def build_proj_js
    buildProjJs params[:project]
    render :json => {:success => true}
  end

  def buildProjJs(project)
    initconfig
    files_android = [
      "core-js/javascript/lib/prototype.min.js",
      "core-js/javascript/lib/system_android.js",
      "core-js/javascript/lib/core_android.js",
      "core-js/javascript/lib/log_android.js",
    ];
    files_ios = [
      "core-js/javascript/lib/prototype.min.js",
      "core-js/javascript/lib/system_ios.js",
      "core-js/javascript/lib/core_ios.js",
      "core-js/javascript/lib/log_ios.js",
    ];
    files_web = [
      "core-js/javascript/lib/prototype.min.js",
      "core-js/javascript/lib/system_web.js",
      "core-js/javascript/lib/core_web.js",
      "core-js/javascript/lib/log_web.js",
    ];

    # 读取源文件合并字符
    begin
      getdirfiles("core-js/javascript/controllers").collect{ |item| files_android.push(item[:path]);files_ios.push(item[:path]);files_web.push(item[:path]); }
      getdirfiles(project+"/javascript/controllers").collect{ |item| files_android.push(item[:path]);files_ios.push(item[:path]);files_web.push(item[:path]);}
      files_android.push("core-js/javascript/main_android.js")
      files_android.push(project+"/javascript/appconfig.json")
      files_ios.push("core-js/javascript/main_ios.js")
      files_ios.push(project+"/javascript/appconfig.json")
      files_web.push("core-js/javascript/main_web.js")
      files_web.push(project+"/javascript/appconfig.json")
      # Rails.logger.info IO.read( @basepath+project+"/javascript/appconfig.json" ) 
      str_android = ""
      str_ios = ""
      str_web = ""
      files_android.each{ |item| str_android+= IO.read( @basepath+item )+"\n" }
      files_ios.each{ |item| str_ios+= IO.read( @basepath+item )+"\n" }
      files_web.each{ |item| str_web+= IO.read( @basepath+item )+"\n" }
    rescue Exception => e
      return render :text => "#{$!}"
    end

    # 写入文件
    begin
      fh = File.new(@basepath+project+"/javascript/all_android.js", "w")
      fh.puts str_android.to_s
      fh.close
      FileUtils.cp @basepath+project+"/javascript/all_android.js", @basepath+project+"/javascript/all.js"
      fh = File.new(@basepath+project+"/javascript/all_ios.js", "w")
      fh.puts str_ios.to_s
      fh.close
      fh = File.new(@basepath+project+"/javascript/all_web.js", "w")
      fh.puts str_web.to_s
      fh.close
    rescue Exception => e
      Net::SSH.start( SITE_CONFIG["antbuild"]["localip"], SITE_CONFIG["antbuild"]["localuser"], :password=>SITE_CONFIG["antbuild"]["localpass"] ) do |session|
        session.open_channel do |channel|
          channel.on_data do |ch, data|
            Rails.logger.info data
          end
          channel.exec "chmod -R 777 #{Rails.root}/#{@basepath+project}"
          Rails.logger.info "chmod 777 -R #{Rails.root}/#{@basepath+project}"
        end
        session.loop
      end
    end
  end

  def file
    respond_to do |format|
      format.json{ render :json => getdirfiles(params[:dir])}
    end
  end

  def fileSave
    initconfig
    fh = File.new(@basepath+params[:filename], "w")
    fh.puts params[:str].to_s
    fh.close
    respond_to do |format|
      format.json{ render :json => {:success => true}}
    end
  end
  def fileRemove
    initconfig
    filename = @basepath+params[:filename]
    if File.directory? filename
      FileUtils.rm_rf(filename)
    else
      File.delete filename
    end
    respond_to do |format|
      format.json{ render :json => {:success => true}}
    end
  end
  def fileRename
    initconfig
    newname = @basepath+params[:newname]
    filename = @basepath+params[:filename]
    File.rename(filename, newname)
    respond_to do |format|
      format.json{ render :json => {:success => true}}
    end
  end
  def fileDupe
    initconfig
    newname = @basepath+params[:newname]
    filename = @basepath+params[:filename]
    FileUtils.copy(filename, newname)
    respond_to do |format|
      format.json{ render :json => {:success => true}}
    end
  end
  def fileNewfile
    initconfig
    fh = File.new(@basepath+params[:newname], "w") 
    fh.puts ""
    fh.close
    respond_to do |format|
      format.json{ render :json => {:success => true}}
    end
  end
  def fileNewfolder
    initconfig
    FileUtils.mkdir_p @basepath+params[:newname]
    respond_to do |format|
      format.json{ render :json => {:success => true}}
    end
  end
  def newProj
    initconfig
    FileUtils.mkdir_p @basepath+params[:newname]+"/config"
    FileUtils.mkdir_p @basepath+params[:newname]+"/javascript/controllers"
    respond_to do |format|
      format.json{ render :json => {:success => true}}
    end
  end


  # 初始化一些配置信息
  def initconfig
    @basepath = SITE_CONFIG['editor']['basepath']
    @baseurl = SITE_CONFIG['editor']['baseurl']
  end
end
