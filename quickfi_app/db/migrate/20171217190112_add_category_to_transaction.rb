class AddCategoryToTransaction < ActiveRecord::Migration[5.0]
  def change
    add_reference :transactions, :category, foreign_key: true
  end
end
