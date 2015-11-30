# encoding: utf-8
class Kf::CoursesController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/courses
  # GET /kf/courses.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    joins = ""
    sortids = []
    sortids = params[:sort_id].to_s.split(",") unless params[:sort_id].blank?
    sortsql = sortids.collect{|sortid| "tb#{sortid}.kf_sort_id!=0" }.join(" and ")
    search = " #{sortsql} "
    search += " and " if !params[:search].blank? && !params[:sort_id].blank?
    search += " title like '%#{params[:search]}%' " if !params[:search].blank?
    sortids.each do |sortid|
      joins += " left join kf_courses_kf_sorts tb#{sortid} on( kf_courses.id=tb#{sortid}.kf_course_id and tb#{sortid}.kf_sort_id='#{sortid}' ) "
    end
    @kf_courses = Kf::Course.includes(:kf_children).order("id DESC").where(search).joins(joins).paginate(:page => params[:page], :per_page => params[:per_page] )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_courses }
    end
  end
  
  # GET /kf/courses/1
  # GET /kf/courses/1.json
  def show
    @kf_course = Kf::Course.find(params[:id])

    # 整理内容
    new_courses = {}
    @courses = {}
    @kf_course.kf_course_index.each do |item|
      new_courses[item.day_start_type.to_s] = {} if new_courses[item.day_start_type.to_s].blank?
      new_courses[item.day_start_type.to_s][item.day_start.to_s] = [] if new_courses[item.day_start_type.to_s][item.day_start.to_s].blank?
      new_courses[item.day_start_type.to_s][item.day_start.to_s].push item
    end
    # 界面重新排序
    day_order = ["start_date","day_1_name","day_2_name","day_3_name","day_4_name","day_5_name"]
    day_order.each do |item|
      @courses[item] = new_courses[item].sort_by { |key, value| key.to_i } unless new_courses[item].blank?
    end
    @courses.each do |key,i|
      i.each do |t|
        t[1] = t[1].sort_by{ |value| value.order_level }
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_course }
    end
  end

  # 下载
  def showtext
    @kf_course = Kf::Course.find(params[:id])
    # 整理内容
    new_courses = {}
    @courses = {}
    indices = @kf_course.kf_course_index
    # 子课程的情况
    if @kf_course.kf_children.size > 0
      @kf_course.kf_children.each do |item|
        indices = indices + item.kf_course_index
      end
    end
    indices.each do |item|
      new_courses[item.day_start_type.to_s] = {} if new_courses[item.day_start_type.to_s].blank?
      new_courses[item.day_start_type.to_s][item.day_start.to_s] = [] if new_courses[item.day_start_type.to_s][item.day_start.to_s].blank?
      new_courses[item.day_start_type.to_s][item.day_start.to_s].push item
    end
    # 界面重新排序
    day_order = ["start_date","day_1_name","day_2_name","day_3_name","day_4_name","day_5_name"]
    day_order.each do |item|
      @courses[item] = new_courses[item].sort_by { |key, value| key.to_i } unless new_courses[item].blank?
    end
    @courses.each do |key,i|
      i.each do |t|
        t[1] = t[1].sort_by{ |value| value.order_level }
      end
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_course }
    end
  end

  # 复制
  def dupe
    course = Kf::Course.find(params[:id]).clone_data()
    respond_to do |format|
      format.html { redirect_to kf_courses_url({:page => params[:page]}) , notice: 'Course was successfully duped.' }
      format.json { render json: @kf_course, status: :created, location: @kf_course }
    end
  end

  # 复制index
  def dupe_index
    item = Kf::CourseIndex.find params[:id]
    params[:offset] = 0 if params[:offset].blank?
    for i in 1..(params[:days].to_i)
      item.clone_child(i * (params[:offset].to_i + 1))
    end
    # item.children_count = Kf::CourseIndex.where(:parent_id => item.id).size
    item.save
    render :json => {:success => true}
  end

  # 内容排序
  def order_items
    orders = params[:orders].split ","
    orders.each do |items_order|
      task_a = items_order.split ":"
      task = Kf::CourseIndex.find(task_a[1])
      task.order_level = task_a[0]
      task.save
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {:success => true} }
    end
  end

  # GET /kf/courses/new
  # GET /kf/courses/new.json
  def new
    @kf_course = Kf::Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_course }
    end
  end

  # GET /kf/courses/1/edit
  def edit
    @kf_course = Kf::Course.find(params[:id])
  end

  # POST /kf/courses
  # POST /kf/courses.json
  def create
    @kf_course = Kf::Course.new(params[:kf_course])

    respond_to do |format|
      if @kf_course.save
        format.html { redirect_to kf_courses_url({:page => params[:page]}) , notice: 'Course was successfully created.' }
        format.json { render json: @kf_course, status: :created, location: @kf_course }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/courses/1
  # PUT /kf/courses/1.json
  def update
    @kf_course = Kf::Course.find(params[:id])

    respond_to do |format|
      if @kf_course.update_attributes(params[:kf_course])
        format.html { redirect_to kf_courses_url({:page => params[:page]}), notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/courses/1
  # DELETE /kf/courses/1.json
  def destroy
    @kf_course = Kf::Course.find(params[:id])
    @kf_course.destroy

    respond_to do |format|
      format.html { redirect_to kf_courses_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
