root = this
class root.EcEditor
  constructor: (@editor_obj , dir) ->
    @dir = dir
    $.cookie('project' , dir)
    $(window).resize(@windowResize).keydown(@windowKeyDown)
    tree_option = root: @dir
    this.refreshTree(tree_option)
    $('#folder').contextmenu( 
      target: '#context_menu'
      before: (e,element) ->
        if $(e.target).attr('rel').length > 0
          $('#context_menu').data( 'rel' , $(e.target).attr('rel') )
          $('#context_menu').data( 'is_dir' , $(e.target).parent().hasClass('dir') )
          $('#context_menu li').hide()
          if $(e.target).parent().hasClass('dir')
            $('#context_menu .cm_dir').show()
          else
            $('#context_menu .cm_file').show()
          return true;
      onItem: (e,element)  ->
        root.ec_editor['file'+$(element).attr('action')] $(this).data('rel')
    )
    # 切换项目
    $('#project select').change((e) ->
      window.location.href = "index?dir=" + $(e.target).val()
    )
    # 弹出框确认事件处理
    submitModal = ->
      root.ec_editor.modalAction($('#filename .modal-footer .btn-primary').attr('action' )
        ,$('#filename input[type="text"]').val()
        ,$('#filename input[type="hidden"]').val()
      )
    $('#filename .modal-body form').submit(submitModal)
    $('#filename .modal-footer .btn-primary').click(submitModal)

  fileChange: (name) ->
    nav = $("#navTab li>a[ref=\"#{name}\"]").parent()
    if nav.length > 0
      this.changedTab(nav)
    else
      this.addTab name

  fileSave: (name , str) ->
    this.modalAction('save' , name , str)

  fileRemove: (name) ->
    this.modalAction('remove' , name )

  fileRename: (name) ->
    this.openModal "文件改名" , 'rename' , name , name

  fileDupe: (name) ->
    [file...,ext] = name.split(".")
    this.openModal "复制文件" , 'dupe' , file + '_copy.'+ext , name

  newProj: () ->
    this.openModal "新建项目" , 'newproj' , '' , ''

  fileNewfile: (name) ->
    dir = if $("#folder .dir > a[rel='#{name}']").length>0 then name+"/" else name.split("/")[0..-2].join("/")+"/"
    this.openModal "新建文件" , 'newfile' , dir , name

  fileNewfolder: (name) ->
    dir = if $("#folder .dir > a[rel='#{name}']").length>0 then name+"/" else name.split("/")[0..-2].join("/")+"/"
    this.openModal "新建文件夹" , 'newfolder' , dir , name

  openModal: (title ,action , value ,hvalue ) ->
    $('#filename .modal-header h3').html(title)
    $('#filename').on('shown', ->
      $('#filename input[type="hidden"]').val(hvalue)
      $('#filename input[type="text"]').focus().val(value)
    ).modal({show:true})
    $('#filename .modal-footer .btn-primary').attr('action' , action)

  modalAction: (action , value , hvalue) ->
    this.loading('show','正在处理...')
    data = {}
    url  = ''
    success = false
    successCall = ->
    failCall = ->
      alert "操作失败，请重试"
    $('#filename').modal('hide')
    switch action
      when "remove"
        url = "fileRemove.json"
        data = 
          filename: value
        successCall = (data)->
          $("#folder li>a[rel=\"#{value}\"]").parent().remove()
          root.ec_editor.removeTab $("#navTab li>a[ref=\"#{value}\"]").parent()
      when "save"
        url = "fileSave.json"
        data = 
          filename: value
          str: hvalue
        successCall = (data)->
          root.ec_editor.savedTab $("#navTab li>a[ref=\"#{value}\"]").parent()
      when "rename"
        url = "fileRename.json"
        data = 
          newname: value
          filename: hvalue
        successCall = (data)->
          if value != hvalue
            $("#folder li>a[rel=\"#{hvalue}\"]").parent().remove()
            root.ec_editor.removeTab $("#navTab li>a[ref=\"#{hvalue}\"]").parent()
            root.ec_editor.refreshFileFolder(value)
      when "dupe"
        url = "fileDupe.json"
        data = 
          newname: value
          filename: hvalue
        successCall = (data)->
          if value != hvalue
            root.ec_editor.refreshFileFolder(value)
      when "newfile"
        url = "fileNewfile.json"
        data = 
          newname: value
          filename: hvalue
        successCall = (data)->
          if data.success
            root.ec_editor.refreshFileFolder(value)
      when "newfolder"
        url = "fileNewfolder.json"
        data = 
          newname: value
          filename: hvalue
        successCall = (data)->
          if data.success
            root.ec_editor.refreshFileFolder(value)
      when "newproj"
        url = "newProj.json"
        data = 
          newname: value
          filename: hvalue
        successCall = (data)->
          window.location.href = "index?dir=" + value
    $.post( url , data , successCall ).fail( failCall );
    this.loading('hide')

  # 刷新新建文件所在目录
  refreshFileFolder: (value) ->
    farr = value.split("/")
    $("#folder .dir.expanded > a[rel=\""+farr[0..-2].join("/")+"\"]").click().click()
    $("#folder .dir.collapsed > a[rel=\""+farr[0..-2].join("/")+"\"]").click()
    if farr.length == 2
      tree_option = root: root.ec_editor.dir
      root.ec_editor.refreshTree(tree_option)

  refreshTree: (tree_option) ->
    $('.jqueryFileTree',@editor_obj).fileTree(tree_option
      , (file)->
        # 寻找tab是否存在该文件
        if $("#navTab a[href=\"##{file.replace(/\//g, "-").replace(/\./g, "-") }\"]").length > 0
          root.ec_editor.goTab($("#navTab a[href=\"##{file.replace(/\//g, "-").replace(/\./g, "-") }\"]").parent())
        else
          root.ec_editor.goTab(0)
          if $('#__default_frame iframe').attr("src") != 'editor?file='+file
            $('#__default_frame iframe').attr("src" , 'editor?file='+file)
        setTimeout( ->
          $('#folder li > a').removeClass('active')
          $("#folder li > a[rel=\"#{file}\"]").addClass('active')
        ,100)
      ,(file) ->
        root.ec_editor.addTab(file)
    )

  addTab: (dir) ->
    [d...,file] = dir.split("/")
    ref = dir.replace( /\//g, "-" ).replace( /\./g, "-" )
    # 创建新的标签
    tab = $("#navTab a[href=\"##{ref}\"]").parent()
    if tab.length == 0
      content = $('<div class="tab-pane active" id="'+ref+'"><iframe src="editor?file='+dir+'" frameborder="no" scrolling="auto"></iframe></div>')
      $("#tabContent").append( content )
      tab = $("<li><a href=\"##{ref}\" ref=\"#{dir}\" data-toggle=\"tabContent\">#{file}</a><button type=\"button\" class=\"close\" >×</button></li>").click(() ->
        root.ec_editor.goTab(tab)
      ).dblclick( () ->
        root.ec_editor.removeTab($(this))
      )
      $('button',tab).click(->
        root.ec_editor.removeTab(tab)
      )
      $("#navTab").append( tab )
      $('.tab-content').css('top',$('.nav-tabs').height()+"px")
    this.saveNowTabs()
    this.goTab($(tab))

  saveNowTabs: ->
    tabs = []
    $("#navTab li>a").each( (k,v) ->
      tabs.push($(v).attr('ref')) if $(v).attr('ref')?
    )
    $.cookie( 'tabs' , tabs.join(",") )

  changedTab: (id) ->
    obj = this.getTab(id)
    $("a" , obj).html($("a" , obj).html()+"*") if $("a" , obj).html()[-1..]!="*"

  savedTab: (id) ->
    obj = this.getTab(id)
    $("a" , obj).html($("a" , obj).html()[0..-2]) if $("a" , obj).html()[-1..]=="*"

  removeTab: (id) ->
    obj = this.getTab(id)
    if obj.length > 0
      obj.remove()
      $("#tabContent .tab-pane[id='#{$("a" , obj).attr("href").substr(1)}']" ).remove()
      $('.tab-content').css('top',($('.nav-tabs').height()+1)+"px")
    this.saveNowTabs()

  goTab: (id) ->
    obj = this.getTab(id)
    if obj.length > 0
      $("a" , obj).tab('show')
      $("#tabContent .tab-pane" ).removeClass('active')
      $("#tabContent .tab-pane[id='#{$("a" , obj).attr("href").substr(1)}']" ).addClass('active')
      [location , href] = window.location.href.split("#")
      window.location.href = location+$("a" , obj).attr('href')
      # 相应文件选择
      setTimeout( ->
        $('#folder li > a').removeClass('active')
        $("#folder li > a[rel=\"#{$("a" , obj).attr('ref')}\"]").addClass('active')
      ,100)
  getTab: (id) ->
    if "object" == typeof id
      obj = id
    else
      obj = $("#navTab a:eq(#{parseInt(id)})").parent()
    return obj
  windowResize: (event) ->
    root.ec_editor.editor_obj.width("#{$(window).width()}px")
    root.ec_editor.editor_obj.height("#{$(window).height()}px")

  windowKeyDown: (event) ->
    # if (event.metaKey && event.keyCode == 83) || (event.ctrlKey && event.keyCode == 83)
    #     return false;
  buildProjJs : () ->
    $("#build_btn").html "building..."
    $.post( "build_proj_js" , {project:$('#project select').val()} , ->
      $("#build_btn").html "build"
      ).fail( ->
      $("#build_btn").html "build fail"
      );
  loading: (action,words)->
    $('#loading')[action]()
    $('#loading').html(words) if words?

$ ->
  root.ec_editor = new EcEditor($("#main"),$('#project select').val())
  root.ec_editor.windowResize()
  # 打开所有之前打开的文件
  root.ec_editor.addTab v for v in $.cookie('tabs').split(",")


