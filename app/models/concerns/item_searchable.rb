# coding: utf-8
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
      indexes :user_id, type: 'integer'

      # profile
      indexes :profile do
        indexes :nickname, index: 'no'
        indexes :address,  index: 'no'
        indexes :location, type: 'geo_point'
      end
    end

    def as_indexed_json(options={})
      hash = as_json(
        only: [:name, :intro, :num, :buy_from, :remark, :opened, :user_id],
        include: { profile: {only: [:nickname, :address]} }
      )
      hash['profile']['location'] = self.profile.location
      hash
    end

    # 按距离排序
    def self.search_by_distance(query, exclude_user_id)
      str = query.str
      longitude = query.longitude.to_f
      latitude = query.latitude.to_f

      definition = Elasticsearch::DSL::Search.search do
        query do
          bool do
            must do
              multi_match do
                query str
                fields %w[ name intro ]
              end
            end

            must_not do
              term user_id: exclude_user_id
            end
          end
        end

        sort do
          by :_geo_distance, location: [longitude, latitude], order: 'asc', unit: 'km', distance_type: 'plane'
        end

        fields ['_source']

        script_fields distance: {
                        script: "doc['location'].distanceInKm(lat, lon)",
                        params: {lat: latitude, lon:longitude}
                      }
      end

      __elasticsearch__.search definition
    end

    # 按数量排序，如果数量相同就按距离排序
    def self.search_by_num(query, exclude_user_id)
      str = query.str
      longitude = query.longitude.to_f
      latitude = query.latitude.to_f

      definition = Elasticsearch::DSL::Search.search do
        query do
          bool do
            must do
              multi_match do
                query str
                fields %w[ name intro ]
              end
            end

            must_not do
              term user_id: exclude_user_id
            end
          end
        end

        sort do
          by :num, order: 'desc'
          by :_geo_distance, location: [longitude, latitude], order: 'asc', unit: 'km', distance_type: 'plane'
        end

        fields ['_source']

        script_fields distance: {
                        script: "doc['location'].distanceInKm(lat, lon)",
                        params: {lat: latitude, lon:longitude}
                      }
      end

      __elasticsearch__.search(definition)
    end

    # 智能排序，数量优先，距离递减
    def self.search_by_recommend(query)
      str = query.str
      longitude = query.longitude.to_f
      latitude = query.latitude.to_f

      definition = Elasticsearch::DSL::Search.search do
        query do
          function_score do
            query do
              filtered do
                query do
                  multi_match do
                    query str
                    fields %w[ name intro ]
                  end
                end

                filter do
                  geo_distance :location do
                    lat latitude
                    lon longitude
                    distance "50km"
                  end
                end
              end
            end

            functions << {
              gauss: {
                location: {
                  origin: [longitude, latitude],
                  offset: '5km',
                  scale: '10km'
                }
              }
            }

            functions << {
              field_value_factor: {
                field: "num",
                factor: 0.1,
                modifier: "log1p"
              },
              weight: 2
            }

            boost_mode "replace"
          end
        end

        fields ['_source']

        script_fields distance: {
                        script: "doc['location'].distanceInKm(lat, lon)",
                        params: {lat: latitude, lon:longitude}
                      }
      end

      __elasticsearch__.search(definition)
    end

  end
end
