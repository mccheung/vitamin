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
    arr = Item.where("name LIKE '%#{query}%'")
          .eager_load(:profile)
          .order(num: :desc)
          .limit(5)
          .pluck(:name, :num, :nickname)
          .uniq
    if arr.empty?
      request.reply.text "没有这种药"
    else
      results = arr.each.map { |name, num, nickname|
        name + "\n" + nickname + "\n数量：" + num.to_s + "\n"
      }.join("\n") + "\n注意：以上结果是数量最多的前5位麻麻"
      request.reply.text results
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

end
