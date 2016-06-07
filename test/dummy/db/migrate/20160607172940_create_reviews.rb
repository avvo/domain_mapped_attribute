class CreateReviews < ActiveRecord::Migration
  def change

    create_table :reviewers do |t|
      t.string :username
      t.timestamps null: false
    end

    create_table :restaurants do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :reviews do |t|
      t.string :title
      t.string :body
      t.belongs_to :restaurant
      t.string :restaurant_name
      t.belongs_to :reviewer
      t.string :reviewed_by
      t.timestamps null: false
    end
  end
end
