module Application
  module Logging

    protected

    def log(str)
      puts "#{Time.now} #{str}"
    end
  end

  module Security
    include Logging

    protected

    # Set enviroment variable WHITELIST_IP as comma delimited list of IP addresses
    def protected_by_ip
      unless ENV['WHITELIST_IP'].nil?
        unless request.env['HTTP_X_REAL_IP'].member_of? ENV['WHITELIST_IP'].split(',')
          log "#{request.env['HTTP_X_REAL_IP']} attempted to access a secure area"
          redirect '/'
        end
      end
    end
  end
end