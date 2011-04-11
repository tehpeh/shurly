module Application
  module Logging

    protected

    def log(str)
      puts "#{Time.now} #{str}"
    end
    
  end
end