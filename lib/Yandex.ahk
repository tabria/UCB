;========================================================================================
; Yandex Class													            			;
;========================================================================================
	#NoEnv
	#Include Z:\SPODELEN\UCB\lib\Userator.ahk
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
	
	
	Class Yandex extends Userator {
	
		regionByHand	:= ["Ташкент","Новая Москва"]
		UrlStranici			:= array()
		targetPageInfo 		:= array()
		notInTop			:= array()
	
	;Check for yandex.com
		yandexComCheck(abbyyshot) {
			If InStr(abbyyshot, "yandex.com") {
				this.messagebox("RACHNO Ima yandex.com")
				sleep 300
				ExitApp
			}
			return
		}
	
		yandexSecondClickSearch(){
			this.yandexRemoveBrowserDownloadLink()
			sleep 200
			MouseClick, left, 701, 152, 1, 3
			sleep 200
			this.FFwaitAll()
			return
		}
		;get container's path
		yandexMainContainer(docobj, reg="region"){
			for each, subobj in Acc_Children(docobj) {
				Xpos:= Acc_LocationX(subobj).pos
				Hpos:= Acc_LocationH(subobj).pos
				if (Acc_GetRoleText(subobj .accRole(0))="list"){
					WinGet, hwnd, ID, ahk_class MozillaWindowClass
					if (reg="region") {
						return, pathchange:=this.FFNormalPath(GetAccPath(docobj, hwnd))
					} else {
						return, pathchange:=this.FFNormalPath(GetAccPath(subobj, hwnd))
					}
				}
				if (Acc_GetRoleText(subobj .accRole(0))="unknown object") and (Hpos>400) {
					return this.yandexMainContainer(subobj, reg)
				}
				sleep 1
			}
		}
		;containrer's path on second page
		yandexRegMainContainer() {
			pathchange 			:= ""
			regHolderCheck 		= Изменить регион
			
			mainObj 			:= this.FFMainObject()
			mainContainerPath	:= this.yandexMainContainer(mainObj, "region")
			currObj				:= Acc_Get("Object", mainContainerPath, 0, "ahk_class MozillaWindowClass")
			for each, part in Acc_Children(currObj) {
				name := part .accName(0)
				IfInString, name, %regHolderCheck%
				{
					WinGet, hwnd, ID, ahk_class MozillaWindowClass
					return, pathchange:=this.FFNormalPath(GetAccPath(part, hwnd))
				}
				sleep 1
			}
				this.messagebox("No Region")
				ExitApp
		}
		;make all regions to digits
		yandexAllRegionsDigits(finalReg){
			checkfile=Z:\SPODELEN\UCB\TXT\regionsNumbers.txt
			regNumber := 0
			
			if finalReg is Digit 
			{
				return finalReg
			}
			
			Loop, Read, %checkfile%
			{
				Loop, Parse, A_LoopreadLine, \
				{
					StringCaseSense Locale
					if (A_Index = 1){
						regNumber := A_LoopField
					}					
					if ((A_LoopField=finalReg) and (A_Index = 2))
					{
						goto, endRegNumbers
					}
				}	
			}
			endRegNumbers:
			return, regNumber
		}
		
		
		;get region from screenshot
		yandexRegionFromScreen() {
			checkfile=Z:\SPODELEN\UCB\TXT\regions.txt
			abbyyfile:="W:\zad.txt"
			openBrack:="регион ("
			inYanCheck = в Яндексе
			
			this.browserMinMaxAction("Firefox", "min")
			abbyfast() 
			FileRead, abbyyshot, %abbyyfile%
			sleep 100
			this.browserMinMaxAction("Firefox", "max")
			this.browserWinAction("Firefox", "activate")
			
			StringReplace, abbyyshot, abbyyshot, `r`n, %a_space%, All
			StringGetPos, inYanCheckPos, abbyyshot, %inYanCheck%
			StringLeft, yanCheckRemove, abbyyshot, % (inYanCheckPos-2)
			StringGetPos, openBrackPos, yanCheckRemove, %openBrack%
			StringTrimLeft, finalReg, yanCheckRemove, % (openBrackPos+strlen(openBrack))

			Loop, Read, %checkfile%
			{
				Loop, Parse, A_LoopreadLine, \
				{
					StringCaseSense Locale
					if ((A_LoopField=finalReg) and (A_Index = 1))
					{
						subReg:=A_LoopreadLine
						StringGetPos, subRegPos, subReg, \
						StringTrimLeft, addressValue, subReg, % (subRegPos+1)
						goto, pastezapros29
					}
				}
			}
			this.browserWinAction("Firefox", "activate")
			finalReg=%finalReg%

			this.CrT()
			this.sendingKeys(finalReg)
			this.messagebox("Correct Region")
			
			sleep 200
			addressValue:=this.FFGetCurrUrl()
			keyword=%finalReg%\%addressValue%
			FileAppend, `r`n%keyword%, Z:\SPODELEN\UCB\TXT\regions.txt
			sleep 100
			this.browserTabAction("Firefox", "close", 3)
			pastezapros29:
			finalVar=%addressValue%
			this.browserTabAction("Firefox", "change", 2)
			sleep 100
			return, finalVar
		}
		;get current region
		yandexCurrentRegion(){
			toAdd 				:= ".1"
			mainContainerPath	:= this.yandexRegMainContainer()
			;adding .1 to open the link container with the name of the region
			trueRegionPath		:= mainContainerPath toAdd
			regionName 			:= Acc_Get("Name", trueRegionPath, 0, "ahk_class MozillaWindowClass")
			return, regionName
		}
		
		yandexRegionForRegion(searchEngine) {
			
			checkInfo			:= "Дополнительная информация о запросе"
			yandexRu := "yandex.ru"
			
			currentUrl := this.FFGetCurrUrl()
			IfNotInString, currentUrl, %searchEngine%
			{
				this.messagebox("Change region to coincides with the domain")
				return
			}
			
			mainObj				:= this.FFMainObject()
			mainContainerPath	:= this.yandexMainContainer(mainObj, "region")
			CurObj 				:= Acc_Get("Object", mainContainerPath, 0, "ahk_class MozillaWindowClass")

			for each, result in Acc_Children(CurObj) {

				nameNow := result .accName(0)
				if inStr(nameNow, checkInfo) {
					WinGet, hwnd, ID, ahk_class MozillaWindowClass
					pathPage:=this.FFNormalPath(GetAccPath(result, hwnd))
					this.objectsRegion.Insert(pathPage)
					this.childPath.Insert(1)
					valT := this.FFRegChildChecker()
					if (valT="noscroll") {
						this.messagebox("Change region to coincides with the domain")
						return
					}
				}
				sleep 1
			}
			return
		}

		yandexCheckRegionForErrors() {
			regionNow	:= this.yandexCurrentRegion()
			
			For vo, bo in this.regionByHand {	
				If InStr(regionNow, bo) {
					this.messagebox("Moscow region problem!! Will Exit")
					ExitApp
				}
				sleep 1
			}
		}
		
		;change region
		yandexRegionChanger() {
			regClip		:= this.yandexRegionFromScreen()
			regionNow	:= this.yandexCurrentRegion()

			if regClip is digit
			{
				;digit
				irvalue := this.FFGetCurrUrl()
				irQCheck := "?lr="
				ampCheck := "&"
				irEqualCheck := "lr="
				StringCaseSense, Locale
				IfInString, irvalue, %irQCheck%
				{
					StringGetPos, ampPos, irvalue, %ampCheck%
				} else {
					StringGetPos, ampPos, irvalue, %ampCheck%, L2
				}
				StringGetPos, irEqualPos, irvalue, %irEqualCheck%
				if (ampPos < 1) {
					LeftKeys := 0
				} else {
					leftKeys := StrLen(irvalue) - ampPos
				}
				delKeys := StrLen(irvalue) - irEqualPos - strLen(irEqualCheck) - LeftKeys
				this.CrL()
				this.En()
				if (leftKeys > 0) {
					Loop, %leftKeys% {
						this.lef()
					}
				}
				sleep 100
				Loop, %delKeys% {
					this.backspac()
				}
				this.sendingKeysPageLoad(regclip, "NA", 1)
				this.yandexRemoveBrowserDownloadLink()
				
			} 
			else IfInString, regclip, %regionNow%
			{
				goto, endRegChanger
			} else {

				mainObj		:= this.FFMainObject()
				mainPath 	:= this.yandexRegMainContainer(mainObj)
				this.FFOnScreenLocation(mainPath, "yandex")
				this.FFwaitAll()
				this.yandexRegClick()
				this.sendingKeysPageLoad(regClip, "A", 0)
				this.Ente()
				sleep 200
				this.Ente()
				this.FFwaitAll()
				urlNow := this.FFGetCurrUrl()
				if inStr(urlNow, "tune") {
					this.messagebox("Region Page Problem!! Will Exit")
					ExitApp
				}
				this.yandexRemoveBrowserDownloadLink()
			}
			endRegChanger:
			sleep 200
			return
		}
		;put region in tune field
		yandexRegClick() {
			regionpath:="application.grouping1.property_page2.unknown_object1.document1.unknown_object2.unknown_object1.unknown_object2"
			Loop
			{
				xRegionLoc:= Acc_GetX("location", regionpath, 0, "ahk_class MozillaWindowClass")
				yRegionLoc:= Acc_GetY("location", regionpath, 0, "ahk_class MozillaWindowClass")
				if (xRegionLoc="")
				{
					goto, againregpole
				}
				this.OffsetLMouseClick(xRegionLoc, yRegionLoc, 363, 55, "left") 
				sleep 100
				goto, exitamdpastereg
				againregpole:
				sleep 2
			}
			exitamdpastereg:
			return
		}
		;scroll page if region is not special
		yandexScrollRegion() {
			checkInfo			:= "Дополнительная информация о запросе"
			mainObj				:= this.FFMainObject()
			mainContainerPath	:= this.yandexMainContainer(mainObj, "region")
			CurObj 				:= Acc_Get("Object", mainContainerPath, 0, "ahk_class MozillaWindowClass")

			for each, result in Acc_Children(CurObj) {
				nameNow := result .accName(0)
				if inStr(nameNow, checkInfo) {
					WinGet, hwnd, ID, ahk_class MozillaWindowClass
					pathPage:=this.FFNormalPath(GetAccPath(result, hwnd))
					this.objectsRegion.Insert(pathPage)
					this.childPath.Insert(1)
					valT := this.FFRegChildChecker()
					if (valT="noscroll") {
						goto, noscrollReg
					}
				}
				sleep 1
			}
			MouseClick, left, 20, 230, 1, 3
			sleep 50
			this.En()
			noscrollReg:
			
			sleep 100
			return
		}
		;yandex search bar clicker shortcut alt+shift+s
		yandexSBLocator() {
			mainObj	:= this.FFMainObject()
			for each, val in Acc_Children(mainObj) {
				Hpos := Acc_LocationH(val).pos
				if ((Hpos > 50) and (Hpos < 75)) {
					Xpos := Acc_LocationX(val).pos
					Ypos := Acc_LocationY(val).pos
					this.OffsetLMouseClick(Xpos, Ypos, 394, 36, "left")
					sleep 3000
					return
				}
				sleep 1
			}
			return
		}
		;yandex rezults
		yandexResults(notToOpenSitesOrPageToFind, targetPage) {
			mainObj 		:= this.FFMainObject()
			position		:= 0
			yandexListPath	:= this.yandexMainContainer(mainObj, "list")
			listObj 		:= Acc_Get("Object", yandexListPath, 0, "ahk_class MozillaWindowClass")
			for each, firstchild in Acc_Children(listObj) {
				if (firstChild .accName(0) = "Реклама") {
					continue
				}
				for each, secondChild in Acc_Children(firstChild) {
					for each, thirdChild in Acc_Children(secondChild) {
						if (Acc_GetRoleText(thirdChild .accRole(0))="link") {
							urlToInsert:=this.FFWebPos(thirdChild, notToOpenSitesOrPageToFind, "yandex", targetPage)

							if (urlToInsert!="") {
								position := position + 1
							}
							if ((targetPage = "Yes") and (urlToInsert != "Ne e Path") and (urlToInsert != "")) {
								this.targetPageInfo.Insert(urlToInsert)
								this.targetPageInfo.Insert(position)
								return
							}
							if (urlToInsert !="") {
								this.UrlStranici.Insert(urlToInsert)
							}
							goto, exitSecondChild
						}
						if (Acc_GetRoleText(thirdChild .accRole(0))="unknown object") {
							for each, fourthChild in Acc_Children(thirdChild) {
								if (Acc_GetRoleText(fourthChild .accRole(0))="link") {
									urlToInsert:=this.FFWebPos(fourthChild, notToOpenSitesOrPageToFind, "yandex", targetPage)
									if (urlToInsert!="") {
										position := position + 1
									}
									if ((targetPage = "Yes") and (urlToInsert != "Ne e Path") and (urlToInsert != "")) {
										this.targetPageInfo.Insert(urlToInsert)
										this.targetPageInfo.Insert(position)
										return
									}
									if (urlToInsert !="") {
										this.UrlStranici.Insert(urlToInsert)
									}
									goto, exitSecondChild
								}
								sleep 1
							}
						}
						sleep 1
					}
					sleep 1
				}
				exitSecondChild:
				sleep 1
			}
			return
		}
		;remove link for downloading yandex browser
		yandexRemoveBrowserDownloadLink() {
		mainObj 		:= this.FFMainObject()
			yandexListPath	:= this.yandexMainContainer(mainObj, "list")
			StringTrimRight, noList, yandexListPath, 2
			UnObj 		:= Acc_Get("Object", noList, 0, "ahk_class MozillaWindowClass")
			for each, chi in Acc_Children(UnObj) {
				xpos:=Acc_LocationX(chi).pos
				if (xpos = 4) {
					this.OffsetLMouseClick(975, 142, 0, 0, "left")
					sleep 3000
					break
				}
				sleep 1
			}
			return
		}
			
		
	}