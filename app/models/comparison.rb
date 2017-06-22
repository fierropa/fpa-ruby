class Comparison < ApplicationRecord
  attr_reader :exit_status_msg
  has_many :documents
  accepts_nested_attributes_for :documents, allow_destroy: true
  
  
  def run
    puts "\npdf1 #{self.documents.first.file.url}"
    puts "pdf2 #{self.documents.last.file.url} \n"
    system "source ~/.virtualenvs/fpa/bin/activate"
    @exit_status_msg = `vendor/utils/pdf-diff resume_pdf.pdf resume_pdf_updated.pdf > comparison_output.png`
    return false if $?.exitstatus > 0
    true
  end
  
end
