# encoding: utf-8
class Kf::StatusesController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end

  # GET /kf/statuses
  # GET /kf/statuses.json
  def index
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    conditions = {:status_type => 0 ,:relation_id => 0 ,:count_type => 0 }
    conditions[:status_type] = params[:status_type] unless params[:status_type].blank?
    conditions[:relation_id] = params[:relation_id] unless params[:relation_id].blank?
    conditions[:count_type] = params[:count_type] unless params[:count_type].blank?
    @kf_statuses = Kf::Status.order("date DESC").where(conditions).paginate(:page => params[:page], :per_page => params[:per_page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_statuses }
    end
  end

  # GET /kf/statuses/1
  # GET /kf/statuses/1.json
  def show
    @kf_status = Kf::Status.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_status }
    end
  end

  # GET /kf/statuses/new
  # GET /kf/statuses/new.json
  def new
    @kf_status = Kf::Status.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_status }
    end
  end

  # GET /kf/statuses/1/edit
  def edit
    @kf_status = Kf::Status.find(params[:id])
  end

  # POST /kf/statuses
  # POST /kf/statuses.json
  def create
    params[:kf_status][:status_type] = params[:status_type] unless params[:status_type].blank?
    params[:kf_status][:relation_id] = params[:relation_id] unless params[:relation_id].blank?
    params[:kf_status][:count_type] = params[:count_type] unless params[:count_type].blank?
    @kf_status = Kf::Status.new(params[:kf_status])

    respond_to do |format|
      if @kf_status.save
        format.html { redirect_to "/kf/statuses?page=#{params[:page]}&relation_id=#{params[:relation_id]}&status_type=#{params[:status_type]}&count_type=#{params[:count_type]}",notice: 'Status was successfully created.' }
        format.json { render json: @kf_status, status: :created, location: @kf_status }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/statuses/1
  # PUT /kf/statuses/1.json
  def update
    params[:kf_status][:status_type] = params[:status_type] unless params[:status_type].blank?
    params[:kf_status][:relation_id] = params[:relation_id] unless params[:relation_id].blank?
    params[:kf_status][:count_type] = params[:count_type] unless params[:count_type].blank?
    @kf_status = Kf::Status.find(params[:id])

    respond_to do |format|
      if @kf_status.update_attributes(params[:kf_status])
        format.html { redirect_to "/kf/statuses?page=#{params[:page]}&relation_id=#{params[:relation_id]}&status_type=#{params[:status_type]}&count_type=#{params[:count_type]}", notice: 'Status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/statuses/1
  # DELETE /kf/statuses/1.json
  def destroy
    @kf_status = Kf::Status.find(params[:id])
    @kf_status.destroy

    respond_to do |format|
      format.html { redirect_to "/kf/statuses?page=#{params[:page]}&relation_id=#{params[:relation_id]}&status_type=#{params[:status_type]}&count_type=#{params[:count_type]}" }
      format.json { head :no_content }
    end
  end
end
