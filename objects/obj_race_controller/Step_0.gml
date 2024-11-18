/// @description Insert description here
// You can write your code in this editor


//get the number 
//of enemies total
//and the number
//of enemies that have
//finished.
var total = 0;
var finishers = 0;

with (obj_enemy)
{
	total++;
	if (did_finish)
	{
		finishers++;
	}
}

if (instance_exists(obj_player_car) and obj_player_car.did_finish)
{
	//Don't update the time_taken once all
	//racers have finished,
	//for now we won't check if the enemies have finished
	//for testing purposes.
	
	//if every enemy has finished,
	//and the player has also finished,
	//the race is over.
	if (total == finishers)
	{
		end_race();
	}
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