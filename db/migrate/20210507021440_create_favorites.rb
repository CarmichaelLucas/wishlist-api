class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :list
      t.references :product

      t.timestamps
    end
  end
end
