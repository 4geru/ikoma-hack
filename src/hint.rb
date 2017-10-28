def hint_confirm()
{
  "type": "template",
  "altText": "ヒント洗濯中",
  "template": {
      "type": "confirm",
      "text": "ヒントを使いますか?",
      "actions": [
          {
              "type": "uri",
              "label": "Yes",
              "uri": "line://nv/location/"
          },
          {
            "type": "message",
            "label": "No",
            "text": "ヒントを使いませんでした"
          }
      ]
  }
}
end
# :latitude => 34.693027,
# :longitude => 135.6954373
def hint_location(latitude, longitude)
  
end

def get_distance(pos1, pos1)
	lat1 = pos1[0]
	lng1 = pos1[1]
	lat2 = pos2[0]
	lng2 = pos2[1]
	y1 = lat1 * Math::PI / 180
	x1 = lng1 * Math::PI / 180
	y2 = lat2 * Math::PI / 180
	x2 = lng2 * Math::PI / 180
	earth_r = 6378140
		
	deg = Math::sin(y1) * Math::sin(y2) + Math::cos(y1) * Math::cos(y2) * Math::cos(x2 - x1)
	distance = earth_r * (Math::atan(-deg / Math::sqrt(-deg * deg + 1)) + Math::PI / 2) / 1000
end