;Moving onscreen keyboard to exact location Screen res 1440x900
#NoEnv
#NoTrayIcon
#SingleInstance force
CoordMode, Mouse, Screen
  

 WinActivate, ahk_class MozillaWindowClass
 sleep 200	
 WinMove, A,, 0, 0, 1023, 728

return 