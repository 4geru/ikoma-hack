require 'sinatra'
require 'line/bot'
require './src/hello'

# 微小変更部分！確認用。
get '/' do
  "test"
end

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
        case msg
        when "さがす"
        client.reply_message(event['replyToken'], make_carousel_template_data)
        end
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
  }

  "OK"
end

def make_carousel_template_data
  return message = {
  "type": "template",
  "altText": "select mission",
  "template": {
      "type": "carousel",
      "columns": [
         {
            "thumbnailImageUrl": http://www2.city.ikoma.lg.jp/dm/12/1206shonotani/120602shonotani/00789.php,
            "title": "xxx遺跡",
            "text": "遺跡って響き...いいよね！！",
            "actions": [
                {
                    "type": "postback",
                    "label": "Buy",
                    "data": "action=buy&itemid=111"
                },
                {
                    "type": "postback",
                    "label": "Add to cart",
                    "data": "action=add&itemid=111"
                },
                {
                    "type": "uri",
                    "label": "View detail",
                    "uri": "http://www2.city.ikoma.lg.jp/dm/12/1206shonotani/120602shonotani/120602shonotani.php"
                }
            ]
          }
      ]
    }
  }
end
