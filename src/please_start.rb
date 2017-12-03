def please_start
  [
    {
      type: 'text',
      text: "ゲームが始まってないよ\nゲームをはじめてね！"
    },
    {
  		"type": "template",
  		"altText": "ゲームスタート選択中",
  		"template": {
  			"type": "confirm",
  			"text": "ゲームを始めますか？",
  			"actions": [
  				{
  					"type": "postback",
  					"label": "Yes",
  					"text": "ゲームスタート",
  					"data": "foo"
  				},
  				{
  					"type": "message",
  					"label": "No",
  					"text": "また挑戦してください！"
  				}
  			]
  		}
    }
  ]
end