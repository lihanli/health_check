require './sites'
require 'gmail'
require './gmail_credentials'
require 'active_support/all'
require 'httparty'

TIME_BETWEEN_CHECKS = 900
TIMEOUT = 30

while true
  puts Time.now.in_time_zone('Eastern Time (US & Canada)').strftime('%l:%M%p %b %e, %Y').strip

  SITES.each do |site|
    begin
      code = HTTParty.get(site, timeout: TIMEOUT).code.to_i
      raise Net::HTTPBadResponse if code >= 400
      puts "#{site} up"
    rescue Exception => e
      Gmail.new(GMAIL[:username], GMAIL[:password]) do |gmail|
        gmail.deliver do
          to GMAIL[:notifications_addr]
          subject "#{site} down"
          body    "#{e.class}: #{e.to_s}"
        end
      end
    end
  end
  puts "=================\n"
  sleep TIME_BETWEEN_CHECKS
end


