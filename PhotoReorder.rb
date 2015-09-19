require 'net/http'
require 'json'

groupID = "-331509"
photoID = ""
beforeID = ""
afterID = ""

requestAdress = "https://api.vk.com/method/photos.reorderPhotos?owner_id=#{groupID}
                                                               &photo_id=#{photoID}
                                                               &before=#{beforeID}
                                                               &after=#{afterID}"
