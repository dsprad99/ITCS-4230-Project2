/// @description Insert description here
// You can write your code in this editor

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
}