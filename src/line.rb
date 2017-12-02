require 'line/bot'
require './src/hint'
require './src/start'
require './src/give_up'
require './src/picture_book'

require 'dotenv'
Dotenv.load
require 'mini_magick'
require 'cloudinary'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  }
end

post '/callback' do
  @goal_lat = 10
  @goal_lng = 100
  body = request.body.read
  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request'
    end
  end

  events = client.parse_events_from(body)
  events.each { |event|
    User.find_or_create_by({user_id: event["source"]["userId"]})
    case event

    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        if event.message['text'] == 'ビーコン'

      msg = "クリアです！みんなで記念写真を撮ってね！"
      message = [
        {
          type: 'text',
          text: msg
        },
        {
          type: "sticker",
          packageId: "1",
          stickerId: "136"
        }
      ]
      client.reply_message(event['replyToken'], message)

        elsif event.message['text'] == 'ヒントをください'
          client.reply_message(event['replyToken'], hint_confirm())

        elsif event.message['text'] == 'ゲームスタート'
          rand_ids = AllStory.where("lat is not ?", nil).ids
          rand_num = rand_ids.sample(5)
          goal = []
          goal[0] = AllStory.find(rand_num[0].to_i)
          goal[1] = AllStory.find(rand_num[1].to_i)
          goal[2] = AllStory.find(rand_num[2].to_i)
          goal[3] = AllStory.find(rand_num[3].to_i)
          goal[4] = AllStory.find(rand_num[4].to_i)
          # p user.user_id, user.all_story_id

          data = make_carousel_template_data([
              goal[0],
              goal[1],
              goal[2],
              goal[3],
              goal[4]
            ])
            # p data
            @goal_lat = goal[0].lat
            @goal_lng = goal[0].lng
          client.reply_message(event['replyToken'], data)

        elsif event.message['text'] == 'ギブアップ'
          client.reply_message(event['replyToken'], give_up_confirm())
        elsif event.message['text'] == '図鑑'
          client.reply_message(event['replyToken'], picture_book(User.find_by(user_id: event["source"]["userId"]).id))
        end
        msg = Hello.new.message(event.message['text'])
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)

      when Line::Bot::Event::MessageType::Image
        response = client.get_message_content(event.message['id'])
        image = MiniMagick::Image.read(response.body)
        imageName = SecureRandom.uuid
        image.write("/tmp/#{imageName}.jpg")
        result = Cloudinary::Uploader.upload("/tmp/#{imageName}.jpg")
        user = User.where({user_id: event["source"]["userId"]}).first
        image = Photo.create({
          user_id: user.id,
          all_story_id: 1,
          url: result['secure_url']
        })

        message = [
          {
            type: 'text',
            text: "アルバムに画像を保存しました！！おめでとう！！"
          },
          {
            type: "sticker",
            packageId: "1",
            stickerId: "407"
          },
          {
            type: 'text',
            text: image.url
          }
        ]

        client.reply_message(event['replyToken'], message)

      when Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)

      when 'location'
        user = User.find_or_create_by({user_id: event["source"]["userId"]})
        p user.user_id, user.all_story_id
        story = AllStory.find(user.all_story_id)
        message = {
          type: 'text',
          text: hint_location(event.message['latitude'], event.message['longitude'], story.lat, story.lng)
        }
        client.reply_message(event['replyToken'], message)
      end

    when Line::Bot::Event::Beacon
      msg = "クリアです！みんなで記念写真を撮ってね！"
      message = [
        {
          type: 'text',
          text: msg
        },
        {
          type: "sticker",
          packageId: "1",
          stickerId: "136"
        },
        {
          type: 'text',
          text: "idは" + event['beacon']['hwid'] + "です！"
        }
      ]
      client.reply_message(event['replyToken'], message)

    when Line::Bot::Event::Postback
      data =  URI::decode_www_form(event['postback']['data']).to_h
      p data
      case data['action']
      when 'start'
        user = User.find_or_create_by({user_id: event["source"]["userId"]})
        user.all_story_id = data["place_id"]
        user.save
        story = AllStory.find(data["place_id"])
        message = {
          type: 'text',
          text: "目的地は" + story.title + "だね！楽しい冒険が始まるよ！頑張ってね！"
        }
        client.reply_message(event['replyToken'], message)
      when 'giveup'
        message = {
          type: 'text',
          text: "えぇー？本当に？"
        }
        client.reply_message(event['replyToken'], [message, final_give_up_confirm()])
      when 'finalgiveup'
        message = {
          type: 'text',
          text: "お疲れ様！また頑張ってね！"
        }
        client.reply_message(event['replyToken'], message)
      end
    end
  }

  "OK"
end
