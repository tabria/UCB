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

	syou := new Yandex

	ytube=youtube.com
	icheck := "IBeam"
	
	syou.browserTabAction("Firefox", "close", 2)
	syou.CrT()	
	syou.sendingKeysPageLoad("youtube.com", "L", 1)
	
	;check for banner over the search field
	MouseMove, 509, 181
	sleep 100
	cursortext=%A_Cursor%
	
	;check if the cursor is IBeam
	if cursortext = %icheck%
	{
		MouseClick, left, 509, 181, 1, 3
		sleep 100
	} else {
		MouseClick, left, 513, 153, 1, 3
		sleep 100
	}

	syou.CrAV()
	syou.Ente()
	syou.FFwaitAll()	
	syou.useratorCtrl1()
	syou.messagebox("Manual Search")
	sleep 200
	syou.UseratorExistnew()
	syou.UseratorErrornew()
	syou.browserWinAction("Firefox", "activate")
	syou.browserTabAction("Firefox", "change", 2)
	syou.useratorActivate()
	syou.useratorCtrl1()
	syou.UseratorExistnew()
	syou.UseratorErrornew()
	syou.useratorScreenshot()
	syou.browserWinAction("Firefox", "activate")
	syou.browserTabAction("Firefox", "change", 3)
	
	;loop for minutes
	Loop
	{
		syou.useratorActivate()
		WinGetActiveStats, title, width, height, x, y
		kraiwidthcheck:=425
		kraiheightcheck:=150
		
		;check for comment
		if (width=kraiwidthcheck) and (height=kraiheightcheck:=150)
		{
			syou.useratorCommEnd()
			sleep 200
			syou.UseratorErrornew()
			syou.useratorActivate()
			Loop
			{
				sleep 10
				Mousemove, 1308, 315, 2
				sleep 400
				Loop, 4
				{
					run, "Z:\SPODELEN\UCB\lib\AutoIT\mleft_click.au3"
				}
				sleep 100
				syou.UseratorExistnew()
				syou.UseratorErrornew()
				sleep 100
				usernow:=Acc_GetH("Location", this.uListbox, 0, "ahk_class UseratorGUI")
				if (usernow!=189)
				{
					goto, otpravitotnachalo119
				} else {
					goto, otpravitok119
				}
				sleep 10
				otpravitotnachalo119:
			}
			otpravitok119:
			sleep 200
			syou.useratorActivate()
			syou.useratorEndTask()()
			syou.useratorctrl1otpravit()
			sleep 300
			Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\vstart.ahk
			ExitApp
		}
		
		;check for time and then CTRL+1
		syou.useratorCtrl1()
		
		;taking screenshots
		syou.UseratorExistnew()
		syou.UseratorErrornew()
		syou.useratorScreenshot()
		sleep 100
	}
	;krai
	ExitApp


!^q::ExitApp
return