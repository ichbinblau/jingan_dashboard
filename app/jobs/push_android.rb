$:.unshift File.dirname(__FILE__)+'/../lib'
require 'rubygems'
require 'mqtt'
require 'json'
class PushAndroid
  @queue = "pushandroid"


  def self.perform(args)
    custom = {}
    custom = args["custom"] unless args["custom"].blank?
    custom[:contentid] = args["contentid"] unless args["contentid"].blank?
    custom[:content] = args["des"] unless args["contentid"].blank?
  	pushData = {
      "device_token" => args["token"],
      "title" => args["title"],
      "badge" => 1,
      "custom"  => custom,
      "sound" => "siren.aiff",
      "siren.aiff" => Time.now + 60*60
  	}.to_json

  	MQTT::Client.connect('android.push.nowapp.cn',1884) do |client|
        client.publish("androidPush",pushData)
    end
  end
end
