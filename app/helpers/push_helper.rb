module PushHelper
  class << self
    def push_new_item(user, item)
      event = Instapush::Event.new 'new_item'
      event.tracker = {
        :nickname => user.nickname,
        :item_name => item.name,
        :item_num => item.num
      }
      $instapush.push event
    end

    def push_signups(user)
      event = Instapush::Event.new 'signups'
      puts "nickname: #{user.nickname}"
      event.tracker = { :nickname => user.nickname }
      $instapush.push event
    end
  end
end
