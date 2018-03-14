

require 'rubygems'
require 'watir'
require 'time'
require 'timeout'
require 'net/https'
require 'uri'
require 'Win32API'
require 'auto_click'
require 'json'
require 'win32/sound'
include Win32



class CoinVolumnBest
  
  #TODO 크롬 , 인터넷IE 로직도 추가
   #initialize :: param setting
   attr_accessor :server, :loginId, :loginPw, :watir , :bandloop_Cnt , :exceptionCnt
   
   def initialize()
     time1 = Time.new
     puts "Current Time : " + time1.inspect
     @loginId = loginId
     @loginPw = loginPw
     @server = 'http://www.bithumb.com/'
     @watir = Watir::Browser.new :firefox #chrome 
     @watir.goto "#{@server}"
     @bandloop_Cnt = 0
     @exceptionCnt = 0
     #@watir.window.resize_to(600, 700)
     puts "initialize setting!"
     #puts '[' +"#{@bandList_Array}".length.to_s   + ']' 
   end
   
  def start
    
    
 
   
      
       
    begin
    
      
      
   beforeArray = {}
   nowArray = {}
   countValue = 0  
      
    while true
      
     
      
    
    
      sleep(3)
      @watir.goto 'https://www.bithumb.com'
      sleep(3)
      @watir.select_list(:id => 'selectRealTick').option(:index, 3).select
      sleep(1)
      @watir.span(:id=>'assetRealBTC2KRW' ).click
      
      sleep(5)    
      
       if ( beforeArray.empty? )
           puts 'init setting.. beforeArray'
           beforeArray = {"BCH"=>1, "BTC"=>10, "DASH"=>3, "ETC"=>4, "ETH"=>5, "LTC"=>6, "QTUM"=>7, "XMR"=>8, "XRP"=>9, "ZEC"=>2}
       end        
         
       puts beforeArray.delete_at(2).length
       
       btcValue = @watir.span(:id=>'assetRealBTC2KRW' ).text.gsub(/[^\d]/, '').to_i 
       ethValue = @watir.span(:id=>'assetRealETH2KRW' ).text.gsub(/[^\d]/, '').to_i 
       dashValue = @watir.span(:id=>'assetRealDASH2KRW').text.gsub(/[^\d]/, '').to_i 
       ltcValue = @watir.span(:id=>'assetRealLTC2KRW' ).text.gsub(/[^\d]/, '').to_i 
       etcValue = @watir.span(:id=>'assetRealETC2KRW' ).text.gsub(/[^\d]/, '').to_i 
       xrpValue = @watir.span(:id=>'assetRealXRP2KRW' ).text.gsub(/[^\d]/, '').to_i 
       bchValue = @watir.span(:id=>'assetRealBCH2KRW' ).text.gsub(/[^\d]/, '').to_i 
       xmrValue = @watir.span(:id=>'assetRealXMR2KRW' ).text.gsub(/[^\d]/, '').to_i 
       zecValue = @watir.span(:id=>'assetRealZEC2KRW' ).text.gsub(/[^\d]/, '').to_i 
       qtumValue = @watir.span(:id=>'assetRealQTUM2KRW').text.gsub(/[^\d]/, '').to_i 
     
       listValue = { "BTC"=> btcValue , "ETH" =>  ethValue , "DASH" => dashValue , "LTC" =>ltcValue ,"ETC"  =>etcValue,"XRP" =>xrpValue,"BCH" => bchValue,"XMR" =>xmrValue ,"ZEC"  =>zecValue, "QTUM"  =>qtumValue}
       arrayRank = {}
       countValue = 0    
       listValue.sort_by {|k,v| v}.reverse.each do |key, value|
          countValue = countValue+1
          arrayRank[key] = countValue
       end
       nowArray = arrayRank

       
       
    
       
        
      
        
        
        
        result = {}
        beforeArray.each {|k, v| result[k] = nowArray[k] if nowArray[k] != v }
   
        result2 = result.sort_by{ |x| x.last }.to_h
         
        
        beforeArray = nowArray  
          
        if( !result2.empty? )
              Sound.beep(5000,500) # play a beep 600 hertz for 200 milliseconds
              puts '***************Change Rank...****************'
              result2.each do |key, value|
              puts '***************Key Value...****************'
              puts key
              puts value
              puts '***************Key Value...****************'
              puts '***************Change Rank...****************'
              end
        else
          puts 'Rank holding...'
          puts listValue
          puts beforeArray
          puts nowArray
          sleep(2)
        end
        
        
        nowArray
     
        
        

       
     
       
      #h3 = { "a" => 3 }
      #h3["b"]=5  
        
      #(beforeArray.keys & nowArray.keys).each {|k| puts 'Result ::'+( beforeArray[k] == nowArray[k] ? beforeArray[k] : k ) }
        
      #beforeArray = nowArray
      #puts 'before'  
      #puts beforeArray
      #puts 'now'
      #puts nowArray
      #nowArray.clear
      
      
      
      
     end
     rescue
       self.start 
     puts 'error'
   end 
    
   # {"BCH"=>9399060155, "BTC"=>2603241157, "ETC"=>2164481285, "LTC"=>2164481285, "DASH"=>1038448996, "ETH"=>509666754, "XRP"=>362889257, "QTUM"=>200472265, "ZEC"=>101484164, "XMR"=>90611004}

   
  end
   
end



doTask = CoinVolumnBest.new() 
doTask.start