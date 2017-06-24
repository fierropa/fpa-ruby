class Comparison < ApplicationRecord
  attr_reader :exit_status_msg
  has_many :documents
  accepts_nested_attributes_for :documents, allow_destroy: true
  
  
  def documents_dir
    return Rails.root.join('public', 'images', 'comparisons', "#{id}") if Rails.env == 'development'
    File.join('/var', 'www', 'fpa', 'shared', 'public', 'images', 'comparisons', "#{id}")
  end
  
  def result_image_path
    File.join(documents_dir, 'comparison_output.png')
  end
  
  def result_image_url
    "comparisons/#{id}/comparison_output.png"
  end
  
  
  def run
    
    unless self.documents.size == 2
      @exit_status_msg = "The must be 2 files to compare, no more, mo less. Received #{self.documents.size}"
      return false
    end
    
    puts "\n\npdf1 #{self.documents.first.file.path}"
    puts "pdf2 #{self.documents.last.file.path} \n\n"
    
    source_virtualenv_path
    if $?.exitstatus > 0
      raise "I failed to activate python env. #{$?.exitstatus} \n virtualenv_path: #{virtualenv_path}"
      return false 
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
  
  
  private
  
    def source_virtualenv_path
      return (system "source ~/.virtualenvs/fpa/bin/activate") if Rails.env == 'development'
      source_env_from('/home/deploy/fpa/fpaenv/bin/activate')
    end
  
    def virtualenv_path
      return '~/.virtualenvs/fpa/bin/activate' if Rails.env == 'development'
      '~/fpa/fpaenv/bin/activate'
    end
    
    # Read in the bash environment, after an optional command.
    #   Returns Array of key/value pairs.
    def bash_env(cmd=nil)
      env = `#{cmd + ';' if cmd} printenv`
      env.split(/\n/).map {|l| l.split(/=/)}
    end

    # Source a given file, and compare environment before and after.
    #   Returns Hash of any keys that have changed.
    def bash_source(file)
      Hash[ bash_env(". #{File.realpath file}") - bash_env() ]
    end

    # Find variables changed as a result of sourcing the given file, 
    #   and update in ENV.
    def source_env_from(file)
      bash_source(file).each {|k,v| ENV[k] = v }
    end
  
end

