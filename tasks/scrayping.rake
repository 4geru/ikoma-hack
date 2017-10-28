require './src/scrayping/main'
namespace :scrayping do
  desc "スクレイピングを実行しますす"
  task :get do
    run()
  end
end