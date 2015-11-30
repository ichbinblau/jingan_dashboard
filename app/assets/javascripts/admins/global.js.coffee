root = this
@editSortForm = (sort_id)->
	$('#edit_sort').data('sort_id' , sort_id).modal('show')

@addSort = (obj)->
	parent = obj.parent().parent()
	name = $('input[name="name"]' , parent).val()
	father_id = $('input[name="father_id"]' , parent).val() ? 0
	sort_order = $('input[name="sort_order"]' , parent).val() ? 0
	$.get("/dashboard/sort_add?name=#{name}&father_id=#{father_id}&sort_order=#{sort_order}" , (data)->
		root.renewList()
	)

@editSort = (obj)->
	parent = obj.parent().parent()
	id = $('input[name="id"]' , parent).val()
	name = $('input[name="name"]' , parent).val()
	father_id = $('input[name="father_id"]' , parent).val() ? 0
	sort_order = $('input[name="sort_order"]' , parent).val() ? 0
	$.get("/dashboard/sort_edit?sort_id=#{id}&name=#{name}&father_id=#{father_id}&sort_order=#{sort_order}" , (data)->
		root.renewList()
	)

@removeSort = (obj)->
	parent = obj.parent().parent()
	id = $('input[name="id"]' , parent).val()
	del = confirm("分类删除不可恢复，请确保该分类下没有内容！");
	if del
		$.get("/dashboard/sort_remove?sort_id=#{id}" , (data)->
			root.renewList()
		)


@renewList =  ->
	sort_id = $('#edit_sort').data('sort_id')
	$.get("/dashboard/sort_list?sort_id=#{sort_id}" , (data)->
		sort_tree = []
		kv_data = {}
		deep = 0
		for item in data
			item.children = []
			kv_data[item.id] = item
		for item in data
			if kv_data[item.father_id]
				for v in data
					if v.father_id == item.id
						kv_data[item.id].children.push(kv_data[v.id])
						delete(kv_data[v.id])
						deep = 2 if deep < 2
				kv_data[item.father_id].children.push(kv_data[item.id])
				delete(kv_data[item.id])
				deep = 1 if deep < 1

		html = "<p>仅支持2级分类</p>"
		if 2 == deep
			for k,item of kv_data
				html += "<table class='table table-bordered table-condensed'>"
				html += "<tr class='warning'><td>id: #{item.id}<input type='hidden' value='#{item.id}' name='id' /></td><td><input type='text' class='input-small' value='#{item.cnname}' name='name' /></td>"
				html += "<td><a href='javascript:void(0)' class='btn' onclick='editSort($(this))'>保存</a></td></tr>"
				html += "<tr><td></td><td><input type='text' class='input-small' value=''  name='name'/></td>"
				html += "<td><input type='hidden' class='input-mini' value='#{item.id}' name='father_id' /><a href='javascript:void(0)' class='btn' onclick='addSort($(this))'>添加</a></td></tr>"
				html += "</table>"

				for k1,item1 of item.children
					html += "<table class='table table-bordered table-condensed'>"
					html += "<tr class='warning'><td>id</td><td>名称</td><td>父分类id</td><td>排序</td><td></td></tr>"

					html += "<tr class='warning'><td>#{item1.id}<input type='hidden' value='#{item1.id}' name='id' /></td><td><input type='text' class='input-small' value='#{item1.cnname}' name='name' /></td><td><input type='text' class='input-mini' value='#{item1.father_id}'  name='father_id'/></td>"
					html += "<td></td><td><a href='javascript:void(0)' class='btn' onclick='editSort($(this))'>保存</a><button type='button' class='close' onclick='removeSort($(this))'>×</button></td></tr>"
					for k2,item2 of item1.children
						html += "<tr><td>#{item2.id}<input type='hidden' value='#{item2.id}' name='id' /></td><td><input type='text' class='input-small' value='#{item2.cnname}'  name='name'/></td><td><input type='text' class='input-mini' value='#{item2.father_id}'  name='father_id'/></td>"
						html += "<td><input type='text' class='input-mini' value='#{item2.sort_order}' name='sort_order'/></td><td><a href='javascript:void(0)' class='btn' onclick='editSort($(this))'>保存</a><button type='button' class='close' onclick='removeSort($(this))'>×</button></td></tr>"
					html += "<tr><td></td><td><input type='text' class='input-small' value=''  name='name'/></td><td><input type='hidden' class='input-mini' value='#{item1.id}' name='father_id' />#{item1.id}</td>"
					html += "<td></td><td><a href='javascript:void(0)' class='btn' onclick='addSort($(this))'>添加</a></td></tr>"
					html += "</table>"
		if 1 == deep || 0 == deep
			for k,item of kv_data
				html += "<table class='table table-bordered table-condensed'>"
				html += "<tr class='warning'><td>id</td><td>名称</td><td>父分类id</td><td>排序</td><td></td></tr>"
				html += "<tr class='warning'><td>#{item.id}<input type='hidden' value='#{item.id}' name='id' /></td><td><input type='text' class='input-small' value='#{item.cnname}'  name='name'/></td><td></td>"
				html += "<td></td><td><a href='javascript:void(0)' class='btn'>保存</a><button type='button' class='close'>×</button></td></tr>"

				for k1,item1 of item.children
					html += "<tr ><td>#{item1.id}<input type='hidden' value='#{item1.id}' name='id' /></td><td><input type='text' class='input-small' value='#{item1.cnname}' name='name'/></td><td><input type='text' class='input-mini' value='#{item1.father_id}' name='father_id'/></td>"
					html += "<td><input type='text' class='input-mini' value='#{item1.sort_order}'  name='sort_order'/></td><td><a href='javascript:void(0)' class='btn' onclick='editSort($(this))'>保存</a><button type='button' class='close' onclick='removeSort($(this))'>×</button></td></tr>"
				html += "<tr><td></td><td><input type='text' class='input-small' value=''  name='name'/></td><td><input type='hidden' class='input-mini' value='#{item.id}'  name='father_id'/>#{item.id}</td>"
				html += "<td></td><td><a href='javascript:void(0)' class='btn' onclick='addSort($(this))'>添加</a></td></tr>"
				html += "</table>"

		$('#sort_div').html(html)
	)
$ ->
	$('#edit_sort').on('shown',root.renewList)
