class Webapps::ShopController < ApplicationController
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

    # 如果只有1条记录，则直接到show模块显示内容
    if !@item_list.blank? && @item_list.size == 1
      params[:contentid] = @item_list[0]["id"]
      return show
    end

    @item_list.each do |item|
      item["abstracts"] = item["address"]
    end
  end
  def show
    get_app_info
    @baidu_key = CONFIG_WEBAPP['key']['ditu_baidu']
    @item_info = callApi( "content.getcontentinfo" , { :contentid =>params[:contentid] } ,"1.0" )["ContentInfo"]
    render "webapps/shop/show"

  end
end
