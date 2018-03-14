

require 'rubygems'
require 'watir'
require 'time'
require 'timeout'
require 'net/https'
require 'uri'
require 'Win32API'
require 'auto_click'
require 'json'



class CoinVolumnBest
  
  def initialize()
    puts "initialize setting!"
    #puts '[' +"#{@bandList_Array}".length.to_s   + ']' 
    result = '1,2,3,4,'.gsub(/[^\d]/, '')
    puts result
  end
  
  def start
    #https://api.bithumb.com/public/ticker/ALL
    jsonValue =""
    uri = URI('https://api.bithumb.com/public/ticker/ALL')
    params = { :limit => 10, :page => 3 }
    uri.query = URI.encode_www_form(params)
    
    res = Net::HTTP.get_response(uri)
    puts res.body if res.is_a?(Net::HTTPSuccess)
    jsonValue = res.body
    puts jsonValue
    data_hash =  JSON.parse(jsonValue)
    puts JSON.parse(jsonValue).keys
    puts data_hash['status']
    puts 'BTC=>'+ sv1 = ( data_hash['data']['BTC']['volume_1day'].to_f * data_hash['data']['BTC']['closing_price'].to_f ).to_s
    puts sv1 = data_hash['data']['ETH']['volume_1day'].to_f * data_hash['data']['ETH']['closing_price'].to_f
    puts sv1 = data_hash['data']['DASH']['volume_1day'].to_f * data_hash['data']['DASH']['closing_price'].to_f
    puts sv1 = data_hash['data']['LTC']['volume_1day'].to_f * data_hash['data']['LTC']['closing_price'].to_f
    puts sv1 = data_hash['data']['ETC']['volume_1day'].to_f * data_hash['data']['ETC']['closing_price'].to_f
    puts sv1 = data_hash['data']['XRP']['volume_1day'].to_f * data_hash['data']['XRP']['closing_price'].to_f
    puts sv1 = data_hash['data']['BCH']['volume_1day'].to_f * data_hash['data']['BCH']['closing_price'].to_f
    puts sv1 = data_hash['data']['XMR']['volume_1day'].to_f * data_hash['data']['XMR']['closing_price'].to_f
    puts sv1 = data_hash['data']['ZEC']['volume_1day'].to_f * data_hash['data']['ZEC']['closing_price'].to_f
    puts sv1 = data_hash['data']['QTUM']['volume_1day'].to_f * data_hash['data']['QTUM']['closing_price'].to_f
    
    #hash = {:item1 => 1}
    #hash[:item2] = 2
      
    volumn_hash = {"BTC" => data_hash['data']['BTC']['volume_1day'].to_f * data_hash['data']['BTC']['closing_price'].to_f } 
    volumn_hash["ETH"] = data_hash['data']['ETH']['volume_1day'].to_f * data_hash['data']['ETH']['closing_price'].to_f 
    volumn_hash["DASH"] =  data_hash['data']['DASH']['volume_1day'].to_f * data_hash['data']['DASH']['closing_price'].to_f    
    volumn_hash["LTC"] =data_hash['data']['LTC']['volume_1day'].to_f * data_hash['data']['LTC']['closing_price'].to_f    
    volumn_hash["ETC"] =data_hash['data']['ETC']['volume_1day'].to_f * data_hash['data']['ETC']['closing_price'].to_f    
    volumn_hash["XRP"] =data_hash['data']['XRP']['volume_1day'].to_f * data_hash['data']['XRP']['closing_price'].to_f    
    volumn_hash["BCH"] =data_hash['data']['BCH']['volume_1day'].to_f * data_hash['data']['BCH']['closing_price'].to_f    
    volumn_hash["XMR"] =data_hash['data']['XMR']['volume_1day'].to_f * data_hash['data']['XMR']['closing_price'].to_f   
    volumn_hash["ZEC"] =data_hash['data']['ZEC']['volume_1day'].to_f * data_hash['data']['ZEC']['closing_price'].to_f  
    volumn_hash["QTUM"] =data_hash['data']['QTUM']['volume_1day'].to_f * data_hash['data']['QTUM']['closing_price'].to_f  
    puts volumn_hash
    
    
    
    puts volumn_hash.sort.to_h 
    volumn_hash.sort.to_h 
    
 
        # record.some_field["data"] << {"name" => "C", "available" => "1"}
        arrayRank = {}
        countValue = 0    
        volumn_hash.sort.each do |key, value|
            countValue = countValue+1
            arrayRank[key] = countValue
        end
        
        puts arrayRank
      
    
       
     

   
       #uri = URI('https://api.coinone.co.kr/ticker/')
       #params = { :format => 'json', :currency => 'all' }
       #uri.query = URI.encode_www_form(params)
       #res = Net::HTTP.get_response(uri)
       #puts res.body if res.is_a?(Net::HTTPSuccess)
       #jsonValue = res.body
       #puts jsonValue
       #data_hash =  JSON.parse(jsonValue)
       #puts JSON.parse(jsonValue).keys
       #
       #volumn_hash2 = {"btc" => data_hash['btc']['volume'].to_f * data_hash['btc']['last'].to_f} 
       #volumn_hash2["eth"] = data_hash['eth']['volume'].to_f * data_hash['eth']['last'].to_f    
       #volumn_hash2["ltc"] =data_hash['ltc']['volume'].to_f * data_hash['ltc']['last'].to_f    
       #volumn_hash2["etc"] =data_hash['etc']['volume'].to_f * data_hash['etc']['last'].to_f    
       #volumn_hash2["xrp"] =data_hash['xrp']['volume'].to_f * data_hash['xrp']['last'].to_f    
       #volumn_hash2["bch"] =data_hash['bch']['volume'].to_f * data_hash['bch']['last'].to_f
       #volumn_hash2["qtum"] =data_hash['qtum']['volume'].to_f * data_hash['qtum']['last'].to_f  
       #puts volumn_hash2
       #puts volumn_hash2.sort.to_h 
       #volumn_hash2.sort.to_h 
        
      
      
    
  end
   
end



doTask = CoinVolumnBest.new() 
doTask.start