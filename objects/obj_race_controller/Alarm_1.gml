/// @description Insert description here
// You can write your code in this editor

if (global.paused)
{
	//if we're paused,
	//just keep resetting
	//this alarm to go off in 1 frame
	//so that when it's unpaused
	//we go straight back to this
	//event.
	alarm_set(1, 1);
}

//LD Montello,
//Switch the camera controller
//to follow the lead racer
//that hasn't finished
//the race.
obj_camera_controller.cam_target = ds_priority_find_max(obj_race_controller.car_placement_queue);