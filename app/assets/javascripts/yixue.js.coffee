root = this
father_id = 1718
sort_ids = { "1723":"内科学","1724":"外科学","1725":"消​化​内​科​学","1726":"临床诊断学","1727":"综合护理学","1728":"口​腔​内科学","1729":"心​​内​科​学","1730":"药理学" }
sort_id = 0
page_now = 1
page_perpage = 30

topic_all_num = 79
topic_now_num = 0
topics_info = {}
topics_stack = []
topics_finished_stack = []
topic_answers = {}
count_error = 0
count_success = 0
load_fun = {}

@get_new_topics = (page)->
	$.get "call_api" , 
		method: "content/news/index"
		version: "1.0"
		father_id: sort_id
		simple_result: "1"
		page: page
		perpage: page_perpage
	.done (result) ->
		for i in result.data.content_list
			topics_stack.push i
		root.next_topic() if topic_now_num == 0

@get_rand_topics = (page)->
	$.get "call_api" , 
		method: "content/news/index"
		version: "1.0"
		father_id: sort_id
		simple_result: "1"
		rand_result: "1"
		page: page
		perpage: page_perpage
	.done (result) ->
		for i in result.data.content_list
			topics_stack.push i
		root.next_topic() if topic_now_num == 0
		page_now = page + 1

@get_fav_topics = (page)->
	$.get "call_api" , 
		method: "user/favorites"
		version: "1.0"
		father_id: sort_id
		page: 1
		perpage: 100
	.done (result) ->
		# 获取收藏仅执行一次
		load_fun = ->

		for i in result.data.content_list
			topics_stack.push i
		root.next_topic() if topic_now_num == 0
		page_now = page + 1
		$(".topic-all").html result.data.content_list.length


@next_topic = () ->
	show_topic true

@pre_topic = () ->
	show_topic false
	
show_topic = (next)->
	# return alert "没有更多题目了" if topic_now_num > topics_stack.length
	topic_now_num = if next == true then topic_now_num + 1 else topic_now_num - 1
	# 准备数据
	topic = topics_stack[topic_now_num-1]
	content = JSON.parse topic.content
	topic.options = content.options.split "\n"
	topic.answer = content.answer
	topics_info[topic.id] = topic
	# 显示题目
	$(".topic-title").html topic.title
	$(".topic-des").hide().html topic.abstract
	$(".topic-sum").hide()
	opt_html = ""
	for i,k in content.options.split "\n"
		opt_html += '<label optionnum="'+(k+1)+'"><span class="input"><input type="radio" optionnum="'+(k+1)+'" name="square-radio"/></span>&nbsp;&nbsp;<span class="content">'+i+'</span></label>'
	$(".options").html opt_html
	$('input').iCheck
		checkboxClass: 'icheckbox_square-blue'
		radioClass: 'iradio_square-blue'
	.on 'ifChecked', (event,obj) ->
		root.check topic.id ,$(event.target).attr("optionnum")
	# 显示按钮、统计等
	$(".topic-now").html topic_now_num
	$(".action-fav").attr("onclick","fav_topic(#{topic.id})").removeClass "disabled"
	if topic_now_num < topic_all_num then $(".action-next").show() else $(".action-next").hide()
	if topic_now_num > 1 then $(".action-pre").show() else $(".action-pre").hide()
	show_check_state topic.id , topic.my_answer if topic.my_answer?
	# load新内容
	load_fun() if topic_now_num > topics_stack.length - 6


@check = (topicid , option) ->
	# topics_finished_stack.push topics_info[topicid]
	topics_info[topicid].my_answer = option
	topic_info = topics_info[topicid]
	if option == topic_info.answer then count_success = count_success + 1 else count_error = count_error + 1
	show_check_state topicid , option
	root.next_topic(page_now) if option == topic_info.answer

show_check_state = (topicid , option) ->
	topics_info[topicid].my_answer = option
	topic_info = topics_info[topicid]
	if option == topic_info.answer
		$("label>span.input").iCheck('disable');
		$("label[optionnum=#{topic_info.answer}]").addClass "success"
	else
		$("label>span.input").iCheck('disable');
		$("label[optionnum=#{topic_info.answer}]").addClass "success"
		$("label[optionnum=#{option}]").addClass "error"
		# $("label").unbind()
		$(".topic-des").show()
		$(".topic-sum").show().html "<pre>统计：共答对#{count_success}题，答错#{count_error}题，正确率#{Math.ceil(count_success/(count_success+count_error) * 1000)/10}%</pre>"


@fav_topic = (topicid) ->
	topic_info = topics_info[topicid]
	$.get "call_api" , 
		method: "user/favorites/create"
		version: "1.0"
		content_id: topic_info.id
	.done (result) ->
		alert "收藏成功"



# ----------------------------------------------------------------------------------------------------

$(document).ready ->
	$(".topic-all").html topic_all_num
	if _type == 1
		sort_id = father_id
		load_fun = root.get_new_topics
	else if _type == 2
		sort_id = father_id
		load_fun = root.get_rand_topics
	else if _type == 4
		sort_id = father_id
		load_fun = root.get_fav_topics
	load_fun(1)


document.addEventListener('WeixinJSBridgeReady', ->
	WeixinJSBridge.on('menu:share:appmessage', (argv)->
		shareFriend();
	)
	WeixinJSBridge.call('hideToolbar');

, false)

imgUrl = 'http://is.hudongka.com/3010017_200.png'
lineLink = 'http://www.ecloudiot.com/yixue/train?type=1'
descContent = "全国医师定期考核在线培训系统"
shareTitle = '医师定期考核培训'
appid = ''

shareFriend = ->
	WeixinJSBridge.invoke('sendAppMessage',
		"appid": appid
		"img_url": imgUrl
		"img_width": "80"
		"img_height": "80"
		"link": lineLink
		"desc": descContent
		"title": shareTitle
	, (res) ->
		_report('send_msg', res.err_msg)
	)
