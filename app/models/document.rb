class Document < ApplicationRecord
  belongs_to :comparison
  # Remember that the :path and :url have to align so that the file path and URL path match and the file is served by your web server.
  # It’s best to modify the path only if the local filesystem prefix is different than the ‘public’ folder in the root of your Rails application directory.
  has_attached_file :file, path: ":rails_root/public/uploads:url",
                           url: "/:comparison_id/:filename"
  validates_attachment :file, presence: true, content_type: { content_type: "application/pdf" }, size: { in: 0..999.kilobytes }
  
  
  Paperclip.interpolates :comparison_id do |attachment, style|
    attachment.instance.comparison_id
  end
  
  
  # Alias for paperclip method. 
  # 'file_file_name' looks weird.
  def file_name
    file_file_name
  end
  
end


# Comparison.all.each do |comp|
#   comp.documents.each do |doc|
#     doc.destroy
#   end
#
#   comp.destroy
# end

