class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table :words do |t|
      t.text :word
      t.text :definition

      t.timestamps
    end
  end
end
