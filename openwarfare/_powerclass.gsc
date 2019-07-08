/**/
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
		
	game["menu_cac_editor"] = "cac_editor";
	precacheMenu( game["menu_cac_editor"] );
	
	level.serverDvars = [];
	
	//--- Integral Config Edit Dvar ---
	level.configedit 	= dvardef( "scr_powerclass_configedit", 0, 0, 999, "int" );
	
	//--- turn progressive unlocks on or off ---
	level.progressiveUnlocks = dvardef( "scr_powerclass_progressiveUnlocks", 0, 0, 1, "int" );

	//------------------------- Default Class Hangling --------------------------------------------------
	
	// set each custom class to a default weapon 
	level.default_class0			= dvardef( "scr_default_weapon1", "m16", "", "", "string" );
	level.default_class1			= dvardef( "scr_default_weapon2", "mp5", "", "", "string" );
	level.default_class2			= dvardef( "scr_default_weapon3", "saw", "", "", "string" );
	level.default_class3			= dvardef( "scr_default_weapon4", "winchester1200", "", "", "string" );
	level.default_class4			= dvardef( "scr_default_weapon5", "m40a3", "", "", "string" );
	level.default_class5			= dvardef( "scr_default_weapon6", "skorpion", "", "", "string" );
	level.default_class6			= dvardef( "scr_default_weapon7", "ak47", "", "", "string" );
	level.default_class7			= dvardef( "scr_default_weapon8", "rpd", "", "", "string" );
	
	//--------------------------- Weapon Dvars --------------------------------------------------------

	//--- allow Weapons individually ---
	level.allow_m21 				= dvardef( "weap_allow_m21", 1, 0, 1, "int" );
	level.allow_m4 					= dvardef( "weap_allow_m4", 1, 0, 1, "int" );
	level.allow_uzi 				= dvardef( "weap_allow_uzi", 1, 0, 1, "int" );
	level.allow_m60e4 				= dvardef( "weap_allow_m60e4", 1, 0, 1, "int" );
	level.allow_g3	 				= dvardef( "weap_allow_g3", 1, 0, 1, "int" );
	level.allow_ak74u 				= dvardef( "weap_allow_ak74u", 1, 0, 1, "int" );
	level.allow_m1014 				= dvardef( "weap_allow_m1014", 1, 0, 1, "int" );
	level.allow_remington700		= dvardef( "weap_allow_remington700", 1, 0, 1, "int" );
	level.allow_g36c		 		= dvardef( "weap_allow_g36c", 1, 0, 1, "int" );
	level.allow_p90			 		= dvardef( "weap_allow_p90", 1, 0, 1, "int" );
	level.allow_m14					= dvardef( "weap_allow_m14", 1, 0, 1, "int" );
	level.allow_barrett				= dvardef( "weap_allow_barrett", 1, 0, 1, "int" );
	level.allow_mp44				= dvardef( "weap_allow_mp44", 1, 0, 1, "int" );
	level.allow_ak47				= dvardef( "weap_allow_ak47", 1, 0, 1, "int" );
	level.allow_rpd					= dvardef( "weap_allow_rpd", 1, 0, 1, "int" );
	level.allow_skorpion			= dvardef( "weap_allow_skorpion", 1, 0, 1, "int" );
	level.allow_mp5 				= dvardef( "weap_allow_mp5", 1, 0, 1, "int" );
	level.allow_m16 				= dvardef( "weap_allow_m16", 1, 0, 1, "int" );
	level.allow_saw 				= dvardef( "weap_allow_saw", 1, 0, 1, "int" );
	level.allow_winchester1200 		= dvardef( "weap_allow_winchester1200", 1, 0, 1, "int" );
	level.allow_m40a3 				= dvardef( "weap_allow_m40a3", 1, 0, 1, "int" );
	level.allow_dragunov 			= dvardef( "weap_allow_dragunov", 1, 0, 1, "int" );
	
	//--- allow pistols individually ---
	level.allow_beretta 			= dvardef( "weap_allow_beretta", 1, 0, 1, "int" );
	level.allow_colt45 				= dvardef( "weap_allow_colt45", 1, 0, 1, "int" );
	level.allow_usp 				= dvardef( "weap_allow_usp", 1, 0, 1, "int" );
	level.allow_deserteagle			= dvardef( "weap_allow_deserteagle", 1, 0, 1, "int" );
	level.allow_deagle_gold			= dvardef( "weap_allow_deserteaglegold", 1, 0, 1, "int" );
	
	//--- allow grenades individually ---
	level.allow_frag_grenade 		= dvardef( "weap_allow_frag_grenade", 1, 0, 1, "int" );
	level.allow_concussion_grenade 	= dvardef( "weap_allow_concussion_grenade", 1, 0, 1, "int" );
	level.allow_flash_grenade		= dvardef( "weap_allow_flash_grenade", 1, 0, 1, "int" );
	level.allow_smoke_grenade 		= dvardef( "weap_allow_smoke_grenade", 1, 0, 1, "int" );

	//---------------------------- Attachment Dvars ------------------------------------------------------
	
	//--- allow attachments individually ---
	level.attach_allow_none 	= dvardef( "attachment_allow_none", 1, 0, 1, "int" );
	level.attach_allow_gl 		= dvardef( "attachment_allow_gl", 1, 0, 1, "int" );
	level.attach_allow_reflex 	= dvardef( "attachment_allow_reflex", 1, 0, 1, "int" );
	level.attach_allow_silencer = dvardef( "attachment_allow_silencer", 1, 0, 1, "int" );
	level.attach_allow_acog 	= dvardef( "attachment_allow_acog", 1, 0, 1, "int" );
	level.attach_allow_grip 	= dvardef( "attachment_allow_grip", 1, 0, 1, "int" );

	//---------------------------- Perk Dvars -----------------------------------------------------------

	//Perk Group 1
	level.perk_allow_specialgrenade		= dvardef( "perk_allow_specialty_specialgrenade", 1, 0, 1, "int" );
	level.perk_allow_fraggrenade		= dvardef( "perk_allow_specialty_fraggrenade", 1, 0, 1, "int" );
	level.perk_allow_extraammo			= dvardef( "perk_allow_specialty_extraammo", 1, 0, 1, "int" );
	level.perk_allow_detectexplosive	= dvardef( "perk_allow_specialty_detectexplosive", 1, 0, 1, "int" );
	level.perk_allow_C4					= dvardef( "perk_allow_c4_mp", 1, 0, 1, "int" );
	level.perk_allow_rpg				= dvardef( "perk_allow_rpg_mp", 1, 0, 1, "int" );
	level.perk_allow_claymore			= dvardef( "perk_allow_claymore_mp", 1, 0, 1, "int" );
	
	// original dvars preserved from OW modwarfare 
	level.inventory_ammo_claymore = getdvarx( "scr_claymore_ammo_count", "int", 2, 1, 2 );
	level.inventory_ammo_rpg = getdvarx( "scr_rpg_ammo_count", "int", 2, 1, 3 );
	level.inventory_ammo_c4 = getdvarx( "scr_c4_ammo_count", "int", 2, 1, 2 );
	
	// original dvars preserved from OW modwarfare
	level.specialty_fraggrenade_ammo_count = getdvarx( "specialty_fraggrenade_ammo_count", "int", 2, 1, 3 );
	level.specialty_specialgrenade_ammo_count = getdvarx( "specialty_specialgrenade_ammo_count", "int", 2, 1, 3 );
	
	//Perk Group 2
	level.perk_allow_bulletdamage		= dvardef( "perk_allow_specialty_bulletdamage", 1, 0, 1, "int" );
	level.perk_allow_armorvest			= dvardef( "perk_allow_specialty_armorvest", 1, 0, 1, "int" );
	level.perk_allow_fastreload			= dvardef( "perk_allow_specialty_fastreload", 1, 0, 1, "int" );
	level.perk_allow_rof				= dvardef( "perk_allow_specialty_rof", 1, 0, 1, "int" );
	level.perk_allow_gpsjammer			= dvardef( "perk_allow_specialty_gpsjammer", 1, 0, 1, "int" );
	level.perk_allow_explosivedamage	= dvardef( "perk_allow_specialty_explosivedamage", 1, 0, 1, "int" );
	level.perk_allow_twoprimaries		= dvardef( "perk_allow_specialty_twoprimaries", 1, 0, 1, "int" );
	
	//Perk Group 3
	level.perk_allow_longersprint		= dvardef( "perk_allow_specialty_longersprint", 1, 0, 1, "int" );
	level.perk_allow_bulletaccuracy		= dvardef( "perk_allow_specialty_bulletaccuracy", 1, 0, 1, "int" );
	level.perk_allow_pistoldeath		= dvardef( "perk_allow_specialty_pistoldeath", 1, 0, 1, "int" );
	level.perk_allow_grenadepulldeath	= dvardef( "perk_allow_specialty_grenadepulldeath", 1, 0, 1, "int" );
	level.perk_allow_bulletpenetration	= dvardef( "perk_allow_specialty_bulletpenetration", 1, 0, 1, "int" );
	level.perk_allow_holdbreath			= dvardef( "perk_allow_specialty_holdbreath", 1, 0, 1, "int" );
	level.perk_allow_quieter			= dvardef( "perk_allow_specialty_quieter", 1, 0, 1, "int" );
	level.perk_allow_parabolic			= dvardef( "perk_allow_specialty_parabolic", 1, 0, 1, "int" );
	
	//---------------------------- CAMO Dvars -----------------------------------------------------------
	
	dvardef( "camo_allow_camo_none", 1, 0, 1, "int" );
	dvardef( "camo_allow_camo_brockhaurd", 1, 0, 1, "int" );
	dvardef( "camo_allow_camo_bushdweller", 1, 0, 1, "int" );
	dvardef( "camo_allow_camo_blackwhitemarpat", 1, 0, 1, "int" );
	dvardef( "camo_allow_camo_tigerred", 1, 0, 1, "int" );
	dvardef( "camo_allow_camo_stagger", 1, 0, 1, "int" );
	dvardef( "camo_allow_camo_gold", 1, 0, 1, "int" );
	
	//---------------------------------------------------------------------------------------------------
	
	if( level.progressiveUnlocks )
	{
		// These are the default unlocked items. Everything else has to be unlocked progressively via rank or challenge
		level.defaultWeapons = "beretta;usp;mp5;skorpion;m16;ak47;m40a3;winchester1200;rpd;saw;frag_grenade;flash_grenade;smoke_grenade;concussion_grenade";
		level.defaultPerks = "c4_mp;claymore_mp;rpg_mp;specialty_specialgrenade;specialty_bulletdamage;specialty_armorvest;specialty_explosivedamage;specialty_longersprint;specialty_bulletaccuracy;specialty_bulletpenetration";
		level.defaultAttachments = "gl;silencer";
		level.defaultCamos = "camo_none;camo_brockhaurd;camo_bushdweller";
		
		// Challenge Camo string array
		level.challengeCamos = "camo_blackwhitemarpat;camo_tigerred;camo_stagger;camo_gold";
	}
	
	level thread onPlayerConnected();
}

// Run this from connecting player, otherwise we will incur a server command overflow. 
// Rather, wait for the player to be actually fully connected.
onPlayerConnected()
{
	for( ;; )
	{
		level waittill( "connected", player );
		
		// don't run this stuff on bots
		if( openwarfare\_testbots::isBot( player ) ) return;
		
		/////////// CLOSE CLASS AND CAC EDITOR FOR CERTAIN GAME MODES ///////////////////
		
		if( byPassClassSelection() )
		{
			player setClientdvar( "ui_close_class", 1 );
			return;
		}
		else
			player setClientdvar( "ui_close_class", 0 );
		
		////////////////////////////////////////////////////////////////////////////
		
		// init the class reset methods
		player init_DefaultClasses();
		player thread SetExtraClassName();

		player thread initPlayerValues();
		player thread setClassEditorDvars();
		
		// init the class editor
		player thread openwarfare\_caceditor::initializeEditor();
		player thread openwarfare\_caceditor::cacResponseHandler();
		
		player thread onPlayerSpawned();
	}
}

initPlayerValues()
{
	self.specialty = [];
	self.specialty[0] = "specialty_null";
	self.specialty[1] = "specialty_null";
	self.specialty[2] = "specialty_null";
	
	if( level.progressiveUnlocks )
	{	
		// Build a Client Array for Weapon Challenge Items
		self.challengeAttachments = [];
		self.challengeCamos = [];
		for( i=0; i < level.baseWeaponName.size; i++ )
		{
			weaponName = level.baseWeaponName[i];
			
			// Camos
			self.challengeCamos[weaponName] = [];
			challengeCamos = StrTok( level.challengeCamos, ";" );
			for( j=0; j < challengeCamos.size; j++ )
				self.challengeCamos[weaponName][challengeCamos[j]] = 0;
			
			// Attachments
			self.challengeAttachments[weaponName] = [];
			for( j=0; j < level.weaponAttachments.size; j++ )
				self.challengeAttachments[weaponName][level.weaponAttachments[j]] = 0;
		}

		// Open the default Weapon Attachment player flags
		self.challengeAttachments[ "beretta" ]["silencer"] = 1;
		self.challengeAttachments[ "usp" ]["silencer"] = 1;
		self.challengeAttachments[ "ak47" ]["gl"] = 1;
		self.challengeAttachments[ "m16" ]["gl"] = 1;
	
	}
}

// set the client dvars to open all class items in the editor
setClassEditorDvars()
{
	if( level.progressiveUnlocks )
	{
		self openDefaultItems();
	}
	else
	{
		self endon( "disconnect" );
		
		dvarKeys = getArrayKeys( level.serverDvars );
		for( index = 0; index < dvarKeys.size; index++ )
		{
			// open everything according to admin preferences
			if( isSubStr( dvarKeys[index], "_allow_" ) )
				self setClientDvar( dvarKeys[index], level.serverDvars[dvarKeys[index]] );	
				
			wait( 0.05 );
		}
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	
	for( ;; )
	{
		self waittill( "spawned_player" );
		
		self setClientVal();
	}
}

// set the client Val onPlayerSpawned in case the player gets disconnected and 
// has to come back a second time in order to complete the process.
setClientVal()
{	
	// check if the player has passed through before and return if they have
	if( self hasPassedBefore() ) return; 
		
	// set the config edit dvar value incremented by 1 into player's record to tell us if they have passed through before or not
	self setStat( 3152, level.configedit + 1 );
}

// called from onPlayerConnected
init_DefaultClasses()
{
	// return if the player has passed through before
	if( self hasPassedBefore() ) return;
	
	// reset the CAC classes to default settings
	self setDefaultClasses();
	self thread setDefaultClassNames();
}

// method to check for client val being set higher than config edit value
hasPassedBefore()
{
	// 3152 is the stat number which stores the config edit dvar value
	if( self GetStat( 3152 ) > level.configedit )
		return true;
		
	return false;
}

// this sets the 3 extra class names each and every time the player connects because a player can't name the classes 
// without those names getting lost after they disconnect (there are only 5 custom class dvars in the engine)
SetExtraClassName()
{
	if( self hasPassedBefore() )
	{
		count = 5;	
		for( i=5; i < 8; i++ )
		{
			count++;
			primary_num = self getstat( 320+(i*10)+1 );
			primary_refname = "@"+tableLookup( "mp/statsTable.csv", 0, primary_num, 3 );
			self setClientDvar( "customclass"+count, primary_refname );
		}		
	}
}

// this sets the default class names either for first time players or on class resets
setDefaultClassNames()
{
	count = 0;
	for( i = 0; i < 8; i ++ )
	{
		count++;
		primary_num = self getstat( 320+(i*10)+1 );
		primary_refname = "@"+tableLookup( "mp/statsTable.csv", 0, primary_num, 3 );
		self setClientDvar( "customclass"+count, primary_refname );
	}
}

// SET THE DEFAULT CLASSES
setDefaultClasses()
{
	// wait - otherwise we will incurr a server command overflow
	wait( 1.5 );
		
	// ReSet all the Create-a-Class records to a stock loadout
	for( i = 0; i < 8; i ++ )
	{		
		//Primary Grenade
		self setStat( 320+(i*10)+0, 100 ); // Default to frag
		
		//Primary Weapon
		self setStat( 320+(i*10)+1, getWeapon( i ) );
		//Primary Attachments
		self setStat( 320+(i*10)+2, 0 );
		//Secondary Weapon
		self setStat( 320+(i*10)+3, getPistol() );
		//Secondary Attachments
		self setStat( 320+(i*10)+4, 0 );
	
		//Perks "specialty_null"
		self setStat( 320+(i*10)+5, 190 ); 
		self setStat( 320+(i*10)+6, 190 ); 
		self setStat( 320+(i*10)+7, 190 ); 
	
		//Secondary Grenades
		self setStat( 320+(i*10)+8, 101 ); //Default to smoke
		
		//Camo
		self setStat( 320+(i*10)+9, 0 );
	}
}

// get the weapon stat derived from the default weapon dvars
getWeapon( count )
{
	stat = 0;
	switch( count )
	{
		case 0: stat = getWeaponStat( level.default_class0 ); break;
		case 1: stat = getWeaponStat( level.default_class1 ); break;
		case 2: stat = getWeaponStat( level.default_class2 ); break;
		case 3: stat = getWeaponStat( level.default_class3 ); break;
		case 4: stat = getWeaponStat( level.default_class4 ); break;
		case 5: stat = getWeaponStat( level.default_class5 ); break;
		case 6: stat = getWeaponStat( level.default_class6 ); break;
		case 7: stat = getWeaponStat( level.default_class7 ); break;
	}
	
	return( stat );
}

// generate a random pistol stat from the server dvar array (only allowed pistols will be selected)
getPistol()
{
	pistolStat = 0;
	array = [];
	
	pistol = [];
	pistol[0] = "beretta";
	pistol[1] = "usp";
	if( !level.progressiveUnlocks )
	{
		pistol[2] = "colt45";
		pistol[3] = "deserteagle";
		pistol[4] = "deserteaglegold";
	}

	for( index=0; index < pistol.size; index++ )
	{
		if( !level.serverDvars[ "weap_allow_" + pistol[index] ] )
			continue;
		
		array[array.size] = pistol[index];
	}
	
	weapon = array[ randomint( array.size ) ];
	
	pistolStat = getWeaponStat( weapon );
	
	return( pistolStat );
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////// PROGRESSIVE UNLOCKS /////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

openDefaultItems()
{
	self endon( "disconnect" );
	
	dvarKeys = getArrayKeys( level.serverDvars );
	for( index = 0; index < dvarKeys.size; index++ )
	{
		// close all items first
		self setClientDvar( dvarKeys[index], 0 );
			
		// Now, open default items only according to admin preferences - weapons first 
		if( isSubStr( dvarKeys[index], "weap_allow_" ) )
		{			
			defaultweap = strTok( level.defaultWeapons, ";" );
			for( i=0; i < defaultweap.size; i++ )
				if( isSubStr( dvarKeys[index], defaultweap[i] ) )
					self setClientDvar( dvarKeys[index], level.serverDvars[dvarKeys[index]] );
		}
			
		// open the default perks according to admin preferences
		if( isSubStr( dvarKeys[index], "perk_allow_" ) )
		{
			defaultperk = strTok( level.defaultPerks, ";" );
			for( i=0; i < defaultperk.size; i++ )
				if( isSubStr( dvarKeys[index], defaultperk[i] ) )
					self setClientDvar( dvarKeys[index], level.serverDvars[dvarKeys[index]] );
		}
			
		// open the default attachments according to admin preferences
		if( isSubStr( dvarKeys[index], "attachment_allow_" ) )
		{
			defaultattachment = strTok( level.defaultAttachments, ";" );
			for( i=0; i < defaultattachment.size; i++ )
				if( isSubStr( dvarKeys[index], defaultattachment[i] ) )
					self setClientDvar( dvarKeys[index], level.serverDvars[dvarKeys[index]] );
		}
			
		// open the default camos according to admin preferences
		if( isSubStr( dvarKeys[index], "camo_allow_" ) )
		{
			defaultcamo = strTok( level.defaultCamos, ";" );
			for( i=0; i < defaultcamo.size; i++ )
				if( isSubStr( dvarKeys[index], defaultcamo[i] ) )
					self setClientDvar( dvarKeys[index], level.serverDvars[dvarKeys[index]] );
		}
		
		wait( 0.05 );
	}
	
	self thread unlockChallengItems();
	self thread checkItemsforRank();
}

// unlock the weapon items according to the players progress
unlockChallengItems()
{	
	self endon( "disconnect" );
	
	tableName = "mp/challenge_unlocks.csv";
	
	for( index = 0; index < level.baseWeaponName.size; index++ )
	{
		weaponName = level.baseWeaponName[index];
		
		//============= ATTACHMENTS ==================
		
		attachStat = int( tableLookup( tableName, 1, weaponName, 2 ) );
		if( !isDefined( attachStat ) )
			continue;
		
		attachments = tableLookup( tableName, 1, weaponName, 4 );
		if( !isdefined( attachments ) || attachments == "" )
			continue;
		
		attachment_maxVals	= tableLookup( tableName, 1, weaponName, 3 );
		if( !isdefined( attachment_maxVals ) || attachment_maxVals == "" )
			continue;
			
		attachment_tokens = strtok( attachments, " " );
		attachment_maxval_tokens = strtok( attachment_maxVals, " " );
			
		if( attachment_tokens.size == 0 && attachment_maxval_tokens.size == 0 )
		{
			if( self getStat( attachStat ) >= int( attachment_maxval_tokens ) )
				self.challengeAttachments[ weaponName ][ attachment_tokens ] = 1;
		}
		else
		{
			for( k = 0; k < attachment_tokens.size; k++ )
			{
				if( self getStat( attachStat ) >= int( attachment_maxval_tokens[k] ) )
					self.challengeAttachments[ weaponName ][ attachment_tokens[k] ] = 1;
			}
		}
		
		//============================================
		
		//================== CAMOS ===================
		
		camoStat = int( tableLookup( tableName, 1, weaponName, 5 ) );
		if( !isDefined( camoStat ) )
			continue;
		
		camos = tableLookup( tableName, 1, weaponName, 7 );
		if( !isdefined( camos ) || camos == "" )
			continue;
		
		camo_maxVals	= tableLookup( tableName, 1, weaponName, 6 );
		if( !isdefined( camo_maxVals ) || camo_maxVals == "" )
			continue;
			
		camo_tokens = strtok( camos, " " );
		camo_maxval_tokens = strtok( camo_maxVals, " " );
			
		if( camo_tokens.size == 0 && camo_maxval_tokens.size == 0 )
		{
			if( self getStat( camoStat ) >= int( camo_maxval_tokens ) )
				self.challengeCamos[weaponName][ camo_tokens ] = 1;
		}
		else
		{
			for( k = 0; k < camo_tokens.size; k++ )
			{
				if( self getStat( camoStat ) >= int( camo_maxval_tokens[k] ) )
					self.challengeCamos[weaponName][ camo_tokens[k] ] = 1;
			}
		}
		
		//============================================
	}
}

// Scroll through each line of rankTable.csv and end at player's rank.
// Any item to be unlocked will have it's dvar switched on.
checkItemsforRank()
{
	for( idx = 0; idx <= self.pers["rank"]; idx++ )
	{
		// search by index number and not player's rank. Otherwise it will only find items at 
		// player's rank and none before it.

		// unlock weapon =======
		unlockedWeapon = self maps\mp\gametypes\_rank::getRankInfoUnlockWeapon( idx );	// unlockedweapon is weapon reference string
		if ( isDefined( unlockedWeapon ) && unlockedWeapon != "" )
			self unlockWeapon( unlockedWeapon );
	
		// unlock perk ==========
		unlockedPerk = self maps\mp\gametypes\_rank::getRankInfoUnlockPerk( idx );	// unlockedweapon is weapon reference string
		if ( isDefined( unlockedPerk ) && unlockedPerk != "" )
			self unlockPerk( unlockedPerk );

		// unlock attachment ====
		unlockedAttachment = self maps\mp\gametypes\_rank::getRankInfoUnlockAttachment( idx );	// ex: ak47 gl
		if( isDefined( unlockedAttachment ) && unlockedAttachment != "" )
			self unlockAttachment( unlockedAttachment );
	}
}

unlockWeapon( weapon )
{
	if( !level.progressiveUnlocks ) return;
	
	self setClientDvar( "weap_allow_" + weapon, level.serverDvars["weap_allow_" + weapon] );
}

unlockPerk( perk )
{
	if( !level.progressiveUnlocks ) return;
	
	self setClientDvar( "perk_allow_" + perk, level.serverDvars["perk_allow_" + perk] );
}

unlockAttachment( unlockedAttachment )
{
	if( !level.progressiveUnlocks ) return;

	// break down the unlockedAttachment string into element parts
	attachment = StrTok( unlockedAttachment, " " );
	weapRef = attachment[0];
	unlockedAttach = attachment[1];
			
	// set the player's attachment flag to 1 so that the attachment check 
	// in _caceditor will turn on the attachment
	self.challengeAttachments[weapRef][ unlockedAttach ] = 1;
}

unlockGoldCamo( weaponName )
{
	if( !level.progressiveUnlocks ) return;
	
	self.challengeCamos[weaponName][ "camo_gold" ] = 1;
}

///////////////////////////////////////////////////////////////////////////////////
///////////////////////// END PROGRESSIVE UNLOCKS /////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

/*-----------------------------------------------------------------------------------------------------
	Ravir's cvardef for COD1, with modifications by Bell and Number7
	Revised for COD4/5 by Tally
-------------------------------------------------------------------------------------------------------*/
dvardef( varname, vardefault, min, max, type )
{
	originalVar = varname;
	
	if( isDefined( level.script ) )
		mapname = level.script;
	else
		mapname = toLower( getdvar("mapname") );

	if( isDefined( level.gametype ) )
		gametype = level.gametype;
	else
		gametype = getdvar( "g_gametype" );

	both = gametype + "_" + mapname;

	tempvar = varname + "_" + gametype;
	if( getdvar( tempvar ) != "" )
		varname = tempvar;

	tempvar = varname + "_" + mapname;
	if( getdvar( tempvar ) != ""  )
		varname = tempvar;

	tempvar = varname + "_" + both;
	if( getdvar( tempvar ) != "" )
		varname = tempvar;

	switch( type )
	{	
		case "float":
			if( getdvar( varname ) == "" )
				definition = vardefault;
			else
				definition = getdvarfloat( varname );
			break;
			
		case "string":
			if( getdvar( varname ) == "" )
				definition = vardefault;
			else
				definition = getdvar( varname );
			break;

		case "int":
		default:
			if( getdvar( varname ) == "" )
				definition = vardefault;
			else
				definition = getdvarint( varname );
			break;
	}

	if( ( type == "int" || type == "float" ) && definition < min )
		definition = min;

	if( ( type == "int" || type == "float" ) && definition > max )
		definition = max;
	
	// set all server dvars for all types of vars
	setDvar( originalVar, definition );
	
	// build the client dvar arrays based on integers only
	if( type == "int" )
	{
		level.serverDvars[originalVar] = definition;
	}

	return( definition );
}


