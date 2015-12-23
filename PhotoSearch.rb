require 'net/http'
require 'json'

if ARGV.size >= 3
  puts "Searching photos..."
  personID = ARGV[0].to_s
  groupID = ARGV[1].to_s
  alboms = ARGV[2..ARGV.size]

  photoList = Array.new
  for albom in alboms
    offset = 0
    until offset >= 10000 do
      uri = URI.parse("https://api.vk.com/"+
                      "method/photos.get?"+
                      "owner_id=#{groupID}"+
                      "&album_id=#{albom}"+
                      "&offset=#{offset}"+
                      "&count=1000")

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
      offset += 1000
    end
  end

  writeHandler = File.new("Search result " + "#{personID.to_s}"+".txt", "w")
  writeHandler.puts(photoList).to_s

  puts "Done, results at: Search result " + "#{personID.to_s}"+".txt"
else
  puts "Usage: personID groupID {albom_id,albom_id,..}"
end
