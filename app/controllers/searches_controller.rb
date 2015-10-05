class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_jssdk

  def new
    @query = Query.new
    @total = Item.total
    @top_queries = $namespaced_redis.zrevrange :queries, 0, 9
  end

  def index
    @query = Query.new(query_params)

    page = params[:page]

    if params['sort_by'].nil? && !@query.str.blank?
      now = DateTime.now
      ttl = now.next_week.to_i - now.to_i
      $namespaced_redis.multi do |multi|
        multi.zincrby :queries, 1, @query.str
        multi.expire :queries, ttl
      end
    end

    if params['sort_by'] == 'num'
      @resp = Item.search_by_num(@query, current_user.id).page(page)
    else
      @resp = Item.search_by_distance(@query, current_user.id).page(page)
    end

    @results = @resp.results.map { |r|
      r._source.merge distance: r.fields.distance[0]
    }

    if page
      render :page, layout: false
    else
      render :index
    end
  end

  private

  def query_params
    params.require(:query).permit(:str, :longitude, :latitude)
  end

  def set_jssdk
    @hash = Wechat.api.jsapi_ticket.signature(request.original_url)
  end
end
