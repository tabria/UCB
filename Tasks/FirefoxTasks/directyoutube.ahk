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


	
	dirYouTube := new Yandex

	dirYouTube.browserTabAction("Firefox", "close", 2)
	dirYouTube.CrT()	
	dirYouTube.CrLAV()
	dirYouTube.Ente()
	dirYouTube.FFwaitAll()
	dirYouTube.messagebox("Check for ads")
	dirYouTube.useratorActivate()
	dirYouTube.useratorCtrl1()
	dirYouTube.UseratorExistnew()
	dirYouTube.UseratorErrornew()
	dirYouTube.useratorActivate()
;loop za minutite
	kraiwidthcheck:=425
	kraiheightcheck:=150
	;msgbox, predi loop
	Loop
	{
		dirYouTube.useratorActivate()
		WinGetActiveStats, title, width, height, x, y
		;check for comment
		if (width=kraiwidthcheck) and (height=kraiheightcheck:=150)
		{
			
			dirYouTube.useratorCommEnd()
			dirYouTube.UseratorErrornew()
			dirYouTube.useratorActivate()
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
				dirYouTube.UseratorExistnew()
				dirYouTube.UseratorErrornew()
				sleep 100
				usernow:=Acc_GetH("Location", this.uListbox, 0, "ahk_class UseratorGUI")
				if (usernow!=189) {
					goto, otpravitotnachalo116
				} else {
					goto, otpravitok116
				}
				sleep 10
				otpravitotnachalo116:
			}
			otpravitok116:
			sleep 200
			dirYouTube.useratorActivate()
			dirYouTube.useratorEndTask()
			dirYouTube.useratorctrl1otpravit()
			Run, Z:\SPODELEN\Neshta\Autohotkey Scripts\Auto_firefox\Yostrov2015\vstart.ahk
			ExitApp
		}
		sleep 100
		;Check if time is up then CTRL+1
		dirYouTube.useratorCtrl1()
		;taking screenshots
		dirYouTube.UseratorExistnew()
		dirYouTube.UseratorErrornew()
		dirYouTube.useratorScreenshot()
		sleep 400
	}
ExitApp


!^q::ExitApp
return