# widgetMapWidget
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
	tpl : """
		<div id="<%= input.page_id %>shop_map" style="height:100%;"></div>
	"""


$.fn["widgetMapWidget"] = (options)-> 
	return if this.length == 0
	opt = $.extend({} ,opts , options)
	for item in this
		item._plugin_id = item._plugin_id || $.uuid()
		if  !cache[item._plugin_id]
			cache[item._plugin_id] = new widgetMapWidget(item, opt)
			tmp = cache[item._plugin_id]
		else
			cache[item._plugin_id].onResume(options)
	return if this.length == 1 then tmp else this

widgetMapWidget = (el, opts) -> 
	self = this
	self.el = el
	self.$el = $(el)
	self.current_page = opts.current_page
	self.configs = opts.configs
	self.params = $.ecParams self.configs.configs
	for item in self.configs.setEvent
		self.events[item.name] = item

	$(self.$el).one("destroy", (e) ->
		delete cache[self._plugin_id] if cache[self._plugin_id]
	);
	self.tpl = opts.tpl
	console.log "initWidget : #{opts.configs.control_id}"
	self.init( opts.configs.control_id ) if opts.configs.control_id != null

widgetMapWidget.prototype = 
	name : null
	current_page : null
	widget_type : null
	el : null
	$el : null
	tpl : null
	configs : null
	params : null
	events : {
		itemLoad : {
			javascript : "",
			params :[]
		}
	}
	init : ( control_id )->
		self = this
		self.name = control_id
		self.widget_type = self.configs.xtype
		$.template_set "widgetMapWidget" , self.tpl

	setData : () ->
		self = this
		data = self.configs.datasource.data
		if Object.toQueryString(data) == ""
			method = this.configs.datasource.method
			$.ui.showMask()
			# console.log "....."+self.params.title
			# $.ui.setTitle(self.params.title)
			$.callApi method , $.ecParams(self.configs.datasource.params , self , 1) , (res) ->
				$.ui.hideMask()
				if res.data.error
					alert "请求出错："+res.data.error.errordes
				else
					self.showContent res , self
		else
			self.showContent data , self
	showContent : (data , self) ->
		console.log "adapter input:" , data
		input = $.adapter( data.data , self.configs.datasource.adapter )
		self.configs.datasource.data = input
		console.log "adapter output:" , input
		console.log "#{self.el.id}:" , $.template( "widgetMapWidget" , { input : input } )
		input.page_id = self.current_page.id
		$("._page#{self.current_page.id} ##{self.el.id}").html $.template( "widgetMapWidget" , { input : input } )
		self.showMap input.title ,input.address,input.phone_num ,input.longitude ,input.latitude

	showMap : (title ,address , phone , long , lati) ->
		self = this
		# head = document.getElementsByTagName('head')[0];
		# script = document.createElement('script');
		# script.type = 'text/javascript';
		# script.src = "http://api.map.baidu.com/api?v=1.5&ak=#{_baidu_key}";
		# head.insertBefore( script, head.firstChild );
		# load_script("http://api.map.baidu.com/api?v=1.5&ak=#{_baidu_key}" , () ->
		# $.feat.nativeTouchScroll = false;
		window.BMap = window.BMap || {};
		BMap.Convertor = {};
		BMap.Convertor.translate = translate;
		# console.log "-----"+long
		# console.log "-----"+Object.toJSON BMap
		# GPS坐标
		ggPoint = new BMap.Point(long,lati);
		setTimeout( ()->
			BMap.Convertor.translate(ggPoint,2,(point ) ->
				# 地图初始化
				bm = new BMap.Map("#{self.current_page.id}shop_map")
				bm.centerAndZoom(point, 18)
				bm.addControl(new BMap.NavigationControl())
				opts = {
					width : 200,     # 信息窗口宽度
					height: 100,     # 信息窗口高度
					enableMessage:false,# 设置允许信息窗发送短息
					title : title  # 信息窗口标题
				}
				infoWindow = new BMap.InfoWindow("地址：#{address}<br />电话：<a href='tel://#{phone}'>#{phone}</a>", opts)  # 创建信息窗口对象
				bm.openInfoWindow(infoWindow,point) # 开启信息窗口
			)
		, 500)
		# )
		self.itemLoadEvent self

	itemLoadEvent : ( self ) ->
		str = "params = {};"
		for k , v of $.ecParams( self.events.itemLoad.params , self )
			str += "params.#{k} = '#{v}';"
		str += "#{self.events.itemLoad.javascript}"
		console.log "itemLoadEvent: eval = "+str
		eval str

load_script = (xyUrl, callback) ->
	console.log "load_script" , xyUrl
	head = document.getElementsByTagName('head')[0];
	script = document.createElement('script');
	script.type = 'text/javascript';
	script.src = xyUrl;
	# 借鉴了jQuery的script跨域方法
	script.onload = script.onreadystatechange = ()->
		if !this.readyState || this.readyState is "loaded" || this.readyState is "complete"
			callback && callback();
			script.onload = script.onreadystatechange = null;
			if head && script.parentNode 
				head.removeChild( script );
	head.insertBefore( script, head.firstChild );

translate = (point,type,callback) ->
	callbackName = 'cbk_' + Math.round(Math.random() * 10000);    #随机函数名
	xyUrl = "http://api.map.baidu.com/ag/coord/convert?from="+ type + "&to=4&x=" + point.lng + "&y=" + point.lat + "&callback=BMap.Convertor." + callbackName;
	# 动态创建script标签
	load_script(xyUrl);
	BMap.Convertor[callbackName] = (xyResult) ->
		delete BMap.Convertor[callbackName];    # 调用完需要删除改函数
		point = new BMap.Point(xyResult.x, xyResult.y);
		callback && callback(point);

# translateCallback = (point , title , address , phone_num) ->
	
		
# (function(){        //闭包
# function load_script(xyUrl, callback){
#     var head = document.getElementsByTagName('head')[0];
#     var script = document.createElement('script');
#     script.type = 'text/javascript';
#     script.src = xyUrl;
#     //借鉴了jQuery的script跨域方法
#     script.onload = script.onreadystatechange = function(){
#         if((!this.readyState || this.readyState === "loaded" || this.readyState === "complete")){
#             callback && callback();
#             // Handle memory leak in IE
#             script.onload = script.onreadystatechange = null;
#             if ( head && script.parentNode ) {
#                 head.removeChild( script );
#             }
#         }
#     };
#     // Use insertBefore instead of appendChild  to circumvent an IE6 bug.
#     head.insertBefore( script, head.firstChild );
# }
# function translate(point,type,callback){
#     var callbackName = 'cbk_' + Math.round(Math.random() * 10000);    //随机函数名
#     var xyUrl = "http://api.map.baidu.com/ag/coord/convert?from="+ type + "&to=4&x=" + point.lng + "&y=" + point.lat + "&callback=BMap.Convertor." + callbackName;
#     //动态创建script标签
#     load_script(xyUrl);
#     BMap.Convertor[callbackName] = function(xyResult){
#         delete BMap.Convertor[callbackName];    //调用完需要删除改函数
#         var point = new BMap.Point(xyResult.x, xyResult.y);
#         callback && callback(point);
#     }
# }

# window.BMap = window.BMap || {};
# BMap.Convertor = {};
# BMap.Convertor.translate = translate;
# })();
# //GPS坐标
# var ggPoint = new BMap.Point(<%= input.longitude %>,<%= input.latitude %>);


# function translateCallback(point){
#   //地图初始化
#   var bm = new BMap.Map("shop_map");
#   bm.centerAndZoom(point, 18);
#   bm.addControl(new BMap.NavigationControl());
#   var opts = {
#     width : 200,     // 信息窗口宽度
#     height: 100,     // 信息窗口高度
#     enableMessage:false,//设置允许信息窗发送短息
#     title : '<%= input.title %>'  // 信息窗口标题
#   }
#   var infoWindow = new BMap.InfoWindow('地址：<%= input.address %><br />电话：<%= input.phone_num %>', opts);  // 创建信息窗口对象
#   bm.openInfoWindow(infoWindow,point); //开启信息窗口
# }
# setTimeout(function(){
#     BMap.Convertor.translate(ggPoint,2,translateCallback);     //GCJ-02坐标转成百度坐标
# }, 500);

