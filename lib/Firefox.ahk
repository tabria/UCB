;========================================================================================
; FireFox Class													            
;========================================================================================
	#NoEnv
	#Include Z:\SPODELEN\UCB\lib\Acc.ahk
	#Include Z:\SPODELEN\UCB\lib\BrowserBase.ahk
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
	
	
	Class FireFox extends BrowserBase {
			ChecksArray		:= [".yandex","images/search?","video/search?","yandex","ya.ru"]
			UrlAttrib		:= {" ":"","https://":"bqdyiy","http://":"bqdyiy","www.":"bqdyiy","`r":"bqdyiy", "`n":"bqdyiy", "«р://":"bqdyiy"}
			uListbox		:= "dialog"
			objectsRegion	:=[]
			childPath		:=[]
			
	;Waiting for Firefox to load completely the page
		FFwaitAll(repetitions="2", sleeptime="1000" ) {
				FFwaitArray := ["application.tool_bar3.combo_box1.push_button"]
				loading := "Stop loading this page"
				loaded  := "Reload current page"
				Loop, %repetitions%
				{
					time1:=10
					n:=0
					
					this.browserWinAction("Firefox", "activate")
					Loop {
						n:=n+1
						if (n>7) {
								n:=0
								sleep 1
								continue
						}
						buttonLoc := FFwaitArray[1] . n
						description := Acc_Get("Name", buttonLoc, 0, "ahk_class MozillaWindowClass")
						if (description = loaded)  {
							break
						}		
						if (time1>3020)
						{
							this.Escap()
							this.messagebox("Infinite Loop vzemat se merki")
							sleep 200
							break 2
						}
						sleep, 10
						time1:=time1+5
						sleep 1
					}
					sleep %sleeptime%
				}
				sleep 100
				return
		}
	;Closing Refresh msg on the bottom of Firefox Browser
		FFRefreshCloser() {
				ffAlertLoc:="application.alert1.push_button2"
				AlertX:= Acc_GetX("Location", ffAlertLoc, 0, "ahk_class MozillaWindowClass")
				AlertY:= Acc_GetY("Location", ffAlertLoc, 0, "ahk_class MozillaWindowClass")
				if (AlertX!="") && (AlertY!="")
				{
					this.OffsetLMouseClick(AlertX, AlertY, 8, 13)
				}
				return
		}
	;Obtaining the current URL from Firefox address bar
		FFGetCurrUrl(){
				curl1loc := "application.tool_bar3.combo_box1.editable_text1"
				
				curl1value:=Acc_Get("Value", curl1loc, 0, "ahk_class MozillaWindowClass")
				return, curl1value
		}
	;Extract Firefox status bar
		FFStatBarNow(){
				url1locstatraw := "application.grouping1.property_page.x.status_bar1"
				
				activetab:=this.FFNomerActiveTab()
				StringReplace, url1locstat, url1locstatraw, .x, %activetab%
				statbartext := Acc_Get("Name", url1locstat, 0, "ahk_class MozillaWindowClass")
				return, statbartext
		}
	;Returning the number of the current active tab
		FFNomerActiveTab() {
				loaded  := "Reload current page"
				loading := "Stop loading this page"
		
				Loop {
					n:=0
					time1:=0
					tabnomer:=0
					httpcheck=
					broitabove:=tabobj .accChildCount
					buttonraw:="application.tool_bar3.combo_box1.push_button.x"
					
					this.FFwaitAll(2, 100)
					ActiveNameTab:=Acc_Get("Name", "application", 0, "ahk_class MozillaWindowClass")
					StringReplace, ActiveNameTab, ActiveNameTab, %A_Space%-%A_Space%Mozilla%A_Space%Firefox,,
					tabobj:=Acc_Get("Object", "application.tool_bar2.page_tab_list", 0, "ahk_class MozillaWindowClass")
					for each, child in Acc_Children(tabobj) {
							tabnomer:=tabnomer+1
							NameTab:=child .accName(0)
							if (NameTab=0) {
									break
							}
							if (NameTab=ActiveNameTab) {
									break 2
							}
							if (ActiveNameTab="Mozilla Firefox") {
									StringCaseSense, Locale
									IfInString, NameTab, %httpcheck% 
									{
											break 2
									}
							}
							if (NameTab="Connecting…") {
									Loop {
											n:=n+1
											if (n>7) {
												n:=0
												sleep 1
												continue
											}
											StringReplace, button, buttonraw, .x,%n%
											description := Acc_Get("Name", button, 0, "ahk_class MozillaWindowClass")
											if (description = loading) or (description = loaded) {
													break
											}
									}
									description := Acc_Get("Name", button, 0, "ahk_class MozillaWindowClass")
									StringCaseSense, Locale
									IfInString, description, %loaded% 
									{
											break 2
									}
							}
							if (tabnomer>broitabove) {
									break
							}
							sleep 2
					}
					sleep 2
				}
				return, tabnomer
		}
	;Turn path from Getpath to normal
		FFNormalPath(pathchange) {
				structure:= ["24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40"]
				
				for what, with in structure {
					IfInString, pathchange, %with%
					{
						StringReplace, pathchange, pathchange, 4.%with%.1, 4.%with%.2

					}
				}
				return, pathchange
		}
	;extract the Search Engine from abbyy
		FFSEextract(searchInto, firstSearch, secondSearch, offset) {
				StringReplace, searchInto, searchInto, `r`n, %a_space%, All	
				StringGetPos, firstSearchPos, searchInto, %firstSearch%
				StringLeft, afterFirstTrim, searchInto, % (firstSearchPos-offset)
				StringGetPos, secondSearchPos, afterFirstTrim, %secondSearch%
				StringTrimLeft, afterSecondTrim, afterFirstTrim, % (secondSearchPos+StrLen(secondSearch))
				StringReplace, afterSecondTrim, afterSecondTrim, -,%A_Space%
				StringGetPos, spacePos, afterSecondTrim, %A_space%
				if (spacePos<0) {
					goto, nospacelabel
				}
				StringLeft, afterSecondTrim, afterSecondTrim, % spacePos
				nospacelabel:
				return, afterSecondTrim
		}
	;extract searchword for nonsynonym tasks
		FFWordExtract(searchInto, firstToSearch, secondToSearch, thirdToSearch, typeTask) {
			if (typeTask = "non") {
				checkfile:="Z:\SPODELEN\UCB\Txt\bezsinonimzapros.txt"
			} else {
				checkfile:="Z:\SPODELEN\UCB\Txt\sinonimzapros.txt"
			}
			StringReplace, searchInto, searchInto, `r`n, %a_space%, All	
			StringGetPos, firstToSearchpos, searchInto, %firstToSearch%
			StringTrimLeft, firstToSearchTrim, searchInto, %firstToSearchPos%
			StringGetPos, secondToSearchPos, firstToSearchTrim, %secondToSearch%
			StringLeft, secondToSearchTrim, firstToSearchTrim, %secondToSearchPos%
			StringGetPos, thirdToSearchPos, secondToSearchTrim, %thirdToSearch%
			StringTrimLeft, finalTrim, secondToSearchTrim, % (thirdToSearchPos+1)
			Loop, Read, %checkfile%
			{
				Loop, Parse, A_LoopreadLine, \
				{
					if (A_LoopField=finalTrim) {
						foundLine:=A_LoopreadLine
						StringGetPos, posInFoundLine, foundLine, \
						StringTrimLeft, keywords, foundLine, % (posInFoundLine+1)
						goto, pasteKeywords
					}
				}
			}
			finalTrim=%finalTrim%
			this.CrT()
			sleep 100
			this.sendingKeys(finalTrim)
			this.messagebox("Correct the search word !!!!")
			sleep 200
			keywords:=this.FFGetCurrUrl()
			keywordToStore=%finalTrim%\%keywords%
			FileAppend, `r`n%keywordToStore%, %checkfile%	
			sleep 100
			this.browserTabAction("Firefox", "close", 2)
			pasteKeywords:
			return, keywords
		}
	;change keyword to synonym
		FFSynonymMaker(sword1, searchengine="yandex") {
			replace1 := {"рено":"reanault","вайлдберриз":"wildberries","ламода":"lamoda","маскотте":"mascotte","кбе":"kbe","рехау":"rehau","форд":"ford","аир-бокс":"air-box","вулкан":"vulcan","покупать":"купить","проведал":"provedal","казино":"casino","макдональдс":"mcdonalds","перевозка":"доставка","самсунг":"samsung","мерседес":"mercedes","калпеда":"calpeda","раутитан":"rautitan","стабил":"stabil","тессер":"tesser","молескин":"moleskine","плейбокс":"playbox","легранд":"legrand","валена":"valena","плейтодей":"playtoday","айлове":"ailove","лободис":"lobodis","ейпал":"apple","ирест":"irest","карепрост":"careprost","пауъруеар":"powerware","верисаин":"verisign","секюр":"secure","сайт":"страниц","мотул":"motul","юнификс":"unifix","директ":"direct","баусервис":"bauservice","тимбилдинг":"teambuilding","вконтакте":"vkontakte","индизайн":"indesign","дендер":"dender","нескафе":"nescafe","сейп":"sape","ларсон":"larson","холз":"holz","шнайдер":"schnider","уника":"unica","кобра":"cobra","аймак":"imac","ссл":"ssl","бмв":"bmw","лайтстар":"lightstar","бейби":"baby","фуут":"foot","вундерлич":"wunderlicht","клиар":"clear","фит":"fit","статус":"status","ямагучи":"yamaguchi"}
			replace8 := {"а":"о","a":"o","у":"о","y":"o","ы":"ь","и":"е","i":"e","э":"е","я":"иа","ю":"иу","u":"o","ё":"е","е":"и","e":"i"}
			addwordsArray := {2:"срочно", 3:"отзывы", 4:"быстро", 5:"цена"}
			
			if InStr(searchengine, "rambler") or InStr(searchengine, "mail") {
				randmax := 5
			} else {
				randmax := 7
			}
			Random, randsinon, 1, %randmax%
			if (randsinon=1) or (randsinon=7) {
		
				for what, with in replace%randsinon% {
					If InStr(sword1, what) {
						StringReplace, var600, sword1, %what%, %with%
						sleep 200
						goto, endToReturn
					}
					If InStr(sword1, with)  {
						StringReplace, var600, sword1, %with%, %what%
						sleep 200
						goto, endToReturn
					}
					sleep 1
				}
				randsinon := 2
			}
			if (randsinon >= 2) and (randsinon <= 5){
				for keyrand, wordrand in addwordsArray {
					if (keyrand = randsinon) {
						StringReplace, var600, sword1, %sword1%, %sword1% %wordrand%
						sleep 200
						goto, endToReturn
					}
					sleep 1
				}
			}

			if (randsinon=6) {
				Loop {
					StringLen, lenght, sword1
					Random, randsinon2, 1, %lenght%
					StringMid, var500, sword1, %randsinon2%, 1
					if var500 is space
					{
						continue
					}
					StringReplace, var600, sword1, %var500%
					if (sword1=var600) {
						continue
					} else {
						sleep 200
						goto, endToReturn
					}
					sleep 1
				}
			}
		endToReturn:
		sleep 200	
		return, var600
		
	}
	;firefox enter + FFwait
		FFEnterFFWait() {
				this.Ente()
				this.FFwaitAll(2, 1500)
				sleep 200
				return
		}

	;Scroll up firefox
		;direction 0 up , 1 down
		FFScroll(x, y, direction) {
			MouseClick, left, x, y, 1, 3
			sleep 50
			Loop, 16
			{
				PostMessage, 0x115, %direction%,,, ahk_class MozillaWindowClass
				sleep 1
			}
			return
		}
	;Loading search Engine into firefox tab
	;controlAction L-MouseCrA() - prashta ctrl+L+A (formata e s mouseclick vmesto L), A-CrA(), E-izprashta end i speis sled 0 - nqma control Action
		FFSeLoad(words, includeL="includeL", newTab="newTab") {
			StringCaseSense, Locale
			if (newTab = "newTab") {
				this.CrT()
			}
			sleep 200
			if (includeL = "includeL") {
				this.sendingKeysPageLoad(words, "L", 1)
				sleep 100
			}else if (includeL = "includeE") {
				this.sendingKeysPageLoad(words, "E", 1)
			} else {
				this.sendingKeysPageLoad(words, "A", 1)
			}
			
			sleep 200
			return
		}
		sendingKeysPageLoad(wordToSend, controlAction="NA", enterAction=1, delay=200)
		{
			;controlAction L-MouseCrA() - prashta ctrl+L+A (formata e s mouseclick vmesto L), A-CrA(), E-izprashta end i speis sled 0 - nqma control Action
			;enterAction 1-natiska se enter i se izchakva FFwait, 0 - ne se izprashta enter i FFwait
			If (controlAction = "L") {
				this.MouseCrA()
			} else if (controlAction = "A") {
				this.CrA()
			} else if (controlAction = "E") {
				this.En()
				this.Spac()
			}else {
				sleep 20
			}
			sleep 100
			send % this.sendRandomDelay(wordToSend)
			if (enterAction = 0)
			{
				sleep 400
			} else {
				this.Ente()
				sleep 100
				this.FFwaitAll()
				sleep 100
			}
			sleep 400
			return
		}	
		sendRandomDelay(stringToSend)
		{
			Loop, parse, stringToSend 
			{
				send % A_LoopField
				random, t, 42, 233
				sleep, %t%
			}
		}
	;get position(path) for website in search
		FFWebPos(LastArray, SluchSitesNoGo, se="yandex", targetPage="No") {
			WinGet, hwnd, ID, ahk_class MozillaWindowClass

			LinkValuenot:=LastArray .accValue(0)
			if (se = "google") {
				If ( InStr(LinkValuenot, "google") and InStr(LinkValuenot, "/search?q") ) 
					or ( InStr(LinkValuenot, "javascript:;") ) {
						goto, endfunc
				}
			} else {
				For vo, bo in this.ChecksArray {	
					If InStr(LinkValuenot, bo) {
						goto, endfunc
					}
					sleep 1
				}
			}
			if (targetPage = "Yes") {
				pathchange:=this.FFTargetSitePath(LastArray, LinkValuenot, SluchSitesNoGo)
				goto, endfunc
			}

			if (isObject(SluchSitesNoGo)) {
				For element, url in SluchSitesNoGo {	

					If InStr(LinkValuenot, url) {
						goto, endfunc
					}
					sleep 1
				}
			}


			pathchange:=this.FFNormalPath(GetAccPath(LastArray, hwnd))
			endfunc:

			return, pathchange
		}
		FFTargetSitePath(currentObject,currentPageValue, pageToFind) {
			WorkSiteValue:=RemoveExtraChars(currentPageValue)

			IfInString, WorkSiteValue, %pageToFind%
			{
				StringGetPos, searchWordPos, WorkSiteValue, %pageToFind%

				StringTrimLeft, searchWordTrim, WorkSiteValue, % (searchWordPos+StrLen(pageToFind))

				if (StrLen(searchWordTrim)>0) {

					goto, endReturnPath
				}

				if (WorkSiteValue=pageToFind)
				{

					WinGet, hwnd, ID, ahk_class MozillaWindowClass
					pathPage:=this.FFNormalPath(GetAccPath(currentObject, hwnd)) 

					return, pathPage
				}
			}
			endReturnPath:
			return, pathPage:="Ne e path"
		}

		FFUrlSearchResult()
		{
			beforeUrl = запросу сайт	
			afterUrl = и введите
			abbyyfile:="W:\zad.txt"
			
			this.browserMinMaxAction("Firefox", "min")
			abbyfast() 
			FileRead, abbyyvalue, %abbyyfile%
			sleep 100
			if (InStr(abbyyvalue, beforeUrl) and InStr(abbyyvalue, afterUrl)) 
			{
				StringReplace, abbyyvalue, abbyyvalue, `r`n, %a_space%, All

				StringGetPos, preUrlPos, abbyyvalue, %beforeUrl%
				StringTrimLeft, midCutTemp, abbyyvalue, % (preUrlPos+strlen(beforeUrl))

				StringGetPos, afterUrlPos, midCutTemp, %afterUrl%
				StringLeft, fullCut, midCutTemp, % (afterUrlPos+0)

			fullcut = %fullcut%

				finalurl:=RemoveExtraChars(fullCut)

				sleep 200
			}
			else {
				this.messagebox("wrong words in screenshot")
				sleep 400
				ExitApp
			}
			this.browserMinMaxAction("Firefox", "max")
			sleep 200

			correctfile=Z:\SPODELEN\UCB\TXT\correctUrl.txt
			Loop, Read, %correctfile%
			{
				Loop, Parse, A_LoopreadLine, \
				{
					StringCaseSense Locale
					if (A_LoopField=finalurl)
					{
						var2:=A_LoopreadLine
						StringGetPos, pos1, var2, \
						StringTrimLeft, finalurl, var2, % (pos1+1)
						goto, goodUrl
					}

				}
	
			}
			goodUrl:

			return, this.FFCyrEmptyCheck(finalurl)
		}
	;check for cyrillic pages
		FFCyrEmptyCheck(searchwww) {
			cyrcheck2=xn--
			if (searchwww="") {
				this.messagebox("No URL Found!!! Extraction Problem")
			}
			IfInString, searchwww, %cyrcheck2%
			{

				this.CrT()
				this.sendingKeys(searchwww)
				this.messagebox("Change search words")
				searchwww:=this.FFGetCurrUrl()
				this.browserTabAction("Firefox", "close", 3)
			}
			sleep 200
			return, searchwww
		}
	;errors on the site
		FFsiterrors() {
			replace		:= {"err1":"Secure Connection Failed", "err2":"The Connection has timed out", "err3":"Server not found", "err4":"Address Not Found", "err5":"The connection was reset", "err6":"404 Not Found", "err7":"Problem loading page", "err8":"504 Gateway Timed-out", "err8":"Service Unavailable"}
			errorloc	:="application"
			errornomer	:=0
				
			errorname := Acc_Get("Name", errorloc, 0, "ahk_class MozillaWindowClass")
			StringReplace, errorname, errorname, -%A_Space%Mozilla Firefox,,
			errorname=%errorname%
			for what, with in replace {
				StringCaseSense , Locale
				if (errorname=with) {
					errornomer:=1
					sleep 300
					break
				}
				sleep 2
			}
			sleep 200
			return, errornomer
		}
	;check for errors in razhodka.ahk
		FFWalkContactCheck() {
			contactW:=["553", "601"]
			contactH:=["172", "155"]

			wUser := Acc_GetW("Location", this.uListbox, 0, "ahk_class UseratorGUI")
			hUser := Acc_GetH("Location", this.uListbox, 0, "ahk_class UseratorGUI")
			for what, with in contactW {
				If	(wUser=with) {
					for vhat, vith in contactH {
						If (hUser=vith) {
							errorloadingsite:=this.FFsiterrors() 
							if (errorloadingsite=1) {
								sleep 100
								;saita ne e v top 50
								hour:=A_Hour
								min:=A_min
								FileDelete, C:\UCB\Temp\nezarejda.txt
								FileAppend,
								(
									Sayt ne rabotayet %hour%:%min%
								), C:\UCB\Temp\nezarejda.txt
								sleep 100
								Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\contact_bez_scroll.ahk
								ExitApp
							}
							Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\kont_search.ahk
							ExitApp
						}
						sleep 1
					}
				}
				sleep 1
			}
			sleep 200
			return
		}
	;check if find bar exists
		FFSearchBarChecker() {
				activetab:=this.NomerActiveTab()
				checkrol:=tool bar
				searchbarurlraw := "application.grouping1.property_page.x.tool_bar1"
				StringReplace, searchbarurl, searchbarurlraw, .x, %activetab%
				searchbarRole := Acc_Get("Role", searchbarurl, 0, "ahk_class MozillaWindowClass")
				If (searchbarRole="tool bar")
				{
					goto, exitsearchrabput
				}
				else
				{
					WinActivate, ahk_class MozillaWindowClass
					sleep 50
					send {ctrl down}{f down}{f up}{ctrl up}
					sleep 100
				}
				exitsearchrabput:
				sleep 200
				return
			}
	;simulating mouse moves on website
		FFRandomScroll(currenterror="0") {
				movearray:= {"1":"HorMouseMove", "2":"VertMousemove", "3":"ElipseMousemove", "4":"UpDownMousemove"}
				movearray2:= { "1":"sleepnow", "2":"HorMouseMove", "3":"VertMousemove", "4":"ElipseMousemove", "5":"UpDownMousemove"}
				
				Random, sleeprand2, 1200, 1700
				sleep %sleeprand2%
				;random scroll or random move
				Random, scrollormove, 1, 3
				sleep 200
				msgbox, %scrollormove%<>%currenterror%
				this.browserWinAction("Firefox", "activate")
				if (scrollormove = 2) and (currenterror = 0) {
						scrollcheckres := this.FFScrollCheckNoMove()
						sleep 100
						msgbox, scrollcheckres  %scrollcheckres%
						if (scrollcheckres=0) {
								goto, nextmove1
						}
						;scroll
						Random, broinadolu, 1, 3
						Loop, %broinadolu%
						{
								posscroll:=this.FFVScrollPosPix()
								posstart:=posscroll+4
								possend:=posscroll+44
								MouseClick, left, 1010, %posstart%, 1, 3, D
								sleep 200
								MouseClick, left, 1010, %possend%, 1, 3, U
								sleep 200
								Random, sleeprand, 100, 500
								sleep %sleeprand%
						}
						goto, nextmove1
				}
				nextmove1:
				;move
				if (scrollormove=1) {
						Random, randmove, 1, 4
						for what, with in movearray {
								IfInString, randmove, %what%
								{
										WinActivate, ahk_class MozillaWindowClass
										sleep 50
										%with%()
										goto, sndtime
								}
								sleep 1
						}
						sndtime:
						sleep 700
						Random, randmove2, 1, 5
						for what2, with2 in movearray2 {
								IfInString, randmove2, %what2%
								{
										a=%with%
										a2=%with2%
										if (a=a2) {
												WinActivate, ahk_class MozillaWindowClass
												sleep 100
												goto, endnow1
										}
										WinActivate, ahk_class MozillaWindowClass
										sleep 50
										%with2%()
										goto, endnow1
								}
								sleep 1
						}
				}	
				endnow1:
				if (scrollormove=3) and (currenterror = 0) {
							scrollcheckres:=this.FFScrollCheckNoMove()
							sleep 100
							if (scrollcheckres=0) {
									goto, nextmove12
							}
							posscroll:=this.FFVScrollPosPix()
							Random, broinagore, 0, 3
							if (posscroll=138) {
									broinagore:=0
							}
							sleep 900
							Loop, %broinagore%
							{
									posscroll:=this.FFVScrollPosPix()
									posstart:=posscroll+8
									possend:=posscroll-30
									MouseClick, left, 1010, %posstart%, 1, 3, D
									sleep 200
									MouseClick, left, 1010, %possend%, 1, 3, U
									sleep 150
							}
				}
				nextmove12:
				sleep 827
				return
		}


		FFScrollCheckNoMove() {
				sbreal:=1
				black = 0x000000
				activetab:=this.FFNomerActiveTab()
				tab1docloc := "application.grouping1.property_page.x.unknown_object1.document1"
				StringReplace, tab1docloc, tab1docloc, .x, %activetab%
				Wtab1:=Acc_GetW("Location", tab1docloc, 0, "ahk_class MozillaWindowClass")
				PixelGetColor, cvqtscroll1, 1010, 671
				msgbox, cvqt %cvqtscroll1%
				if (Wtab1=1015) and (cvqtscroll1 = black) {
						sbreal:=1
						goto, 1sbgo3
				} else if (Wtab1=1015) and (cvqtscroll1 != black) {
						sbreal:=0
						goto, 1sbgo3
				} else if ( cvqtscroll1 = black) {
						sbreal:=1
						goto, 1sbgo3
				} else {
						msgbox, opopop
						sbreal:=0
						goto, 1sbgo3
				}
				1sbgo3:
				return, sbreal
		}

		FFVScrollPosPix() {

				scx:=1018
				scy:=138
				cvqtcheck=0x404040
				Loop {
						PixelGetColor, cvqtscroll1, %scx%, %scy%
						scy:=scy+1

						if (cvqtscroll1=cvqtcheck) {
								sb1:=scy-1
								goto, scrollformenu3
						}
						if (scy>690) {
								scy:=138
						}
						;sleep 1
				}
				scrollformenu3:
				return, sb1
		}
		FFScrollMid(errorloadingsite) {
				scx:=1018
				scy:=144
				cvqtcheck=0x404040
				
				this.FRandomScroll(errorloadingsite)
				sleep 400
				scrollcheckres := this.FFScrollCheckNoMove()
				sleep 100
				if (scrollcheckres=0) {
						sleep 100
						return
				}
				Loop {
						PixelGetColor, cvqtscroll1, %scx%, %scy%
						scy:=scy+1
						;proverka dali cveta pod pixela savpada s chernoto ot scrolla ->0x404040
						if (cvqtscroll1=cvqtcheck) {
								;scy-1 pokazva kade e nachaloto na scroll boxa
								sb1:=scy-1
								;msgbox, %sb1%
								;loop za otlrivane na kraqt na thumb-a
								Loop {
										PixelGetColor, cvqtscroll2, %scx%, %scy%
										scy:=scy+1
										if (cvqtscroll2!=cvqtcheck) {
												se1:=scy-1
												middle:=Ceil(sb1+((se1-sb1)/2))
												sbpos:=400    
												MouseClick, left, 1010, %middle%, 1, 3, D
												sleep 200
												MouseClick, left, 1010, %sbpos%, 1, 3, U
												sleep 100
												return
										}
								}
						}
				}
		}
		FFChangeCrAlZ() {
			this.CrAlZ()
			this.FFwaitAll()	
			sleep 100
			return
		}
		FFnevTop50PromqnaKeyword(searchwww) {
			checkfile:="Z:\SPODELEN\UCB\Txt\notintop.txt"
			Loop, Read, %checkfile%
			{
				Loop, Parse, A_LoopreadLine, \
				{
					if (A_LoopField=searchwww) {
						foundLine:=A_LoopreadLine
						StringGetPos, posInFoundLine, foundLine, \
						StringTrimLeft, keywords, foundLine, % (posInFoundLine+1)
						goto, pasteKeywordsNotInTop
					}
				}
			}
			searchwww=%searchwww%
			this.CrT()
			sleep 100
			this.sendingKeys(searchwww)
			this.messagebox("Change search words")
			sleep 200
			keywords:=this.FFGetCurrUrl()
			keywordToStore=%searchwww%\%keywords%
			FileAppend, `r`n%keywordToStore%, %checkfile%	
			sleep 100
			this.browserTabAction("Firefox", "close", 3)
			pasteKeywordsNotInTop:
			return, keywords
		}
		
		FFMainObject() {
			mainLocation	:= "application.grouping1.property_page2.unknown_object1.document1"
			currentObject 	:= Acc_Get("Object", mainLocation, 0, "ahk_class MozillaWindowClass")
			return, currentObject
		}
		
		FFOnScreenLocation(WorkSitePath, SearchEngine, clickButton="left"){
			YandexCheck=yandex
			
			Loop
			{
				WorkSiteX:=Acc_GetX("Location", WorkSitePath, 0, "ahk_class MozillaWindowClass")
				WorkSiteY:=Acc_GetY("Location", WorkSitePath, 0, "ahk_class MozillaWindowClass")
				WorkSiteH:=Acc_GetH("Location", WorkSitePath, 0, "ahk_class MozillaWindowClass")
				
				

				IfInString, SearchEngine, %YandexCheck%
				{
					valuemove	:= 225
					Xmclick		:= 29 ;50
					Ymclick		:= 220 ;621
					OffsetX		:= 38
					OffsetY		:= 10
				} else {
					valuemove	:= 210
					Xmclick		:= 6
					Ymclick		:= 300
					OffsetX		:= 17
					OffsetY		:= 10
				}
				if (WorkSiteY > valuemove) {

					endsitesite:=WorkSiteY+WorkSiteH
					if (WorkSiteY<650) and (endsitesite<650) {
						this.OffsetLMouseClick(WorkSiteX, WorkSiteY, OffsetX, OffsetY, clickButton)
						goto, endOSL
					} else {
						this.FFScroll(Xmclick, Ymclick, 1)
					}
				} else {

					this.FFScroll(Xmclick, Ymclick, 0)
				}
				sleep 25
			}
			endOSL:
			sleep 300
			return
		}	

		FFvmIpOrder(vmname) {
			nextvmloc:="Z:\SPODELEN\UCB\autostartVMs\startnextvm.txt"
			Loop
			{
				IfExist, %nextvmloc%
				{
					FileRead, vmnamefile, %nextvmloc%
					if (vmnamefile=vmname)
					{
						break
					}
				}
				sleep 15000
			}
			sleep 100
			return
		}

		InternetConnector(user) {

			Loop
			{
				RTT := Ping4("www.google.com", Result)
				If (ErrorLevel)
				{
					Loop
					{
						RunWait, rasdial xxx "%user%" "",, min
						sleep 4000
						RTT := Ping4("www.google.com", Result)
						If (ErrorLevel)
						{
							continue
						}
						Else
						{
							break 2
						}
					}
				}
				Else
				{
					break
				}
			}
			return
		}

		FFOpener()
		{
			IfWinExist, ahk_class MozillaWindowClass
			{
				goto, imaff
			}
			Run, "C:\Program Files\Mozilla Firefox\firefox.exe"
			sleep 1000
			WinWait, ahk_class MozillaWindowClass
			sleep 100
			WinActivate, ahk_class MozillaWindowClass
			sleep 200	
			WinMove, A,, 0, 0, 1023, 728
			sleep 200
			MouseMove, 81, 56, 2
			sleep 100
			MouseClick, left
			sleep 300
			imaff:
			return
		}
	
		FFGetWorkingIp() {
			;todays ip file location
			todaysIpFileLocation	:= "Z:\SPODELEN\UCB\autostartVMs\ipdaily.txt"
			vmfile					:= "Z:\SPODELEN\UCB\autostartVMs\startnextvm.txt"
			;ping.eu ip location
			iploc					:="application.grouping1.property_page1.unknown_object1.document1.table1.row2.cell1.table1.row1.cell1.editable_text2"
			;otvarq se ping.eu i se vzima nastoqshteto ip
			Loop, 3
			{
				this.CrL()
				sleep 100
				this.sendingKeys("ping.eu")
				this.Ente()
				this.FFwaitAll()	
				currentIp:=Acc_Get("Name", iploc, 0, "ahk_class MozillaWindowClass")
				sleep 100
				if (currentIp="") {
					continue
				} else {
					break
				}
			}

			StringGetPos, LastDot, currentIp, ., R
			StringLeft, ipsubnet, currentIp, %LastDot%

			FileGetTime, filetime, %todaysIpFileLocation%

			StringLeft, fileDay, filetime, 8
			StringRight, fileDay, fileDay, 2

			if (fileDay!=A_DD) {

				FileDelete, %todaysIpFileLocation%
				sleep 10
				FileAppend, %ipsubnet%`r`n, %todaysIpFileLocation%
				sleep 100
				FileDelete, %vmfile%
			} else {

				Loop, Read, %todaysIpFileLocation%
				{
					Loop, Parse, A_LoopreadLine, \
					{
						StringCaseSense Locale

						if (A_LoopField=ipsubnet)
						{

							RunWait, rasdial "%xxx%" /disconnect,, min
							sleep 200
							Run, C:\UCB\vmGuestStart.ahk
							ExitApp
						}
					}
				}
				sleep 10
				
				FileAppend, %ipsubnet%`r`n, %todaysIpFileLocation%
				sleep 100
				FileDelete, %vmfile%
			}
			sleep 300
			IfWinExist, ahk_class MozillaWindowClass
			{
				WinClose, ahk_class MozillaWindowClass
				sleep 200
			}
			this.FFOpener()

			sleep 200
			this.CrL
			this.sendingKeys("vzadache.ru")
			this.Ente()
			this.FFwaitAll()	

			return
		}
		FFRegChildChecker() {
			startPath := this.objectsRegion[this.objectsRegion.MaxIndex()]
			ChObj 	:= Acc_Get("Object", startPath , 0, "ahk_class MozillaWindowClass")
			If (isObject(ChObj)) {
				for each, child in Acc_Children(ChObj) {
					if (a_index < this.childPath[this.childPath.MaxIndex()]) {
						continue
					}
					if (instr(child .accName(0) ,"Показаны результаты")) {
						ret:="noscroll"
						this.objectsRegion:=[]
						this.childPath:=[]
						return, ret
					} else {
						if (child .accChildCount != 0) {
							WinGet, hwnd, ID, ahk_class MozillaWindowClass
							pathPage:=this.FFNormalPath(GetAccPath(child, hwnd))
							this.objectsRegion.Insert(pathPage)
							this.childPath.Insert(1)
								return this.FFRegChildChecker()
						} else {
							continue
						}	
					}
					sleep 1
				}
			}
			this.childPath.Remove(this.childPath.MaxIndex())
			this.objectsRegion.Remove(this.ObjectsRegion.MaxIndex())
			prevChildNumbet:= this.childPath[this.childPath.MaxIndex()]
			prevChildNumbet ++
			if (this.childPath.MaxIndex() < 2) {
				this.childPath := [] 
				this.childPath.Insert(prevChildNumbet)
			} else {
				this.childPath.Remove(this.childPath.MaxIndex())
				this.childPath.Insert(prevChildNumbet)
			}
			if (this.objectsRegion.MaxIndex() < 1) {
				return
			} else {
				return this.FFRegChildChecker()
			}
		}

	}
	
	