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
        client.reply_message(event['replyToken'], make_carousel_template_data)
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
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
      "columns": {
        "thumbnailImageUrl": "https://wing-auctions.c.yimg.jp/sim?furl=auctions.c.yimg.jp%2Fimages.auctions.yahoo.co.jp%2Fimage%2Fdr000%2Fauc0310%2Fusers%2F3%2F0%2F9%2F2%2Fneutraltakizawa-img640x480-1507701425ktdswi32237.jpg&dc=1&sr.fs=20000",
        "title": "xxx遺跡",
        "text": "遺跡って響き...いいよね！！",
        "actions": {
          "type": "uri",
          "label": "View detail",
          "uri": "http://www2.city.ikoma.lg.jp/dm/12/1206shonotani/120602shonotani/120602shonotani.php"
        }
      }
    }
  }
end
