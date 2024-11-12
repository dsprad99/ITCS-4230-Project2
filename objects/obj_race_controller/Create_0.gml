/// @description Insert description here
// You can write your code in this editor

//LD Montello.
//Start the race
//in this many seconds.
seconds_till_race_start = 3;

//LD Montello
//On create 
//we'll have the countdown happen
//and start the race
show_message("Start Race")

#region start light

//LD Montello
//Get the camera
cam = view_get_camera(0);

//Calculate our center
//position relative to the camera.
center_x = camera_get_view_x(cam) //+ camera_get_view_width(cam) / 2
center_y = camera_get_view_y(cam) //+ camera_get_view_height(cam) / 2

//create the traffic light for the start of the race.
light_drop_down_start = layer_sequence_create("Sequences", center_x, center_y, seq_start_light_drop_down);

//light_drop_down_start.scale

#endregion

//alarm_set(0, game_get_speed(gamespeed_fps)*seconds_till_race_start);

function start_race()
{
	//LD Montello
	//Display something
	//that shows the race has started
	//show_message("GO!")

	//LD Montello
	//For all enemies
	//say that they can move
	//when the race starts.
	with (obj_enemy)
	{
		can_move = true;
	}

	//LD Montello
	//say that the player car can
	//move.
	with (obj_player_car)
	{
		can_move = true;
	}
}