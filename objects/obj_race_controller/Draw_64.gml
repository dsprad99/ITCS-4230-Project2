/// @description Insert description here
// You can write your code in this editor



//LD Montello
//Display FPS 
//if in debug mode.
if (global.in_debug)
{
	draw_text_transformed(camera_get_view_width(cam) - 150, 500, "FPS: " + string(fps), 2, 2, 0);
}

//LD Montello
//draw the overall time
draw_time_formatted(50, 50, time_taken);

if (instance_exists(obj_player_car))
{
	//LD Montello
	//Draw the player cars track times
	draw_time_formatted(50, 100, obj_player_car.lap1_time);
	draw_time_formatted(50, 150, obj_player_car.lap2_time);
	draw_time_formatted(50, 200, obj_player_car.lap3_time);
	
	
	draw_text_transformed_color(camera_get_view_width(cam) - 150, 50, "Lap " + string(obj_player_car.cur_lap), 2, 2, 0, c_aqua, c_aqua, c_aqua, c_aqua, 1);

	
	cur_search_index = get_closest_point_on_path(obj_player_car.x, obj_player_car.y);
	
	if (global.in_debug)
	{
		draw_text_transformed_color(camera_get_view_width(cam) - 250, 100, "Progress: " + string(cur_search_index / path_get_length(CircuitCity_track)), 2, 2, 0, c_white, c_white, c_white, c_white, 1);
	}
}



//LD Montello
//clear queue just in case.
if (!ds_priority_empty(copy_queue))
	ds_priority_clear(copy_queue);
//LD Montello
//copy the queue before we iterate through it.
ds_priority_copy(copy_queue, car_placement_queue);

var place = 1;
var _y = 50;

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
	
	draw_text_transformed_color(camera_get_view_width(cam) - 550, _y, string(place) + " " + cur_car.car_name, 2, 2, 0, name_color, name_color, name_color, name_color, 1);
	
	//go down by 50 for the next drawing
	//of the placement
	_y += 50;
	
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
	
	draw_text_transformed_color(camera_get_view_width(cam) - 550, _y, string(place) + " " + cur_car.car_name + " " + string(car_priority), 2, 2, 0, name_color, name_color, name_color, name_color, 1);
	
	//LD Montello
	//Store the race position
	//for this car.
	cur_car.race_position = place;
	
	//go down by 50 for the next drawing
	//of the placement
	_y += 50;
	
	//increment the place.
	place++;
}



//LD Montello
#region draw the player's position in the race

if (obj_player_car.race_position == 1)
{
	draw_sprite(spr_1st, 0, camera_get_view_width(cam) - 250, 100);
}
else if (obj_player_car.race_position == 2)
{
	draw_sprite(spr_2nd, 0, camera_get_view_width(cam) - 250, 100);
}
else if (obj_player_car.race_position == 3)
{
	draw_sprite(spr_3rd, 0, camera_get_view_width(cam) - 250, 100);
}
else if (obj_player_car.race_position == 4)
{
	draw_sprite(spr_4th, 0, camera_get_view_width(cam) - 250, 100);
}
else if (obj_player_car.race_position == 5)
{
	draw_sprite(spr_5th, 0, camera_get_view_width(cam) - 250, 100);
}


#endregion

