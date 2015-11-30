class KfzsadminController < ApplicationController
	before_filter:authenticate_admin_user!
  def perpage
    20
  end
  def index
    @admininfo = admin_info
    # render :json => {:abc => "123"}
  end
end
