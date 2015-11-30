# encoding: utf-8
class Kf::CourseItemTypesController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/course_item_types
  # GET /kf/course_item_types.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "title like ? or description like ?"
      conditions.push "%#{params[:search]}%"
      conditions.push "%#{params[:search]}%"
    end
    @kf_course_item_types = Kf::CourseItemType.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page] ,:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_course_item_types }
    end
  end

  # GET /kf/course_item_types/1
  # GET /kf/course_item_types/1.json
  def show
    @kf_course_item_type = Kf::CourseItemType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_course_item_type }
    end
  end

  # GET /kf/course_item_types/new
  # GET /kf/course_item_types/new.json
  def new
    @kf_course_item_type = Kf::CourseItemType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_course_item_type }
    end
  end

  # GET /kf/course_item_types/1/edit
  def edit
    @kf_course_item_type = Kf::CourseItemType.find(params[:id])
  end

  # POST /kf/course_item_types
  # POST /kf/course_item_types.json
  def create
    @kf_course_item_type = Kf::CourseItemType.new(params[:kf_course_item_type])

    respond_to do |format|
      if @kf_course_item_type.save
        format.html { redirect_to kf_course_item_types_url({:page => params[:page]}), notice: 'Course item type was successfully created.' }
        format.json { render json: @kf_course_item_type, status: :created, location: @kf_course_item_type }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_course_item_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/course_item_types/1
  # PUT /kf/course_item_types/1.json
  def update
    @kf_course_item_type = Kf::CourseItemType.find(params[:id])

    respond_to do |format|
      if @kf_course_item_type.update_attributes(params[:kf_course_item_type])
        format.html { redirect_to kf_course_item_types_url({:page => params[:page]}), notice: 'Course item type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_course_item_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/course_item_types/1
  # DELETE /kf/course_item_types/1.json
  def destroy
    @kf_course_item_type = Kf::CourseItemType.find(params[:id])
    @kf_course_item_type.destroy

    respond_to do |format|
      format.html { redirect_to kf_course_item_types_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
