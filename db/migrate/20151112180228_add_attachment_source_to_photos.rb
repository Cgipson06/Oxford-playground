class AddAttachmentSourceToPhotos < ActiveRecord::Migration
  def self.up
    change_table :photos do |t|
      t.attachment :source
    end
  end

  def self.down
    remove_attachment :photos, :source
  end
end
