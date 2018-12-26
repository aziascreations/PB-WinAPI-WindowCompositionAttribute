Enumeration WindowCompositionAttribute
	#WCA_ACCENT_POLICY = 19
EndEnumeration

Enumeration AccentState
	#ACCENT_DISABLED = 0
	#ACCENT_ENABLE_GRADIENT = 1
	#ACCENT_ENABLE_TRANSPARENTGRADIENT = 2
	#ACCENT_ENABLE_BLURBEHIND = 3
	#ACCENT_ENABLE_ACRYLICBLURBEHIND = 4 ; Added in Redstone 4 (https://withinrafael.com/2018/02/01/adding-acrylic-blur-to-your-windows-10-apps-redstone-4-desktop-apps/)
	#ACCENT_INVALID_STATE = 5
EndEnumeration

Structure ACCENTPOLICY ; Used when #WCA_ACCENT_POLICY in used for nAttribute.i in a WINCOMPATTRDATA structure
	nAccentState.i
	nColor.i ; Was supposed to be lower in the structure according to the source material, but tests worked with this setup.
	nFlags.i
	nAnimationId.i
EndStructure

Structure WINCOMPATTRDATA
	nAttribute.i
	*pData
	ulDataSize.i
EndStructure

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 13
; EnableXP