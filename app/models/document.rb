class Document < ApplicationRecord
  belongs_to :comparison
  has_attached_file :file, path: ":rails_root/public/uploads/comparisons/:comparison_id/:filename"
  validates_attachment :file, presence: true, content_type: { content_type: "application/pdf" },  size: { in: 0..999.kilobytes }
end
