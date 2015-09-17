class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_jssdk

  def new
    @query = Query.new
  end

  def show
    @query = Query.new(query_params)
    @results = Item.search_by_distance(@query)
  end

  private

  def query_params
    params.require(:query).permit(:str, :longitude, :latitude)
  end

  def set_jssdk
    @hash = Wechat.api.jsapi_ticket.signature(request.original_url)
  end
end
