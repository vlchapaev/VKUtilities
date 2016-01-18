require 'net/http'
require 'json'

if ARGV.size >= 3
  puts "Searching photos..."
  date = ARGV[0]
  groupID = ARGV[1]
  albom = ARGV[2]

  photoList = Array.new
  $offset = 0
  until $offset >= 10000 do
    uri = URI.parse("https://api.vk.com/method/photos.get?"+
                      "owner_id=#{groupID}"+
                      "&album_id=#{albom}"+
                      "&offset=#{$offset}"+
                      "&extended=1"+
                      "&count=1000")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    hashData = JSON.parse(response.body)
    responseList = hashData["response"]
    for record in responseList
      if Time.at(record["created"].to_i).strftime("%d.%m.%Y").eql? date
        photoList.unshift("https://vk.com/photo#{groupID}_" + record["pid"].to_s)
        #photoList.push(record["pid"].to_s)
      end
    end
    $offset += 1000
  end
  puts photoList
  #writeHandler = File.new("Search by date result.txt", "w")
  #writeHandler.puts(photoList).to_s
else
  puts "Usage: <dd.mm.yyyy> <owner_id> <album_id>"
end
