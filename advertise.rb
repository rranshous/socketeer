

require 'dnssd'

tr = DNSSD::TextRecord.new
tr["test"] = '1'
tr["success"] = '1'
DNSSD.register("Test Server", "_http._tcp,_testapp", nil, 8111, tr)
tr["test"] = '2'
tr["success"] = '2'
DNSSD.register("Test Server2", "_http._tcp,_testapp", nil, 8111, tr)

while true
  sleep(1)
end
