require 'line/bot'

def client
  @client ||= Line::Bot::Client.new { |config|

    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
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
          msg = Hello.new.message(event.message['text'])
          message = {
            type: 'text',
            text: msg
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image
          response = client.get_message_content(event.message['id'])

          # Need Config Var 'CLOUDINARY_URL' with format (API Key):(API Secret)@(Cloud name)
          image = MiniMagick::Image.read(response.body)
          imageName = SecureRandom.uuid
          image.write("tmp/#{imageName}.jpg")
          result = Cloudinary::Uploader.upload("tmp/#{imageName}.jpg")
          # message = [
          #   {
          #     type: 'text',
          #     text: result['secure_url']
          #   }
          # ]
          image = Image.new()
          image.user_id = 1
          image.all_story_id = 1
          image.url = result['secure_url']
          image.save

          message = [
            {
              type: 'text',
              text: "クリアです！！おめでとう！！"
            },
            {
              type: "sticker",
              packageId: "1",
              stickerId: "1"
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
        end
      when Line::Bot::Event::Beacon
        msg = "クリアです！みんなで記念写真を撮ってね！"
        message = {
          type: 'text',
          text: msg
        }
        client.reply_message(event['replyToken'], message)
      end
    }

    "OK"
  end
