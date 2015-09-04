class AddItemNum < ActiveRecord::Migration
  def change
    add_column :items, :num, :integer, after: :intro
  end
end
