class Kf::PipesController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/pipes
  # GET /kf/pipes.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "name like ? or description like ?"
      conditions.push "%#{params[:search]}%"
      conditions.push "%#{params[:search]}%"
    end
    @kf_pipes = Kf::Pipe.order("order_level DESC").paginate(:page => params[:page], :per_page => params[:per_page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_pipes }
    end
  end

  # GET /kf/pipes/1
  # GET /kf/pipes/1.json
  def show
    @kf_pipe = Kf::Pipe.find(params[:id])
    @kf_pipe[:children] = @kf_pipe.children
    @pipe_config = nil
    @viewconfig = JSON.parse( Kf::GlobalConfig.where(:key => "pipe_config").first.value )
    @pipe_config = @viewconfig[@kf_pipe.top_id.to_s][@kf_pipe.deep.to_s] if !@viewconfig[@kf_pipe.top_id.to_s].blank? && !@viewconfig[@kf_pipe.top_id.to_s][@kf_pipe.deep.to_s].blank?
    @pipe_config = @viewconfig[@kf_pipe.id.to_s] if @kf_pipe.top_id == 0 && !@viewconfig[@kf_pipe.id.to_s].blank?

    respond_to do |format|
      format.html { render !@pipe_config.nil? && @pipe_config["admin_view_index"] ? @pipe_config["admin_view_index"] : "show.html.erb" }
      format.json { render json: @kf_pipe }
    end
  end

  # GET /kf/pipes/new
  # GET /kf/pipes/new.json
  def new
    @kf_pipe = Kf::Pipe.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_pipe }
    end
  end

  # GET /kf/pipes/1/edit
  def edit
    @kf_pipe = Kf::Pipe.find(params[:id])
  end

  # POST /kf/pipes
  # POST /kf/pipes.json
  def create
    @kf_pipe = Kf::Pipe.new(params[:kf_pipe])

    if @kf_pipe.save
        if @kf_pipe.father_id != 0
          return redirect_to "/kf/pipes/#{params[:kf_pipe][:father_id]}"
        else
          format.html { redirect_to kf_pipes_url , notice: 'Sort was successfully created.' }
        end
        format.json { render json: @kf_pipe, status: :created, location: @kf_pipe }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_pipe.errors, status: :unprocessable_entity }
      end
  end

  # PUT /kf/pipes/1
  # PUT /kf/pipes/1.json
  def update
    @kf_pipe = Kf::Pipe.find(params[:id])

    respond_to do |format|
      if @kf_pipe.update_attributes(params[:kf_pipe])
        if @kf_pipe.father_id != 0
          return redirect_to "/kf/pipes/#{params[:kf_pipe][:father_id]}"
        else
          format.html { redirect_to kf_pipes_url , notice: 'Pipe was successfully updated.' }
        end
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_pipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/pipes/1
  # DELETE /kf/pipes/1.json
  def destroy
    @kf_pipe = Kf::Pipe.find(params[:id])
    @kf_pipe.destroy

    respond_to do |format|
      format.html { redirect_to kf_pipes_url }
      format.json { head :no_content }
    end
  end
end
