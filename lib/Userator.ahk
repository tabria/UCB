;========================================================================================
; Userator Class													           			;
;========================================================================================
	#NoEnv
	#Include Z:\SPODELEN\UCB\lib\Acc.ahk
	#Include Z:\SPODELEN\UCB\lib\trayIcon.ahk
	#Include Z:\SPODELEN\UCB\lib\Firefox.ahk
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
	
	
	Class Userator extends Firefox {
	
		no_task_path_Array	:="application.grouping1.property_page1.unknown_object1.document1.unknown_object3.unknown_object2.unknown_object1.unknown_object1.unknown_object1.editable_text1"
		task_type_Array		:="application.grouping1.property_page1.unknown_object1.document1.unknown_object3.unknown_object2.unknown_object1.unknown_object1.unknown_object1.unknown_object1.unknown_object1.editable_text1"
		Soft_Error_Array	:= "application.grouping1.property_page1.unknown_object1.document1.unknown_object1.editable_text1"
		nevtop50var			:= ""
		ExcludeSites	:=["reklama-rt16.ru", "concepto.ru", "artlogic-abc.ru", "ide-agency.ru", "rapart.ru", "tatneko.ru", "грунт-зона.рф", "vamproducts.ru", "kamin-keramik.ru", "a107prom.ru", "info-dom.ru", "sazhentsi.tiu.ru", "topxl.ru", "cashbuzz.ru", "mrt-rus.info", "diagnostikacentr.ru", "saratov.ldc.ru", "ooo-ip-spb.ru", "avito", "soft1", "softl", "проверь-печень.рф", "rezervkapital.ru", "wiseadvice", "serpstat", "blackkit", "skrill", "tourister", "openeyesdesign", "otzovyk", "lenadia", "aksioma", "youtube", "lrnd", "tapeten", "грунт-зона", "rospres", "усадьбаклязьма", "autosteklo", "svoimi", "kompromat", "klinkerhof", "nnprositutki", "sluh", "pechnik", "mzk", "сейфеддин"]
		posi:=0
		
		nozadnow:="Сейчас нет задания для Вашего IP"
		nozadcheck:="К сожалению, сейчас заданий для вашего IP нет"
		nozadnoweng:="Now there is no tasks for your IP"
	
	;Activating Userator and checking for existence
		useratorActivate() {
			WinActivate, ahk_class UseratorGUI
			sleep 200
		}
	;Check if Userator Exist
		useratorExistNew() {
			behave	:= "behavioral"
			t:=0
				
			Loop {
				IfWinExist, Counter Avtomat Izchakvane
				{
					sleep 60000
					continue
				}
				IfWinExist, ABBYY Screenshot Reader
				{
					;msgbox, abyy exist
					this.browserWinAction("abbyy", "close")
				}
				IfWinExist, Userator
				{

					WinGetText, nozadtitle, Userator
					If InStr(nozadtitle, this.nozadnow) or InStr(nozadtitle, this.nozadnoweng) {

						WinActivate, Userator
						WinGetPos, x, y, , , Userator

						this.OffsetLMouseClick(x, y, 183, 82)
						sleep 1000
						continue
					}
					this.useratorNotOnTop()
				}
				WinGetPos, x, y, width, height, ahk_class UseratorGUI

				if (height="") or (height=768) {
					;no userator
					t:=t+1
					if (t>100) {
						this.UseratorNovoZadanie()
						Run, Z:\SPODELEN\UCB\vstart.ahk
						ExitApp
					}
					sleep 1579
					continue
				} else {
					;userator present
					this.useratorNotOnTop()
					break
				}
			}
			sleep 100
			return	
		}
		
		useratorErrornew() {
			greshkawidthConn:=521
			greshkaheightConn:=138
			greshkawidthcheck:=598
			greshkaheightcheck:=121
			nqmazadaniqwidth:=389
			nqmazadaniqheight:=113
			
			WinGetPos, x, y, width, height, ahk_class UseratorGUI
			if ((width=greshkawidthcheck) and (height=greshkaheightcheck)) or ((width=greshkawidthConn) and (height=greshkaheightConn)) {
				;Server Error, open new start script
				this.useratorNovoZadanie()
				Run, Z:\SPODELEN\UCB\vstart.ahk
				ExitApp
			}
			sleep 100
			return	
		}
	;Open new task from userator program
		useratorNovoZadanie() {
			t:=0
			Loop {
				sleep 200
				MouseMove, 1136, 430, 2
				sleep 100
				TrayIcon_Button("userator.exe", "R")
				sleep 100
				Loop, 3 {
					this.Dow()
					sleep 150
				}
				this.Ente()
				Loop {
					MouseClick, left, 1168, 10, 1, 3
					sleep 100
					WinGetActiveStats, title, width, height, x, y
					IfWinExist, Userator
					{
						WinGetText, nozadtitle, Userator
						StringCaseSense, Locale
						If InStr(nozadtitle, this.nozadnow) or InStr(nozadtitle, this.nozadnoweng)
						{
							this.useratorActivate()
							WinGetPos, x, y,,Userator
							this.OffsetLMouseClick(x, y, 183, 82)
							sleep 300
							break 2
						}	
					}
					if (height=768) {
						t:=t+1
						if (t>100) {
							t:=0
							sleep 10
							goto, looppakcheck
						}
						sleep 1753
						goto, useratornotexistnew1212
					} else {
						;have userator
						break 2
					}
					useratornotexistnew1212:
					sleep 10
				}
				looppakcheck:
				sleep 10
			}
			sleep 100
			return
		}
	;Make Userator program not to be on TOp	
		useratorNotOnTop() {
			this.useratorActivate()
			WinSet, AlwaysOnTop, Off, ahk_class UseratorGUI
			sleep 100
			return
		}
	;Send Ctrl+1 in userator and make checks
		useratorCtrl1() {
			WinGetPos, x, y, width, height, ahk_class UseratorGUI
			widthstart:=width
			heightstart:=height	
			Loop {
				this.useratorActivate()
				this.Cr1user()
				;loop for checking if userator is open and if the dimentions are correct
				Loop {
					this.UseratorExistnew()
					this.UseratorErrornew()
					WinGetPos, x, y, width, height, ahk_class UseratorGUI
					widthend:=width
					heightend:=height

					if (widthstart=widthend) and (heightstart=heightend) {

						sleep 1
						continue 2
					} else {
						break 2
					}
				}
			}
			this.useratorNotOnTop()
			sleep 200
			return
		}
	;screenshots and checks
		useratorScreenPlusErrors() {
			this.useratorScreenshot()
			this.useratorExistnew()
			this.useratorErrornew()
			sleep 200
			return
		}
	;making screenshot
		useratorScreenshot() {
			UserTitleCatcher=ScreenСatcher
			Loop
			{
				this.useratorActivate()
				sleep 50
				run, "Z:\SPODELEN\UCB\lib\AutoIT\enter.au3"
				sleep 200
				Loop, 100
				{
					;checks if userator exists
					MouseClick, left, 1295, 10, 1, 3
					sleep 50
					WinGetActiveStats, title, width, height, x, y
					if (height=768) {
						;no userator
						;check if the tile is screencatcher
						useratornamevalue1 := Acc_Get("Name", this.uListbox, 0, "ahk_class UseratorGUI")
						if (useratornamevalue1=UserTitleCatcher) {
							goto, exitmainloopUserSnimkiSS
						}
						goto, UseratorExistLoop1SS
					} else {
						;have userator
						goto, UseratorExistLoop1SS
					}
					UseratorExistLoop1SS:
					sleep 10
				}
				sleep 1
			}
			exitmainloopUserSnimkiSS:
			Loop
			{
				this.useratorActivate()
				run, "Z:\SPODELEN\UCB\lib\AutoIT\enter.au3"
				sleep 200
				Loop, 100
				{
					
					sleep 50
					MouseClick, left, 1295, 10, 1, 3
					sleep 50
					WinGetActiveStats, title, width, height, x, y
					if (height=768) {
						;no userator
						goto, UseratorSCreenCatcherNotOkss
					} else {
						;yes userator
						goto, VsichkoEOKExitss
					}
					UseratorSCreenCatcherNotOkss:
					sleep 100
				}
				sleep 1
			}
			VsichkoEOKExitss:
			sleep 100
			this.UseratorErrornew()
			sleep 50
			return
		}
	;screenshot pages
		useratorSiteShotsSinon() {
			this.browserTabAction("Firefox", "change", 4)
			this.FFwaitAll()
			this.useratorActivate()
			this.useratorScreenPlusErrors()
			;check if there is one more website
			this.useratorActivate()
			MouseClick, left, 1222, 21, 1, 3
			sleep 50
			WinGetActiveStats, title, width, height, x, y
			xListBox1:=Acc_Geth("Location", this.uListbox, 0, "ahk_class UseratorGUI")
			if (height=xListBox1) {
				;there is 2-nd site
				;closing last tab
				this.browserTabAction("Firefox", "close", 4)
				this.browserTabAction("Firefox", "change", 3)
				this.FFwaitAll()
				this.useratorExistnew()
				this.useratorErrornew()
				this.useratorScreenshot()
			}
			this.browserTabAction("Firefox", "close", 3)
			sleep 200
			return
		}
	;position of the target site in userator
		useratorPosition() {
			poziciqvuser := this.targetPageInfo[2]
			xListBoxRaw:=Acc_GetX("Location", this.uListbox, 0, "ahk_class UseratorGUI")
			yListBoxRaw:=Acc_GetY("Location", this.uListbox, 0, "ahk_class UseratorGUI")
			this.useratorActivate()
			this.OffsetLMouseClick(xListBoxRaw, yListBoxRaw, 55, 16, "left") 
			sleep 200
			this.Hom()
			if (poziciqvuser != 1) {
				poziciqsaitcorr := poziciqvuser-1
				SetKeyDelay, 300, 10
				send {Down %poziciqsaitcorr%}
				sleep 100
			}
			sleep 200
			return
		}
		useratorPositionEnd(){
			this.useratorActivate()
			Mousemove, 1208, 15, 2
			sleep 200
			mouseclick, left
			sleep 200
			
			;sending enter
			Loop
			{
				sleep 10
				run, "Z:\SPODELEN\UCB\lib\AutoIT\mleft_click.au3"
				sleep 100
				this.UseratorExistnew()
				this.UseratorErrornew()
				this.useratorActivate()
				UserOtpravitH := Acc_Geth("Location", this.uListbox, 0, "ahk_class UseratorGUI")
				if (UserOtpravitH>300) {
					sleep 10
					continue
				} else {
					break
				}
			}
			sleep 200
			this.useratorActivate()
			this.UseratorExistnew()
			this.UseratorErrornew()
			;proverka check if there is an error box for not choosing the website position
			IfWinExist, Не выбран вариант
			{
				this.messagebox("Put Position")
				sleep 200
				goto, startclicksite
			}

			sleep 300
			this.useratorScreenshot()
			startclicksite:

			this.browserWinAction("Firefox", "activate")
			this.Cr9()

			Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\razhodka.ahk

			ExitApp
			return
		}
		useratorScrollTargetPagePosition(searchEngine, searchwww, message="No", clickButton="left") {
			if (this.notInTop.maxIndex()!="") {
				this.useratorTargetPageNotInTop(searchEngine, searchwww, clickButton)
				ExitApp
			}
			WorkSitePath := this.targetPageInfo[1]
			this.FFOnScreenLocation(WorkSitePath, searchEngine, clickButton)
			this.browserTabAction("Firefox", "change", 2)
			if (message = "Yes") {
				this.messagebox("Put the website Position")
			} else if (message="NiT") {
				this.useratorActivate()
				this.useratorScreenshot()
				this.browserWinAction("Firefox", "activate")
				this.Cr9()
				Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\razhodka.ahk
				ExitApp
			} else {
				this.useratorPosition()
			}
			this.useratorPositionEnd()
			return
		}
		;when page is not in top 50
		useratorTargetPageNotInTop(searchEngine, searchwww, clickButton) {
			this.targetPageInfo := Array()
			this.notInTop		:= Array()
			this.useratorNoTop50Combine()
			this.browserTabAction("Firefox", "change", 2)
			this.Hom()
			neVTopSearchWords := this.FFnevTop50PromqnaKeyword(searchwww)
			if (searchEngine = "google") {
				this.GoogleSearchBarLoc()
				this.FFSeLoad(neVTopSearchWords, "includeE", "same")
				this.googleavcheck()
				mainObj := this.FFMainObject()
				this.googleWrongSearchClick(mainObj)
			} else {
				this.yandexSBLocator()
				this.FFSeLoad(neVTopSearchWords, "includeE", "same")
				this.yandexRemoveBrowserDownloadLink()
			}
			this.useratorFindTargetPage(searchwww, "Yes", searchEngine)
			if (this.notInTop.maxIndex()!="") {
				this.useratorNeVTop50End()
				ExitApp
			} else {
				this.useratorScrollTargetPagePosition(searchEngine, searchwww, "NiT", clickButton)
			}
			
			return
		}
	;marking in userator, that the site is not in top50
		useratorNoTop50Combine() {
			this.useratorActivate()
			xListBoxRaw:=Acc_GetX("Location", this.uListbox, 0, "ahk_class UseratorGUI")
			yListBoxRaw:=Acc_GetY("Location", this.uListbox, 0, "ahk_class UseratorGUI")
			this.OffsetLMouseClick(xListBoxRaw, yListBoxRaw, 55, 16) 
			sleep 400
			mouseclick, left
			sleep 400
			mouseclick, left
			sleep 200
			this.En()
			sleep 200
			run, "Z:\SPODELEN\UCB\lib\AutoIT\enter.au3"
			sleep 500
			this.useratorExistnew()
			this.useratorErrornew()
			sleep 200
			return
		}
		useratorNeVTop50End(){
			this.messagebox("Not in top 50")
			sleep 200
			this.useratorActivate()
			this.useratorScreenPlusErrors()
			Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\nevtopasites.ahk
			ExitApp
		}
	;comment
		useratorCommEnd() {

			replace:= {"file1":"commtext.txt","file2":"nqmalink.txt","file3":"nezarejda.txt","file4":"nevtop50.txt"}
			for what, with in replace {
				FileRead, readvalue, C:\Neshta\Autohotkey Scripts\Auto_firefox\Vzadache_text\%with%
				if (readvalue!="") {
					this.messagebox(readvalue)
				}
			}
			sleep 200
			return
		}

		useratorEndTask() {
			Loop {
				this.useratorActivate() 
				WinGetActiveStats, title, width, height, x, y
				sleep 50
				targetW=523
				targetH=189
				if (height=targetH) and (width=targetW) {
					goto, exitendloop
				}
				sleep 500
			}
			exitendloop:
			sleep 200
			return
		}

		useratorctrl1otpravit() {

			WinGetActiveStats, title, width, height, x, y
			widthstart:=width
			heightstart:=height	
			Loop {

				this.useratorActivate()
				this.useratorCtrl1()

				Loop {
					WinGetActiveStats, title, width, height, x, y
					widthend:=width
					heightend:=height

					if (widthstart=widthend) and (heightstart=heightend) {

						goto, Ctrl1UseratorChecknachalo24
					} else {

						goto, exitloopctrl1useratorcheck24
					}
					sleep 50
				}		
				Ctrl1UseratorChecknachalo24:
				sleep 3000
			}
			exitloopctrl1useratorcheck24:
			sleep 100
			return
		}
	;end of nppy or nppg
		useratorEndNPPX() {
			this.browserTabAction("Firefox", "change", 3)
			this.FFwaitAll()
			this.useratorActivate() 
	
			this.useratorCtrl1()
			this.useratorScreenPlusErrors()
			this.useratorCommEnd()

			this.browserTabAction("Firefox", "close", 2)
			this.useratorActivate() 
			this.useratorErrornew()
			this.useratorActivate() 
			sleep 100
			Loop
			{
				sleep 10
				Mousemove, 1308, 315, 2
				sleep 400
				Loop, 2
				{
					run, "Z:\SPODELEN\UCB\lib\AutoIT\mleft_click.au3"
				}
				sleep 100
				Loop, 2
				{
					run, "Z:\SPODELEN\UCB\lib\AutoIT\mleft_click.au3"
				}
				sleep 100
				this.useratorExistnew()
				this.useratorErrornew()
				sleep 100
				usernow:=Acc_GetH("Location", this.uListbox, 0, "ahk_class UseratorGUI")
					if (usernow!=189)
					{
						goto, otpravitotnachalo11
					}
					else
					{
						goto, otpravitok11
					}
				sleep 6000
				otpravitotnachalo11:
			}
			otpravitok11:
			sleep 200
			this.useratorActivate() 
			this.useratorEndTask()
			sleep 200
			this.useratorctrl1otpravit()
			sleep 300
			Run, Z:\SPODELEN\UCB\vstart.ahk
			sleep 200
		}

		useratorCtrl1MouseMove(currenterror, scrollNow="Yes") {
			WinGetPos, x, y, width, height, ahk_class UseratorGUI
			widthstart:=width
			heightstart:=height	
			Loop {
				this.useratorActivate()
				this.useratorCtrl1() 

				Loop {
					this.UseratorExistnew()
					this.UseratorErrornew()
					WinGetPos, x, y, width, height, ahk_class UseratorGUI
					widthend:=width
					heightend:=height
					if (widthstart=widthend) and (heightstart=heightend) {

						goto, randomScrollOrNot
					} else {

						goto, exitUseratorCMM
					}
					sleep 50
				}
				randomScrollOrNot:
				if (scrollNow = "Yes") {
					this.FFRandomScroll(currenterror)
				}
				sleep 1
			}
			exitUseratorCMM:
			sleep 200
			return
		}

		useratorExtraProgOpener()
		{
			Run, "C:\Program Files\ABBYY FineReader 11\Bonus.ScreenshotReader.exe"
			sleep 200
			WinWait , ABBYY Screenshot Reader
			sleep 3000
			WinActivate, ABBYY Screenshot Reader
			sleep 200
			changeAbbyySendMode()
			sleep 5000
			this.AbbyyCloser()
			sleep 300

			Run, Z:\SPODELEN\UCB\numpadmap.ahk
			sleep 100
			this.messagebox("Click to start loading TASKS!!!!!!!")
			this.UseratorNovoZadanie()
			sleep 100
			Run, Z:\SPODELEN\UCB\vstart.ahk
			
			return
		}
		;make array of search results without pages that must not be opened
		useratorBezSluchainiStranici(taskType="non", searchEngine="yandex", clickButton="left") {
			NesluchainiStranici	:= array()
			cyrcheck	= xn~p
			spacer		= bqdyiy
			removethis =Если в задан
			searchdot=.
			removeOK:=["I ок 1]","I ок 1"]
			removeDoNotOpen = Не открывайте сайт
			removeDoNotOpenSyn = Не открывайте сайты как случайные:
			abbyyfile:="W:\zad.txt"

			this.browserMinMaxAction("Firefox", "min")
			abbyfast() 
			this.browserMinMaxAction("Firefox", "max")
			FileRead, nesluchaen, %abbyyfile%			
			for each, site in this.ExcludeSites {
			StringCaseSense, Locale

				IfInString, nesluchaen, %site%
				{
					if (taskType = "non") {
						this.messagebox("Manual")
						sleep 400
						this.useratorEndNPPX()
						ExitApp
					} else {
						this.messagebox("Manual")
						sleep 400
						this.useratorSynonEnder(searchEngine, clickbutton)
						ExitApp
					}
					
				}
			}
			StringCaseSense, Locale
			IfInString, nesluchaen, %removethis%
			{	 
				StringGetPos, removePos, nesluchaen, %removethis%
				StringLeft, nesluchaen, nesluchaen, % (removePos-2)
				StringGetPos, removeDoNotOpenPos, nesluchaen, %removeDoNotOpen%
				StringtrimLeft, nesluchaen, nesluchaen, % (removeDoNotOpenPos + StrLen(removeDoNotOpen)+1)
				StringCaseSense, Locale
				IfNotInString, nesluchaen, %searchdot%
				{
					this.messagebox("No website")
					sleep 400
					Run, Z:\SPODELEN\UCB\vstart.ahk
					ExitApp
				}
			} else {

				StringGetPos, removeDoNotOpenPos, nesluchaen, %removeDoNotOpenSyn%
				StringtrimLeft, nesluchaen, nesluchaen, % (removeDoNotOpenPos+StrLen(removeDoNotOpenSyn)+2)
				for each, occur in removeOK {

					StringGetPos, occurPos, nesluchaen,  %occur%
					if (occurPos>-1) {
						StringLeft, nesluchaen, nesluchaen, occurPos
					}
				}
				
				nesluchaen=%nesluchaen%

			}
			RawSites:=nesluchaen

			If InStr( RawSites, cyrcheck){

				NesluchainiStranici.Insert(".рф")
			}

			for key, value in this.UrlAttrib {
				StringReplace, RawSites, RawSites, %key%, %value%, All
			}

			Loop {

				If InStr( RawSites, spacer) {

					StringGetPos, SpacerPos, RawSites, %spacer%

					if (Spacerpos<3) {

						Stringtrimleft, RawSites, RawSites, % (SpacerPos+StrLen(spacer))
						continue
					} else {

						StringLeft, SiteOnly, RawSites, % SpacerPos

						ClearSite:=RemoveExtraChars(SiteOnly)

						NesluchainiStranici.Insert(ClearSite)

						StringTrimLeft, RawSites, RawSites, % SpacerPos
						continue
					}
				}

				if (RawSites="") {

					break
				} else {

					ClearSite2:=RemoveExtraChars(RawSites)

					NesluchainiStranici.Insert(ClearSite2)
					break
				}
				sleep 1
			}
			sleep 200
			return, NesluchainiStranici
		}
		useratorSynonEnder(searchEngine="yandex", clickbutton="left") {
			this.useratorSiteShotsSinon()
			searchwww		:= this.FFUrlSearchResult()

			this.browserTabAction("Firefox", "change", 2)
			this.useratorFindTargetPage(searchwww, "Yes", searchEngine)
			if (searchEngine = "yandex") {
				this.useratorScrollTargetPagePosition(searchEngine, searchwww, "No", clickButton)
				this.yandexTargetPageNotInTop(searchwww)
				ExitApp
			} else {
				this.useratorScrollTargetPagePosition(searchEngine, searchwww, "Yse")
				this.googleTargetPageNotInTop(searchwww)
				ExitApp
			}
			return
		}
		
		useratorFindTargetPage(pageToFind, targetPage, searchEngine) {
			page 		:= 0
			realPosition	:= 0
			
			loop, 5 
			{
				if (searchEngine = "google") {
					this.posi:=0
					this.googBaseAll(pageToFind, targetPage)
				} else if (searchEngine = "yandex") {
					this.yandexRemoveBrowserDownloadLink()
					this.yandexResults(pageToFind, targetPage)
				} else {
					this.messagebox("Nepoznat SE !!!!!")
					ExitApp
				}
				if ((this.targetPageInfo[1] != "") and (this.targetPageInfo[1] != "Ne e Path")) {
					realPos := A_index * 10 - 10 + this.targetPageInfo[2]
					;msgbox, realpos %realPos%
					this.targetPageInfo.Remove(2)
					this.targetPageInfo.Insert(realPos)
					goto endpageinfo
				}
				;msgbox, a index %A_Index%
				if (A_index = 5) {
					break
				} else {
					beforeUrl := this.FFGetCurrUrl()
					this.FFChangeCrAlZ()
					afterUrl := this.FFGetCurrUrl()
					if (beforeUrl = afterUrl) {
						break
					}
				}
			}
			if (this.targetPageInfo.MaxIndex() = "") {
				this.notInTop.Insert(1)
			}
			endpageinfo:
			return
		}
		
		useratorVzadOpener(vmname, vmpass)
		{
			signinloc:="application.grouping1.property_page1.unknown_object1.document1.unknown_object1.unknown_object1.unknown_object2"
			userpassloc:="application.grouping1.property_page1.unknown_object1.document1.dialog.unknown_object1.unknown_object1"
			OffsetXUser:=67
			OffsetYUser:=81
			OffsetXPass:=76
			OffsetYPass:=139
			OffsetXSign:=158
			OffsetYSign:=195
			SigninXOffset:=104
			SigninYOffset:=40
			
			WinActivate, ahk_class MozillaWindowClass
			sleep 200	
			
			SigninX:= Acc_GetX("Location", signinloc, 0, "ahk_class MozillaWindowClass")
			SigninY:= Acc_GetY("Location", signinloc, 0, "ahk_class MozillaWindowClass")
			
			this.OffsetLMouseClick(SigninX, SigninY, SigninXOffset, SigninYOffset)
			this.FFwaitAll()
			sleep 100


			UserPassX:= Acc_GetX("Location", userpassloc, 0, "ahk_class MozillaWindowClass")
			UserPassY:= Acc_GetY("Location", userpassloc, 0, "ahk_class MozillaWindowClass")
			if (UserPassX!="") && (UserPassY!="")
			{
				this.OffsetLMouseClick(UserPassX, UserPassY, OffsetXUser, OffsetYUser)
				this.CrA()
				this.sendingKeys(vmname)
				this.Ente()
				sleep 100
				this.OffsetLMouseClick(UserPassX, UserPassY, OffsetXPass, OffsetYPass)
				this.CrA()
				this.sendingKeys(vmpass)
				this.Ente()
				sleep 100
				this.OffsetLMouseClick(UserPassX, UserPassY, OffsetXSign, OffsetYSign)
				sleep 100
			}
			else
			{
				sleep 800
				exitApp
			}
			sleep 800
			return
		}

		
	}