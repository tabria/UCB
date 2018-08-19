#Include Z:\SPODELEN\UCB\lib\Acc.ahk
#Include Z:\SPODELEN\UCB\lib\vlibrary.ahk
;#Include Z:\SPODELEN\UCB\lib\BrowserBase.ahk
#Include Z:\SPODELEN\UCB\lib\Userator.ahk
#Include Z:\SPODELEN\UCB\lib\Yandex.ahk
;#Include Z:\SPODELEN\UCB\lib\google.ahk
;#Include Z:\SPODELEN\UCB\lib\FirefoxFuncs.ahk
;#Include Z:\SPODELEN\UCB\lib\msgboxes.ahk
;#Include Z:\SPODELEN\UCB\lib\Firefox.ahk
;#Include Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\vzadache\vlibrary.ahk
;#Include Z:\SPODELEN\UCB\lib\trayIcon.ahk
#InstallKeybdHook
StringCaseSense, Locale

f3::

;global UrlStranici	:= Array()

	abbyyfile		:="Z:\SPODELEN\zad5.txt"
	searchEngine :="google"
	FileRead, abbyyshot, %abbyyfile%

;msgbox, start
yan	:= new Yandex
;goog	:=new Google
	
	mainLocation	:= "application.grouping1.property_page2.unknown_object1.document1"
	docObj 			:= Acc_Get("Object", mainLocation, 0, "ahk_class MozillaWindowClass")

yan.yandexSBLocator()
	

msgbox, exit out 

ExitApp
!^q::ExitApp
return




