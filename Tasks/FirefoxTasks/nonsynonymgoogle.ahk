#NoEnv
#SingleInstance force
#Include Z:\SPODELEN\UCB\lib\vlibrary.ahk
#Include Z:\SPODELEN\UCB\lib\Google.ahk
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
	
	goog 			:= new Google
	searchWords 	:= goog.FFWordExtract(abbyyshot, "Введите ключевое слово:", "»",  "«", "non")
	sear 			:= goog.googleSENCR(abbyyshot, "Введите ключевое слово:", "«", 2)
	
;open search engine in firefox tab
	goog.FFSeLoad(sear, "IncludeL", "newTab")
	goog.FFSeLoad(searchWords, "IncludeA", "same")
	goog.googleavcheck()
	mainObj := goog.FFMainObject()
	goog.googleWrongSearchClick(mainObj)
	goog.useratorCtrl1()
	goog.useratorScreenPlusErrors()
	goog.useratorScreenPlusErrors()
;putting forbidden pages in array
	SluchSitesNoGo	:= goog.useratorBezSluchainiStranici("non", "google", "middle")
	goog.googBaseAll(SluchSitesNoGo, "No")
	goog.browserRandomChisla(1, 17, 10, "google") 
	goog.useratorEndNPPX()
	
	ExitApp
	!^q::ExitApp
	return



