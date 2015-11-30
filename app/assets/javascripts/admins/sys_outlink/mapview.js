var myDate = new Date();
//获取当前时间
var dates = myDate.getFullYear() + "-" + (myDate.getMonth() + 1) + "-" + myDate.getDate()
var support = "MozWebSocket" in window ? 'MozWebSocket' : ("WebSocket" in window ? 'WebSocket' : null);
var host = "ws://websocket.nowapp.cn:13001/api/1.0/repair_map?pnum=816893519";
var socket=null;
var root = this;
function connectSocketServer() {
    try {
        socket = new window[support](host);
        socket.onopen = function (openEvent) {
            console.log('socket.onopen:' + new Date()); 
        };

        socket.onmessage = function (messageEvent) {
            console.log('socket.onmessage:' + new Date());
            if (messageEvent.data instanceof Blob) {
                var destinationCanvas = document.getElementById('destination');
                var destinationContext = destinationCanvas.getContext('2d');
                var image = new Image();
                image.onload = function () {
                    destinationContext.clearRect(0, 0,
                       destinationCanvas.width, destinationCanvas.height);
                    destinationContext.drawImage(image, 0, 0);
                }
                image.src = URL.createObjectURL(messageEvent.data);
            } else {
                // debugger
                var json = eval("(" + messageEvent.data + ")");
                var record = json["data"]["Success"];
                if (!record || !record.lat) return;

                var lat = (record["lat"]);
                var log = (record["log"]);
                var type = (record["type"]);
                var content = (record["content"]);
                if (type == "signin") {
                    var pt = new BMap.Point(log, lat);
                    var myIcon = new BMap.Icon("/assets/outlink_mapview/green_flash.gif", new BMap.Size(22, 26));
                    var marker2 = new BMap.Marker(pt, { icon: myIcon });  // 创建标注
                    root.map.addOverlay(marker2);
                    var infoWindow1 = new BMap.InfoWindow(content);
                    marker2.addEventListener("click", function () { this.openInfoWindow(infoWindow1); });
                    var i = new Number($("#Label2").text())
                    $("#Label2").text(i + 1);
                    setTimeout(function () { marker2.remove(); addpoint(lat, log, type, content); }, 7200000)
                } else if (type == "repair") {
                    var pt = new BMap.Point(log, lat);
                    var myIcon = new BMap.Icon("/assets/outlink_mapview/red_flash.gif", new BMap.Size(22, 26));
                    var marker2 = new BMap.Marker(pt, { icon: myIcon });  // 创建标注
                    root.map.addOverlay(marker2);
                    var infoWindow1 = new BMap.InfoWindow(content);
                    marker2.addEventListener("click", function () { this.openInfoWindow(infoWindow1); });
                    var i = new Number($("#Label4").text())
                    $("#Label4").text(i + 1);
                    setTimeout(function () { marker2.remove(); addpoint(lat, log, type, content); }, 7200000)
                }
            }
        };

        socket.onerror = function (errorEvent) {
            console.log('socket.onerror:' + new Date());
        };

        socket.onclose = function (closeEvent) {
            console.log('socket.onclose:' + new Date());
            setTimeout(function () {
                connectSocketServer();
            }, 5000);
        };
    }
    catch (exception) { if (window.console) console.log(exception); }
}

function sendTextMessage() {

    if (socket.readyState != WebSocket.OPEN) return;

    var e = document.getElementById("textmessage");
    socket.send(e.value);
}

function sendBinaryMessage() {
    if (socket.readyState != WebSocket.OPEN) return;

    var sourceCanvas = document.getElementById('source');

    socket.send(sourceCanvas.msToBlob());
}
function getlistinfo(type) {
    if (type == "signin") {
        window.open('signin.html?access_token=123&api_key=123y&type=' + type)
    } else {
        window.open('repair.html?access_token=123&api_key=123y&type=' + type)
    }
}

function callShops(){
    $.ajax({
        url: 'call',
        data: {
            "sonid": "490",
            "method": "getshopinfo/get",
            "version": "1.0",
            "page": "1",
            "perpage": "1000",
            "maptype": "baidu",
            "size": "5000000",
            "log": "121.4183934",
            "lat": "31.1560796",
        },
        success: function (data, ddd) {
            if (data["data"]["title"] != undefined) {
                var content = "<p style='font-size:14px;'>" + data["data"]["title"] + "</p><p style='font-size:12px;'>信息：" + data["data"]["content"] + "<br/>地址：" + data["data"]["address"] + "</p>";
                addpoint(data["data"]["baidu_latitude"], data["data"]["baidu_longitude"], "address", content);
            }else {
                for (var i = 0; i < data["data"].length; i++) {
                    var content = "<p style='font-size:14px;'>" + data["data"][i]["title"] + "</p><p style='font-size:12px;'>信息：" + data["data"][i]["content"] + "<br/>地址：" + data["data"][i]["address"] + "</p>";
                    addpoint(data["data"][i]["baidu_latitude"], data["data"][i]["baidu_longitude"], "address", content);
                }
            }
            callSignins();
        }
    });
}
function callSignins(){
    $.ajax({
        url: 'call',
        data: {
            "method": "signin/get",
            "version": "1.0",
            "nowtime": dates
        },
        success: function (data, ddd) {
            if (data["data"]["shoptitle"] != undefined) {
                var content = "<p style='font-size:14px;'>" + data["data"]["shoptitle"] + "（运动记录）</p><p style='font-size:12px;'>时间：" + data["data"]["content"] + "<br/>地址：" + data["data"]["shopaddress"] + "</p>";
                addpoint(data["data"]["shopbaidulat"], data["data"]["shopbaidulog"], "signin", content);
                // $("#Label2").text("1");
            }
            else {
                for (var i = 0; i < data["data"].length; i++) {
                    var content = "<p style='font-size:14px;'>" + data["data"][i]["shoptitle"] + "（运动记录）</p><p style='font-size:12px;'>时间：" + data["data"][i]["content"] + "<br/>地址：" + data["data"][i]["shopaddress"] + "</p>";
                    addpoint(data["data"][i]["shopbaidulat"], data["data"][i]["shopbaidulog"], "signin", content);
                }
                // $("#Label2").text(data["data"].length);
            }
            callRepairs();
        }
    });
}
function callRepairs(){
    $.ajax({
        url: 'call',
        data: {
            "method": "repair/get",
            "version": "1.0",
            "nowtime": dates
        },
        success: function (data, ddd) {
            if (data["data"]["shoptitle"] != undefined) {
                var content = "<p style='font-size:14px;'>" + data["data"]["shoptitle"] + "（报修）</p><p style='font-size:12px;'>设备：" + data["data"]["devicetitle"] + "<br/>地址：" + data["data"]["shopaddress"] + "</p>";
                addpoint(data["data"]["shopbaidulat"], data["data"]["shopbaidulog"], "repair", content);
                // $("#Label4").text("1");
            }
            else {
                for (var i = 0; i < data["data"].length; i++) {
                    var content = "<p style='font-size:14px;'>" + data["data"][i]["shoptitle"] + "（报修）</p><p style='font-size:12px;'>设备：" + data["data"][i]["devicetitle"] + "<br/>地址：" + data["data"][i]["shopaddress"] + "</p>";
                    addpoint(data["data"][i]["shopbaidulat"], data["data"][i]["shopbaidulog"], "repair", content);
                }
                // $("#Label4").text(data["data"].length);
            }

        }
    });
}
function addpoint(lat, log, type, content) {
    var pt = new BMap.Point(log, lat);
    if (type == "address") {
        var myIcon = new BMap.Icon("/assets/outlink_mapview/gray.png", new BMap.Size(11, 11));
        var marker1 = new BMap.Marker(pt, { icon: myIcon });  // 创建标注
        root.map.addOverlay(marker1);              // 将标注添加到地图中
        //创建信息窗口
        var infoWindow1 = new BMap.InfoWindow(content);
        marker1.addEventListener("click", function () { this.openInfoWindow(infoWindow1); });
    }else if (type == "signin") {
        var myIcon = new BMap.Icon("/assets/outlink_mapview/green.png", new BMap.Size(22, 26));
        var marker1 = new BMap.Marker(pt, { icon: myIcon });  // 创建标注
        root.map.addOverlay(marker1);              // 将标注添加到地图中
        //创建信息窗口
        var infoWindow1 = new BMap.InfoWindow(content);
        marker1.addEventListener("click", function () { this.openInfoWindow(infoWindow1); });
    }
    else if (type == "repair") {
        var myIcon = new BMap.Icon("/assets/outlink_mapview/red.png", new BMap.Size(22, 26));
        var marker1 = new BMap.Marker(pt, { icon: myIcon });  // 创建标注
        root.map.addOverlay(marker1);              // 将标注添加到地图中
        //创建信息窗口
        var infoWindow1 = new BMap.InfoWindow(content);
        marker1.addEventListener("click", function () { this.openInfoWindow(infoWindow1); });
    }
}

$(document).ready(function () {
    root.map = new BMap.Map("allmap");
    root.map.centerAndZoom(new BMap.Point(121.44290233245,31.174887798612), 15);//放到到16级，数字越大，地图越大
    root.map.addControl(new BMap.NavigationControl());  //添加默认缩放平移控件
    root.map.enableScrollWheelZoom(true);

    connectSocketServer();
    $(".tab").click(function () {
        var X = $(this).attr('id');

        if (X == 'signup') {
            $("#login").removeClass('select');
            $("#signup").addClass('select');
            $("#loginbox").slideUp();
            $("#signupbox").slideDown();
        }
        else {
            $("#signup").removeClass('select');
            $("#login").addClass('select');
            $("#signupbox").slideUp();
            $("#loginbox").slideDown();
        }

    });

    callShops();

});
