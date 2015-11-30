# encoding: utf-8
class Kf::UserNoticesController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/user_notices
  # GET /kf/user_notices.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "title like ?"
      conditions.push "%#{params[:search]}%"
    end
    @kf_user_notices = Kf::UserNotice.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page],:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_user_notices }
    end
  end

  # GET /kf/user_notices/1
  # GET /kf/user_notices/1.json
  def show
    @kf_user_notice = Kf::UserNotice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_user_notice }
    end
  end

  # GET /kf/user_notices/new
  # GET /kf/user_notices/new.json
  def new
    @kf_user_notice = Kf::UserNotice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_user_notice }
    end
  end

  # GET /kf/user_notices/1/edit
  def edit
    @kf_user_notice = Kf::UserNotice.find(params[:id])
  end

  # POST /kf/user_notices
  # POST /kf/user_notices.json
  def create
    @kf_user_notice = Kf::UserNotice.new(params[:kf_user_notice])

    respond_to do |format|
      if @kf_user_notice.save
        format.html { redirect_to kf_user_notices_url({:page => params[:page]}), notice: 'User notice was successfully created.' }
        format.json { render json: @kf_user_notice, status: :created, location: @kf_user_notice }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_user_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/user_notices/1
  # PUT /kf/user_notices/1.json
  def update
    @kf_user_notice = Kf::UserNotice.find(params[:id])

    respond_to do |format|
      if @kf_user_notice.update_attributes(params[:kf_user_notice])
        format.html { redirect_to kf_user_notices_url({:page => params[:page]}), notice: 'User notice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_user_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/user_notices/1
  # DELETE /kf/user_notices/1.json
  def destroy
    @kf_user_notice = Kf::UserNotice.find(params[:id])
    @kf_user_notice.destroy

    respond_to do |format|
      format.html { redirect_to kf_user_notices_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
