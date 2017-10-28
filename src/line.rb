require 'line/bot'
require './src/hint'
require './src/start'
require './src/give_up'

require 'dotenv'
Dotenv.load

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
    p event
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        if event.message['text'] == 'ヒントをください'
          client.reply_message(event['replyToken'], hint_confirm())
        elsif event.message['text'] == 'ゲームスタート'
          data = make_carousel_template_data([
              AllStory.find(1),
              AllStory.find(2),
              AllStory.find(3),
              AllStory.find(4),
              AllStory.find(5)
            ])
            p data
          client.reply_message(event['replyToken'], data)
        elsif event.message['text'] == 'ギブアップ'
          client.reply_message(event['replyToken'], give_up_confirm())
        end
        msg = Hello.new.message(event.message['text'])
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Image
        response = client.get_message_content(event.message['id'])

        # Need Config Var 'CLOUDINARY_URL' with format (API Key):(API Secret)@(Cloud name)
        image = MiniMagick::Image.read(response.body)
        imageName = SecureRandom.uuid
        image.write("tmp/#{imageName}.jpg")
        result = Cloudinary::Uploader.upload("tmp/#{imageName}.jpg")
        message = [
          {
            type: 'text',
            text: result['secure_url']
          }
        ]
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      when 'location'
        
        message = {
          type: 'text',
          text: hint_location(event.message['latitude'], event.message['longitude'])
        }
        client.reply_message(event['replyToken'], message)
      end
    when Line::Bot::Event::Beacon
    msg = "クリアです！記念写真を撮ってね！"
    message = {
      type: 'text',
      text: msg
    }
    client.reply_message(event['replyToken'], message)
    
    when Line::Bot::Event::Postback
      data =  URI::decode_www_form(event['postback']['data']).to_h
      p data
      case data['action']
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
