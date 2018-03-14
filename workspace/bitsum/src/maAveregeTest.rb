require 'rubygems'
require 'watir'
require 'time'
require 'timeout'
require 'net/https'
require 'uri'
require 'Win32API'
require "selenium-webdriver"
#require 'auto_click'
#require 'win32/sound'
require 'open3'
require 'telegram/bot'

class MaAveregeTest
  
  
  
  
  puts 1341531.00.to_i.to_s
  
  #def insert_comma(string)
  #    return string.gsub(/(\d)(?=(?:\d\d\d)+(?!\d))/, ‘\1,’);
  #end
  
  
     chatReal= -1001189596297  
     chatTest = -1001364815243 
     puts -1001364815243.to_s
  
  uri = URI.parse( URI.encode('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id='+chatTest.to_s+'&text=방가
    방가') )
  Net::HTTP.get(uri)
  
  
  return 
  
  puts "123.000".gsub(/\d/, "") .gsub(".","").length     

  
  a= "넥서스\nNXS/BTC"
  
  puts  a[0..a.index("\n")]
  
  
  
  nMvAvgSrtVal =    {"MA120"=>"9986.8177", "MA5"=>"9570.1800", "MA60"=>"9430.3673", "MA240"=>"12573.4691", "MA20"=>"10370.3119"}
  nowTranSortValue = {}  
  arrayRank = {}
  countValue = 0    
  nMvAvgSrtVal.sort_by {|k,v| v}.reverse.each do |key, value|
     countValue = countValue + 1
     nMvAvgSrtVal[key] = value
     nowTranSortValue[key]  = value  
  end
  
 puts nowTranSortValue
  
text = ""
nMvAvgSrtVal.each do |key, value|
           text+= key +' : '+ value + '%0d%0a'
end   
puts text 

 puts    nowTranSortValue["MA5"] == 5 && nowTranSortValue["MA20"] == 4 && nowTranSortValue["MA60"] == 3 && nowTranSortValue["MA120"] == 2  && nowTranSortValue["MA240"] == 1 #정배열
 puts    nowTranSortValue["MA5"] == 1 && nowTranSortValue["MA20"] == 2 && nowTranSortValue["MA60"] == 3 && nowTranSortValue["MA120"] == 4  && nowTranSortValue["MA240"] == 5 #역배열
  
puts nMvAvgSrtVal.key(1).to_s+' : '+nMvAvgSrtVal[nMvAvgSrtVal.key(1)].to_s+'%0d%0a' +nMvAvgSrtVal.key(2).to_s+' : '+nMvAvgSrtVal[nMvAvgSrtVal.key(2)].to_s+'%0d%0a' +nMvAvgSrtVal.key(3).to_s+' : '+nMvAvgSrtVal[nMvAvgSrtVal.key(3)].to_s+'%0d%0a'+nMvAvgSrtVal.key(4).to_s+' : '+nMvAvgSrtVal[nMvAvgSrtVal.key(4)].to_s+'%0d%0a'+nMvAvgSrtVal.key(5).to_s+' : '+nMvAvgSrtVal[nMvAvgSrtVal.key(5)].to_s
   
   
  
end