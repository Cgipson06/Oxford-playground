class PhotosController < ApplicationController
  def new
    @photo = Photo.new
  end
  
  def create
    @photo = Photo.new
    # if user upload file
    if params[:photo][:picture].present?
      @photo.source =  params[:photo][:picture]
      @photo.save
      api_list(@photo)
    # if user adds url to get file from
    elsif params[:photo][:url] != ""
      @photo.source = URI.parse(params[:photo][:url])
      @photo.save
      api_list(@photo)
    else
      redirect_to new_photo_path and return 
    end
    
    if @photo.save
        redirect_to photo_path(@photo)
    else
        alert("There was a problem processing your photo.  Please try a different photo.")
    end
  end
  
  def show
    @photo = Photo.find(params[:id])  
    @description = ActiveSupport::JSON.decode(@photo.description)
    if @photo.details
        @details = ActiveSupport::JSON.decode(@photo.details)
    end
    @rectangles = @description.count 
    #gon gem to pass variables to javascript
    gon.description = @description
    gon.details = @details
        
  end
  
end
