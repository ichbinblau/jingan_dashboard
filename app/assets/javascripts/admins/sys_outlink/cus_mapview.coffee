root = this;
config = {"years":"店龄","sort_ids":"主营产品","admin_name":"服务人员","c_role":"职位","cus_des":"客户群描述","c_mobile":"智能机使用","new_cus_from":"新客户来源","old_cus_service":"老客户服务","unique_des":"独特性描述","coupon_des":"传统优惠方式","method_improving":"提高业绩方法","des":"备注","server_num":"在店服务员人数","top_of_day":"每日服务高峰","trade_des":"营业/交易状况"}
cus_level = ["未拜访","A类","B类","C类","D类","E类","F类","G类","H类","I类"]
all_items = []
$(document).ready ->
    root.map = new BMap.Map("allmap");
    root.map.centerAndZoom(new BMap.Point(121.522725,31.303178), 16); # 放到到16级，数字越大，地图越大
    root.map.addControl(new BMap.NavigationControl());  # 添加默认缩放平移控件
    root.map.enableScrollWheelZoom(true);
    initShops();

initShops = ()->
    $.ajax 
        url: 'cus_mapview_shops'
        success: (data, success)  ->
            console.log data.father_sorts
            # console.log data.sorts
            all_items = data.shops
            all_sorts = data.father_sorts
            for v,k in data.father_sorts
                $("#sorts").append "<div onclick='addpoints([#{v.children.join(",")}])' id='sort_#{v.id}'>#{v.cnname}</div>"

            for v,k in data.shops
                addpoint v["baidu_latitude"], v["baidu_longitude"], v
            # 
@addpoints = (sorts) ->
    root.map.clearOverlays();
    for v,k in all_items
        if sorts?
            for vsv,vsk in v.sorts
                for sv,sk in sorts
                    if vsv == sv
                        addpoint v["baidu_latitude"], v["baidu_longitude"], v
        else
            addpoint v["baidu_latitude"], v["baidu_longitude"], v

addpoint = (lat, log, res ) ->
    pt = new BMap.Point(log, lat);
    if res.order_level == 0
        myIcon = new BMap.Icon("/assets/outlink_mapview/map_dot_grey.png", new BMap.Size(11, 11));
    else if res.order_level == 21 
        myIcon = new BMap.Icon("/assets/outlink_mapview/map_dot_blue.png", new BMap.Size(11, 11));
    else if res.order_level == 1 
        myIcon = new BMap.Icon("/assets/outlink_mapview/green_flash.gif", new BMap.Size(22, 26));
    else if res.order_level == 2 || res.order_level == 3
        myIcon = new BMap.Icon("/assets/outlink_mapview/map_dot_orange.png", new BMap.Size(11, 11));
    else if res.order_level > 3 
        myIcon = new BMap.Icon("/assets/outlink_mapview/map_dot_red.png", new BMap.Size(11, 11));
    else
        myIcon = new BMap.Icon("/assets/outlink_mapview/map_dot_green.png", new BMap.Size(11, 11));
    # console.log res.sorts
    content = "<div style='font-size:14px;width:500px;'>店名：#{res.title}</div><br />"
    content = content+"<div style='float:left;width:200px;'><div style='font-size:12px;'>客户等级：#{cus_level[res.order_level]}</div>"
    data = JSON.parse res.content
    marker1 = new BMap.Marker(pt, { icon: myIcon });
    root.map.addOverlay(marker1);
    for k,v of config
        content = content+"<div style='font-size:12px;'>#{v}：#{data[k]}</div>" if typeof data[k] != "undefined"
    content = content+"</div>"
    content = content+"<div style='float:left;'><a href='http://is.hudongka.com/#{res.image_cover.url}' target='_blakn'><img src='http://is.hudongka.com/#{res.image_cover.url.replace("\.","_0x220\.")}' height='220px;'/></a></div>" if res.image_cover.url?

    infoWindow1 = new BMap.InfoWindow(content);
    marker1.addEventListener "click", () -> 
        this.openInfoWindow infoWindow1 
