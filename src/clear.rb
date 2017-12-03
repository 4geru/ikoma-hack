def clear_message
  [
    {
      type: 'text',
      text: "クリアです！みんなで記念写真を撮ってね！"
    },
    {
      type: "sticker",
      packageId: "1",
      stickerId: "136"
    },
    {
      type: "uri",
      label: "撮影",
      uri: "line://nv/camera/"
    }
  ]
end