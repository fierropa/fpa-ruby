class Document < ApplicationRecord
  belongs_to :comparison
  has_attached_file :file
  validates_attachment :file, 
                       path: ":rails_root/public/uploads/comparisons/:comparison_id/:filename",
                       presence: true, 
                       content_type: { content_type: "application/pdf" }, 
                       size: { in: 0..999.kilobytes }
end
