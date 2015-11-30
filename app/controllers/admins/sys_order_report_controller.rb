# encoding: utf-8
class Admins::SysOrderReportController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end

  def index
    app_module_info


    # 内容列表
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?
    joins="join `cms_contents` on (`act_buy_orders`.`cms_content_id` = `cms_contents`.`id`)  join user_infos on (act_buy_orders.user_info_id = user_infos.id) join user_sort_infos on (user_infos.id = user_sort_infos.user_info_id)"

    search = "`act_buy_orders`.`project_info_id`=#{admin_info.project_info_id} and act_buy_orders.act_status_type_id=8"
    #场地

    if (params[:sel_shop].to_s.length>0 )
      if (params[:sel_shop].to_s!="0")
        contentinfo=CmsContent.where("id=#{params[:sel_shop]}").first()
        search += " and act_buy_orders.title = '"+contentinfo.title+"'"
      end
    end
    #项目
    if (params[:sel_product].to_s.length>0 )
      if (params[:sel_product].to_s!="0")
        search += " and act_buy_orders.cms_content_id = '#{params[:sel_product]}'"
      end
    end
    #时间
    if  !params[:starttime].blank?
      search += " and act_buy_orders.updated_at >= '#{params[:starttime]}'"
    end
    if  !params[:endtime].blank?
      search += " and act_buy_orders.updated_at <= '#{params[:endtime]}'"
    end

    # 查询运动项目
    sorts=CmsSort.where("father_id =(select id from cms_sorts where cnname='运动项目'  and project_info_id=#{admin_info.project_info_id}  limit 0, 1 )")
    ordercount=0
    productcount=0
    pricecount=0

    sorts.each do |sort|

      sort.top_sort_id=0
      sort.level=0
      sort.content_count=0

      #查询订单数
      sort.top_sort_id=ActBuyOrder.where(search).where('act_buy_orders.json_property like \'%"gym_project"%:%"'+sort.cnname+'"%\'').count()

      #商品数
      if sort.cnname=="游泳"
        sort.level=ActBuyOrder.where(search).where('act_buy_orders.json_property like \'%"gym_project"%:%"'+sort.cnname+'"%\'').select(" sum(people_num) as productcount").first().productcount.to_i()
      else
        sort.level=ActBuyOrder.where(search).where('act_buy_orders.json_property like \'%"gym_project"%:%"'+sort.cnname+'"%\'').select(" sum((length(json_property) - length(replace(json_property,'color','')))/length('color')) as productcount").first().productcount.to_i()
      end

      #金额
      sort.content_count=ActBuyOrder.where(search).where('act_buy_orders.json_property like \'%"gym_project"%:%"'+sort.cnname+'"%\'').select(" sum(must_price) as pricecount").first().pricecount.to_i()

      ordercount=ordercount+sort.top_sort_id
      productcount=productcount+ sort.level
      pricecount=pricecount+ sort.content_count
    end
    #sorts.new(:cnname=>"总计",:top_sort_id=>ordercount,:level=>productcount,:content_count=>pricecount)




    @content_distitle = JSON.parse('{"cnname":"总计","top_sort_id":'+ordercount.to_s+',"level":'+productcount.to_s+',"content_count":'+pricecount.to_s+'}')
    @content_items = sorts
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupon_contents }
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