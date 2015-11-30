require 'open-uri'
class PushBaidu
  @queue = "push_baidu"
  def self.perform(args)
	http_method = "POST"

	#查询配置
	# projectinfo = ProjectInfo.find user_entity.project_info_id
	# project_config = JSON.parse projectinfo.app_config
	begin
		url = "#{ args["os_type"] == 'iosdebug' ? 'https://channel.iospush' : 'http://channel'}.api.duapp.com/rest/2.0/channel/channel"
		api_key = args["api_key"]
		secret_key = args["secret_key"]
		user_id = args["user_id"]
		title = args["message"]
		custom_content = args["custom_content"]
		if "android" == args["os_type"]
		    device_type = "3"
		    message_type = "0"
		    messages = {
		        "title" => "",
		        "description" => title,
		        "custom_content" => custom_content
		    }
		else
		    device_type = "4"
		    message_type = "1"
		    custom_content["aps"] = {
		        "alert" => title
		    }
		    messages = custom_content
		end
		#    "channel_id" => "4672915356141432330"
		#    "user_id" => "1079566959864305774"
		#    "user_id" => "744983611566582972"
		#    "channel_id" => "3549718969592970829"
		#    "user_id" => "849523724463485631"

		para = {
		    "method" => "push_msg",
		    "apikey" => api_key,
		    "timestamp" => Time.now.to_time.to_i.to_s ,
		    "expires" =>  (Time.now.to_time.to_i + 900).to_s ,
		    "v" => "1",
		    "device_type" => device_type,
		    "push_type" => "1",
		    "user_id" => user_id,
		    "message_type" =>  message_type,
		#    "messages" =>"{\"title\":\"\",\"description\":\"测试推送#{Time.now.to_s}\"}",
		    "messages" => messages.to_json,
		    "msg_keys" => Digest::MD5.hexdigest(Time.now.to_time.to_i.to_s)
		}
		para.sort
		#MD5(urlencode($http_method$url$k1=$v1$k2=$v2$k3=$v3$secret_key));
		str = "#{http_method}#{url}#{para.sort.map{|k,v| k+'='+v }.join("")}#{secret_key}"
		encode_str = CGI::escape "#{http_method}#{url}#{para.sort.map{|k,v| k+'='+v }.join("")}#{secret_key}" 
		md5 = Digest::MD5.hexdigest encode_str
		para["sign"] = md5

		result = ""
		uri = URI.parse(url)
		if "iosdebug" == args["os_type"]
		    http = Net::HTTP.new(uri.host, 443)
		    http.use_ssl = true
		    path = uri.path
		    headers = {'Content-Type'=> 'application/x-www-form-urlencoded'}
		    resp, data = http.post(path, para.to_query, headers)
		    result = resp.body
		    #    obj = {}
		    #    resp.each {|key, val| obj[key] = val }
		    #puts 'Code = ' + resp.code
		    #puts 'Message = ' + resp.message
		    #resp.each {|key, val| puts key + ' = ' + val}
		    #puts data
		else
		    Net::HTTP.start(uri.host, uri.port) do |http|
		      req = Net::HTTP::Post.new(uri.path)
		      req.set_form_data(para)
		      result =  http.request(req).body
		    end
		end
	rescue Exception => e
		Rails.logger.info "error : #{e.message}"
		Rails.logger.info "backtrace : #{e.backtrace}"

	end
	# Rails.logger.info "push result:" + { :params => para , :result =>result }.to_s



	# pusher = Grocer.pusher(
	#   # certificate: "doc/certificate.pem",    # required
	#   certificate: args["pem"],      	 # required
	#   passphrase:  "",                       # optional
	#   gateway:     "gateway.sandbox.push.apple.com", # optional; See note below.
	#   port:        2195,                     # optional
	#   retries:     3                         # optional
	# )
	# notification = Grocer::Notification.new(
	#   # device_token: "9dd9c03b43215dd0d2be2d2a2296d57ed94e79bc526d8560336017d003027c4b",
	#   device_token: args["token"],
	#   alert:        args["title"],
	#   badge:        1,
	#   custom: {
	#     "contentid" => args["contentid"],
	#     "content" => args["des"],
	#   },
	#   sound:        "siren.aiff",         # optional
	#   expiry:       Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
	#   # identifier:   args[:des]         # optional
	# )
	# pusher.push(notification)
    # puts "Doing something complex with #{args}"
  end
end
