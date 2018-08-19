
	#NoEnv
	#Include Z:\SPODELEN\UCB\lib\Acc.ahk
	#Include Z:\SPODELEN\UCB\lib\vlibrary.ahk
	#KeyHistory 0
	#MaxThreads 225
	#MaxMem 256
	ListLines, Off
	CoordMode, Mouse, Screen
	SetTitleMatchMode 2
	SetKeyDelay, 50, 10
	SetBatchLines, -1
	StringCaseSense, Locale

;Common functions

;abbyy screenshots fast
abbyfast()
{
	windowrez=1360
	;check for language in ABBYY
	langcheck=Russian and English
	langpath:="dialog1.window4.combo_box1.window1.editable_text1"
	abbyyfile:="W:\zad.txt"
	
	
	IfExist, %abbyyfile%
	{
		FileDelete, %abbyyfile%
	}
	sleep 300
	MouseMove, 1121, 22, 2
	sleep 100
	WinActivate, ahk_class UseratorGUI
	sleep 50
	1ulistbox:="dialog"
	wDim:=Acc_GetW("Location", 1ulistbox, 0, "ahk_class UseratorGUI")
	if (wDim>windowrez)
	{
		sleep 100
		goto, bubbleclicksinon1202
	}
	sleep 200
	Run, C:\Program Files\ABBYY FineReader 11\Bonus.ScreenshotReader.exe
	sleep 300
	WinWait , ABBYY Screenshot Reader
	sleep 300
	WinActivate, ABBYY Screenshot Reader
	sleep 200
	WinActivate, ABBYY Screenshot Reader
	sleep 100
	Loop
	{
		WinMove, A,, 1030, 345, 327, 115
		sleep 200
		mousemove, 1310, 410
		sleep 200
		MouseClick, left
		sleep 1000
		IfWinExist, ABBYY Screenshot Reader
		{
			goto, clickaltg
		}
		else
		{
			goto, altgckicked
		}
		clickaltg:
		sleep 500
	}
	altgckicked:
	Loop
	{
		mousemove, 1146,16
		sleep 200
		MouseClick, left
		sleep 200
		IfWinExist, ABBYY Screenshot Reader
		{
			goto, shotok
		}
		else
		{
			goto, shotnotok
		}
		shotnotok:
		sleep 500
	}
	shotok:
	exit2ndpartloop:
	sleep 1000
	WinWait, Save Text As..., ,60
	IfWinExist, Save Text As...
	{
		changeAbbyySaveFileLoc()
		sleep 200
		WinActivate, Save Text As...
		sleep 100
		WinMove, 800, 195
		sleep 400
		MouseClick, left, 1010, 546, 1, 3
		sleep 300
		sendingKeys("zad.txt")
		send {enter down}
		sleep 50
		send {enter up}
		sleep 400
		Loop
		{
			IfWinExist, Save Text As...
			{
				sleep 300
				continue
			}
			else
			{
				sleep 300
				break
			}
		}
	}
	IfNotExist, %abbyyfile%
	{
		msgbox, "Clipboard is not processed"
	}
	sleep 100
	bubbleclicksinon1202:
	sleep 100	
	MouseMove, 1092, 413, 2
	sleep 300
	return
}
;location to save abbyy file
changeAbbyySaveFileLoc()
{
	fileLoc:="dialog1.window2.combo_box1"
	targetLoc=Removable Disk (W:)

	WinActivate, Save Text As...
	sleep 100
	fileLocValue:= Acc_Get("Value", fileLoc, 0, "Save Text As...")
	sleep 100
	StringCaseSense, Locale
	IfNotInString, fileLocValue, %targetLoc%
	{
		WinActivate, Save Text As...
		sleep 100
		coordX:=Acc_GetX("Location", fileLoc, 0, "Save Text As...")
		coordY:=Acc_GetY("Location", fileLoc, 0, "Save Text As...")
		xuser:=coordX+200
		yuser:=coordY+5
		mousemove, %xuser%, %yuser%, 2
		sleep 100
		MouseClick, left
		sleep 300
		Loop
		{
			sleep 100
			sendingKeys("r")
			sleep 200
			fileLocValue2:= Acc_Get("Value", fileLoc, 0, "Save Text As...")
			sleep 100
			if inStr(fileLocValue2, targetLoc)
			{
				xuser:=coordX+200
				yuser:=coordY+5
				mousemove, %xuser%, %yuser%, 2
				sleep 100
				MouseClick, left
				sleep 300
				break
			}
			sleep 1
		}
	}
	return
}
changeAbbyySendMode()
{
	textCheck=Text to File
	textCheckClip=Text to Clipboard
	textToFilePath:="dialog1.window6.combo_box1"
	textToFileValue:= Acc_Get("Value", textToFilePath, 0, "ABBYY Screenshot Reader")
	WinActivate, ABBYY Screenshot Reader
	sleep 100
	send {alt down}{s down}{s up}{alt up}
	sleep 200
	StringCaseSense, Locale
	IfNotInString, textToFileValue, %textCheck%
	{
		Loop 
		{
			WinActivate, ABBYY Screenshot Reader
			sleep 100
			textToFileValue:= Acc_Get("Value", textToFilePath, 0, "ABBYY Screenshot Reader")
			sleep 200
			if inStr(textToFileValue, textCheck)
			{
				break
			}
			else if inStr(textToFileValue, textCheckClip) 
			{
				send {down}
				sleep 300
			}
			else
			{
				send {up}
				sleep 300
			}
			sleep 1
		}
	}
	return
}
;sending keys
sendingKeys(keysToSend, delay=200) {
	SetKeyDelay, %delay%, 40
	send %keysToSend%
	sleep 200
	return
}
;========================================================================================
; Common Functions      																;
;========================================================================================
;Delete txt files
	DeleteTxtFiles() {
		replace:= {"file1":"commtext.txt","file2":"regtext.txt","file3":"nqmalink.txt", "file4":"nezarejda.txt", "file5":"nevtop50.txt", "file6":"regDigits.txt"}
		for what, with in replace {
			IfExist, C:\UCB\Temp\%with%
			{
					FileDelete, C:\UCB\Temp\%with%
			}
			;for backward compatibility
			IfExist, C:\Neshta\Autohotkey Scripts\Auto_firefox\Vzadache_text\%with%
			{
				FileDelete, C:\Neshta\Autohotkey Scripts\Auto_firefox\Vzadache_text\%with%
			}
		}
		return
	}
;removing characters
	RemoveExtraChars(DataToRemove) {
			dotremove=.
			httpslash=://
			wwwremove=ww.
			slashcheck=/
			removeR=`r
			RemoveN=`n
			StringGetPos, httpslashPos, DataToRemove, %httpslash%
			if (httpslashPos>0) {
				StringTrimLeft, DataToRemove, DataToRemove, % (httpslashPos+StrLen(httpslash))
			}

			StringGetPos, www2pos, DataToRemove, %wwwremove%

			if (www2pos>3) {
					DataToRemove=xxxda.ffdd
					goto, enddata
			}

			if (www2pos>-1) {
					StringTrimLeft, DataToRemove, DataToRemove, % (www2pos+3)
			}

			StringGetPos, slash3pos, DataToRemove,  %slashcheck%
			if (slash3pos>0) {
					StringLeft, DataToRemove, DataToRemove, slash3pos
			}

			StringGetPos, rpos, DataToRemove,  %RemoveR%
			if (rpos>-1) {
					StringLeft, DataToRemove, DataToRemove, rpos
			}

			StringGetPos, npos, DataToRemove,  %RemoveN%
			if (npos>-1) {
					StringLeft, DataToRemove, DataToRemove, npos
			}
		;remove ok button-
			DataToRemove=%DataToRemove%
			StringReplace, DataToRemove, DataToRemove, %A_Space%,,All
			sleep 1
			enddata:

			return, DataToRemove
	}
;movement of the mouse into browser 
		HorMouseMove() {
				MouseMove_Ellipse("", "", 180, 404, 4, 0, 1)
				sleep 700
				MouseMove_Ellipse("", "", 697, 435, 3)
				sleep 1000
				return
		}
		VertMousemove() {
				MouseMove_Ellipse("", "", 922, 562, 4, 0, 1)
				sleep 700
				MouseMove_Ellipse("", "", 867, 379, 4)
				sleep 1000
				return
		}
		ElipseMousemove() {
				MouseMove_Ellipse("", "", 560, 312, 4, 0, 1)
				sleep 50
				MouseMove_Ellipse("", "", 190, 392, 4, 0, 1)
				sleep 50
				MouseMove_Ellipse("", "", 120, 444, 3)
				sleep 1000
				return
		}
		UpDownMousemove() {
				MouseMove_Ellipse("", "", 672, 583, 6, 0, 1)
				sleep 50
				MouseMove_Ellipse("", "", 680, 466, 6, 0, 1)
				sleep 50
				MouseMove_Ellipse("", "", 627, 341, 6, 0, 1)
				sleep 50
				MouseMove_Ellipse("", "", 578, 641, 6, 0, 1)
				sleep 50
				MouseMove_Ellipse("", "", 634, 601, 6)
				sleep 1000
				return
		}
		SleepNow() {
				sleep 100
				return
		}
	;******************* Ecliptic Mouse Moves nachalo ************************************
		; --------------------------------------------------------------------------------------------------------------------------------------------------------------- ;
		;By:            	Wicked.                                                                                                                                       ;
		;Name:          	MouseMove_Ellipse()                                                                                                                           ;
		;Description:   	Moves the mouse from (X1, Y1) to (X2, Y2) using an ellipse rather then a straight line.                                                       ;
		;Parameters:    	X1 - The beginning X coordinate. Leave blank to use the current mouse position.                                                               ;
		;				Y2 - The beginning Y coordinate. Leave blank to use the current mouse position.                                                                   ;
		;				X2 - The second X coordinate.                                                                                                                     ;
		;				Y2 - The second Y coordinate.                                                                                                                     ;
		;				S - The speed. In this case, the larger the number, the faster the speed.                                                                         ;
		;				B - Blocks the mouse input. Set to 1 or true to block mouse input during the mouse movement.                                                      ;
		;				I - Inverts the ellipse path.                                                                                                                     ;
		;Examples:      	MouseMove_Ellipse(50, 50, 300, 300) moves mouse from (50, 50) to (300, 300).                                                                  ;
		;				MouseMove_Ellipse("", "", 300, 300, 2) moves mouse from it's current position to (300, 300) with a speed of 2.                                    ;
		;				MouseMove_Ellipse(50, 50, 300, 300, 5, 1) moves mouse from (50, 50) to (300, 300) with a speed of 5 and blocks mouse input.                       ;
		;				MouseMove_Ellipse(50, 50, 300, 300, 5, 1, 1) moves mouse from (50, 50) to (300, 300) with a speed of 5, blocks mouse input and inverts the path.  ;
		;Credits:       	None - Lending a helping hand.                                                                                                                ;
		;				[VxE] - For his guide to the ternary operator.                                                                                                    ;
		; --------------------------------------------------------------------------------------------------------------------------------------------------------------- ;
		MouseMove_Ellipse(X1, Y1, X2, Y2, S=1, M=0, I="") {
			MouseGetPos, X0, Y0
			If(I="")
				Random, I, 0, 1
		   X1 := (X1 != "") ? X1 : X0, Y1 := (Y1 != "") ? Y1 : Y0, B := Abs(X1-X2), A := Abs(Y1-Y2), H := (X1<X2) ? ((Y1<Y2) ? ((I=0) ? X1:X2):((I=0) ? X2:X1)):((Y1<Y2) ? ((I=0) ? X2:X1):((I=0) ? X1:X2)), K := (Y1<Y2) ? ((X1<X2) ? ((I=0) ? Y2:Y1):((I=0) ? Y1:Y2)):((X1<X2) ? ((I=0) ? Y1:Y2):((I=0) ? Y2:Y1)), D := A_MouseDelay 
			SetMouseDelay, 1
			If(M)
				BlockInput, Mouse
			If(B > A)
				Loop, % B / S
				{
					M := (X1 < X2) ? ((I=0) ? -1:1):((I=0) ? 1:-1), X := (X1 < X2) ? (X1+A_Index*S) : (X1-A_Index*S), Y := M*Sqrt(A**2*((X-H)**2/B**2-1)*-1)+K
					MouseMove, %X%, %Y%, 0
				}
			Else
				Loop, % A / S
				{
					M := (Y1 < Y2) ? ((I=0) ? 1:-1):((I=0) ? -1:1), Y := (Y1 < Y2) ? (Y1+A_Index*S) : (Y1-A_Index*S), X := M*Sqrt(B**2*(1-(Y-K)**2/A**2))+H
					MouseMove, %X%, %Y%, 0
				}
			MouseMove, %X2%, %Y2%, 0
			BlockInput, Off
			SetMouseDelay, % D
		}
	;******************* Ecliptic Mouse Moves KRAI ************************************
		

;==================================================================================================================
; Function:       IPv4 ping with name resolution, based upon 'SimplePing' by Uberi ->
;                 http://www.autohotkey.com/board/topic/87742-simpleping-successor-of-ping/
; Parameters:     Addr     -  IPv4 address or host / domain name.
;                 ----------  Optional:
;                 Result   -  Object to receive the result in three keys:
;                             -  InAddr - Original value passed in parameter Addr.
;                             -  IPAddr - The replying IPv4 address.
;                             -  RTTime - The round trip time, in milliseconds.
;                 Timeout  -  The time, in milliseconds, to wait for replies.
; Return values:  On success: The round trip time, in milliseconds.
;                 On failure: "", ErrorLevel contains additional informations.
; AHK version:    AHK 1.1.13.01
; Tested on:      Win XP - AHK A32/U32, Win 7 x64 - AHK A32/U32/U64
; Authors:        Uberi / just me
; Version:        1.0.00.00/2013-11-06/just me - initial release
; MSDN:           Winsock Functions   -> http://msdn.microsoft.com/en-us/library/ms741394(v=vs.85).aspx
;                 IP Helper Functions -> hhttp://msdn.microsoft.com/en-us/library/aa366071(v=vs.85).aspx
; =================================================================================================================
	Ping4(Addr, ByRef Result := "", Timeout := 1024) {
	   ; ICMP status codes -> http://msdn.microsoft.com/en-us/library/aa366053(v=vs.85).aspx
	   ; WSA error codes   -> http://msdn.microsoft.com/en-us/library/ms740668(v=vs.85).aspx
	   Static WSADATAsize := (2 * 2) + 257 + 129 + (2 * 2) + (A_PtrSize - 2) + A_PtrSize
	   OrgAddr := Addr
	   Result := ""
	   ; -------------------------------------------------------------------------------------------------------------------
	   ; Initiate the use of the Winsock 2 DLL
	   VarSetCapacity(WSADATA, WSADATAsize, 0)
	   If (Err := DllCall("Ws2_32.dll\WSAStartup", "UShort", 0x0202, "Ptr", &WSADATA, "Int")) {
		  ErrorLevel := "WSAStartup failed with error " . Err
		  Return ""
	   }
	   If !RegExMatch(Addr, "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") { ; Addr contains a name
		  If !(HOSTENT := DllCall("Ws2_32.dll\gethostbyname", "AStr", Addr, "UPtr")) {
			 DllCall("Ws2_32.dll\WSACleanup") ; Terminate the use of the Winsock 2 DLL
			 ErrorLevel := "gethostbyname failed with error " . DllCall("Ws2_32.dll\WSAGetLastError", "Int")
			 Return ""
		  }
		  PAddrList := NumGet(HOSTENT + 0, (2 * A_PtrSize) + 4 + (A_PtrSize - 4), "UPtr")
		  PIPAddr   := NumGet(PAddrList + 0, 0, "UPtr")
		  Addr := StrGet(DllCall("Ws2_32.dll\inet_ntoa", "UInt", NumGet(PIPAddr + 0, 0, "UInt"), "UPtr"), "CP0")
	   }
	   INADDR := DllCall("Ws2_32.dll\inet_addr", "AStr", Addr, "UInt") ; convert address to 32-bit UInt
	   If (INADDR = 0xFFFFFFFF) {
		  ErrorLevel := "inet_addr failed for address " . Addr
		  Return ""
	   }
	   ; Terminate the use of the Winsock 2 DLL
	   DllCall("Ws2_32.dll\WSACleanup")
	   ; -------------------------------------------------------------------------------------------------------------------
	   Err := ""
	   If (HPORT := DllCall("Iphlpapi.dll\IcmpCreateFile", "UPtr")) { ; open a port
		  REPLYsize := 32 + 8
		  VarSetCapacity(REPLY, REPLYsize, 0)
		  If DllCall("Iphlpapi.dll\IcmpSendEcho", "Ptr", HPORT, "UInt", INADDR, "Ptr", 0, "UShort", 0
												, "Ptr", 0, "Ptr", &REPLY, "UInt", REPLYsize, "UInt", Timeout, "UInt") {
			 Result := {}
			 Result.InAddr := OrgAddr
			 Result.IPAddr := StrGet(DllCall("Ws2_32.dll\inet_ntoa", "UInt", NumGet(Reply, 0, "UInt"), "UPtr"), "CP0")
			 Result.RTTime := NumGet(Reply, 8, "UInt")
		  }
		  Else
			 Err := "IcmpSendEcho failed with error " . A_LastError
		  DllCall("Iphlpapi.dll\IcmpCloseHandle", "Ptr", HPORT)
	   }
	   Else
		  Err := "IcmpCreateFile failed to open a port!"
	   ; -------------------------------------------------------------------------------------------------------------------
	   If (Err) {
		  ErrorLevel := Err
		  Return ""
	   }
	   ErrorLevel := 0
	   Return Result.RTTime
	}
