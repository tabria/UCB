;========================================================================================
; Google Class													            			;
;========================================================================================
	#NoEnv
	#Include Z:\SPODELEN\UCB\lib\userator.ahk
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
	
	
	Class Google extends Userator {

		UrlStranici		:= Array()
		targetPageInfo 	:= Array()
		notInTop		:= Array()
	
	;google search engine check
		googleSENCR(abbyyshot, removeword1, removeword2, offset) {
			GoogleDomainArray:={"google.co.th" : ".th",  "google.co.uz":".uz", "google.com.my" : ".ту", "google.co.id" : ".id", "google.co.in" : ".in", "google.ae" : "80ak", "google.by":".ьу"}
			rawse := this.FFSEextract(abbyyshot, removeword1, removeword2, offset)
			If (rawse="google.com") {
				engineToSearch=%rawse%/ncr
				goto, exitSEExtract
			}
			for goog, name1 in GoogleDomainArray {
				IfInString, rawse, %name1%
				{
					engineToSearch=%goog%
					goto, exitSEExtract
				}
				sleep 1
			}
			engineToSearch=%rawse%
			exitSEExtract:
			sleep 200
			return engineToSearch
		}

		googleavcheck() {
			CheckDoc=- Поиск в Google
			captchacheck=sorry
				
			captchaecxist:= Acc_Get("Value", this.mainLocation, 0, "ahk_class MozillaWindowClass")
			IfInString, captchaecxist, %captchacheck%
			{
				this.messagebox("!!!!Captcha Google !!!! Captcha Google !!!!!")
				sleep 200
				this.FFwaitAll()	
			}
			searchgoogbg2 := Acc_Get("Name", this.mainLocation, 0, "ahk_class MozillaWindowClass")
			StringGetPos, textpos, searchgoogbg2,  %CheckDoc%
			if (textpos>-1) {
				StringLeft, Cleantext, searchgoogbg2, textpos-1
				if (cleantext = tocheck) or (cleantext = tocheck2) or (cleantext = tocheck3) {
					this.messagebox("Incorrect paste")
					ExitApp
				}
			}
			IfInString, searchgoogbg2, %CheckDoc%
			{
				goto, nextstepnow2
			} else {
				this.GoogleLangChange()
				sleep 200
				goto, nextstepnow2
			}
			nextstepnow2:
			return
		}
	;change lang to russian 
		GoogleLangChange() {
				langcheck=languages
				;click on settings
				this.OffsetLMouseClick(678, 222,  0, 0, "left")
				this.FFwaitAll(1, 450)	
				sleep 300
				;click on lang
				this.OffsetLMouseClick(678, 282,  0, 0, "left")
				this.FFwaitAll()
				;click on radio button for rus lang
				this.OffsetLMouseClick(531, 376,  0, 0, "left")
				sleep 300
				;click on save button
				this.OffsetLMouseClick(730, 575,  0, 0, "left")
				sleep 200
				Loop, 20
				{
					DescrLoc:="application.grouping1.property_page2.dialog"
					Descr:=Acc_Get("Description", DescrLoc, 0, "ahk_class MozillaWindowClass")
					if (descr!="") {
						this.Ente()
						sleep 200
						this.FFwaitAll()
						break
					}
					sleep 100
				}
				return
		}
	;autocorrect
		googleWrongSearchClick(docObj) {
			linknow := 0

			for each, obj in Acc_Children(docObj) {
				Hpos:=Acc_LocationH(obj).pos	
				Xpos:=Acc_LocationX(obj).pos

				If ((Xpos=154) or (Xpos = 170)) and (Hpos<100) and (Hpos>40) {
					if (Xpos = 170) {
						for each, child in Acc_Children(obj) {
			
							if (Acc_GetRoleText(child .accRole(0))="editable text") 
								and ( Instr(child.accName(0), "Искать вместо этого") 
								or InStr(child .accName(0), "Искать только" )) {
						
									linknow := 1
							} else if (Acc_GetRoleText(child .accRole(0))="editable text") 
								and (child .accName(0) = "Не найдено результатов по запросу ")   {
									
									return this.messagebox("Nqma rezultati za tarseneto Promqna i OK !!!!")
							} else if (Acc_GetRoleText(child .accRole(0))="link") and (linknow = 1) {
									
									ErrorX:=Acc_LocationX(child).pos
									ErrorY:=Acc_LocationY(child).pos
									this.OffsetLMouseClick(ErrorX, ErrorY,  12, 6, "left") 
									this.FFwaitAll()
									return
							} else  {
								sleep 1
							}
						}
					}
					return this.googleWrongSearchClick(obj)
				}
				if (Acc_GetRoleText(obj .accRole(0))="unknown object") {	
					if (hpos>400) {

						return this.googleWrongSearchClick(obj)
					}
					if (xpos = 154) and (hpos >40 ) {

						return this.googleWrongSearchClick(obj)
					}
				}
			}
		}

		GoogleBaseMain(docobj) {
			WinGet, hwnd, ID, ahk_class MozillaWindowClass
			hPrev:=0

			for each, obj in Acc_Children(docobj) {
				Hpos:=Acc_LocationH(obj).pos
				if (Hpos !=0 && Hpos>Hprev) {
					Hprev := Hpos
				}
				sleep 1
			}
			for each, obj in Acc_Children(docobj){
				Xpos:=Acc_LocationX(obj).pos
				Hpos:=Acc_LocationH(obj).pos

				if (xpos=170) and (hpos=hPrev) {
					return this.FFNormalPath(GetAccPath(obj, hwnd)) . ".1.2.1" 
					
				}
				if (Acc_GetRoleText(obj .accRole(0))="unknown object") and (Hpos=hPrev) {
					return this.GoogleBaseMain(obj) 
				}
				sleep 1
			}
		}
		
		googleResultFinder(path, sitesNotToFind, targetPage) {
			if (path="") {
				this.messagebox("Chck in main H!!!!Will Exit")
				ExitApp
			}
			ParObj	:= Acc_Get("Object", path, 0, "ahk_class MozillaWindowClass")
			loopCount:=ParObj .accChildCount
			if (loopCount = 0) {

				this.messagebox("Error in child's number!! Will Exit")
				ExitApp
			}
			Loop % loopCount {
				SubParPath := path . "." . a_Index . ".1"
				subParObj	:= Acc_Get("Object", SubParPath, 0, "ahk_class MozillaWindowClass")
				for each, subParChild in Acc_Children(subParObj) {
					childs := subparObj .accChildCount
				
					this.googleInsertResult(subParChild, sitesNotToFind, targetPage)

					sleep 1
				}
				sleep 1
			}	
			return
		}

		googleInsertResult(obj, sitesNotToFind, targetPage){
			for each, resultChild in Acc_Children(obj) {
				hpos1 := Acc_LocationH(resultChild).pos
				xpos1 := Acc_LocationX(resultChild).pos

				if ((xpos1 != 170) or (hpos1 < 20)) {
					return
				}
				if (hpos1 = 22) {
					return this.googleInsertResult(resultChild, sitesNotToFind, targetPage)
				}
				if  (hpos1 = 21) and (Acc_GetRoleText(resultChild .accRole(0))="link") {
					urlToInsert:=this.FFWebPos(resultChild, sitesNotToFind, "google", targetPage)
					this.posi := this.posi + 1
					a:= this.posi

					if ((targetPage = "Yes") and (urlToInsert != "Ne e Path") and (urlToInsert != "")) {
						this.targetPageInfo.Insert(urlToInsert)
						this.targetPageInfo.Insert(this.posi)
						return
					}
					if (urlToInsert !="") {

						this.UrlStranici.Insert(urlToInsert)
						return
					}
					return
				}
				sleep 1
			}
			return this.googleInsertResult(resultChild, sitesNotToFind, targetPage)
		}
		
		googBaseAll(pageToFind, targetPage) {
			mainObj 	:= this.FFMainObject()
			mainPath	:= this.GoogleBaseMain(mainObj)
			this.googleResultFinder(mainPath, pageToFind, targetPage)
			return
		}

		GoogleSearchBarLoc() {
			mainLocation	:= "application.grouping1.property_page2.unknown_object1.document1"
			docobj 	:= Acc_Get("Object", mainLocation, 0, "ahk_class MozillaWindowClass")
			
			for each, obj in Acc_Children(docobj) {
				Hpos:=Acc_LocationH(obj).pos
				Xpos:=Acc_LocationX(obj).pos
				
				if (Xpos = 4) and (Hpos > 40) {
					Ypos:=Acc_LocationY(obj).pos
					
					this.OffsetLMouseClick(Xpos, Ypos, 433, 22, "left")
					sleep 200
					return
				}
				sleep 1
			}
			this.messagebox("Search bar not found!!! Will Exit")
			return
		}	
	}