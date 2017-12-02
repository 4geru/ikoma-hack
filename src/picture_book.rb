def picture_book(user_id)
  {
  "type": "template",
  "altText": "図鑑選択中",
  "template": {
      "type": "buttons",
      "title": "図鑑",
      "text": "Mapで図鑑を見る",
      "actions": [
          {
            "type": "uri",
            "label": "Webページへ",
            "uri": "https://ikoma-rp7rf.c9users.io/map/#{user_id}"
          }
      ]
  }
}
end