class Admin::UploadController < ApplicationController

  #protect_from_forgery :except => [:upload]
  skip_before_filter :verify_authenticity_token

  def index
    @files = UploadFile.find(:all)
  end
  
  def upload
    @file = params[:file]
    @filename = params[:file].original_filename
    post = UploadFile.create(@file)
    redirect_to :action => "index"
  end
  
  def delete
    f = UploadFile.find(params[:file])
    f[0].delete
    redirect_to :action => "index"
  end

end
