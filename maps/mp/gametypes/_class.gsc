#include common_scripts\utility;
// check if below includes are removable
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include openwarfare\_utils;

init()
{
	
	level.classMap["custom1"] = "CLASS_CUSTOM1";
	level.classMap["custom2"] = "CLASS_CUSTOM2";
	level.classMap["custom3"] = "CLASS_CUSTOM3";
	level.classMap["custom4"] = "CLASS_CUSTOM4";
	level.classMap["custom5"] = "CLASS_CUSTOM5";
	level.classMap["custom6"] = "CLASS_CUSTOM6";
	level.classMap["custom7"] = "CLASS_CUSTOM7";
	level.classMap["custom8"] = "CLASS_CUSTOM8";
	
	if( level.onlineGame )
		level.defaultClass = "CLASS_ASSAULT";
	
	level.weapons["frag"] = "frag_grenade_mp";
	level.weapons["smoke"] = "smoke_grenade_mp";
	level.weapons["flash"] = "flash_grenade_mp";
	level.weapons["concussion"] = "concussion_grenade_mp";
	level.weapons["nervegas"] = "nervegas_grenade_mp";
	level.weapons["c4"] = "c4_mp";
	level.weapons["claymore"] = "claymore_mp";
	level.weapons["rpg"] = "rpg_mp";
	
	// initializes create a class settings
	cac_init();	
		
	// generating weapon type arrays which classifies the weapon as primary (back stow), pistol, or inventory (side pack stow)
	// using mp/statstable.csv's weapon grouping data ( numbering 0 - 149 )
	level.primary_weapon_array = [];
	level.side_arm_array = [];
	level.grenade_array = [];
	level.inventory_array = [];
	level.candidate_array = [];
	
	max_weapon_num = 149;
	for( i = 0; i < max_weapon_num; i++ )
	{
		weapon = tableLookup( "mp/statsTable.csv", 0, i, 4 );
		if ( !isDefined( weapon ) || weapon == "" )
			continue;
		
		level.candidate_array[level.candidate_array.size] = weapon;
		
		weapon_type = tableLookup( "mp/statsTable.csv", 0, i, 2 );
		attachment = tableLookup( "mp/statsTable.csv", 0, i, 8 );
		
		weapon_class_register( weapon+"_mp", weapon_type );	
		
		if( isdefined( attachment ) && attachment != "" )
		{			
			attachment_tokens = strtok( attachment, " " );
			if( isdefined( attachment_tokens ) )
			{
				if( attachment_tokens.size == 0 )
					weapon_class_register( weapon+"_"+attachment+"_mp", weapon_type );	
				else
				{
					// multiple attachment options
					for( k = 0; k < attachment_tokens.size; k++ )
						weapon_class_register( weapon+"_"+attachment_tokens[k]+"_mp", weapon_type );
				}
			}
		}
	}
	
	precacheShader( "waypoint_bombsquad" );

	level thread onPlayerConnecting();
}

weapon_class_register( weapon, weapon_type )
{
	if( isSubstr( "weapon_smg weapon_assault weapon_sniper weapon_shotgun weapon_lmg", weapon_type ) )
		level.primary_weapon_array[weapon] = weapon_type;
	else if( weapon_type == "weapon_pistol" )
		level.side_arm_array[weapon] = 1;
	else if( weapon_type == "weapon_grenade" )
		level.grenade_array[weapon] = 1;
	else if( weapon_type == "weapon_explosive" || weapon_type == "weapon_projectile" )
		level.inventory_array[weapon] = 1;
	else
		assertex( false, "Weapon group info is missing from statsTable for: " + weapon_type );
}

// create a class init
cac_init()
{
	// generating camo data vars collected from attachmentTable.csv
	level.tbl_CamoSkin = [];
	level.camoReferenceToIndex = [];
	level.attachmentReferenceToIndex = [];
	for( i=0; i < 8; i++ )
	{
		level.tbl_CamoSkin[i]["bitmask"] = int( tableLookup( "mp/attachmentTable.csv", 11, i, 10 ) );
		level.tbl_CamoSkin[i]["name"] = tableLookup( "mp/attachmentTable.csv", 11, i, 4 ); // Tally: added an array for checkable camo names
		level.camoReferenceToIndex[ level.tbl_CamoSkin[i]["name"] ] = i;
		
		level.tbl_WeaponAttachment[i]["bitmask"] = int( tableLookup( "mp/attachmentTable.csv", 9, i, 10 ) );
		level.tbl_WeaponAttachment[i]["reference"] = tableLookup( "mp/attachmentTable.csv", 9, i, 4 );
		level.attachmentReferenceToIndex[ level.tbl_WeaponAttachment[i]["reference"] ] = i; // Tally: added an array for checkable use elsewhere
	}
	
	level.tbl_weaponIDs = [];
	level.weaponReferenceToIndex = [];
	for( i=0; i < 150; i++ )
	{
		reference_s = tableLookup( "mp/statsTable.csv", 0, i, 4 );
		if( reference_s != "" )
		{ 
			level.tbl_weaponIDs[i]["reference"] = reference_s;
			level.tbl_weaponIDs[i]["group"] = tablelookup( "mp/statstable.csv", 0, i, 2 );
			level.tbl_weaponIDs[i]["count"] = int( tablelookup( "mp/statstable.csv", 0, i, 5 ) );
			level.tbl_weaponIDs[i]["attachment"] = tablelookup( "mp/statstable.csv", 0, i, 8 );	
			
			level.weaponReferenceToIndex[ level.tbl_weaponIDs[i]["reference"] ] = i; // Tally: created a level array to find a weapon's stat number generated from the weapon's reference/name
		}
		else
			continue;
	}
	
	// generating perk data vars collected form statsTable.csv
	level.perkNames = [];
	level.perkIcons = [];
	level.PerkData = [];
	level.perkReferenceToIndex = [];
	for( i=150; i < 194; i++ )
	{
		reference_s = tableLookup( "mp/statsTable.csv", 0, i, 4 );
		if( reference_s != "" )
		{
			level.tbl_PerkData[i]["reference"] = reference_s;
			level.tbl_PerkData[i]["reference_full"] = tableLookup( "mp/statsTable.csv", 0, i, 6 );
			level.tbl_PerkData[i]["count"] = int( tableLookup( "mp/statsTable.csv", 0, i, 5 ) );
			level.tbl_PerkData[i]["group"] = tableLookup( "mp/statsTable.csv", 0, i, 2 );
			level.tbl_PerkData[i]["name"] = tableLookupIString( "mp/statsTable.csv", 0, i, 3 );
			precacheString( level.tbl_PerkData[i]["name"] );
			level.tbl_PerkData[i]["perk_num"] = tableLookup( "mp/statsTable.csv", 0, i, 8 );
			
			// stat number added to specialty name
			level.perkReferenceToIndex[ level.tbl_PerkData[i]["reference_full"] ] = i; // Tally: turned this into a level array for use elsewhere
			
			level.perkNames[level.tbl_PerkData[i]["reference_full"]] = level.tbl_PerkData[i]["name"];
			level.perkIcons[level.tbl_PerkData[i]["reference_full"]] = level.tbl_PerkData[i]["reference_full"];
			precacheShader( level.perkIcons[level.tbl_PerkData[i]["reference_full"]] );
		}
		else
			continue;
	}
	
	//=========== Special Handling of Inventory Items for Class Editor ===============
	
	// these stat numbers need to be added separately as they go by inventory name and not speciatly name.
	level.perkReferenceToIndex[ "c4_mp" ] = 184;
	level.perkReferenceToIndex[ "claymore_mp"] = 185;
	level.perkReferenceToIndex[ "rpg_mp"] = 186;

	// stat number to full inventory name
	level.tbl_PerkData[184]["reference_full"] = "c4_mp";
	level.tbl_PerkData[185]["reference_full"] = "claymore_mp";
	level.tbl_PerkData[186]["reference_full"] = "rpg_mp";
	
	perkIcons = [];
	
	level.perkIcons[ "c4_mp" ] = tableLookup( "mp/statsTable.csv", 4, "c4_mp", 6 );
	perkIcons[perkIcons.size] = level.perkIcons[ "c4_mp" ];
	level.perkIcons[ "claymore_mp" ] = tableLookup( "mp/statsTable.csv", 4, "claymore_mp", 6 );
	perkIcons[perkIcons.size] = level.perkIcons[ "claymore_mp" ];
	level.perkIcons[ "rpg_mp" ] = tableLookup( "mp/statsTable.csv", 4, "rpg_mp", 6 );
	perkIcons[perkIcons.size] = level.perkIcons[ "rpg_mp" ];
	
	for( i=0; i < perkIcons.size; i++ )
		precacheShader( perkIcons[i] );
	
	perkNames = [];
	
	level.perkNames[ "c4_mp" ] = tableLookupIString( "mp/statsTable.csv", 4, "c4_mp", 3 );
	perkNames[perkNames.size] = level.perkNames[ "c4_mp" ];
	level.perkNames[ "claymore_mp" ] = tableLookupIString( "mp/statsTable.csv", 4, "claymore_mp", 3 );
	perkNames[perkNames.size] = level.perkNames[ "claymore_mp" ];
	level.perkNames[ "rpg_mp" ] = tableLookupIString( "mp/statsTable.csv", 4, "rpg_mp", 3 );
	perkNames[perkNames.size] = level.perkNames[ "rpg_mp" ];
	
	for( i=0; i < perkNames.size; i++ )
		precacheString( perkNames[i] );
		
	//==================================================================================
	
	
	// allowed perks in each slot, for validation.
	level.allowedPerks[0] = [];
	level.allowedPerks[1] = [];
	level.allowedPerks[2] = [];
	
	level.allowedPerks[0][ 0] = 190; // 190 through 193 are attachments and "none"
	level.allowedPerks[0][ 1] = 191;
	level.allowedPerks[0][ 2] = 192;
	level.allowedPerks[0][ 3] = 193;
	level.allowedPerks[0][ 4] = level.perkReferenceToIndex[ "specialty_weapon_c4" ];
	level.allowedPerks[0][ 5] = level.perkReferenceToIndex[ "specialty_specialgrenade" ];
	level.allowedPerks[0][ 6] = level.perkReferenceToIndex[ "specialty_weapon_rpg" ];
	level.allowedPerks[0][ 7] = level.perkReferenceToIndex[ "specialty_weapon_claymore" ];
	level.allowedPerks[0][ 8] = level.perkReferenceToIndex[ "specialty_fraggrenade" ];
	level.allowedPerks[0][ 9] = level.perkReferenceToIndex[ "specialty_extraammo" ];
	level.allowedPerks[0][10] = level.perkReferenceToIndex[ "specialty_detectexplosive" ];
	
	level.allowedPerks[1][ 0] = 190;
	level.allowedPerks[1][ 1] = level.perkReferenceToIndex[ "specialty_bulletdamage" ];
	level.allowedPerks[1][ 2] = level.perkReferenceToIndex[ "specialty_armorvest" ];
	level.allowedPerks[1][ 3] = level.perkReferenceToIndex[ "specialty_fastreload" ];
	level.allowedPerks[1][ 4] = level.perkReferenceToIndex[ "specialty_rof" ];
	level.allowedPerks[1][ 5] = level.perkReferenceToIndex[ "specialty_twoprimaries" ];
	level.allowedPerks[1][ 6] = level.perkReferenceToIndex[ "specialty_gpsjammer" ];
	level.allowedPerks[1][ 7] = level.perkReferenceToIndex[ "specialty_explosivedamage" ];
	
	level.allowedPerks[2][ 0] = 190;
	level.allowedPerks[2][ 1] = level.perkReferenceToIndex[ "specialty_longersprint" ];
	level.allowedPerks[2][ 2] = level.perkReferenceToIndex[ "specialty_bulletaccuracy" ];
	level.allowedPerks[2][ 3] = level.perkReferenceToIndex[ "specialty_pistoldeath" ];
	level.allowedPerks[2][ 4] = level.perkReferenceToIndex[ "specialty_grenadepulldeath" ];
	level.allowedPerks[2][ 5] = level.perkReferenceToIndex[ "specialty_bulletpenetration" ];
	level.allowedPerks[2][ 6] = level.perkReferenceToIndex[ "specialty_holdbreath" ];
	level.allowedPerks[2][ 7] = level.perkReferenceToIndex[ "specialty_quieter" ];
	level.allowedPerks[2][ 8] = level.perkReferenceToIndex[ "specialty_parabolic" ];
}

getClassChoice( response )
{
	tokens = strtok( response, "," );
	
	assert( isDefined( level.classMap[tokens[0]] ) );
	
	return( level.classMap[tokens[0]] );
}

getWeaponChoice( response )
{
	tokens = strtok( response, "," );
	if ( tokens.size > 1 )
		return int( tokens[1] );
	else
		return 0;
}

// ============================================================================
// obtains custom class setup from stat values
cac_getdata()
{
	if ( isDefined( self.cac_initialized ) )
		return;
	
	for( i = 0; i < 8; i ++ )
	{
		primary_grenade = self getstat( 320+(i*10)+0 );
		primary_num = self getstat( 320+(i*10)+1 );
		primary_attachment_flag = self getstat( 320+(i*10)+2 );
		
		// Player primary attachment Record for each class
		self.custom_class[i]["primary_attachment"] = primary_attachment_flag;
		
		if( !isDefined( level.tbl_WeaponAttachment[primary_attachment_flag] ) )
			primary_attachment_flag = 0;
			
		secondary_num = self getstat( 320+(i*10)+3 );
		secondary_attachment_flag = self getstat( 320+(i*10)+4 );
		
		// Player secondary attachment Record for each class
		self.custom_class[i]["secondary_attachment"] = secondary_attachment_flag;
		
		if ( !isDefined( level.tbl_WeaponAttachment[secondary_attachment_flag] ) )
			secondary_attachment_flag = 0;
		secondary_attachment_mask = level.tbl_WeaponAttachment[secondary_attachment_flag]["bitmask"];
		
		specialty1 = self getstat( 320+(i*10)+5 );
		specialty2 = self getstat( 320+(i*10)+6 );
		specialty3 = self getstat( 320+(i*10)+7 ); 
		special_grenade = self getstat ( 320+(i*10)+8 );
		
		camo_num = self getstat( 320+(i*10)+9 );
		
		if( camo_num < 0 || camo_num >= level.tbl_CamoSkin.size )
		{
			println( "^1Warning: (" + self.name + ") camo " + camo_num + " is invalid. Setting to none." );
			camo_num = 0;
		}

		// apply the primary grenade details
		if ( primary_grenade < 100 )
		{
			iprintln( "^1Warning: (" + self.name + ") primary grenade " + primary_grenade + " is invalid. Setting to frag." );
			primary_grenade = 100;
		}

		// builds the full primary grenade reference string
		self.custom_class[i]["primary_grenades"] = level.tbl_weaponIDs[primary_grenade]["reference"]+"_mp";
		self.custom_class[i]["primary_grenades_count"] = 1;
		
		m16WeaponIndex = 25;
		assert( level.tbl_weaponIDs[m16WeaponIndex]["reference"] == "m16" );
		if( primary_num < 0 || !isDefined( level.tbl_weaponIDs[ primary_num ] ) )
		{
			primary_num = m16WeaponIndex;
			primary_attachment_flag = 0;
		}
		if( secondary_num < 0 || !isDefined( level.tbl_weaponIDs[ secondary_num ] ) )
		{
			secondary_num = 0;
			secondary_attachment_flag = 0;
		}
		
		specialty1 = validatePerk( specialty1, 0 );
		specialty2 = validatePerk( specialty2, 1 );
		specialty3 = validatePerk( specialty3, 2 );
		
		// if specialty2 is not Overkill, disallow anything besides pistols for secondary weapon
		if( level.tbl_PerkData[specialty2]["reference_full"] != "specialty_twoprimaries" )
		{
			if( level.tbl_weaponIDs[secondary_num]["group"] != "weapon_pistol" )
			{
				println( "^1Warning: (" + self.name + ") secondary weapon is not a pistol but perk 2 is not Overkill. Setting secondary weapon to pistol." );
				
				// Tally - since I've moved the beretta to stat number 8, this needs fixing:
				secondary_num = 8;
				
				// set their secondary attachment to none:
				secondary_attachment_flag = 0;
			}
		}
		
		// if certain attachments are used, make sure specialty1 is set right
		primary_attachment_ref = level.tbl_WeaponAttachment[primary_attachment_flag]["reference"];
		secondary_attachment_ref = level.tbl_WeaponAttachment[secondary_attachment_flag]["reference"];
		
		// validate weapon attachments, if faulty attachement found, reset to no attachments
		primary_ref = level.tbl_WeaponIDs[primary_num]["reference"];
		primary_attachment_set = level.tbl_weaponIDs[primary_num]["attachment"];
		secondary_ref = level.tbl_WeaponIDs[secondary_num]["reference"];
		secondary_attachment_set = level.tbl_weaponIDs[secondary_num]["attachment"];
		if( !issubstr( primary_attachment_set, primary_attachment_ref ) )
		{
			println( "^1Warning: (" + self.name + ") attachment [" + primary_attachment_ref + "] is not valid for [" + primary_ref + "]. Removing attachment." );
			primary_attachment_flag = 0;
		}
		if ( !issubstr( secondary_attachment_set, secondary_attachment_ref ) )
		{
			println( "^1Warning: (" + self.name + ") attachment [" + secondary_attachment_ref + "] is not valid for [" + secondary_ref + "]. Removing attachment." );
			secondary_attachment_flag = 0;
		}
		
		// validate special grenade type
		flashGrenadeIndex = 101;
		assert( level.tbl_weaponIDs[flashGrenadeIndex]["reference"] == "flash_grenade" ); // if this fails we need to change flashGrenadeIndex
		if ( !isDefined( level.tbl_weaponIDs[special_grenade] ) )
			special_grenade = flashGrenadeIndex;
		specialGrenadeType = level.tbl_weaponIDs[special_grenade]["reference"];
		if( specialGrenadeType != "flash_grenade" && specialGrenadeType != "smoke_grenade" )
		{
			println( "^1Warning: (" + self.name + ") special grenade " + special_grenade + " is invalid. Setting to flash grenade." );
			special_grenade = flashGrenadeIndex;
		}
		
		if( specialGrenadeType == "smoke_grenade" && level.tbl_PerkData[specialty1]["reference_full"] == "specialty_specialgrenade" )
		{
			println( "^1Warning: (" + self.name + ") smoke grenade may not be used with extra special grenades. Setting to flash grenade." );
			special_grenade = flashGrenadeIndex;
		}
		
		// apply attachment to primary weapon, getting weapon reference strings
		attachment_string = level.tbl_WeaponAttachment[primary_attachment_flag]["reference"];
		if( primary_attachment_flag != 0 && attachment_string != "" )
			self.custom_class[i]["primary"] = level.tbl_weaponIDs[primary_num]["reference"]+"_" + attachment_string + "_mp";
		else
			self.custom_class[i]["primary"] = level.tbl_weaponIDs[primary_num]["reference"]+"_mp";
		
		// apply attachment to secondary weapon, getting weapon reference strings
		attachment_string = level.tbl_WeaponAttachment[secondary_attachment_flag]["reference"];
		if( secondary_attachment_flag != 0 && attachment_string != "" )
			self.custom_class[i]["secondary"] = level.tbl_weaponIDs[secondary_num]["reference"] + "_" + attachment_string + "_mp"; 
		else
			self.custom_class[i]["secondary"] = level.tbl_weaponIDs[secondary_num]["reference"]+"_mp";
		
		// obtaining specialties, getting specialty reference strings
		assertex( isdefined( level.tbl_PerkData[specialty1] ), "Specialty #:"+specialty1+"'s data is undefined" );
		self.custom_class[i]["specialty1"] = level.tbl_PerkData[specialty1]["reference_full"]; 
		self.custom_class[i]["specialty1_weaponref"] = level.tbl_PerkData[specialty1]["reference"]; 
		self.custom_class[i]["specialty1_count"] = level.tbl_PerkData[specialty1]["count"]; 
		self.custom_class[i]["specialty1_group"] = level.tbl_PerkData[specialty1]["group"]; 
		
		self.custom_class[i]["specialty2"] = level.tbl_PerkData[specialty2]["reference"]; 
		self.custom_class[i]["specialty2_weaponref"] = self.custom_class[i]["specialty2"];
		self.custom_class[i]["specialty2_count"] = level.tbl_PerkData[specialty2]["count"]; 
		self.custom_class[i]["specialty2_group"] = level.tbl_PerkData[specialty2]["group"]; 
		
		self.custom_class[i]["specialty3"] = level.tbl_PerkData[specialty3]["reference"]; 
		self.custom_class[i]["specialty3_weaponref"] = self.custom_class[i]["specialty3"];
		self.custom_class[i]["specialty3_count"] = level.tbl_PerkData[specialty3]["count"];
		self.custom_class[i]["specialty3_group"] = level.tbl_PerkData[specialty3]["group"]; 
		
		// builds the full special grenade reference string
		self.custom_class[i]["special_grenade"] = level.tbl_weaponIDs[special_grenade]["reference"]+"_mp"; 
		self.custom_class[i]["special_grenade_count"] = level.tbl_weaponIDs[special_grenade]["count"]; 
		
		// camo selection, default 0 = no camo skin
		self.custom_class[i]["camo_num"] = camo_num;		

		self.cac_initialized = true;
	}
}

validatePerk( perkIndex, perkSlotIndex )
{
	for ( i = 0; i < level.allowedPerks[ perkSlotIndex ].size; i++ )
	{
		if ( perkIndex == level.allowedPerks[ perkSlotIndex ][i] )
			return perkIndex;
	}
	println( "^1Warning: (" + self.name + ") Perk " + level.tbl_PerkData[perkIndex]["reference_full"] + " is not allowed for perk slot index " + perkSlotIndex + "; replacing with no perk" );
	return 190;
}


logClassChoice( class, primaryWeapon, specialType, perks )
{
	if ( class == self.lastClass )
		return;

	self logstring( "choseclass: " + class + " weapon: " + primaryWeapon + " special: " + specialType );		
	for( i=0; i<perks.size; i++ )
		self logstring( "perk" + i + ": " + perks[i] );
	
	self.lastClass = class;
}

// distributes the specialties into the corrent slots; inventory, grenades, special grenades, generic specialties
get_specialtydata( class_num, specialty )
{
	cac_reference = self.custom_class[class_num][specialty];
	cac_weaponref = self.custom_class[class_num][specialty+"_weaponref"];	// for inventory whos string ref is the weapon ref
	cac_group = self.custom_class[class_num][specialty+"_group"];
	cac_count = self.custom_class[class_num][specialty+"_count"];
	
	class = getPlayerCustomClass( self.custom_class[class_num]["primary"] );
		
	assertex( isdefined( cac_group ), "Missing "+specialty+"'s group name" );

	if( specialty == "specialty1" )
		self.specialty[0] = cac_reference;
	if( specialty == "specialty2" )
		self.specialty[1]  = cac_reference;
	if( specialty == "specialty3" )
		self.specialty[2]  = cac_reference;
	
	// grenade classification and distribution ==================
	if( specialty == "specialty1" )
	{
		if( isSubstr( cac_group, "grenade" ) )
		{
			// if user selected 3 frags, then give 3 count, else always give 1
			if( cac_reference == "specialty_fraggrenade" )
			{
				self.custom_class[class_num]["grenades"] = self.custom_class[class_num]["primary_grenades"];
				self.custom_class[class_num]["grenades_count"] += level.specialty_fraggrenade_ammo_count;
			}
			else
			{
				self.custom_class[class_num]["grenades"] = self.custom_class[class_num]["primary_grenades"];
				self.custom_class[class_num]["grenades_count"] = game["loadout_" + class + "_frags"];
			}
			
			// if user selected 3 special grenades, then give 3 count to the selected special grenade type, else always give 1
			assertex( isdefined( self.custom_class[class_num]["special_grenade"] ) && isdefined( self.custom_class[class_num]["special_grenade_count"] ), "Special grenade missing from custom class loadout" );
			if( cac_reference == "specialty_specialgrenade" )
			{
				self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
				self.custom_class[class_num]["specialgrenades_count"] += level.specialty_specialgrenade_ammo_count;
			}
			else
			{
				self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
				self.custom_class[class_num]["specialgrenades_count"] = game["loadout_" + class + "_special"];
			}
			return;
		}
		else
		{
			assertex( isdefined( self.custom_class[class_num]["special_grenade"] ), "Special grenade missing from custom class loadout" );
			self.custom_class[class_num]["grenades"] = self.custom_class[class_num]["primary_grenades"];
			self.custom_class[class_num]["grenades_count"] = game["loadout_" + class + "_frags"];
			self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
			self.custom_class[class_num]["specialgrenades_count"] = game["loadout_" + class + "_special"];
		}
	}
			
	// if user selected inventory items
	if( cac_group == "inventory" )
	{
		// inventory distribution to action slot 3 - unique per class
		assertex( isdefined( cac_count ) && isdefined( cac_weaponref ), "Missing "+specialty+"'s reference or count data" );
		self.custom_class[class_num]["inventory"] = cac_weaponref;		// loads inventory into action slot 3
		self.custom_class[class_num]["inventory_count"] = getInventoryCount( self.custom_class[class_num]["inventory"] );	// loads ammo count
	}
	else if( cac_group == "specialty" )
	{
		// building player's specialty, variable size array with size 3 max
		if( self.custom_class[class_num][specialty] != "" )
			self.specialty[self.specialty.size] = self.custom_class[class_num][specialty];
	}

}

getInventoryCount( inventory )
{
	// Control amount of ammo for perk1 explosives
	ammoCount = undefined;
	switch( inventory )
	{
		case "claymore_mp":
			ammoCount = level.inventory_ammo_claymore;
			break;
		case "rpg_mp":
			ammoCount = level.inventory_ammo_rpg;
			break;
		case "c4_mp":
			ammoCount = level.inventory_ammo_c4;
			break;
		default:
			ammoCount = 2;
			break;
	}
	
	return( ammoCount );
}

// clears all player's custom class variables, prepare for update with new stat data
reset_specialty_slots( class_num )
{
	self.specialty = [];		// clear all specialties
	self.custom_class[class_num]["inventory"] = "";
	self.custom_class[class_num]["inventory_count"] = 0;
	self.custom_class[class_num]["inventory_group"] = "";
	self.custom_class[class_num]["grenades"] = ""; 
	self.custom_class[class_num]["grenades_count"] = 0;
	self.custom_class[class_num]["grenades_group"] = "";
	self.custom_class[class_num]["specialgrenades"] = "";
	self.custom_class[class_num]["specialgrenades_count"] = 0;
	self.custom_class[class_num]["specialgrenades_group"] = "";
}

giveLoadout( team, class )
{
	if( openwarfare\_testbots::IsBot( self ) )
	{
		self openwarfare\_testbots::giveLoadout( team );
		return;
	}
	
	self takeAllWeapons();
	
	// initialize specialty array
	self.specialty = [];

	primaryWeapon = undefined;
	
	// gets custom class data from stat bytes
	self cac_getdata();
	
	// obtains the custom class number
	class_num = int( class[class.size-1] )-1;
	self.class_num = class_num;
		
	assertex( isdefined( self.custom_class[class_num]["primary"] ), "Custom class "+class_num+": primary weapon setting missing" );
	assertex( isdefined( self.custom_class[class_num]["secondary"] ), "Custom class "+class_num+": secondary weapon setting missing" );
	assertex( isdefined( self.custom_class[class_num]["specialty1"] ), "Custom class "+class_num+": specialty1 setting missing" );
	assertex( isdefined( self.custom_class[class_num]["specialty2"] ), "Custom class "+class_num+": specialty2 setting missing" );
	assertex( isdefined( self.custom_class[class_num]["specialty3"] ), "Custom class "+class_num+": specialty3 setting missing" );
		
	// clear of specialty slots, repopulate the current selected class' setup
	self reset_specialty_slots( class_num );
	self get_specialtydata( class_num, "specialty1" );
	self get_specialtydata( class_num, "specialty2" );
	self get_specialtydata( class_num, "specialty3" );
		
	// set re-register perks to code
	self register_perks();
	// at this stage, the specialties are loaded into the correct weapon slots, and special slots

		// weapon override for round based gametypes
		// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
		if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
			weapon = self.pers["weapon"];
		else
			weapon = self.custom_class[class_num]["primary"];
		
		sidearm = self.custom_class[class_num]["secondary"];

		self GiveWeapon( sidearm );
		if ( self cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( sidearm );
			
		// give primary weapon
		primaryWeapon = weapon;
		
		assertex( isdefined( self.custom_class[class_num]["camo_num"] ), "Player's camo skin is not defined, it should be at least initialized to 0" );

		primaryTokens = strtok( primaryWeapon, "_" );
		self.pers["primaryWeapon"] = primaryTokens[0];
		
		self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );
		
		self GiveWeapon( weapon, self.custom_class[class_num]["camo_num"] );
		if ( self cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( weapon );
		self setSpawnWeapon( weapon );
		
		if ( level.scr_enable_nightvision )
			self SetActionSlot( 1, "nightvision" );
		
		secondaryWeapon = self.custom_class[class_num]["inventory"];
		if ( secondaryWeapon != "" )
		{
			self GiveWeapon( secondaryWeapon );
			
			self setWeaponAmmoOverall( secondaryWeapon, self.custom_class[class_num]["inventory_count"] );
			
			self thread giveActionSlot3AfterDelay( secondaryWeapon );
			self SetActionSlot( 4, "" );
		}
		else
		{
			self thread giveActionSlot3AfterDelay( "altMode" );
			self SetActionSlot( 4, "" );
		}
		
		// give frag for all no matter what
		grenadeTypePrimary = self.custom_class[class_num]["grenades"]; 
		if ( grenadeTypePrimary != "" )
		{
			grenadeCount = self.custom_class[class_num]["grenades_count"]; 
	
			self GiveWeapon( grenadeTypePrimary );
			self SetWeaponAmmoClip( grenadeTypePrimary, grenadeCount );
			self SwitchToOffhand( grenadeTypePrimary );
		}
		
		// give special grenade
		grenadeTypeSecondary = self.custom_class[class_num]["specialgrenades"]; 
		if ( grenadeTypeSecondary != "" )
		{
			grenadeCount = self.custom_class[class_num]["specialgrenades_count"]; 
	
			if ( grenadeTypeSecondary == level.weapons["flash"])
				self setOffhandSecondaryClass("flash");
			else
				self setOffhandSecondaryClass("smoke");
			
			self giveWeapon( grenadeTypeSecondary );
			self SetWeaponAmmoClip( grenadeTypeSecondary, grenadeCount );
		}
	
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


	// cac specialties that require loop threads
	self cac_selector();
}

// sets the amount of ammo in the gun.
// if the clip maxs out, the rest goes into the stock.
setWeaponAmmoOverall( weaponname, amount )
{
	if ( isWeaponClipOnly( weaponname ) )
	{
		self setWeaponAmmoClip( weaponname, amount );
	}
	else
	{
		self setWeaponAmmoClip( weaponname, amount );
		diff = amount - self getWeaponAmmoClip( weaponname );
		assert( diff >= 0 );
		self setWeaponAmmoStock( weaponname, diff );
	}
}

replenishLoadout() // used by ammo hardpoint.
{
	team = self.pers["team"];
	class = self.pers["class"];

    weaponsList = self GetWeaponsList();
    for( idx = 0; idx < weaponsList.size; idx++ )
    {
		weapon = weaponsList[idx];

		self giveMaxAmmo( weapon );
		self SetWeaponAmmoClip( weapon, 9999 );

		if ( weapon == "claymore_mp" || weapon == "claymore_detonator_mp" )
			self setWeaponAmmoStock( weapon, 2 );
    }
	
	if ( self getAmmoCount( level.classGrenades[class]["primary"]["type"] ) < level.classGrenades[class]["primary"]["count"] )
 		self SetWeaponAmmoClip( level.classGrenades[class]["primary"]["type"], level.classGrenades[class]["primary"]["count"] );

	if ( self getAmmoCount( level.classGrenades[class]["secondary"]["type"] ) < level.classGrenades[class]["secondary"]["count"] )
 		self SetWeaponAmmoClip( level.classGrenades[class]["secondary"]["type"], level.classGrenades[class]["secondary"]["count"] );	
}

onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connecting", player );

		if ( !level.oldschool )
		{
			if ( !isDefined( player.pers["class"] ) )
			{
				player.pers["class"] = "";
			}
			player.class = player.pers["class"];
			player.lastClass = "";
		}
		player.detectExplosives = false;
		player.bombSquadIcons = [];
		player.bombSquadIds = [];	
	}
}


fadeAway( waitDelay, fadeDelay )
{
	wait waitDelay;
	
	self fadeOverTime( fadeDelay );
	self.alpha = 0;
}


setClass( newClass )
{
	self.curClass = newClass;
}


// ============================================================================================
// =======																				=======
// =======						 Create a Class Specialties 							=======
// =======																				=======
// ============================================================================================

initPerkDvars()
{
	level.cac_bulletdamage_data = cac_get_dvar_int( "perk_bulletDamage", "40" );		// increased bullet damage by this %
	level.cac_armorvest_data = cac_get_dvar_int( "perk_armorVest", "75" );				// increased health by this %
	level.cac_explosivedamage_data = cac_get_dvar_int( "perk_explosiveDamage", "25" );	// increased explosive damage by this %
}

// CAC: Selector function, calls the individual cac features according to player's class settings
// Info: Called every time player spawns during loadout stage
cac_selector()
{
	perks = self.specialty;

	self.detectExplosives = false;
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];
		// run scripted perk that thread loops
		if( perk == "specialty_detectexplosive" )
			self.detectExplosives = true;
	}
	
	maps\mp\gametypes\_weapons::setupBombSquad();
}

register_perks()
{
	perks = self.specialty;
	self clearPerks();
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];

		// TO DO: ask code to register the inventory perks and null perk
		// not registering inventory and null perks to code
		if( maps\mp\gametypes\_weapons::isInventory( perk ) || perk == "specialty_null" || isSubStr( perk, "specialty_weapon_" ) )
			continue;
			
		self setPerk( perk );
	}
	
	/#
	maps\mp\gametypes\_dev::giveExtraPerks();
	#/
}


// returns dvar value in int
cac_get_dvar_int( dvar, def )
{
	return int( cac_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
cac_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
		return getdvarfloat( dvar );
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

// CAC: Selected feature check function, returns boolean if a specialty is selected by the current class
// Info: Called on "player" as self, "feature" parameter is a string reference of the specialty in question
cac_hasSpecialty( perk_reference )
{
	return_value = self hasPerk( perk_reference );
	return return_value;
	
	/*
	perks = self.specialty;
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];
		if( perk == perk_reference )
			return true;
	}
	return false;
	*/
}

// CAC: Weapon Specialty: Increased bullet damage feature
// CAC: Weapon Specialty: Armor Vest feature
// CAC: Ability: Increased explosive damage feature
cac_modified_damage( victim, attacker, damage, meansofdeath )
{
	// skip conditions
	if( !isdefined( victim) || !isdefined( attacker ) || !isplayer( attacker ) || !isplayer( victim ) )
		return damage;
	if( attacker.sessionstate != "playing" || !isdefined( damage ) || !isdefined( meansofdeath ) )
		return damage;
	if( meansofdeath == "" )
		return damage;
		
	old_damage = damage;
	final_damage = damage;
	
	/* Cases =======================
	attacker - bullet damage
		victim - none
		victim - armor
	attacker - explosive damage
		victim - none
		victim - armor
	attacker - none
		victim - none
		victim - armor
	===============================*/
	
	// if attacker has bullet damage then increase bullet damage
	if( attacker cac_hasSpecialty( "specialty_bulletdamage" ) && isPrimaryDamage( meansofdeath ) )
	{
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased

		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage;
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased bullet damage" );
			#/
		}
		else
		{
			final_damage = damage*(100+level.cac_bulletdamage_data)/100;
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + attacker.name + "'s bullet damage did extra damage to " + victim.name );
			#/
		}
	}
	else if( attacker cac_hasSpecialty( "specialty_explosivedamage" ) && isExplosiveDamage( meansofdeath ) )
	{
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased

		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage;
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased explosive damage" );
			#/
		}
		else
		{
			final_damage = damage*(100+level.cac_explosivedamage_data)/100;
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + attacker.name + "'s explosive damage did extra damage to " + victim.name );
			#/
		}
	}
	else
	{	
		// if attacker has no bullet damage then check if victim has armor
		// if victim has armor then less damage is taken, else damage unchanged
		
		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage*(level.cac_armorvest_data/100);
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + victim.name + "'s armor decreased " + attacker.name + "'s damage" );
			#/
		}
		else
		{
			final_damage = old_damage;
		}	
	}
	
	// debug
	/#
	if ( getdvarint("scr_perkdebug") )
		println( "Perk/> Damage Factor: " + final_damage/old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
	#/
	
	// return unchanged damage
	return int( final_damage );
}

// including grenade launcher, grenade, RPG, C4, claymore
isExplosiveDamage( meansofdeath )
{
	explosivedamage = "MOD_GRENADE MOD_GRENADE_SPLASH MOD_PROJECTILE MOD_PROJECTILE_SPLASH MOD_EXPLOSIVE";
	if( isSubstr( explosivedamage, meansofdeath ) )
		return true;
	return false;
}

// if primary weapon damage
isPrimaryDamage( meansofdeath )
{
	// including pistols as well since sometimes they share ammo
	if( meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET" )
		return true;
	return false;
}

getPlayerCustomClass( primaryWeapon )
{
	playerClass = "CLASS_UNKNOWN";
	
	switch( weaponClass( primaryWeapon ) )
	{
		case "rifle":
			playerClass = "CLASS_ASSAULT";
			break;
		case "pistol":
			playerClass = "CLASS_SNIPER";
			break;
		case "mg":
			playerClass = "CLASS_HEAVYGUNNER";
			break;
		case "smg":
			playerClass = "CLASS_SPECOPS";
			break;
		case "spread":
			playerClass = "CLASS_DEMOLITIONS";
			break;
	}
	
	return playerClass;
}