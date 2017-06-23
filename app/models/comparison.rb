class Comparison < ApplicationRecord
  attr_reader :exit_status_msg
  has_many :documents
  accepts_nested_attributes_for :documents, allow_destroy: true
  
  
  def documents_dir
    Rails.root.join('public', 'images', 'comparisons', "#{id}")
  end
  
  def result_image_path
    File.join(documents_dir, 'comparison_output.png')
  end
  
  def result_image_url
    "comparisons/#{id}/comparison_output.png"
  end
  
  
  def run
    raise self.documents.size unless self.documents.size == 2
    puts "\n\npdf1 #{self.documents.first.file.path}"
    puts "pdf2 #{self.documents.last.file.path} \n\n"
    
    
    system 'source ~/.virtualenvs/fpa/bin/activate'
    if $?.exitstatus > 0
      raise "I failed to activate python env. #{$?.exitstatus}"
    end
    
    system "mkdir #{documents_dir}"
    if $?.exitstatus > 0
      @exit_status_msg = "I failed to create #{documents_dir}, I am very sorry :'( #{$?.exitstatus}"
      raise @exit_status_msg
      return false 
    end
    
    system "cd vendor/utils/pdf-diff; pdf-diff #{self.documents.first.file.path} #{self.documents.last.file.path} > #{result_image_path}"
    if $?.exitstatus > 0
      @exit_status_msg = "I failed to switch directories, I am very sorry :'( #{$?.exitstatus}"
      raise @exit_status_msg
      return false 
    end

    true
  end
  
end

