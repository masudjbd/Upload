namespace :radiant do
  namespace :extensions do
    namespace :upload do
      
      desc "Runs the migration of the Upload extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          UploadExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          UploadExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Upload to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from UploadExtension"
        Dir[UploadExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(UploadExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
