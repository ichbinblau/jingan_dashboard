class FormScheme < ActiveRecord::Base
  attr_accessible :cols_order, :description, :form_num, :name, :op10_config, :op10_name, :op11_config, :op11_name, :op12_config, :op12_name, :op13_config, :op13_name, :op14_config, :op14_name, :op15_config, :op15_name, :op16_config, :op16_name, :op17_config, :op17_name, :op18_config, :op18_name, :op19_config, :op19_name, :op1_config, :op1_name, :op20_config, :op20_name, :op21_config, :op21_name, :op22_config, :op22_name, :op23_config, :op23_name, :op24_config, :op24_name, :op25_config, :op25_name, :op26_config, :op26_name, :op27_config, :op27_name, :op28_config, :op28_name, :op29_config, :op29_name, :op2_config, :op2_name, :op30_config, :op30_name, :op3_config, :op3_name, :op4_config, :op4_name, :op5_config, :op5_name, :op6_config, :op6_name, :op7_config, :op7_name, :op8_config, :op8_name, :op9_config, :op9_name, :project_info_id, :sort_id, :state
  has_many :form_info
  belongs_to :project_info
end
