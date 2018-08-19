#NoEnv
#Persistent
CoordMode, Mouse, Screen
SetTitleMatchMode 2
SetKeyDelay, 50, 10
SetBatchLines, -1
SetControlDelay -1
ListLines, Off



NumLock::
send {ctrl down}{v down}{v up}{ctrl up}
return

NumpadEnter::
run, "Z:\SPODELEN\UCB\lib\AutoIT\enter.au3"
return


NumpadMult::
send {ctrl down}{f down}{f up}{ctrl up}
return

NumpadDiv::
send {ctrl down}{c down}{c up}{ctrl up}
return


Numpad1::
send {f2 down}{f2 up}
return

Numpad2::
send {f3 down}{f3 up}
return

Numpad3::
return

Numpad4::

return

Numpad6::
send {ctrl down}{t down}{t up}{ctrl up}
return

Numpad7::
send {Space down}{space up} 
return

Numpad8::

return

Numpad9::

return

Numpadsub::
send {backspace down}{backspace up}
return

NumpadDel::
send {ctrl down}{1 down}{1 up}{ctrl up}
return
NumpadDot::
send {ctrl down}{1 down}{1 up}{ctrl up}
return


XButton2::
WinActivate, ahk_class MozillaWindowClass
send {home up}{home down}
return

XButton1::
WinActivate, ahk_class MozillaWindowClass
send {end up}{end down}
return



MButton::
send {ctrl down}{LButton down}{LButton up}{Ctrl up}
return


^XButton2::
send {ctrl down}{a down}{a up}{v down}{v up}{ctrl up}
return


!^q::ExitApp
return