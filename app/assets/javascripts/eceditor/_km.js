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
                var exp = /(\b(https?|ft):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
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
    removeClass: function (value) {

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

_KM.Android.Configs = PageSetConfig;

/* 传入是一个对象
1.遍历属性 
    a . type in [ string json] 放入简单属性里面  (键值对)
    b . type in table 属性 table 列表中          (对象数组 列表)
    c . type in object 对其 fields 遍历
2.
*/
/*传入是一个数组

*/


_KM.Android.Controls.TabControl = Ext.extend(_KM.Controls.uiComponent, {
    cls: "tabbable tabs-right",
    dataKey: "tab_data",
    tabBody: true, //使用自己的容器进行管理
    tabBarCls: "nav nav-tabs",
    tabActivateCls: "active",
    tabPanelCls: "tab-pane",
    tabItemElHtml: "<li>",
    tabContentCls: "tab-content",
    initComponent: function () {
        var config = this.initialConfig;
        _KM.Android.Controls.TabControl.superclass.initComponent.call(this);
        this.addEvents("add", "beforeAdd", "remove", "activate", "moveTo");
    },
    setTabText: function (value, control) {
        var tabs = this.getTabs();
        var index = this.items.indexOf(control);
        tabs.eq(index).find('a').text(value);
    },
    getItems: function () {
        var items = this.tabBody ? this.items : this.controls;
        return items;
    },
    add: function (o) { // o={name:"",control:"};
        o = o || {};

        var context = this,
            tabEls = this.tabEls,
            items = this.getItems();

        if (context.fireEvent("beforeAdd", context, o) === false) return false;

        items.push(o.control);
        if (context.tabBody) { //是否使用自己的body 进行管理
            o.control.render(context.tabBodyEls);
            o.control.addClass(context.tabPanelCls);
            o.control.addClass(context.tabActivateCls);
            o.control.parent = context;
            //tab-pane
        }
        context.getTabs().removeClass("ac");
        var currentTab = context.currentTab =
            $(context.tabItemElHtml)
                .addClass(context.tabActivateCls)
                .append($('<a href="javascript:;"></a>').text(o.title || 'NULL'))
                .appendTo(tabEls).data(context.dataKey, o)
                .click(function () {
                    context.setActivate($(this));
                });
        context.setActivate(currentTab);

        context.fireEvent("add", context, o, { tab: currentTab });

        return currentTab;
    },
    setActivateIndex: function (index) {
        var context = this,
            tabEls = this.tabEls;

        var tabs = context.getTabs();
        var tab = tabs.eq(index);
        context.setActivate(tab);
    },
    setActivate: function (tab) {
        var context = this,
            tabEls = this.tabEls;;

        context.currentTab = null;
        if (tab.length) {
            this.currentTab = tab;
            tab.addClass(context.tabActivateCls).siblings().removeClass(context.tabActivateCls);

            var o = tab.data(context.dataKey);
            o.control && o.control.show();
            var items = context.getItems();

            for (var i = 0; i < items.length; i++) {
                if (items[i] != o.control) {

                    items[i].removeClass(context.tabActivateCls);
                    items[i].hide();
                }
            }
        }
    },
    remove: function (tab) {
        var context = this;
        tab = tab || this.currentTab;
        var o = tab.data(context.dataKey);
        this.removeControl(o.control);
        tab.remove();
        if (this.tabBody) {
            o.control.destroy();
        }
        this.setActivateIndex(0);
        this.fireEvent("remove", this, { tab: tab, data: o, control: o.control });
        return tab;
    },
    removeControl: function (c) {
        this.getItems().remove(c);
        
        c.parent = null;
    },
    moveTo: function (tab, index) {
        var context = this,
            tabEls = this.tabEls,
            items = context.getItems();

        if (items.length <= 1) return;
        var o = tab.data(context.dataKey);
        var cmp = o.control;

        items.remove(cmp);
        tab.detach();

        var tabs = context.getTabs();

        if (index < 0) index = tabs.length;
        else if (index > tabs.length) index = 0;

        if (index) {
            tabs.eq(index - 1).after(tab);
        } else
            tabs.eq(index).before(tab);

        items.insertAt(index, cmp);

        context.fireEvent("moveTo", context);//还未设置参数

        this.setActivate(tab);
    },
    moveToNext: function (tab) {
        tab = tab || this.currentTab;
        var index = tab.index();
        this.moveTo(tab, index + 1);
    },
    moveToPrev: function (tab) {
        tab = tab || this.currentTab;
        var index = tab.index();
        this.moveTo(tab, index - 1);
    },
    clear: function () {
        var items = this.getItems(), context = this;

        if (context.tabBody) {
            for (var i = 0; i < items.length; i++)
                items[i].destroy();
        }
        context.getTabs().remove();
        context.currentTab = null;
        items.clear();
    },
    builderEl: function () {
        var tpl = [
            '<div class="tabs-panel">',
               '<ul class="tabs ', this.tabBarCls || '', '"></ul>',
               '<div class="tabs-body ', this.tabContentCls || '', '"></div>',
            '</div>'].join("");
        return tpl;
    },
    globalIndex: 0,
    getTabs: function () {
        return this.tabEls.children();
    },
    render: function (args) {
        _KM.Android.Controls.TabControl.superclass.render.call(this, args);
        var context = this;
        this.tabEls = this.jel.find('.tabs');
        var tabOptEls = this.tabOptEls = this.jel.find('.tabs-opt');
        if (this.tabBody) {
            this.tabBodyEls = this.jel.find('.tabs-body');
        }

    },
    controls: []

});



_KM.Android.Controls.FieldSetControl = Ext.extend(_KM.Controls.uiComponent, {

    initComponent: function () {
        var config = this.initialConfig;
        _KM.Android.Controls.FieldSetControl.superclass.initComponent.call(this);
        this.addEvents("inputValueChange");
    },
    inputDataConfigKey: "fieldSet-config-Item",
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
            simpleMembers = context.simpleMembers;

        if (type == "array") {

            table_content_el && table_content_el.empty();

            var
                member = config.member || {},
                memberType = member.type,
                mode = config.mode || member.mode,
                isStringArray = memberType == "string";

            if (isStringArray || mode == "column") {
                var fields = isStringArray ? [{ name: "value", cls: member.cls  }] : (config.fields ? config.fields : member.fields);

                if (value && $.isArray(value)) {
                    $.each(value, function (i, item) {
                        var tr = context.addTableRowByColumnMode(fields, table_content_el);
                        tr.find("[dataindex]").each(function () {
                            var ctx = $(this), v = isStringArray ? item : item[ctx.attr('dataindex')];
                            if ($.type(v) != "string")
                                v = Ext.encode(v);
                            ctx.val(v);
                        });
                    });
                }
            } else {
                $.each(context.items, function (i, item) {
                    item.destroy();
                });
                var tabControl = context.tabControl;
                tabControl.clear();
                context.items.clear();

                $.each(value, function (i, item) {
                    var cmp = context.addCloneItem();
                    cmp.setValue(item);
                });
            }

        } else if (type == "object" || !type) {
            var textEls = table_content_el.find(':text,select,textarea');
            $.each(simpleMembers, function () {
                var f = this,
                    v = value[f.name],
                    el = textEls.filter('[dataindex=' + f.name + ']');

                if (f.type == "json") {
                    if (v && $.type(v) !="string") {
                        v = Ext.encode(v);
                    }
                    
                }
                el.val(v);
                context.fireEvent("inputValueChange", context, { el: el[0], configItem: f });
            });

            $.each(this.items, function (i, item) {
                var childConfigItem = complexMembers[i], childeValue = value[childConfigItem.name];
                childeValue && item.setValue(childeValue);
            });
        }
    },
    getFieldsObject: function (fields, ctl) {
        var o = {}, textEls = $(ctl).find(":text,select,textarea");
        $.each(fields, function () {
            var f = this;
            if (f.type != "object" && f.type != "array") {
                var v = $.trim(textEls.filter('[dataindex=' + f.name + ']').val());
                o[f.name] = v;
                if (f.type == "json" && v.length) {
                    try {
                        o[f.name] = Ext.decode(v);
                    } catch(e) {
                        o[f.name] = v;
                    } 
                    
                }
            }
        });
        return o;
    },
    getTableEls: function() {
        return this.table_content_el? this.table_content_el.find(':text,select,textarea'): null;
    },
    getValue: function () {
        var context = this,
           head_el = context.head_el,
           table_content_el = context.table_content_el,
           children_el = context.children_el,
           table_el = context.table_el,
           controls_el = context.controls_el,
           config = context.configItem;

        var configType = $.type(config);
        var type = config.type;

        var complexMembers = context.complexMembers,
            simpleMembers = context.simpleMembers,
            result = null;

        var mode = config.mode;

        if (type == "array") {
            var isStringArray;;
            result = [];

            if (config.member) {
                isStringArray = config.member.type == "string";
                if (!mode) mode = config.member.mode;
            }

            if (isStringArray) {
                table_content_el.find(':text,textarea').each(function () {
                    result.push($(this).val());
                });
            } else if (mode == "column") {
                table_content_el.find('tr').each(function () {
                    result.push(context.getFieldsObject(config.fields || config.member.fields, this));
                });
            } else {
                var items = this.items;

                if (context.tabControl) {
                    items = context.tabControl.getItems();
                }
                $.each(items, function (i, item) {
                    result.push(item.getValue());
                });

            }

        } else if (type == "object" || !type) {
            result = context.getFieldsObject(simpleMembers, table_content_el);
            $.each(this.items, function (i, item) {
                var childConfigItem = complexMembers[i], childType = childConfigItem.type;
                result[childConfigItem.name] = item.getValue();
            });
        }
        return result;
    },
    //添加动态行 列模式 configFields
    addTableRowByColumnMode: function (fields, toEl) {
        var ar = [
        '<tr class="info">',
            '<td><a class="btn button delete btn-mini" href="javascript:;">删除</a> </td>',
        '</tr>'];
        var tr = $(ar.join('')).appendTo(toEl);


        for (var i = 0; i < fields.length; i++) {
            var field = fields[i];
            var fieldName = field.name,
                value = field.defaultValue || "",
                valueType = $.type(value),
                cls = field.cls || "";

            if (valueType == "object" || valueType == "array") {
                value = Ext.encode(value);
            }
            // debugger;
            $(['<td><textarea class="text ', cls, '" dataindex="', fieldName, '" name="', fieldName, '">', value, '</textarea></td>'].join(''))
                .appendTo(tr).data(this.inputDataConfigKey, { field: field, control: this });
            // $(['<td><textarea  class="', cls, '" dataindex="', fieldName, '" name="', fieldName, '" >',value,'</textarea></td>'].join(''))
            //     .appendTo(tr).data(this.inputDataConfigKey, { field: field, control: this });

        }

        tr.find('.delete').click(function () {
            $(this).closest('tr').remove();
        });
        return tr;
    },
    addCloneItem: function () {
        var context = this,
         tabControl = context.tabControl;
        var item = Ext.apply({}, context.configItem.member);
        //delete item.mode;

        //tab 添加元素
        var cmp = new _KM.Android.Controls.FieldSetControl();
        tabControl.add({ title: item.name || ("new_tab_" + (tabControl.globalIndex++)), control: cmp });

        context.items.push(cmp);
        cmp.setConfig(item, item.name);

        cmp.on("inputValueChange", function (me, e) {
            var el = $(e.el), sourceConfigName = e.configItem.name;
            //control_id
            if (sourceConfigName == "name" || sourceConfigName == "control_id")
                tabControl.setTabText(el.val(), cmp);
        });

        return cmp;
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

        context.Key && head_el.text(key);
        var configType = $.type(config);

        var type = config.type,
            mode = config.mode;

        if (type == "array") {
            var member = config.member || {},
                memberType = member.type;
            // debugger;

            if (mode == "column" || member.mode == "column" || memberType == "string") {

                var headTr = table_el.find("thead tr").empty();
                table_content_el.empty();

                var fields = mode == "column" ? config.fields : (member.mode == "column" ? member.fields : [{ name: "value", cls: member.cls }]);
                // debugger;
                console.log(fields)
                var ar = [];
                ar.push('<th><a href="javascript:;" class="btn button add btn-mini">添加</a></th>');
                $.each(fields, function (i, item) {
                    ar.push('<th>', item.name, '</th>');
                });


                headTr.html(ar.join('')).find('.add').click(function () {
                    context.addTableRowByColumnMode(fields, table_content_el);
                });
            } else {

                /*步骤 
                1.把自己作为一个容器
                2.复制节点副本 并修改 membe.mode 为 delete 表明 可以删除
                在设置值的时候判断自己如果是 克隆型，那么 value为数组  按照长度创建结构 并设置值，所以要独立方法
                */
                if (context.table_el) {
                    context.table_el.remove();
                    delete context.table_content_el;
                    delete context.table_el;
                }
                context.body_el.empty();

                var tabOptEls = $(['<div class="tabs-opt">',
                    '<a href="javascript:;" class="btn button btn-mini add btn-primary">添加</a>',
                    '<a href="javascript:;" class="btn button btn-mini prev">←</a>',
                    '<a href="javascript:;" class="btn button btn-mini next">→</a>',
                    '<a href="javascript:;" class="btn button btn-mini delete btn-danger">移除</a>',
                    '</div>'].join('')).appendTo(context.body_el);


                var tabControl = context.tabControl = new _KM.Android.Controls.TabControl();
                tabControl.parent = context;
                tabControl.render(context.body_el);
                var linkes = tabOptEls.find("a");
                linkes.filter('.add').click(function () {

                    context.addCloneItem();
                });
                linkes.filter('.delete').click(function () {
                    tabControl.remove();
                });
                linkes.filter('.prev').click(function () {
                    tabControl.moveToPrev();
                });
                linkes.filter('.next').click(function () {
                    tabControl.moveToNext();
                });
            }

        }
        else if (type == "object" || !type) {
            var complexMembers = context.complexMembers = [],
                simpleMembers = context.simpleMembers = [],
                fields = configType == "array" ? config : config.fields;

            if (fields) {
                $.each(fields, function (i, item) {
                    if (item.type == "string" || item.type == "json"|| item.type == "text" || !item.type)
                        simpleMembers.push(item);
                    else if (item.type == "object" || item.type == "array") {
                        complexMembers.push(item);
                    }
                });
            } else { //查找属性
                for (var name in config) {
                    var item = config[name];
                    item.name = name;
                    if (item.type == "string" || item.type == "json"|| item.type == "text" || !item.type)
                        simpleMembers.push(item);
                    else if (item.type == "object" || item.mode == "array") {
                        complexMembers.push(item);
                    }
                }
            }
            table_content_el.empty();
            $.each(simpleMembers, function (i, item) {
                var fieldName = item.name, value = item.defaultValue || "", valueType = $.type(value), cls = item.cls || "";
                if (valueType == "object" || valueType == "array") {
                    value = Ext.encode(value);
                }
                var textEls = $(['<tr class="info"><td>'
                    , item.name,
                        '</td><td>',
                    (item.type == 'json'|| item.type == "text") ? '<textarea' : '<textarea autocomplete="off" type="text"', ' class="text ', cls, '" name="', fieldName, '" dataindex="', fieldName, '"', (item.type == 'json' || item.type == "text") ? '></textarea></textarea>' : '/>',
                        '</td><td><span class="default">', value, '</span></td></tr>'].join(''))
                        .appendTo(table_content_el)
                        .find(':text,textarea,select')
                        .val(value)
                        .data(context.inputDataConfigKey, { field: item, control: context })
                        .on('change', function () {
                            context.fireEvent("inputValueChange", context, { el: this, configItem: item });
                        });

            });

            $(context.items, function (i, item) {
                item && item.destroy();
            });
            context.items.clear();

            if (complexMembers.length) {
                $.each(complexMembers, function (i, item) {

                    var cmp = new _KM.Android.Controls.FieldSetControl({ renderTo: children_el });
                    cmp.parent = context;
                    cmp.render();
                    cmp.setConfig(item, item.name);
                    context.items.push(cmp);
                });
            }
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
'<table class="table table-bordered table-striped table-hover table-condensed">',
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
            table_el = this.table_el = body_el.find("table"),
            children_el = context.children_el = el.find(".ctl-data-group-children"),
            table_content_el = this.table_content_el = table_el.find("tbody"),
            controls_el = this.controls_el = this.jel.find('.ctl-data-group-controls');
        this.configItem && this.setConfig(this.configItem);

        context.head_el.click(function () {
            context.head_el.siblings().toggle();
        });



        context.on("beforedestroy", function () {
            context.configItem && delete context.configItem;
            context.key && delete context.key;
            context.tabControl && context.tabControl.destroy() && delete context.tabControl;

            context.parent && delete context.parent;

        });

    },
    controls: []
});


