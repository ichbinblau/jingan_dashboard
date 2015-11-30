# encoding: utf-8
# File.expand_path('../../../lib/web/controller_base',  __FILE__)

class Admins::SysRepairlogController <  ApplicationController
  before_filter :authenticate_admin_user!
  layout "admins/_global",:only => [:index ]
  # To change this template use File | Settings | File Templates.


  def admin_info
    AdminUser.select("admin_users.email ,admin_users.project_info_id, project_infos.*")
    .joins(" left join project_infos on( admin_users.project_info_id = project_infos.id)").find(current_admin_user.id)
  end


  def index
    # 这里修改id      63
    project_info_id = admin_info.project_info_id
    page= params[:page]
    pageSize = params[:per_page]


    queryBuf = ["
SELECT
    c.*,
    b.name,
    b.nickname,
    b.phone_number,
    a.title as devicetitle,
    g.title as shoptitle,
    d.address as  shopaddress,
    d.baidu_latitude as shopbaidulat,
    d.baidu_longitude as shopbaidulog
FROM cms_content_comments  c
JOIN user_infos b ON c.user_info_id = b.id
JOIN cms_contents a ON c.cms_content_id = a.id
JOIN news_contents_shop_contents e ON a.id = e.news_content_id
JOIN cms_contents g ON e.shop_content_id = g.id
JOIN cms_info_shops d ON g.cms_content_info_id = d.id
WHERE c.project_info_id = ?  && c.typenum = 2 && a.type = 'NewsContent' && g.type = 'ShopContent' 
ORDER BY c.updated_at DESC" ]
    args =[project_info_id]
    if !params[:status].blank?
      queryBuf.push " AND c.status=?"
      args.push params[:status]
    end


    @content_items =  CmsContentComment.paginate_by_sql [queryBuf.join(' ')]+args ,:page => page, :per_page => pageSize

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @content_items }
    end


  end

 def edit
   # status 0 or null =初始化(已报修)  1=已处理
   msg = nil
   success = false

   project_info_id = admin_info.project_info_id
   id = params[:key]
   if !id.blank?
     # project_info_id=? AND
     m =  CmsContentComment.find(:first,:conditions =>["id=? AND project_info_id",id,project_info_id] )
     if !m.nil?

       if  m.status.nil? || m.status==0
         m.status=1
         m.save
         success=true
       else
         msg="此记录状态错误"
       end
     else
       msg="未找到此记录"
     end

   else
     msg="标识null"
   end
   render :json=>{:success=> success,:msg=> msg}
  end



end