root = this
class root.AceEditor
  constructor: (type , @editor_id , filename) ->
    @editor = ace.edit(@editor_id)
    @editor.setTheme("ace/theme/twilight")
    @js_mode = require("ace/mode/#{type}").Mode
    @editor.getSession().setMode(new @js_mode())
    @editor.getSession().setTabSize(2)
    @editor.getSession().setUseSoftTabs(true)
    @editor.getSession().setUseWrapMode('free')
    @editor.setShowInvisibles(true);
    this.notifyChange = false
    @editor.on("change", (e) ->
    	if !ace_editor.editor.notifyChange
    		top.ec_editor.fileChange filename
    		ace_editor.editor.notifyChange = true
    )
    cmd = 
    	name: 'save'
	    bindKey: {win: 'Ctrl-S',  mac: 'Command-S'}
	    exec: (editor) ->
	    	top.ec_editor.fileSave(filename,ace_editor.editor.getValue())
	    	ace_editor.editor.notifyChange = false
    @editor.commands.addCommand cmd
    $(document).keydown(@windowKeyDown)
    cmd = 
    	name: 'tab1'
	    bindKey: {win: 'Ctrl-1',  mac: 'Command-1'}
	    exec: (editor) ->
	        top.ec_editor.goTab(1)
    @editor.commands.addCommand cmd
    cmd = 
    	name: 'tab2'
	    bindKey: {win: 'Ctrl-2',  mac: 'Command-2'}
	    exec: (editor) ->
	        top.ec_editor.goTab(2)
    @editor.commands.addCommand cmd
    cmd = 
    	name: 'tab3'
	    bindKey: {win: 'Ctrl-3',  mac: 'Command-3'}
	    exec: (editor) ->
	        top.ec_editor.goTab(3)
    @editor.commands.addCommand cmd
    cmd = 
    	name: 'tab4'
	    bindKey: {win: 'Ctrl-4',  mac: 'Command-4'}
	    exec: (editor) ->
	        top.ec_editor.goTab(4)
    @editor.commands.addCommand cmd
    cmd = 
    	name: 'tab5'
	    bindKey: {win: 'Ctrl-5',  mac: 'Command-5'}
	    exec: (editor) ->
	        top.ec_editor.goTab(5)
    @editor.commands.addCommand cmd
    cmd = 
    	name: 'tab6'
	    bindKey: {win: 'Ctrl-6',  mac: 'Command-6'}
	    exec: (editor) ->
	        top.ec_editor.goTab(6)
    @editor.commands.addCommand cmd
  # 屏蔽 ctrl + s
  windowKeyDown: (event) ->
    if(event.metaKey && event.keyCode == 83) || (event.ctrlKey && event.keyCode == 83)
        return false
