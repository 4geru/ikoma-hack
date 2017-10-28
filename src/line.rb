require 'line/bot'
require './src/hint'

require 'dotenv'
Dotenv.load

def client
  @client ||= Line::Bot::Client.new { |config|

    config.channel_secret = "ba34878dd4a81c9b82ec84fe00e00765"
    config.channel_token = "JKoe35FW7SxRSvoWr/HLAlTl4RbBm2fqbuiuaUwXZShKJnKJ6GS+Tte8xt71poYxOlu7YqeURq8LBDv7m1NG5JT2urWiYqc/v5Tksga4c2e45HWKMhAy5NTh8lJKBSl8Z+zF62HKLRfOrpiWRPL6ZwdB04t89/1O/w1cDnyilFU="
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
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        if event.message['text'] == 'ヒントをください'
          client.reply_message(event['replyToken'], hint_confirm())
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
    end
  }

  "OK"
end
