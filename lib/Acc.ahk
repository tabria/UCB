;------------------------------------------------------------------------------
; Acc.ahk Standard Library
; by Sean
; Updated by jethrow:
; 	Modified ComObjEnwrap params from (9,pacc) --> (9,pacc,1)
; 	Changed ComObjUnwrap to ComObjValue in order to avoid AddRef (thanks fincs)
; 	Added Acc_GetRoleText & Acc_GetStateText
; 	Added additional functions - commented below
; 	Removed original Acc_Children function
; last updated 2/25/2010
;------------------------------------------------------------------------------

Acc_Init()
{
	Static	h := DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_ObjectFromEvent(ByRef _idChild_, hWnd, idObject, idChild)
{
	Acc_Init()
	if (DllCall("oleacc\AccessibleObjectFromEvent"
	          , "Ptr", hWnd
			  , "UInt", idObject
			  , "UInt", idChild
			  , "Ptr*", pacc
			  , "Ptr", VarSetCapacity(varChild, 8 + 2 * A_PtrSize, 0) * 0 + &varChild) = 0) {
		_idChild_:=NumGet(varChild,8,"UInt")
		return ComObjEnwrap(9,pacc,1)
	}
}

Acc_ObjectFromPoint(ByRef _idChild_ = "", x = "", y = "")
{
	Acc_Init()
	if (DllCall("oleacc\AccessibleObjectFromPoint"
			  , "Int64", x == ""||y==""
						 ? 0 * DllCall("GetCursorPos","Int64*",pt) + pt
						 : x & 0xFFFFFFFF | y << 32
			  , "Ptr*", pacc
			  , "Ptr", VarSetCapacity(varChild, 8 + 2 * A_PtrSize, 0) * 0 + &varChild) = 0) {
		_idChild_:=NumGet(varChild,8,"UInt")
		return ComObjEnwrap(9,pacc,1)
	}
}

Acc_ObjectFromWindow(hWnd, idObject = -4)
{
	Acc_Init()
	if (DllCall("oleacc\AccessibleObjectFromWindow"
			  , "Ptr", hWnd
			  , "UInt", idObject &= 0xFFFFFFFF
			  , "Ptr", -VarSetCapacity(IID,16)
			           + NumPut(idObject == 0xFFFFFFF0
							    ? 0x46000000000000C0
								: 0x719B3800AA000C81
								, NumPut(idObject == 0xFFFFFFF0
								? 0x0000000000020400
								: 0x11CF3C3D618736E0,IID,"Int64"),"Int64")
			  , "Ptr*", pacc) = 0)
		return ComObjEnwrap(9,pacc,1)
}

Acc_WindowFromObject(pacc)
{
	if (DllCall("oleacc\WindowFromAccessibleObject"
	          , "Ptr", IsObject(pacc) ? ComObjValue(pacc) : pacc
			  , "Ptr*", hWnd) = 0)
		return hWnd
}


Acc_GetRoleText(nRole)
{
	nSize := DllCall("oleacc\GetRoleText"
	               , "Uint", nRole
				   , "Ptr", 0
				   , "Uint", 0)
	VarSetCapacity(sRole, (A_IsUnicode ? 2 : 1) * nSize)
	DllCall("oleacc\GetRoleText"
	      , "Uint", nRole
		  , "str", sRole
		  , "Uint", nSize+1)
	return sRole
}

Acc_GetStateText(nState)
{
	nSize := DllCall("oleacc\GetStateText"
	               , "Uint", nState
				   , "Ptr", 0
				   , "Uint", 0)
	VarSetCapacity(sState, (A_IsUnicode ? 2 : 1) * nSize)
	DllCall("oleacc\GetStateText"
	      , "Uint", nState
		  , "str", sState
		  , "Uint", nSize+1)
	return sState
}

Acc_SetWinEventHook(eventMin, eventMax, pCallback)
{
	Return	DllCall("SetWinEventHook", "Uint", eventMin, "Uint", eventMax, "Uint", 0, "Ptr", pCallback, "Uint", 0, "Uint", 0, "Uint", 0)
}

Acc_UnhookWinEvent(hHook)
{
	Return	DllCall("UnhookWinEvent", "Ptr", hHook)
}
/*	Win Events:

	pCallback := RegisterCallback("WinEventProc")
	WinEventProc(hHook, event, hWnd, idObject, idChild, eventThread, eventTime)
	{
		Critical
		Acc := Acc_ObjectFromEvent(_idChild_, hWnd, idObject, idChild)
		; Code Here:

	}
*/

; Written by jethrow
Acc_Role(Acc, ChildId=0) {
	try return ComObjType(Acc,"Name") = "IAccessible"
	           ? Acc_GetRoleText(Acc.accRole(ChildId))
			   : "invalid object"
}

Acc_State(Acc, ChildId=0) {
	try return ComObjType(Acc,"Name") = "IAccessible"
	           ? Acc_GetStateText(Acc.accState(ChildId))
			   : "invalid object"
}

Acc_Location(Acc, ChildId=0) { ; adapted from Sean's code
	try Acc.accLocation(ComObj(0x4003, & x := 0)
	                  , ComObj(0x4003,&y:=0)
					  , ComObj(0x4003,&w:=0)
					  , ComObj(0x4003,&h:=0)
					  , ChildId)
	catch
		return
	return { x:NumGet(x,0,"int")
	       , y:NumGet(y,0,"int")
		   , w:NumGet(w,0,"int")
		   , h:NumGet(h,0,"int")
		   , pos:"x" NumGet(x,0,"int")
		      . " y" NumGet(y,0,"int")
			  . " w" NumGet(w,0,"int")
			  . " h" NumGet(h,0,"int") }
}
Acc_LocationX(Acc, ChildId=0) { ; adapted from Sean's code
	try Acc.accLocation(ComObj(0x4003, & x := 0)
	                  , ComObj(0x4003,&y:=0)
					  , ComObj(0x4003,&w:=0)
					  , ComObj(0x4003,&h:=0)
					  , ChildId)
	catch
		return
	return { x:NumGet(x,0,"int")
		   , pos: NumGet(x ,0,"int") }
}
Acc_LocationY(Acc, ChildId=0) { ; adapted from Sean's code
	try Acc.accLocation(ComObj(0x4003, & x := 0)
	                  , ComObj(0x4003,&y:=0)
					  , ComObj(0x4003,&w:=0)
					  , ComObj(0x4003,&h:=0)
					  , ChildId)
	catch
		return
	return { y:NumGet(y,0,"int")
		   , pos: NumGet(y ,0,"int") }
}
Acc_LocationW(Acc, ChildId=0) { ; adapted from Sean's code
	try Acc.accLocation(ComObj(0x4003, & x := 0)
	                  , ComObj(0x4003,&y:=0)
					  , ComObj(0x4003,&w:=0)
					  , ComObj(0x4003,&h:=0)
					  , ChildId)
	catch
		return
	return { w:NumGet(w,0,"int")
		   , pos: NumGet(w ,0,"int") }
}
Acc_LocationH(Acc, ChildId=0) { ; adapted from Sean's code
	try Acc.accLocation(ComObj(0x4003, & x := 0)
	                  , ComObj(0x4003,&y:=0)
					  , ComObj(0x4003,&w:=0)
					  , ComObj(0x4003,&h:=0)
					  , ChildId)
	catch
		return
	return { h:NumGet(h,0,"int")
		   , pos: NumGet(h ,0,"int") }
}

Acc_Parent(Acc) { 
	try parent := Acc.accParent
	return parent ? Acc_Query(parent) :
}

Acc_Child(Acc, ChildId=0) {
	try child := Acc.accChild(ChildId)
	return child ? Acc_Query(child) :
}

; thanks Lexikos - www.autohotkey.com/forum/viewtopic.php?t=81731&p=509530#509530
Acc_Query(Acc) { 
	try return ComObj(9, ComObjQuery(Acc, "{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}

Acc_Error(p="") {
	static setting:=0
	return p=""?setting:setting:=p
}
Acc_Children(Acc) {
	if ComObjType(Acc,"Name") != "IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren%
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
			return Children.MaxIndex()?Children:
		} else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}
Acc_ChildrenByRole(Acc, Role) {
	if ComObjType(Acc,"Name")!="IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren% {
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i)
				if NumGet(varChildren,i-8)=9
					AccChild:=Acc_Query(child), ObjRelease(child), Acc_Role(AccChild)=Role?Children.Insert(AccChild):
				else
					Acc_Role(Acc, child)=Role?Children.Insert(child):
			}
			return Children.MaxIndex()?Children:, ErrorLevel:=0
		} else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}
Acc_Get(Cmd, ChildPath="", ChildID=0, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="") {
	static properties := {Action:"DefaultAction", DoAction:"DoDefaultAction", Keyboard:"KeyboardShortcut"}
	AccObj :=   IsObject(WinTitle)? WinTitle
			:   Acc_ObjectFromWindow( WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText), 0 )
	if ComObjType(AccObj, "Name") != "IAccessible"
		ErrorLevel := "Could not access an IAccessible Object"
	else {
		StringReplace, ChildPath, ChildPath, _, %A_Space%, All
		AccError:=Acc_Error(), Acc_Error(true)
		Loop Parse, ChildPath, ., %A_Space%
			try {
				if A_LoopField is digit
					Children:=Acc_Children(AccObj), m2:=A_LoopField ; mimic "m2" output in else-statement
				else
					RegExMatch(A_LoopField, "(\D*)(\d*)", m), Children:=Acc_ChildrenByRole(AccObj, m1), m2:=(m2?m2:1)
				if Not Children.HasKey(m2)
					throw
				AccObj := Children[m2]
			} catch {
				ErrorLevel:="Cannot access ChildPath Item #" A_Index " -> " A_LoopField, Acc_Error(AccError)
				if Acc_Error()
					throw Exception("Cannot access ChildPath Item", -1, "Item #" A_Index " -> " A_LoopField)
				return
			}
		Acc_Error(AccError)
		StringReplace, Cmd, Cmd, %A_Space%, , All
		properties.HasKey(Cmd)? Cmd:=properties[Cmd]:
		try {
			if (Cmd = "Location")
				AccObj.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
			  , ret_val := "x" NumGet(x,0,"int") " y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")
			else if (Cmd = "Object")
				ret_val := AccObj
			else if Cmd in Role,State
				ret_val := Acc_%Cmd%(AccObj, ChildID+0)
			else if Cmd in ChildCount,Selection,Focus
				ret_val := AccObj["acc" Cmd]
			else
				ret_val := AccObj["acc" Cmd](ChildID+0)
		} catch {
			ErrorLevel := """" Cmd """ Cmd Not Implemented"
			if Acc_Error()
				throw Exception("Cmd Not Implemented", -1, Cmd)
			return
		}
		return ret_val, ErrorLevel:=0
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}
;modificirano da pokazva samo X pri izpolzvane na location
Acc_GetX(Cmd, ChildPath="", ChildID=0, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="") {
	static properties := {Action:"DefaultAction", DoAction:"DoDefaultAction", Keyboard:"KeyboardShortcut"}
	AccObj :=   IsObject(WinTitle)? WinTitle
			:   Acc_ObjectFromWindow( WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText), 0 )
	if ComObjType(AccObj, "Name") != "IAccessible"
		ErrorLevel := "Could not access an IAccessible Object"
	else {
		StringReplace, ChildPath, ChildPath, _, %A_Space%, All
		AccError:=Acc_Error(), Acc_Error(true)
		Loop Parse, ChildPath, ., %A_Space%
			try {
				if A_LoopField is digit
					Children:=Acc_Children(AccObj), m2:=A_LoopField ; mimic "m2" output in else-statement
				else
					RegExMatch(A_LoopField, "(\D*)(\d*)", m), Children:=Acc_ChildrenByRole(AccObj, m1), m2:=(m2?m2:1)
				if Not Children.HasKey(m2)
					throw
				AccObj := Children[m2]
			} catch {
				ErrorLevel:="Cannot access ChildPath Item #" A_Index " -> " A_LoopField, Acc_Error(AccError)
				if Acc_Error()
					throw Exception("Cannot access ChildPath Item", -1, "Item #" A_Index " -> " A_LoopField)
				return
			}
		Acc_Error(AccError)
		StringReplace, Cmd, Cmd, %A_Space%, , All
		properties.HasKey(Cmd)? Cmd:=properties[Cmd]:
		try {
			if (Cmd = "Location")
				AccObj.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
			  , ret_val :=  NumGet(x,0,"int") 
			else if (Cmd = "Object")
				ret_val := AccObj
			else if Cmd in Role,State
				ret_val := Acc_%Cmd%(AccObj, ChildID+0)
			else if Cmd in ChildCount,Selection,Focus
				ret_val := AccObj["acc" Cmd]
			else
				ret_val := AccObj["acc" Cmd](ChildID+0)
		} catch {
			ErrorLevel := """" Cmd """ Cmd Not Implemented"
			if Acc_Error()
				throw Exception("Cmd Not Implemented", -1, Cmd)
			return
		}
		return ret_val, ErrorLevel:=0
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}
;modificirano da pokazva smo Y pri izpolzvane na location
Acc_GetY(Cmd, ChildPath="", ChildID=0, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="") {
	static properties := {Action:"DefaultAction", DoAction:"DoDefaultAction", Keyboard:"KeyboardShortcut"}
	AccObj :=   IsObject(WinTitle)? WinTitle
			:   Acc_ObjectFromWindow( WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText), 0 )
	if ComObjType(AccObj, "Name") != "IAccessible"
		ErrorLevel := "Could not access an IAccessible Object"
	else {
		StringReplace, ChildPath, ChildPath, _, %A_Space%, All
		AccError:=Acc_Error(), Acc_Error(true)
		Loop Parse, ChildPath, ., %A_Space%
			try {
				if A_LoopField is digit
					Children:=Acc_Children(AccObj), m2:=A_LoopField ; mimic "m2" output in else-statement
				else
					RegExMatch(A_LoopField, "(\D*)(\d*)", m), Children:=Acc_ChildrenByRole(AccObj, m1), m2:=(m2?m2:1)
				if Not Children.HasKey(m2)
					throw
				AccObj := Children[m2]
			} catch {
				ErrorLevel:="Cannot access ChildPath Item #" A_Index " -> " A_LoopField, Acc_Error(AccError)
				if Acc_Error()
					throw Exception("Cannot access ChildPath Item", -1, "Item #" A_Index " -> " A_LoopField)
				return
			}
		Acc_Error(AccError)
		StringReplace, Cmd, Cmd, %A_Space%, , All
		properties.HasKey(Cmd)? Cmd:=properties[Cmd]:
		try {
			if (Cmd = "Location")
				AccObj.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
			  , ret_val :=  NumGet(y,0,"int") 
			else if (Cmd = "Object")
				ret_val := AccObj
			else if Cmd in Role,State
				ret_val := Acc_%Cmd%(AccObj, ChildID+0)
			else if Cmd in ChildCount,Selection,Focus
				ret_val := AccObj["acc" Cmd]
			else
				ret_val := AccObj["acc" Cmd](ChildID+0)
		} catch {
			ErrorLevel := """" Cmd """ Cmd Not Implemented"
			if Acc_Error()
				throw Exception("Cmd Not Implemented", -1, Cmd)
			return
		}
		return ret_val, ErrorLevel:=0
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}
;modificirano da pokazva samo W pri izpolzvane na location
Acc_GetW(Cmd, ChildPath="", ChildID=0, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="") {
	static properties := {Action:"DefaultAction", DoAction:"DoDefaultAction", Keyboard:"KeyboardShortcut"}
	AccObj :=   IsObject(WinTitle)? WinTitle
			:   Acc_ObjectFromWindow( WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText), 0 )
	if ComObjType(AccObj, "Name") != "IAccessible"
		ErrorLevel := "Could not access an IAccessible Object"
	else {
		StringReplace, ChildPath, ChildPath, _, %A_Space%, All
		AccError:=Acc_Error(), Acc_Error(true)
		Loop Parse, ChildPath, ., %A_Space%
			try {
				if A_LoopField is digit
					Children:=Acc_Children(AccObj), m2:=A_LoopField ; mimic "m2" output in else-statement
				else
					RegExMatch(A_LoopField, "(\D*)(\d*)", m), Children:=Acc_ChildrenByRole(AccObj, m1), m2:=(m2?m2:1)
				if Not Children.HasKey(m2)
					throw
				AccObj := Children[m2]
			} catch {
				ErrorLevel:="Cannot access ChildPath Item #" A_Index " -> " A_LoopField, Acc_Error(AccError)
				if Acc_Error()
					throw Exception("Cannot access ChildPath Item", -1, "Item #" A_Index " -> " A_LoopField)
				return
			}
		Acc_Error(AccError)
		StringReplace, Cmd, Cmd, %A_Space%, , All
		properties.HasKey(Cmd)? Cmd:=properties[Cmd]:
		try {
			if (Cmd = "Location")
				AccObj.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
			  , ret_val :=  NumGet(w,0,"int") 
			else if (Cmd = "Object")
				ret_val := AccObj
			else if Cmd in Role,State
				ret_val := Acc_%Cmd%(AccObj, ChildID+0)
			else if Cmd in ChildCount,Selection,Focus
				ret_val := AccObj["acc" Cmd]
			else
				ret_val := AccObj["acc" Cmd](ChildID+0)
		} catch {
			ErrorLevel := """" Cmd """ Cmd Not Implemented"
			if Acc_Error()
				throw Exception("Cmd Not Implemented", -1, Cmd)
			return
		}
		return ret_val, ErrorLevel:=0
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}
;modificirano da pokazva samo H pri izpolzvane na Location
Acc_GetH(Cmd, ChildPath="", ChildID=0, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="") {
	static properties := {Action:"DefaultAction", DoAction:"DoDefaultAction", Keyboard:"KeyboardShortcut"}
	AccObj :=   IsObject(WinTitle)? WinTitle
			:   Acc_ObjectFromWindow( WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText), 0 )
	if ComObjType(AccObj, "Name") != "IAccessible"
		ErrorLevel := "Could not access an IAccessible Object"
	else {
		StringReplace, ChildPath, ChildPath, _, %A_Space%, All
		AccError:=Acc_Error(), Acc_Error(true)
		Loop Parse, ChildPath, ., %A_Space%
			try {
				if A_LoopField is digit
					Children:=Acc_Children(AccObj), m2:=A_LoopField ; mimic "m2" output in else-statement
				else
					RegExMatch(A_LoopField, "(\D*)(\d*)", m), Children:=Acc_ChildrenByRole(AccObj, m1), m2:=(m2?m2:1)
				if Not Children.HasKey(m2)
					throw
				AccObj := Children[m2]
			} catch {
				ErrorLevel:="Cannot access ChildPath Item #" A_Index " -> " A_LoopField, Acc_Error(AccError)
				if Acc_Error()
					throw Exception("Cannot access ChildPath Item", -1, "Item #" A_Index " -> " A_LoopField)
				return
			}
		Acc_Error(AccError)
		StringReplace, Cmd, Cmd, %A_Space%, , All
		properties.HasKey(Cmd)? Cmd:=properties[Cmd]:
		try {
			if (Cmd = "Location")
				AccObj.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
			  , ret_val :=  NumGet(h,0,"int") 
			else if (Cmd = "Object")
				ret_val := AccObj
			else if Cmd in Role,State
				ret_val := Acc_%Cmd%(AccObj, ChildID+0)
			else if Cmd in ChildCount,Selection,Focus
				ret_val := AccObj["acc" Cmd]
			else
				ret_val := AccObj["acc" Cmd](ChildID+0)
		} catch {
			ErrorLevel := """" Cmd """ Cmd Not Implemented"
			if Acc_Error()
				throw Exception("Cmd Not Implemented", -1, Cmd)
			return
		}
		return ret_val, ErrorLevel:=0
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}

Acc_GetChild(Acc_or_Hwnd, child_path) {
   Acc := WinExist("ahk_id" Acc_or_Hwnd)? Acc_ObjectFromWindow(Acc_or_Hwnd):Acc_or_Hwnd
   if ComObjType(Acc,"Name") = "IAccessible" {
      Loop Parse, child_path, csv
         Acc := A_LoopField="P"? Acc_Parent(Acc):Acc_Children(Acc)[A_LoopField]
      return Acc
   }
}


Acc_IsAcc(Acc) {
	try return ComObjType(Acc, "Name") = "IAccessible"
}

GetAccPath(Acc, byref hwnd="") {
	hwnd := Acc_WindowFromObject(Acc)
	WinObj := Acc_ObjectFromWindow(hwnd)
	while Acc_WindowFromObject(Parent:=Acc_Parent(WinObj)) = hwnd
		t1.="P,", WinObj:=Parent
	while Acc_WindowFromObject(Parent:=Acc_Parent(Acc)) = hwnd
		t2:=GetEnumIndex(Acc) "." t2, Acc:=Parent
	return SubStr(t1 t2,3,-1)
}


/*
;original
GetAccPath(Acc, byref hwnd="") {
	hwnd := Acc_WindowFromObject(Acc)
	WinObj := Acc_ObjectFromWindow(hwnd)
	while Acc_WindowFromObject(Parent:=Acc_Parent(WinObj)) = hwnd
		t1.="P,", WinObj:=Parent
	while Acc_WindowFromObject(Parent:=Acc_Parent(Acc)) = hwnd
		t2:=GetEnumIndex(Acc) "," t2, Acc:=Parent
	return SubStr(t1 t2,1,-1)
}

*/
GetEnumIndex(Acc, ChildId=0) {
	if Not ChildId {
		ChildPos := Acc_Location(Acc).pos
		For Each, child in Acc_Children(Acc_Parent(Acc))
			if IsObject(child) and Acc_Location(child).pos=ChildPos
				return A_Index
	} else {
		ChildPos := Acc_Location(Acc,ChildId).pos
		For Each, child in Acc_Children(Acc)
			if Not IsObject(child) and Acc_Location(Acc,child).pos=ChildPos
				return A_Index
	}
}