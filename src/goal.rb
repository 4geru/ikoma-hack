def goal_uploaded_photo_message(user)
  [
    {
      type: 'text',
      text: "#{user.all_story.title}をアルバムに画像を保存しました！！おめでとう！！"
    },
    {
      type: "sticker",
      packageId: "1",
      stickerId: "407"
    },
    picture_book(user)
  ]
end

def goal_upload_photo_messge(user)
  [
    {
      type: 'text',
      text: "#{user.all_story.title}についたよ！\nクリアです！下のURLをタップしてみんなで記念写真を撮ってね！"
    },
    {
      type: "sticker",
      packageId: "1",
      stickerId: "136"
    },
    {
      type: "text",
      text: "line://nv/camera/"
    }
  ]
end