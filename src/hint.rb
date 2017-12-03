def hint_confirm()
{
  "type": "template",
  "altText": "ヒント選択中",
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

def hint_location(latitude, longitude, goal)

  answer = target(goal.lng, goal.lat)
  answer_pos = [answer[:latitude], answer[:longitude]]
  target_pos = [latitude, longitude]
  case rand(2)
  when 0
    # angle
    p get_angle(target_pos, answer_pos) + "の方向に進め"
    return "#{goal.title}は#{get_angle(target_pos, answer_pos)}の方向だよ！"
  when 1
    # distance
    if get_distance(target_pos, answer_pos) > 1
      ret = sprintf("%.1fkm", get_distance(target_pos, answer_pos))
    else
      ret = sprintf("%2fm", get_distance(target_pos, answer_pos) * 1000)
    end
    return "#{goal.title}まで残り#{ret}だよ！"
  else
    # img
  end
end

def get_distance(pos1, pos2)
	y1 = pos1[0] * Math::PI / 180
	x1 = pos1[1] * Math::PI / 180
	y2 = pos2[0] * Math::PI / 180
	x2 = pos2[1] * Math::PI / 180
	earth_r = 6378140

	deg = Math::sin(y1) * Math::sin(y2) + Math::cos(y1) * Math::cos(y2) * Math::cos(x2 - x1)
	distance = earth_r * (Math::atan(-deg / Math::sqrt(-deg * deg + 1)) + Math::PI / 2) / 1000
end

def target(goal_lat, goal_lng)
  # pos2 = [34.724944, 135.723749] #きた生駒
  p goal_lat, goal_lng
  {
    :latitude => goal_lat,
    :longitude => goal_lng
  }
end

def get_angle(pos1, pos2)
	lat1 = pos1[0]
	lng1 = pos1[1]
	lat2 = pos2[0]
	lng2 = pos2[1]

	# 緯度経度 lat1, lng1 の点を出発として、緯度経度 lat2, lng2 への方位
	# 東向きを0度とした時計回り
	y = Math::cos(lng2 * Math::PI / 180) * Math::sin(lat2 * Math::PI / 180 - lat1 * Math::PI / 180);
	x = Math::cos(lng1 * Math::PI / 180) * Math::sin(lng2 * Math::PI / 180) - Math::sin(lng1 * Math::PI / 180) * Math::cos(lng2 * Math::PI / 180) * Math::cos(lat2 * Math::PI / 180 - lat1 * Math::PI / 180);

	angle = 180 * Math::atan2(y, x) / Math::PI;
	if (angle < 0)
			angle = angle + 360; #0～360 にする。
	end

# 	p "目標までの角度: "+ angle.to_s
	if (angle >= 0 && angle < 90) then
		return '南東'
	elsif (angle >= 90  && angle < 180) then
    return '南西'
	elsif (angle >= 180 && angle < 270) then
    return '北西'
	elsif (angle >= 270 && angle < 360) then
    return '北東'
	end

end
