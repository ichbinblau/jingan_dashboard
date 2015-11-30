# widgetActionBarWidget
$ = this.af
# attr : 表示widget属性，像行数列数等
# data : 为生成widget所用数据
# configs : 上下传参
cache = {}
baseurl = _appcfg_url || "./"
opts = 
	control_id : null
	configs : null
	current_page : null

$.fn["widgetActionBarWidget"] = (options)-> 
	return if this.length == 0
	opt = $.extend({} ,opts , options)
	for item in this
		item._plugin_id = item._plugin_id || $.uuid()
		# 暂时取消缓存，缓存好像只有key，没有内容，不知道为什么
		# if  !cache[item._plugin_id] actionbar
		cache[item._plugin_id] = new widgetActionBarWidget(item , opt)
		tmp = cache[item._plugin_id]
	return if this.length == 1 then tmp else this

widgetActionBarWidget = (el, opts) -> 
	self = this
	self.el = el
	self.$el = $(el)
	self.current_page = opts.current_page
	self.configs = opts.configs
	self.params = $["ecParams"] self.configs.configs
	$(self.$el).one("destroy", (e) ->
		delete cache[self._plugin_id] if cache[self._plugin_id]
	);
	self.configs = opts.configs
	console.log "initWidget : #{opts.configs.control_id}"
	self.init( opts.configs.control_id ) if opts.configs.control_id != null
	return self

widgetActionBarWidget.prototype = 
	name : null
	current_page : null
	widget_type : null
	el : null
	$el : null
	configs : null
	params : null
	init : ( control_id )->
		self = this
		self.name = control_id
		self.widget_type = self.configs.xtype

	setData : () ->
		data = $.parseParams( this.configs.datasource.data ,this )
		# data = this.configs.datasource.data
		if data.withActionBar == "true" then this.showBar() else this.hideBar() if data.withActionBar != ""
		this.setTitle data.title if data.title != ""
		if data.withHomeItem == "true" then this.showHomeItem() else this.hideHomeItem() if data.withHomeItem != ""

	showHomeItem : () ->
		$.ui.showBackButton = true

	hideHomeItem : () ->
		$.ui.showBackButton = false

	showBar : () ->
		$.ui.toggleHeaderMenu true

	hideBar : () ->
		$.ui.toggleHeaderMenu false

	setTitle : (data) ->
		$.ui.setTitle data if data != ""

	getTitle : (data) ->
		return $("#pageTitle").html()

# {
#   "control_id": "page_index_tab_ActionBarWidget",
#   "xtype": "ActionBarWidget",
#   "layout": "",
#   "datasource": {
#     "method": "http://abc/",
#     "data": {
#       "withActionBar": "true",
#       "withHomeItem": "false",
#       "homeIcon": "",
#       "actionBarBg": "",
#       "title": "",
#       "withHomeAsUp": "false"
#     },
#     "params": [],
#     "adapter": []
#   },
#   "setEvent": [
#     {
#       "name": "optionItemClick",
#       "id": "home",
#       "javascript": "this.exitConfim()",
#       "params": []
#     }
#   ],
#   "position": [],
#   "attr": [],
#   "configs": []
# }