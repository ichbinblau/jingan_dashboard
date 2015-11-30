# encoding: utf-8
class Kf::SortsController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/sorts
  # GET /kf/sorts.json
  def index
    conditions = []
    where = ""
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "name like ? or description like ?"
      conditions.push "%#{params[:search]}%"
      conditions.push "%#{params[:search]}%"
    end
    where = "deep = #{params[:deep]}" unless params[:deep].blank?
    @kf_sorts = Kf::Sort.select("* , CONCAT(name , ' | ' , description) as ectitle").order("id DESC").where(where).paginate(:page => params[:page], :per_page => params[:per_page],:conditions => conditions)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_sorts }
    end
  end
  def for_deep4
    params[:deep] = 4
    return index
  end
  # GET /kf/sorts/1
  # GET /kf/sorts/1.json
  def show
    @kf_sort = Kf::Sort.find(params[:id])
    @kf_sort[:children] = @kf_sort.children
    @sort_config = nil
    @viewconfig = JSON.parse( Kf::GlobalConfig.where(:key => "sort_config").first.value )
    @sort_config = @viewconfig[@kf_sort.top_id.to_s][@kf_sort.deep.to_s] if !@viewconfig[@kf_sort.top_id.to_s].blank? && !@viewconfig[@kf_sort.top_id.to_s][@kf_sort.deep.to_s].blank?
    @sort_config = @viewconfig[@kf_sort.id.to_s] if @kf_sort.top_id == 0 && !@viewconfig[@kf_sort.id.to_s].blank?

    Rails.logger.info @sort_config.to_json
    respond_to do |format|
      format.html { render !@sort_config.nil? && @sort_config["admin_view_index"] ? @sort_config["admin_view_index"] : "show.html.erb" }
      format.json { render json: @kf_sort }
    end
  end

  # GET /kf/sorts/new
  # GET /kf/sorts/new.json
  def new
    @kf_sort = Kf::Sort.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_sort }
    end
  end

  # GET /kf/sorts/1/edit
  def edit
    @kf_sort = Kf::Sort.find(params[:id])
  end

  # POST /kf/sorts
  # POST /kf/sorts.json
  def create
    @kf_sort = Kf::Sort.new(params[:kf_sort])

    respond_to do |format|
      if @kf_sort.save
        if @kf_sort.father_id != 0
          format.html { redirect_to "/kf/sorts/#{params[:kf_sort][:father_id]}" , notice: 'Sort was successfully created.' }
        else
          format.html { redirect_to kf_sorts_url , notice: 'Sort was successfully created.' }
        end
        format.json { render json: @kf_sort, status: :created, location: @kf_sort }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_sort.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/sorts/1
  # PUT /kf/sorts/1.json
  def update
    @kf_sort = Kf::Sort.find(params[:id])

    respond_to do |format|
      if @kf_sort.update_attributes(params[:kf_sort])
        if @kf_sort.father_id != 0
          format.html { redirect_to "/kf/sorts/#{params[:kf_sort][:father_id]}" , notice: 'Sort was successfully updated.' }
        else
          format.html { redirect_to kf_sorts_url , notice: 'Sort was successfully updated.' }
        end
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_sort.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/sorts/1
  # DELETE /kf/sorts/1.json
  def destroy
    @kf_sort = Kf::Sort.find(params[:id])
    @kf_sort.destroy

    respond_to do |format|
      if params[:sort_father_id] != 0.to_s
        format.html { redirect_to "/kf/sorts/#{params[:sort_father_id]}" }
      else
        format.html { redirect_to kf_sorts_url }
      end
      format.json { head :no_content }
    end
  end
end
