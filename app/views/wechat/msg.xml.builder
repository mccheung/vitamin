xml.instruct!
xml.xml {
  xml.ToUserName { xml.cdata! @to }
  xml.FromUserName { xml.cdata! @from }
  xml.MsgType { xml.cdata! @msg_type }
  xml.Content { xml.cdata! @content }
  xml.CreateTime Time.now.to_i
}
