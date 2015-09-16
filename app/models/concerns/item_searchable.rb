module ItemSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name [Rails.application.engine_name, Rails.env].join('_')

    after_commit on: [:create, :update] do
      ItemIndexer.perform_async(:index,  self.id)
    end

    after_commit on: [:destroy] do
      ItemIndexer.perform_async(:delete, self.id)
    end

    mapping dynamic: 'strict' do
      indexes :name
      indexes :intro
      indexes :remark
      indexes :num, type: 'integer'
      indexes :buy_from, index: 'no'
      indexes :remark, index: 'no'
      indexes :opened, type: 'boolean'

      # profile
      indexes :profile do
        indexes :nickname, index: 'no'
        indexes :address,  index: 'no'
        indexes :location, type: 'geo_point'
      end
    end

    def as_indexed_json(options={})
      hash = as_json(
        only: [:name, :intro, :num, :buy_from, :remark, :opened],
        include: { profile: {only: [:nickname, :address]} }
      )
      hash['profile']['location'] = self.profile.location
      hash
    end

    def self.search(query)
      str = query.str
      longitude = query.longitude.to_f
      latitude = query.latitude.to_f

      @search_definition = {
        fields: [
          "_source"
        ],
        query: {
          filtered: {
            query: {
              multi_match: {
                query: str,
                fields: ["name", "intro"]
              }
            },
            filter: {
              geo_distance: {
                distance: "1000km",
                location: [
                  longitude,
                  latitude
                ]
              }
            }
          }
        },
        script_fields: {
          distance: {
            script: "doc['location'].distanceInKm(lat, lon)",
            params: {
              lat: latitude,
              lon: longitude
            }
          }
        }
      }
      resp = __elasticsearch__.search(@search_definition)
      resp.results.map { |r|
        r._source.merge distance: r.fields.distance[0]
      }
    end
  end
end
