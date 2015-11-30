# encoding: utf-8
class Admins::ToolsQrcodeController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    100
  end
  def index
    params[:per_page] = perpage if params[:per_page].blank?
    @code_infos = SysCodeAction.paginate(:page => params[:page], :per_page => params[:per_page])
  end
  def save_action
    @code_info = SysCodeAction.find(params[:id])
    content_info = CmsContent.find(params[:contentid])
    @code_info.data = "ecct://content/getcontentinfo?contentid=#{content_info.id}"
    @code_info.value = content_info.id
    @code_info.save
    # Rails.logger.info @code_info.id.inspect
    respond_to do |format|
      format.json{ render :json => @code_info }
    end
  end
  def show
    @code_info = SysCodeAction.find(params[:id])
    respond_to do |format|
      format.json{ render :json => @code_info }
    end
  end

  def add
    is_redirect = params[:url].blank? ? "0" : "1"
    i = 0;
    while i < params[:num].to_i  do
      code = SysCodeAction.new(:code => getRandCode(10),:batch_value=>params[:batch_value],:project_info_id=>params[:project_info_id] ,
        :enabled=>params[:enabled],:url => params[:url] , :is_redirect => is_redirect )
      code.save
      i+=1
    end
    respond_to do |format|
      format.json{ render :json => {} }
    end
  end

  def getRandCode(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""  
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }  
    return newpass
  end

  def download
    tmp_fname = getRandCode(10)
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = "1" if params[:page].blank?
    Rails.logger.info params[:page].inspect
    Rails.logger.info params[:per_page].inspect
    @code_infos = SysCodeAction.paginate(:page => params[:page], :per_page => params[:per_page])
    cache_dir = "./tmp/"+tmp_fname
    if ::File.exists?(cache_dir) == false || ::File.directory?(cache_dir) == false
      Dir.mkdir(cache_dir)
    end
    @code_infos.each do |code|
      get_file_contents("http://cs.hudongka.com/?level=L&size=10&border=1&data=http://a.nowapp.cn/"+code.code,cache_dir+"/"+code.id.to_s+"_"+code.code+".png").to_s
      # render :text => true
    end
    tmp_file = Tempfile.new(tmp_fname)
    compress(cache_dir,tmp_file.path)
    send_file tmp_file.path ,
              :content_type => "application/zip",
              :filename => "#{tmp_fname}.zip"
    FileUtils.rm_rf(cache_dir)
  end
end
