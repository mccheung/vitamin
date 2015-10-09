class ProfileIndexer
  include Sidekiq::Worker
  sidekiq_options queue: :elasticsearch, retry: false

  def perform(operation, record_id)
    case operation.to_s
    when /update/
      profile = Profile.find(record_id)
      Item.import_all_by_profile(profile)
    else
      raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
