# VkUtilities
Ruby script utilities for https://vk.com social network.

Scripts must be launched manualy at your terminal.

* PhotoSearch - search photos in alboms by autor id.
* PhotoReorder - sort photos by upload date.
* SearchByDate - returns photos uploaded in a specified date.

# PhotoSearch
Can search photos in specified albom or alboms.
Usage: 
```ruby
$ ruby PhotoSearch.rb <autor_id> <group_id> <album_id>
```
or
```ruby
$ ruby PhotoSearch.rb <autor_id> <owner_id> {album_id,albom_id...}
```
Search results will be shown in Search result <autor_id>.txt file.

# PhotoReorder
Requesting vk to reorder photos in specified album.
Note: you need to manually receive access token by any possible authorization methods. Then manually insert it in to the code.
Usage:
```ruby
$ ruby PhotoReorder.rb <owner_id> <album_id> <asc or des>
```
