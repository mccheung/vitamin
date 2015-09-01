require 'addressable/uri'

module WechatHelper
  def self.jssdk_signature(jsapi_ticket, timestamp, nonce, url)
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
