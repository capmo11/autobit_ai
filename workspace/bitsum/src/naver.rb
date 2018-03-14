require 'rubygems'
require 'watir'
require 'time'
require 'timeout'

# 네이버 로그인 진짜로 하는것처럼 로직 변경해야함.
# nclks('log.login',this,event)
# 네이버 이메일로 로그인
#서비스 이용정지 
#https://auth.band.us/get_user_account_status?next_url=http://band.us&signature=8P8Lt9CtplcyKDMaZNhy6eM%2Fn34M0K8np6BTNFBWTac%3D&token=45b4c355284549daf2a0513aaa0c9e298e21a2bf&user_no=10156050
class NaverTest
	
	#TODO 크롬 , 인터넷IE 로직도 추가
	#initialize :: param setting
	attr_accessor :server, :loginId, :loginPw, :watir , :bandloop_Cnt , :exceptionCnt
	
	def initialize(loginId,loginPw)
		@loginId = loginId
		@loginPw = loginPw
		@server = 'http://www.naver.com'
		@watir = Watir::Browser.new :chrome # firefox
		@watir.goto "#{@server}"
		@bandloop_Cnt = 0
		@exceptionCnt = 0
		#@watir.window.resize_to(600, 700)
		
		puts "initialize setting!"
		#puts '[' +"#{@bandList_Array}".length.to_s 	+ ']'	
	end

	#httpRespons Method
	def httpResponsCheck
		begin
			uri = URI(@watir.url)
			res = Net::HTTP.get_response(uri)
			return res.code
		rescue Exception => e
			puts 'httpResponsCheck Exception'
			sleep(3)
			exceptionCnt++
			if(exceptionCnt < 5 )
				puts self.httpResponsCheck
			else
				self.loginDo
			end
			
		end
			
	end


	#Naver login logic 
	def loginDo
		begin
			puts "Naver login logic Start"
			#@watir.execute_script("javascript:alert(1);") 
			@watir.text_field(:id=>'id').value = "#{@loginId}"
			@watir.text_field(:id=>'pw').value = "#{@loginPw}"
			@watir.span(:class ,'btn_login').click
			sleep(1)
			@watir.text_field(:id=>'query').value = "네이버밴드"
			@watir.button(:id ,'search_btn').click
			sleep(1)
			@watir.a(:href => "http://band.us/").click
			sleep(1)
			@watir.windows.last.use
			@watir.a(:class => "login").click
			@watir.a(:class => "uBtn -icoType -email").click
			
			self.bandLoginDo

		rescue Exception => e
			puts "loginDo Fail"
			self.loginDo
		ensure
		end
	end

	
	#Naver login logic 
	def bandLoginDo
		begin

			puts "bandLoginDo logic Start"
			@watir.text_field(:id=>'input_email').value = "#{@loginId}"
			@watir.text_field(:id=>'input_password').value = "#{@loginPw}"
			@watir.button(:class ,'uBtn -tcType -confirm gMG2').click
			uri = URI(@watir.url)
			res = Net::HTTP.get_response(uri)
			#puts res.code 
			if  httpResponsCheck == '200'
				puts "bandLoginDo Success"
				self.bandListDo
			else
				self.loginDo
			end
		rescue Exception => e
			puts "loginDo Fail"
			self.loginDo
		ensure
		end
	end

	#Naver Band Login logic 
	def loginBandDo
		begin
			puts "Band Login logic Start"

			@watir.goto "https://auth.band.us/login_page?next_url=http%3A%2F%2Fband.us%2F"
			@watir.a(:class ,'uBtn -icoType -naver').click
			
			if httpResponsCheck == '200'
				puts "Band Login logic Success"
				self.bandListDo
			else
				self.loginBandDo
			end
		rescue Exception => e
			puts "loginBandDo Fail"
			self.loginBandDo
		end
	end

	#Naver BandList Login logic 
	def bandListDo
		begin
			puts "bandlist"
			if httpResponsCheck != '200'
				puts 'bandListDo out!!'
				self.bandListDo
			else
				sleep(5)
				bandList_Array = @watir.spans(:class => /uriText/ ).collect(&:text)
				#네이버 밴드 리스트 중복 제거 
				puts bandList_Array.length.to_s 	
				bandList_Array.sort
				bandList_Array.delete('밴드 만들기')
				bandList_Array.delete('밴드 가이드')

				puts 'bandList_Array List Count [ '+bandList_Array.length.to_s + ']'
				puts 'bandList_Array List Chk Start '
				bandList_Array.each do |textValue|
					puts 'bandList_Array List Chk = [' + textValue + ']'
				end
				puts 'bandList_Array List Chk End'
				if bandList_Array.length == 0
					puts 'bandListDo list loding .. Waiting...'
					sleep(5)
					self.bandListDo
				else
					
					puts 'bandListDd Success Next bandWriteTask... '
					self.bandWriteTask(bandList_Array)
				end
			end

			rescue Exception => e
			puts "bandListDo Fail"
			self.bandListDo
		end
	end

	def bandWriteTask(bandList_Array)	
		begin
			 
				loopingCnt = 0
				writeButtonExistCnt = 0 
				puts 'bandWriteTask start'
				puts '[' +bandList_Array.length.to_s 	+ ']'	
				bandList_Array.each do |textValue|
		
					puts 'Band skinName = [' + textValue + ']' + ' Loop Cnt = [' + loopingCnt.to_s + ']'
					#puts 'Band CntValue S = [' + link_BandName.length.to_s + ']'
					sleep(3)
					#네이버 밴드 리스트
					@watir.span(:text ,textValue).click
					uri = URI(@watir.url)
					puts uri
						
					if( uri == 'http://band.us/')
						puts 'out looping'
					else
							#글씨기 버튼누르기
						while true
							sleep(1)
							writeButtonExistCnt = writeButtonExistCnt + 1
							puts writeButtonExistCnt
							#puts '_btnOpenWriteLayer exists? ' 
							break if  @watir.button(:class ,'cPostWriteEventWrapper _btnOpenWriteLayer').exists? == true  or writeButtonExistCnt > 5
						end
					
						#글쓰기 버튼이 없으면 루프를 빠져나온다.
						if writeButtonExistCnt > 5
							puts 'writeButtonExistCnt loop'
							writeButtonExistCnt = 0
							loopingCnt = loopingCnt + 1
							@watir.goto "http://band.us/#!/"
							next	
						end
						@watir.button(:class ,'cPostWriteEventWrapper _btnOpenWriteLayer').click

						
						#네이버 밴드 join 후 글쓰기 창이 있는지?
						#contentEditor _richEditor skin11 cke_editable cke_editable_inline cke_contents_ltr placeholder
						while true
							sleep(1) 
							#puts 'contentEditor exists? ' 
							break if @watir.div(:class ,'contentEditor').exists? == true
						end
						@watir.div(:class ,'contentEditor').click
						sleep(1)


					
						@watir.div(:class ,'contentEditor').send_keys [:control, 'v']
						sleep(1)
						
						#puts @watir.div(:class ,'contentEditor').text

						if(@watir.alert.exists? == true)
							@watir.alert.ok
							@watir.div(:class ,'contentEditor').send_keys :enter
							@watir.goto "http://band.us/#!/"
							#puts 'Band CntValue E = [' + link_Band.length.to_s + ']'
							loopingCnt = loopingCnt + 1
						else
							#@watir.div(:class ,'contentEditor').inner_html
							#=> "Insights"

							sleep(1)
							#puts @watir.div(:class ,'contentEditor').text
							#puts @watir.div(:class ,'contentEditor').p.text
							@watir.button(:class ,'uButton -point _btnSubmitPost -active').click

							#@watir.alert.ok
							
							
							while true
								
								#puts '_btnSubmitPost -active exists? ' 
								break if @watir.button(:class ,'uButton -point _btnSubmitPost -active').exists? == false
							end
							#link_Band.delete(textValue)
							@watir.goto "http://band.us/#!/"
							#puts 'Band CntValue E = [' + link_Band.length.to_s + ']'
							loopingCnt = loopingCnt + 1
						end	

					end

					
				end
			puts '10 Minute.. Counting'
			sleep(600)
			self.bandListDo
		rescue Exception => e
			puts "bandWriteTask Fail => ["+loopingCnt.to_s+']'
		end
		
	end

end

#doTask = NaverTest.new('capmo1@naver.com','Dnjzm1324!') 
#doTask.loginDo

doTask = NaverTest.new('finance_jh@naver.com','dnjzm1324!') 
doTask.loginDo

#doTask = NaverTest.new('cityrabbit25@naver.com','jh450045') 
#doTask.loginDo


#doTask = NaverTest.new('kzero0708@naver.com','shikishiki@78')
#doTask.loginDo