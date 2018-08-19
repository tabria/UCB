#NoEnv
#SingleInstance force
#Include Z:\SPODELEN\UCB\lib\vlibrary.ahk
#Include Z:\SPODELEN\UCB\lib\Google.ahk
#Include Z:\SPODELEN\UCB\lib\Acc.ahk
#Include Z:\SPODELEN\UCB\lib\Userator.ahk
#KeyHistory 0
#MaxThreads 225
#MaxMem 256
CoordMode, Mouse, Screen
SetTitleMatchMode 2
SetKeyDelay, 50, 10
SetBatchLines, -1
SetControlDelay -1
ListLines, Off
StringCaseSense, Locale


	abbyyfile		:="W:\zad.txt"
	urlArray		:= array()
	searchEngine	:="google"
	
	FileRead, abbyyshot, %abbyyfile%
	
	goog 			:= new Google
	searchWords 	:= goog.FFWordExtract(abbyyshot, "������� �����:", "�",  "�", "syn")
	sear 			:= goog.googleSENCR(abbyyshot, "� ��������", "�������� ", 1)
	
	synonym := goog.FFSynonymMaker(searchWords, searchEngine)
	goog.FFSeLoad(sear, "IncludeL", "newTab")
	goog.FFSeLoad(synonym, "IncludeA","same")
	goog.googleavcheck()
	mainObj 		:= goog.FFMainObject()
	goog.googleWrongSearchClick(mainObj)
	goog.useratorCtrl1()
	goog.useratorScreenPlusErrors()
	goog.browserTabAction("Firefox", "change", 2)
	goog.GoogleSearchBarLoc()
	goog.FFSeLoad(searchWords, "IncludeA", "same")
	goog.googleavcheck()
	mainObj 		:= goog.FFMainObject()
	goog.googleWrongSearchClick(mainObj)
	goog.useratorActivate()
	goog.useratorCtrl1()
;put forbidden pages in an array
	SluchSitesNoGo	:= goog.useratorBezSluchainiStranici("syn", searchEngine, "middle")
	goog.googBaseAll(SluchSitesNoGo, "No")
	goog.browserRandomChisla(2, 17, 10, searchEngine)
	goog.useratorSiteShotsSinon()
;searching for the target site
	searchwww		:= goog.FFUrlSearchResult()
	goog.browserTabAction("Firefox", "change", 2)
	goog.useratorFindTargetPage(searchwww, "Yes", searchEngine)
	goog.useratorScrollTargetPagePosition(searchEngine, searchwww, "Yes", "middle")



	ExitApp
	!^q::ExitApp
	return



