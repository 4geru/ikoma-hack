def give_up_confirm()
	{
		"type": "template",
		"altText": "ギブアップ選択中",
		"template": {
			"type": "confirm",
			"text": "ギブアップしますか？",
			"actions": [
				{
					"type": "postback",
					"label": "Yes",
					"data": "action=giveup"
				},
				{
					"type": "message",
					"label": "No",
					"text": "もう少し頑張りましょう"
				}
			]
		}
	}
end

def final_give_up_confirm()
	{
		"type": "template",
		"altText": "ギブアップ選択中",
		"template": {
			"type": "confirm",
			"text": "本当に、ギブアップしますか？",
			"actions": [
				{
					"type": "postback",
					"label": "Yes",
					"data": "action=finalgiveup"
				},
				{
					"type": "message",
					"label": "No",
					"text": "頑張ってください！"
				}
			]
		}
	}
end

