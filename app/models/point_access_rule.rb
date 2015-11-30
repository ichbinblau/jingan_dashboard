# encoding: utf-8
class PointAccessRule < ActiveRecord::Base
  belongs_to :project_info
  belongs_to :point_action_type
  belongs_to :point_excute_rule
  attr_accessible  :project_info_id,:point_action_type_id,:point_excute_rule_id,:is_add
  rails_admin do
    navigation_label '项目'
    weight 12
  end
end