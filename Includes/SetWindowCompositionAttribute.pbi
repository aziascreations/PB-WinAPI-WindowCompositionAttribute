; Documentation & sources:
;	* http://undoc.airesoft.co.uk/user32.dll/SetWindowCompositionAttribute.php
;	* https://withinrafael.com/2015/07/08/adding-the-aero-glass-blur-to-your-windows-10-apps/
;	* https://withinrafael.com/2018/02/01/adding-acrylic-blur-to-your-windows-10-apps-redstone-4-desktop-apps/

XIncludeFile "WindowCompositionAttributeHeader.pbi"

; TODO: Check if it is just a long or an int (size difference between 32&64 bits)
Prototype.b SWCA_WIN_API_UNDOCUMMENTED(hwnd.l, *pAttrData)

Global SetWindowCompositionAttribute_.SWCA_WIN_API_UNDOCUMMENTED = #Null

Procedure.b LoadSetWindowCAFunction()
	Protected LibId = OpenLibrary(#PB_Any, "user32.dll")
	
	If LibId
		SetWindowCompositionAttribute_ = GetFunction(LibId, "SetWindowCompositionAttribute")
		CloseLibrary(LibId)
		
		If SetWindowCompositionAttribute_
			ProcedureReturn #True
		EndIf
		
		DebuggerWarning("Failed to load SetWindowCompositionAttribute(...) from user32.dll !")
	EndIf
	
	DebuggerWarning("Failed to load user32.dll !")
	ProcedureReturn #False
EndProcedure


; Uncomment this piece of code to let the program attempt to load it on its own.

; If Not LoadSetWindowCAFunction()
; 	DebuggerError("Failed to automatically load SetWindowCompositionAttribute(...) from user32.dll ! -> (SetWindowCompositionAttribute.pbi)")
; EndIf

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 18
; FirstLine = 2
; Folding = -
; EnableXP