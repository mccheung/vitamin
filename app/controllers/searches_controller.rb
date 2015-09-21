class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_jssdk

  def new
    @query = Query.new
  end

  def show
    @query = Query.new(query_params)
    if params['sort_by'] == 'num'
      @resp = Item.search_by_num(@query).page(params[:page])
    else
      @resp = Item.search_by_distance(@query).page(params[:page])
    end

    @results = @resp.results.map { |r|
      r._source.merge distance: r.fields.distance[0]
    }
  end

  private

  def query_params
    params.require(:query).permit(:str, :longitude, :latitude)
  end

  def set_jssdk
    @hash = Wechat.api.jsapi_ticket.signature(request.original_url)
  end
end
