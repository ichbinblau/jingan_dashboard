class Webapps::PhotoController < ApplicationController
  def index
    get_app_info
    if url = check_mobileapp_redirect(params[:module_id])
      return redirect_to url
    end  
    # 获取当前模块、分类、频道信息
    module_datas = getModuleDatas(params[:module_id])
    @channels = module_datas[:channels]
    @sort_id = module_datas[:sort_id]
    @item_list = module_datas[:item_list]
  end
  def show
    get_app_info
    # 获取当前模块、分类、频道信息
    @sort_id = params[:sort_id]
    @channel_info = CmsSortsPlugincfgInfos.select("cms_sorts.*").joins(" left join cms_sorts on (cms_sorts_plugincfg_infos.cms_sort_id = cms_sorts.id)").where(:cms_sort_id =>@sort_id).first

    @item_info = callApi( "content.getcontentinfo" , { :contentid =>params[:contentid] } ,"1.0" )["ContentInfo"]
    if @item_info["imgList"].nil?
      @item_info["imgList"] = [{
                             "image" => @item_info["ImageCover"],
                             "description" => @item_info["Title"]
      }]
    end
  end
end
