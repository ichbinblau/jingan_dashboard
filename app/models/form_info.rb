class FormInfo < ActiveRecord::Base
  attr_accessible :batch_id, :form_scheme_id, :op1, :op10, :op11, :op12, :op13, :op14, :op15, :op16, :op17, :op18, :op19, :op2, :op20, :op21, :op22, :op23, :op24, :op25, :op26, :op27, :op28, :op29, :op3, :op30, :op4, :op5, :op6, :op7, :op8, :op9, :project_info_id, :state, :user_info_id
  belongs_to :form_scheme
  belongs_to :user_info
  belongs_to :project_info
end
