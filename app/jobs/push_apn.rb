class PushApn
  @queue = "demo"

  def self.perform(args)
	pusher = Grocer.pusher(
	  # certificate: "doc/certificate.pem",    # required
	  certificate: args["pem"],      	 # required
	  passphrase:  "",                       # optional
	  gateway:     "gateway.sandbox.push.apple.com", # optional; See note below.
	  port:        2195,                     # optional
	  retries:     3                         # optional
	)
	notification = Grocer::Notification.new(
	  # device_token: "9dd9c03b43215dd0d2be2d2a2296d57ed94e79bc526d8560336017d003027c4b",
	  device_token: args["token"],
	  alert:        args["title"],
	  badge:        1,
	  custom: {
	    "contentid" => args["contentid"],
	    "content" => args["des"],
	  },
	  sound:        "siren.aiff",         # optional
	  expiry:       Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
	  # identifier:   args[:des]         # optional
	)
	pusher.push(notification)
    # puts "Doing something complex with #{args}"
  end
end
