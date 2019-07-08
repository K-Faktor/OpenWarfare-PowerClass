/**/
#define CAC_POPUP( nameArg, xArg, yArg ) \
	menuDef	 \
	{ \
		IMPROVED_POPUP_SETUP_ONOPEN( nameArg, 8, xArg, yArg, ;, ;, 1 ) \
		PREPROC_SHADER_DRAW_ALIGNED( -4 -24 (CHOICE_POPUP_WIDTH) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 1, 2, CHOICE_POPUP_BORDER_COLOR ) \
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -22 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@MPUI_YOUR_CLASSES", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR ) \
		PREPROC_SHADER_DRAW_ALIGNED( 200 -14 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_down", 0.9 0.9 0.95 0.4, 0, 2, CHOICE_POPUP_BORDER_COLOR ) \
		CHOICE_BUTTON( 1, dvarString(customclass1), scriptMenuResponse "cacedit,0"; close self; ) \
		CHOICE_BUTTON( 2, dvarString(customclass2), scriptMenuResponse "cacedit,1"; close self; ) \
		CHOICE_BUTTON( 3, dvarString(customclass3), scriptMenuResponse "cacedit,2"; close self; ) \
		CHOICE_BUTTON( 4, dvarString(customclass4), scriptMenuResponse "cacedit,3"; close self; ) \
		CHOICE_BUTTON( 5, dvarString(customclass5), scriptMenuResponse "cacedit,4"; close self; ) \
		CHOICE_BUTTON( 6, dvarString(customclass6), scriptMenuResponse "cacedit,5"; close self; ) \
		CHOICE_BUTTON( 7, dvarString(customclass7), scriptMenuResponse "cacedit,6"; close self; ) \
		CHOICE_BUTTON( 8, dvarString(customclass8), scriptMenuResponse "cacedit,7"; close self; ) \
	}