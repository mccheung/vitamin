class ProfileIndexer
  include Sidekiq::Worker
  sidekiq_options queue: 'profile_indexer', retry: false

  def perform(operation, record_id)
    case operation.to_s
    when /update/
      profile = Profile.find(record_id)
      item_ids = profile.item_ids
      return if item_ids.empty?
      Item.__elasticsearch__.client.bulk index: Item.index_name,
                                         type: Item.document_type,
                                         body: prepare_items(item_ids, profile)
    else
      raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end

  private

  def prepare_items(item_ids, profile)
    doc = {
      profile: {
        nickname: profile.nickname,
        address: profile.address,
        location: profile.location
      }
    }
    item_ids.map do |item_id|
      {update: {_id: item_id, data: {doc: doc}}}
    end
  end
end
