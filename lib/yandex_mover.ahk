;Moving onscreen keyboard to exact location Screen res 1440x900


#NoEnv
#SingleInstance force
CoordMode, Mouse, Screen
SetTitleMatchMode 2
SetKeyDelay, 50, 10
SetBatchLines, -1
SetControlDelay -1
ListLines, Off
  
  
  
 WinActivate, ahk_class YandexBrowser_WidgetWin_1
 sleep 200	
 WinMove, A,, 0, 27, 1020, 699
sleep 300


return 