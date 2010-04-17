require "FileUtils"

class UploadFile < ActiveRecord::Base

  @@directory = "public/upload"
  attr_accessor :file, :filename

  def initialize(filename="")
    path = File.join(@@directory, filename)
    self.file = File.new(path, "r+")
    self.filename = File.basename(self.file.path)
  end
  
  def self.find(pattern="")
    files = self.cleanup_files(Dir.new(@@directory).entries)
    files = self.filter_files(files, pattern)
    upload_files = []
    files.each do |f|
      upload_files.push(UploadFile.new(f))
    end
    return upload_files
  end
  
  def self.create(file)
    FileUtils.mkdir_p 'public/upload'
    filename = file.original_filename.gsub(" ", "_")
    path = File.join(@@directory, filename)
    File.open(path, "w+") { |f| f.write(file.read) }
    return UploadFile.new(filename)
  end
  
  def delete
    begin
      File.delete(self.file.path)
      return true
    rescue
      return false
    end
  end
  
  def self.cleanup_files(files_array)
    files_array.delete(".")
    files_array.delete("..")
    return files_array
  end
  
  def self.filter_files(files, pattern)
    new_files = []
    files.each do |f|
      if f.index(pattern)
        new_files.push(f)
      end
    end
    return new_files
  end

end
