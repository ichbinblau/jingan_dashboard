class Kf::SortTypesController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/sort_types
  # GET /kf/sort_types.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "title like ? or description like ?"
      conditions.push "%#{params[:search]}%"
      conditions.push "%#{params[:search]}%"
    end
    @kf_sort_types = Kf::SortType.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page] ,:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_sort_types }
    end
  end

  # GET /kf/sort_types/1
  # GET /kf/sort_types/1.json
  def show
    @kf_sort_type = Kf::SortType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_sort_type }
    end
  end

  # GET /kf/sort_types/new
  # GET /kf/sort_types/new.json
  def new
    @kf_sort_type = Kf::SortType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_sort_type }
    end
  end

  # GET /kf/sort_types/1/edit
  def edit
    @kf_sort_type = Kf::SortType.find(params[:id])
  end

  # POST /kf/sort_types
  # POST /kf/sort_types.json
  def create
    @kf_sort_type = Kf::SortType.new(params[:kf_sort_type])

    respond_to do |format|
      if @kf_sort_type.save
        format.html { redirect_to kf_sort_types_url({:page => params[:page]}), notice: 'Sort type was successfully created.' }
        format.json { render json: @kf_sort_type, status: :created, location: @kf_sort_type }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_sort_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/sort_types/1
  # PUT /kf/sort_types/1.json
  def update
    @kf_sort_type = Kf::SortType.find(params[:id])

    respond_to do |format|
      if @kf_sort_type.update_attributes(params[:kf_sort_type])
        format.html { redirect_to kf_sort_types_url({:page => params[:page]}), notice: 'Sort type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_sort_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/sort_types/1
  # DELETE /kf/sort_types/1.json
  def destroy
    @kf_sort_type = Kf::SortType.find(params[:id])
    @kf_sort_type.destroy

    respond_to do |format|
      format.html { redirect_to kf_sort_types_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
