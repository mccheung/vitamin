class ProfileIndexer
  include Sidekiq::Worker
  sidekiq_options queue: 'profile_indexer', retry: false

  def perform(operation, record_id)
    case operation.to_s
    when /update/
      profile = Profile.find(record_id)
      items = profile.items
      return if items.empty?
      Item.__elasticsearch__.client.bulk index: Item.index_name,
                                         type: Item.document_type,
                                         body: prepare_items(items, profile)
    else
      raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end

  private

  def prepare_items(items, profile)
    items.map do |item|
      doc = item.as_indexed_json
      {index: {_id: item.id, data: doc}}
    end
  end
end
