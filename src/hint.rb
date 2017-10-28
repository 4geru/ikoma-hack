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