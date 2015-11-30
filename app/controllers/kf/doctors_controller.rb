# encoding: utf-8
class Kf::DoctorsController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/doctors
  # GET /kf/doctors.json
  def index
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    search = ""
    search += " doctor_group_id='#{params[:sort_id]}' " unless params[:sort_id].blank?
    search += " and " if !params[:search].blank? && !params[:sort_id].blank?
    search += " name like '%#{params[:search]}%' or description like '%#{params[:search]}%' " if !params[:search].blank?
    @kf_doctors = Kf::Doctor.order("id DESC").where(search).paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_doctors }
    end
  end

  # GET /kf/doctors/1
  # GET /kf/doctors/1.json
  def show
    @kf_doctor = Kf::Doctor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_doctor }
    end
  end

  # GET /kf/doctors/new
  # GET /kf/doctors/new.json
  def new
    @kf_doctor = Kf::Doctor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_doctor }
    end
  end

  # GET /kf/doctors/1/edit
  def edit
    @kf_doctor = Kf::Doctor.find(params[:id])
  end

  # POST /kf/doctors
  # POST /kf/doctors.json
  def create
    @kf_doctor = Kf::Doctor.new(params[:kf_doctor])

    respond_to do |format|
      if @kf_doctor.save
        format.html { redirect_to kf_doctors_url({:page => params[:page]}), notice: 'Doctor was successfully created.' }
        format.json { render json: @kf_doctor, status: :created, location: @kf_doctor }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/doctors/1
  # PUT /kf/doctors/1.json
  def update
    @kf_doctor = Kf::Doctor.find(params[:id])

    respond_to do |format|
      if @kf_doctor.update_attributes(params[:kf_doctor])
        format.html { redirect_to kf_doctors_url({:page => params[:page]}), notice: 'Doctor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/doctors/1
  # DELETE /kf/doctors/1.json
  def destroy
    @kf_doctor = Kf::Doctor.find(params[:id])
    @kf_doctor.destroy

    respond_to do |format|
      format.html { redirect_to kf_doctors_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
