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

	FileRead, abbyyshot, %abbyyfile%
	
	yan 			:= new Yandex
	searchWords 	:= yan.FFWordExtract(abbyyshot, "������� �������� �����:", "�",  "�", "non")
	sear 			:= yan.FFSEextract(abbyyshot, "������� �������� �����:", "�", 2)
	
	
	yan.yandexComCheck(abbyyshot)
	yan.FFSeLoad(sear, "IncludeL","newTab")
	yan.FFSeLoad(searchWords, "IncludeA","same")
	yan.yandexSecondClickSearch()
	
	yan.yandexRegionForRegion(sear)
	
	yan.useratorCtrl1()
	yan.yandexRegionChanger()
	
	yan.yandexCheckRegionForErrors()
	
	yan.yandexScrollRegion()
	yan.useratorScreenPlusErrors()
	yan.browserTabAction("Firefox", "change", 2)
	yan.Hom()
	yan.useratorScreenPlusErrors()
	SluchSitesNoGo	:= yan.useratorBezSluchainiStranici("synon", "yandex", "middle")
	yan.yandexResults(SluchSitesNoGo, "No")
	yan.browserRandomChisla(1, 38, 10, "yandex") 
	yan.useratorEndNPPX()

	
	ExitApp
	!^q::ExitApp
	return



