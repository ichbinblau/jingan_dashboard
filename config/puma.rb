rails_env = ENV['RAILS_ENV'] || 'production'

if rails_env == "development"
	threads 1,8
	app_path="/Users/macuser/yunpan/_ruby/ruby_general_admin"
	bind "tcp://0.0.0.0:8081"
else
	threads 3,16
	app_path="/data/www/ruby_general_admin"
	bind "tcp://0.0.0.0:80"
	# bind "unix://"+app_path+"/tmp/puma/kfzs_web_admin.sock"
end

pidfile app_path+"/tmp/puma/pid"
state_path app_path+"/tmp/puma/state"
activate_control_app
