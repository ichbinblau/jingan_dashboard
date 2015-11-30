# 修改默认时间格式
Date::DATE_FORMATS[:default] = '%Y-%m-%d'

# if you want to change the format of Time display then add the line below
Time::DATE_FORMATS[:default]= '%Y-%m-%d %H:%M:%S'

# if you want to change the DB date format.
Time::DATE_FORMATS[:db]= '%Y-%m-%d %H:%M:%S'

class ActiveSupport::TimeWithZone
    def as_json(options = {})
        strftime('%Y-%m-%d %H:%M:%S')
    end
end