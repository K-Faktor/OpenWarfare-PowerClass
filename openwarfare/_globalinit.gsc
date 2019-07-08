//******************************************************************************
//  _____                  _    _             __
// |  _  |                | |  | |           / _|
// | | | |_ __   ___ _ __ | |  | | __ _ _ __| |_ __ _ _ __ ___
// | | | | '_ \ / _ \ '_ \| |/\| |/ _` | '__|  _/ _` | '__/ _ \
// \ \_/ / |_) |  __/ | | \  /\  / (_| | |  | || (_| | | |  __/
//  \___/| .__/ \___|_| |_|\/  \/ \__,_|_|  |_| \__,_|_|  \___|
//       | |               We don't make the game you play.
//       |_|                 We make the game you play BETTER.
//
//            Website: http://openwarfaremod.com/
//******************************************************************************

init()
{
	// Initialize the arrays to hold the gametype names and stock map names
	initGametypesAndMaps();

	// Do not thread these initializations
	openwarfare\_eventmanager::eventManagerInit();
	openwarfare\_maprotationcs::init();
	
	thread openwarfare\_advancedacp::init();
	thread openwarfare\_advancedmvs::init();
	thread openwarfare\_antibunnyhopping::init();
	thread openwarfare\_anticamping::init();
	thread openwarfare\_bigbrotherbot::init();
	thread openwarfare\_blackscreen::init();
	thread openwarfare\_bloodsplatters::init();
	thread openwarfare\_bodyremoval::init();
	thread openwarfare\_capeditor::init();
	thread openwarfare\_clanvsall::init();
	thread openwarfare\_damageeffect::init();
	thread openwarfare\_disarmexplosives::init();
	thread openwarfare\_dogtags::init();
	thread openwarfare\_dvarmonitor::init();
	thread openwarfare\_dynamicattachments::init();		
	thread openwarfare\_extendedobituaries::init();	
	thread openwarfare\_fitnesscs::init();	
	thread openwarfare\_globalchat::init();
	thread openwarfare\_guidcs::init();
	thread openwarfare\_healthsystem::init();
	thread openwarfare\_hidescores::init();
	thread openwarfare\_idlemonitor::init();
	thread openwarfare\_keybinds::init();		
	thread openwarfare\_killingspree::init();
	thread openwarfare\_limitexplosives::init();
	thread openwarfare\_livebroadcast::init();
	thread openwarfare\_martyrdom::init();
	thread openwarfare\_numlives::init();
	thread openwarfare\_objoptions::init();
	thread openwarfare\_overtime::init();
	thread openwarfare\_paindeathsounds::init();
	thread openwarfare\_playerdvars::init();
	thread openwarfare\_players::init();
	thread openwarfare\_powerclass::init();	
	thread openwarfare\_quickactions::init();
	thread openwarfare\_rangefinder::init();
	thread openwarfare\_realtimestats::init();
	thread openwarfare\_reservedslots::init();
	thread openwarfare\_rng::init();
	thread openwarfare\_rotateifempty::init();
	thread openwarfare\_rsmonitor::init();
	thread openwarfare\_scorebot::init();
	thread openwarfare\_scoresystem::init();
	thread openwarfare\_serverbanners::init();
	thread openwarfare\_servermessages::init();
	thread openwarfare\_sniperzoom::init();
	thread openwarfare\_spawnprotection::init();
	thread openwarfare\_speedcontrol::init();
	thread openwarfare\_stationaryturrets::init();
	thread openwarfare\_teamstatus::init();
	thread openwarfare\_testbots::init();
	thread openwarfare\_thirdperson::init();
	thread openwarfare\_timeout::init();
	thread openwarfare\_timer::init();
	thread openwarfare\_tkmonitor::init();
	thread openwarfare\_weapondamagemodifier::init();
	thread openwarfare\_weaponjam::init();
	thread openwarfare\_weaponlocationmodifier::init();
	thread openwarfare\_weaponrangemodifier::init();
	thread openwarfare\_weaponweightmodifier::init();
	thread openwarfare\_welcomerulesinfo::init();
}


initGametypesAndMaps()
{
	// ********************************************************************
	// WE DO NOT USE LOCALIZED STRINGS TO BE ABLE TO USE THEM IN MENU FILES
	// ********************************************************************
	
	// Load all the gametypes we currently support
	level.supportedGametypes = [];
	level.supportedGametypes["ass"] = "^1�����������^7";
	level.supportedGametypes["bel"] = "^1� ���� �����^7";
	level.supportedGametypes["ch"] = "^1��������� � ��������^7";
	level.supportedGametypes["ctf"] = "^1������ �����^7";
	level.supportedGametypes["dm"] = "^1��������� ����^7";
	level.supportedGametypes["dom"] = "^1�������������^7";
	level.supportedGametypes["ftag"] = "^1���������^7";
	level.supportedGametypes["gr"] = "^1�����^7";
	level.supportedGametypes["tgr"] = "^1��������� �����^7";
	level.supportedGametypes["gg"] = "^1������^7";	
	level.supportedGametypes["koth"] = "^1����^7";
	level.supportedGametypes["hns"] = "^1������^7";	
	level.supportedGametypes["lms"] = "^1��������� ��������^7";
	level.supportedGametypes["lts"] = "^1�������� �������^7";
	level.supportedGametypes["oitc"] = "^1���� ������^7";
	level.supportedGametypes["re"] = "^1�������^7";
	level.supportedGametypes["sab"] = "^1�������^7";
	level.supportedGametypes["sd"] = "^1�����^7";
	level.supportedGametypes["ss"] = "^1������ �������^7";
	level.supportedGametypes["war"] = "^1��������� ���^7";
	
	// Build the default list of gametypes
	level.defaultGametypeList = buildListFromArrayKeys( level.supportedGametypes, ";" );
	
	// Load the name of the stock maps
	level.stockMapNames = [];
	level.stockMapNames["mp_bog"] = "^4������^7";
	level.stockMapNames["mp_backlot"] = "^4��������^7";
	level.stockMapNames["mp_bloc"] = "^4����^7";
	level.stockMapNames["mp_broadcast"] = "^4�������^7";
	level.stockMapNames["mp_cargoship"] = "^4������ ����^7";
	level.stockMapNames["mp_carentan"] = "^4���������^7";
	level.stockMapNames["mp_citystreets"] = "^4�����^7";
	level.stockMapNames["mp_convoy"] = "^4������^7";
	level.stockMapNames["mp_countdown"] = "^4������^7";
	level.stockMapNames["mp_crash"] = "^4��������^7";
	level.stockMapNames["mp_crash_snow"] = "^4������ ��������^7";
	level.stockMapNames["mp_creek"] = "^4�����^7";
	level.stockMapNames["mp_crossfire"] = "^4�����������^7";
	level.stockMapNames["mp_farm"] = "^4������^7";
	level.stockMapNames["mp_killhouse"] = "^4���������^7";
	level.stockMapNames["mp_overgrown"] = "^4�����^7";
	level.stockMapNames["mp_pipeline"] = "^4�����������^7";
	level.stockMapNames["mp_shipment"] = "^4�����������^7";
	level.stockMapNames["mp_showdown"] = "^4�������^7";
	level.stockMapNames["mp_strike"] = "^4����^7";
	level.stockMapNames["mp_vacant"] = "^4����^7";
	
	// Build the default list of maps
	level.defaultMapList = buildListFromArrayKeys( level.stockMapNames, ";" );
}


buildListFromArrayKeys( arrayToList, delimiter )
{
	newList = "";
	arrayKeys = getArrayKeys( arrayToList );
	
	for ( i = 0; i < arrayKeys.size; i++ ) {
		if ( newList != "" ) {
			newList += delimiter;
		}
		newList += arrayKeys[i];		
	}	

	return newList;
}