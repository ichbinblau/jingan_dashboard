# encoding: UTF-8
class SyncsController < ApplicationController
  before_filter:authenticate_admin_user!
  def admin_info
    AdminUser.select("admin_users.email ,admin_users.project_info_id, project_infos.*")
    .joins(" left join project_infos on( admin_users.project_info_id = project_infos.id)").find(current_admin_user.id)
  end
  def new
    Rails.logger.info params[:type].camelize.to_s
    client = OauthChina::const_get(params[:type].camelize.to_sym).new
    authorize_url = client.authorize_url
    Rails.cache.write(build_oauth_token_key(client.name, client.oauth_token), client.dump)
    Rails.cache.write(build_oauth_token_key(client.name, client.oauth_token)+"_from", params[:from])
    redirect_to authorize_url
  end
  def callback
    client = OauthChina::const_get(params[:type].camelize.to_sym).load(Rails.cache.read(build_oauth_token_key(params[:type], params[:oauth_token])))
    client.authorize(:oauth_verifier => params[:oauth_verifier])

    results = client.dump

    if results[:access_token] && results[:access_token_secret]
      weibo_type = PlugincfgOpenApi.where(:name =>params[:type]).first
      token_info = {"Params" => {
          "Token" => results[:access_token],
          "Secret" => results[:access_token_secret]
        }}
      PlugincfgOpenApisProjectInfo.new({:project_info_id=>admin_info.project_info_id,:plugincfg_open_api_id=>weibo_type[:id] , :configs =>token_info.to_json}).save
      #在这里把access token and access token secret存到db
      #下次使用的时候:
      #client = OauthChina::Sina.load(:access_token => "xx", :access_token_secret => "xxx")
      #client.add_status("同步到新浪微薄..")
      flash[:notice] = "授权成功！"
    else
      flash[:notice] = "授权失败!"
    end
    redirect_to Rails.cache.read(build_oauth_token_key(params[:type], params[:oauth_token])+"_from")

    # redirect_to root_path
  end

  def add_status
    weibo_type = PlugincfgOpenApi.where(:name =>params[:type]).first
    token_config = PlugincfgOpenApisProjectInfo.where(:project_info_id=>admin_info.project_info_id,:plugincfg_open_api_id=>weibo_type[:id] ).order("id desc").first
    if token_config
      token_info = JSON.parse(token_config[:configs])["Params"]
      client = OauthChina::Netease.load(:access_token => token_info["Token"], :access_token_secret => token_info["Secret"])
      result = client.add_status(params[:words]).response.body

    else
      result = {:errornum => 3}
    end
    respond_to do |format|
      format.json { render json:  result}
    end
  end

  private
  def build_oauth_token_key(name, oauth_token)
    [name, oauth_token].join("_")
  end
end
