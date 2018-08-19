#NoEnv
#SingleInstance force
#Include Z:\SPODELEN\UCB\lib\vlibrary.ahk
#KeyHistory 0
#MaxThreads 225
#MaxMem 256
CoordMode, Mouse, Screen
SetTitleMatchMode 2
SetKeyDelay, 50, 10
SetBatchLines, -1
SetControlDelay -1
ListLines, Off


;variables
	user=xxx
	vmname=xxx
	vmpass=xxx

	connect := new PppoeConnection

	connect.PppoeConnectionVmIpOrder(vmname)

	connect.PppoeConnectionInternetConnector(user)

	connect.PppoeConnectionFFOpener()

	connect.PppoeConnectionGetWorkingIp()

	connect.PppoeConnectionVzadOpener(vmname, vmpass)

	connect.PppoeConnectionExtraProgOpener()
	
ExitApp
!^q::ExitApp
return