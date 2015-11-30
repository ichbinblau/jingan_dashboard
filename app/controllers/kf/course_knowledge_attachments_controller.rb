# encoding: utf-8
class Kf::CourseKnowledgeAttachmentsController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/course_knowledge_attachments
  # GET /kf/course_knowledge_attachments.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "title like ? "
      conditions.push "%#{params[:search]}%"
    end
    @kf_course_knowledge_attachments = Kf::CourseKnowledgeAttachment.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page] ,:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_course_knowledge_attachments }
    end
  end

  # GET /kf/course_knowledge_attachments/1
  # GET /kf/course_knowledge_attachments/1.json
  def show
    @kf_course_knowledge_attachment = Kf::CourseKnowledgeAttachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_course_knowledge_attachment }
    end
  end

  # GET /kf/course_knowledge_attachments/new
  # GET /kf/course_knowledge_attachments/new.json
  def new
    @kf_course_knowledge_attachment = Kf::CourseKnowledgeAttachment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_course_knowledge_attachment }
    end
  end

  # GET /kf/course_knowledge_attachments/1/edit
  def edit
    @kf_course_knowledge_attachment = Kf::CourseKnowledgeAttachment.find(params[:id])
  end

  # POST /kf/course_knowledge_attachments
  # POST /kf/course_knowledge_attachments.json
  def create
    @kf_course_knowledge_attachment = Kf::CourseKnowledgeAttachment.new(params[:kf_course_knowledge_attachment])

    respond_to do |format|
      if @kf_course_knowledge_attachment.save
        format.html { redirect_to kf_course_knowledge_attachments_url({:page => params[:page]}), notice: 'Course knowledge attachment was successfully created.' }
        format.json { render json: @kf_course_knowledge_attachment, status: :created, location: @kf_course_knowledge_attachment }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_course_knowledge_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/course_knowledge_attachments/1
  # PUT /kf/course_knowledge_attachments/1.json
  def update
    @kf_course_knowledge_attachment = Kf::CourseKnowledgeAttachment.find(params[:id])

    respond_to do |format|
      if @kf_course_knowledge_attachment.update_attributes(params[:kf_course_knowledge_attachment])
        format.html { redirect_to kf_course_knowledge_attachments_url({:page => params[:page]}), notice: 'Course knowledge attachment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_course_knowledge_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/course_knowledge_attachments/1
  # DELETE /kf/course_knowledge_attachments/1.json
  def destroy
    @kf_course_knowledge_attachment = Kf::CourseKnowledgeAttachment.find(params[:id])
    @kf_course_knowledge_attachment.destroy

    respond_to do |format|
      format.html { redirect_to kf_course_knowledge_attachments_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
