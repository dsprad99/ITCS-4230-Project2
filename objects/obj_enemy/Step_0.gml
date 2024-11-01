/// @description Insert description here
// You can write your code in this editor



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
	//show_debug_message(i);
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
if (distance_to_point(target_x,target_y) < 1)
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



#region Slowdown for turns

shouldAccel = true;

//var far_point = current_point + path_increment * 6;
//var far_x = path_get_point_x(track_path, next_point)
//var far_y = path_get_point_y(track_path, next_point) 

////TODO:
////Make it so that if the angle between
////our current point and our next point is sharp
////enough, that we decelerate to match the curve.
////USE NEXT_X AND NEXT_Y
//if (angle_difference(image_angle, point_direction(x,y, far_x, far_y)) > 25)
//{
//	shouldAccel = false;
	
//	//TODO: Calculate
//	//the minimum speed to reach
//	//on this turn, 
//	//so that we know if we need
//	//to start deccelerating and
//	//then turn "shouldDeccel" 
//	//to true.
//	if (car_speed > 1)
//		shouldDeccel = true;
//	else
//		shouldDeccel = false;
//}
//else
//{
//	shouldAccel = true;
//	shouldDeccel = false;
//}

#endregion



//get our target positions
//by getting our 0-1 percentage
//along the path using our current_point / path_len
//so we know where along the path to move to.
path_point_x = path_get_x(track_path, current_point / path_get_length(track_path));
path_point_y = path_get_y(track_path, current_point / path_get_length(track_path));

#region get point within radius from path

//LD 
//Get the distance that we are from the track,
//if it's less than our max distance
//from the path
//then get the right perpendicular vector
//or left perpendicular vector
//and normalize them and then multiply
//by our current distance from the path
//or max distance if we are exceeding it,
//and then make our current target be that
//point. 

//var max_dist_from_path = 25;

//Get the left and right perpendicular vectors

var prev_point = current_point - 1;
if (prev_point < 0)
{
	prev_point = path_len - (path_increment - 1);
}
var prev_x = path_get_x(track_path, prev_point / path_get_length(track_path));
var prev_y = path_get_y(track_path, prev_point / path_get_length(track_path));

var future_point = current_point + 1;
if (future_point > path_len)
{
	future_point = (path_len - current_point) + 1;
}
var future_x = path_get_x(track_path, future_point / path_get_length(track_path));
var future_y = path_get_y(track_path, future_point / path_get_length(track_path));

var path_dir = new Vector2(prev_x - future_x, prev_y - future_y);

left_perp_vec = path_dir.left_perp();
right_perp_vec = path_dir.right_perp();


//Set our target position by
//using our current distance from
//the path, multiplied
//by the normalized perpendicular vector.

left_dist = point_distance(x, y, path_point_x + left_perp_vec.x, path_point_y + left_perp_vec.y);
right_dist = point_distance(x, y, path_point_x + right_perp_vec.x, path_point_y + right_perp_vec.y)

//if we are on the left side of the path
if (left_dist < right_dist)
{
	
	left_perp_vec = left_perp_vec.normalized().multiply_scalar(clamp(left_dist, 0, max_dist_from_path));
	
	target_x = path_point_x + left_perp_vec.x
	target_y = path_point_y + left_perp_vec.y

}
//if we are on the right side of the path
else
{
	right_perp_vec = right_perp_vec.normalized().multiply_scalar(clamp(right_dist, 0, max_dist_from_path));
	
	target_x = path_point_x + right_perp_vec.x
	target_y = path_point_y + right_perp_vec.y

}

//target_x = path_get_x(track_path, current_point / path_get_length(track_path));
//target_y = path_get_y(track_path, current_point / path_get_length(track_path));

#endregion

#region turning

//Get the vector from the current point to the next point,
//and turn to face that vector so we aim
//towards the direction of the path instead of the 
//direction of the individual point.
var next_target_x = path_get_x(track_path, current_point + (path_increment * 4) / path_get_length(track_path));
var next_target_y = path_get_y(track_path, current_point + (path_increment * 4) / path_get_length(track_path));

var heading = point_direction(target_x, target_y, next_target_x, next_target_y);

heading_vec = Vector2.angle_to_vector(heading);

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
#endregion



#region handle car physics

if (shouldAccel)
{
	
	//Stolen from Davis' code.
	car_speed+=acceleration;
    if(car_speed>max_speed){
		car_speed = max_speed; 
	}
	
	//var target_vec = Vector2.angle_to_vector(image_angle)


	//if (point_distance(x, y, target_x, target_y) > acceleration)
	//{
	//	target_vec = target_vec.normalized().multiply_scalar(acceleration);

	//	vel_vec.x += target_vec.x;
	//	vel_vec.y += target_vec.y;
	//}
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

#region collision handling

//LD Montello, if we hit an enemy car,
//let that car push us, or bounce out 
//of it's way.
var _inst = instance_place(x, y, [obj_enemy, obj_player_car])
if (_inst != noone)
{
	//Decrease speed of car,
	vel_vec.multiply_scalar(0.5);
	//add speed of the car we hit.
	//that way we are pushed by it.
	//vel_vec.add(new Vector2(1,1).normalized().multiply_scalar(_inst.car_speed));
	//Calculate vector from our car to the other car,
	//to make sure we can't collide
	var newVec = new Vector2(x - _inst.x, y - _inst.y);
	//Normalize the vector, and multiply it's scale by 2
	//so you bounce off at a speed of 2
	vel_vec.add(newVec.normalized().multiply_scalar(2));
}

#endregion


#region handle wall bouncing

//LD Montello, if we 
//hit a track wall.
if (place_meeting(x+vel_vec.x, y+vel_vec.y, bounceables))
{
	//Davis Spradling
	//This will act as the outline of our track and will make the 
	//player bounce off the wall it hits
	//LD Montello,
	//just apply opposite speed so we bounce
	//of in the direction we entered.
	//var enter_speed = vel_vec.magnitude();
	//maybe get the normal of the location
	//we hit and bounce off in the direction
	//of the normal instead.
	vel_vec = vel_vec.multiply_scalar(-0.5);
	
	vel_vec = vel_vec.clamp_magnitude(max_bounce_speed)
}  

#endregion


//var goal_x = x + vel_vec.x;
//var goal_y = y + vel_vec.y;

//x += vel_vec.x;
//y += vel_vec.y;

#region steering

//LD's Research source:
//https://code.tutsplus.com/understanding-steering-behaviors-seek--gamedev-849t

//calculate desired velocity
//var desired_velocity = Vector2.angle_to_vector(image_angle).normalized().multiply_scalar(max_speed);;;
var desired_velocity = new Vector2(target_x - x, target_y - y).normalized().multiply_scalar(max_speed);
var steering = desired_velocity;
steering = steering.subtract(vel_vec)
steering = steering.clamp_magnitude(steering, max_speed);
//0-1 value for how fast
//we want to change velocity.
//Research: https://gamedev.stackexchange.com/questions/73361/understanding-the-seek-steering-behavior
scalar = 0.05;
steering = steering.multiply_scalar(scalar);

//mass = 1;
//steering = steering.multiply_scalar(steering.magnitude() / mass);


//WE NO LONGER ADD OUR ACTUAL STEERING
//VECTOR, BECAUSE WE ACCELERATE IN THE DIRECTION WE 
//ARE FACING.
vel_vec = vel_vec.clamp_magnitude(vel_vec.add(steering), max_speed)


//LD's Research for this section:
//https://gamedev.stackexchange.com/questions/149875/how-can-i-apply-steering-behaviors-to-a-car-controlled-with-turning-and-accelera
#region turning
//var maxSteerAngleInRad = 2 * pi / 180;

//var fullSteers = arccos(Vector2.dot(desired_velocity.normalized(), vel_vec.normalized())) / maxSteerAngleInRad
//var steerAngle = fullSteers * (sign(Vector2.dot(desired_velocity.left_perp(), vel_vec)))

//steerAngle = clamp(steerAngle, -1, 1);



//image_angle = radtodeg(steerAngle);
//direction = image_angle;

#endregion

//Acceleration.
//if (desired_velocity.magnitude() > vel_vec.magnitude())
//vel_vec = vel_vec.clamp_magnitude(vel_vec.add(Vector2.angle_to_vector(image_angle).normalized().multiply_scalar(acceleration)), max_speed)



x += vel_vec.x;
y += vel_vec.y;

#endregion

//x+= lengthdir_x(car_speed, image_angle)
//y+= lengthdir_y(car_speed, image_angle)

//mp_potential_step_object(path_get_point_x(track_path, i), track
//Path using car_speed
//mp_potential_step(target_x, target_y, car_speed, false);


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