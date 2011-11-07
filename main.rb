require 'rubygems'
require 'sinatra'
require 'instagram'
require 'haml'
require 'erb'
require 'dalli'
require 'yajl' 
require 'logger'

CACHE = Dalli::Client.new

Instagram.configure do |config|
  config.client_id = 'bded657abe374e3da6ce4753286f6850'
  config.client_secret = '5dd01feba30d4d4f9b99f57d0212c34a'   
end 

def log_to_file
  log = File.new("log/sinatra.log", "w")     
  STDOUT.reopen(log)                          
  STDERR.reopen(log) 
end

error 404 do
  haml :not_found
end  

def getPhotos
  photos = Instagram.tag_recent_media('sun') 
  puts photos 
  photos.find_all{ |photo| photo.filter =!nil}.map { |photo| photo.images.low_resolution.url}   
end  


get '/' do   
  @results = CACHE.fetch('sun', 900) { getPhotos() }    
  erb :index
end 
  
