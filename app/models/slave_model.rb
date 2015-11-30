# encoding: utf-8
class SlaveModel < ActiveRecord::Base
	self.abstract_class = true
	use_connection_ninja(:slave_database)
end