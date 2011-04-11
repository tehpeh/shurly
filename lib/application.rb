module Shurly

  module Application

  protected

    # Set enviroment variable WHITELIST_IP as comma delimited list of IP addresses
    def protected_by_ip
      unless ENV['WHITELIST_IP'].nil?
        redirect '/' unless ENV['WHITELIST_IP'].split(',').include?(request.env['HTTP_X_REAL_IP'])
      end
    end
  end
end