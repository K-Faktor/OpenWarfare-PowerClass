/**************************************************************

	Tally's Improved Modwarfare Bot Code
	------------------------------------
	
	This bot script improves over the first one I 
	did for modwarfare in 2007 in that it uses the 
	offline classtable. If anyone makes a mod which uses
	both create-a-class and modwarfare, there is no longer
	any need to create 2 bot scripts - just use this one for 
	both!

***************************************************************/

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

#include openwarfare\_utils;

init()
{
	level.testclients = getdvarx( "scr_testclients", "int", 0, 0, 64 );
	
	if( !level.testclients ) return;

	level.classMap["offline_class1_mp"] = "OFFLINE_CLASS1";
	level.classMap["offline_class2_mp"] = "OFFLINE_CLASS2";
	level.classMap["offline_class3_mp"] = "OFFLINE_CLASS3";
	level.classMap["offline_class4_mp"] = "OFFLINE_CLASS4";
	level.classMap["offline_class5_mp"] = "OFFLINE_CLASS5";
	level.classMap["offline_class6_mp"] = "OFFLINE_CLASS6";
	level.classMap["offline_class7_mp"] = "OFFLINE_CLASS7";
	level.classMap["offline_class8_mp"] = "OFFLINE_CLASS8";
	level.classMap["offline_class9_mp"] = "OFFLINE_CLASS9";
	level.classMap["offline_class10_mp"] = "OFFLINE_CLASS10";	

	datatable = "mp/offline_classTable.csv";
	
	default_loadout( datatable, "OFFLINE_CLASS1", 200 );
	default_loadout( datatable, "OFFLINE_CLASS2", 210 );
	default_loadout( datatable, "OFFLINE_CLASS3", 220 );
	default_loadout( datatable, "OFFLINE_CLASS4", 230 );
	default_loadout( datatable, "OFFLINE_CLASS5", 240 );
	default_loadout( datatable, "OFFLINE_CLASS6", 250 );
	default_loadout( datatable, "OFFLINE_CLASS7", 260 );
	default_loadout( datatable, "OFFLINE_CLASS8", 270 );
	default_loadout( datatable, "OFFLINE_CLASS9", 280 );
	default_loadout( datatable, "OFFLINE_CLASS10", 290 );
	
	if( game["roundsplayed"] > 0 )
		thread onPlayerConnect();
	
	thread addTestClients();
}

/************************************************************************************
	These 2 functions are needed to spoof the ranks, as the main testclient 
	function is not called on more than 1 round. On a second round, they need ranks!
*************************************************************************************/

//////////////////////////////////////////////////////////////////////////////////////

onPlayerConnect()
{	
	for( ;; )
	{
		level waittill( "connected", player );
		
		if( IsBot( player ) )
			player thread OnBotSpawned();
	}
}

OnBotSpawned()
{
	self waittill( "spawned_player" );
	
	// give them back their spoofed rank
	self setRank( self.pers["Botrank"], 0 );
}

/////////////////////////////////////////////////////////////////////////////////////////

default_loadout( datatable, class, stat_num )
{
	setDefaultLoadout( datatable, "allies", class, stat_num );
	setDefaultLoadout( datatable, "axis", class, stat_num );
}

setDefaultLoadout( datatable, team, class, stat_num )
{
	// give primary weapon and attachment
	primary_attachment = tablelookup( datatable, 1, stat_num + 2, 4 );
	if( primary_attachment != "" && primary_attachment != "none" )
		game["classWeapons"][team][class][0] = tablelookup( datatable, 1, stat_num + 1, 4 ) + "_" + primary_attachment + "_mp";
	else
		game["classWeapons"][team][class][0] = tablelookup( datatable, 1, stat_num + 1, 4 ) + "_mp";	

	// give secondary weapon and attachment
	secondary_attachment = tablelookup( datatable, 1, stat_num + 4, 4 );
	if( secondary_attachment != "" && secondary_attachment != "none" )
		game["classSidearm"][team][class] = tablelookup( datatable, 1, stat_num + 3, 4 ) + "_" + secondary_attachment + "_mp";
	else
		game["classSidearm"][team][class] = tablelookup( datatable, 1, stat_num + 3, 4 ) + "_mp";	
		
	// give frag and special grenades
	game["classGrenades"][class]["primary"]["type"] = tablelookup( datatable, 1, stat_num, 4 ) + "_mp";
	game["classGrenades"][class]["primary"]["count"] = int( tablelookup( datatable, 1, stat_num, 6 ) );
	game["classGrenades"][class]["secondary"]["type"] = tablelookup( datatable, 1, stat_num + 8, 4 ) + "_mp";
	game["classGrenades"][class]["secondary"]["count"] = int( tablelookup( datatable, 1, stat_num + 8, 6 ) );
	
	// give default class perks
	game["default_perk"][class] = [];	
	game["default_perk"][class][0] = tablelookup( datatable, 1, stat_num + 5, 4 );
	game["default_perk"][class][1] = tablelookup( datatable, 1, stat_num + 6, 4 );
	game["default_perk"][class][2] = tablelookup( datatable, 1, stat_num + 7, 4 );
	
	// give all inventory
	inventory_ref = tablelookup( datatable, 1, stat_num + 5, 4 );
	if( isdefined( inventory_ref ) && tablelookup( "mp/statsTable.csv", 6, inventory_ref, 2 ) == "inventory" )
	{
		inventory_count = int( tablelookup( "mp/statsTable.csv", 6, inventory_ref, 5 ) );
		inventory_item_ref = tablelookup( "mp/statsTable.csv", 6, inventory_ref, 4 );
		assertex( isdefined( inventory_count ) && inventory_count != 0 && isdefined( inventory_item_ref ) && inventory_item_ref != "" , "Inventory in statsTable.csv not specified correctly" );
		
		game["classItem"][team][class]["type"] = inventory_item_ref;
		game["classItem"][team][class]["count"] = inventory_count;
	}
	else
	{
		game["classItem"][team][class]["type"] = "";
		game["classItem"][team][class]["count"] = 0;		
	}
}

addTestClients()
{
	// Return here after first round otherwise the bots multiply exponentially
	if( game["roundsplayed"] > 0 ) return;
	
	wait( 5 );

	for( i = 0; i < level.testclients; i++ )
	{
		Bot[i] = addtestclient();

		if( !isdefined( Bot[i] ) ) 
		{
			println( "Could not add test client" );
			wait( 1 );
			continue;
		}
		
		Bot[i] thread TestClient( "autoassign" );
		
		wait( 0.75 );
	}
}

TestClient( team )
{ 
	while( !isdefined( self.pers["team"] ) )
		wait( 0.05 );
	
	// give the bots a spoofed rank	when they join a team
	self thread spoof_rank();

	self notify( "menuresponse", game["menu_team"], team );
	wait( 0.5 );

	classes = getArrayKeys( level.classMap );
	okclasses = [];
	for( i = 0; i < classes.size; i++ )
	{
		if( isDefined( game["default_perk"][ level.classMap[ classes[i] ] ] ) )
			okclasses[ okclasses.size ] = classes[i];
	}
	
	assert( okclasses.size );

	class = okclasses[ randomint( okclasses.size ) ];

	self notify( "menuresponse", game["menu_changeclass"], class );
	
}

menuClass( response )
{
	self maps\mp\gametypes\_globallogic::closeMenus();

	// this should probably be an assert
	if( !isDefined( self.pers["team"] ) || ( self.pers["team"] != "allies" && self.pers["team"] != "axis" ) )
		return;
	
	//===== SET CLASS ====
	
	// This is their actual class - their level.classmap class
	self.pers["classMap"] = getClassChoice( response );
	
	// Set a class recognised by modwarfare ( i.e. "assault", "specops", "demolitions", "sniper", and "heavygunner" ) - this is 
	// needed by modwarfare's release and claim class functions
	primary = game["classWeapons"][self.pers["team"]][ self.pers["classMap"] ][0];	
	class = convertWeapontoClassModwarfare( primary ); // convert their primary weapon into a class recognised by modwarfare ( i.e. "assault", "specops", "demolitions", "sniper", and "heavygunner" )
	
	// store their modwarfare class to self.curClass struct
	self setClass( class );
	
	//====================

	if( self.sessionstate == "playing" )
	{
		self.pers["class"] = class;
		self.class = class;
		
		/*
		// claim the bot's class in modwarfare
		self maps\mp\gametypes\_modwarfare::claimClass( self.pers["team"], self.pers["class"] );
		*/

		if( game["state"] == "postgame" )
			return;
	}
	else
	{
		self.pers["class"] = class;
		self.class = class;
		
		/*
		// claim the bot's class in modwarfare
		self maps\mp\gametypes\_modwarfare::claimClass( self.pers["team"], self.pers["class"] );
		*/

		if( game["state"] == "postgame" )
			return;

		if( game["state"] == "playing" )
			self thread [[level.spawnClient]]();
	}

	level thread maps\mp\gametypes\_globallogic::updateTeamStatus();
	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}

giveLoadout( team )
{
	self takeAllWeapons();
	
	// initialize specialty array
	self.specialty = [];
	
	// load the selected default class's specialties
	assertex( isdefined( self.pers["classMap"] ), "Player during spawn and loadout got no class!" );
	
	specialty_size = game["default_perk"][ self.pers["classMap"] ].size;	
	for( i = 0; i < specialty_size; i++ )
	{
		if( isdefined( game["default_perk"][ self.pers["classMap"] ][i] ) && game["default_perk"][ self.pers["classMap"] ][i] != "" )
			self.specialty[self.specialty.size] = game["default_perk"][ self.pers["classMap"] ][i];
	}
	assertex( isdefined( self.specialty ) && self.specialty.size > 0, "Default class: " + self.pers["classMap"] + " is missing specialties " );
		
	// re-registering perks to code since perks are cleared after respawn in case players switch classes
	self maps\mp\gametypes\_class::register_perks();
		
	//=========== SIDEARM ===============
	
	sidearm = game["classSidearm"][team][ self.pers["classMap"] ];
		
	self GiveWeapon( sidearm );
	if( self maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_extraammo" ) )
		self giveMaxAmmo( sidearm );
	
	//=========== END SIDEARM ============
	
	//========= PRIMARY WEAPON ===========
	
	primaryWeapon = game["classWeapons"][team][ self.pers["classMap"] ][0]; // weaponName + "_mp"
	
	self maps\mp\gametypes\_teams::playerModelForWeapon( primaryWeapon );		

	self GiveWeapon( primaryWeapon );
	if( self maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_extraammo" ) )
		self giveMaxAmmo( primaryWeapon );
	self setSpawnWeapon( primaryWeapon );
	
	//========== END PRIMARY WEAPON =========
	
	//========== INVENTORY ITEMS ============
	
	inventoryItem = game["classItem"][team][ self.pers["classMap"] ]["type"];	
	if( inventoryItem != "" )
	{
		self GiveWeapon( inventoryItem );
			
		self maps\mp\gametypes\_class::setWeaponAmmoOverall( inventoryItem, game["classItem"][team][ self.pers["classMap"] ]["count"] );
			
		self SetActionSlot( 3, "weapon", inventoryItem );
		self SetActionSlot( 4, "" );
	}
	else
	{
		self SetActionSlot( 3, "altMode" );
		self SetActionSlot( 4, "" );
	}
	
	//========== END INVENTORY ITEMS =========
	
	
	//========== GRENADES ============
		
	grenadeTypePrimary = game["classGrenades"][ self.pers["classMap"] ]["primary"]["type"];
	if( grenadeTypePrimary != "" )
	{
		grenadeCount = game["classGrenades"][ self.pers["classMap"] ]["primary"]["count"];
	
		self GiveWeapon( grenadeTypePrimary );
		self SetWeaponAmmoClip( grenadeTypePrimary, grenadeCount );
		self SwitchToOffhand( grenadeTypePrimary );
	}
		
	grenadeTypeSecondary = game["classGrenades"][ self.pers["classMap"] ]["secondary"]["type"];
	if( grenadeTypeSecondary != "" )
	{
		grenadeCount = game["classGrenades"][ self.pers["classMap"] ]["secondary"]["count"];
	
		if ( grenadeTypeSecondary == level.weapons["flash"] )
			self setOffhandSecondaryClass( "flash" );
		else
			self setOffhandSecondaryClass( "smoke" );
			
		self giveWeapon( grenadeTypeSecondary );
		self SetWeaponAmmoClip( grenadeTypeSecondary, grenadeCount );
	}
	
	//========== END GRENADES ============
	
	switch ( weaponClass( primaryWeapon ) )
	{
		case "rifle":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_assault_movespeed", "float", 0.95, 0.5, 1.5 ) );
			break;
		case "pistol":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_sniper_movespeed", "float", 1.0, 0.5, 1.5 ) );
			break;
		case "mg":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_heavygunner_movespeed", "float", 0.875, 0.5, 1.5 )  );
			break;
		case "smg":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_specops_movespeed", "float", 1.0, 0.5, 1.5 ) );
			break;
		case "spread":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_demolitions_movespeed", "float", 1.0, 0.5, 1.5 ) );
			break;
		default:
			self thread openwarfare\_speedcontrol::setBaseSpeed( 1.0 );
			break;
	}
	
	// check for specialty_detectexplosives and if so thread to bombsquad
	self maps\mp\gametypes\_class::cac_selector();
}

getClassChoice( response )
{
	tokens = strtok( response, "," );
	
	assert( isDefined( level.classMap[tokens[0]] ) );
	
	return( level.classMap[tokens[0]] );
}

setClass( newClass )
{
	self.curClass = newClass;
}

// Function to spoof rank
spoof_rank()
{	
	giverank = [];
	
	for( i=0; i < 55; i++ )
		giverank[i] = i;
	
	rankId = giverank[ randomint( giverank.size ) ];
	self.pers["Botrank"] = rankId;
	self setRank( self.pers["Botrank"], 0 );	
}

isbot( player )
{
	if( GetSubStr( player.name, 0, 3 ) == "bot" ) return true; 
 
	return false;
}

AnnouncetoAll( Msg )
{
	players = getentarray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		players[i] iprintlnbold( Msg );
	}
}

/*****************************************************************************

	ConvertWeapontoClassModwarfare
	------------------------------
	
	Function to convert primary weapon to class groups recognised by modwarfare 
	( i.e. "assault", "specops", "demolitions", "sniper", and "heavygunner" ) 
	since modwarfare doesn't use the same class group names as CAC ( i.e. "assault", 
	"smg", "shotgun", "sniper", and "lmg" ). 

******************************************************************************/
convertWeapontoClassModwarfare( weapon )
{
	switch( level.primary_weapon_array[ weapon ] )
	{
		case "weapon_assault":
			return( "assault" );
			
		case "weapon_smg":
			return( "specops" );
			
		case "weapon_sniper":
			return( "sniper" );
			
		case "weapon_shotgun":
			return( "demolitions" );
			
		case "weapon_lmg":
			return( "heavygunner" );
			
	}
}
