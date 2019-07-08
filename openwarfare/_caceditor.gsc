/****************************************
	Original code by OpenWarfare team
	Complete Rewrite by Tally 2012
*****************************************/

#include openwarfare\_utils;

// called from _powerclass::onPlayerConnected()
initializeEditor()
{
	//Set up arrays and starting indexes
	self.classesIndex = 0;
	self.primariesIndex = 0;
	self.pattachmentsIndex = 0;
	self.secondariesIndex = 0;
	self.sattachmentsIndex = 0;
	self.perk1Index = 0;
	self.perk2Index = 0;
	self.perk3Index = 0;
	self.sgrenadesIndex = 0;
	self.camosIndex = 0;
	
	self.cacEdit_classes = [];
	
	//Add data to arrays
	self addClasses();
}

// called from _powerclass::onPlayerConnected()
cacResponseHandler()
{
	self endon( "disconnect" );
	
	for( ;; )
	{
		self waittill( "menuresponse", menu, response );
		
		if( isSubStr( response, "cacedit" ) )
		{
			self closeMenu();
			self closeInGameMenu();
			
			self openClass( response );
			continue;
		}

		if( getSubStr( response, 0, 7 ) == "loadout" )
		{
			self processLoadoutResponse( response );
			continue;
		}
		
		if( response == "open_camo_button" )
		{
			self checkChallengeCamos();
			continue;
		}

		if( response == "cacSubmit" )
		{
			self submitUpdate();
			continue;
		}
	}
}

openClass( response )
{
	self.classesIndex = 0;
	self.primariesIndex = 0;
	self.pattachmentsIndex = 0;
	self.secondariesIndex = 0;
	self.sattachmentsIndex = 0;
	self.perk1Index = 0;
	self.perk2Index = 0;
	self.perk3Index = 0;
	self.sgrenadesIndex = 0;
	self.camosIndex = 0;

	self class( response );
}

class( response )
{
	tokens = strTok( response, "," );
	self.classesIndex = int( tokens[1] );
	
	if( self.classesIndex < 0 )
		self.classesIndex = self.cacEdit_classes.size - 1;
	else if( self.classesIndex >= self.cacEdit_classes.size )
		self.classesIndex = 0;
		
	self displayDefaultLoadout();	
}

displayDefaultLoadout()
{	
	//Class name
	self setClientDvar( "cac_class", self.cacEdit_classes[self.classesIndex].text );
	
	class_offset = 320+(self.classesIndex*10);
	
	//Get current class' stats
	def_primary = self getStat( class_offset + 1 );
	def_pattach = self getStat( class_offset + 2 );
	def_secondary = self getStat( class_offset + 3 );
	def_sattach = self getStat( class_offset + 4 );
	def_perk1 = self getStat( class_offset + 5 );
	def_perk2 = self getStat( class_offset + 6 );
	def_perk3 = self getStat( class_offset + 7 );
	def_sgrenade = self getStat( class_offset + 8 );
	def_camo = self getStat( class_offset + 9 );
	
	//Set default primary index
	primary = convertStattoWeapon( def_primary );
	self setClientDvar( "loadout_primary", primary );
	self.primariesIndex = def_primary;
	
	//Set default primary attachment index
	pattach = getAttachmentName( def_pattach );
	self setClientDvar( "loadout_primary_attachment", pattach );
	self.pattachmentsIndex = def_pattach;
	
	//Set default secondary index
	secondary = convertStattoWeapon( def_secondary );
	self setClientDvar( "loadout_secondary", secondary );
	self.secondariesIndex = def_secondary;
	
	//Set default secondary attachment index
	sattach = getAttachmentName( def_sattach );
	self setClientDvar( "loadout_secondary_attachment", sattach );
	self.sattachmentsIndex = def_sattach;
	
	//Set default perk1 index
	perkName = convertStattoPerk( def_perk1 );
	self setClientDvar( "loadout_perk1", perkName );
	self.perk1Index = def_perk1;
	
	//Set default perk2 index
	perkname = convertStattoPerk( def_perk2 );
	self setClientDvar( "loadout_perk2", perkname );
	self.perk2Index = def_perk2;
	
	//Set default perk3 index
	perkname = convertStattoPerk( def_perk3 );
	self setClientDvar( "loadout_perk3", perkname );
	self.perk3Index = def_perk3;

	//Set default special grenade index
	sgrenade = convertStattoWeapon( def_sgrenade );
	self setClientDvar( "loadout_sgrenade", sgrenade );
	self.sgrenadesIndex = def_sgrenade;

	//Set default camo index
	camo = getCamoName( def_camo );
	self setClientDvar( "loadout_camo", camo );
	self.camosIndex = def_camo;
	
	self openMenu( game["menu_cac_editor"] );
}

processLoadoutResponse( respString )
{
	commandTokens = strTok( respString, "," );
	
	for( index = 0; index < commandTokens.size; index++ )
	{
		subTokens = strTok( commandTokens[index], ":" );
		assert( subTokens.size > 1 );

		switch( subTokens[0] )
		{
			case "loadout_primary":
				{	
					// convert the response to a weapon stat number
					def_primary = getWeaponStat( subTokens[1] );
					
					// turn off all attachements and then turn on attachments supported by this weapon
					self turnOffAttachments();
					self turnOnAttachmentsforWeapon( def_primary );
					
					self setClientDvar( subTokens[0], subTokens[1] );
					self.primariesIndex = def_primary;
				}
				break;
			
			case "loadout_secondary":
				{			
					// convert the response to a weapon stat number
					def_secondary = getWeaponStat( subTokens[1] );
					
					// turn off all attachements and then turn on attachments supported by this weapon
					self thread turnOffAttachments();
					self thread turnOnAttachmentsforWeapon( def_secondary );
					
					self.secondariesIndex = def_secondary;
					self setClientDvar( subTokens[0], subTokens[1] );
				}
				break;
				
			case "loadout_primary_attachment":
				{
					// convert the response to an attachment stat number
					def_pattach = getAttachmentStatfromName( subTokens[1] );
					
					self.pattachmentsIndex = def_pattach;
					self setClientDvar( subTokens[0], subTokens[1] );
				}
				break;

			case "loadout_secondary_attachment":
				{
					// convert the response to an attachment stat number
					def_sattach = getAttachmentStatfromName( subTokens[1] );
					
					self.sattachmentsIndex = def_sattach;
					self setClientDvar( subTokens[0], subTokens[1] );
				}
				break;

			case "loadout_perk1":
				{
					// convert the response to a perk stat number
					def_perk1 = convertPerktoStat( subTokens[1] );
					
					self.perk1Index = def_perk1;
					self setClientDvar( subTokens[0], subTokens[1] );
				}
				break;
				
			case "loadout_perk2":
				{
					// convert the response to a perk stat number
					def_perk2 = convertPerktoStat( subTokens[1] );
					
					self.perk2Index = def_perk2;
					self setClientDvar( subTokens[0], subTokens[1] );
				}
				break;
				
			case "loadout_perk3":
				{
					// convert the response to a perk stat number
					def_perk3 = convertPerktoStat( subTokens[1] );
					
					self.perk3Index = def_perk3;
					self setClientDvar( subTokens[0], subTokens[1] );
				}
				break;

			case "loadout_sgrenade":
				{
					// convert the response to a grenade stat number
					def_sgrenade = getWeaponStat( subTokens[1] );
					
					self.sgrenadesIndex = def_sgrenade;
					self setClientDvar( subTokens[0], subTokens[1] );
				}
				break;
	
			case "loadout_camo":
				{
					// convert the response to a camo stat number
					def_camo = getCamoStat( subTokens[1] );
					
					self.camosIndex = def_camo;
					self setClientDvar( subTokens[0], subTokens[1] );
				}
				break;
		}
	}
}

submitUpdate()
{	
	class_offset = 320+(self.classesIndex*10);
	
	self setStat( class_offset + 1, self.primariesIndex ); //Primary Weapon
	self setStat( class_offset + 2, self.pattachmentsIndex ); //Primary Attachment

	// hack to prevent incorrect weapon and attachment data creeping into the client's 
	// stat file after turning off overkll
	self.secondariesIndex = CheckSideArm( self.secondariesIndex );
	self.sattachmentsIndex = CheckSecondaryAttachment( self.sattachmentsIndex, self.secondariesIndex );
		
	self setStat( class_offset + 3, self.secondariesIndex ); //Secondary Weapon
	self setStat( class_offset + 4, self.sattachmentsIndex ); //Secondary Attachment
	
	self setStat( class_offset + 5, self.perk1Index ); //Perk 1
	self setStat( class_offset + 6, self.perk2Index ); //Perk 2
	self setStat( class_offset + 7, self.perk3Index ); //Perk 3
	self setStat( class_offset + 8, self.sgrenadesIndex ); //Special Grenade
	self setStat( class_offset + 9, self.camosIndex ); //Camo
	
	self.cac_initialized = undefined;
}

addClasses()
{
	//Add classes ( name, class_stat )
	self addCACClasses( "customclass1", 320 ); //Custom class 1
	self addCACClasses( "customclass2", 321 ); //Custom class 2
	self addCACClasses( "customclass3", 322 ); //Custom class 3
	self addCACClasses( "customclass4", 323 ); //Custom class 4
	self addCACClasses( "customclass5", 324 ); //Custom class 5
	self addCACClasses( "customclass6", 325 ); //Custom class 6
	self addCACClasses( "customclass7", 326 ); //Custom class 7	
	self addCACClasses( "customclass8", 327 ); //Custom class 8	
}	

addCACClasses( text, stat )
{
	cacClass = spawnstruct();
	cacClass.text = text;
	cacClass.stat = stat;
	self.cacEdit_classes[self.cacEdit_classes.size] = cacClass;
}

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// UTILITIES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

turnOffAttachments()
{
	for( i=0; i < 6; i++ )
		self setClientDvar( "attachment_allow_" + level.tbl_WeaponAttachment[i]["reference"], 0 );
}

turnOnAttachmentsforWeapon( weaponStat )
{
	for( i=0; i < 6; i++ )
		if( isValidAttachment( weaponStat, level.tbl_WeaponAttachment[i]["reference"] ) )
			self setClientDvar( "attachment_allow_" + level.tbl_WeaponAttachment[i]["reference"], level.serverDvars[ "attachment_allow_" + level.tbl_WeaponAttachment[i]["reference"] ] );
			
}

isUsingOverkill()
{
	if( self.perk2Index == 166 )
		return true;
		
	return false;
}

/******************************************************************

	Function to randomly find a replacement primary from an 
	array. It will select the first primary in the array when a 
	dvar reference is an integer, and return that primary as the
	replacement.
	
*******************************************************************/
getNextAvailablePrimary( currentPrimaryStat )
{
	currentPrimary = convertStattoWeapon( currentPrimaryStat );
	candidate = undefined;
	
	array = [];
	if( level.progressiveUnlocks )
	{
		weapons = StrTok( level.defaultWeapons, ";" );
		for( i=0; i < weapons.size; i++ )
			array[array.size] = weapons[i];
	}
	else
		array = level.candidate_array;
	
	for( i=0; i < array.size; i++ )
	{
		weapon = array[i];
		if( maps\mp\gametypes\_weapons::isPrimaryWeapon( weapon + "_mp" ) && weapon != currentPrimary && getDvarInt( "weap_allow_" + weapon ) )	
		{
			candidate = weapon;
			break;
		}
	}
	
	return( candidate );
}

isValidAttachment( weaponStat, attachment )
{
	if( attachment == "none" )
		return true;

	if( isSubStr( level.tbl_weaponIDs[ weaponStat ]["attachment"], attachment ) && progressiveUnlocks( weaponStat, attachment ) )
		return true;
	
	return false;
}

progressiveUnlocks( weaponStat, attachment )
{
	if( !level.progressiveUnlocks )
		return true;
	else
	{
		return( self.challengeAttachments[ ConvertStattoWeapon( weaponStat ) ][ attachment ] );
	}
}

checkChallengeCamos()
{
	if( !level.progressiveUnlocks ) return;
	
	challengeCamo = StrTok( level.challengeCamos, ";" );
	for( i=0; i < challengeCamo.size; i++ )
		self setClientDvar( "camo_allow_" + challengeCamo[i], self.challengeCamos[ convertStattoWeapon( self.primariesIndex ) ][ challengeCamo[i] ] );
	
}

/********************************************************************************************************************

	Hack for players who don't bother to reset their weapons after switching off specialty_twoprimaries. Doing so will 
	either leave them with a primary weapon as a sidearm but no Overkill perk, or a sidearm when it should be a primary. 
	The menu widgets don't seem to be able to send a scriptmenuresponse from inside the widgets themselves, so 
	this check is needed to make sure everything looks right when saving the class.
	
*********************************************************************************************************************/
CheckSideArm( sideArmStat )
{
	secondariesIndex = undefined;
	sideArm = convertStattoWeapon( sideArmStat ) + "_mp";
	
	if( !self isUsingOverkill() && maps\mp\gametypes\_weapons::isPrimaryWeapon( sideArm )  ) // They have a primary as a secondary but don't have Overkill
	{
		// give them a randomized pistol for a sidearm  
		secondariesIndex = openwarfare\_powerclass::getPistol();
	}
	else if( self isUsingOverkill() && maps\mp\gametypes\_weapons::isSideArm( sideArm ) ) // They have Overkill on but they have a pistol
	{
		// replace their pistol with an Overkill weapon which doesn't conflict with their existing primary
		replacement = getNextAvailablePrimary( self.primariesIndex );
		secondariesIndex = getWeaponStat( replacement );
	}
	else // Everything is right, so give them their choice
	{
		// give them the weapon they selected
		secondariesIndex = sideArmStat;
	}
	
	return( secondariesIndex );
}

CheckSecondaryAttachment( secAttachStat, weaponStat )
{
	sattachmentsIndex = undefined;
	attachment = getAttachmentName( secAttachStat );
	
	if( !isValidAttachment( weaponStat, attachment ) )
		sattachmentsIndex = 0;
	else
		sattachmentsIndex = secAttachStat;
		
	return( sattachmentsIndex );
}

