class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :photoset_id

      t.timestamps
    end
  end
end
