#NoEnv
#SingleInstance force
#Include Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Vzadache\vlibrary.ahk
#KeyHistory 0
#MaxThreads 225
#MaxMem 256
CoordMode, Mouse, Screen
SetTitleMatchMode 2
SetKeyDelay, 50, 10
SetBatchLines, -1
SetControlDelay -1
ListLines, Off

timeleft4scr:=3600

		Gui, Font, bold
	Gui, Add, GroupBox, x2 y2 w120 h60 , Cancel
	Gui, Font
	Gui, Add, Button, x6 y20 w110 h35 vMakefilecancel gMakefilecancel, Cancel
		Gui, Font, bold
	Gui, Add, GroupBox, x122 y2 w120 h60  , Vstart
	Gui, Font
	Gui, Add, Button, x127 y20 w110 h35 vbezscroll gbezscroll, Restart VStart
		Gui, Font, Bold
	Gui, Font, s70
	Gui, Add, Text, x2 y125 w250 h102 vtextcount, %Counter%
	SetTimer, count, 1000 ; timera se updeitva vsqka sekunda
	Gui, Show, x1026 y450 w255 h230,  Counter Avtomat Izchakvane
	return
	count:
	Counter1++
	Counter:=timeleft4scr-counter1
	if (counter<0)
	{
		sleep 100
		Gui, destroy
		ExitApp
		return
	}
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
	bezscroll:
		sleep 100
		Gui, destroy
		ExitApp
	return
	makefilecancel:
	Gui, destroy
	ExitApp
	return