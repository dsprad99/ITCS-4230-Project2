/// @description Insert description here
// You can write your code in this editor

//LD Montello,
//loop through the remaining points 
//in the path
//for (i = current_point; i < path_get_length(track_path); i++)
//{
//	var next_x = path_get_point_x(track_path, i)
//	var next_y = path_get_point_y(track_path, i) 
	
//	//if this is the closest point on the path,
//	//And it is ahead of the current point,
//	//path towards it.
//	if (current_point < i and distance_to_point(next_x, next_y) < distance_to_point(target_x, target_x))
//	{
//		//Reset the nearest point to be the current point
//		current_point = i;
//		target_x = next_x;
//		target_y = next_y;
//	}
	
//}

var next_x = path_get_point_x(track_path, current_point + 1)
var next_y = path_get_point_y(track_path, current_point + 1) 

//if (distance_to_point(path_get_point_x(track_path, current_point), path_get_point_y(track_path, current_point)) < 1)
//{
//	show_message("HREE");
//	current_point++;
//	target_x = next_x;
//	target_y = next_y;
//}

if (distance_to_point(path_get_x(track_path, current_point / path_get_length(track_path)),path_get_y(track_path, current_point / path_get_length(track_path))) < 1)
{
	//show_message("HREE");
	current_point++;
}

target_x = path_get_x(track_path, current_point / path_get_length(track_path));
target_y = path_get_y(track_path, current_point / path_get_length(track_path));

//mp_potential_step_object(path_get_point_x(track_path, i), track
mp_potential_step(target_x, target_y, 5, false);
