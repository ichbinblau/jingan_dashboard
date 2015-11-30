/**
 * jq.web.template - a javascript template library
 * Templating from John Resig - http://ejohn.org/ - MIT Licensed
 */
(function($) {
    self = this
    self._tpl = {}

    $["template"] = function(tmpl, data) {
        return (template(tmpl, data));
    }

    $["tmpl"] = function(tmpl, data) {
        return $(template(tmpl, data));
    }

    $['template_set'] = function(name , value){
        self._tpl[name] = value
    }
    $['template_get'] = function(name){
        return self._tpl[name]
    }
    var template = function(str, data) {
        //If there's no data, let's pass an empty object so the user isn't forced to.
        if (!data)
            data = {};
        return tmpl(str, data);
    };
    
    (function() {
        var cache = {};
        this.tmpl = function tmpl(str, data) {
            // // var fn = !/\W/.test(str) ? cache[str] = cache[str] || tmpl(document.getElementById(str).innerHTML) : new Function("obj", "var p=[],print=function(){p.push.apply(p,arguments);};" + "with(obj){p.push('" + str.replace(/[\r\t\n]/g, " ").replace(/'(?=[^%]*%>)/g, "\t").split("'").join("\\'").split("\t").join("'").replace(/<%=(.+?)%>/g, "',$1,'").split("<%").join("');").split("%>").join("p.push('") + "');}return p.join('');");
            var fn = !/\W/.test(str) ? cache[str] = cache[str] || tmpl($.template_get(str)) : new Function("obj", "var p=[],print=function(){p.push.apply(p,arguments);};" + "with(obj){p.push('" + str.replace(/[\r\t\n]/g, " ").replace(/'(?=[^%]*%>)/g, "\t").split("'").join("\\'").split("\t").join("'").replace(/<%=(.+?)%>/g, "',$1,'").split("<%").join("');").split("%>").join("p.push('") + "');}return p.join('');");
            return data ? fn(data) : fn;
        };
    })();
})(jq);