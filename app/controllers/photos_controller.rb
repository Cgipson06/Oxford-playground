class PhotosController < ApplicationController
  def new
    @photo = Photo.new
  end
  
  def create
    @photo = Photo.new
    
    uri = URI('https://api.projectoxford.ai/emotion/v1.0/recognize')
    request = Net::HTTP::Post.new(uri.request_uri)
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = ENV['OXFORD-API-KEY']
    request['Content-Type'] = 'application/json'
    # if user upload file
    if params[:photo][:picture].present?
      @photo.source =  params[:photo][:picture]
      @photo.save
      # Request body
      request.body = "{'url' : '" + @photo.source.url + "'}"
    # if user adds url to get file from
    elsif params[:photo][:url].present?
      @photo.source = URI.parse(params[:photo][:url])
      @photo.save
      # Request body
      request.body = "{'url' : '" + @photo.source.url + "'}"
    else
      flash[:error]= "Please upload or input a photo url to process"  
    end
    
   # send request to microsoft
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
       http.request(request)
    end
    # need a check for failed requests ~~ if response.body = []
    #currently fails on failed responses
    @photo.description = response.body
    if @photo.save
        puts response.body
        redirect_to photo_path(@photo)
    end
  end
  
  def show
    @photo = Photo.find(params[:id])  
    @description = ActiveSupport::JSON.decode(@photo.description)
    @rectangles = @description.count 
    gon.description = @description
    gon.jsonDescription = @description
        
  end
  
end
