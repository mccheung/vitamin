class SearchController < ApplicationController
  before_action :authenticate_user!
  before_action :set_jssdk

  def new
    @query = Query.new
  end

  def create
    @query = Query.new(query_params)
    @results = Item.search(@query)
  end

  protected

  def query_params
    params.require(:query).permit(:str, :longitude, :latitude)
  end

  def set_jssdk
    # TODO dirty code
    @hash = WechatController.wechat.jsapi_ticket.signature(request.original_url)
  end
end
