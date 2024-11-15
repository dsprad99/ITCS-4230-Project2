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
//show_message("Start Race")

#region race times

//LD Montello
//The time at which the race starts.
//we set this in the broadcast event
start_time = 0;

//the time since the race has started
//we set this in the step event
//and draw it in Draw GUI.
time_taken = 0;

//LD Montello
//Draw the time with formatting given a position
//and a time.
function draw_time_formatted(_x, _y, _time)
{
	//LD Montello
//Where I found the way to calculate the time values:
//https://stackoverflow.com/questions/10874048/from-milliseconds-to-hour-minutes-seconds-and-milliseconds
	var milliseconds = _time;
	var seconds = floor((milliseconds / 1000) % 60)
	var minutes = floor((milliseconds / (1000*60)) % 60);
	var hours = floor((milliseconds / (1000*60*60)) % 24);
	draw_text_transformed_color(_x, _y, string(minutes) + "m " + string(seconds) + "s " + string(milliseconds % 1000) + "ms ", 2, 2, 0, c_aqua, c_aqua, c_aqua, c_aqua, 1);
}

#endregion

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