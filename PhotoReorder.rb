require 'net/http'
require 'json'

$groupID = ARGV[0]
$albomID = ARGV[1]
$order = ARGV[2]

$access_token = "0"

def getPhotoList()
  offset = 0
  photoList = Array.new
  until offset >= 10000 do
    photosGetAddress = "https://api.vk.com/method/photos.get?"+
                        "owner_id=#{$groupID}"+
                        "&album_id=#{$albomID}"+
                        "&offset=#{offset}"+
                        "&count=1000"

    uri = URI.parse(photosGetAddress)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    hashData = JSON.parse(response.body)
    responseList = hashData["response"]
    offset += 1000
    for record in responseList
      temp = {"id" => record["pid"], "date" => record["created"]}
      photoList.push(temp)
    end
  end
  return photoList.sort_by { |record| record["date"]}.reverse
end

def sortPhotos(isAscending, photoList)
  afterID = "0"
  if isAscending == true
    afterID = photoList.last["id"]
  else
    afterID = photoList.first["id"]
  end

  row = 1
  for record in photoList
    photoID = record["id"]
    photosReorderAddress = "https://api.vk.com/method/photos.reorderPhotos?"+
                            "owner_id=#{$groupID}"+
                            "&photo_id=#{photoID}"+
                            "&after=#{afterID}"+
                            "&access_token=#{$access_token}"
    uri = URI.parse(photosReorderAddress)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    http.request(request)
    puts "Row:#{row}"
    row+=1
    sleep(1)
  end
end

if ARGV.size == 3
  if ARGV[2].to_s.eql? "asc"
    isAscending = true
  elsif ARGV[2].to_s.eql? "des"
    isAscending = false
  end
  puts "Geting photo list"
  photoList = getPhotoList()
  puts "Sorting photos"
  sortPhotos(isAscending, photoList)
  puts "Sort is finished, check ypur albom"
else
  puts "Usage: <owner_id> <albom_id> <asc or des>"
end
