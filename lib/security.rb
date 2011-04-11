module Application
  module Security
    require File.expand_path(File.join(File.dirname(__FILE__), 'logging'))
    include Application::Logging
    
    protected

    # Set enviroment variable WHITELIST_IP as comma delimited list of IP addresses
    def protected_by_ip
      unless ENV['WHITELIST_IP'].nil?
        unless ENV['WHITELIST_IP'].split(',').include?(request.env['HTTP_X_REAL_IP'])
          log "#{request.env['HTTP_X_REAL_IP']} attempted to access a secure area"
          redirect '/'
        end
      end
    end
    
  end
end