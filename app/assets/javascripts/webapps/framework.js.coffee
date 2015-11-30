# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
root = this
root.webRoot = "./"
appnum = _appnum
apibaseurl = "/webapis/wiki/"

# 手工初始化界面，显示splash
$.ui.autoLaunch = false
# 初始化界面
@init = ->
	$.post apibaseurl+"init_api" , { appnum : appnum } , ->
		$.ui.backButtonText = "返回"
		$.ui.launch()
		# window.setTimeout( ->
		# , 1000)
document.addEventListener("DOMContentLoaded", root.init, false)

# $("#content").html content
# app内嵌webapp
@onDeviceReady = ->
	AppMobi.device.setRotateOrientation("portrait")
	AppMobi.device.setAutoRotate(false)
	root.webRoot = AppMobi.webRoot + "/"
	# hide splash screen

	AppMobi.device.hideSplashScreen()
    # $.ui.blockPageScroll()  # block the page from scrolling at the header/footer


document.addEventListener("appMobi.device.ready", root.onDeviceReady, false)

# ui初始化成功后
$.ui.ready( ->
	$.ui.disableSideMenu()
	$.ui.disableNativeScrolling()
	$("#content").appPage { page_id : "page_index_tab" }
	#This function will get executed when $.ui.launch has completed
)

# content = """
# <div title='' id="main" class="panel" selected="true">
# <ul class="list">
# <li>Test</li>
# <li><a href="#" data-transition="pop" data-persist-ajax="true">Test</a></li>
# <li><a href="#webactionsheet" >Zzzzzzzz</a></li>
# <li>Test</li>
# <li>Test</li>
# <li>Test</li>
# <li><a href="#" data-transition="pop" data-persist-ajax="true">Test</a></li>
# <li><a href="#webactionsheet" >Zzzzzzzz</a></li>
# <li>Test</li>
# <li>Test</li>
# <li>Test</li>
# <li><a href="#" data-transition="pop" data-persist-ajax="true">Test</a></li>
# <li><a href="#webactionsheet" >Zzzzzzzz</a></li>
# <li>Test</li>
# <li>Test</li>
# <li>Test</li>
# <li><a href="#" data-transition="pop" data-persist-ajax="true">Test</a></li>
# <li><a href="#webactionsheet" >Zzzzzzzz</a></li>
# <li>Test</li>
# <li>Test</li>
# <li>Test</li>
# <li><a href="#" data-transition="pop" data-persist-ajax="true">Test</a></li>
# <li><a href="#webactionsheet" >Zzzzzzzz</a></li>
# <li>Test</li>
# <li>Test</li>
# <li>Test</li>
# <li><a href="#" data-transition="pop" data-persist-ajax="true">Test</a></li>
# <li><a href="#webactionsheet" >Zzzzzzzz</a></li>
# <li>Test</li>
# <li>Test</li>
# </ul> 
# </div>
# """
# $.ui.updatePanel "#content" ,content