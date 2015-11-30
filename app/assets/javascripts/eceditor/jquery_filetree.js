// jQuery File Tree Plugin
//

if (jQuery) (function($){
	$.extend($.fn, {
		fileTree: function(o, click_call , dbclick_call ) {
			// Defaults
      var defaults = {
        script: 'file.json',
        expandSpeed: 500,
        expandEasing: null,
        collapseSpeed: 500,
        collapseEasing: null,
        root: '/',
        loadingMessage: 'Loading...'
      };
      // Expand the defaults with the supplied o
      o = $.extend(defaults, o);
			
			$(this).each(function() {
        function showTree(c, t) {
          $(c).addClass('wait');
          $(".jqueryFileTree.start").remove();
          $.get(o.script, {dir: t}, function (data) {
            var listHtml = '<ul class="jqueryFileTree" style="display:none">';
            $.each(data, function(k,v){
              if (v.isdir)
                listHtml += '<li class="dir directory collapsed"><a href="#" rel="'+ v.path +'">' + v.name + '</li>';
            });
            $.each(data, function(k,v){
              if (!v.isdir)
                listHtml += '<li class="file ext_'+v.ext+'"><a href="#" rel="'+ v.path +'">' + v.name + '</li>';
            });
            listHtml += "</ul>"
            $(c).find('.start').html('');
            $(c).removeClass('wait').append(listHtml );
            if( o.root == t ) $(c).find('UL:hidden').show(); else $(c).find('UL:hidden').slideDown({ duration: o.expandSpeed, easing: o.expandEasing });
            bindTree(c);
          }, 'json');
        }
        
        function bindTree(t) {
          // 单击
          $(t).find('LI A').bind("click", function() {
            if( $(this).parent().hasClass('directory') ) {
              if( $(this).parent().hasClass('collapsed') ) {
                $(this).parent().find('UL').remove(); // cleanup
                showTree( $(this).parent(), $(this).attr('rel') );
                $(this).parent().removeClass('collapsed').addClass('expanded');
              } else {
                // Collapse
                $(this).parent().find('UL').slideUp({ duration: o.collapseSpeed, easing: o.collapseEasing });
                $(this).parent().removeClass('expanded').addClass('collapsed');
              }
            } else {
              // click_call($(this).attr('rel'));
            }
            return false;
          });
          // 双击，文件打开标签，文件夹刷新显示
          $(t).find('LI A').bind("dblclick", function() {
            if (!$(this).parent().hasClass('directory'))
              dbclick_call($(this).attr('rel')) 
          });
          // 右键
          $(t).find('LI A').bind("mousedown", function(e) {
            if(3 == e.which && !$(this).parent().hasClass('directory') )
              click_call($(this).attr('rel'));
          });

        }
        function openFolder(){

        }

        // Loading message
        $(this).html('<ul class="jqueryFileTree start"><li class="wait">' + o.loadingMessage + '<li></ul>');
        // Get the initial file list
        showTree( $(this), escape(o.root) );
			});
		}
	});
})(jQuery);

