# appPage
$ = this.af
# internal cache of objects
cache = {}
page_cache = {}
session_id = $.uuid()
baseurl = _appcfg_url || "./"
opts = 
	page_id : null
global_widget = ["TabWidget","ActionBarWidget"]

$.fn["appPage"] = (options)-> 
	return if this.length == 0
	opt = $.extend({} ,opts , options)
	for item in this
		item._plugin_id = item._plugin_id || $.uuid()
		# if  !cache[item._plugin_id]
		cache[item._plugin_id] = new appPage(item , opt)
		tmp = cache[item._plugin_id]
		# else
		# 	cache[item._plugin_id].onResume(options)
	return if this.length == 1 then tmp else this

appPage = (el, opts) ->
	self = this
	this.el = el
	this.$el = $(el)
	$(this.$el).one("destroy", (e) ->
		delete cache[self._plugin_id] if cache[self._plugin_id]
	);
	self.params = opts.params
	console.log "initpage : #{opts.page_id} ; params: #{Object.toJSON self.params}"
	self.init( opts.page_id ) if opts.page_id != null
	return self

appPage.prototype = 
	name : null
	id : null
	el : null
	$el : null
	params : null
	configs : null
	sets : null
	controls : null
	widgets : {}
	current_page : null
	init : ( page_id )->
		self = this
		this.current_page = self
		self.url = page_id
		self.id = $.getPageID page_id
		self.name = page_id.split("?")[0]
		$.ui.showMask()
		$.ui.updateContentDiv "._page#{self.id}" , ""
		$.ui.setTitle ""
		# self.loadPageConfig( (data)->
		$.getJSON "page_config?name=#{self.name}.json&session=#{session_id}" ,{} , (data) ->
			$.ui.hideMask()
			# page_cache[self.name] = data
			self.configs = data
			self.sets = $.ecParams data.configs ,self
			$.ui.setTitle(self.params.title) if self.params? && self.params.title?
			if self.sets.layout?
				$("._page#{self.id}").html self.sets.layout
			self.controls = {}
			# 保存 controls配置到当前控件，key-value模式
			data.controls.map (item) ->
				self.controls[self.name + item.control_id] = item
			# 启动 controls
			for item in data.auto_start_controls
				continue if "undefined" == typeof self.controls[self.name + item]
				self.startControl self.name + item

	onResume : (options) ->
		self = this
		# console.log "apppage : resume - #{self.name}"
		# console.log "params : #{Object.toJSON( self.params )} "
		# console.log "newpar : #{Object.toJSON(options.params) }"
		$.ui.setTitle(options.params.title) if options.params.title
		if self.params? && Object.toJSON(self.params) != Object.toJSON(options.params)
			self.params = options.params
			# 重新启动 controls
			console.log "apppage : renew - #{self.name}"
			for item in data.auto_start_controls
				continue if "undefined" == typeof self.controls[self.name + item]
				self.startControl self.name + item

	startControl : (control_id) ->
		self = this
		control = self.controls[control_id]
		pos_cfg = {}
		#位置设置数据处理
		if control.position.length > 0
			control.position.map (val) -> 
				pos_cfg[val.key] = val.value || val.defaultValue
		# 添加控件容器，启动控件
		if pos_cfg["parent"] && pos_cfg["location"] && -1 is global_widget.indexOf(control.xtype)
			content = """
				<div id="#{control.control_id}" class="insert-type-#{pos_cfg.insertType}"></div>
			"""
			if $("._page#{self.id} ##{pos_cfg.parent}").children().length >= parseInt(pos_cfg["location"])+1
				console.log "insert control"
				$(content).insertBefore( $("._page#{self.id} ##{pos_cfg.parent}").children().get(pos_cfg["location"]) )
			else
				console.log "append control"
				$("._page#{self.id} ##{pos_cfg.parent}").append( $(content) )
			console.log "._page#{self.id} ##{pos_cfg.parent}","##{control.control_id}"
			self.runControl $("._page#{self.id} ##{control.control_id}") , control
		else
			self.runControl $("#widgets") , control

	runControl : (selector , configs) ->
		self = this
		if selector["widget"+configs.xtype]?
			widget = selector["widget"+configs.xtype] { current_page :self , configs : configs}
			widget.setData()
			self.widgets[configs.control_id] = widget
		else
			console.log "widget"+configs.xtype+" not found"



