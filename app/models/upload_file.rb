class UploadFile < ActiveRecord::Base

  @@directory = "public/upload"
  attr_accessor :file, :filename

  def initialize(filename="", directory=@@directory)
    path = File.join(directory, filename)
    self.file = File.new(path, "r+")
    self.filename = File.basename(self.file.path)
  end
  
  def self.find(pattern="")
    files = self.cleanup_files(Dir.new(@@directory).entries)
    files = self.filter_files(files, pattern)
    dataFiles = []
    files.each do |f|
      dataFiles.push(DataFile.new(f))
    end
    return dataFiles
  end
  
  def self.create(file, directory=@@directory)
    # create directory if it doesn't exist
    # if it does continue uploading the files
    filename = file.original_filename.gsub(" ", "_")
    path = File.join(directory, filename)
    File.open(path, "w+") { |f| f.write(file.read) }
    return DataFile.new(filename)
  end
  
  def delete
    begin
      File.delete(self.file.path)
      return true
    rescue
      return false
    end
  end
  
  def self.cleanup_files(filesArray)
    filesArray.delete(".")
    filesArray.delete("..")
    return files
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
