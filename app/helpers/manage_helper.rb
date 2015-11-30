# encoding: utf-8
module ManageHelper

# 获取当前状态文字
def app_state_enum ( app_state )
	app_state ||= ""
    enum = getappstateenum
    return enum[app_state.to_s]
end
# 获取当前设备类型文字
def app_phonetype_enum ( app_phonetype )
	app_phonetype ||= ""
    enum = getphonetypeenum
    return enum[app_phonetype.to_s]
end
# 返回所有设备类型的enum
def getphonetypeenum
	return {
    	"" => '全部',
    	"android" => 'android',
    	"ios" => 'ios'
    }
end

# 返回所有状态的enum
def getappstateenum
	return {
    	"" => '全部',
    	"0"  => '新项目',
    	"10" => '签订合同',
    	"20" => '需求整理',
    	"30" => '内容录入',
    	"40" => '技术开发',
    	"50" => '内部测试',
    	"60" => '公开测试',
    	"70" => '交付客户',
    	"80" => '发布推广',
    	"90" => '暂停发布'
    }
end
end
