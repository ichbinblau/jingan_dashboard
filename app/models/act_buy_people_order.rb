# encoding: utf-8
class ActBuyPeopleOrder < ActiveRecord::Base
  belongs_to :act_buy_order
  attr_accessible  :username,:phone,:card_id,:sex,:age,:address,:project_info_id
  rails_admin do
    visible false
    list do
      field :username
      field :phone
    end
  end
end
