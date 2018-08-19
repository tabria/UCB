#NoEnv
#SingleInstance force
#Include Z:\SPODELEN\UCB\lib\vlibrary.ahk
#Include Z:\SPODELEN\UCB\lib\BrowserBase.ahk
#Include Z:\SPODELEN\UCB\lib\Firefox.ahk
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


;Starting point


abbyyfile:="W:\zad.txt"


;Deleteing txt files for the comment and for the yandex region
	loop, 4 {
	DeleteTxtFiles()
;creating new instance ot userator class
	userat	:= new Userator
	userat.browserWinAction("Firefox", "activate")
	userat.browserTabAction("Firefox", "close", 2)
	userat.useratorActivate()
	userat.useratorExistnew()
	userat.useratorErrornew()
;Change Lang to EN
	SendMessage, 0x50, 0, 0x4090409,, A
	sleep 100
;minimizing Firefox	
	userat.browserMinMaxAction("Firefox", "min")
	userat.useratorActivate()	
;Screenshot
	abbyfast()
	userat.browserMinMaxAction("Firefox", "max")
	FileRead, abbyyshot, %abbyyfile%
	sleep 100
	
;======================================================================
;              ------------ Task Distributor -----------------
;======================================================================
; Open scripts for task
	userat.browserTaskFullPath(abbyyshot)
	userat.useratorNovoZadanie()
	sleep 10000
}
	sleep 177687
	Run % A_ScriptFullPath
	ExitApp
ExitApp

 
		 
!^q::ExitApp
return
