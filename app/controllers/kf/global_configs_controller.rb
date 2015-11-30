# encoding: utf-8
class Kf::GlobalConfigsController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/global_configs
  # GET /kf/global_configs.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "config_type like ? or key like ?"
      conditions.push "%#{params[:search]}%"
      conditions.push "%#{params[:search]}%"
    end
    @kf_global_configs = Kf::GlobalConfig.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page] ,:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_global_configs }
    end
  end

  def feedback
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    @feedbacks = CmsContentFeedback.order("id DESC").where(:project_info_id => 157).paginate(:page => params[:page], :per_page => params[:per_page] )
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_courses }
    end
  end
  # GET /kf/global_configs/1
  # GET /kf/global_configs/1.json
  def show
    @kf_global_config = Kf::GlobalConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_global_config }
    end
  end

  # GET /kf/global_configs/new
  # GET /kf/global_configs/new.json
  def new
    @kf_global_config = Kf::GlobalConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_global_config }
    end
  end

  # GET /kf/global_configs/1/edit
  def edit
    @kf_global_config = Kf::GlobalConfig.find(params[:id])
  end

  # POST /kf/global_configs
  # POST /kf/global_configs.json
  def create
    @kf_global_config = Kf::GlobalConfig.new(params[:kf_global_config])

    respond_to do |format|
      if @kf_global_config.save
        format.html { redirect_to kf_global_configs_url({:page => params[:page]}), notice: 'Global config was successfully created.' }
        format.json { render json: @kf_global_config, status: :created, location: @kf_global_config }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_global_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/global_configs/1
  # PUT /kf/global_configs/1.json
  def update
    @kf_global_config = Kf::GlobalConfig.find(params[:id])

    respond_to do |format|
      if @kf_global_config.update_attributes(params[:kf_global_config])
        format.html { redirect_to kf_global_configs_url({:page => params[:page]}), notice: 'Global config was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_global_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/global_configs/1
  # DELETE /kf/global_configs/1.json
  def destroy
    @kf_global_config = Kf::GlobalConfig.find(params[:id])
    @kf_global_config.destroy

    respond_to do |format|
      format.html { redirect_to kf_global_configs_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
