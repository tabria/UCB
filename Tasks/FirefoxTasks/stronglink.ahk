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


	
	stro := new Yandex

	stro.browserTabAction("Firefox", "close", 2)
	stro.CrT()	
	stro.CrLAV()
	stro.Ente()
	stro.FFwaitAll()
	stro.useratorActivate()
	stro.useratorCtrl1()
	stro.UseratorExistnew()
	stro.UseratorErrornew()
	stro.messageTripleButton("OK //// Missing Link //// Cancel")
	ifmsgbox Yes
	{
		goto, vsichkoeok
	}
	ifmsgbox No
	{
		;Missing link
		FileDelete, C:\Neshta\Autohotkey Scripts\Auto_firefox\Vzadache_text\nqmalink.txt
		FileAppend,
		(
			Net ssylka v shag 2
		), C:\Neshta\Autohotkey Scripts\Auto_firefox\Vzadache_text\nqmalink.txt
		goto, vsichkoeok
	}
	else
	{
		ExitApp
	}
	vsichkoeok:
	stro.browserWinAction("Firefox", "activate")
	stro.browserTabAction("Firefox", "change", 2)
	stro.useratorActivate()
	stro.useratorCtrl1()
	stro.UseratorExistnew()
	stro.UseratorErrornew()
	stro.useratorScreenshot()
	stro.useratorActivate()
	stro.useratorCtrl1()
	stro.UseratorExistnew()
	stro.UseratorErrornew()
	stro.browserWinAction("Firefox", "activate")
	stro.browserTabAction("Firefox", "change", 3)
	stro.FFwaitAll()
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\razhodka.ahk
	ExitApp

!^q::ExitApp
return