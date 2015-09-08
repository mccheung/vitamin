class AddItemOpenBuyFromExpire < ActiveRecord::Migration
  def change
    add_column :items, :opened, :boolean, default: false, after: :num
    add_column :items, :buy_from, :string, default: "", after: :opened
    add_column :items, :expire_at, :datetime, after: :buy_from
  end
end
