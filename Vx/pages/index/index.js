// index.js
Page({
  data:{
    msg:'hello world',
    nickName:'',
    avatar:''
  },
  //获取微信用户头像和名称
  getUserInfo(){
    wx.getUserProfile({
      desc: '获取用户信息',
      success: (res) =>{
        console.log(res.userInfo)

        this.setData({
          nickName: res.userInfo.nickName,
          avatar: res.userInfo.avatarUrl
        })
      }
    })
  },

  wxLogin(){
    //wx登录的函数
    wx.login({
      success: (res)=>{
        console.log(res.code)

      }
    })
  },

  //发送请求
  sendRequest(){
    wx.request({
      url: 'http://localhost:8080/user/shop/status',
      method:'GET',
      success: (res)=>{
        console.log(res.data)

      }
    })
  }

})
