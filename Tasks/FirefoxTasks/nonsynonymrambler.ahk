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
	
	mail 			:= new Yandex
	searchWords 	:= mail.FFWordExtract(abbyyshot, "������� �������� �����:", "�",  "�", "non")
	sear 			:= mail.FFSEextract(abbyyshot, "������� �������� �����:", "�������� �������� ", 1)
	
	mail.FFSeLoad(sear, "IncludeL","newTab")
	mail.FFSeLoad(searchWords, "IncludeA","same")
	mail.useratorCtrl1()
	mail.useratorScreenPlusErrors()
	mail.messagebox("Opening a random web site")
	mail.useratorEndNPPX()


	ExitApp
	!^q::ExitApp
	return
