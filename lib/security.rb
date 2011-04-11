module Shurly

  module Security

  protected

    # Set enviroment variable WHITELIST_IP as comma delimited list of IP addresses
    # Pass your logger to have a message logged
    def protected_by_ip(logger = nil)
      unless ENV['WHITELIST_IP'].nil?
        unless ENV['WHITELIST_IP'].split(',').include?(request.env['HTTP_X_REAL_IP'])
          logger.warn "#{request.env['HTTP_X_REAL_IP']} attempted to access a secure area" unless logger.nil?
          redirect '/'
        end
      end
    end

  end
end