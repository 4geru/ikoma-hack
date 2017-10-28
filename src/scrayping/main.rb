require 'mechanize'
require 'open-uri'
require 'json'
require './src/scrayping/scrayping'

def run(url = 'http://www2.city.ikoma.lg.jp/dm/41ichiran/4105shisetsu/4105shisetsu.php')
  agent = Mechanize.new
  page = agent.get(url)
  ret = ""
  page.css("table a").each do |a|
     if a[:href] =~ /..\/..\/[0-9][0-9]\//
        url =  'http://www2.city.ikoma.lg.jp/dm/' + a[:href].split('/')[2..-1].join('/')
        s = Scrayping.new(url)
        data =  s.getItems
        ret += "AllStory.create({ 'url': '" + data[:url] + "', 'title': '" +data[:title] + "', 'detail': '" + data[:detail] + "', 'img': '" + data[:img] + "'})\n"
     end
  end
  save_seed(ret)
  ret
end

def save_seed(data)
  File.open("seed.rb", "w") do |f| 
    f.print(data.to_json)
  end
end

def save(data)
  File.open("scrayping_data.json", "w") do |f| 
    f.puts(data.to_json)
  end
end

# run()