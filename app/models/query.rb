class Query
  include ActiveModel::Model
  attr_accessor :str, :longitude, :latitude

  def initialize(attributes={})
    super
    @longitude ||= 121.356
    @latitude ||= 31.3427
  end
end
