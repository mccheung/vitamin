module PushHelper
  class << self
    def push_new_item(item)
      event = Instapush::Event.new 'new_item'
      event.tracker = {
        :nickname => item.profile.nickname,
        :item_name => item.name,
        :item_num => item.num
      }
      $instapush.push event
    end

    def push_signups(user)
      event = Instapush::Event.new 'signups'
      event.tracker = { :nickname => user.profile.nickname }
      $instapush.push event
    end
  end
end
