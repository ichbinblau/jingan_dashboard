# encoding: utf-8
class Kf::CourseUserFavsController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/course_user_favs
  # GET /kf/course_user_favs.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    @kf_course_user_favs = Kf::CourseUserFav.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page] )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_course_user_favs }
    end
  end

  # GET /kf/course_user_favs/1
  # GET /kf/course_user_favs/1.json
  def show
    @kf_course_user_fav = Kf::CourseUserFav.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_course_user_fav }
    end
  end

  # GET /kf/course_user_favs/new
  # GET /kf/course_user_favs/new.json
  def new
    @kf_course_user_fav = Kf::CourseUserFav.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_course_user_fav }
    end
  end

  # GET /kf/course_user_favs/1/edit
  def edit
    @kf_course_user_fav = Kf::CourseUserFav.find(params[:id])
  end

  # POST /kf/course_user_favs
  # POST /kf/course_user_favs.json
  def create
    @kf_course_user_fav = Kf::CourseUserFav.new(params[:kf_course_user_fav])

    respond_to do |format|
      if @kf_course_user_fav.save
        format.html { redirect_to kf_course_user_favs_url({:page => params[:page]}), notice: 'Course user fav was successfully created.' }
        format.json { render json: @kf_course_user_fav, status: :created, location: @kf_course_user_fav }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_course_user_fav.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/course_user_favs/1
  # PUT /kf/course_user_favs/1.json
  def update
    @kf_course_user_fav = Kf::CourseUserFav.find(params[:id])

    respond_to do |format|
      if @kf_course_user_fav.update_attributes(params[:kf_course_user_fav])
        format.html { redirect_to kf_course_user_favs_url({:page => params[:page]}), notice: 'Course user fav was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_course_user_fav.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/course_user_favs/1
  # DELETE /kf/course_user_favs/1.json
  def destroy
    @kf_course_user_fav = Kf::CourseUserFav.find(params[:id])
    @kf_course_user_fav.destroy

    respond_to do |format|
      format.html { redirect_to kf_course_user_favs_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
