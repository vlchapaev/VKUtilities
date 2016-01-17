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
$ ruby PhotoSearch.rb <autor_id> <group_id> <albom_id>
```
or
```ruby
$ ruby PhotoSearch.rb <autor_id> <group_id> {albom_id,albom_id...}
```
Search results will be shown in Search result <autor_id>.txt file.
