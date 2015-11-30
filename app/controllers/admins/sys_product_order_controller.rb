# encoding: utf-8
class Admins::SysProductOrderController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end

  def index
    app_module_info
    # 内容列表
    params[:per_page] = perpage if params[:per_page].blank?
    params[:page] = 1 if params[:page].blank?
    joins="join `cms_contents_cms_sorts` on (`act_buy_orders`.`cms_content_id` = `cms_contents_cms_sorts`.`cms_content_id`)"
    search = "`act_buy_orders`.`project_info_id`=#{admin_info.project_info_id}  and `cms_contents_cms_sorts`.`cms_sort_id`="+@sort_id.to_s
    search += " and check_time like '%#{params[:words]}%'" if !params[:words].blank?
    print("1111111111111111111111111111",params[:myselect])
    if (params[:myselect].to_s.length>0 )
      if (params[:myselect].to_s!="0")
        search += " and act_status_type_id = '#{params[:myselect]}'"
      end
    end
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_items = ActBuyOrder
                    .joins( joins )
                    .where( search )
                    .order("check_time DESC").paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupon_contents }
    end

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
    @content_distitle =JSON.parse("{\"zhx\":1}")
    if @module_info[:configs].to_s.length>0
      @content_distitle = JSON.parse(@module_info[:configs])
    end
    @content_item = ActBuyOrder.find(params[:act_buy_order][:id])
    respond_to do |format|
      @sortids="465,466"
      @zhx=ActBuyOrder.where("#{@sort_id} in (#{@sortids}) and id!= #{params[:act_buy_order][:id]}  and project_info_id= #{admin_info.project_info_id} and cms_content_id=#{params[:act_buy_order][:cms_content_id]} and ((check_time<='#{params[:act_buy_order][:check_time]}' and departure_time>= '#{params[:act_buy_order][:check_time]}') or (check_time<='#{params[:act_buy_order][:departure_time]}' and departure_time>= '#{params[:act_buy_order][:departure_time]}'))")
      if(@zhx.count>0)
        #flash[:notice] = "该时间内不可以下单"
        format.html { redirect_to url_for action: "edit" , :id =>params[:act_buy_order][:id] ,:page=>params[:page],:sort_id=>params[:sort_id],:notice => "该时间内不可以下单" }
      else
        if @content_item.update_attributes(params[:act_buy_order])
          format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '修改成功.' }
        else
          format.html { render action: "edit" }
        end
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
      format.html { redirect_to url_for :action =>"index" ,:page=>params[:page],:sort_id=>params[:sort_id], notice: '删除成功.' }
      format.json { head :no_content }
    end
  end
end
