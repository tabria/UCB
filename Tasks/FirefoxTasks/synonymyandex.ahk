#NoEnv
#SingleInstance force
#Include Z:\SPODELEN\UCB\lib\vlibrary.ahk
#Include Z:\SPODELEN\UCB\lib\Yandex.ahk
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
	searchEngine	:="yandex"

	FileRead, abbyyshot, %abbyyfile%
	
	yan := new Yandex
	searchWords 	:= yan.FFWordExtract(abbyyshot, "������� �����:", "�",  "�", "syn")
	sear 			:= yan.FFSEextract(abbyyshot, "� ��������", "�������� ", 1)
	yan.yandexComCheck(abbyyshot)
	synonym := yandex.FFSynonymMaker(searchWords, searchEngine)
	yan.FFSeLoad(sear, "IncludeL", "newTab")
	yan.FFSeLoad(synonym, "IncludeA","same")
	yan.yandexSecondClickSearch()
	
	yan.yandexRegionForRegion(sear)
	
	yan.useratorCtrl1()
	yan.yandexRegionChanger()
	
	yan.yandexCheckRegionForErrors()
	
	yan.yandexScrollRegion()
	yan.useratorScreenPlusErrors()
	yan.browserTabAction("Firefox", "change", 2)
	yan.Hom()
	yan.yandexSBLocator()
	yan.FFSeLoad(searchWords, "IncludeA", "same")
	yan.yandexRemoveBrowserDownloadLink()
	yan.useratorActivate()
	yan.useratorCtrl1()
	SluchSitesNoGo	:= yan.useratorBezSluchainiStranici("syn", searchEngine, "middle")
	yan.yandexResults( SluchSitesNoGo, "No")
	yan.browserRandomChisla(2, 38, 10, searchEngine)
	yan.useratorSiteShotsSinon()
	;search for website
	searchwww		:= yan.FFUrlSearchResult()
	yan.browserTabAction("Firefox", "change", 2)
	yan.useratorFindTargetPage(searchwww, "Yes", searchEngine)
	;loading old version of the site walk
	yan.useratorScrollTargetPagePosition(searchEngine, searchwww, "No", "middle")

	

	ExitApp
	!^q::ExitApp
	return



