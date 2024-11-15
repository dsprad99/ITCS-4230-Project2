/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_player_car) and obj_player_car.did_finish)
{
	//Don't update the time_taken once all
	//racers have finished,
	//for now we won't check if the enemies have finished
	//for testing purposes.
}
else
{
	//set the time taken
	time_taken = current_time-start_time;
}

center_x = camera_get_view_x(cam) + camera_get_view_width(cam) / 2
center_y = camera_get_view_y(cam) + (64 * 5)
layer_sequence_x(light_drop_down_start, center_x)
layer_sequence_y(light_drop_down_start, center_y)