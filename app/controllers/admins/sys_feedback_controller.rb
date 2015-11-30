# encoding: utf-8
class Admins::SysFeedbackController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end

  def index
    app_module_info
    # 内容列表
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?
    search = " project_info_id = #{admin_info.project_info_id}"
    search += " and (content like '%#{params[:words]}%' or contact_info like '%#{params[:words]}%')" if !params[:words].blank?

    print "Hello, ", search
    print "Hello, ", search
    # Rails.logger.info joins.inspect
    @content_items = CmsContentFeedback
    .where( search )
    .order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupon_contents ,json:@title_item}
    end



  end

  def show
    @content_item = CmsContentFeedback.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def new
    app_module_info
    search = " project_info_id = #{admin_info.project_info_id}"
    @title_item = ActApply.where( search )
    @content_item = CmsContentFeedback.new
    @content_item.project_info_id = admin_info.project_info_id
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def edit
    app_module_info
    search = " project_info_id = #{admin_info.project_info_id}"
    @title_item = ActApply.where( search )
    @content_item = CmsContentFeedback.find(params[:id])
    @content_item.project_info_id = admin_info.project_info_id

  end

  def create
    app_module_info
    @content_item = CmsContentFeedback.new(params[:cms_content_feedback])
    @content_item.project_info_id = admin_info.project_info_id
    respond_to do |format|
      if @content_item.save
        format.html { redirect_to url_for :action =>"index",:sort_id=>params[:sort_id], notice: '添加成功.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    require "resque"
    app_module_info
    @content_item = CmsContentFeedback.find(params[:cms_content_feedback][:id])
    respond_to do |format|
      if @content_item.update_attributes(params[:cms_content_feedback])
        if  params[:cms_content_feedback][:is_comment] == "1"
          #android推送
            args = {}
            appinfo = ProjectApp.select("id").where(:project_info_id =>admin_info.project_info_id);

            # contents
            user = UserInfo.find(params[:cms_content_feedback][:user_info_id])
            args[:title] = params[:cms_content_feedback][:comment_info]
            args[:token] = user.push_android_token
            args[:contentid] = params[:cms_content_feedback][:id]
            args[:des] = params[:cms_content_feedback][:comment_info]
            # Rails.logger.info args.to_json
            Resque.enqueue(PushAndroid, args)
            # pushData = {
            #       "device_token" => args[:token],
            #       "title" => args[:title],
            #       "badge" => 1,
            #       "custom"  => {
            #           "contentid" => args[:contentid],
            #           "content" => args[:des]
            #       },
            #       "sound" => "siren.aiff",
            #       "siren.aiff" => Time.now + 60*60
            #   }.to_json
            #   Rails.logger.info("eclogger:push_android_token:"+user.push_android_token)

            #   MQTT::Client.connect('android.push.nowapp.cn' ,1884) do |client|
            #     client.publish("androidPush",pushData)
            #   end


          #def apn_push
          #  # 苹果apn推送服务
          #  # puts "setup_cafterinfo......................................................................"
          #  args = {}
          #  appinfo = ProjectApp.select("id ,apn_sandbox_key").where(:project_info_id =>admin_info.project_info_id);
          #  args[:pem] = "public/uploads/project_app/apn_sandbox_key/"+appinfo[0][:id].to_s+"/"+appinfo[0][:apn_sandbox_key].to_s
          #  # contents
          #  args[:title] = params[:comment_info]
          #  # users
          #  users = UserInfo.select("push_apn_token").where("project_info_id=#{admin_info.project_info_id} and push_apn_token!=''");
          #  users.each do |user|
          #    args[:token] = user.push_apn_token
          #    Resque.enqueue(PushApn, args)
          #    puts args
          #  end
          #  # users = ;
          #end
        end


        format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '修改成功.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    app_module_info
    @content_item = CmsContentFeedback.find(params[:id])
    @content_item.destroy

    respond_to do |format|
      format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '删除成功.' }
      format.json { head :no_content }
    end
  end
end
