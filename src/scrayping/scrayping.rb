require 'mechanize'
require 'json'
class Scrayping
  def initialize(url = '')
    @agent = Mechanize.new
    @url = url
  end
  
  def getItems()
      
    page = @agent.get(@url)
    title = page.css("table")[1].css("img")[0]
    title = title.attribute("alt").value
    img = page.css("table")[1].css("img")[1]
    img_url =  @url.split('/')[0..-2].join('/') + '/' + img.attribute("src").value
    detail = ''
    if not page.css('.lineh120perfontxsmall').empty?
      p 'true'
      detail = page.css('.lineh120perfontxsmall')[0].inner_text
    else
      p 'else'
      detail = page.css('.txtbunsetsumei')[0].inner_text
    end
    
    # 空白を変換
    detail.gsub!('  ',' ')
    
    # 改行文字の変換
    detail.gsub!('\\r\\r', '<br />')
    data = {
      :url => @url,
      :title => title,
      :img => img_url,
      :detail => detail
    }
    data
  end
end
# sample code
# url = 'http://www2.city.ikoma.lg.jp/dm/07/0706amidaji/070600top/070600top.php'
# s = Scrayping.new(url)
# puts s.getItems


