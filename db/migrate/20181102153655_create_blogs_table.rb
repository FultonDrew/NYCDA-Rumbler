class CreateBlogsTable < ActiveRecord::Migration[5.2]
  def change
  	create_table :blogs do |t|
  		t.string :title
  		t.string :content
  		t.string :image
  		t.boolean :likes
  		t.integer :user_id
  end
end
end