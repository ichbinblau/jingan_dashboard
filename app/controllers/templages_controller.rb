# encoding: utf-8
class TemplagesController < ApplicationController
  def testweixin
    # require "resque"
    # args = {
    #   :os_type => "iosdebug",
    #   :api_key => "vaqpcw8PhG3BdtwjdjRlNptW",
    #   :secret_key => "EwVTLxxsN3LI5sCIsaorHbu7FPTV1zb2",
    #   # :user_id => "1079566959864305774",
    #   :user_id => "1070387908688397896",
    #   :message => "testmessage",
    #   :custom_content => {
    #     :key1 => "value1",
    #     :key2 => "value2",
    #   }
    # }
    # Resque.enqueue(PushBaidu, args)

    # return render json: args
    $client ||= WeixinAuthorize::Client.new("wxeb8dc9e99d523ca1", "fdb2c2eceb0580572213fcd1479745b5")
    $client.is_valid?
    domain = "www.ecloudiot.com"
    menu = {
    "button"=>[
    {
     "type"=>"view",
     "name"=>"考前需知",
     "url"=>"http://#{domain}/866386381/yixue/news"
    },
    {
     "type"=>"view",
     "name"=>"考核学习",
     "url"=>"http://#{domain}/866386381/yixue/subject"
    },
    {
     "name"=>"考核题库",
     "sub_button"=>[
     {  
         "type"=>"click",
         "name"=>"考前题库",
         "key"=>"866386381|CLICK_TS1"
      },
      {
         "type"=>"click",
         "name"=>"冲刺题库",
         "key"=>"866386381|CLICK_TS2"
      },
      {
         "type"=>"click",
         "name"=>"补考题库",
         "key"=>"866386381|CLICK_TS3"
      }]
    }]
    }
    # render json: $client.create_menu(menu)

  end
  def test_sortble

  end
  # GET /templages
  # GET /templages.json
  def importdata
    # 需要去除空格，类字样

    # shops = ShopContent.where( :order_level => 158 ,:project_info_id => 149)
    # shops.each do |shop|
    #   shop.delete
    # end
    # return

    #{"title":"店名","order_level":"客户等级","years":"店龄","sort_ids":"主营产品","address":"地址","admin_name":"服务人员","c_role":"职位","cus_des":"客户群描述","c_mobile":"智能机使用","new_cus_from":"新客户来源","old_cus_service":"老客户服务","unique_des":"独特性描述","coupon_des":"传统优惠方式","method_improving":"提高业绩方法","des":"备注","server_num":"在店服务员人数","top_of_day":"每日服务高峰","trade_des":"营业/交易状况"}

    string = ""
    IO.foreach("tmp/data/data.json"){|line| string = string + line};
    json = JSON.parse string
    fields = JSON.parse '{"image_cover":"图片","title":"学校名称","sort_1":"所在地","sort_2":"性质","sort_3":"类型","join":"参与","belonged_to":"学校隶属","address":"地址","phone_num":"电话","website":"学校网址","special_enroll":"特殊招生","zdxk_num":"国家重点学科","ys_num":"院士","bsd_num":"博士点","ssd_num":"硕士点","bsh_num":"博士后流动站","introduction":"院校介绍","abstract":"学校简介","yuanxi":"院系设置","zhuanye":"专业介绍","jangxuejin":"奖学金设置","shisu":"食宿条件","jichusheshi":"基础设施","lianxifangfa":"联系办法","zhaoshengjianzhang":"招生简章","zhaoshengzhangcheng":"招生章程","yishuleizhaosheng":"艺术类招生","wangnianluqu":"往年录取信息","luquguize":"录取规则","tijian":"体检要求","shoufei":"收费项目","biyesheng":"毕业生就业"}'
    sorts_1= JSON.parse '{"1491":"全国范围","1492":"北京市","1493":"天津市","1494":"上海市","1495":"重庆市","1505":"河北省","1506":"山西省","1507":"内蒙古","1508":"辽宁省","1509":"吉林省","1510":"黑龙江省","1511":"江苏省","1512":"浙江省","1513":"安徽省","1514":"福建省","1515":"江西省","1516":"山东省","1517":"河南省","1518":"湖北省","1519":"湖南省","1520":"广东省","1521":"广西省","1522":"海南省","1524":"四川省","1525":"贵州省","1526":"云南省","1527":"陕西省","1528":"甘肃省","1529":"青海省","1530":"宁夏","1531":"新疆","1532":"香港","1533":"澳门","1534":"台湾省"}'
    sorts_1_filter = JSON.parse '{"全国范围":1491,"北京市":1492,"天津市":1493,"上海市":1494,"重庆市":1495,"河北省":1505,"山西省":1506,"内蒙古":1507,"辽宁省":1508,"吉林省":1509,"黑龙江省":1510,"江苏省":1511,"浙江省":1512,"安徽省":1513,"福建省":1514,"江西省":1515,"山东省":1516,"河南省":1517,"湖北省":1518,"湖南省":1519,"广东省":1520,"广西省":1521,"海南省":1522,"云南省":1526,"四川省":1524,"贵州省":1525,"陕西省":1527,"甘肃省":1528,"青海省":1529,"宁夏":1530,"新疆":1531,"香港":1532,"澳门":1533,"台湾省":1534}'
    # sorts_2 = JSON.parse '{"1484":"全部性质","1485":"财经","1488":"工科","1535":"交通","1536":"军事","1538":"理工","1539":"林业","1540":"旅游","1541":"民族","1542":"农业","1543":"师范","1544":"体育","1545":"外语","1546":"研究","1547":"医科","1548":"医学","1549":"医药","1573":"艺术","1574":"语言","1575":"政法","1576":"综合"}'
    # sorts_2_filter = JSON.parse '{"全部性质":"1484","财经":"1485","工科":"1488","交通":"1535","军事":"1536","理工":"1538","林业":"1539","旅游":"1540","民族":"1541","农业":"1542","师范":"1543","体育":"1544","外语":"1545","研究":"1546","医科":"1547","医学":"1548","医药":"1549","语言":"1574","艺术":"1573","政法":"1575","综合":"1576"}'
    sorts_2 = JSON.parse '{"1484": "全部性质","1485": "财经","1488": "工科","1535": "交通","1536": "军事","1538": "理工","1539": "林业","1540": "旅游","1542": "农业","1543": "师范","1544": "体育","1546": "研究","1549": "医药","1573": "艺术","1574": "语言","1575": "政法","1576": "综合","1608": "农林","1609": "经贸","1610": "党政","1611": "公安"}'
    sorts_2_filter = JSON.parse '{"全部性质":"1484","财经":"1485","工科":"1488","交通":"1535","军事":"1536","理工":"1538","林业":"1539","旅游":"1540","公安":"1611","农业":"1542","师范":"1543","体育":"1544","党政":"1610","研究":"1546","经贸":"1609","农林":"1608","医药":"1549","语言":"1574","艺术":"1573","政法":"1575","综合":"1576"}'
    # sorts_3 = JSON.parse '{"1486":"全部类型","1487":"独立学院","1489":"高等军事院校","1550":"高等职业技术学院","1551":"公办本科院校","1552":"公立大学","1553":"民办本科院校","1554":"普通高职院校","1555":"企业办学","1556":"全国重点大学","1577":"事业法人单位","1579":"私立大学","1580":"艺术学院","1581":"中外机构","1582":"中央部属高校","1583":"重点大学"}'
    # sorts_3_filter = JSON.parse '{"全部类型":"1486","独立学院":"1487","高等军事院校":"1489","高等职业技术学院":"1550","公办本科院校":"1551","公立大学":"1552","民办本科院校":"1553","普通高职院校":"1554","企业办学":"1555","全国重点大学":"1556","事业法人单位":"1577","私立大学":"1578","艺术学院":"1580","中外机构":"1581","中央部属高校":"1582","重点大学":"1583"}'
    sorts_3 = JSON.parse '{"1486": "全部类型","1487": "普通本科","1489": "高职高专","1550": "中外合作办学","1551": "远程教育学院","1552": "独立学院","1553": "HND项目","1554": "其他"}'
    sorts_3_filter = JSON.parse '{"全部类型":"1486","普通本科":"1487","高职高专":"1489","中外合作办学":"1550","远程教育学院":"1551","独立学院":"1552","HND项目":"1553","其他":"1554"}'


    row = json[0]
    for k,v in row
        row[k] = v.strip
    end
    row["sort_tmp"] = row["sort_2"]
    row["sort_2"] = row["sort_1"]
    row["sort_1"] = row["sort_tmp"]
    render json: row
    return

    for row in json
      for k,v in row
          row[k] = v.strip
      end
      row["sort_tmp"] = row["sort_2"]
      row["sort_2"] = row["sort_1"]
      row["sort_1"] = row["sort_tmp"]
      if row["sort_1"].strip !="" || row["sort_2"].strip!="" || row["sort_3"].strip!=""
        sorts = [1484,1486,1491]
        sorts.push sorts_1_filter[row["sort_1"].strip] unless sorts_1_filter[row["sort_1"].strip].nil?
        key = row["sort_1"].strip + "市"
        sorts.push sorts_1_filter[key] unless sorts_1_filter[key].nil?
        key = row["sort_1"].strip + "省"
        sorts.push sorts_1_filter[key] unless sorts_1_filter[key].nil?
        sorts.push sorts_2_filter[row["sort_2"].strip] unless sorts_2_filter[row["sort_2"].strip].nil?
        if row["sort_2"] != ""
          if row["sort_2"].split( ";" ).size > 1
            row["sort_2"].split( ";" ).each do |item|
              sorts.push sorts_2_filter[item.strip] unless sorts_2_filter[item.strip].nil?
              Rails.logger.info " -- " + item.strip + " - " + row["sort_2"]
            end
          else
            sorts.push sorts_2_filter[row["sort_3"].strip] unless sorts_2_filter[row["sort_2"].strip].nil?
          end
        end
        sorts.push sorts_3_filter[row["sort_3"].strip] unless sorts_3_filter[row["sort_3"].strip].nil?

        n_row = {:title => row["title"] ,:abstract => row["join"] ,:content =>row.to_json , :cms_sort_ids => sorts , :project_info_id => 149,:order_level => 158}
        new_row = ShopContent.new n_row
        info = { :address => row["address"] ,:phone_num =>row["phone_num"]}
        new_row.cms_info_shop = CmsInfoShop.new info
        new_row.image_cover.upload_url = row["image_cover"]
        new_row.save
      end
    end

    render json: n_row
  end

  def importdianpu
    # 需要去除空格，类字样

    # shops = ShopContent.where( :project_info_id => 152)
    # shops.each do |shop|
    #   shop.delete
    # end
    # return

    #{"title":"店名","order_level":"客户等级","years":"店龄","sort_ids":"主营产品","address":"地址","admin_name":"服务人员","c_role":"职位","cus_des":"客户群描述","c_mobile":"智能机使用","new_cus_from":"新客户来源","old_cus_service":"老客户服务","unique_des":"独特性描述","coupon_des":"传统优惠方式","method_improving":"提高业绩方法","des":"备注","server_num":"在店服务员人数","top_of_day":"每日服务高峰","trade_des":"营业/交易状况"}

    string = ""
    IO.foreach("tmp/data/data_dianpu.json"){|line| string = string + line};
    json = JSON.parse string
    fields = JSON.parse '{"title":"店名","years":"店龄","sort_ids":"主营产品","order_level":"客户等级","address":"地址","admin_name":"服务人员","c_role":"职位","cus_des":"客户群描述","c_mobile":"智能机使用","new_cus_from":"新客户来源","old_cus_service":"老客户服务","unique_des":"独特性描述","coupon_des":"传统优惠方式","method_improving":"提高业绩方法","des":"备注","server_num":"在店服务员人数","top_of_day":"每日服务高峰","trade_des":"营业/交易状况"}'
    
    
    row = json[0]
    now_row = {}
    for k,v in row
      k = "years" if k == "order_level"
      k = "sort_ids" if k == "years"
      k = "order_level" if k == "sort_ids"
      now_row[k] = v.strip
    end
    render json: now_row
    return

    for row in json
      now_row = {}
      for k,v in row
        k = "years" if k == "order_level"
        k = "sort_ids" if k == "years"
        k = "order_level" if k == "sort_ids"
        now_row[k] = v.strip
      end
      sorts = [1602]
      n_row = {:title => now_row["title"] ,:abstract => now_row["des"] ,:content =>now_row.to_json , :cms_sort_ids => sorts , :project_info_id => 152}
      new_row = ShopContent.new n_row
      info = { :address => now_row["address"] ,:shop_num =>now_row["id"]}
      new_row.cms_info_shop = CmsInfoShop.new info
      new_row.save
    end

    render json: n_row
  end

  def index
    @templages = Templage.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @templages }
    end
  end

  # GET /templages/1
  # GET /templages/1.json
  def show
    @templage = Templage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @templage }
    end
  end

  # GET /templages/new
  # GET /templages/new.json
  def new
    @templage = Templage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @templage }
    end
  end

  # GET /templages/1/edit
  def edit
    @templage = Templage.find(params[:id])
  end

  # POST /templages
  # POST /templages.json
  def create
    @templage = Templage.new(params[:templage])

    respond_to do |format|
      if @templage.save
        format.html { redirect_to @templage, notice: 'Templage was successfully created.' }
        format.json { render json: @templage, status: :created, location: @templage }
      else
        format.html { render action: "new" }
        format.json { render json: @templage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /templages/1
  # PUT /templages/1.json
  def update
    @templage = Templage.find(params[:id])

    respond_to do |format|
      if @templage.update_attributes(params[:templage])
        format.html { redirect_to @templage, notice: 'Templage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @templage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templages/1
  # DELETE /templages/1.json
  def destroy
    @templage = Templage.find(params[:id])
    @templage.destroy

    respond_to do |format|
      format.html { redirect_to templages_url }
      format.json { head :no_content }
    end
  end
end
