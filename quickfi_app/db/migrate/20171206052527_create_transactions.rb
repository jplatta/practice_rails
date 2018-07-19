class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.text :description
      t.string :category
      t.boolean :credit
      t.datetime :date
      t.references :user, foreign_key: true
      t.timestamps
    end

    add_index :transactions, [:user_id, :created_at]
  end
end
