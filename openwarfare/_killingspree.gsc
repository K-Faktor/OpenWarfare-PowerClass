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

#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{
	// Get the main module's dvars
	level.scr_unreal_headshot_sound = getdvarx( "scr_unreal_headshot_sound", "int", 0, 0, 1 );
	level.scr_unreal_firstblood_sound = getdvarx( "scr_unreal_firstblood_sound", "int", 0, 0, 1 );

	// If killing spree sounds are not enabled then there's nothing to do here
	if ( level.scr_unreal_headshot_sound == 0 && level.scr_unreal_firstblood_sound == 0 )
		return;


	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	self thread onPlayerKillStreak();
}


onPlayerKillStreak()
{
	self endon("disconnect");
	level endon( "game_ended" );

	for(;;)
	{
		self waittill("kill_streak", killStreak, streakGiven, sMeansOfDeath );
		playedSound = false;

		// Check if we need to play first blood sound 
		if ( level.scr_unreal_firstblood_sound == 1 && !playedSound && !isDefined( level.firstBlood ) ) {
			playedSound = true;
			level.firstBlood = true;
			self playLocalSound( "firstblood" );
		}
		
		// Check if we need to play headshot sound
		if ( level.scr_unreal_headshot_sound == 1 && !playedSound && sMeansOfDeath == "MOD_HEAD_SHOT" ) {
			playedSound = true;
			self playLocalSound( "headshot" );
		}				
	}
}