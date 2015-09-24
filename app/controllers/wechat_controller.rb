# coding: utf-8
class WechatController < ApplicationController

  wechat_responder

  on :text, with: "借药" do |request|
    request.reply.text "#{bind_url request[:FromUserName]}"
  end

  on :text, with: "ma@oct" do |request|
    request.reply.text request[:FromUserName]
  end

  on :text do |request, query|
    resp = Item.search query: {term: {name: query}},
                       sort: [num: {order: 'desc'}],
                       size: 5
    if resp.results.total == 0
      request.reply.text random_text
    else
      msg = resp.results.map { |r|
        r.name + "\t" + r.num.to_s + "个\n" + r.profile.nickname + "\n"
      }.join("\n") + "\n注意：以上结果是数量最多的前5位麻麻"
      request.reply.text msg
    end
  end

  private
  def bind_url(openid)
    if User.find_for_authentication(:openid => openid)
      %Q[<a href="#{Figaro.env.app_domain}/users/sign_in?oid=#{openid}">马村药品库</a>]
    else
      %Q[您的微信号还未与马村药品库建立绑定。点击<a href="#{Figaro.env.app_domain}/users/sign_up?oid=#{openid}">进行绑定</a>]
    end
  end

  def random_text
    arr = %w[ 你是不是要"借药" 在聊天框输入药名关键字就能查询哦 有新药记得来添加哦 药品出借后记得更新数量哟]
    arr.at Random.rand(arr.length)
  end

end
