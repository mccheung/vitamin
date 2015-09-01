# coding: utf-8
class Msg
  def initialize(hash)
    @source = OpenStruct.new(hash)
  end

  def method_missing(method, *args, &block)
    @source.send(method, *args, &block)
  end

  def CreateTime
    @source.CreateTime.to_i
  end

  def MsgId
    @source.MsgId.to_i
  end

  def self.factory(xml)
    hash = MultiXml.parse(xml)['xml']
    case hash['MsgType']
    when 'text'
      ::Text.new(hash)
    when 'image'
      ::Image.new(hash)
    when 'video'
      ::Video.new(hash)
    when 'shortvideo'
      ::ShortVideo.new(hash)
    when 'location'
      ::Location.new(hash)
    when 'link'
      ::Link.new(hash)
    when 'event'
      ::Event.new(hash)
    end
  end
end

# <xml>
# <ToUserName><![CDATA[gh_ac0d6ee46c9b]]></ToUserName>
# <FromUserName><![CDATA[of16As7gvnOiqK9ZBxyhAwUMMBQY]]></FromUserName>
# <CreateTime>1438099360</CreateTime>
# <MsgType><![CDATA[text]]></MsgType>
# <Content><![CDATA[hi]]></Content>
# <MsgId>6176589719809329505</MsgId>
# </xml>
Text = Class.new(Msg)

# <xml>
# <ToUserName><![CDATA[gh_ac0d6ee46c9b]]></ToUserName>
# <FromUserName><![CDATA[of16As7gvnOiqK9ZBxyhAwUMMBQY]]></FromUserName>
# <CreateTime>1438099390</CreateTime>
# <MsgType><![CDATA[image]]></MsgType>
# <PicUrl><![CDATA[http://mmbiz.qpic.cn/mmbiz/kgMXREicPn3Wt0Gvp19uVKU4vhSIibH8rJL1H1NULPIPLhML3pw0tQpurpSP3u31hDdDlO4RoTdeH9icM6A5fQSdw/0]]></PicUrl>
# <MsgId>6176589848658348390</MsgId>
# <MediaId><![CDATA[7vBHeQjZSuPsCK18IHkRvnLy11S6N6RqlHialqt4fY37YHS8GiGIFxa7AIbU5rTI]]></MediaId>
# </xml>
Image = Class.new(Msg)

# <xml>
# <ToUserName><![CDATA[gh_ac0d6ee46c9b]]></ToUserName>
# <FromUserName><![CDATA[of16As7gvnOiqK9ZBxyhAwUMMBQY]]></FromUserName>
# <CreateTime>1438099437</CreateTime>
# <MsgType><![CDATA[voice]]></MsgType>
# <MediaId><![CDATA[iK55zGubImTFLXNtk4WkmlKruTpqJH-5hmqbZhcZSstcgsYJQ0y2rYcU7tk7PIR4]]></MediaId>
# <Format><![CDATA[speex]]></Format>
# <MsgId>6176590050311012352</MsgId>
# <Recognition><![CDATA[]]></Recognition>
# </xml>
Voice = Class.new(Msg)

# <xml>
# <ToUserName><![CDATA[gh_ac0d6ee46c9b]]></ToUserName>
# <FromUserName><![CDATA[of16As7gvnOiqK9ZBxyhAwUMMBQY]]></FromUserName>
# <CreateTime>1438099645</CreateTime>
# <MsgType><![CDATA[video]]></MsgType>
# <MediaId><![CDATA[7JPvvWEY8Hq3-_K79gRBcPRYLjPAf-QR9pwxIKZqOivR7Y0IZqxfZzr32cvZv2lQ]]></MediaId>
# <ThumbMediaId><![CDATA[St4U-AVDD7flmWaLBzNF2DSe28nUmafKkBPLqWWbhx1n3nuViYHF93NrNwJFW6g7]]></ThumbMediaId>
# <MsgId>6176590943875008918</MsgId>
# </xml>
Video = Class.new(Msg)

# <xml>
# <ToUserName><![CDATA[gh_ac0d6ee46c9b]]></ToUserName>
# <FromUserName><![CDATA[of16As7gvnOiqK9ZBxyhAwUMMBQY]]></FromUserName>
# <CreateTime>1438099511</CreateTime>
# <MsgType><![CDATA[shortvideo]]></MsgType>
# <MediaId><![CDATA[WvgwVVcxecbDZcrzUQ1KjmHk3NOM5o-5Qqi9gZi5unO-FoZP0iJHu12QEnBXMI1e]]></MediaId>
# <ThumbMediaId><![CDATA[rICSe9dN0_E2XdSKrLBzHpOJAy7y-GZ8i1VLHGfdlxkmzFXzEnprXeUxxaIPvMQn]]></ThumbMediaId>
# <MsgId>6176590368349391235</MsgId>
# </xml>
ShortVideo = Class.new(Msg)

# <xml>
# <ToUserName><![CDATA[gh_ac0d6ee46c9b]]></ToUserName>
# <FromUserName><![CDATA[of16As7gvnOiqK9ZBxyhAwUMMBQY]]></FromUserName>
# <CreateTime>1438099691</CreateTime>
# <MsgType><![CDATA[location]]></MsgType>
# <Location_X>31.347161</Location_X>
# <Location_Y>121.357157</Location_Y>
# <Scale>15</Scale>
# <Label><![CDATA[上海市宝山区菊太路1198弄1~10号]]></Label>
# <MsgId>6176591141443504546</MsgId>
# </xml>
class Location < Msg
  def Location_X
    @source.Location_X.to_f
  end

  def Location_Y
    @source.Location_Y.to_f
  end

  def Scale
    @source.Scale.to_i
  end
end

# <xml>
# <ToUserName><![CDATA[gh_ac0d6ee46c9b]]></ToUserName>
# <FromUserName><![CDATA[of16As7gvnOiqK9ZBxyhAwUMMBQY]]></FromUserName>
# <CreateTime>1438099792</CreateTime>
# <MsgType><![CDATA[link]]></MsgType>
# <Title><![CDATA[幼儿急疹 - 妈妈该怎么做]]></Title>
# <Description><![CDATA[]]></Description>
# <Url><![CDATA[http://mp.weixin.qq.com/s?__biz=MzAxMzYzNzA5NA==&mid=211221562&idx=1&sn=8fff09f75cca2d298913767c19a72716#rd]]></Url>
# <MsgId>6176591575235201458</MsgId>
# </xml>
Link = Class.new(Msg)

# <xml>
# <ToUserName><![CDATA[gh_ac0d6ee46c9b]]></ToUserName>
# <FromUserName><![CDATA[of16As7gvnOiqK9ZBxyhAwUMMBQY]]></FromUserName>
# <CreateTime>1438100374</CreateTime>
# <MsgType><![CDATA[event]]></MsgType>
# <Event><![CDATA[subscribe]]></Event>
# <EventKey><![CDATA[]]></EventKey>
# </xml>
Event = Class.new(Msg)
