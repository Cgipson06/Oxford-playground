class AddDetailsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :details, :string
  end
end
