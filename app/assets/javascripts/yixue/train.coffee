root = @
@_cfgs = 
	perpage : 10
	sort_id : 0
	subjcts_allnum : 0
	now_subject_num : 0
	now_sort_id : 0
	now_subject : 0
	subjects_info : {}
	subjects_answers : {}

@start_train = (sort_id , count) ->
	root._cfgs.subjcts_allnum = count
	root._cfgs.sort_id = sort_id
	get_new_subjects(sort_id , 1)

get_new_subjects = (sort_id , page)->
	init_page()
	$.getJSON "subjects.json?sort_id=#{sort_id}&page=#{page}&perpage=#{root._cfgs.perpage}" , (res) ->
		num = ( page - 1 ) * root._cfgs.perpage
		for i in res
			root._cfgs.subjects_info["subject_"+( ++num )] = i
		@go_topic parseInt $(".train-num-now").val() if parseInt( $(".train-num-now").val() ) != root._cfgs.now_subject_num
		# root.next_topic() if root._cfgs.now_subject_num == 0
		# console.log JSON.stringify root._cfgs.subjects_info

@next_topic = () ->
	return if root._cfgs.now_subject_num >= root._cfgs.subjcts_allnum 
	root._cfgs.now_subject_num++
	root.go_topic root._cfgs.now_subject_num
	# show_topic( root._cfgs.now_subject_num )

@pre_topic = () ->
	return if root._cfgs.now_subject_num == 1
	root._cfgs.now_subject_num--
	root.go_topic root._cfgs.now_subject_num
	# show_topic( root._cfgs.now_subject_num )

@go_topic = (num) ->
	return if num > root._cfgs.subjcts_allnum || num < 1
	root._cfgs.now_subject_num = num
	if !root._cfgs.subjects_info["subject_"+num]?
		$(".train-num-now").val num
		root._cfgs.now_subject_num = 0
		return get_new_subjects root._cfgs.sort_id , Math.ceil( num / 10 )
	show_topic(num)

show_topic = (num) ->
	$(".train-des").hide()
	subject_info = root._cfgs.subjects_info["subject_"+num]
	if num < root._cfgs.subjcts_allnum
		$(".train-pageright").show()
	else
		$(".train-pageright").hide()
	if num > 1
		$(".train-pageleft").show()
	else
		$(".train-pageleft").hide()
	# 显示题目
	$(".train-num-now").val num 
	$(".train-title").html subject_info.subject
	# alert JSON.stringify subject_info
	options_html = ""
	i = 0
	for key,item of subject_info.options
		options_html = options_html + "<li data-key=\"#{i}\" onclick=\"select_option($(this))\"><span class=\"icon\"> </span> #{key}. <span>#{item}</span></li>"
		i++
	$(".train-options").html options_html
	# 显示答案
	answer = root._cfgs.subjects_answers["subject_"+num]
	if answer?
		unless answer.right
			$(".options li .icon").eq(answer.error_answers).addClass("icon-close").addClass("error")
			$(".train-des").show().html subject_info.des
		for item in answer.success_answers
			$(".options li .icon").eq(item).addClass("icon-check").addClass("success")
		$(".options li").attr "onclick",""

@select_option = (obj) ->
	numarr = [ "A" , "B" , "C" , "D" , "E" , "F" ,"G" , "H" , "I" , "J" ]
	now_subject = root._cfgs.subjects_info["subject_"+root._cfgs.now_subject_num]
	answer = now_subject.answer
	return if !answer? || answer==""
	now_answer = parseInt obj.attr("data-key")
	answers = []
	for item in answer
		answers.push numarr.indexOf item
	if answers.indexOf(now_answer) == -1
		$(".options li .icon").eq(now_answer).addClass("icon-close").addClass("error")
		for item in answers
			$(".options li .icon").eq(item).removeClass("icon-close").removeClass("error").addClass("icon-check").addClass("success")
		$(".train-des").show().html(now_subject.des)
		return save_answer()
	else
		$(".options li .icon").eq(now_answer).addClass("icon-check")
		items = []
		items.push $(item).parent().attr("data-key") for item in $(".options li .icon-check")
		if items.join(",") == answers.join(",")
			$(".options li .icon-check").addClass "success"
			save_answer()

save_answer = () ->
	success_answers = []
	error_answers = []
	success_answers.push $(item).parent().attr("data-key") for item in $(".options li .icon-check")
	error_answers.push $(item).parent().attr("data-key") for item in $(".options li .icon-close")
	root._cfgs.subjects_answers["subject_"+root._cfgs.now_subject_num] = 
		right : ($(".options li .icon-close").length == 0)
		success_answers : success_answers.join ""
		error_answers : error_answers.join ""
	$(".options li").attr "onclick",""
	s_count_all = 0
	s_count_error = 0
	for k,v of root._cfgs.subjects_answers
		s_count_all++
		s_count_error++ unless v.right
	$(".train-num-error").html s_count_error+" / "+s_count_all

init_page = () ->
	$(".train-pageleft , .train-pageright , .train-des").hide()
	$(".train-title").html("正在读取...")
	$(".train-options").html("")
	$(".train-num-all").html(root._cfgs.subjcts_allnum)


# ======
@select_train = () ->
	sort_id = $("form input:checked").val()
	code = $("#code").val()
	return alert "请选择试题类型" unless sort_id?
	return alert "请输入试题验证码" unless code?
	$.getJSON "check_code?sort_id=#{sort_id}&code=#{code}" , (res) ->
		if res.success
			location.reload()
		else
			alert res.msg

$(document).ready ->
	init_page()


document.addEventListener('WeixinJSBridgeReady', ->
	WeixinJSBridge.on('menu:share:appmessage', (argv)->
		shareFriend();
	)
	WeixinJSBridge.call('hideToolbar');
, false)

shareFriend = ->
	imgUrl = 'http://is.hudongka.com/3010017_200.png'
	lineLink = 'http://www.ecloudiot.com/866386381/yixue/subject'
	descContent = "全国医师定期考核在线培训系统"
	shareTitle = '医师定期考核培训'
	appid = ''
	WeixinJSBridge.invoke('sendAppMessage',
		"appid": appid
		"img_url": imgUrl
		"img_width": "80"
		"img_height": "80"
		"link": lineLink
		"desc": descContent
		"title": shareTitle
	, (res) ->
		# _report('send_msg', res.err_msg)
	)
