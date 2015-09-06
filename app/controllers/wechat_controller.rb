# coding: utf-8
class WechatController < ApplicationController

  # 接收微信的push消息，必须跳过CSRF检查
  skip_before_action :verify_authenticity_token

  def verify
    render plain: params[:echostr]
  end

  def msg
    body = request.body.read
    xml = MultiXml.parse(body)['xml']
    xml_doc = OpenStruct.new(xml)
    if xml_doc.Content == '借药'
      @from = xml_doc.ToUserName
      @to = xml_doc.FromUserName
      @msg_type = 'text'
      @content = bind_url(xml_doc.FromUserName)
      puts @content
    else
      render nothing: true
    end
  end

  private
  def bind_url(openid)
    user = User.find_for_authentication(:openid => openid)
    if user
      "<a href=" << "\"http://mc.ggrok.com\"" << ">马村药品库</a>"
    else
      "您的微信号还未与马村药品库建立绑定。点击<a href=" << "\"http://mc.ggrok.com/users/sign_up?oid=#{openid}\"" << ">进行绑定</a>"
    end
  end

end
