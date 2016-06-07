class CreateReviews < ActiveRecord::Migration
  def change

    create_table :restarants do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :reviews do |t|
      t.string :title
      t.string :body
      t.belongs_to :restaurant
      t.string :restaurant_name
      t.timestamps null: false
    end
  end
end
