class Photo < ActiveRecord::Base
  has_attached_file :source, styles: { original: "480x720>" }
  validates_attachment_content_type :source, content_type: /\Aimage\/.*\Z/
end
