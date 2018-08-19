;Moving onscreen keyboard to exact location Screen res 1440x900
#NoEnv
#NoTrayIcon
#SingleInstance force
CoordMode, Mouse, Screen
  
  
  
 WinActivate, ahk_class YandexBrowser_WidgetWin_1
 sleep 200	
 WinMove, A,, 0, 27, 1020, 699
sleep 300

return 