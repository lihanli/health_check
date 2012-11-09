require 'rubygems'
require 'net/http'
require 'uri'
require './sites'
require 'gmail'
require './gmail_credentials'

TIME_BETWEEN_CHECKS = 900
TIMEOUT = 30

while true
  SITES.each do |site|
    begin
      uri = URI.parse(site)
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout, http.open_timeout = TIMEOUT, TIMEOUT
      code = http.request(Net::HTTP::Get.new(uri.request_uri)).code.to_i
      raise Net::HTTPBadResponse unless (code >= 200) && (code < 300)
      puts "#{site} up"
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::ETIMEDOUT,
           EOFError, SocketError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
           Net::HTTP::Persistent::Error, Net::ProtocolError => e

      Gmail.new(GMAIL[:username], GMAIL[:password]) do |gmail|
        gmail.deliver do
          to GMAIL[:notifications_addr]
          subject "#{site} down"
        end
      end
    end
  end
  sleep TIME_BETWEEN_CHECKS
end


