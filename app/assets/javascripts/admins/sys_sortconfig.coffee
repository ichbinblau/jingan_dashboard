root = @

log = null
className = "dark"
curDragNodes = []
autoExpandNode = []
newCount = 1

call_fun = {}
call_fun.dropPrev = (treeId, nodes, targetNode) ->
	pNode = targetNode.getParentNode()
	if pNode && pNode.dropInner == false 
		return false
	else
		# for i = 0,l = curDragNodes.length; i<l i++
		for dish, i in curDragNodes
			curPNode = curDragNodes[i].getParentNode();
			if curPNode && curPNode != targetNode.getParentNode() && curPNode.childOuter == false
				return false;
	return true

call_fun.dropInner = (treeId, nodes, targetNode) ->
	if targetNode && targetNode.dropInner == false
		return false;
	else
		# for (var i=0,l=curDragNodes.length; i<l; i++) {
		for dish, i in curDragNodes
			if !targetNode && curDragNodes[i].dropRoot == false
				return false
			else if curDragNodes[i].parentTId && curDragNodes[i].getParentNode() != targetNode && curDragNodes[i].getParentNode().childOuter == false
				return false
	return true

call_fun.dropNext = (treeId, nodes, targetNode) ->
	pNode = targetNode.getParentNode();
	if pNode && pNode.dropInner == false
		return false;
	else
		# for (var i=0,l=curDragNodes.length; i<l; i++) {
		for dish, i in curDragNodes
			curPNode = curDragNodes[i].getParentNode()
			if curPNode && curPNode != targetNode.getParentNode() && curPNode.childOuter == false
				return false
	return true

call_fun.beforeDrag = (treeId, treeNodes) ->
	className = if className == "dark" then "" else "dark"
	call_fun.showLog("[ "+call_fun.getTime()+" beforeDrag ]    drag: " + treeNodes.length + " nodes." );
	# for (var i=0,l=treeNodes.length; i<l; i++) {
	for item , i in treeNodes
		if treeNodes[i].drag == false 
			curDragNodes = null
			return false
		else if treeNodes[i].parentTId && treeNodes[i].getParentNode().childDrag == false
			curDragNodes = null
			return false
	curDragNodes = treeNodes
	return true

call_fun.beforeDragOpen = (treeId, treeNode) ->
	autoExpandNode = treeNode
	return true

call_fun.beforeDrop = (treeId, treeNodes, targetNode, moveType, isCopy) ->
	className = if className == "dark" then "" else "dark"
	call_fun.showLog("[ "+call_fun.getTime()+" beforeDrop ]    moveType:" + moveType)
	call_fun.showLog("target: " + (if targetNode? then targetNode.name else "root") + "  -- is "+ (if isCopy==null then "cancel" else if isCopy? then "copy" else "move"))
	return true

call_fun.onDrag = (event, treeId, treeNodes)  ->
	className = if className == "dark" then "" else "dark"
	call_fun.showLog("[ "+call_fun.getTime()+" onDrag ]    drag: " + treeNodes.length + " nodes." )

call_fun.onExpand = (event, treeId, treeNode) ->
	if treeNode == autoExpandNode
		className = if className == "dark" then "" else "dark"
		call_fun.showLog("[ "+call_fun.getTime()+" onExpand ]   " + treeNode.name)

call_fun.beforeEditName = (treeId, treeNode) ->
	className = if className == "dark" then "" else "dark" 
	call_fun.showLog("[ "+call_fun.getTime()+" beforeEditName ]    " + treeNode.name)
	zTree = $.fn.zTree.getZTreeObj("treeDemo")
	zTree.selectNode(treeNode)
	# return confirm("进入节点 -- " + treeNode.name + " 的编辑状态吗？")

call_fun.beforeRemove = (treeId, treeNode) ->
	className = if className == "dark" then "" else "dark"
	call_fun.showLog("[ "+call_fun.getTime()+" beforeRemove ]    " + treeNode.name)
	zTree = $.fn.zTree.getZTreeObj("treeDemo")
	zTree.selectNode(treeNode)
	return confirm("确认删除 节点 -- " + treeNode.name + " 吗？")

call_fun.beforeRename = (treeId, treeNode, newName, isCancel) ->
	className = if className == "dark" then "" else "dark"
	call_fun.showLog(( if isCancel then "<span style='color:red'>" else "" ) + "[ "+call_fun.getTime()+" beforeRename ]    " + treeNode.name + (if isCancel then "</span>" else ""))
	if newName.length == 0
		alert("节点名称不能为空.");
		zTree = $.fn.zTree.getZTreeObj("treeDemo")
		setTimeout(() -> 
			zTree.editName(treeNode) 
		, 10 )
		return false
	return true


call_fun.onDrop = (event, treeId, treeNodes, targetNode, moveType, isCopy) ->
	className = if className == "dark" then  "" else "dark"
	call_fun.showLog("[ "+call_fun.getTime()+" onDrop ]    moveType:" + moveType)
	call_fun.showLog("target: " + (if targetNode then targetNode.name else "root") + "  -- is "+ (if isCopy == null then "cancel" else if isCopy then "copy" else "move"))
	sort_id = if moveType == "inner" then targetNode.id else 0
	$.get "modify_sort?sort_id=#{treeNodes[0].id}&father_id=#{sort_id}" ,(data)-> 

call_fun.onRename = (e, treeId, treeNode, isCancel) ->
	$.get "modify_sort?sort_id=#{treeNode.id}&name=#{treeNode.name}" ,(data)-> 
	call_fun.showLog(( if isCancel then "<span style='color:red'>" else "" ) + "[ "+call_fun.getTime()+" onRename ]    " + treeNode.name + (if isCancel then "</span>" else ""))

call_fun.onRemove = (e, treeId, treeNode) ->
	$.get "remove_sort?sort_id=#{treeNode.id}" ,(data)->
	call_fun.showLog("[ "+call_fun.getTime()+" onRemove ]    " + treeNode.name)

call_fun.addHoverDom = (treeId, treeNode) ->
	sObj = $("#" + treeNode.tId + "_span")
	return if treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length > 0
	addStr = "<span class='button add' id='addBtn_" + treeNode.tId + "' title='add node' onfocus='this.blur();'></span>"
	sObj.after(addStr)
	btn = $("#addBtn_"+treeNode.tId);
	if (btn)
		btn.bind("click", () ->
			zTree = $.fn.zTree.getZTreeObj("treeDemo");
			$.get "add_sort?father_id=#{treeNode.id}&name=newnode" ,(data)->
				zTree.addNodes(treeNode, {id:data.id, pId:treeNode.id, name:"newnode" })
			return false
		)

call_fun.removeHoverDom = (treeId, treeNode) ->
	$("#addBtn_"+treeNode.tId).unbind().remove()

call_fun.showLog = (str) ->
	console.log str
	# log = $("#log") if !log?
	# log.append("<li class='"+className+"'>"+str+"</li>")
	# if log.children("li").length > 8
	# 	log.get(0).removeChild(log.children("li")[0])

call_fun.getTime = () ->
	now = new Date()
	h = now.getHours()
	m = now.getMinutes()
	s = now.getSeconds()
	ms = now.getMilliseconds()
	return (h+":"+m+":"+s+ " " +ms)

call_fun.setTrigger = () ->
	zTree = $.fn.zTree.getZTreeObj("treeDemo")
	zTree.setting.edit.drag.autoExpandTrigger = $("#callbackTrigger").attr("checked")

setting = {
	view: {
		addHoverDom: call_fun.addHoverDom,
		removeHoverDom: call_fun.removeHoverDom,
		selectedMulti: false
	},
	edit: {
		drag: {
			autoExpandTrigger: true,
			prev: call_fun.dropPrev,
			inner: call_fun.dropInner,
			next: call_fun.dropNext
		},
		enable: true,
		editNameSelectAll: true,
		showRemoveBtn: true,
		showRenameBtn: true
		# showRemoveBtn: call_fun.showRemoveBtn,
		# showRenameBtn: call_fun.showRenameBtn
	},
	data: {
		simpleData: {
			enable: true
		}
	},
	callback: {
		beforeDrag: call_fun.beforeDrag,
		beforeDrop: call_fun.beforeDrop,
		beforeDragOpen: call_fun.beforeDragOpen,
		onDrag: call_fun.onDrag,
		onDrop: call_fun.onDrop,
		onExpand: call_fun.onExpand

		beforeEditName: call_fun.beforeEditName,
		beforeRemove: call_fun.beforeRemove,
		beforeRename: call_fun.beforeRename,
		onRemove: call_fun.onRemove,
		onRename: call_fun.onRename
	}
};
$(document).ready  ->
	$.get "ssort" ,(data)->
		if data.length < 80
			item.open = true for item in data
		$.fn.zTree.init($("#treeDemo"), setting, data)
		$("#callbackTrigger").bind("change", {}, call_fun.setTrigger)








