class Admin::UploadController < ApplicationController

  #protect_from_forgery :except => [:upload]
  skip_before_filter :verify_authenticity_token

  def index
    @files = DataFile.find
  end
  
  def upload
    @file = params[:file]
    @filename = params[:file].original_filename
    post = DataFile.create(@file)
    redirect_to :action => "index"
  end
  
  def delete
    f = DataFile.find(params[:file])
    f[0].delete
    redirect_to :action => "index"
  end

end
