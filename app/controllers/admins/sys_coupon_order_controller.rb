# encoding: utf-8
class Admins::SysCouponOrderController < ApplicationController
  before_filter :authenticate_admin_user!
  layout "admins/_global"


  # To change this template use File | Settings | File Templates.

  def admin_info
    AdminUser.select("admin_users.email ,admin_users.project_info_id, project_infos.*")
    .joins(" left join project_infos on( admin_users.project_info_id = project_infos.id)").find(current_admin_user.id)
  end

  def index
    project_info_id = admin_info.project_info_id
    page= params[:page]
    pageSize = params[:per_page]

    queryBuf = ["SELECT
  a.act_status_type_id,
	a.nick_name,
	a.apply_code,
  a.created_at,
  a.updated_at,
	c.title,
	c.abstract,
	c.content,
	c.image_cover
FROM act_coupon_orders a
INNER JOIN cms_info_coupons b  ON a.cms_content_coupon_id=b.id
INNER JOIN cms_contents c ON c.id = b.cms_content_id
WHERE 1=1 "]
    args = []

    queryBuf.push "AND a.project_info_id=?"
    args.push project_info_id

    if !params[:code].blank?
      queryBuf.push "AND a.apply_code REGEXP concat('\s*',?)"
      args.push params[:code].gsub(/\s+/,"")
    end

    if !params[:status].blank?
      queryBuf.push "AND a.act_status_type_id=?"
      args.push params[:status]
    end
    queryBuf.push "ORDER BY  a.updated_at DESC "

    #@content_items =  CmsContentComment.paginate_by_sql @query ,:page => page, :per_page => pageSize

    @content_items = ActCouponOrder.paginate_by_sql [ queryBuf.join(" ")]+args,:page => page, :per_page => pageSize

  end



  def show
    code=params[:code]
    project_info_id = admin_info.project_info_id

    #可能要加 项目的条件
     m =  ActCouponOrder.find_by_sql(["
SELECT
  a.act_status_type_id,
	a.nick_name,
	a.apply_code,
	c.title,
	c.abstract,
	c.content,
	c.image_cover
FROM act_coupon_orders a
INNER JOIN cms_info_coupons b  ON a.cms_content_coupon_id=b.id
INNER JOIN cms_contents c ON c.id = b.cms_content_id
WHERE a.apply_code REGEXP concat('\s*',?) AND a.project_info_id=?  limit 1",code,project_info_id]).first

    #&& m.act_status_type_id!=4
    if !m.nil?
      if (m.act_status_type_id == 4)
        m[:status] ="领取"
      elsif (m.act_status_type_id == 0)
        m[:status] ="创建"
      elsif (m.act_status_type_id == 2)
        m[:status] ="已使用"
      else
        m[:status] ="未知"
      end
    end

      render :json => m
  end

  def edit

  end



  def update
    #这里需要改
    project_info_id = admin_info.project_info_id
    code=params[:code]
    #ActCouponOrder
    m =  ActCouponOrder.find(:first, :conditions => ["apply_code REGEXP concat('\s*',?) ",code])
    msg = nil
    success = false
    if m.nil?
        msg = "优惠券不存在"
    elsif m.user_info_id ==0 or m.act_status_type_id==1
        msg = "未初始化"
    elsif  m.act_status_type_id!=4
        msg = "优惠券状态错误"
    elsif m.project_info_id != project_info_id
       msg = "优惠券项目错误"
     else
        m.act_status_type_id=2
        m.save
        success=true
    end
    #这里更改优惠券状态

    render :json=> {:success=>success,:msg => msg }
  end


end
