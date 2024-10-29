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

var next_point = current_point + 15;
var next_x = path_get_point_x(track_path, current_point + 1)
var next_y = path_get_point_y(track_path, current_point + 1) 

//if (distance_to_point(path_get_point_x(track_path, current_point), path_get_point_y(track_path, current_point)) < 1)
//{
//	show_message("HREE");
//	current_point++;
//	target_x = next_x;
//	target_y = next_y;
//}

//if we've reached our current point
if (distance_to_point(path_get_x(track_path, current_point / path_get_length(track_path)),path_get_y(track_path, current_point / path_get_length(track_path))) < 1)
{
	//show_message("HREE");
	//current_point++;
	//Go up by 15 in the path to reach the next point.
	
	//if we have exceeded the path length,
	//the path is closed so go back to the beginning
	//of the path and continue.
	if (current_point + 15 > path_len)
	{
		//show_message("HERE");
		//current_point = (current_point + 15) - path_len;
		current_point++;
		
		//rollover to next point if we have reached
		//the "end" of our path.
		if (current_point - path_len < 1)
		{
			current_point = 0;
		}
	}

	//Increment by 15
	//because we are using each
	//pixel in the path as a point
	//when we do the mp_potential_step.
	current_point += 15;
}

//get our target positions
//by getting our 0-1 percentage
//along the path using our current_point / path_len
//so we know where along the path to move to.
target_x = path_get_x(track_path, current_point / path_get_length(track_path));
target_y = path_get_y(track_path, current_point / path_get_length(track_path));

//mp_potential_step_object(path_get_point_x(track_path, i), track
mp_potential_step(target_x, target_y, 55, false);
