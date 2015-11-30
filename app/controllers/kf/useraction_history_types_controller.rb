class Kf::UseractionHistoryTypesController < ApplicationController
  before_filter:authenticate_admin_user!
  def perpage
    20
  end
  # GET /kf/useraction_history_types
  # GET /kf/useraction_history_types.json
  def index
    conditions = []
    params[:per_page] = perpage if params[:per_page].nil?
    params[:page] = 1 if params[:page].blank?
    unless params[:search].blank?
      conditions.push "title like ? or description like ?"
      conditions.push "%#{params[:search]}%"
      conditions.push "%#{params[:search]}%"
    end
    @kf_useraction_history_types = Kf::UseractionHistoryType.order("id DESC").paginate(:page => params[:page], :per_page => params[:per_page],:conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kf_useraction_history_types }
    end
  end

  # GET /kf/useraction_history_types/1
  # GET /kf/useraction_history_types/1.json
  def show
    @kf_useraction_history_type = Kf::UseractionHistoryType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @kf_useraction_history_type }
    end
  end

  # GET /kf/useraction_history_types/new
  # GET /kf/useraction_history_types/new.json
  def new
    @kf_useraction_history_type = Kf::UseractionHistoryType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @kf_useraction_history_type }
    end
  end

  # GET /kf/useraction_history_types/1/edit
  def edit
    @kf_useraction_history_type = Kf::UseractionHistoryType.find(params[:id])
  end

  # POST /kf/useraction_history_types
  # POST /kf/useraction_history_types.json
  def create
    @kf_useraction_history_type = Kf::UseractionHistoryType.new(params[:kf_useraction_history_type])

    respond_to do |format|
      if @kf_useraction_history_type.save
        format.html { redirect_to kf_useraction_history_types_url({:page => params[:page]}), notice: 'Useraction history type was successfully created.' }
        format.json { render json: @kf_useraction_history_type, status: :created, location: @kf_useraction_history_type }
      else
        format.html { render action: "new" }
        format.json { render json: @kf_useraction_history_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /kf/useraction_history_types/1
  # PUT /kf/useraction_history_types/1.json
  def update
    @kf_useraction_history_type = Kf::UseractionHistoryType.find(params[:id])

    respond_to do |format|
      if @kf_useraction_history_type.update_attributes(params[:kf_useraction_history_type])
        format.html { redirect_to kf_useraction_history_types_url({:page => params[:page]}), notice: 'Useraction history type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @kf_useraction_history_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kf/useraction_history_types/1
  # DELETE /kf/useraction_history_types/1.json
  def destroy
    @kf_useraction_history_type = Kf::UseractionHistoryType.find(params[:id])
    @kf_useraction_history_type.destroy

    respond_to do |format|
      format.html { redirect_to kf_useraction_history_types_url({:page => params[:page]}) }
      format.json { head :no_content }
    end
  end
end
