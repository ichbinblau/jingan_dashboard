Ext.ns("_KM", "_KM.Component", "_KM.Event", "_KM.Controls", "_KM.Controls.UI", "_KM.Controls.plugins", "_KM.Controls.ViewPaging", "_KM.Node", "_KM.Android.Controls", "_KM.Android.Configs");

Array.prototype.clear = function () {
    this.length = 0;
};
Array.prototype.insertAt = function (index, obj) {
    this.splice(index, 0, obj);
};
Array.prototype.removeAt = function (index) {
    this.splice(index, 1);
};
Array.prototype.remove = function (obj) {
    var index = this.indexOf(obj);
    if (index >= 0) {
        this.removeAt(index);
    }
};

(function () {
    var lt = {
        Fn: {
            replaceURLWithHTMLLinks: function (text) {
                var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
                return text.replace(exp, "<a target='_blank' href='$1'>$1</a>");
            },
            isUrl: function (Value) {
                var strRegex = ["^((https|http|ftp|rtsp|mms)?://)"
                                , "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" //ftp的user@ 
                                , "(([0-9]{1,3}.){3}[0-9]{1,3}" // IP形式的URL- 199.194.52.184 
                                , "|" // 允许IP和DOMAIN（域名）
                                , "([0-9a-z_!~*'()-]+.)*" // 域名- www. 
                                , "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]." // 二级域名 
                                , "[a-z]{2,6})" // first level domain- .com or .museum 
                                , "(:[0-9]{1,4})?" // 端口- :80 
                //, "((/?)|(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$" // a slash isn't required if there is no file name 
                ].join('');

                var re = new RegExp(strRegex);
                if (re.test(Value)) {
                    return (true);
                } else {
                    return (false);
                }
            },
            htmlToText: function (value) {
                var el = $("<textarea>");
                el.html(value);
                return el.val();
            }
        },
        getMaxZindex: function (el) {
            var jel = el.jQuery ? el : $(el),
                v1 = 0, v2;

            $("*", jel).each(function () {
                if (el.style && (v2 = el.style['z-index']) != "auto" && v2 > v1)
                    v1 = v2;
            });
            return v1;
        },
        getUserName: function (value) {
            if (value == null) return '';
            return value.replace(/^[^\\]+\\/g, '');
        },
        getByteLen: function (value) {
            var byteNum = 0;
            for (var i = 0; i < value.length; i++) {
                if (value.charCodeAt(i) > 255)
                    byteNum += 2;
                else
                    byteNum++;
            }
            return byteNum;
        },
        ellipsis: function (value, len, sign) {
            if (!value || !len) { return ''; }
            sign = sign == null ? '...' : sign;

            var byteNum = 0;
            var buf = [];

            for (var i = 0; i < value.length; i++) {
                if (value.charCodeAt(i) > 255)
                    byteNum += 2;
                else
                    byteNum++;

                if (byteNum > len) { buf.push(sign); return buf.join(''); }
                buf.push(value.charAt(i));
            }

            if (len > byteNum)
                return value;

            buf.push(sign);
            //如果全部是单字节字符，就直接返回源字符串
            return buf.join('');
        },
        getjQueryObject: function (obj, c) {
            if (obj == null)
                return null;
            if (c) {
                if ($.isFunction(obj)) {
                    return $(obj(c));
                }
                return $(obj, c);
            }
            if (obj instanceof jQuery)
                return obj;
            if ($.isFunction(obj))
                return $(obj());
            return $(obj);
        },
        getDom: function (obj) {
            if (obj instanceof jQuery)
                return obj.get(0);
            return obj;
        },
        stopEvent: function (event) { if (!event) event = window.event; event.stopPropagation(); event.preventDefault(); },

        getRecord: function (p, trim) { // {dataIndex fn}
            var o = {},
                els = $("input:radio[dataIndex*=],textarea[dataIndex*=],input:text[dataIndex*=],input:hidden[dataIndex*=],select[dataIndex*=]", p);

            $.each(els, function () {
                var el = this,
                    jel = $(this),
                    dataIndex = jel.attr("dataIndex"),
                    getFn = jel.attr("getValueFn"),
                    getHandler = jel.attr("getValueHandler");

                var value = undefined;

                if (getFn) {
                    value = eval("(" + getFn + ").call(this,\"" + dataIndex + "\",el);");
                } else if (getHandler) {
                    value = eval("(function(dataIndex,el){" + getHandler + "}).call(this,dataIndex,el);");
                }
                else if (this.value != undefined) {
                    value = trim === true ? $.trim(this.value) : this.value;
                }

                if (value === undefined)
                    return;

                var v = o[dataIndex];
                if (v === undefined) {
                    o[dataIndex] = value;
                } else {
                    if ($.isArray(v)) {
                        v.push(this.value);
                    } else {
                        o[dataIndex] = [v, value];
                    }
                }
            });
            return o;
        },
        setRecord: function (p, reocrd) {
            reocrd = reocrd || {};
            var els = $("[dataIndex*=]", p);
            $.each(els, function () {
                var el = this, jel = $(this),
                dataIndex = jel.attr("dataIndex"),
                setFn = jel.attr("setValueFn"),
                setHandler = jel.attr("setValueHandler");
                var value = reocrd[dataIndex];

                if (setFn) {
                    eval("(" + setFn + ").call(this,value,record,\"" + dataIndex + "\",el);");
                } else if (setHandler) {
                    eval("(function(value,record,dataIndex,el){" + getHandler + "}).call(this.caller||this,value,record,dataIndex,el);");
                }
                else if (this.value != undefined) {
                    if (jel.is(":checkbox,:radio")) {
                        if ($.isArray(value)) {
                            this.checked = jQuery.inArray(this.value, value);
                        } else if (typeof value == "String") {
                            var reg = new RegExp("\W+" + this.value + "\W+", "ig");
                            this.checked = reg.test("|" + value + "|");
                        }
                    } else {
                        jel.val(value);
                    }
                }
            });
        },
        setDefaultImage: function (el) {
            $(el).find("img").bind("error", function () {//测试使用
                this.src = '/Images/avatar.gif';
                //this.src = "/Component/common/images/_temp/_temp.img.3.1.jpg"; //测试
            });
        },
        validImageFile: function (f, msg) {
            var v = $.trim(f.value).toLowerCase();
            if (!v.length) { msg.push("请选择文件"); return false }
            var ar = [".jpg", ".jpeg", ".gif", ".png", ".bmp"];
            v = v.match(/\.[^\.]+$/);
            v = v ? v[0] : null;
            if (!v || $.inArray(v, ar) == -1) {
                msg.push("文件格式不正确，格式为:" + ar.join(""));
                return false;
            } else if (f.fileSize && f.fileSize > 100 * 1024) {
                msg.push("上传文件大小不能超过100K");
                return false;
            }
            return true;
        },
        getCenterPostion: function (el) {
            //            var width = $(window).width(),     //以前代码
            //                height = $(document).height(),
            //                o = { top: (height - $(el).height()) * 0.5, left: (width - $(el).width()) * 0.5 };
            var o = {}, p;
            if (window.innerHeight) {
                p = window;
                o.left = window.pageXOffset;
                o.top = window.pageYOffset;
            }
            else if (document.documentElement && document.documentElement.scrollTop != null) {
                p = document.documentElement;
                o.left = document.documentElement.scrollLeft;
                o.top = document.documentElement.scrollTop;
            }
            else if (document.body) {
                p = document.body;
                o.left = document.body.scrollLeft;
                o.top = document.body.scrollTop;
            }
            var offset = {
                left: ($(p).width() - $(el).width()) / 2,
                top: ($(p).height() - $(el).height()) / 2
            }
            o.left += offset.left;
            o.top += offset.top;
            return o;
        }
    };
    Ext.apply(_KM, lt);
})();

_KM.TextareaUtils = (function () {
    var a = {}, b = document.selection;
    a.selectionStart = function (h) {
        h.focus();
        try {
            if (!b) {
                return h.selectionStart
            }
            var o = b.createRange(), n, g, m = 0;
            var j = document.body.createTextRange();
            j.moveToElementText(h);
            for (m; j.compareEndPoints("StartToStart", o) < 0; m++) {
                j.moveStart("character", 1)
            }
        } catch (e) {

        }
        return m
    };
    a.selectionBefore = function (g) {
        return g.value.slice(0, a.selectionStart(g))
    };
    a.selectText = function (g, h, j) {
        g.focus();
        if (!b) {
            g.setSelectionRange(h, j);
            return;
        }
        var m = g.createTextRange();
        m.collapse(1);
        m.moveStart("character", h);
        m.moveEnd("character", j - h);
        m.select()
    };
    a.insertText = function (j, h, n, m) {
        j.focus();
        m = m || 0;
        if (n === undefined)
            n = a.selectionStart(j);

        if (!b) {
            var o = j.value,
                q = n - m,
                g = q + h.length;
            j.value = o.slice(0, q) + h + o.slice(n, o.length);
            a.selectText(j, g, g);

        } else {
            var p = b.createRange();
            p.moveStart("character", -m);
            p.text = h
        }
    };
    a.getCursorPos = function (m) {
        var j = 0;
        if ($.browser.msie) {
            m.focus();
            var g = null;
            g = b.createRange();
            var h = g.duplicate();
            h.moveToElementText(m);
            h.setEndPoint("EndToEnd", g);
            m.selectionStart = h.text.length - g.text.length;
            m.selectionEnd = m.selectionStart + g.text.length;
            j = m.selectionStart
        }
        else {
            if (m.selectionStart || m.selectionStart == "0") {
                j = m.selectionStart
            }
        }
        return j
    };
    a.getSelectedText = function (h) {
        var j = "";
        var g = function (m) {
            if (m.selectionStart != undefined && m.selectionEnd != undefined) {
                return m.value.substring(m.selectionStart, m.selectionEnd)
            }
            else {
                return ""
            }
        };
        if (window.getSelection) {
            j = g(h)
        }
        else {
            j = b.createRange().text
        }
        return j
    };
    a.setCursor = function (j, m, h) {
        //设置Textarea的光标点 j=textarea
        m = m == null ? j.value.length : m;
        h = h == null ? 0 : h;
        try {
            j.focus();
            if (j.createTextRange) {
                var g = j.createTextRange();
                g.move("character", m);
                g.moveEnd("character", h);
                g.select()
            }
            else {
                j.setSelectionRange(m, m + h)
            }
        } catch (e) {


        }
    };

    a.unCoverInsertText = function (m, o, j) {
        /*
        n=textarea 
        o=@ 
        j=
        */
        j = (j == null) ? {} : j;
        j.rcs = j.rcs == null ? m.value.length : j.rcs * 1;
        j.rccl = j.rccl == null ? 0 : j.rccl * 1;
        var n = m.value,
            g = n.slice(0, j.rcs),
            h = n.slice(j.rcs + j.rccl, n == "" ? 0 : n.length);

        m.value = g + o + h;
        this.setCursor(m, j.rcs + (o == null ? 0 : o.length))
    };
    return a
})();

_KM.EncodeUtils = (function () {
    var g = {
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "\\": "&#92;",
        "&": "&amp;",
        "'": "&#039;",
        "\r": "",
        "\n": "<br>"
    },
        a = /<|>|\'|\"|&|\\|\r\n|\n| /gi;
    var b = {};

    //Unicode转换
    b.regexp = function (h) {
        return h.replace(/\}|\]|\)|\.|\$|\^|\{|\[|\(|\|\|\*|\+|\?|\\/gi, function (j) {
            //Unicode 转换成16进制
            j = j.charCodeAt(0).toString(16);
            //产生5位的Unicode
            return "\\u" + (new Array(5 - j.length)).join("0") + j
        })
    };
    //html编码转换
    b.html = function (h, j) {
        j = j || g;

        return h.replace(a, function (m) {
            return j[m]
        })
    };
    return b
}
)();



_KM.Event = function (config) {
    this.initialConfig = config;
    Ext.apply(this, config);
    if (!this.events) this.events = {};
    _KM.Event.superclass.constructor.call(this);
    if (config && config.eventConfigs) {
        this.addEvents(config.eventConfigs);
    }
}
Ext.extend(_KM.Event, Ext.util.Observable);


_KM.Component = function (config) {
    this.initialConfig = config;
    Ext.apply(this, config);
    if (!this.events) this.events = {};

    _KM.Component.superclass.constructor.call(this);
    this.initComponent();
    if (this.plugins) {
        if (Ext.isArray(this.plugins)) {
            for (var i = 0, len = this.plugins.length; i < len; i++) {
                this.plugins[i] = this.initPlugin(this.plugins[i]);
            }
        } else {
            this.plugins = this.initPlugin(this.plugins);
        }
    }


};

Ext.extend(_KM.Component, Ext.util.Observable, {
    initEvents: function () { },
    initComponent: function () {
        this.initEvents();
        if (this.listeners) {
            this.on(this.listeners);
            delete this.listeners;
        }
    },
    initPlugin: function (p) {
        p.init(this);
        return p;
    },
    render: function () {

    }
});


//_KM.Controls = function () { }





//可视化组件
_KM.Controls.uiComponent = Ext.extend(_KM.Component, {
    initComponent: function () {
        var config = this.initialConfig;
        _KM.Controls.uiComponent.superclass.initComponent.call(this);
        this.addEvents("beforehide", "beforeshow", "show", "hide", "beforerender", "render", "enable", "disable", "readonly", "resize");
        Ext.applyIf(this, { items: [] });

        //        this.on("enable", function () {
        //            setItemsDisable(false);
        //        });
        //        this.on("disable", function () {
        //            setItemsDisable(true);
        //        });

    },
    setItemsDisable: function (value) {
        var context = this;
        if (context.items && context.items.length) {
            Ext.each(context.items, function (c) {
                c.setDisable && c.setDisable(value);
            });
        }
    },
    onRender: function (ct, position) {
        var h = this.builderEl(),
            c;
        if (h) {
            if (position) {
                c = _KM.getjQueryObject(position);
                this.jel = _KM.getjQueryObject(h).insertBefore(c);
            } else if (ct) {
                this.jel = _KM.getjQueryObject(h).appendTo(ct);
            }
            else if (this.renderTo) {
                c = _KM.getjQueryObject(this.renderTo);
                this.jel = _KM.getjQueryObject(h).appendTo(c);
            }
            else if (this.applyTo) {
                this.jel = _KM.getjQueryObject(this.applyTo);
                var el = _KM.getjQueryObject(h);
                var children = el.children();
                if (el && children.length) {
                    this.jel.append(children);
                    el.remove();
                }
            }
            else {
                this.jel = _KM.getjQueryObject(h).appendTo(ct || document.body);
            }
        } else {
            if (this.applyTo) {
                this.jel = _KM.getjQueryObject(this.applyTo);
            }
        }

    },
    render: function (container, position) {
        var context = this;
        if (!this.rendered && this.fireEvent('beforerender', this) !== false) {

            this.rendered = true;
            this.jcontainer = _KM.getjQueryObject(container);
            var jposition = null;
            if (position !== undefined) {
                if (typeof position == "number") {
                    jposition = this.jcontainer.children().eq(position);
                } else {
                    jposition = _KM.getjQueryObject(position, this.jcontainer);
                }
            }

            this.onRender(this.jcontainer, jposition || null);

            if (this.cls) {
                this.addClass(this.cls);
                delete this.cls;
            }
            if (this.style) {
                if (typeof this.style == "string") {
                    var styles = $.trim(this.style).split(/\s*(?::|;)\s*/);
                    for (len = styles.length, i = 0; i < len;) {
                        this.jel.css(styles[i++], styles[i++]);
                    }
                } else {
                    this.jel.css(this.style);
                }
                //样式要重写
                //                var keyValues = this.style.split(";");
                //                for (var i = 0; i < keyValues.length; i++) {
                //                    var kv = keyValues.split(":"),
                //                    k = $.trim(kv[0]),
                //                    v = $.trim(kv[1]);
                //                    this.jel.get(0).style[k] = v;
                //                }
                delete this.style;
            }
            if (this.width != null) {
                this.jel.get(0).style.width = this.width;
                delete this.width;
            }
            if (this.height != null) {
                this.jel.get(0).style.height = this.height;
                delete this.height;
            }

            this.fireEvent('render', this);

            if (this.hidden === true) {
                this.hide();
            } else
                this.show();

            if (this.html) {
                this.jel.html(this.html);
                delete this.html;
            }
            if (this.disabled) {
                this.disable();
            }
            this.afterRender && this.afterRender(container);

            if (this.jel) {
                this.jel.bind("resize", function (e) {
                    context.onResize(e);
                });
            }

        }
    },
    onResize: function (e) {
        this.fireEvent("resize", this, e);
    },
    getWidth: function () {
        return this.jel.width();
    },
    setWidth: function (value) {
        this.jel.width(value);
    },
    getHeight: function () {
        return this.jel.height();
    },
    setHeight: function (value) {
        this.jel.height(value);
    },
    addClass: function (value) {
        this.jel.addClass(value);
        return this;
    },
    removeClass: function () {

        this.jel.removeClass(value);
        return this;
    },
    getFormElements: function () {
        var fromSelector = ":input,:textarea,:radio,:checkbox";
        var elements = this.jel.filter(selector);
        elements.add(this.jel.find(selector));
        return elements;
    },
    setDisable: function (value) {
        value ? this.disable(false) : this.enable(false);
        return this;
    },
    alertDisabledMsg: function (msg) {
        msg = msg || this.disabledMessage || '此控件被禁用';
        if (msg)
            alert(msg);
    },
    setDisabledMsg: function (msg, isBubble) {
        this.disabledMessage = msg;
        var context = this;

        if (isBubble === false)
            return;
        if (context.items && context.items.length) {
            Ext.each(context.items, function (c) {
                c.setDisabledMsg && c.setDisabledMsg(msg);
            });
        }
    },
    enable: function (isFireEvent) {
        //        if (this.getFormElements) {
        //            var elements = this.getFormElements();
        //            elements.attr("disable", false);
        //        }
        this.disabled = false;
        //if (isFireEvent === false) return this;
        this.fireEvent("enable", this)
        this.setItemsDisable && this.setItemsDisable(false);
        return this;
    },
    disable: function (isFireEvent) {
        //        var elements = this.getFormElements();
        //        elements.attr("disable", true);
        this.disabled = true;
        //if (isFireEvent === false) return this;
        this.fireEvent("disable", this);
        this.setItemsDisable && this.setItemsDisable(true);
        return this;
    },
    setReadonly: function (value, isFireEvent) {

        var elements = this.getFormElements();
        elements.attr("readonly", value);
        this.readonly = value;
        if (isFireEvent === false) return this;
        this.fireEvent("readonly", this, value, elements);
        return this;
    },
    isVisible: function () {
        return this.hidden === false;
    },
    getOffset: function () {
        return this.jel.offset();
    },
    setOffset: function (value) {
        if (typeof value == "string") {
            if (value == "center") {
                //getCenterPostion
                var o = _KM.getCenterPostion(this.jel);
                if (o.top < 0) {
                    o.top = 0;
                }
                this.jel.offset(o);
            }

        } else {
            this.jel.offset(value);
        }
    },
    //此方法需要重写返回html元素或者对象
    builderEl: function () { },
    hide: function (value) {

        if (this.fireEvent("beforehide", this) === false)
            return;

        this.hidden = true;
        if (value) this.jel.css(value);

        this.jel.hide();
        this.fireEvent("hide", this);
    },
    show: function (value) {

        if (this.fireEvent("beforeshow", this) === false)
            return;

        this.hidden = false;
        if (value) this.jel.css(value);
        this.jel.show();
        //this.jel.fadeIn('fast');
        this.fireEvent("show", this);
    },
    destroy: function () {
        if (this.fireEvent("beforedestroy", this) === false)
            return false;
        if (this.jel) {
            this.jel.remove();
            this.jel = null;
        }

        if (this.items && this.items.length) {
            for (var i = 0; i != this.items.length; i++) {
                var cmp = this.items[i];
                if (cmp.destroy) {
                    cmp.destroy();
                }
                delete cmp;
            }
            delete this.items;
        }
        this.fireEvent("destroy", this);
    },
    zindex: function () {
        return this.jel.css("z-index");
    },
    toggle: function () {
        if (this.hidden)
            this.show();
        else
            this.hide();
        //this.jel.toggle();
    },
    hasEl: function (el) {
        return $(el).closest(this.jel).length;
    },
    setCss: function (o) {
        this.jel.css(o);
    },
    getCss: function () {
        return this.jel.css();
    }
});

_KM.Android.Configs = {
    FieldSetConfig: [
          { name: "control_id" },
          { name: "xtype" },
          { name: "layout" },
          {
              name: "position",
              type: "array",
              mode: "column",
              fields: [
                  { name: "key", type: "string" },
                  { name: "value", type: "string" }
              ]
          },
          {
              name: "attr", type: "column",
              fields: [
                  { name: "key", type: "string" },
                  { name: "value", type: "string" }
              ]
          },
          {
              name: "configs",
              type: "array",
              mode: "column",
              fields: [
                  { name: "key", type: "string" },
                  { name: "value", type: "string" }
              ]
          },
          {
              name: "setEvent",
              type: "object",
              fields: [
                  { name: "name", type: "string" },
                  {
                      name: "params",
                      type: "array",
                      mode: "column",
                      fields: [
                            { name: "key", type: "string" },
                            { name: "value", type: "string", defaultValue: "缺省值" }
                      ]
                  },
                  { name: "javascript", type: "javascript" }
              ]
          },
          {
              name: "dataSource",
              type: "object",
              fields: [
                  { name: "method", type: "string" },
                  {
                      name: "params",
                      type: "array",
                      mode: "column",
                      fields: [
                          { name: "key", type: "string" },
                          { name: "value", type: "string" }
                      ]

                  },
                  { name: "data", type: "json" },
                  {
                      name: "adapter",
                      type: "array",
                      mode: "column",
                      fields: [
                              { name: "key", type: "string" },
                              { name: "value", type: "string" }
                      ]

                  }
              ]
          }],
    PageSetConfig: [
         { name: "name", type: "string" },
         { name: "page_id", type: "string" },
        {
            name: "dataSource",
            type: "object",
            fields: [
              { name: "method", type: "string" },
              {
                  name: "params",
                  type: "array",
                  mode: "column",
                  fields: [
                      { name: "key", type: "string" },
                      { name: "value", type: "string" }
                  ]

              },
              { name: "data", type: "json" },
              {
                  name: "adapter",
                  type: "array",
                  mode: "column",
                  fields: [
                          { name: "key", type: "string" },
                          { name: "value", type: "string" }
                  ]

              }
            ]
        },
        {
             name: "configs",
             type: "array",
             mode: "column",
             fields: [
                 { name: "key", type: "string" },
                 { name: "value", type: "string" }
             ]
        },
        { name: "auto_start_controls", type: "array", memberType: "string" }
        //{ name: "controls", type: "array", memberType: "object", member: [] }
    ]
};



/* 传入是一个对象
1.遍历属性 
    a . type in [ string json] 放入简单属性里面  (键值对)
    b . type in table 属性 table 列表中          (对象数组 列表)
    c . type in object 对其 fields 遍历
2.
*/
/*传入是一个数组

*/
_KM.Android.Controls.FieldSetControl = Ext.extend(_KM.Controls.uiComponent, {

    setValue: function (value) {
        if (!value) return;

        var context = this,
           head_el = context.head_el,
           table_content_el = context.table_content_el,
           children_el = context.children_el,
           table_el = context.table_el,
           controls_el = context.controls_el,
           config = context.configItem;
        if (!config) return;
        var configType = $.type(config);
        var type = config.type;

        var complexMembers = context.complexMembers,
            simpleMembers = context.simpleMembers,
            mode = config.mode;

        var isStringArray = (type == "array" && config.memberType == "string");

        if (mode == "column" || isStringArray) {
            table_content_el.empty();
            var fields = config.fields;
            if (value && $.isArray(value)) {
                $.each(value, function (i, item) {
                    var tr = context.addTableRowByColumnMode(fields, table_content_el);
                    tr.find("[dataIndex]").each(function () {
                        var ctx = $(this);
                        if (isStringArray) {
                            ctx.val(item);
                        } else
                            ctx.val(item[ctx.attr('dataIndex')]);
                    });
                });
            }
        } else if (type == "object" || !type) {


            table_content_el.find('[dataIndex]').each(function () {
                var el = $(this);
                value && el.val(value[el.attr('dataIndex')] || "");
            });

            $.each(this.items, function (i, item) {
                var childConfigItem = complexMembers[i], childeValue = value[childConfigItem.name];
                childeValue && item.setValue(childeValue);
            });
        }
    },
    getValue: function () {
        var context = this,
           head_el = context.head_el,
           table_content_el = context.table_content_el,
           children_el = context.children_el,
           table_el = context.table_el,
           controls_el = context.controls_el,
           config = context.configItem;
        if (!config) return;

        var configType = $.type(config);
        var type = config.type;

        var complexMembers = context.complexMembers,
            simpleMembers = context.simpleMembers,
            result = null,
            mode = config.mode;

        var isStringArray = (type == "array" && config.memberType == "string");

        if (mode == "column" || isStringArray) {
            result = [];
            if (isStringArray) {
                table_content_el.find(':text').each(function () {
                    result.push($(this).val());
                });
            } else {
                table_content_el.find('tr').each(function (i) {
                    var o = {}, tr = $(this);
                    tr.find(':text').each(function () {
                        var el = $(this);
                        o[el.attr("dataIndex")] = el.val();
                    });
                    result.push(o);
                });
            }
        } else if (type == "object" || !type) {
            result = {};
            table_content_el.find(':text').each(function () {
                var el = $(this);
                result[el.attr("dataIndex")] = el.val();
            });

            $.each(this.items, function (i, item) {
                var childConfigItem = complexMembers[i], childType = childConfigItem.type;
                result[childConfigItem.name] = item.getValue();
            });

        }
        return result;
    },
    //添加动态行 列模式 configFields
    addTableRowByColumnMode: function (fields, toEl) {
        var ar = [];
        ar.push('<tr>');
        for (var i = 0; i < fields.length; i++) {
            var field = fields[i];
            var fieldName = field.name, value = field.defaultValue || "";
            ar.push('<td><input type="text" class="input-medium" dataIndex="', fieldName, '" name="', fieldName, '" value="', value, '" ></td>');
        }
        ar.push('<td><input type="button" class="btn delete" value="删除"> </td></tr>');
        var tr = $(ar.join('')).appendTo(toEl);
        tr.find(':button').click(function () {
            $(this).closest('tr').remove();
        });
        return tr;
    },
    setConfig: function (config, key) {
        var context = this,
            head_el = context.head_el,
            table_content_el = context.table_content_el,
            children_el = context.children_el,
            table_el = this.table_el,
            controls_el = this.controls_el;

        if (!config) return;

        context.Key = key || config.name;
        context.configItem = config;

        head_el.text(key);
        var configType = $.type(config);

        var type = config.type,
            mode = config.mode;
        if (type == "object" || !type) {

            var complexMembers = context.complexMembers = [],
                simpleMembers = context.simpleMembers = [],
                fields = configType == "array" ? config : config.fields;

            if (fields) {
                $.each(fields, function (i, item) {
                    if (item.type == "string" || item.type == "json" || item.type == "javascript" || !item.type)
                        simpleMembers.push(item);
                    else if (item.type == "object" || item.type == "array" || item.mode == "column") {
                        complexMembers.push(item);
                    }
                });
            } else { //查找属性
                for (var name in config) {
                    var item = config[name];
                    item.name = name;
                    if (item.type == "string" || item.type == "json" || item.type == "javascript" || !item.type)
                        simpleMembers.push(item);
                    else if (item.type == "object" || item.mode == "array" || item.mode == "column") {
                        complexMembers.push(item);
                    }
                }
            }
            table_content_el.empty();
            $.each(simpleMembers, function (i, item) {
                var fieldName = item.name, value = item.defaultValue || "";
                $(['<tr><td>', item.name, '</td><td><input type="text" class="input-medium" name="', fieldName, '" dataIndex="', fieldName, '" value="', value, '" /></td><td><span class="default">', value, '</span></td></tr>'].join('')).appendTo(table_content_el);
            });

            $(context.items, function (i, item) {
                item && item.destroy();
            });
            context.items = [];

            if (complexMembers.length) {
                $.each(complexMembers, function (i, item) {

                    var cmp = new _KM.Android.Controls.FieldSetControl({ renderTo: children_el });
                    context.items.push(cmp);
                    cmp.render();
                    cmp.setConfig(item, item.name);
                });
            }
        } else if (mode == "column" || (type == "array" && config.memberType == "string")) {

            //重建 列头 item 清除内容
            var headTr = table_el.find("thead tr").empty();
            table_content_el.empty();

            var fields = mode == "column" ? config.fields : [{ name: "value" }];

            var ar = [];
            $.each(fields, function (i, item) {
                ar.push('<td>', item.name, '</td>');
            });
            ar.push('<td><input type="button" class="btn add" value="添加" /></td>');

            headTr.html(ar.join('')).find(':button').click(function () {
                context.addTableRowByColumnMode(fields, table_content_el);
            });
        }
    },
    getConfig: function () {
        return this.configItem;
    },
    builderEl: function () {
        var tpl = [
'<fieldset>',
'<legend class="ctl-data-group-head"></legend>',
'<div class="ctl-data-group-body">',
'<table>',
   '<thead>',
       '<tr>',
           '<th>名称</th>',
           '<th>值</th>',
           '<th>缺省</th>',
       '</tr>',
   '</thead>',
   '<tbody></tbody>',
'</table>',
'</div>',
'<div class="ctl-data-group-children"></div>',
'<div class="ctl-data-group-controls"></div>',
'</fieldset>'].join("");
        return tpl;
    },
    render: function (args) {
        _KM.Android.Controls.FieldSetControl.superclass.render.call(this, args);
        var context = this;
        var el = context.el = this.jel,
            head_el = context.head_el = el.find(".ctl-data-group-head"),
            body_el = context.body_el = el.find(".ctl-data-group-body"),
            children_el = context.children_el = el.find(".ctl-data-group-children"),
            table_el = this.table_el = body_el.find("table"),
            table_content_el = this.table_content_el = table_el.find("tbody"),
            controls_el = this.controls_el = this.jel.find('.ctl-data-group-controls');
        this.configItem && this.setConfig(this.configItem);
        //_KM.Android.Configs_KM.Android.Configs
    },
    items: [],
    controls: []
});


