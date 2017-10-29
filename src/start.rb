def make_carousel_template_data(places)
  root = "https://ikoma-hack.herokuapp.com/images"
 {
  "type": "template",
  "altText": "this is a carousel template",
  "template": {
      "type": "carousel",
      "columns": [
          {
            "thumbnailImageUrl": root + "/0.jpg",
            "title": "#{places[0].title[0..12]}",
            "text": "#{places[0].detail[0..20]}",
            "actions": [
                {
                    "type": "postback",
                    "label": "冒険を始める！",
                    "data": "action=start&place_id=#{places[0].id}"
                },
            ]
          },
          {
            "thumbnailImageUrl": root + "/1.jpg",
            "title": "#{places[1].title[0..12]}",
            "text": "#{places[1].detail[0..20]}",
            "actions": [
                {
                    "type": "postback",
                    "label": "冒険を始める！",
                    "data": "action=start&place_id=#{places[1].id}"
                },
            ]
          },
          {
            "thumbnailImageUrl": root + "/2.jpg",
            "title": "#{places[2].title[0..12]}",
            "text": "#{places[2].detail[0..20]}",
            "actions": [
                {
                    "type": "postback",
                    "label": "冒険を始める！",
                    "data": "action=start&place_id=#{places[2].id}"
                },
            ]
          },
          {
            "thumbnailImageUrl": root + "/3.jpg",
            "title": "#{places[3].title[0..12]}",
            "text": "#{places[3].detail[0..20]}",
            "actions": [
                {
                    "type": "postback",
                    "label": "冒険を始める！",
                    "data": "action=start&place_id=#{places[3].id}"
                },
            ]
          }, 
          {
            "thumbnailImageUrl": root + "/4.jpg",
            "title": "#{places[4].title[0..12]}",
            "text": "#{places[4].detail[0..20]}",
            "actions": [
                {
                    "type": "postback",
                    "label": "冒険を始める！",
                    "data": "action=start&place_id=#{places[4].id}"
                },
            ]
          },
      ]
  }
}
end