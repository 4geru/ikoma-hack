require 'mechanize'
require 'open-uri'
require 'json'
require './src/scrayping/scrayping'

def run(url = "", t = 40)
  agent = Mechanize.new
  page = agent.get('http://www2.city.ikoma.lg.jp/dm/41ichiran/4105shisetsu/4105shisetsu.php')
  ret = ""
  page.css("table a").each do |a|
     if a[:href] =~ /..\/..\/[0-9][0-9]\//
        url =  'http://www2.city.ikoma.lg.jp/dm/' + a[:href].split('/')[2..-1].join('/')
        p url
        s = Scrayping.new(url)
        data =  s.getItems
        puts data
        ret << data.to_json
     end
  end
  save(ret)
  ret
end

def save(data)
  File.open("scrayping_data.json", "w") do |f| 
    f.puts(data.to_json)
  end
end

# run()