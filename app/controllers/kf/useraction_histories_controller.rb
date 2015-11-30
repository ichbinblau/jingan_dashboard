# encoding: utf-8
class Kf::UseractionHistoriesController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/useraction_histories
  # GET /kf/useraction_histories.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "action_type like ? "
      conditions.push "%#{params[:search]}%"
    end
    @kf_useraction_histories = Kf::UseractionHistory.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page],:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_useraction_histories }
    end
  end

  # GET /kf/useraction_histories/1
  # GET /kf/useraction_histories/1.json
  def show
    @kf_useraction_history = Kf::UseractionHistory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_useraction_history }
    end
  end

  # GET /kf/useraction_histories/new
  # GET /kf/useraction_histories/new.json
  def new
    @kf_useraction_history = Kf::UseractionHistory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_useraction_history }
    end
  end

  # GET /kf/useraction_histories/1/edit
  def edit
    @kf_useraction_history = Kf::UseractionHistory.find(params[:id])
  end

  # POST /kf/useraction_histories
  # POST /kf/useraction_histories.json
  def create
    @kf_useraction_history = Kf::UseractionHistory.new(params[:kf_useraction_history])

    respond_to do |format|
      if @kf_useraction_history.save
        format.html { redirect_to kf_useraction_histories_url({:page => params[:page]}), notice: 'Useraction history was successfully created.' }
        format.json { render json: @kf_useraction_history, status: :created, location: @kf_useraction_history }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_useraction_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/useraction_histories/1
  # PUT /kf/useraction_histories/1.json
  def update
    @kf_useraction_history = Kf::UseractionHistory.find(params[:id])

    respond_to do |format|
      if @kf_useraction_history.update_attributes(params[:kf_useraction_history])
        format.html { redirect_to kf_useraction_histories_url({:page => params[:page]}), notice: 'Useraction history was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_useraction_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/useraction_histories/1
  # DELETE /kf/useraction_histories/1.json
  def destroy
    @kf_useraction_history = Kf::UseractionHistory.find(params[:id])
    @kf_useraction_history.destroy

    respond_to do |format|
      format.html { redirect_to kf_useraction_histories_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
