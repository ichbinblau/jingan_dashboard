# encoding: utf-8
class Kf::SicknessesController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/sicknesses
  # GET /kf/sicknesses.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "name like ? or description like ?"
      conditions.push "%#{params[:search]}%"
      conditions.push "%#{params[:search]}%"
    end
    @kf_sicknesses = Kf::Sickness.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page] ,:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_sicknesses }
    end
  end

  # GET /kf/sicknesses/1
  # GET /kf/sicknesses/1.json
  def show
    @kf_sickness = Kf::Sickness.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_sickness }
    end
  end

  # GET /kf/sicknesses/new
  # GET /kf/sicknesses/new.json
  def new
    @kf_sickness = Kf::Sickness.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_sickness }
    end
  end

  # GET /kf/sicknesses/1/edit
  def edit
    @kf_sickness = Kf::Sickness.find(params[:id])
  end

  # POST /kf/sicknesses
  # POST /kf/sicknesses.json
  def create
    @kf_sickness = Kf::Sickness.new(params[:kf_sickness])

    respond_to do |format|
      if @kf_sickness.save
        format.html { redirect_to kf_sicknesses_url({:page => params[:page]}), notice: 'Sickness was successfully created.' }
        format.json { render json: @kf_sickness, status: :created, location: @kf_sickness }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_sickness.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/sicknesses/1
  # PUT /kf/sicknesses/1.json
  def update
    @kf_sickness = Kf::Sickness.find(params[:id])

    respond_to do |format|
      if @kf_sickness.update_attributes(params[:kf_sickness])
        format.html { redirect_to kf_sicknesses_url({:page => params[:page]}), notice: 'Sickness was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_sickness.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/sicknesses/1
  # DELETE /kf/sicknesses/1.json
  def destroy
    @kf_sickness = Kf::Sickness.find(params[:id])
    @kf_sickness.destroy

    respond_to do |format|
      format.html { redirect_to kf_sicknesses_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
