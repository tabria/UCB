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

	direct2=Прогулка по сайту
	direct3=Переход на целевую страницу
	abbyyfile:="W:\zad.txt"
	
	dirweb := new Yandex
	
	dirweb.browserTabAction("Firefox", "close", 2)
	dirweb.useratorActivate()
	dirweb.useratorCtrl1()
	dirweb.UseratorExistnew()
	dirweb.UseratorErrornew()
	dirweb.browserWinAction("Firefox", "activate")
	dirweb.CrT()
	sleep 400
	dirweb.CrLV()
	dirweb.Ente()
	dirweb.FFwaitAll()
	dirweb.useratorActivate()
	dirweb.useratorCtrl1()
	dirweb.UseratorExistnew()
	dirweb.UseratorErrornew()
	dirweb.useratorActivate()
	WinGetActiveStats, title, width, height, x, y

	if (width=386) and (height=189)
	{
		Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\razhodka.ahk
		ExitApp
	}
	sleep 10
	dirweb.browserMinMaxAction("Firefox", "min")
	abbyfast() 
	FileRead, abbyyshot2, %abbyyfile%
	sleep 100
	dirweb.browserMinMaxAction("Firefox", "max")
	dirweb.browserWinAction("Firefox", "activate")
	IfInString, abbyyshot2, %direct2%
	{
		Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\razhodka.ahk
		ExitApp
	}
	IfInString, abbyyshot2, %direct3%
	{
		Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\kont_search.ahk
		ExitApp
	}
	dirweb.messagebox("Ima banner")
	sleep 300
	dirweb.useratorActivate()
	dirweb.useratorCtrl1()
	dirweb.useratorScreenPlusErrors()
	
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\razhodka.ahk
	ExitApp
	
	!^q::ExitApp
	return