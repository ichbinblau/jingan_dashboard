# encoding: utf-8
class Kf::DiariesController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/diaries
  # GET /kf/diaries.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "title like ? "
      conditions.push "%#{params[:search]}%"
    end
    @kf_diaries = Kf::Diary.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page] ,:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_diaries }
    end
  end

  # GET /kf/diaries/1
  # GET /kf/diaries/1.json
  def show
    @kf_diary = Kf::Diary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_diary }
    end
  end

  # GET /kf/diaries/new
  # GET /kf/diaries/new.json
  def new
    @kf_diary = Kf::Diary.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_diary }
    end
  end

  # GET /kf/diaries/1/edit
  def edit
    @kf_diary = Kf::Diary.find(params[:id])
  end

  # POST /kf/diaries
  # POST /kf/diaries.json
  def create
    @kf_diary = Kf::Diary.new(params[:kf_diary])

    respond_to do |format|
      if @kf_diary.save
        format.html { redirect_to kf_diaries_url({:page => params[:page]}), notice: 'Diary was successfully created.' }
        format.json { render json: @kf_diary, status: :created, location: @kf_diary }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_diary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/diaries/1
  # PUT /kf/diaries/1.json
  def update
    @kf_diary = Kf::Diary.find(params[:id])

    respond_to do |format|
      if @kf_diary.update_attributes(params[:kf_diary])
        format.html { redirect_to kf_diaries_url({:page => params[:page]}), notice: 'Diary was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_diary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/diaries/1
  # DELETE /kf/diaries/1.json
  def destroy
    @kf_diary = Kf::Diary.find(params[:id])
    @kf_diary.destroy

    respond_to do |format|
      format.html { redirect_to kf_diaries_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
