/// @description Insert description here
// You can write your code in this editor

//LD Montello
//did the player finish
//the race?
player_finished = false;

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
function draw_time_formatted(_x, _y, _time, _color = c_aqua, _x_scale = 2, _y_scale = 2)
{
	//LD Montello
//Where I found the way to calculate the time values:
//https://stackoverflow.com/questions/10874048/from-milliseconds-to-hour-minutes-seconds-and-milliseconds
	var milliseconds = _time;
	var seconds = floor((milliseconds / 1000) % 60)
	var minutes = floor((milliseconds / (1000*60)) % 60);
	var hours = floor((milliseconds / (1000*60*60)) % 24);
	draw_text_transformed_color(_x, _y, string(minutes) + "m " + string(seconds) + "s " + string(milliseconds % 1000) + "ms ", _x_scale, _y_scale, 0, _color, _color, _color, _color, 1);
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

//function draw_mini_leaderboard_GUI()
//{
//	var start_x =  camera_get_view_width(cam) - (camera_get_view_width(cam) / 8)
//	var start_y = (camera_get_view_height(cam) / 4);
	
//	var x_scale = 0.25;
//	var y_scale = 0.25;
	
//	var scaled_width = x_scale * 1920;
//	var scaled_height = y_scale * 1080;
	
//	var x_text_scale = x_scale * 8;
//	var y_text_scale = y_scale * 8;
	
//	//LD Montello
//	//Draw the leaderboard sprite
//	//with slight alpha
//	draw_sprite_ext(spr_leaderboard, 0, start_x, start_y, x_scale, y_scale, 0, c_white, 0.5)
	
	
//	#region drawing race placements.
	
//	//LD Montello
//	//clear queue just in case.
//	if (!ds_priority_empty(copy_queue))
//		ds_priority_clear(copy_queue);
//	//LD Montello
//	//copy the queue before we iterate through it.
//	ds_priority_copy(copy_queue, car_placement_queue);

//	var place = 1;
//	var _y = (start_y - scaled_height / 2) + (y_scale * 200);
	
//	//loop through the cars
//	//that have finished the race.
//	for (i = 0; i < ds_list_size(final_placements_list); i++)
//	{
//		//get the current car
//		var cur_car = ds_list_find_value(final_placements_list, i);
	
//		var name_color = c_white;
	
//		//if the car type is the player,
//		//make their name color be cyan
//		if (cur_car.object_index == obj_player_car)
//		{
//			name_color = global.neon_cyan;
//		}
//		//otherwise, it's an enemy name.
//		else
//		{
//			name_color = global.neon_magenta;
//		}
	
//		//draw_text_transformed_color(start_x - (scaled_width / 2), _y, string(place) + " " + cur_car.car_name, 2, 2, 0, name_color, name_color, name_color, name_color, 1);
		
//		//draw the position
//		draw_text_transformed_color(start_x - (scaled_width / 2) + (40 * x_scale), _y, string(place), x_text_scale, y_text_scale, 0, name_color, name_color, name_color, name_color, 1);
		
//		//draw the name
//		draw_text_transformed_color(start_x - (scaled_width / 2) + (400 * x_scale), _y, cur_car.car_name, x_text_scale, y_text_scale, 0, name_color, name_color, name_color, name_color, 1);
	
		
//		//draw the time
//		//of the current lap.
//		if (cur_car.cur_lap == 1)
//		{
//			draw_time_formatted(start_x - (scaled_width / 2) + (1350 * x_scale), _y, cur_car.lap1_time, name_color, x_text_scale, y_text_scale)
//		}
//		else if (cur_car.cur_lap == 2)
//		{
//			draw_time_formatted(start_x - (scaled_width / 2) + (1350 * x_scale), _y, cur_car.lap2_time, name_color, x_text_scale, y_text_scale)
//		}
//		else if (cur_car.cur_lap == 3)
//		{
//			draw_time_formatted(start_x - (scaled_width / 2) + (1350 * x_scale), _y, cur_car.lap3_time, name_color, x_text_scale, y_text_scale)
//		}
		
//		//go down by 50 for the next drawing
//		//of the placement
//		_y += (y_scale * 200);
	
//		//increment the place.
//		place++;
//	}

//	//loop through
//	//the cars that
//	//are still racing
//	while (!ds_priority_empty(copy_queue))
//	{
//		//get the current car
//		var cur_car = ds_priority_find_max(copy_queue);
	
//		//get the priority
//		//of the car.
//		var car_priority = ds_priority_find_priority(copy_queue, cur_car);
	
//		//remove the current car, effectively "popping" it from
//		//the queue.
//		ds_priority_delete_max(copy_queue);
	
//		var name_color = c_white;
	
//		//if the car type is the player,
//		//make their name color be cyan
//		if (cur_car.object_index == obj_player_car)
//		{
//			name_color = global.neon_cyan;
//		}
//		//otherwise, it's an enemy name.
//		else
//		{
//			name_color = global.neon_magenta;
//		}
		
//		//draw_text_transformed_color(start_x - (scaled_width / 2), _y, string(place) + " " + cur_car.car_name + " " + string(car_priority), 2, 2, 0, name_color, name_color, name_color, name_color, 1);
		
//		//draw the position
//		draw_text_transformed_color(start_x - (scaled_width / 2) + (40 * x_scale), _y, string(place), x_text_scale, y_text_scale, 0, name_color, name_color, name_color, name_color, 1);
		
//		//draw the name
//		draw_text_transformed_color(start_x - (scaled_width / 2) + (400 * x_scale), _y, cur_car.car_name, x_text_scale, y_text_scale, 0, name_color, name_color, name_color, name_color, 1);
	
//		//draw the time
//		//of the current lap.
//		if (cur_car.cur_lap == 1)
//		{
//			draw_time_formatted(start_x - (scaled_width / 2) + (1350 * x_scale), _y, cur_car.lap1_time, name_color, x_text_scale, y_text_scale)
//		}
//		else if (cur_car.cur_lap == 2)
//		{
//			draw_time_formatted(start_x - (scaled_width / 2) + (1350 * x_scale), _y, cur_car.lap2_time, name_color, x_text_scale, y_text_scale)
//		}
//		else if (cur_car.cur_lap == 3)
//		{
//			draw_time_formatted(start_x - (scaled_width / 2) + (1350 * x_scale), _y, cur_car.lap3_time, name_color, x_text_scale, y_text_scale)
//		}
	
//		//LD Montello
//		//Store the race position
//		//for this car.
//		cur_car.race_position = place;
	
//		//go down by 50 for the next drawing
//		//of the placement
//		_y += (y_scale * 200);
	
//		//increment the place.
//		place++;
//	}
//}

//LD Montello
//draw the leaderboard
//at a set position
//and scale on the screen in GUI coordinates.
function draw_leaderboard_GUI(start_x, start_y, x_scale, y_scale)
{
	
	//LD Montello
	//Set the font
	//Make the text aligned to the left.
	draw_set_font(fnt_gamecuben)
	//draw_set_valign(fa_middle)
	draw_set_color(c_white);
	
	//var start_x = camera_get_view_width(cam) / 2
	//var start_y = camera_get_view_height(cam) / 2
	
	//var x_scale = 1;
	//var y_scale = 1;
	
	var scaled_width = x_scale * 1920;
	var scaled_height = y_scale * 1080;
	
	var x_text_scale = x_scale * (64 / 72);
	var y_text_scale = y_scale * (64 / 72);
	
	//LD Montello
	//Draw the leaderboard sprite
	//with slight alpha
	draw_sprite_ext(spr_leaderboard, 0, start_x, start_y, x_scale, y_scale, 0, c_white, 0.5)
	
	
	#region drawing race placements.
	
	//LD Montello
	//clear queue just in case.
	if (!ds_priority_empty(copy_queue))
		ds_priority_clear(copy_queue);
	//LD Montello
	//copy the queue before we iterate through it.
	ds_priority_copy(copy_queue, car_placement_queue);

	var y_offset = (y_scale * (1080 / 5));

	var place = 1;
	var _y = (start_y - scaled_height / 2) + y_offset;
	
	//loop through the cars
	//that have finished the race.
	for (i = 0; i < ds_list_size(final_placements_list); i++)
	{
		//get the current car
		var cur_car = ds_list_find_value(final_placements_list, i);
	
		var name_color = c_white;
	
		//if the car type is the player,
		//make their name color be cyan
		if (cur_car.object_index == obj_player_car)
		{
			name_color = global.neon_cyan;
		}
		//otherwise, it's an enemy name.
		else
		{
			name_color = global.neon_magenta;
		}
	
		//draw_text_transformed_color(start_x - (scaled_width / 2), _y, string(place) + " " + cur_car.car_name, 2, 2, 0, name_color, name_color, name_color, name_color, 1);
		
		//draw the position
		draw_text_transformed_color(start_x - (scaled_width / 2) + (40 * x_scale), _y, string(place), x_text_scale, y_text_scale, 0, name_color, name_color, name_color, name_color, 1);
		
		//draw the name
		draw_text_transformed_color(start_x - (scaled_width / 2) + (400 * x_scale), _y, cur_car.car_name, x_text_scale, y_text_scale, 0, name_color, name_color, name_color, name_color, 1);
	
		
		//draw the time
		//of the current lap.
		if (cur_car.cur_lap == 1)
		{
			draw_time_formatted(start_x - (scaled_width / 2) + (1350 * x_scale), _y, cur_car.lap1_time, name_color, x_text_scale / 1.5, y_text_scale / 1.5)
		}
		else if (cur_car.cur_lap == 2)
		{
			draw_time_formatted(start_x - (scaled_width / 2) + (1350 * x_scale), _y, cur_car.lap2_time, name_color, x_text_scale / 1.5, y_text_scale / 1.5)
		}
		else if (cur_car.cur_lap == 3)
		{
			draw_time_formatted(start_x - (scaled_width / 2) + (1350 * x_scale), _y, cur_car.lap3_time, name_color, x_text_scale / 1.5, y_text_scale / 1.5)
		}
		
		//go down by 50 for the next drawing
		//of the placement
		_y += y_offset;
	
		//increment the place.
		place++;
	}

	//loop through
	//the cars that
	//are still racing
	while (!ds_priority_empty(copy_queue))
	{
		//get the current car
		var cur_car = ds_priority_find_max(copy_queue);
	
		//get the priority
		//of the car.
		var car_priority = ds_priority_find_priority(copy_queue, cur_car);
	
		//remove the current car, effectively "popping" it from
		//the queue.
		ds_priority_delete_max(copy_queue);
	
		var name_color = c_white;
	
		//if the car type is the player,
		//make their name color be cyan
		if (cur_car.object_index == obj_player_car)
		{
			name_color = global.neon_cyan;
		}
		//otherwise, it's an enemy name.
		else
		{
			name_color = global.neon_magenta;
		}
		
		//draw_text_transformed_color(start_x - (scaled_width / 2), _y, string(place) + " " + cur_car.car_name + " " + string(car_priority), 2, 2, 0, name_color, name_color, name_color, name_color, 1);
		
		//draw the position
		draw_text_transformed_color(start_x - (scaled_width / 2) + (40 * x_scale), _y, string(place), x_text_scale, y_text_scale, 0, name_color, name_color, name_color, name_color, 1);
		
		//draw the name
		draw_text_transformed_color(start_x - (scaled_width / 2) + (400 * x_scale), _y, cur_car.car_name, x_text_scale, y_text_scale, 0, name_color, name_color, name_color, name_color, 1);
	
		//draw the time
		//of the current lap.
		if (cur_car.cur_lap == 1)
		{
			draw_time_formatted(start_x - (scaled_width / 2) + (1350 * x_scale), _y, cur_car.lap1_time, name_color, x_text_scale / 1.5, y_text_scale / 1.5)
		}
		else if (cur_car.cur_lap == 2)
		{
			draw_time_formatted(start_x - (scaled_width / 2) + (1350 * x_scale), _y, cur_car.lap2_time, name_color, x_text_scale / 1.5, y_text_scale / 1.5)
		}
		else if (cur_car.cur_lap == 3)
		{
			draw_time_formatted(start_x - (scaled_width / 2) + (1350 * x_scale), _y, cur_car.lap3_time, name_color, x_text_scale / 1.5, y_text_scale / 1.5)
		}
	
		//LD Montello
		//Store the race position
		//for this car.
		cur_car.race_position = place;
	
		//go down by 50 for the next drawing
		//of the placement
		_y += y_offset;
	
		//increment the place.
		place++;
	}
	
	//LD Montello
	//Go back to default alignment.
	draw_set_valign(-1)
	draw_set_halign(-1)
	//Go back to default font
	draw_set_font(-1)
	draw_set_color(-1);
}

time_to_switch_camera = 1;

//LD Montello
//called by a car when it finishes the race.
function on_car_finished()
{
	//if the player has finished,
	//we need to switch the camera target.
	if (player_finished) 
	{
		//LD Montello
		obj_camera_controller.cam_target = noone
		
		//start the alarm
		//to go off after time_to_switch_camera
		//time.
		//when the alarm goes off it will switch the camera to
		//the furthest racer so we can spectate.
		alarm_set(1, time_to_switch_camera * game_get_speed(gamespeed_fps));
	}
}