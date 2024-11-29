/// @description Insert description here
// You can write your code in this editor

//if we're paused, don't
//let this alarm
//go off and instead reset it.
if (global.paused)
{
	//reset alarm.
	alarm_set(2, 1);
	//return.
	return;
}

//this alarm is used
//to do a delay before
//resetting the player.
reset_to_last_checkpoint();