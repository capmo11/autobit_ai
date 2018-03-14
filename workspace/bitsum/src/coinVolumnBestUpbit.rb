

require 'rubygems'
require 'watir'
require 'time'
require 'timeout'
require 'net/https'
require 'uri'
#require 'Win32API'
require 'json'
Selenium::WebDriver::Chrome.driver_path = File.join(File.absolute_path('./', "C:/Ruby24-x64/bin/chromedriver.exe"))    
#require 'win32/sound'
#include Win32



class CoinVolumnBest
  
  #TODO 크롬 , 인터넷IE 로직도 추가
   #initialize :: param setting
   attr_accessor :server, :loginId, :loginPw, :watir , :bandloop_Cnt , :exceptionCnt, :beforeTranValue , :nowTranValue  
   
   def initialize()
     time1 = Time.new
     puts "Current Time : " + time1.inspect
     @loginId = loginId
     @loginPw = loginPw
     @server = 'https://upbit.com/exchange?code=CRIX.UPBIT.BTC-OK'
     @watir = Watir::Browser.new :chrome 
     @watir.goto "#{@server}"
     @bandloop_Cnt = 0
     @exceptionCnt = 0
     @beforeTranValue = {}
     @nowTranValue = {}  
     #@watir.window.resize_to(600, 700)
     puts "initialize setting!"
     #puts '[' +"#{@bandList_Array}".length.to_s   + ']' 
   end
   
   
  def telegramSMS(text)
     begin
         uri = URI.parse( URI.encode('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=-1001189596297&text=거래량 폭증종목
 '+text+'') )
         Net::HTTP.get(uri)
     rescue Exception => e
       puts "telegramSMS...Fail"
       puts e.message 
     end
    
  end 
   
   
  def start
    
    
 
    #   <a href="#" class="on" title="BTC">BTC</a>
      
    
    
    @watir.goto 'https://upbit.com/exchange?code=CRIX.UPBIT.BTC-OK'
    
    @watir.element(:title=> 'BTC').click
    
       
    begin
    
         while true
           
                    @watir.refresh
                    sleep(5)
                    @watir.element(:title=> 'BTC').click
                    sleep(3)
                              
                    # @beforeTranValue = {"트론"=>2, "넥서스"=>1, "트랜스퍼코인"=>3, "이더리움클래식"=>4, "살루스"=>5, "클록코인"=>6, "모네로"=>7, "에이다"=>8, "이더리움"=>9, "아이온"=>10, "리플"=>11, "베리코인"=>12, "복셀"=>13, "이드니아고라스"=>14, "구피"=>15, "버지"=>16, "도지코인"=>17, "레드코인"=>18, "라이트코인"=>19, "언브레이커블코인"=>20, "스트라티스"=>21, "네오"=>22, "오미세고"=>23, "익스펜스"=>24, "스텔라루멘"=>25, "시린토큰"=>26, "비트코인캐시"=>27, "시스코인"=>28, "퀀텀리지스턴트렛저"=>29, "코파운드잇"=>30, "시아코인"=>31, "퍼스트블러드"=>32, "유니코인골드"=>33, "블록틱스"=>34, "다이내믹"=>35, "엣지리스"=>36, "블랙코인"=>37, "솔트"=>38, "뉴이코노미무브먼트"=>39, "아크"=>40, "비트빈"=>41, "인터넷오브피플"=>42, "베이직어텐션토큰"=>43, "이그니스"=>44, "대시"=>45, "오케이캐시"=>46, "비트코인골드"=>47, "웨이브"=>48, "블록메이슨"=>49, "윙스다오"=>50, "메이드세이프"=>51, "비트베이"=>52, "스웜시티토큰"=>53, "시프트"=>54, "지캐시"=>55, "리스크"=>56, "페이션토리"=>57, "디지바이트"=>58, "텐엑스페이토큰"=>59, "스피어"=>60, "누비츠"=>61, "아더"=>62, "에이엠피"=>63, "코모도"=>64, "왁스"=>65, "아이젝"=>66, "라디움"=>67, "디스트릭트"=>68, "바이버레이트"=>69, "휴매닉"=>70, "스팀"=>71, "버트코인"=>72, "이니그마"=>73, "퀀텀"=>74, "엘비알와이크레딧"=>75, "메메틱"=>76, "파티클"=>77, "페더코인"=>78, "애드엑스"=>79, "골렘"=>80, "파워렛저"=>81, "신디케이트"=>82, "리피오크레딧네트워크"=>83, "버스트코인"=>84, "디센트럴랜드"=>85, "애드토큰"=>86, "스테이터스네트워크토큰"=>87, "게임크레딧"=>88, "모나코"=>89, "팩텀"=>90, "그로스톨코인"=>91, "피벡스"=>92, "엔엑스티"=>93, "시빅"=>94, "뱅코르"=>95, "젠캐시"=>96, "블록넷"=>97, "코어코인"=>98, "디지털노트"=>99, "어거"=>100, "제로엑스"=>101, "디크레드"=>102, "지코인"=>103, "스팀달러"=>104, "익스클루시브코인"=>105, "아인스타이늄"=>106, "비아코인"=>107, "블록브이"=>108, "비트센드"=>109, "모나코인"=>110, "머큐리"=>111, "스토리지"=>112, "디센트"=>113, "바이트볼"=>114, "모네터리유닛"=>115, "유빅"=>116, "엘라스틱"=>117, "나브코인"=>118, "시베리안체르보네츠"=>119, "아라곤"=>120, "노시스"=>121, "뉴메레르"=>122}

          
                    bandList_Array = @watir.tds(:class => 'tit' ).collect(&:text)
                    
                    puts 'bandList_Array List Count ['+bandList_Array.length.to_s + ']'
                    count = 0 
                    
                   # bandList_Array.slice(0,35)    #=> "c"
                    
                
                    arrayRank = {}
                    countValue = 0    
                    bandList_Array.each do |textValue|
                         key =   textValue.gsub(/[a-zA-Z]/, "").gsub(/\//, "").gsub(/[0-9]/, "").gsub(/\\n/, "").gsub(/\n/, "")
                         countValue = countValue+1
                         arrayRank[key] = countValue
                    end
                   # @nowTranValue = arrayRank.delete_if {|key, value| value > 30 }
                    
                    puts arrayRank
                   # puts arrayRank
                   @nowTranValue  = arrayRank

                   result = {}
                   @beforeTranValue.each {|k, v| result[k] = @nowTranValue[k] if @nowTranValue[k] != v }
                  
                   #puts result.delete_if {|key, value| value > 30 }  
                   
                   
                   result2 = result.sort_by{ |x| x.last }.to_h
                   puts  result2
                   
                   

                  smsText = ""   
                   result2.each do |key , value |
                          #puts  @beforeTranValue[key] -  result2[key] > 2
                          if  ( @beforeTranValue[key] -  result2[key] > 4 )
                                    smsText+='*** '+ key+'::'+@beforeTranValue[key].to_s + '위 -> '+ result2[key].to_s+'위로 변경
'
elsif    ( @beforeTranValue[key] -  result2[key] > 3 )
                                    smsText+='** '+  key+'::'+@beforeTranValue[key].to_s + '위 -> '+ result2[key].to_s+'위로 변경
'
elsif    ( @beforeTranValue[key] -  result2[key] > 2 )
                                    smsText+='* '+  key+'::'+@beforeTranValue[key].to_s + '위 -> '+ result2[key].to_s+'위로 변경
'     
                          end        
                   end          
                   
                   if (  smsText !="" )
                        puts telegramSMS(smsText)
                   end
                          
                   @beforeTranValue =  @nowTranValue  
                         
                          
                    
      end
    
     rescue Exception => e
       e.message
       self.start 
     puts 'error'
   end 
    
   # {"BCH"=>9399060155, "BTC"=>2603241157, "ETC"=>2164481285, "LTC"=>2164481285, "DASH"=>1038448996, "ETH"=>509666754, "XRP"=>362889257, "QTUM"=>200472265, "ZEC"=>101484164, "XMR"=>90611004}

   
  end
   
end



doTask = CoinVolumnBest.new() 
doTask.start