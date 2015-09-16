require 'addressable/uri'

module Wechat
  def media_url(media_id, access_token)
    "http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=#{access_token}&media_id=#{media_id}"
  end

  def set_jssdk
    @app_id = $wechat_app_id
    @timestamp = Time.now.to_i
    @nonce = SecureRandom.hex
    @url = request.original_url
    jsapi_ticket = $redis.get "jsapi_ticket:#{$wechat_app_id}"
    @signature = jssdk_signature(jsapi_ticket, @timestamp, @nonce, @url)
  end

  private

  def jssdk_signature(jsapi_ticket, timestamp, nonce, url)
    uri = Addressable::URI.new
    uri.query_values = {:timestamp => timestamp,
                        :noncestr => nonce,
                        :jsapi_ticket => jsapi_ticket,
                        :url => url
                       }.sort
    str = Addressable::URI.unencode_component(uri.query)
    Digest::SHA1.hexdigest(str)
  end
end
