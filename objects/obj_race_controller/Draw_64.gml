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
//draw the leaderboard
//to fill the screen once the player has finished.
if (player_finished)
{
	//draw the finish
	//UI that takes up most of the screen
	draw_leaderboard_GUI(camera_get_view_width(cam) / 2, camera_get_view_height(cam) / 2, 0.75, 0.75);
}
else
{
	//draw the mini version
	//of the leaderboard in the
	//top right.
	draw_leaderboard_GUI(camera_get_view_width(cam) - (camera_get_view_width(cam) / 8), 400, 0.25, 0.25);
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

