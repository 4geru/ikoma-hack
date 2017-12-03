def picture_book(user)
  photos = user.photos
  root = 'https://ikoma-hack.herokuapp.com/map'
  
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
            "uri": "#{root}/#{user.id}"
          }
      ]
  }
}
end