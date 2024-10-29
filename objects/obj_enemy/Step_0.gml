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

var lastDist = point_distance(x, y, target_x, target_y);

//LD Montello,
//loop through the remaining points 
//in the path
for (var i = 0; i < path_len; i+=path_increment)
{
	var new_x = path_get_x(track_path, i / path_len)
	var new_y = path_get_y(track_path, i / path_len) 
	
	var heading_x = x + lengthdir_x(car_speed, image_angle);
	var heading_y = y + lengthdir_y(car_speed, image_angle);
	show_debug_message(i);
	//if this is the closest point on the path,
	//And it is ahead of the current point,
	//path towards it.
	var newDist = point_distance(heading_x, heading_y, new_x, new_y);
	//LD position_empty is where you were.
	if (current_point < i and position_empty(new_x, new_y) and newDist < lastDist)
	{
		//show_message("HERE");
		lastDist = point_distance(heading_x, heading_y, new_x, new_y);
		//Reset the nearest point to be the current point
		current_point = i;
		target_x = new_x;
		target_y = new_y;
	}
	
}

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
if (angle_difference(image_angle, point_direction(x,y, next_x, next_y)) > 25)
{
	shouldAccel = false;
	
	//TODO: Calculate
	//the minimum speed to reach
	//on this turn, 
	//so that we know if we need
	//to start deccelerating and
	//then turn "shouldDeccel" 
	//to true.
	if (car_speed > 1)
		shouldDeccel = true;
	else
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

var targetRot = point_direction(x, y, target_x, target_y);

if (angle_difference(image_angle, targetRot) > 0)
{
	image_angle -= turn_speed;
}
else if (angle_difference(image_angle, targetRot) < 0)
{
	image_angle += turn_speed;
}

//Look towards where we want to go,
//NOT our current velocity.
//image_angle = point_direction(x, y, target_x, target_y);
direction = image_angle

//mp_potential_step_object(path_get_point_x(track_path, i), track
//Path using car_speed
mp_potential_step(target_x, target_y, car_speed, false);



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


//LD Montello
//Draw sprite at the target position
layer_sprite_x(arrow, target_x);
layer_sprite_y(arrow, target_y);