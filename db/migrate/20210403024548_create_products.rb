class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.decimal :price
      t.string :image
      t.string :brand
      t.string :title
      t.decimal :review_score

      t.timestamps
    end
  end
end
