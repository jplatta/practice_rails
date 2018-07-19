class RemoveCategoryFromTransaction < ActiveRecord::Migration[5.0]
  def change
    remove_column :transactions, :category, :string
  end
end
