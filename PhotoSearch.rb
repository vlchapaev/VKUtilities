require 'net/http'
require 'json'

alboms = ["127112479", "131272355", "127112549", "131274305",
          "134539051", "139733464", "87348502", "149123135",
          "146106495", "153359626", "155357544", "156844663",
          "156805849", "158628191", "165252580", "169663584",
          "174560127", "180729117", "186889710", "195090983",
          "199636619", "201699197", "204485126", "206903353",
          "210130811", "211889734", "213957700", "216473097",
          "220579621", "14231802", "101560693"]

personID = "5449102"
groupID = "-331509"
photoList = Array.new

for albom in alboms
$offset = 0
until $offset >= 10000 do

  uri = URI.parse("https://api.vk.com/method/photos.get?owner_id=#{groupID}&album_id=#{albom}&offset=#{$offset}&count=1000")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  hashData = JSON.parse(response.body)
  responseList = hashData["response"]
  for record in responseList
    if (record["user_id"].to_s).eql? personID
      photoList.unshift("https://vk.com/photo#{groupID}_"+record["pid"].to_s)
    end
  end
  $offset += 1000
end
end

writeHandler = File.new("TestFile.txt", "w")
writeHandler.puts(photoList).to_s
