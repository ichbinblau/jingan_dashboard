# encoding: utf-8
class KfzspageController < ApplicationController
	def main
		require 'open-uri'
		tpl_name = ""
		if browser.mobile?
			if browser.name.downcase == "android"
				tpl_name = "android_main.html.erb"
			elsif browser.name.downcase == "chrome"
				tpl_name = "android_main.html.erb"
			elsif browser.name.downcase == "iphone"
				tpl_name = "iphone_main.html.erb"
			end
		else
			tpl_name = "pc_main.html.erb"
		end

		app_infos = ProjectApp.where("id in (321,322)")

		@qrcode_url = "http://cs.hudongka.com/?level=L&size=10&border=5&data=#{Rack::Utils.escape(request.url)}"
		@android_url = app_infos[1].download_url
		@iphone_url = app_infos[0].download_url

		respond_to do |format|
	      format.html { render tpl_name }
	      format.json { render json: @kf_sort }
	    end

	end
end

