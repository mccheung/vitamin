# coding: utf-8
class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_jssdk, only: [:new]

  # GET /items
  # GET /items.json
  def index
    @items = current_user.items
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
    @item.num = 1
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.find_or_initialize_by(
      {
        name: item_params['name'].strip,
        user_id: current_user.id
      })

    @item.num += item_params['num'].to_i

    respond_to do |format|
      if @item.save
        format.html { redirect_to items_url, notice: '添加药品成功' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to items_url, notice: '修改药品成功' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: '删除药品成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:name, :intro, :num)
  end

  def set_jssdk
    @app_id = $wechat_app_id
    @timestamp = Time.now.to_i
    @nonce = SecureRandom.hex
    @url = request.original_url
    jsapi_ticket = $redis.get "jsapi_ticket:#{$wechat_app_id}"
    @signature = WechatHelper.jssdk_signature(
      jsapi_ticket, @timestamp, @nonce, @url)
  end
end
