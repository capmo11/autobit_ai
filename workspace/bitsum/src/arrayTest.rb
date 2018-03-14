require 'win32/sound'
require_relative './CoinDto.rb'
include Win32








class ArrayTest

  test = CoinDto.new()
  puts test.beforeBlueValue=()
  puts test.beforeBlueValue()
  
  

  #dto = CoinDto.new
  
  #dto.macdRedValue=("data")
  #puts dto.macdBlueValue()
  
  
  #Sound.beep(5000,500) # play a beep 600 hertz for 200 milliseconds
  #Sound.beep(1000,500) # play a beep 600 hertz for 200 milliseconds
  #Sound.beep(1000,700) # play a beep 600 hertz for 200 milliseconds
  #Sound.beep(1000,900) # play a beep 600 hertz for 200 milliseconds
  #Sound.beep(2000,900) # play a beep 600 hertz for 200 milliseconds
  
  
  @aData = {"BTC"=>17368330721, "ETH"=>5131925523, "DASH"=>990219631, "LTC"=>1821945777, "ETC"=>6154617132, "XRP"=>92953649061, "BCH"=>34420259033, "XMR"=>762449632, "ZEC"=>2270843152, "QTUM"=>8123072407}
    
  puts @aData

  
  #a.delete_if {|key, value| value > 9999999999 }   #=> {"a"=>100}  
    
   
  puts @aData.sort_by {|k,v| v}.reverse  
  arrayRank = {}
   countValue = 0    
   a.sort_by {|k,v| v}.reverse.each do |key, value|
      countValue = countValue+1
      arrayRank[key] = countValue
   end
   puts arrayRank

  #Sound.play("trompet.wav") # play a file from disk  
  beforeArray ={"BTC"=>1, "BCH"=>2, "ETH"=>3, "ZEC"=>4, "DASH"=>5, "XRP"=>6, "ETC"=>7, "LTC"=>8, "QTUM"=>9, "XMR"=>10}
  nowArray ={"XRP"=>1, "BCH"=>2, "BTC"=>3, "QTUM"=>4, "ETC"=>5, "ETH"=>6, "ZEC"=>7, "LTC"=>8, "DASH"=>9, "XMR"=>10}
   
  beforeArray.delete_if {|key, value| value > 3 }   #=> {"a"=>100}
    
    puts 'result aaa'
    puts   beforeArray
    puts  beforeArray
    
  Sound.play('some_file.wav')
  result = {}
  puts   result.empty?
  beforeArray.each {|k, v| result[k] = nowArray[k] if nowArray[k] != v }
  puts result #=> {:a => 2, :c => "44"}
  puts result.sort_by{ |x| x.last }.to_h
    
  puts '**'  
  # result2.empty?
  
  
  result2 = result.sort_by{ |x| x.last }.to_h
  result2.each do |key, value|
  
          puts key
          puts value
          break
  end
  
  puts beforeArray
   #(beforeArray.keys & nowArray.keys).each {|k| puts ( beforeArray[k] == nowArray[k] ? beforeArray[k] : k ) }
   

    
      
end