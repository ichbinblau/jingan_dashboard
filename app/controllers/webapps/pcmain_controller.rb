class Webapps::PcmainController < ApplicationController
  def index
    get_app_info
    # 获取当前模块、分类、频道信息
    module_info = @modules.select{|v| v[:id].to_s == params[:module_id].to_s }.first
    @channels = CmsSortsPlugincfgInfos.select("cms_sorts.*").joins(" left join cms_sorts on (cms_sorts_plugincfg_infos.cms_sort_id = cms_sorts.id)").where(:plugincfg_info_id => module_info[:id]).all
    @baidu_key = CONFIG_WEBAPP['key']['ditu_baidu']
    # 获取模块的内容
    @modules_info = []
    @modules.each_with_index do | md ,index |
      if md[:tname].to_s == "product" || md[:tname].to_s == "news" || md[:tname].to_s == "coupon"|| md[:tname].to_s == "photo"
        module_tpl = "listviewTwoline"
      else
        module_tpl = "listviewOneline"
      end
      if md[:tname].to_s != "pcmain"
        mdata = {
         :module_tpl => module_tpl,
         :module_info => md,
         :datas => getModuleDatas(md[:id]) # @channels @sort_id @item_list
        }
        if mdata[:datas][:item_list].size == 1
          mdata[:datas][:item] = callApi( "content.getcontentinfo" , { :contentid =>mdata[:datas][:item_list][0]["id"] } ,"1.0" )["ContentInfo"]
        end
        @modules_info.push(mdata)
      end
    end
  end
end
