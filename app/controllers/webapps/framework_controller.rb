# encoding: utf-8
class Webapps::FrameworkController < ApplicationController

  def index
    @appnum = params[:appnum]
    @project_info = ProjectInfo.where( :project_num => params[:appnum] ).first
    # @appnum = "710984957"
  end

  def page_config
    return render :json => {:error => "no input"} if params[:name].blank?
    # 一般page config读取
    appcfg_path = CONFIG_WEBAPP["appcfg_path"]+params[:appnum]+"/config/"+params[:name]
    corecfg_path = CONFIG_WEBAPP["appcfg_path"]+"core-js/config/"+params[:name]
    file = File.exists?(appcfg_path) ? appcfg_path : corecfg_path
    fileStr = ""
    begin
      Rails.logger.info file.to_s
      file = File.new(file, "r")
      while (line = file.gets)
        fileStr += line
      end
      file.close
    rescue => err
        fileStr = '{"error":"no file"}'
    end
    # 自动生成index_tab的配置
    # "tabDataList": [
    # {
    #   "title": "课程介绍",
    #   "icon": "proj_activity_tab_product",
    #   "fragmentName": "ItemFragment",
    #   "fragmentString": "page_fragment_activity?sortid=914",
    #   "tag": "page_fragment_product"
    # },
    # {
    #   "title": "亲子活动",
    #   "icon": "proj_activity_tab_product/",
    #   "fragmentName": "ItemFragment",
    #   "fragmentString": "page_fragment_activity?sortid=915",
    #   "tag": "page_fragment_product"
    # },
    # {
    #   "title": "活动分享",
    #   "icon": "proj_activity_tab_map",
    #   "fragmentName": "ItemFragment",
    #   "fragmentString": "page_fragment_activity?sortid=917",
    #   "tag": "page_fragment_product"
    # },
    # {
    #   "title": "凯顿校区",
    #   "icon": "proj_activity_tab_aboutus",
    #   "fragmentName": "ItemFragment",
    #   "fragmentString": "page_fragment_activity3",
    #   "tag": "page_fragment_activit3"
    # }
    # ]
    if "page_index_tab.json" == params[:name]
      config = JSON.parse fileStr
      modules = getModulesInfo ProjectInfo.where( :project_num => params[:appnum] ).first.id
      tabDataList = []
      modules.each do |md|
        Rails.logger.info md.to_json

        pageconfig = md[:configs]["page_id"].nil? ? md[:type_configs]["page_id"] : md[:configs]["page_id"]
        Rails.logger.info pageconfig.to_json
        item = {
          :title => md[:show_name],
          :fragmentString => pageconfig.to_s % { :sortid => md[:cms_sorts].first.id , :title => md[:show_name] },
        }
        tabDataList.push item if md[:configs]["isWeiXin"]
      end
      config["controls"][1]["datasource"]["data"]["tabDataList"] = tabDataList
      fileStr = config
    end
    render :json => fileStr
  end

end
