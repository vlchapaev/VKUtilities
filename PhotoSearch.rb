require 'net/http'
require 'json'

alboms = ["14231802", "146106495", "216473097"]

personID = "100"
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

writeHandler = File.new("Photo search result.txt", "w")
writeHandler.puts(photoList).to_s
