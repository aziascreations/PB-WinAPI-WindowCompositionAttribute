XIncludeFile "../Includes/SetWindowCompositionAttribute.pbi"

; Loading the function from the library of not done automatically.
If Not SetWindowCompositionAttribute_
	If Not LoadSetWindowCAFunction()
		DebuggerError("Failed to automatically load SetWindowCompositionAttribute(...) from user32.dll ! -> (SetWindowCompositionAttribute.pbi)")
	EndIf
EndIf

; Setting up the WINCOMPATTRDATA and ACCENTPOLICY structures.
Define pAttrData.WINCOMPATTRDATA, *pData.ACCENTPOLICY  = AllocateMemory(SizeOf(ACCENTPOLICY))

With *pData
	\nAccentState = #ACCENT_ENABLE_ACRYLICBLURBEHIND
	\nColor = $3FCBC0FF ; ABGR - The alpha channel represents the intensity of the given color
	\nAnimationId = 0
	\nFlags = 0
EndWith

With pAttrData
	\nAttribute = #WCA_ACCENT_POLICY
	\pData = *pData
	\ulDataSize = SizeOf(ACCENTPOLICY)
EndWith

; Show the window and do some magic.
If OpenWindow(0, 100, 200, 400, 320, "PureBasic Window", #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
	
	; Set the inner window background color to be transparent. (Source: https://www.purebasic.fr/english/viewtopic.php?f=5&t=45362)	
	SetWindowColor(0, #Blue)
	SetWindowLong_(WindowID(0), #GWL_EXSTYLE, #WS_EX_LAYERED | #WS_EX_TOPMOST)
	SetLayeredWindowAttributes_(WindowID(0), #Blue, 0, #LWA_COLORKEY)
	
	; Blurs the background
	SetWindowCompositionAttribute_(WindowID(0), @pAttrData)
	
	Repeat
		Event = WaitWindowEvent()
		
		If Event = #PB_Event_CloseWindow
			Quit = 1
		EndIf
	Until Quit = 1
EndIf
; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 28
; FirstLine = 9
; EnableXP