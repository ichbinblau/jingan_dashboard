# encoding: utf-8
class Admins::SysStatisticsController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end

  def index
    app_module_info


    # 内容列表
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?
    joins = "join user_infos on user_infos.id= act_coupon_orders.user_info_id"
    joins += " join cms_info_coupons on act_coupon_orders.cms_content_coupon_id = cms_info_coupons.id"
    joins += " join cms_contents_cms_sorts on cms_contents_cms_sorts.cms_content_id = cms_info_coupons.cms_content_id"
    search = "`act_coupon_orders`.`project_info_id`=#{admin_info.project_info_id}"
    search += " and cms_contents_cms_sorts.cms_sort_id=1038 "
    #场地

    #if (params[:sel_shop].to_s.length>0 )
    #  if (params[:sel_shop].to_s!="0")
    #    contentinfo=CmsContent.where("id=#{params[:sel_shop]}").first()
    #    search += " and act_buy_orders.title = '"+contentinfo.title+"'"
    #  end
    #end
    #项目
    #if (params[:sel_product].to_s.length>0 )
    #  if (params[:sel_product].to_s!="0")
    #    search += " and act_buy_orders.cms_content_id = '#{params[:sel_product]}'"
    #  end
    #end
    #时间
    if  !params[:starttime].blank?
      search += " and act_coupon_orders.updated_at >= '#{params[:starttime]}'"
    end
    if  !params[:endtime].blank?
      search += " and act_coupon_orders.updated_at <= '#{params[:endtime]}'"
    end

    @content_items = ActCouponOrder
		.select("act_coupon_orders.id, act_coupon_orders.user_info_id, user_infos.phone_number, user_infos.nickname, count(*) as cnt")
		.joins(joins)
		.where(search)
		.group("act_coupon_orders.user_info_id")
		.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @content_items }
    end

  end
end





#def savetxt(path ,txt)
#  fh = File.new(path, "w")
#  fh.puts txt.to_s
#  fh.close
#end
#
#
#
#tmp_fname = getRandCode(10)
#tmp_file = Tempfile.new(tmp_fname)
#compress(@basepath+params[:project],tmp_file.path)
#send_file tmp_file.path ,
#          :content_type => "application/zip",
#          :filename => "config.zip"
