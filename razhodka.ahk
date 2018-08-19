#NoEnv
#SingleInstance force
#Include Z:\SPODELEN\UCB\lib\vlibrary.ahk
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

;Walk on site

errorloadingsite:=0
userpath		:="dialog"
contactW		:={"1":"553", "2":"601"}
contactH		:={"1":"172", "2":"155"}

walk := new Userator

; ---------------------- Step Walk -------------------------
;closing of empty tabs
walk.useratorNotOnTop()
walk.browserWinAction("Firefox", "activate")
walk.FFWalkContactCheck()
walk.Cr9()
walk.FFwaitAll()	
errorloadingsite := walk.FFsiterrors()
if (errorloadingsite=1)
{
	Ctrl1UseratorChecknewnoscroll()
	sleep 100
	goto, errorsitenow
}

Ctrl1UseratorChecknewMousemove()
sleep 100

;check for server not fount error
errorloadingsite:=siterrors()
if (errorloadingsite=1)
{
	goto, errorsitenow
}

WinActivate, ahk_class MozillaWindowClass
sleep 50
ScrollMid()
sleep 100

errorsitenow:
WinActivate, ahk_class UseratorGUI
sleep 50

;take screenshots of the random sites
SluchSaitSnimkanew()
UseratorExistnew()
UseratorErrornew()

;check if next step is contact
sleep 100
WinActivate, ahk_class UseratorGUI
sleep 100
wUser := Acc_GetW("Location", userpath, 0, "ahk_class UseratorGUI")
hUser := Acc_GetH("Location", userpath, 0, "ahk_class UseratorGUI")
for what, with in contactW
{
	If	(wUser=with)
	{
		for vhat, vith in contactH
		{
			If (hUser=vith)
			{
				errorloadingsite:=siterrors()
				if (errorloadingsite=1)
				{
					sleep 100
					;website is not in top 50
					hour:=A_Hour
					min:=A_min
					FileDelete, C:\Neshta\Autohotkey Scripts\Auto_firefox\Vzadache_text\nezarejda.txt
					FileAppend,
					(
						Sayt ne rabotayet %hour%:%min%
					), C:\Neshta\Autohotkey Scripts\Auto_firefox\Vzadache_text\nezarejda.txt
					sleep 100
					Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\contact_bez_scroll.ahk
					ExitApp
				}
				Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\kont_search.ahk
				ExitApp
			}
		}
	}
}
sleep 50
WinActivate, ahk_class MozillaWindowClass
sleep 50
Cr9()
sleep 100
Tab2UrlSite:=ClearUrl()
StringReplace, Tab2UrlSiteFinal, Tab2UrlSite,.,-, All
sleep 100
Run, Z:\SPODELEN\sitepages\%Tab2UrlSiteFinal%.ahk,, UseErrorLevel
if ErrorLevel = ERROR
{
	goto, nqmacontactscheck
}
else
{
	sleep 50
	ExitApp
}
nqmacontactscheck:
if (errorloadingsite=1)
{
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\razhodka.ahk
	ExitApp
}
sleep 100
FileRead, nqmacont, Z:\SPODELEN\nqmasitepages.txt
IfInString, nqmacont, %Tab2UrlSiteFinal%
{
	goto, urlsiteloopok
}
		Gui, Font, bold
	Gui, Add, GroupBox, x2 y2 w150 h60, Start LinkCreator
	Gui, Font
	Gui, Add, Button, x6 y30 w140 h22 vlc glc, LinkCreator
		Gui, Font, bold
	Gui, Add, GroupBox, x152 y2 w150 h60  , Bez LinkCreator
	Gui, Font
	Gui, Add, Button, x157 y30 w140 h22 vbezlc gbezlc, Bez LinkCreator
		Gui, Font, bold
	Gui, Add, GroupBox, x2 y64 w150 h60 , Cancel
	Gui, Font
	Gui, Add, Button, x6 y92 w140 h22 vMakefilecancel23 gMakefilecancel23, Cancel
		Gui, Font, bold
	Gui, Add, GroupBox, x152 y64 w150 h60 , LinkCreator No Scroll
		Gui, Font
	Gui, Add, Button, x157 y92 w140 h22 vnoscrollcont gnoscrollcont, LinkCreator bez Scroll
	Gui, Show, x1045 y450 w305 h130,  Start na LinkCreator
	return
	lc:
	sleep 100
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\LinkCreator.ahk
	Gui, destroy
	ExitApp
	return
	
	noscrollcont:
	sleep 100
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\LinkCreator_no_scroll.ahk
	Gui, destroy
	ExitApp
	return
	
	bezlc:
	sleep 100
	FileAppend, %Tab2UrlSiteFinal%`r`n, Z:\SPODELEN\nqmasitepages.txt
	sleep 100	
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\razhodka.ahk
	Gui, destroy
	ExitApp
	return
	makefilecancel23:
	Gui, destroy
	ExitApp
	return

urlsiteloopok:
	Gui, Font, bold
	Gui, Add, GroupBox, x2 y2 w120 h60, �����
	Gui, Font
	Gui, Add, Button, x6 y20 w110 h35 vsmqna gsmqna, SMQNA NA STRANICATA
		Gui, Font, bold
	Gui, Add, GroupBox, x122 y2 w120 h60  , Stranica bez Scroll
	Gui, Font
	Gui, Add, Button, x127 y20 w110 h35 vbezscroll gbezscroll, Stranica bez Scroll
		Gui, Font, bold
	Gui, Add, GroupBox, x2 y64 w120 h60 , Cancel
	Gui, Font
	Gui, Add, Button, x6 y92 w110 h22 vMakefilecancel gMakefilecancel, Cancel
		Gui, Font, Bold
	Gui, Add, Text, x162 y72 w110 h22, Stapki
	Gui, Add, Text, x162 y92 w110 h22, %tekscreen% ot %broistapki2%
	Gui, Show, x1026 y450 w245 h130,  Smqna Stranici
	Gui, Font, s70
	Gui, Add, Text, x2 y125 w250 h102 vtextcount, %Counter%
	SetTimer, count, 1000 
	Gui, Show, x1026 y450 w255 h230,  Smqna Stranici
	sleep 100
	WinActivate, ahk_class MozillaWindowClass
	sleep 50
	endloopexit:
	return
	count:
	Counter1++
	Counter:=timeleft4scr-counter1
	If (Counter<6)
	{
		Gui Font, cred
		GuiControl font, textcount
		goto, countgui
	}
	else
	{
		Gui Font, cgreen
		GuiControl font, textcount
		goto, countgui
	}
	countgui:
	GuiControl,, Textcount, %Counter%
	return
	smqna:
	f1::
	sleep 400
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\razhodka.ahk
	Gui, destroy
	ExitApp
	return
	bezscroll:
	sleep 400
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\razhodka_bez_scroll.ahk
	Gui, destroy
	ExitApp
	return
	makefilecancel:
	Gui, destroy
	ExitApp
	return
	
ExitApp



ExitApp
!^q::ExitApp
return