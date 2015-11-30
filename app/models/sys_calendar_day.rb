# encoding: utf-8
class SysCalendarDay < ActiveRecord::Base
  attr_accessible :time_type,:date_start,:date_end,:week_day,:year_week,:year_month
  rails_admin do
    visible false
  end
end
