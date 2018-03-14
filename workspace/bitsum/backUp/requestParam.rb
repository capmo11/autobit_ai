require 'rubygems'
require 'watir'
require 'time'
require 'timeout'
require 'net/https'
require 'uri'
require 'Win32API'
require 'auto_click'


class RequestParam
  
  puts 'a'
  #https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=323422607&text=hihi%0d%0aThanks%0d%0aok
  
  uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=323422607&text=hihi%0d%0aThanks%0d%0aok')
  Net::HTTP.get(uri)
  
   puts '***** [ Targeting ... Search...!! Volumn Top Best.. ] *****'
   #jsonValue =""
   #uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage')
   #params = { :chat_id => '323422607', :text => "hihi%0d%0aThanks%0d%0aok" }
   #uri.query = URI.encode_www_form(params)
   #res = Net::HTTP.get_response(uri)
end