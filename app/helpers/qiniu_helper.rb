module QiniuHelper
  def self.fetch(from, bucket, key)
    encode_from = Qiniu::Utils.urlsafe_base64_encode(from)
    encode_to = Qiniu::Utils.encode_entry_uri(bucket, key)

    path = "http://iovip.qbox.me/fetch/#{encode_from}/to/#{encode_to}"
    access_token = Qiniu::Auth.generate_acctoken(path)

    uri = URI(path)
    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = "QBox #{access_token}"
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end
    JSON.load(res.body)
  end
end
