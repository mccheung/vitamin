class ItemIndexer
  include Sidekiq::Worker
  sidekiq_options queue: :elasticsearch, retry: false

  def perform(operation, record_id)
    logger.debug [operation, "ID: #{record_id}"]

    case operation.to_s
    when /index/
      item = Item.find(record_id)
      return if item.profile.address.blank?
      Item.__elasticsearch__.client.index index: Item.index_name,
                                          type: Item.document_type,
                                          id: item.id,
                                          body: item.as_indexed_json
    when /delete/
      Item.__elasticsearch__.client.delete index: Item.index_name,
                                           type: Item.document_type,
                                           id: record_id
    else
      raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
