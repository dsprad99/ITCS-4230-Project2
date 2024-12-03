/// @description Insert description here
// You can write your code in this editor



//LD Montello
//Display FPS 
//if in debug mode.
if (global.in_debug)
{
	draw_text_transformed(camera_get_view_width(cam) - 150, 500, "FPS: " + string(fps), 2, 2, 0);
}



if (instance_exists(obj_player_car))
{
	
	//LD Montello
	//Set the font
	//Make the text aligned to the left.
	draw_set_font(fnt_gamecuben)
	//draw_set_valign(fa_middle)
	draw_set_color(global.neon_cyan);
	
	var _text_scale = 12 / 72;
	
	//LD Montello
	//Draw the player cars track times

	draw_text_transformed(50, 50, "Lap Times: ", _text_scale, _text_scale, 0);
	
	draw_text_transformed(50, 100, "Lap 1: ", _text_scale, _text_scale, 0);

	draw_time_formatted(150, 100, obj_player_car.lap1_time, global.neon_cyan, _text_scale, _text_scale);
	
	draw_text_transformed(50, 150, "Lap 2: ", _text_scale, _text_scale, 0);
	
	draw_time_formatted(150, 150, obj_player_car.lap2_time,  global.neon_cyan, _text_scale, _text_scale);
	
	draw_text_transformed(50, 200, "Lap 3: ", _text_scale, _text_scale, 0);
	
	draw_time_formatted(150, 200, obj_player_car.lap3_time,  global.neon_cyan, _text_scale, _text_scale);

	
	
	draw_text_transformed(50, 250, "Total: ", _text_scale, _text_scale, 0);

	//LD Montello
	//draw the overall time
	draw_time_formatted(150, 250, (obj_player_car.lap1_time + obj_player_car.lap2_time + obj_player_car.lap3_time), global.neon_cyan, _text_scale, _text_scale);

	
	cur_search_index = get_closest_point_on_path(obj_player_car.x, obj_player_car.y);
	
	if (global.in_debug)
	{
		draw_text_transformed_color(camera_get_view_width(cam) - 250, 100, "Progress: " + string(cur_search_index / path_get_length(CircuitCity_track)), 2, 2, 0, c_white, c_white, c_white, c_white, 1);
	}
	
	//LD Montello
	//Go back to default alignment.
	draw_set_valign(-1)
	draw_set_halign(-1)
	//Go back to default font
	draw_set_font(-1)
	draw_set_color(-1);
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

	//draw the player's current lap number in the GUI
	//at the top center of the screen.
	if (obj_player_car.cur_lap == 1)
	{
		draw_sprite_ext(spr_lap1, 0, camera_get_view_width(cam) / 2, sprite_get_height(spr_lap1) * 0.25, 0.25, 0.25, 0, c_white, 1);
	}
	else if (obj_player_car.cur_lap == 2)
	{
		draw_sprite_ext(spr_lap2, 0, camera_get_view_width(cam) / 2, sprite_get_height(spr_lap2) * 0.25, 0.25, 0.25, 0, c_white, 1);
	}
	else if (obj_player_car.cur_lap == 3)
	{
		draw_sprite_ext(spr_lap3, 0, camera_get_view_width(cam) / 2, sprite_get_height(spr_lap3) * 0.25, 0.25, 0.25, 0, c_white, 1);
	}

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

