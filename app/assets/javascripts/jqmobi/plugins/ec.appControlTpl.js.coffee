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
		if  !cache[item._plugin_id]
			cache[item._plugin_id] = new widgetActionBarWidget(item , opt)
			tmp = cache[item._plugin_id]
	return if this.length == 1 then tmp else this

widgetActionBarWidget = (el, opts) -> 
	self = this
	this.el = el
	this.$el = $(el)
	this.current_page = opts.current_page
	$(this.$el).one("destroy", (e) ->
		delete cache[self._plugin_id] if cache[self._plugin_id]
	);
	self.configs = opts.configs
	console.log "initWidget : #{opts.configs.control_id}"
	self.init( opts.configs.control_id ) if opts.configs.control_id != null

widgetActionBarWidget.prototype = 
	name : null
	current_page : null
	widget_type : null
	el : null
	$el : null
	configs : null
	init : ( control_id )->
		self = this
		self.name = control_id
		self.widget_type = self.configs.xtype
		self.setData self.configs.datasource.data

	setData : (data) ->
		this.setTitle data.title if data.title != ""

	setTitle : (data) ->
		$.ui.setTitle data if data != ""

	getTitle : (data) ->
		return $("#pageTitle").html()
