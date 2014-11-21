class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :user_id
      t.text    :description
      t.timestamps
    end

    add_attachment :photos, :image

  end
end
