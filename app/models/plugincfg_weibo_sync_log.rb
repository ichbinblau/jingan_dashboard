# encoding: utf-8
class PlugincfgWeiboSyncLog < ActiveRecord::Base
  attr_accessible :cms_content_id,:project_info_id,:weibo_type,:content,:image,:success
  rails_admin do
    visible false
  end
end
