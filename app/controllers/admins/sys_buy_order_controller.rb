# encoding: utf-8
class Admins::SysBuyOrderController < ApplicationController
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

    search = "`act_buy_orders`.`project_info_id`=#{admin_info.project_info_id}  "
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
    #支付状态
    if (params[:sel_statutype].to_s.length>0 )
      if (params[:sel_statutype].to_s!="0")
        search += " and act_buy_orders.act_status_type_id = '#{params[:sel_statutype]}'"
      end
    end
    #时间
    themeid=params[:theme]
    if themeid=="0" #下单时间
      if  !params[:starttime].blank?
        search += " and act_buy_orders.created_at >= '#{params[:starttime]}'"
      end
      if  !params[:endtime].blank?
        search += " and act_buy_orders.created_at <= '#{params[:endtime]}'"
      end
    else  #消费时间
      if  !params[:starttime].blank?
        search += " and act_buy_orders.updated_at >= '#{params[:starttime]}' and act_buy_orders.act_status_type_id=8"
      end
      if  !params[:endtime].blank?
        search += " and act_buy_orders.updated_at <= '#{params[:endtime]}'  and act_buy_orders.act_status_type_id=8"
      end
    end
    #用户信息
    if !params[:username].blank?
      if  !params[:userphone].blank?
        userinfo=UserInfo.joins("join user_sort_infos on (user_infos.id = user_sort_infos.user_info_id)").where("user_infos.phone_number='#{params[:userphone]}' and user_sort_infos.char_value_0='#{params[:username]}' and user_infos.project_info_id=#{admin_info.project_info_id}").first()
        search += " and act_buy_orders.user_info_id = '#{userinfo.id}'"
      else
        userinfo=UserInfo.joins("join user_sort_infos on (user_infos.id = user_sort_infos.user_info_id)").where("user_sort_infos.char_value_0='#{params[:username]}' and user_infos.project_info_id=#{admin_info.project_info_id}").first()
        search += " and act_buy_orders.user_info_id = '#{userinfo.id}'"
      end
    else
      if  !params[:userphone].blank?
        userinfo=UserInfo.where("user_infos.phone_number='#{params[:userphone]}' and user_infos.project_info_id=#{admin_info.project_info_id} ").first()
        search += " and act_buy_orders.user_info_id = '#{userinfo.id}'"
      end
    end
    #订单号
    if  !params[:ordernum].blank?
      search += " and act_buy_orders.id = '#{params[:ordernum]}'"
    end
    params[:joins]= joins
    params[:search]= search
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_items = ActBuyOrder
                    .joins( joins )
                    .where( search )
                    .select("act_buy_orders.* ,cms_contents.title as projecttitle ,user_infos.phone_number,user_sort_infos.char_value_0")
                    .order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupon_contents }
    end
  end

  def  exports
    app_module_info

    joins=params[:joins]
    search=params[:search]

    require "csv"
    require "nkf"

    field_name = ["\xEF\xBB\xBF订单号", "项目", "场馆名", "姓名", "手机号", "下单时间", "消费时间", "场次", "金额", "订单状态"]  #csv文件的头（标题）

    output = CSV.generate do |csv|

      csv << ["筛选条件"]
      #场地
      if (params[:sel_shop].to_s.length>0 )
        if (params[:sel_shop].to_s!="0")
          contentinfo=CmsContent.where("id=#{params[:sel_shop]}").first()
          csv << ["","场馆名:",contentinfo.title]
        end
      end
      #项目
      if (params[:sel_product].to_s.length>0 )
        if (params[:sel_product].to_s!="0")
          contentinfo=CmsContent.where("id=#{params[:sel_product]}").first()
          csv << ["","项目:",contentinfo.title]
        end
      end
      #支付状态
      if (params[:sel_statutype].to_s.length>0 )
        if (params[:sel_statutype].to_s!="0")
          statustype=ActStatusType.where(:id =>params[:sel_statutype]).first()
          csv << ["","订单状态:",statustype.descption]
        end
      end
      themeid=params[:theme]
      if themeid=="0" #下单时间
        csv << ["","时间类型:","下单时间"]
      else  #消费时间
        csv << ["","时间类型:","消费时间"]
      end
      if (params[:starttime].to_s.length>0 )
        csv << ["","开始时间:",params[:starttime]]
      end
      if (params[:endtime].to_s.length>0 )
        csv << ["","结束时间:",params[:endtime]]
      end

      if (params[:username].to_s.length>0 )
        csv << ["","用户姓名:",params[:username]]
      end

      if (params[:userphone].to_s.length>0 )
        csv << ["","用户手机:",params[:userphone]]
      end

      if (params[:ordernum].to_s.length>0 )
        csv << ["","订单号:",params[:ordernum]]
      end
      csv << [""]
      csv << field_name
      ActBuyOrder
      .joins( joins )
      .where( search )
      .select("act_buy_orders.* ,cms_contents.title as projecttitle ,user_infos.phone_number,user_sort_infos.char_value_0").all.each do |person|
        updated_at= "没有消费"
        if person.act_status_type_id==8
          updated_at=person.updated_at.strftime("%Y-%m-%d %H:%M:%S")
        end
        csv << [person.order_number,person.projecttitle,person.title,person.char_value_0,person.phone_number,person.created_at.strftime("%Y-%m-%d %H:%M:%S"),updated_at,JSON.parse(person.json_property)["orderDetails"],person.must_price,ActStatusType.where(:id =>person.act_status_type_id).first.descption ]   # 将数据插入数组中
      end
    end
    fh = File.new("#{Rails.root}/public/abc.csv", "wb")  #创建一个可写文件流
    fh.puts NKF.nkf("-wL",output) #写入数据。这里没用原作者的“-wLuxs”，因为似乎结果不太对
    fh.close
    tmp_file = fh
    compress(tmp_file.path)
    send_file tmp_file.path ,
              :content_type => "application/csv",
              :filename => "config.csv"
  end

  def show
    @content_item = ActBuyOrder.includes(:act_buy_people_order).find(params[:id])

    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def new
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ActBuyOrder.new
    @content_item.project_info_id = admin_info.project_info_id
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coupon_content }
    end
  end

  def edit
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ActBuyOrder.includes(:act_buy_people_order).find(params[:id])
    @order_items = CmsContentProductDetail.where("act_buy_order_id="+params[:id])
    @consignee_item = UserConsignee.where("id="+@content_item.user_consignee_id.to_s).first
    @content_item.project_info_id = admin_info.project_info_id

  end

  def create
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ActBuyOrder.new(params[:act_buy_order])
    @content_item.project_info_id = admin_info.project_info_id
    respond_to do |format|
      @sortids="465,466"
      @zhx=ActBuyOrder.where("#{@sort_id} in (#{@sortids}) and project_info_id= #{admin_info.project_info_id} and cms_content_id=#{params[:act_buy_order][:cms_content_id]} and ((check_time<='#{params[:act_buy_order][:check_time]}' and departure_time>= '#{params[:act_buy_order][:check_time]}') or (check_time<='#{params[:act_buy_order][:departure_time]}' and departure_time>= '#{params[:act_buy_order][:departure_time]}'))")
      if(@zhx.count>0)
        #flash[:notice] = "该时间内不可以下单"
        format.html { redirect_to url_for action: "new" ,:page=>params[:page],:sort_id=>params[:sort_id],:notice => "该时间内不可以下单" }
      else
        if @content_item.save
          format.html { redirect_to url_for :action =>"index",:sort_id=>params[:sort_id], notice: '添加成功.' }
        else
          format.html { render action: "new" }
        end
      end
    end
  end

  def update
    app_module_info
    @content_item = ActBuyOrder.find(params[:act_buy_order][:id])
    respond_to do |format|

        if @content_item.update_attributes(params[:act_buy_order])
          format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id],:sel_shop=> params[:sel_shop],:sel_product=> params[:sel_product],:sel_statutype=> params[:sel_statutype],:starttime=> params[:starttime],:endtime=> params[:endtime],:theme=> params[:theme],:username=> params[:username],:userphone=> params[:userphone],:ordernum=> params[:ordernum], notice: '修改成功.' }
        else
          format.html { render action: "edit" }
        end


    end
  end

  def destroy
    app_module_info
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ActBuyOrder.find(params[:id])
    @content_item.destroy

    respond_to do |format|
      format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id],:sel_shop=> params[:sel_shop],:sel_product=> params[:sel_product],:sel_statutype=> params[:sel_statutype],:starttime=> params[:starttime],:endtime=> params[:endtime],:theme=> params[:theme],:username=> params[:username],:userphone=> params[:userphone],:ordernum=> params[:ordernum], notice: '删除成功.' }
      format.json { head :no_content }
    end
  end
end
