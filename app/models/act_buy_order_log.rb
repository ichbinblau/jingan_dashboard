class ActBuyOrderLog < ActiveRecord::Base
  # attr_accessible :title, :body




  def attr_copy(act_buy_order=nil)

    if !act_buy_order.nil?
      self[:remarks]=act_buy_order[:remarks]
      self[:act_buy_order_id] = act_buy_order[:id]
      self[:act_status_type_id] = act_buy_order[:act_status_type_id ]
      self[:must_price]=  act_buy_order[:must_price]
      self[:created_at]= act_buy_order[:created_at]
      self[:json_property]= act_buy_order[:json_property]
      self[:title]=act_buy_order[:title]
      self[:cms_sort_id]= act_buy_order[:cms_sort_id]
      self[:project_info_id]= act_buy_order[:project_info_id]

    end

    self
  end

  rails_admin do
    visible false
  end

end
