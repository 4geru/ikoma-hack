def picture_book(user_id)
  {
  "type": "template",
  "altText": "this is a buttons template",
  "template": {
      "type": "buttons",
      "title": "Menu",
      "text": "Please select",
      "actions": [
          {
            "type": "uri",
            "label": "図鑑を見る",
            "uri": "https://ikoma-rp7rf.c9users.io/map/" + user_id
          }
      ]
  }
}
end