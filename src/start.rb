def make_carousel_template_data(places)
  root = "https://ikoma-hack.herokuapp.com/images"
  columns = places[0..4].map{ |place| {
    
      "thumbnailImageUrl":"#{root}/#{place.id}.jpg",
      "title": "#{place.title[0..12]}",
      "text": "#{place.detail[0..20]}",
      "actions": [
          {
              "type": "postback",
              "label": "冒険を始める！",
              "data": "action=start&place_id=#{place.id}"
          },
      ]
  } }
 {
  "type": "template",
  "altText": "目的地選択中",
  "template": {
      "type": "carousel",
      "columns": columns
  }
}
end
