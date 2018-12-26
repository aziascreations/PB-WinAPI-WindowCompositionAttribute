XIncludeFile "../Includes/SetWindowCompositionAttribute.pbi"

; Loading the function from the library of not done automatically.
If Not SetWindowCompositionAttribute_
	If Not LoadSetWindowCAFunction()
		DebuggerError("Failed to manually load SetWindowCompositionAttribute(...) from user32.dll !")
	EndIf
EndIf

; Setting up the WINCOMPATTRDATA and ACCENTPOLICY structures.
Global pAttrData.WINCOMPATTRDATA, *pData.ACCENTPOLICY  = AllocateMemory(SizeOf(ACCENTPOLICY))

With *pData
	\nAccentState = #ACCENT_ENABLE_ACRYLICBLURBEHIND
	\nColor = $FFFFFFFF
	\nAnimationId = 0
	\nFlags = 0
EndWith

With pAttrData
	\nAttribute = #WCA_ACCENT_POLICY
	\pData = *pData
	\ulDataSize = SizeOf(ACCENTPOLICY)
EndWith

; Gadget variables
Global TrackBar_Red, Text_Red, TrackBar_Green, Text_Green, TrackBar_Blue, Text_Blue, TrackBar_Alpha, Text_Alpha, String_HexCode, Button_Borderless

; Changes the text in String_HexCode to the ABGR hex code.
Procedure UpdateGadgetText()
	Protected R.a, G.a, B.a, A.a
	R = GetGadgetState(TrackBar_Red)
	G = GetGadgetState(TrackBar_Green)
	B = GetGadgetState(TrackBar_Blue)
	A = GetGadgetState(TrackBar_Alpha)
	SetGadgetText(Text_Red, Str(R))
	SetGadgetText(Text_Green, Str(G))
	SetGadgetText(Text_Blue, Str(B))
	SetGadgetText(Text_Alpha, Str(A))
	
	*pData\nColor = A << 24 | B << 16 | G << 8 | R
	;pAttrData\pData = *pData
	
	SetGadgetText(String_HexCode, "$"+Hex(*pData\nColor))
EndProcedure

; TODO: find a way to dynamically change between borderless or not !
Flags = #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_ScreenCentered | #PB_Window_SizeGadget

; Borderless flags (Source: http://forums.purebasic.com/english/viewtopic.php?t=12134)
;Flags = #PB_Window_ScreenCentered | #PB_Window_BorderLess | #WS_SYSMENU | #WS_MINIMIZEBOX

If OpenWindow(0, 100, 200, 480, 320, "Acrylic Gradient Color Picker", Flags)
	;{ Declaring the gadgets
	TextGadget(#PB_Any, 10, 10, 40, 20, "Red :", #PB_Text_Right)
	TrackBar_Red = TrackBarGadget(#PB_Any, 60, 10, 220, 20, 0, 255)
	Text_Red = TextGadget(#PB_Any, 290, 10, 30, 20, "")
	SetGadgetState(TrackBar_Red, 255)
	
	TextGadget(#PB_Any, 10, 30, 40, 20, "Green :", #PB_Text_Right)
	TrackBar_Green = TrackBarGadget(#PB_Any, 60, 30, 220, 20, 0, 255)
	Text_Green = TextGadget(#PB_Any, 290, 30, 30, 20, "")
	SetGadgetState(TrackBar_Green, 255)
	
	TextGadget(#PB_Any, 10, 50, 40, 20, "Blue :", #PB_Text_Right)
	TrackBar_Blue = TrackBarGadget(#PB_Any, 60, 50, 220, 20, 0, 255)
	Text_Blue = TextGadget(#PB_Any, 290, 50, 30, 20, "")
	SetGadgetState(TrackBar_Blue, 255)
	
	TextGadget(#PB_Any, 10, 70, 40, 20, "Alpha :")
	TrackBar_Alpha = TrackBarGadget(#PB_Any, 60, 70, 220, 20, 0, 255)
	Text_Alpha = TextGadget(#PB_Any, 290, 70, 30, 20, "")
	SetGadgetState(TrackBar_Alpha, 31)
	
	TextGadget(#PB_Any, 10, 100, 40, 20, "Hex :", #PB_Text_Right)
	String_HexCode = StringGadget(#PB_Any, 60, 100, 110, 20, "")
	
	;Button_Borderless = ButtonGadget(#PB_Any, 370, 56, 80, 24, "Borderless", #PB_Button_Toggle)
	Button_Exit = ButtonGadget(#PB_Any, 370, 10, 80, 24, "Exit")
	;}
	
	UpdateGadgetText()
	
	; Set the inner window background color to be transparent. (Source: https://www.purebasic.fr/english/viewtopic.php?f=5&t=45362)	
	SetWindowColor(0, #Blue)
	SetWindowLong_(WindowID(0), #GWL_EXSTYLE, #WS_EX_LAYERED | #WS_EX_TOPMOST)
	SetLayeredWindowAttributes_(WindowID(0), #Blue, 0, #LWA_COLORKEY)
	
	; Blurs the background
	SetWindowCompositionAttribute_(WindowID(0), @pAttrData)
	
	Repeat
		Event = WaitWindowEvent()
		
		Select event
			Case #PB_Event_CloseWindow
				Quit = 1
			Case #PB_Event_Gadget
				Select EventGadget()
					Case Button_Borderless
						
					Case Button_Exit
						Quit = 1
					Case TrackBar_Red, TrackBar_Blue, TrackBar_Green, TrackBar_Alpha
						EventType()
						UpdateGadgetText()
						SetWindowCompositionAttribute_(WindowID(0), @pAttrData)
				EndSelect
		EndSelect
		
		If Event = #PB_Event_CloseWindow
		EndIf
	Until Quit = 1
EndIf

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 80
; FirstLine = 39
; Folding = 9
; EnableXP