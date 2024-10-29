/// @description Insert description here
// You can write your code in this editor

#region handle car physics

if (shouldAccel)
{
	
	//Stolen from Davis' code.
	car_speed+=acceleration;
    if(car_speed>max_speed){
		car_speed = max_speed; 
	}
}

if (shouldDeccel)
{
	//Stolen from davis' code.
	car_speed -= acceleration;
    if (car_speed< -max_speed){
		car_speed = -max_speed; 
	}
}

#endregion

#region pathing

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

var next_point = current_point + path_increment;
var next_x = path_get_point_x(track_path, next_point)
var next_y = path_get_point_y(track_path, next_point) 

var cur_x = path_get_x(track_path, current_point / path_get_length(track_path))
var cur_y = path_get_y(track_path, current_point / path_get_length(track_path))

//if (distance_to_point(path_get_point_x(track_path, current_point), path_get_point_y(track_path, current_point)) < 1)
//{
//	show_message("HREE");
//	current_point++;
//	target_x = next_x;
//	target_y = next_y;
//}

//if we've reached our current point
if (distance_to_point(cur_x,cur_y) < 1)
{
	//show_message("HREE");
	//current_point++;
	//Go up by 15 in the path to reach the next point.
	
	//if we have exceeded the path length,
	//the path is closed so go back to the beginning
	//of the path and continue.
	if (current_point + path_increment > path_len)
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
	current_point += path_increment;
}


//TODO:
//Make it so that if the angle between
//our current point and our next point is sharp
//enough, that we decelerate to match the curve.
//USE NEXT_X AND NEXT_Y
if (point_direction(cur_x,cur_y, next_x, next_y) > image_angle + 15)
{
	shouldAccel = false;
	
	//TODO: Calculate
	//the minimum speed to reach
	//on this turn, 
	//so that we know if we need
	//to start deccelerating and
	//then turn "shouldDeccel" 
	//to true.
	shouldDeccel = false;
}
else
{
	shouldAccel = true;
	shouldDeccel = false;
}

//get our target positions
//by getting our 0-1 percentage
//along the path using our current_point / path_len
//so we know where along the path to move to.
target_x = path_get_x(track_path, current_point / path_get_length(track_path));
target_y = path_get_y(track_path, current_point / path_get_length(track_path));

//mp_potential_step_object(path_get_point_x(track_path, i), track
//Path using car_speed
mp_potential_step(target_x, target_y, car_speed, false);

//Look towards where we want to go,
//NOT our current velocity.
image_angle = point_direction(x, y, target_x, target_y);
direction = image_angle

//So, the problem I'm having now is that
//if we do use mp_potential_step
//it'll always move the direction
//of the point, it doesn't need to turn
//first.
//I may just need to program the turning
//and try to get it to accelerate towards
//a point and not use mp_potential_step.

//TODO:
//Apply additional momentum to car that
//has built up here:


#endregion