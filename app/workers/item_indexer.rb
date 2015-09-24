class ItemIndexer
  include Sidekiq::Worker
  sidekiq_options queue: 'item_indexer', retry: false

  def perform(operation, record_id)
    logger.debug [operation, "ID: #{record_id}"]

    case operation.to_s
    when /index/
      record = Item.find(record_id)
      Item.__elasticsearch__.client.index index: Item.index_name,
                                          type: Item.document_type,
                                          id: record.id,
                                          body: record.as_indexed_json
    when /delete/
      Item.__elasticsearch__.client.delete index: Item.index_name,
                                           type: Item.document_type,
                                           id: record_id
    else
      raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
