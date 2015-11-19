class AddColumnUrlToPhoto < ActiveRecord::Migration
  def change
    change_table  :photos do |t|
      t.string :url
    end
  end
end
