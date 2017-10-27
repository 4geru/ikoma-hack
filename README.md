### 開発環境設定
ブランチ名はなんでもよいです
Ruby version 2.3.4
```
$ git clone https://github.com/4geru/ikoma-hack.git
$ git co -b 名字_test
$ git push --set-upstream origin 名字_test
$ bundle install --path=vendor/bundle
$ heroku login
$ heroku create app_name
$ git push heroku master origin/名字_test

```

ここまで出来たら、以下から自分のBotを作りましょう
[LINE Bot作成](https://developers.line.me/ja/docs/messaging-api/getting-started/)
手順通りに進めるだけで出来るはずです
出来たBotの詳細ページでChannel Secretとアクセストークンを発行してください
Webhook URLはheroku urlに/callbackをつけて設定してください

ここまで出来たら、Heroku dashboardでLINE_CHANNEL_SECRETとLINE_CHANNEL_TOKENを設定しましょう
[Heroku ダッシュボード](https://dashboard.heroku.com)
今回のアプリを選択 -> Setting -> Reveal Config Vars
ここであなたのLINE_CHANNEL_SECRETとLINE_CHANNEL_TOKENを設定してください

この段階でBotを友達追加してもらうとオウム返しされるはず！
### testについて

[環境構築](http://qiita.com/yusabana/items/db44b81bdddf6ed0e9f5)
[使い方](http://qiita.com/jnchito/items/42193d066bd61c740612)

### DBについて

```
$ rake db:create_migration NAME=create_DB_NAME_
$ rake db:migrate
```

[参照](http://qiita.com/myokkie/items/b6b68b247ec7a110a1c4)# ikoma-hack
