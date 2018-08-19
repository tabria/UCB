#NoEnv
#SingleInstance force

CoordMode, Mouse, Screen
SetTitleMatchMode 2
SetKeyDelay, 50, 10
SetBatchLines, -1
SetControlDelay -1
ListLines, Off


	Gui, Font, bold
	Gui, Add, GroupBox, x2 y2 w120 h100, FF
	Gui, Font
	Gui, Add, Button, x6 y20 w110 h25 vvstart gvstart, VStart FF
	Gui, Add, Button, x6 y45 w110 h25 vrazhodkaff grazhodkaff, Razhodka FF

		Gui, Font, bold
	Gui, Add, GroupBox, x127 y2 w120 h50, YB
	Gui, Font
	Gui, Add, Button, x131 y20 w110 h25 vrazhodkaYB grazhodkaYB, Razhodka YB
	Gui, Font, bold

		Gui, Font, bold
	Gui, Add, GroupBox, x2 y105 w245 h100, Obshti
	Gui, Font
	Gui, Add, Button, x6 y123 w110 h25 vffmove gffmove, FF move
	Gui, Add, Button, x131 y123 w110 h25 vYBmove gYBmove, YB move
	Gui, Add, Button, x6 y148 w110 h25 vnum gnum, NumPad
	Gui, Add, Button, x131 y148 w110 h25 vawait gawait, AutoWait
	Gui, Add, Button, x6 y173 w110 h25 vnezar gnezar, Nezarejda
	Gui, Add, Button, x131 y173 w110 h25 vlc glc, LinkCreator
	
	Gui, Font
	Gui, Add, Button, x65 y210 w110 h25 vMakefilecancel gMakefilecancel, Cancel

	Gui, Show, x1086 y450 w250 h240, Distributor
	return

	;Firefox
	vstart:
	sleep 400 
	Run, Z:\SPODELEN\UCB\vstart.ahk
	Gui, destroy
	ExitApp
	return
	
	razhodkaff:
	sleep 400
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\razhodka.ahk
	Gui, destroy
	ExitApp
	return
	
	;Yandex Browser
	razhodkaYB:
	sleep 400
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\YBSocZad.ahk
	Gui, destroy
	ExitApp
	return
	
	
	ffmove:
	sleep 400
	Run, Z:\SPODELEN\UCB\FF_mover.ahk
	Gui, destroy
	ExitApp
	return
	
	YBmove:
	sleep 400
	Run, Z:\SPODELEN\UCB\yandex_mover.ahk
	Gui, destroy
	ExitApp
	return
	
	num:
	sleep 400
	Run, Z:\SPODELEN\UCB\numpadmap.ahk
	Gui, destroy
	ExitApp
	return
	
	await:
	sleep 400
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\counter_automode.ahk
	Gui, destroy
	ExitApp
	return
	
	nezar:
	sleep 400
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\nezarejda.ahk
	Gui, destroy
	ExitApp
	return
	
	lc:
	sleep 400
	Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\LinkCreator.ahk
	Gui, destroy
	ExitApp
	return
	
	makefilecancel:
	Gui, destroy
	ExitApp
	return
	
;krai
ExitApp



ExitApp
!^q::ExitApp
return