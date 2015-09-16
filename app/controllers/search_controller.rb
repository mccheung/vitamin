require 'wechat'

class SearchController < ApplicationController
  include Wechat
  
  before_action :authenticate_user!
  before_action :set_jssdk

  def new
    @query = Query.new
  end

  def create
    @query = Query.new(query_params)
    @results = Item.search(@query)
  end

  private

  def query_params
    params.require(:query).permit(:str, :longitude, :latitude)
  end
end
