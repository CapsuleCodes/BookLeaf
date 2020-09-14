class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.string :image_url

      t.timestamps null: false
    end
  end
end
