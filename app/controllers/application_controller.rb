class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :photo_emotions
  helper_method :photo_genders
  def api_list(photo)
    
    photo.description = photo_emotions
    photo.details = photo_genders
  
  end
  def photo_emotions
    uri = URI('https://api.projectoxford.ai/emotion/v1.0/recognize')
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Ocp-Apim-Subscription-Key'] = ENV['OXFORD-API-KEY']
    request['Content-Type'] = 'application/json'
    request.body = "{'url' : '" + @photo.source.url + "'}"
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
       http.request(request)
        end
    #insert check
    return response.body
  end
  
  def photo_genders 
    uri2 = URI('https://api.projectoxford.ai/vision/v1/analyses?visualFeatures=Faces')
    request2 = Net::HTTP::Post.new(uri2.request_uri)
    request2['Ocp-Apim-Subscription-Key'] = ENV['OXFORD-VISION-KEY']
    request2['Content-Type'] = 'application/json'
    request2.body = "{'url' : '" + @photo.source.url + "'}"
    response2 = Net::HTTP.start(uri2.host, uri2.port, :use_ssl => uri2.scheme == 'https') do |http|
       http.request(request2)
        end
    return response2.body
    
  end
    
end
