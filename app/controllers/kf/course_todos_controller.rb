# encoding: utf-8
class Kf::CourseTodosController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/course_todos
  # GET /kf/course_todos.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "title like ? "
      conditions.push "%#{params[:search]}%"
    end
    @kf_course_todos = Kf::CourseTodo.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page] ,:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_course_todos }
    end
  end

  # GET /kf/course_todos/1
  # GET /kf/course_todos/1.json
  def show
    @kf_course_todo = Kf::CourseTodo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_course_todo }
    end
  end

  # GET /kf/course_todos/new
  # GET /kf/course_todos/new.json
  def new
    @kf_course_todo = Kf::CourseTodo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_course_todo }
    end
  end

  # GET /kf/course_todos/1/edit
  def edit
    @kf_course_todo = Kf::CourseTodo.find(params[:id])
  end

  # POST /kf/course_todos
  # POST /kf/course_todos.json
  def create
    @kf_course_todo = Kf::CourseTodo.new(params[:kf_course_todo])

    respond_to do |format|
      if @kf_course_todo.save
        format.html { redirect_to kf_course_todos_url({:page => params[:page]}), notice: 'Course todo was successfully created.' }
        format.json { render json: @kf_course_todo, status: :created, location: @kf_course_todo }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_course_todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/course_todos/1
  # PUT /kf/course_todos/1.json
  def update
    @kf_course_todo = Kf::CourseTodo.find(params[:id])

    respond_to do |format|
      if @kf_course_todo.update_attributes(params[:kf_course_todo])
        format.html { redirect_to kf_course_todos_url({:page => params[:page]}), notice: 'Course todo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_course_todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/course_todos/1
  # DELETE /kf/course_todos/1.json
  def destroy
    @kf_course_todo = Kf::CourseTodo.find(params[:id])
    @kf_course_todo.destroy

    respond_to do |format|
      format.html { redirect_to kf_course_todos_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
