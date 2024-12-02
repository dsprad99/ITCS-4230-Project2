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

final_placements_list = ds_list_create()

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

//the cars will update themselves within this queue.

car_placement_queue = ds_priority_create();

//used when iterating through priority
//in the draw GUI event.
copy_queue = ds_priority_create();

current_point = 0;

cur_search_index = 0;

path_len = path_get_length(track_path);

//target_x = 0;
//target_y = 0; 

function get_closest_point_on_path(_x, _y, start_index = 0)
{
	var last_dist = 99999;//point_distance(obj_player_car.x, obj_player_car.y, target_x, target_y);

	
	var closest_index = -1;
	
	//LD Montello,
	//loop through the remaining points 
	//in the path
	for (var i = start_index; i < path_len; i += 15)
	{	
		//get the point to search on the path.
		var _x2 = path_get_x(track_path, i / path_len);
		var _y2 = path_get_y(track_path, i / path_len);
		
		var dist_to_check = point_distance(_x, _y, _x2, _y2);
		
		//if this point is
		//closer than our closest point,
		//say this point is our closest point
		if (dist_to_check < last_dist)
		{
			last_dist = dist_to_check;
			closest_index = i;
		}
	}
	
	return closest_index;
}


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

//LD Montello
//funciton called when
//ever racer has finished.
function end_race()
{
	show_message("Race Over!");
	room_goto(main_menu);
}

function compare_racers(r1, r2)
{
	//show_message(r1)
	//if the lap 
	//number is the same,
	//we need to compare their
	//progression amount
	if (r1[1] == r2[1])
	{
		//if r2 has progressed along
		//the track farther than r1,
		//then r2 is the "larger" value.
		if (r1[2] < r2[2])
		{
			return 1;
		}
		//r1 has progressed farther than r2.
		else if (r1[2] > r2[2])
		{
			return -1;
		}
		//they are equal.
		else if (r1[2] == r2[2])
		{
			return 0;
		}
	}
	//if r1 is less than r2 in lap count,
	//r2 is greater.
	else if (r1[1] < r2[1])
	{
		return 1;
	}
	//r1 is greater in lap count,
	//r1 is greater.
	else if (r1[1] > r2[1])
	{
		return -1;
	}
}

function get_racer_order()
{
	//create array of currently alive 
	//cars.
	//it took me forever to realize 
	//that array_push would only
	//push new values and increase
	//the size of the array,
	//instead of filling the empty
	//indexes.
	//this was broken for a long time before
	//I figured that out.
	new_arr = array_create(0);
	
	//new_arr is an array
	//of 3 element arrays
	//containing [car_instance, lap, progress_on_lap];
	
	//add all player
	//cars + lap values
	//to the array
	with (obj_player_car)
	{
		array_push(other.new_arr, [self, self.cur_lap, self.current_track_path_progression]);
	}
	
	//add all enemy
	//cars + lap values
	//to the array
	with (obj_enemy)
	{
		array_push(other.new_arr, [self, self.cur_lap, self.current_track_path_progression]);
	}
	
	//for (var i = 0; i < array_length(new_arr); i++)
	//{
	//	show_message(array_length(new_arr));
	//	show_message(new_arr[i]);
	//}
	
	//sort the array using
	//our custom car sorting
	//function
	array_sort(new_arr, compare_racers);
	
	//return the sorted array
	return new_arr;
}