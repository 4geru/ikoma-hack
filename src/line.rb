require 'line/bot'
require './src/hint'
require './src/start'
require './src/give_up'
require './src/clear'
require './src/picture_book'
require './src/please_start'

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
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each { |event|
    user = User.find_or_create_by({user_id: event["source"]["userId"]})
    case event

    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        if event.message['text'] == 'ビーコン'
          client.reply_message(event['replyToken'], clear_message)

        elsif event.message['text'] == 'ヒントをください'
          if user.all_story.nil?
            client.reply_message(event['replyToken'], please_start())
          else
            client.reply_message(event['replyToken'], hint_confirm())
          end
        elsif event.message['text'] == 'ゲームスタート'
          all_story = AllStory.where("lat is not ?", nil).shuffle[0..4]
          data = make_carousel_template_data(all_story)
            # p data
          client.reply_message(event['replyToken'], data)

        elsif event.message['text'] == 'ギブアップ'
          if user.all_story.nil?
            client.reply_message(event['replyToken'], please_start())
          else
            client.reply_message(event['replyToken'], give_up_confirm())
          end
        elsif event.message['text'] == '図鑑'
          client.reply_message(event['replyToken'], picture_book(user))
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
        image = Photo.create({
          user_id: user.id,
          all_story_id: user.all_story_id,
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
        story = AllStory.find(user.all_story_id)
        message = {
          type: 'text',
          text: hint_location(event.message['latitude'], event.message['longitude'], story)
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
        user.all_story_id = nil
        user.save
        client.reply_message(event['replyToken'], message)
      end
    end
  }

  "OK"
end
