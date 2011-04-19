require 'rubygems'
require 'sinatra'
require 'instagram'
require 'haml'
require 'dalli'
require 'yajl' 


CACHE = Dalli::Client.new

Instagram.configure do |config|
  config.client_id = 'bded657abe374e3da6ce4753286f6850'
  config.client_secret = '5dd01feba30d4d4f9b99f57d0212c34a'
end  

def getPhotos
  photos = Instagram.tag_recent_media('sun')
  photos.find_all{ |photo| photo.filter =!nil}.map { |photo| photo.images.low_resolution.url} 
end  


get '/' do
  @results = CACHE.fetch('sun', 800) { getPhotos() } 
  erb :index
end