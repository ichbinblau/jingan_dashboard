# encoding: utf-8
class Kf::CourseIndicesController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/course_indices
  # GET /kf/course_indices.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "title like ? or content like ?"
      conditions.push "%#{params[:search]}%"
      conditions.push "%#{params[:search]}%"
    end
    @kf_course_indices = Kf::CourseIndex.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page] ,:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_course_indices }
    end
  end

  # GET /kf/course_indices/1
  # GET /kf/course_indices/1.json
  def show
    @kf_course_index = Kf::CourseIndex.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_course_index }
    end
  end

  # GET /kf/course_indices/new
  # GET /kf/course_indices/new.json
  def new
    @kf_course_index = Kf::CourseIndex.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_course_index }
    end
  end

  # GET /kf/course_indices/1/edit
  def edit
    @kf_course_index = Kf::CourseIndex.find(params[:id])
  end

  # POST /kf/course_indices
  # POST /kf/course_indices.json
  def create
    @kf_course_index = Kf::CourseIndex.new(params[:kf_course_index])
    # kf_course_knowledge_size = params[:kf_course_index][:kf_course_knowledge_attributes].blank? ? 0 : params[:kf_course_index][:kf_course_knowledge_attributes].size
    # kf_course_todo_size = params[:kf_course_index][:kf_course_todo_attributes].blank? ? 0 : params[:kf_course_index][:kf_course_todo_attributes].size
    # kf_course_form_size = params[:kf_course_index][:kf_course_form_attributes].blank? ? 0 : params[:kf_course_index][:kf_course_form_attributes].size
    # @kf_course_index.item_count = kf_course_knowledge_size + kf_course_todo_size + kf_course_form_size
    respond_to do |format|
      if @kf_course_index.save
        format.html { redirect_to edit_kf_course_index_path({:id => @kf_course_index.id , :tab => params[:kf_course_index][:day_start_type],:course_id => @kf_course_index.kf_course_id, :page => params[:page]}), notice: 'Course index was successfully created.' }
        format.json { render json: @kf_course_index, status: :created, location: @kf_course_index }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_course_index.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/course_indices/1
  # PUT /kf/course_indices/1.json
  def update
    @kf_course_index = Kf::CourseIndex.find(params[:id])
    # kf_course_knowledge_size = params[:kf_course_index][:kf_course_knowledge_attributes].blank? ? 0 : params[:kf_course_index][:kf_course_knowledge_attributes].size
    # kf_course_todo_size = params[:kf_course_index][:kf_course_todo_attributes].blank? ? 0 : params[:kf_course_index][:kf_course_todo_attributes].size
    # kf_course_form_size = params[:kf_course_index][:kf_course_form_attributes].blank? ? 0 : params[:kf_course_index][:kf_course_form_attributes].size
    # @kf_course_index.item_count = kf_course_knowledge_size + kf_course_todo_size + kf_course_form_size
    respond_to do |format|
      if @kf_course_index.update_attributes(params[:kf_course_index])
        format.html { redirect_to "/kf/courses/#{params[:kf_course_index][:kf_course_id]}?page=#{params[:page]}&tab=#{params[:tab]}", notice: 'Course index was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_course_index.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/course_indices/1
  # DELETE /kf/course_indices/1.json
  def destroy
    @kf_course_index = Kf::CourseIndex.find(params[:id])
    @kf_course_index.destroy

    respond_to do |format|
      format.html { redirect_to "/kf/courses/#{@kf_course_index.kf_course_id}?page=#{params[:page]}&tab=#{params[:tab]}" }
      format.json { head :no_content }
    end
  end
end
