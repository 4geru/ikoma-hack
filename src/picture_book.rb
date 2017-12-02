def picture_book(user_id)
  photos = User.find(user_id).photos
  {
  "type": "template",
  "altText": "図鑑選択中",
  "template": {
      "type": "buttons",
      "title": "図鑑",
      "text": "現在#{photos.length}件の建物が登録できてるよ！\nMapで図鑑を見る",
      "actions": [
          {
            "type": "uri",
            "label": "Webページへ",
            "uri": "https://ikoma-hack.herokuapp.com/map/#{user_id}"
          }
      ]
  }
}
end