class UserVcodeOrder < ActiveRecord::Base
  attr_accessible  :mobile, :code, :isuse, :created_at, :updated_at

end
