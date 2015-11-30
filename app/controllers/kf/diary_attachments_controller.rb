# encoding: utf-8
class Kf::DiaryAttachmentsController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/diary_attachments
  # GET /kf/diary_attachments.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "title like ? "
      conditions.push "%#{params[:search]}%"
    end
    @kf_diary_attachments = Kf::DiaryAttachment.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page] ,:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_diary_attachments }
    end
  end

  # GET /kf/diary_attachments/1
  # GET /kf/diary_attachments/1.json
  def show
    @kf_diary_attachment = Kf::DiaryAttachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_diary_attachment }
    end
  end

  # GET /kf/diary_attachments/new
  # GET /kf/diary_attachments/new.json
  def new
    @kf_diary_attachment = Kf::DiaryAttachment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_diary_attachment }
    end
  end

  # GET /kf/diary_attachments/1/edit
  def edit
    @kf_diary_attachment = Kf::DiaryAttachment.find(params[:id])
  end

  # POST /kf/diary_attachments
  # POST /kf/diary_attachments.json
  def create
    @kf_diary_attachment = Kf::DiaryAttachment.new(params[:kf_diary_attachment])

    respond_to do |format|
      if @kf_diary_attachment.save
        format.html { redirect_to kf_diary_attachments_url({:page => params[:page]}), notice: 'Diary attachment was successfully created.' }
        format.json { render json: @kf_diary_attachment, status: :created, location: @kf_diary_attachment }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_diary_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/diary_attachments/1
  # PUT /kf/diary_attachments/1.json
  def update
    @kf_diary_attachment = Kf::DiaryAttachment.find(params[:id])

    respond_to do |format|
      if @kf_diary_attachment.update_attributes(params[:kf_diary_attachment])
        format.html { redirect_to kf_diary_attachments_url({:page => params[:page]}), notice: 'Diary attachment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_diary_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/diary_attachments/1
  # DELETE /kf/diary_attachments/1.json
  def destroy
    @kf_diary_attachment = Kf::DiaryAttachment.find(params[:id])
    @kf_diary_attachment.destroy

    respond_to do |format|
      format.html { redirect_to kf_diary_attachments_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
