class CmsSortsPlugincfgInfos < ActiveRecord::Base
  attr_accessible :cms_sort_id , :plugincfg_info_id

  rails_admin do
    visible false
  end
end
