root = this
@now_api_info = {}
@now_project_id = 0
@now_project_info = {}
@now_app_id = 0

# 显示app信息
@showAppInfo = (app_id)->
    $.cookie('now_app_id', app_id)
    root.now_app_id = app_id
    $("#app_about_info .block-loading").show()
    clearApiInfo()
    $.get("get_proj_info",{id : app_id}, (res)->
        $("#app_about_info .block-loading").hide()
        titlehtml = "#{res.project_info.cnname} <a href='http://d.nowapp.cn/#{res.project_info.project_num}' target='_blank'>下载</a>"
        titlehtml += " <a href='/dashboard/fake_login?fake_user_id=#{res.project_info.admin_user[0].id}' target='_blank'>管理</a> " if res.project_info.admin_user.length > 0
        $("#app_about_info .block-title").html( titlehtml )
        $("#app_about_info input:eq(0)").val(res.api_key)
        $("#app_about_info input:eq(1)").val(res.api_secret)
        # $("#app_about_info input:eq(2)").val("#{res.project_info.project_num}.#{_host}/api")
        $("#app_about_info input:eq(2)").val("#{_apihost}/api")
        $("#app_about_info #sort_list").html( getProjectSortHtml res )
        if res.project_info.id != root.now_project_id
            root.now_project_info = res.project_info
            root.now_project_id = res.project_info.id
            $.get("init_api",{appnum : res.project_info.project_num}, (apis)->
                $("#app_about_info input:eq(3)").val apis.access_token
            )
            root.showApiList res.project_info
            root.showTriggerList res.project_info
            root.showResenderList res.project_info
    )

clearApiInfo = ->
    $("#api_info .block-title").html ''
    $("#api_info #api_info_content").html ''
    $("#api_info #api_verion_info").html ''


# 项目api信息 start ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@showApiList = (project_info) ->
    $("#api_proj_list .block-loading").show()
    $.get("get_proj_apis",{id : project_info.id}, (apis)->
        $("#api_proj_list .block-loading").hide()
        html = ""
        if apis.length > 0
            html = getProjectApi apis
        $("#proj_api_list").html( html )
        $("#api_proj_list .block-title").html "#{project_info.cnname}的api <a href='javascript:;' onclick='addApi(#{project_info.id},\"#{project_info.cnname}\")'>添加</a>"
    )
# 显示api信息
@showApiInfo = (api_id , version_id) ->
    $.cookie('now_api_id', api_id)
    $("#api_info .block-loading").show()
    $.get("get_api_info",{id : api_id}, (res)->
        $("#api_info .block-loading").hide()
        root.now_api_info = res
        titlehtml = res.uri_resource + " "
        titlehtml += "&nbsp;&nbsp;<font color=''>已弃用</font> " if res.is_deprecated? && res.is_deprecated
        titlehtml += "&nbsp;&nbsp;<font color=''>#{if res.is_authorization? then '需要认证' else '不需要认证'}</font> "
        for version in res.api_web_info_versions
            titlehtml += "&nbsp;&nbsp;<a href='javascript:;' onclick='showApiVersion(#{version.id})'>#{getVersionNum version.main_version,version.sub_version}</a>"
            last_version = version.id
            default_version = version.id if version.is_default_version 
        titlehtml += "&nbsp;&nbsp;<a href='javascript:;' onclick='editApi(#{root.now_api_info.id})'>编辑api</a> "
        titlehtml += "&nbsp;&nbsp;<a href='javascript:;' onclick='removeApi(#{root.now_api_info.id})' style='display:none'>删除api</a>"
        titlehtml += "&nbsp;&nbsp;<a href='javascript:;' onclick='addApiVersion( #{api_id} )'>添加版本</a>"
        $("#api_info .block-title").html titlehtml
        $("#api_info #api_info_content").html "<br /><pre>#{res.description}</pre>"
        $("#api_info #api_verion_info").html ''
        if res.api_web_info_versions.length > 0
            default_version = version_id if default_version?
            root.showApiVersion if default_version? then default_version else last_version
    )

# 添加api
@addApi = (project_id , project_name) ->
    html = "<table  class='table'>"
    html += "<tr><td>method:</td><td><input type='text' id='a_uri_resource'/></td></tr>"
    html += "<tr><td>说明:</td><td><textarea id='a_description'></textarea></td></tr>"
    html += "<tr><td>所属项目:</td><td><input id='a_project_info_id' type='hidden' value='#{if project_id? then project_id else ''}'/>#{if project_id? then project_name else ''}</td></tr>"
    html += "</table>"
    html += "<button class='btn btn-primary' onclick='doAddApi()'>添加api</button>"
    $("#api_info .block-title").html "添加api"
    $("#api_info #api_info_content").html html
    $("#api_info #api_verion_info").html ''

@doAddApi = () ->
    $.get("add_api",{"api[uri_resource]" : $("#a_uri_resource").val() ,"api[description]" : $("#a_description").val() ,"api[project_info_id]" : $("#a_project_info_id").val() }, (res)->
        root.now_project_id = 0
        root.showAppInfo $.cookie('now_app_id')
        root.showApiInfo res.id
        )

@editApi = (api_id) ->
    $("#api_info .block-loading").show()    
    $.post("get_api_info",{id : api_id}, (res)->
        $("#api_info .block-loading").hide()    
        html = "<table  class='table'>"
        html += "<tr><td>method:</td><td><input type='text' id='a_uri_resource' value='#{res.uri_resource}'/></td></tr>"
        html += "<tr><td>说明:</td><td><textarea id='a_description'>#{res.description}</textarea></td></tr>"
        html += "<tr><td>是否弃用:</td><td><input type='radio' name='a_is_deprecated' id='a_is_deprecated' value='1' #{if res.is_deprecated? && res.is_deprecated == true then 'checked' else ''}> 是 &nbsp;&nbsp;&nbsp; <input type='radio' name='a_is_deprecated' value='0' id='a_is_deprecated' #{if res.is_deprecated? && res.is_deprecated == true then '' else 'checked'}> 否</td></tr>"
        html += "<tr><td>是否需要认证:</td><td><input type='radio' name='a_is_authorization' id='a_is_authorization' value='1' #{if res.is_authorization?&& res.is_authorization == true then 'checked' else ''}> 是 &nbsp;&nbsp;&nbsp; <input type='radio' name='a_is_authorization' value='0' id='a_is_authorization' #{if res.is_authorization? && res.is_authorization == true then '' else 'checked'}> 否</td></tr>"
        html += "</table>"
        html += "<button class='btn btn-primary' onclick='doEditApi(#{api_id})'>修改api</button>"
        $("#api_info .block-title").html "编辑api"
        $("#api_info #api_info_content").html html
        $("#api_info #api_verion_info").html ''
        )

@doEditApi = (api_id) ->
    $.post("edit_api",{ "api[id]": api_id , "api[uri_resource]" : $("#a_uri_resource").val() ,"api[description]" : $("#a_description").val() ,"api[is_deprecated]" : $("#a_is_deprecated:checked").val(),"api[is_authorization]" : $("#a_is_authorization:checked").val() }, (res)->
        root.showApiInfo api_id
        )

@removeApi = (api_id) ->
    $.get("remove_api",{id :api_id}, (res)->
        root.now_project_id = 0
        root.showAppInfo $.cookie('now_app_id')
        )

# 项目api信息 end --------------------------------------------------------------------------------------------------------  


# api版本信息 start ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 显示某版本api
@showApiVersion = (version_id) ->
    for version in root.now_api_info.api_web_info_versions
        version_info = version if version.id == version_id
    try
        input_info = $.secureEvalJSON version_info.input_maps
    catch error
        input_info = {}
    html = "<form action='call_api' method='post' target='_blank' enctype='multipart/form-data' onsubmit='return buildform(this)'><table  class='table'>"
    html += "<tr><td>版本：</td><td>#{getVersionNum version_info.main_version,version_info.sub_version}</td><td></td></tr>"
    html += "<tr><td>method：</td><td>#{root.now_api_info.uri_resource}</td><td></td></tr>"
    for input in input_info
        input_h = 
        switch input.data_type
            when "text" then "<textarea name='#{input.field}'>#{input.default_value}</textarea>"
            when "file" then "<input name='#{input.field}' type='file' class='input-medium' value=''/>"
            else "<input name='#{input.field}' type='text' class='input-medium' value=''/>"
        html += "<tr><td>#{input.label} (#{input.field}) <br/>类型：#{input.data_type} - 空：#{input.allow_blank} <br/>#{if input.description? then input.description else ''}</td><td>#{input_h}</td><td></td></tr>"
    html += "</table>"
    html += "<input name='method' type='hidden' value='#{root.now_api_info.uri_resource}'/>"
    html += "<input name='version' type='hidden' value='#{getVersionNum version_info.main_version,version_info.sub_version}'/>"
    html += "<input name='format' type='hidden' />"
    html += "<input name='call_id' type='hidden' />"
    html += "<input name='api_key' type='hidden' />"
    html += "<input name='access_token' type='hidden' />"
    html += "<input name='version' type='hidden' />"
    html += "<input name='sig' type='hidden' />"
    html += "<button class='btn btn-primary'>提交</button>"
    html += "</form>"
    html += "  <button class='btn' onclick='editApiVersion(#{version_id})'>编辑版本</button>"
    html += "  <button class='btn' onclick='removeApiVersion(#{version_id})' style='float:right'>删除版本</button>"
    $("#api_info #api_verion_info").html html

@buildform = (obj) ->
    api_key = $("#app_about_info input:eq(0)").val()
    secret = $("#app_about_info input:eq(1)").val()
    url = $("#app_about_info input:eq(2)").val()
    access_token = $("#app_about_info input:eq(3)").val()
    call_id = Math.ceil(Math.random() * 1000000000)
    method = $("input[name='method']",obj).val()
    version = $("input[name='version']",obj).val()

    $("input[name='format']",obj).val( 'json' )
    $("input[name='api_key']",obj).val( api_key )
    $("input[name='access_token']",obj).val( access_token )
    $("input[name='call_id']",obj).val( call_id )
    md5var = "api_key=" + api_key + "call_id=" + call_id + "method=" + method + secret;

    $("input[name='sig']", obj).val(hex_md5(md5var));

    obj.action =  "http://"+ url + "/" + version+ "/" + method
    return true

@addApiVersion = (api_id) ->
    html = "<table  class='table'>"
    html += "<tr><td>api:</td><td><input id='a_api_web_info_id' type='hidden' value='#{root.now_api_info.id}'/>#{root.now_api_info.uri_resource}</td></tr>"
    html += "<tr><td>主版本:</td><td><input type='text' id='a_main_version'/></td></tr>"
    html += "<tr><td>子版本:</td><td><input type='text' id='a_sub_version'/></td></tr>"
    html += "<tr><td>输入定义:</td><td><textarea id='a_input_maps' ondblclick='jsonSelect_focus(this)'></textarea></td></tr>"
    html += "<tr><td>代码执行:</td><td><textarea id='a_handler_eval' ondblclick='rubySelect_focus(this)'></textarea></td></tr>"
    html += "<tr><td>输出定义:</td><td><textarea id='a_output_maps' ondblclick='jsonSelect_focus(this)'></textarea></td></tr>"
    html += "</table>"
    html += "<button class='btn btn-primary' onclick='doAddApiVersion()'>添加版本</button>"
    $("#api_info #api_verion_info").html html

@doAddApiVersion =  ->
    param = 
        "api_version[main_version]" : $("#a_main_version").val() 
        "api_version[sub_version]" : $("#a_sub_version").val() 
        "api_version[api_web_info_id]" : $("#a_api_web_info_id").val() 
        "api_version[input_maps]" : $("#a_input_maps").val() 
        "api_version[output_maps]" : $("#a_output_maps").val() 
        "api_version[is_handler_eval]" : 1
        "api_version[handler_eval]" : $("#a_handler_eval").val()
    $.post("add_api_version",param, (res)->
        root.showApiInfo root.now_api_info.id , res.id
        )
@editApiVersion = (version_id) ->
    for version in root.now_api_info.api_web_info_versions
        version_info = version if version.id == version_id
    html = "<table  class='table'>"
    html += "<tr><td>api:</td><td><input id='a_papi_web_info_id' type='hidden' value='#{root.now_api_info.id}'/>#{root.now_api_info.uri_resource}</td></tr>"
    html += "<tr><td>主版本:</td><td><input type='text' id='a_main_version' value='#{version_info.main_version}'/></td></tr>"
    html += "<tr><td>子版本:</td><td><input type='text' id='a_sub_version' value='#{version_info.sub_version}'/></td></tr>"
    html += "<tr><td>输入定义:</td><td><textarea id='a_input_maps' ondblclick='jsonSelect_focus(this)'>#{version_info.input_maps}</textarea></td></tr>"
    html += "<tr><td>代码执行:</td><td><textarea id='a_handler_eval' ondblclick='rubySelect_focus(this)'>#{version_info.handler_eval}</textarea></td></tr>"
    html += "<tr><td>输出定义:</td><td><textarea id='a_output_maps' ondblclick='jsonSelect_focus(this)'>#{version_info.output_maps}</textarea></td></tr>"
    html += "</table>"
    html += "<button class='btn btn-primary' onclick='doEditApiVersion(#{version_id})'>编辑版本</button>"
    $("#api_info #api_verion_info").html html

@doEditApiVersion = (version_id) ->
    param = 
        "api_version[id]" : version_id
        "api_version[main_version]" : $("#a_main_version").val() 
        "api_version[sub_version]" : $("#a_sub_version").val() 
        "api_version[api_web_info_id]" : $("#a_api_web_info_id").val() 
        "api_version[input_maps]" : $("#a_input_maps").val() 
        "api_version[output_maps]" : $("#a_output_maps").val() 
        "api_version[is_handler_eval]" : 1
        "api_version[handler_eval]" : $("#a_handler_eval").val()
    $.post("edit_api_version",param, (res)->
        root.showApiInfo root.now_api_info.id , version_id
        )
@removeApiVersion = (version_id) ->
    $.get("remove_api_version",{id :version_id}, (res)->
        root.showApiInfo root.now_api_info.id
        )

# api版本信息 end --------------------------------------------------------------------------------------------------------  


# 触发器信息 start ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@showTriggerList = (project_info) ->
    $("#proj_trigger_list .block-loading").show()
    $.get("get_proj_triggers",{id : project_info.id}, (res)->
        $("#proj_trigger_list .block-loading").hide()
        html = ""
        if res.length > 0
            for item in res
                html += "<li><a href='javascript:;' onclick='showTriggerInfo(#{item.id})'>#{item.name}</a></li>"
        $("#proj_trigger_lists").html( html )
        $("#proj_trigger_list .block-title").html "#{project_info.cnname}的触发器 <a href='javascript:;' onclick='addTrigger(#{project_info.id},\"#{project_info.cnname}\")'>添加</a>"
    )

@showTriggerInfo = (trigger_id) ->
    $.get("get_trigger",{id : trigger_id}, (res)->
        html = "<table  class='table'>"
        html += "<tr><td>名称:</td><td>#{res.name}</td></tr>"
        html += "<tr><td>说明:</td><td>#{res.description}</td></tr>"
        html += "<tr><td>api:</td><td>#{res.api_web_info.uri_resource}</td></tr>"
        html += "<tr><td>api版本:</td><td>#{res.api_version_reg}</td></tr>"
        html += "<tr><td>处理Api(url):</td><td>#{res.call_url}</td></tr>"
        html += "<tr><td>是否启用:</td><td>#{res.enabled}</td></tr>"
        html += "</table>"
        $("#api_info .block-title").html "触发器#{res.name} <a href='javascript:;' onclick='removeTrigger(#{res.id})'>删除</a> <a href='javascript:;' onclick='editTrigger(#{res.id})'>编辑</a>"
        $("#api_info #api_info_content").html html
        $("#api_info #api_verion_info").html ''
        )

@addTrigger = (project_id , project_name) ->
    html = "<table  class='table'><form id='form_trigger' onsubmit='doAddTrigger();return false;' enctype='multipart/form-data'>"
    html += "<tr><td>所属项目:</td><td><input name='trigger[project_info_id]' type='hidden' value='#{if project_id? then project_id else ''}'/>#{if project_id? then project_name else ''}</td></tr>"
    html += "<tr><td>名称:</td><td><input name='trigger[name]' type='text'/></td></tr>"
    html += "<tr><td>说明:</td><td><textarea name='trigger[description]'></textarea></td></tr>"
    html += "<tr><td>api:</td><td><input type='hidden' name='trigger[api_web_info_id]'/><input id='api_search' name='api_input' type='text'/></td></tr>"
    html += "<tr><td>api版本:</td><td><input name='trigger[api_version_reg]' type='text'/></td></tr>"
    html += "<tr><td>处理Api(url):</td><td><input name='trigger[call_url]' type='text'/></td></tr>"
    html += "<tr><td>条件(json):</td><td><textarea name='trigger[condition_exp]' ondblclick='jsonSelect_focus(this)'></textarea></td></tr>"
    html += "<tr><td>执行判断(ruby):</td><td><textarea name='trigger[call_before_eval]' ondblclick='rubySelect_focus(this)'></textarea></td></tr>"
    html += "<tr><td>附加参数(json):</td><td><textarea name='trigger[call_params]' ondblclick='jsonSelect_focus(this)'></textarea></td></tr>"
    html += "<tr><td>是否启用:</td><td><input name='trigger[enabled]' checked type='checkbox'/></td></tr>"
    html += "<tr><td colspan='2'><button class='btn btn-primary' >添加</button></td></tr>"
    html += "</form></table>"
    $("#api_info .block-title").html "添加触发器"
    $("#api_info #api_info_content").html html
    $('#api_search').typeahead(
        source : root.api_search_source
        updater : root.api_search_updater
        )
    $("#api_info #api_verion_info").html ''

@doAddTrigger = (trigger_id)->
    form = getFormValue $('#form_trigger')
    if form["trigger[api_web_info_id]"] == "" 
        alert "请填入Api"
        return false 
    $.post("add_trigger",form, (res)->
        root.showTriggerList root.now_project_info
        root.showTriggerInfo res.id
        )

@editTrigger = (trigger_id) ->
    $.get("get_trigger",{id : trigger_id}, (res)->
        html = "<table  class='table'><form id='form_trigger' onsubmit='doEditTrigger();return false;' enctype='multipart/form-data'>"
        html += "<tr><td>名称:</td><td><input name='trigger[name]' value='#{res.name}' type='text'/></td></tr>"
        html += "<tr><td>说明:</td><td><textarea name='trigger[description]'>#{res.description}</textarea></td></tr>"
        html += "<tr><td>api:</td><td><input type='hidden' value='#{res.api_web_info.id}' name='trigger[api_web_info_id]'/><input id='api_search' value='#{res.api_web_info.uri_resource}' name='api_input' type='text'/></td></tr>"
        html += "<tr><td>api版本:</td><td><input name='trigger[api_version_reg]' value='#{res.api_version_reg}' type='text'/></td></tr>"
        html += "<tr><td>处理Api(url):</td><td><input name='trigger[call_url]' value='#{res.call_url}' type='text'/></td></tr>"
        html += "<tr><td>条件(json):</td><td><textarea name='trigger[condition_exp]' ondblclick='jsonSelect_focus(this)'>#{res.condition_exp}</textarea></td></tr>"
        html += "<tr><td>执行判断(ruby):</td><td><textarea name='trigger[call_before_eval]' ondblclick='rubySelect_focus(this)'>#{res.call_before_eval}</textarea></td></tr>"
        html += "<tr><td>附加参数(json):</td><td><textarea name='trigger[call_params]' ondblclick='jsonSelect_focus(this)'>#{res.call_params}</textarea></td></tr>"
        html += "<tr><td>是否启用:</td><td><input type='hidden' name='trigger[enabled]' value='#{res.enabled}'><input #{if res.enabled then 'checked' else ''} type='checkbox' value='' onclick='$(this).prev().val( $(this).attr(\"checked\") == \"checked\" )'/></td></tr>"
        html += "<tr><td colspan='2'><input name='trigger[id]' value='#{trigger_id}' type='hidden'/><button class='btn btn-primary' >编辑</button></td></tr>"
        html += "</form></table>"
        $("#api_info .block-title").html "编辑触发器"
        $("#api_info #api_info_content").html html
        $('#api_search').typeahead(
            source : root.api_search_source
            updater : root.api_search_updater
            )
        $("#api_info #api_verion_info").html ''
        )

@doEditTrigger = () ->
    form = getFormValue $('#form_trigger')
    console.log form
    $.post("edit_trigger",form, (res)->
        root.showTriggerInfo res.id
        )

@removeTrigger = (trigger_id) ->
    $.get("remove_trigger",{id :trigger_id}, (res)->
        root.showTriggerList root.now_project_info
        $("#api_info .block-title").html ''
        $("#api_info #api_info_content").html ''
        $("#api_info #api_verion_info").html ''
        )
# 触发器信息 end --------------------------------------------------------------------------------------------------------  


# 转发器 start ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@showResenderList = (project_info) ->
    $("#proj_resender_list .block-loading").show()
    $.get("get_proj_resenders",{id : project_info.id}, (res)->
        $("#proj_resender_list .block-loading").hide()
        html = ""
        if res.length > 0
            for item in res
                html += "<li><a href='javascript:;' onclick='showResenderInfo(#{item.id})'>#{item.name}</a></li>"
        $("#proj_resender_lists").html( html )
        $("#proj_resender_list .block-title").html "#{project_info.cnname}的转发器 <a href='javascript:;' onclick='addResender(#{project_info.id},\"#{project_info.cnname}\")'>添加</a>"
    )

@showResenderInfo = (resender_id) ->
    $.get("get_resender",{id : resender_id}, (res)->
        html = "<table  class='table'>"
        html += "<tr><td>名称:</td><td>#{res.name}</td></tr>"
        html += "<tr><td>说明:</td><td>#{res.description}</td></tr>"
        html += "<tr><td>转发表单设置:</td><td><pre>#{res.send_config}</pre></td></tr>"
        html += "<tr><td>是否启用:</td><td>#{res.enabled}</td></tr>"
        html += "</table>"
        $("#api_info .block-title").html "转发器#{res.name} <a href='javascript:;' onclick='removeResender(#{res.id})'>删除</a> <a href='javascript:;' onclick='editResender(#{res.id})'>编辑</a>"
        $("#api_info #api_info_content").html html
        $("#api_info #api_verion_info").html ''
        )

@addResender = (project_id , project_name) ->
    html = "<table  class='table'><form id='form_resender' onsubmit='doAddResender();return false;' enctype='multipart/form-data'>"
    html += "<tr><td>所属项目:</td><td><input name='resender[project_info_id]' type='hidden' value='#{if project_id? then project_id else ''}'/>#{if project_id? then project_name else ''}</td></tr>"
    html += "<tr><td>名称:</td><td><input name='resender[name]' type='text'/></td></tr>"
    html += "<tr><td>说明:</td><td><input name='resender[description]' type='text'/></td></tr>"
    html += "<tr><td>配置(json):</td><td><textarea name='resender[configs]' ondblclick='jsonSelect_focus(this)'></textarea></td></tr>"
    html += "<tr><td>转发表单设置(json):</td><td><textarea name='resender[send_config]' ondblclick='jsonSelect_focus(this)'></textarea></td></tr>"
    html += "<tr><td>是否启用:</td><td><input type='hidden' name='resender[enabled]' value='true'><input checked type='checkbox' value='' onclick='$(this).prev().val( $(this).attr(\"checked\") == \"checked\" )'/></td></tr>"
    html += "<tr><td colspan='2'><button class='btn btn-primary' >添加</button></td></tr>"
    html += "</form></table>"
    $("#api_info .block-title").html "添加转发器"
    $("#api_info #api_info_content").html html
    $("#api_info #api_verion_info").html ''

@doAddResender = (resender_id)->
    form = getFormValue $('#form_resender')
    console.log form
    $.post("add_resender",form, (res)->
        root.showResenderList root.now_project_info
        root.showResenderInfo res.id
        )

@editResender = (resender_id) ->
    $.get("get_resender",{id : resender_id}, (res)->
        html = "<table  class='table'><form id='form_resender' onsubmit='doEditResender();return false;'>"
        html += "<tr><td>名称:</td><td><input name='resender[name]' type='text' value='#{res.name}'/></td></tr>"
        html += "<tr><td>说明:</td><td><input name='resender[description]' type='text' value='#{res.description}'/></td></tr>"
        html += "<tr><td>配置:</td><td><textarea name='resender[configs]' ondblclick='jsonSelect_focus(this)'>#{res.configs}</textarea></td></tr>"
        html += "<tr><td>转发表单设置:</td><td><textarea name='resender[send_config]' ondblclick='jsonSelect_focus(this)'>#{res.send_config}</textarea></td></tr>"
        html += "<tr><td>是否启用:</td><td><input type='hidden' name='resender[enabled]' value='#{res.enabled}'><input #{if res.enabled then 'checked' else ''} type='checkbox' value='' onclick='$(this).prev().val( $(this).attr(\"checked\") == \"checked\" )'/></td></tr>"
        html += "<tr><td colspan='2'><input name='resender[id]' value='#{resender_id}' type='hidden'/><button class='btn btn-primary' >编辑</button></td></tr>"
        html += "</form></table>"
        $("#api_info .block-title").html "编辑转发器#{res.name}"
        $("#api_info #api_info_content").html html
        $("#api_info #api_verion_info").html ''
        )

@doEditResender = () ->
    form = getFormValue $('#form_resender')
    console.log form
    $.post("edit_resender",form, (res)->
        root.showResenderInfo res.id
        )

@removeResender = (resender_id) ->
    $.get("remove_resender",{id :resender_id}, (res)->
        root.showResenderList root.now_project_info
        $("#api_info .block-title").html ''
        $("#api_info #api_info_content").html ''
        $("#api_info #api_verion_info").html ''
        )

# 转发器 end --------------------------------------------------------------------------------------------------------  

@callApi = (params , success)->
    $.post("call_api",{method : "projectinfo/index" ,version : "1.0"}, success )


getFormValue = (obj) ->
    form = {}
    $.each( $(obj).serializeArray() , (index ,value) ->
        # form[value.name] = value.value if "string" == typeof value.name && value.value != ""
        form[value.name] = value.value
        )
    return form

getVersionNum = (main , sub) ->
    mainversion = main+""
    mainversion += ".0" if mainversion.split(".").length == 1
    subversion = if sub!="" then "."+sub else ""
    return "#{mainversion}#{subversion}"

getProjectApi = (res) ->
    html = ""
    for item in res
        if item.is_deprecated == true
            html += "<li><a href='javascript:;' onclick='showApiInfo(#{item.id})'>#{item.uri_resource}</a></li>"
        else
            html += "<li><a href='javascript:;' onclick='showApiInfo(#{item.id})'>#{item.uri_resource}</a></li>"
    return html
# 分类列表html
getProjectSortHtml = (res)->
    html = ""
    for item0 in res.project_info.cms_sort
            if item0.father_id == 0
                html += "<li>#{item0.cnname} - #{item0.id}<ul>"
                for item1 in res.project_info.cms_sort
                    if item1.father_id == item0.id
                        html += "<li>#{item1.cnname} - #{item1.id}<ul>"
                        for item2 in res.project_info.cms_sort
                            html += "<li>#{item2.cnname} - #{item2.id}</li>" if item2.father_id == item1.id
                        html += "</li></ul>"
                html += "</ul></li>"
    return html

@saveJs = ( nohide ) ->
    el = $('#js_editor').data('el')
    el.val(root.jseditor.getValue())
    $("#ace_js_editor").modal('hide');

@saveRuby = ( nohide ) ->
    el = $('#ruby_editor').data('el')
    el.val(root.rubyeditor.getValue())
    $("#ace_ruby_editor").modal('hide');
    
@saveJson = ( nohide ) ->
    el = $('#json_editor').data('el')
    el.val(root.jsoneditor.getValue())
    $("#ace_json_editor").modal('hide');
    
@jsSelect_focus =  (obj)->
    el = $(obj);
    $("#ace_js_editor").modal('show');
    $('#js_editor').data('el' , el)
    if (el.val()=="")
      el.val " "
    root.jseditor.setValue(el.val())
    root.jseditor.clearSelection();
    root.jseditor.focus()

@rubySelect_focus =  (obj)->
    el = $(obj);
    $("#ace_ruby_editor").modal('show');
    $('#ruby_editor').data('el' , el)
    if (el.val()=="")
      el.val " "
    root.rubyeditor.setValue(el.val())
    root.rubyeditor.clearSelection();
    root.rubyeditor.focus()

@jsonSelect_focus =  (obj)->
    el = $(obj);
    $("#ace_json_editor").modal('show');
    $('#json_editor').data('el' , el)
    if (el.val()=="")
      el.val "{}"
    root.jsoneditor.setValue(el.val());
    root.jsoneditor.clearSelection();
    root.jsoneditor.focus()
# 自动完成、编辑器等用到的工具方法
@api_search_source = (query, process) ->
    return $.getJSON('search_api_list',{ words: $('#api_search').val() ,project_info_id:root.now_project_id },(data) ->
        newData = [];
        root.selector = {}
        $.each(data, ->
            item = this.uri_resource
            newData.push item
            root.selector[item] = this
            )
        return process(newData)
        );
@api_search_updater = (item)->
    obj = root.selector[item]
    $('#api_search').prev().val obj.id
    return item
$( ->
    root.showAppInfo $.cookie('now_app_id') if $.cookie('now_app_id')?
    root.showApiInfo $.cookie('now_api_id') if $.cookie('now_api_id')?
    # 初始化编辑器
    root.jseditor = ace.edit("js_editor");
    root.jseditor.setTheme("ace/theme/twilight");
    root.jseditor.getSession().setMode("ace/mode/javascript");
    root.rubyeditor = ace.edit("ruby_editor");
    root.rubyeditor.setTheme("ace/theme/twilight");
    root.rubyeditor.getSession().setMode("ace/mode/ruby");
    root.jsoneditor = ace.edit("json_editor");
    root.jsoneditor.setTheme("ace/theme/twilight");
    root.jsoneditor.getSession().setMode("ace/mode/json");
    # root.callApi()
    # 搜索项目的自动完成功能
    root.selector = {}
    $('#proj_search').typeahead({
        source: (query, process) ->
            return $.getJSON('get_proj_list',{ words: $('#proj_search').val() },(data) ->
                newData = [];
                root.selector = {}
                $.each(data, ->
                    item = this.project_num + " - " + this.cnname + " - " + this.id + " - " + this.description
                    newData.push this.project_num + " - " + this.cnname + " - " + this.id + " - " + this.description
                    root.selector[item] = this
                    )
                return process(newData)
                );
        updater : (item)->
            $("#proj_search_res").html('')
            obj = root.selector[item]
            $.getJSON('get_proj_app',{ id: obj.id },(data) ->
                $.each(data, ->
                    $("#proj_search_res").html $("#proj_search_res").html() + " <a href='javascript:;' onclick='showAppInfo(#{this.id})'>#{this.cnname}(#{this.phonetype})</a> "
                    )
                )
            return obj.cnname
    })
);


