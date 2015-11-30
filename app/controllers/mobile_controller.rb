# encoding: utf-8
class MobileController < ApplicationController
  def content
    @contentinfo = CmsContent.find( params[:id] )

    respond_to do |format|
      format.html
      format.json{ render :json => @contentinfo }
    end
  end
  def paegRedirect
    
  end

  def download
    @appnum = params[:appnum]
    project_info = ProjectInfo.where({:project_num => @appnum})


    if project_info.size == 0
      render text: '尚未发布此app'
      return
    end

    project = project_info[0]
    @logo_pic = project.project_logo.url
    @title = project.cnname
    @desc = project.description

    ios_apps = ProjectApp.where({project_info_id: project.id, phonetype: 'ios'})
    if ios_apps.size == 0
      @ios_url = nil
    else
      @ios_url = ios_apps.first.download_url
    end

    android_app = ProjectApp.where({project_info_id: project.id, phonetype: 'android'})
    if android_app.size == 0
      @android_url = nil
    else
      @android_url = android_app.first.download_url
    end

  end

  # a.nowapp.cn/5aSnrOV6Iy
  def codeRedirect
    return render :text => 'no code input!' if params[:code].blank?
    return render :text => 'code error!' if !codeinfo = SysCodeAction.where(:code =>params[:code]).first
    # Rails.logger.info codeinfo['is_redirect'].to_s
    return render :text => 'no action!' if codeinfo['is_redirect'].to_s!="true" || codeinfo['url'].blank?
    redirect_to codeinfo['url']
  end
end
