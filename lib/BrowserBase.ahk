;========================================================================================
; CommonBase Class -> Common Functions for all Classes					     			
;========================================================================================
	#NoEnv
	#Include Z:\SPODELEN\UCB\lib\Acc.ahk
	#Include Z:\SPODELEN\UCB\lib\vlibrary.ahk
	#KeyHistory 0
	#MaxThreads 225
	#MaxMem 256
	ListLines, Off
	CoordMode, Mouse, Screen
	SetTitleMatchMode 2
	SetKeyDelay, 50, 10
	SetBatchLines, -1
	StringCaseSense, Locale
	
	
	Class BrowserBase {
	
		browserArray := {"Firefox":["ahk_class MozillaWindowClass", "C:\Program Files\Mozilla Firefox\firefox.exe", 0, 1023, 728, "application.tool_bar2.page_tab_list1", 54, 16, 7, 6], "Yandex":["ahk_class YandexBrowser_WidgetWin_1", "C:\Documents and Settings\Administrator\Local Settings\Application Data\Yandex\YandexBrowser\Application\browser.exe", 27, 1020, 699,"window.client1.client1.client2.page_tab_list1", 54, 12, 11, 10], "Abbyy":["ABBYY Screenshot Reader"]}
		ExcludeTasks	:=["����� 12", "trade12 ������", "trade12 �����", "trade12", "�����12", "������������ ����������� ������", "�������","if� ������ �����������", "ifc ������", "hotwheelspromo.by", "trade 12 ������" , "����������� ����������� ������", "������ trade 12 ������", "freshforex", "����������", "��� ������ ������", "www trade 12 com" , "���� � �����", "http://trade12.com", "����� ��������", "������ � �������� Dreamline", "blackbook", "�������� ������ ������������� �����", "��� �������", "�������", "������ �������� ��� ����������", "����� ������������", "������������ ���", "������ ���� � �����������", "������������ �����������","���������", "yolkki village", "������ ����������", "������ ��������", "���� ����� ������"]
	
	;Open browser, move and resize the browser to correct position
		OpenBrowser(browser="Firefox") {
				IfWinNotExist, % this.browserArray[browser][1]
				{
					Run, % this.browserArray[browser][2]
					this.browserWinAction(browser, "wait")
					this.browserWinAction(browser, "move")
					this.browserTabAction(browser, "change", 1)
				}
				return
		}
	;Action for window browsers WinAction can have 4 values "wait", "move", "close" or "activate". Activate is the default one
		browserWinAction(browser="Firefox", WinAction="activate") {
				sleep 200
				if (WinAction="activate") {
					WinActivate, % this.browserArray[browser][1]
				} else if (WinAction="move") {
					WinActivate, % this.browserArray[browser][1]
					WinMove, A,, 0, % this.browserArray[browser][3], % this.browserArray[browser][4], % this.browserArray[browser][5]
				} else if (WinAction="close") {
					WinClose, % this.browserArray[browser][1]
				} else {
					WinWait, % this.browserArray[browser][1]
				}
				sleep 200	
				return
		}	
	;Showing the number of tabs
		browserShowTabNumber(browser="Firefox") {
			Loop {
					tablist := Acc_Get("Object", this.browserArray[browser][6], 0, this.browserArray[browser][1])
					tablistcalc:=tablist.accChildCount
					(browser="Yandex") ? (tablistcalc:=tablistcalc-1) : (tablistcalc)
					if tablistcalc!=""
						break
					sleep 1
				}
				(tablistcalc>=10) ? (tablistcalc2:=tablistcalc-2) : (tablistcalc2:=tablistcalc)
				return, tablistcalc2
		}
	;action with tabs action can be "close" - Close all the tabs until existing tabs r < TabNumber or "change" to a specific tab
		browserTabAction(browser="Firefox", action="change", TabNumber="1") {
			loopturns:=1
				
			(action="close") ? (loopturns:=200) : (loopturns:=1)
			Loop, % loopturns 
			{
				this.browserWinAction(browser, "activate")
				if (action="close") {
					TabChangePath := this.browserArray[browser][6] . ".page_tab" . TabNumber . ".push_button1"
				} else {
					TabChangePath := this.browserArray[browser][6] . ".page_tab" . TabNumber
				}
				TabToChangeX:= Acc_GetX("Location", TabChangePath, 0, this.browserArray[browser][1])
				TabToChangeY:= Acc_GetY("Location", TabChangePath, 0, this.browserArray[browser][1])
				if (action="close") {
					this.OffsetLMouseClick(TabToChangeX, TabToChangeY, this.browserArray[browser][9], this.browserArray[browser][10])
				} else {
					this.OffsetLMouseClick(TabToChangeX, TabToChangeY, this.browserArray[browser][7], this.browserArray[browser][8])
				}
				if (action="close") {
					TabsLeft:=this.browserShowTabNumber(browser)
					sleep 100
					tabObj := Acc_Get("Object", TabChangePath, 0, "ahk_class MozillaWindowClass")
					if (isObject(tabObj)) {
						continue	
					} else {
						break
					}
				}
				sleep 1
			}
			return
		}
	;Minimizing or Maximizing The Browser action="min" - minimizing the browser action="max" maximizing
		browserMinMaxAction(browser="Firefox", action="max") {
			IfWinExist, % this.browserArray[browser][1]
			{
				if (action="min") {
					SendMessage, 0x112, 0xF020,,, % this.browserArray[browser][1]
				} else {
					SendMessage, 0x112, 0xF120,,, % this.browserArray[browser][1]
				}
				sleep 200
				Loop {
					WinGet, minvalue, MinMax, % this.browserArray[browser][1]
					if ((minvalue=-1) and (action="min")) or ((minvalue=0) and (action="max")) {
						break
					}
					if (minvalue="") {
						this.messagebox("Browser error")
						sleep 200
					}
					sleep 10
				}
			}
			sleep 100
			return
		}
	;Choose the correct browser for the task
		browserTaskPath(abbyyshot) {
				browserTypeArray	:=	{1:["�������� ������ �������", "Tasks\YandexTasks"], 2:[" ", "Tasks\FirefoxTasks"]}
				
				for keybrow, browserType in browserTypeArray {
						If InStr(abbyyshot, browserType.1) {
								return  A_ScriptDir . "\" . browserType.2
						}
						sleep 1
				}
		}
	;Build Synonym and NonSynonym Task path
		browserTaskFullPath(abbyyshot)	{
			
			taskPrePath			:="Z:\SPODELEN\UCB\Tasks\FirefoxTasks\"
			abbyyfile			:="W:\zad.txt"
			searchEnginesArray	:=	["google", "yandex", "rambler", "mail", "bing"]
			skipTasks			:=	["������� (���������) � ����", "(���������) �� �����", "������� �� ����/����/�����"]
			taskTypeArray		:=	{"synonym":"�������� ����� ������� �����", "nonsynonym":"������� �������� �����:", "stronglink":"�������� ������� � ��������� �� ����", "directweb":"������������ ������ ������� ������� ��� ���� �������", "directyoutube":"�������� ����� � YouTube", "searchyoutube":"�������� https://www.youtube.com � �������� �������� �����",  "yandexnews":"news.yandex", "googlenews":"����� �������� � ������ �������"}
			
			FileRead, abbyyshot, %abbyyfile%			
			for skey, skip in skip_tasks {
				if InStr(abbyyshot, skip) {
					return
				}
			}
			If InStr(abbyyshot, "�������� ������ �������") {
				this.messagebox("Yandex Browser Task")
				sleep 100
				ExitApp
			}
			for keytas, taskType in taskTypeArray	{
				If InStr(abbyyshot, taskType)	{
					if ((keytas="synonym") or (keytas="nonsynonym")) {
						if(keytas="nonsynonym"){
							searchWords := this.FFWordExtract(abbyyshot, "������� �������� �����:", "�",  "�", "non")
							for each, exclude in this.ExcludeTasks {
								StringCaseSense, Locale
		
								IfInString, searchWords, %exclude%
								{
									sleep 1000
								
									sleep 200
									return
								}
								sleep 1
							}
						}
						for key, engineval in searchEnginesArray {
							if Instr(abbyyshot, engineval) {
								taskToRun := taskPrePath . keytas . engineval . ".ahk"
								sleep 400
								try {
									Run, %taskToRun%
								
								} catch e {
									this.messagebox("Task file syn/nosyn was not found")
									ExitApp
								}
								ExitApp
							}
						sleep 1
						}
					} else {
						taskToRun := taskPrePath . keytas . ".ahk"
						try {
							sleep 400
							Run, %taskToRun%
						} catch e {
							this.messagebox("Task file was not found")
							ExitApp
						}
						ExitApp
					}
				}
				sleep 1
			}	
			sleep 200
			return
		}
	;Build YandexBrowserPath from second step of the task
		browserTaskYBPath(abbyyshot) {
				If InStr(abbyyshot, "�������� ������ �������") {
						Run % this.browserTaskPath(abbyyshot) . "\common.ahk"
				}
				sleep 200
				return
		}
	;random numbers
		browserRandomChisla(RandStranici, OffsetX, OffsetY, SearchEngine) {
				YandexCheck		= yandex
				ChislaRandom	:= {}
				RandNumbers		:=0
				cyrcheck		=xn--
				Loop {
					RandNumbers:=RandNumbers+1
					if (RandNumbers>this.UrlStranici.MaxIndex()) {
						break
					}
					ChislaRandom.Insert(RandNumbers)
				}
				ReamainingChislarandom := ChislaRandom.MaxIndex()
				Rand1Value:=0
				if (RandStranici=2) {
						Rand2Value:=0
				}
				ChangeOnly:=0
				Loop {
					RandLoopNumber:=0
					Loop {
						RandLoopNumber:=RandLoopNumber+1
						If (ChangeOnly=0) and (RandLoopNumber>RandStranici) {
							goto, ExitRandLoopNumber
						}
						If (ChangeOnly!=0) and (RandLoopNumber>1) {
							goto, ExitRandLoopNumber
						}
						RemChslaRandom:=ReamainingChislaRandom
						Random Index, 1, %RemChslaRandom%
						Rand:=ChislaRandom[Index]
						this.Swap(ChislaRandom, Index, ReamainingChislaRandom) 
						--ReamainingChislarandom	
								
						if (ReamainingChislaRandom=-1) or (Rand="") {
							this.messageOkCancel("OK  /// Cancel ")
							IfMsgBox Cancel
							{
								this.browserTabAction("Firefox", "change", 3)
								sleep 100
								if (RandStranici = 1) {
									goto, randomsvarsheno
								} else {
									
									Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\razhodka.ahk
									ExitApp
								}
							}  else {
								goto, randomsvarsheno
							}
						}
						if (Rand1Value=0) or (ChangeOnly=1) {
							Rand1Value:=Rand
							goto, LoopRandsEqual
						}
						if (RandStranici=2) {
							if (Rand1Value!=0) or (ChangeOnly=2) {
								Rand2Value:=Rand
								goto, LoopRandsEqual
							}
							if (Rand1Value=Rand2Value) {
								RandLoopNumber:=0
								goto, LoopRandsEqual
							}
						}
						LoopRandsEqual:
						sleep 1
					}
					ExitRandLoopNumber:
					Rand1SiteValue:=Acc_Get("Value", this.UrlStranici[Rand1Value], 0, "ahk_class MozillaWindowClass")
					if (RandStranici=2) {
						Rand2SiteValue:=Acc_Get("Value", this.UrlStranici[Rand2Value], 0, "ahk_class MozillaWindowClass")
					}
					rem:=0
					Loop {
						rem:=rem+1
						if (rem>RandStranici) {
							goto, ExitRemoveLoop
						}
						DataToRemove:=Rand%rem%SiteValue
						IfInString, DataToRemove, %cyrcheck%
						{
							Rand%rem%SiteValue=��
							goto, NavToRandSites
						}
						Rand%rem%SiteValue:=RemoveExtraChars(DataToRemove)
					}
					ExitRemoveLoop:
					if (RandStranici=2) {
						IfInString, Rand1SiteValue, %Rand2SiteValue%
						{
							ChangeOnly:=1
							goto, RandLoopSitesAgain
						}
						IfInString, Rand2SiteValue, %Rand1SiteValue%
						{
							ChangeOnly:=2
							goto, RandLoopSitesAgain
						}
					}
					goto, NavToRandSites
					RandLoopSitesAgain:
					sleep 1
				}
				NavToRandSites:
				NavRandNow:=0
				Loop {
					
					NavRandNow:=NavRandNow+1
					Loop {
						if (NavRandNow>RandStranici) {
							goto, 2ndLoopGoog
						}
						if (NavRandNow=1) {
							PathUrlStranica:=this.UrlStranici[Rand1Value]
						}
						if (RandStranici=2) {
							if (NavRandNow=2) {
								PathUrlStranica:=this.UrlStranici[Rand2Value]
							}
						}
						XValueRand%NavRandNow%:=Acc_GetX("Location", PathUrlStranica, 0, "ahk_class MozillaWindowClass")
						YValueRand%NavRandNow%:=Acc_GetY("Location", PathUrlStranica, 0, "ahk_class MozillaWindowClass")
						IfInString, SearchEngine, %YandexCheck%
						{
							valuemove:=225
						} else {
							valuemove:=210
						}
						if (YValueRand%NavRandNow%>valuemove) {
							
							goto, EndVidimaZona1UrlSiteGoog
						} else {
							
							MouseClick, left, 50, 621, 1, 3
							sleep 50
							
							Loop, 16
							{
								PostMessage, 0x115, 0,,, ahk_class MozillaWindowClass
								sleep 1
							}
							goto, VidimaZonaCheck1UrlSiteGoog
						}
						EndVidimaZona1UrlSiteGoog:
						
						if (YValueRand%NavRandNow%<650) {
							
							xm:=XValueRand%NavRandNow%+OffsetX
							ym:=YValueRand%NavRandNow%+OffsetY
							sleep 300
							MouseMove, %xm%, %ym%, 2
							sleep 300
							this.CrLB()
							sleep 300
							
							sleep 200
							goto, tabsnesa4
						} else {
							MouseClick, left, 50, 621, 1, 3
							sleep 50
							
							Loop, 16
							{
								PostMessage, 0x115, 1,,, ahk_class MozillaWindowClass
								sleep 1
							}
							goto, vidimazonacheck1urlsitegoog
						}
						vidimazonacheck1urlsitegoog:
						sleep 15
					}
					2ndloopgoog:
					sleep 100
					
					tablist := this.browserShowTabNumber("Firefox")
					tabcheck:=2+RandStranici
					if (tablist=tabcheck) {
						goto, randomsvarsheno
					}
					if (tablist>tabcheck) {
						this.messagebox("Tabs sa poveche ot 4 nesluchaini")
						sleep 200
						goto, randomsvarsheno
					}	
					tabsnesa4:
					sleep 1
				}
				randomsvarsheno:
				return
		}
		
	;Swapping
		Swap(Obj, a, b)  {
				Temp := Obj[a], Obj[a] := Obj[b], Obj[b] := Temp
		}	
	;Moving the currsor to a location with offset
		OffsetLMouseClick(Xcoord, Ycoord, OffsetX, OffsetY, Mbutton="left") {
				xuser:=Xcoord+OffsetX
				yuser:=Ycoord+OffsetY
				mousemove, %xuser%, %yuser%, 2
				sleep 100
				MouseClick, %Mbutton%
				sleep 300
				return
		}
		
	;Close Abbyy 
		AbbyyCloser() {
			Loop {
				IfWinExist, ABBYY Screenshot Reader
				{
					WinClose, ABBYY Screenshot Reader
					sleep 200
				} else {
					break
				}
				sleep 1
			}
			sleep 100
			return
	}
	;function to send keystrokes
	sendingKeys(keysToSend, delay=200) {
		SetKeyDelay, %delay%, 40
		send %keysToSend%
		sleep 200
		return
	}
	sendingRawKeys(keysToSend, delay=200) {
		SetKeyDelay, %delay%, 40
		send {Raw} %keysToSend%
		sleep 200
		return
	}
	;Custom Msgbox
		CustomMsgBox(Title,Message,Font="",FontOptions="",WindowColor="") {
				Gui,66:Destroy
				Gui,66:Color,%WindowColor%
				Gui,66:Font,%FontOptions%,%Font%
				Gui,66:Add,Text, w260,%Message%
				Gui,66:Font
				GuiControlGet,Text,66:Pos,Static1
				Gui,66:Add,Button,% "Default y+10 w75 g66OK xp+" (TextW / 2) - 38 ,OK
				Gui,66:-MinimizeBox
				Gui,66:-MaximizeBox
				Gui,66:Show, x1036 y450 w255,%Title%
				Gui,66:+LastFound
				WinWaitClose
				Gui,66:Destroy
				return
				
				66OK:
				Gui,66:Destroy
				return
		}
	;Msgbox blank add "message"
		messagebox(message) {
				SetTimer, message1, 200
				this.CustomMsgBox( "message", message, "Lucida Console","cWhite","Black")
				message1:
				SetTimer, message1, Off
				id:=winexist("message")
				WinMove, ahk_id %id%, , 1030, 521
				return
		}
		messageOkCancel(message) {
				SetTimer, kraichisla1, 200 
				msgbox, 1, kraichisla , %message%
				kraichisla1:
				SetTimer, kraichisla1, Off
				id:=winexist("kraichisla")
				WinMove, ahk_id %id%, , 1030, 521	
				return
		}
		messageTripleButton(message)
		{
			SetTimer, contact31, 200
			 msgbox, 3, triple , %message%
			 contact31:
			 SetTimer, contact31, Off
			 id:=winexist("triple")
			 WinMove, ahk_id %id%, , 1030, 521
			 return

		}
	; Sending Ctrl+L+A+V
		CrLAV() {
				sleep 100
				MouseClick, left, 286, 82, 1, 3
				sleep 200
				send {ctrl down}
				sleep 100
				send {a down}
				sleep 50
				send {a up}
				sleep 100
				send {v down}
				sleep 50
				send {v up}
				sleep 50
				send {ctrl up}
				sleep 200
				return
		}
	; Sending Ctrl+A+V
		CrAV() {
				send {ctrl down}
				sleep 100
				send {a down}
				sleep 50
				send {a up}
				sleep 100
				send {v down}
				sleep 50
				send {v up}
				sleep 50
				send {ctrl up}
				sleep 200
				return
		}
	;Sending Ctrl+V
		CrV() {
				send {ctrl down}
				sleep 100
				send {v down}
				sleep 50
				send {v up}
				sleep 50
				send {ctrl up}
				sleep 200
				return
		}
	;Sending Ctrl+F+A+V
		CrFAV() {
				send {ctrl down}
				sleep 100
				send {f down}
				sleep 50
				send {f up}
				sleep 100
				send {a down}
				sleep 50
				send {a up}
				sleep 100
				send {v down}
				sleep 50
				send {v up}
				sleep 50
				send {ctrl up}
				sleep 200
				return
		}
	;SenCtrl+L+C
		CrLC() {
				sleep 100
				MouseClick, left, 286, 82, 1, 3
				sleep 200
				send {ctrl down}
				sleep 100
				send {a down}
				sleep 50
				send {a up}
				sleep 100
				send {c down}
				sleep 50
				send {c up}
				sleep 50
				send {ctrl up}
				sleep 200
				return
			}
	;Sending Ctrl + T
		CrT() {
				this.browserWinAction("Firefox", "activate")
				send {ctrl down}
				sleep 100
				send {t down}
				sleep 50
				send {t up}
				sleep 50
				send {ctrl up}
				sleep 200
				return
		}
	;Sending Ctrl+Alt+Z
		CrAlZ() {
				send {ctrl down}
				sleep 100
				send {alt down}
				sleep 100
				send {z down}
				sleep 50
				send {z up}
				sleep 50
				send {alt up}
				sleep 50
				send {ctrl up}
				sleep 200
				return
		}
		;Sending Ctrl + A
		CrA() {
				send {ctrl down}
				sleep 100
				send {a down}
				sleep 50
				send {a up}
				sleep 50
				send {ctrl up}
				sleep 200
				return
		}
	;Ctrl+LButton
		CrLB() {
				sleep 100
				send {MButton down}
				sleep 50
				send {Mbutton up}
				sleep 100
				return
		}
		;Ctrl+L
		CrL()
		{
			sleep 100
			MouseClick, left, 286, 82, 1, 3
			sleep 200
			send {ctrl down}
			sleep 100
			send {a down}
			sleep 50
			send {a up}
			sleep 50
			send {ctrl up}
			sleep 100
			return
		}
	;sending CrA+Mouse - like CrL
		MouseCrA()
		{
			sleep 100
			 MouseClick, left, 286, 82, 1, 3
			 sleep 200
			send {ctrl down}
			sleep 100
			send {a down}
			sleep 50
			send {a up}
			sleep 50
			send {ctrl up}
			sleep 100
			 return
		}
	;Sending Cr9
		Cr9() {
				send {ctrl down}
				sleep 100
				send {9 down}
				sleep 50
				send {9 up}
				sleep 50
				send {ctrl up}
				sleep 200
				return
		}
	; Sending ENTER
		Ente() {
				send {enter down}
				sleep 50
				send {enter up}
				sleep 200
				return
		}
	; Sending DOWN
		Dow() {
				send {down down}
				sleep 50
				send {down up}
				sleep 200
				return
		}
	; Sending Escape
		Escap() {
				send {escape  down}
				sleep 50
				send {escape  up}
				sleep 200
				return
		}
	;Sending END
		En() {
				send {end down}
				sleep 50
				send {end up}
				sleep 200
				return
		}
	;Sending HOME
		Hom() {
				send {home down}
				sleep 50
				send {home up}
				sleep 200
				return
		}
	;Sending RIGHT
		Righ() {
				 send {right down}
				sleep 50
				send {right up}
				sleep 200
				return
		}
		;Sending Left
		Lef() {
				 send {left down}
				sleep 50
				send {left up}
				sleep 200
				return
		}
		;Sending backspace
		BackSpac() {
				 send {backspace down}
				sleep 50
				send {backspace up}
				sleep 200
				return
		}
	;Sending SPACE
		Spac() {
				 send {space down}
				sleep 50
				send {space up}
				sleep 200
				return
		}
	; Sending Cr+1
		Cr1user() {
				send {ctrl down}
				sleep 100
				send {1 down}
				sleep 50
				send {1 up}
				sleep 50
				send {ctrl up}
				sleep 200
				return
		}
		;Ctrl+L+V
		CrLV()
		{
			 sleep 100
			 MouseClick, left, 286, 82, 1, 3
			 sleep 200
			 send {ctrl down}
			sleep 100
			send {a down}
			sleep 50
			send {a up}
			sleep 100
			send {v down}
			sleep 50
			send {v up}
			sleep 50
			send {ctrl up}
			sleep 200
			 return
		}
	;Send Enter with auto it
		AutoitEnter() {
				WinActivate, ahk_class UseratorGUI
				sleep 50
				run, "C:\UCB\AutoIT\enter.au3"
				sleep 200	
				return
		}

		
	}
	
		
			