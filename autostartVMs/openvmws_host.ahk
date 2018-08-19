#NoEnv
#SingleInstance force
#Include D:\Virtual Machines\SPODELEN\UCB\lib\Acc.ahk
#KeyHistory 0
CoordMode, Mouse, Screen
SetTitleMatchMode 2
SetKeyDelay, 50, 10
SetBatchLines, -1
SetControlDelay -1
ListLines, Off



;variables
vmarray:={"1":"xxx"}

nextvm:="D:\Virtual Machines\SPODELEN\UCB\autostartVMs\startnextvm.txt"
vm1notopen=mgrushe
tabloc:="client1.window6.client1.window4.client1"
tabnomerloc:="client1.window6.client1.window4.client1.window.x"
waitTime:=15000

sleep 100

FileDelete, %nextvm%

sleep 100

WinActivate, ahk_class VMUIFrame
sleep 100

broitaboveObj:=Acc_Get("Object", tabloc, 0, "ahk_class VMUIFrame")
broitabove:=broitaboveObj .accChildCount
if (broitabove>19)
{
	goto, opentabs
}
if (broitabove<19)
{
	msgbox, Nqma Tabove
}
opentabs:
breaktab:=0
tabnomer:=0
Loop
{
	if (breaktab>=19)
	{
		break
	}
	else
	{
		tabnomer:=tabnomer+1
		StringReplace, tabnomerlocReal, tabnomerloc, .x, %tabnomer%
		sleep 10
		tabname:=Acc_Get("Name", tabnomerlocReal, 0, "ahk_class VMUIFrame")
		sleep 10
		if (tabname!="") and (tabname!=vm1notopen)
		{
			breaktab:=breaktab+1
			xtab := Acc_GetX("location", tabnomerlocReal, 0, "ahk_class VMUIFrame")
			ytab := Acc_Gety("location", tabnomerlocReal, 0, "ahk_class VMUIFrame")
			xm:=xtab+30
			ym:=ytab+14
			sleep 300
			MouseMove, %xm%, %ym%, 2
			sleep 100
			MouseClick, left
			sleep 1000
			send {Ctrl down}{b down}{b up}{ctrl up}
			sleep %waitTime%
		}
	}
}

for numb, name in vmarray
{
	FileAppend, %name%, %nextvm%
	Loop
	{
		IfNotExist, %nextvm%
		{
			break
		}
		sleep 5000
	}
}

ExitApp
!^q::ExitApp
return
