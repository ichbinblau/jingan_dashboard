# encoding: utf-8
class Kf::CourseFormsController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/course_forms
  # GET /kf/course_forms.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "title like ? or description like ?"
      conditions.push "%#{params[:search]}%"
      conditions.push "%#{params[:search]}%"
    end
    @kf_course_forms = Kf::CourseForm.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page] ,:conditions => conditions)
    # @kf_course_forms

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_course_forms }
    end
  end
  # GET /kf/course_forms/1
  # GET /kf/course_forms/1.json
  def show
    @kf_course_form = Kf::CourseForm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_course_form }
    end
  end

  # GET /kf/course_forms/new
  # GET /kf/course_forms/new.json
  def new
    @kf_course_form = Kf::CourseForm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_course_form }
    end
  end

  # GET /kf/course_forms/1/edit
  def edit
    @kf_course_form = Kf::CourseForm.find(params[:id])
  end

  # POST /kf/course_forms
  # POST /kf/course_forms.json
  def create
    @kf_course_form = Kf::CourseForm.new(params[:kf_course_form])

    respond_to do |format|
      if @kf_course_form.save
        format.html { redirect_to kf_course_forms_url({:page => params[:page]}), notice: 'Course form was successfully created.' }
        format.json { render json: @kf_course_form, status: :created, location: @kf_course_form }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_course_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/course_forms/1
  # PUT /kf/course_forms/1.json
  def update
    @kf_course_form = Kf::CourseForm.find(params[:id])

    respond_to do |format|
      if @kf_course_form.update_attributes(params[:kf_course_form])
        format.html { redirect_to kf_course_forms_url({:page => params[:page]}), notice: 'Course form was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_course_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/course_forms/1
  # DELETE /kf/course_forms/1.json
  def destroy
    @kf_course_form = Kf::CourseForm.find(params[:id])
    @kf_course_form.destroy

    respond_to do |format|
      format.html { redirect_to kf_course_forms_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
