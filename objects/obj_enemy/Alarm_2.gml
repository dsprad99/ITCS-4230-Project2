/// @description Find nearest point on path
// You can write your code in this editor

//if we're paused, don't
//let this alarm
//go off and instead reset it.
if (global.paused)
{
	//reset alarm.
	alarm_set(2, 1);
	//return.
	return;
}

//LD Montello
//if we're not facing the
//current target,
//lets make sure we're
//targeting the nearest point on the path
current_point = obj_race_controller.get_closest_point_on_path(x + vel_vec[0], y +vel_vec[1], current_point);

if (current_point != -1)
{
	target_x = path_get_x(obj_race_controller.track_path, current_point / obj_race_controller.path_len);
	target_y = path_get_y(obj_race_controller.track_path, current_point / obj_race_controller.path_len);
}

//LD Montello
//we only want to find the nearest point
//every 100 milliseconds, this is because
//searching the entire path for the nearest
//point can be intensive if we do it every frame.
//this seems to be the optimal amount of time
//for searching.
alarm_set(2, game_get_speed(gamespeed_fps)*0.1);