# encoding: utf-8
class Kf::CourseKnowledgesController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/course_knowledges
  # GET /kf/course_knowledges.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "title like ? or description like ?"
      conditions.push "%#{params[:search]}%"
      conditions.push "%#{params[:search]}%"
    end
    @kf_course_knowledges = Kf::CourseKnowledge.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page] ,:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_course_knowledges }
    end
  end

  # GET /kf/course_knowledges/1
  # GET /kf/course_knowledges/1.json
  def show
    @kf_course_knowledge = Kf::CourseKnowledge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_course_knowledge }
    end
  end

  # GET /kf/course_knowledges/new
  # GET /kf/course_knowledges/new.json
  def new
    @kf_course_knowledge = Kf::CourseKnowledge.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_course_knowledge }
    end
  end

  # GET /kf/course_knowledges/1/edit
  def edit
    @kf_course_knowledge = Kf::CourseKnowledge.find(params[:id])
  end

  # POST /kf/course_knowledges
  # POST /kf/course_knowledges.json
  def create
    @kf_course_knowledge = Kf::CourseKnowledge.new(params[:kf_course_knowledge])

    respond_to do |format|
      if @kf_course_knowledge.save
        format.html { redirect_to kf_course_knowledges_url({:page => params[:page]}), notice: 'Course knowledge was successfully created.' }
        format.json { render json: @kf_course_knowledge, status: :created, location: @kf_course_knowledge }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_course_knowledge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/course_knowledges/1
  # PUT /kf/course_knowledges/1.json
  def update
    @kf_course_knowledge = Kf::CourseKnowledge.find(params[:id])

    respond_to do |format|
      if @kf_course_knowledge.update_attributes(params[:kf_course_knowledge])
        format.html { redirect_to kf_course_knowledges_url({:page => params[:page]}), notice: 'Course knowledge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_course_knowledge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/course_knowledges/1
  # DELETE /kf/course_knowledges/1.json
  def destroy
    @kf_course_knowledge = Kf::CourseKnowledge.find(params[:id])
    @kf_course_knowledge.destroy

    respond_to do |format|
      format.html { redirect_to kf_course_knowledges_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
