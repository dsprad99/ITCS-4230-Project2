/// @description Insert description here
// You can write your code in this editor

#region underglow

if (should_draw)
{
	//LD Montello
	//Draw underglow
	layer_sprite_x(ug1, x);
	layer_sprite_y(ug1, y);
	layer_sprite_alpha(ug1, 1);
}
else
{
	layer_sprite_alpha(ug1, 0);
}

#endregion


//LD Montello
//if the game is paused,
//return so we simulate being frozen.
if (global.paused)
{
	return;
}

//if we can't move, 
//don't execute this event.
if (!can_move)
{
	return;
}


//LD Montello
//Update current lap time
//LD Montello
//Store whatever lap time we're
//at as the lap time for our current
//lap 
if (cur_lap == 1)
{
	lap1_time = obj_race_controller.time_taken - lap_start_time;
}
else if (cur_lap == 2)
{
	lap2_time = obj_race_controller.time_taken - lap_start_time;
}
else if (cur_lap == 3)
{
	lap3_time = obj_race_controller.time_taken - lap_start_time;
}

//LD Montello
//if we're
//no longer on a checkered
//object, set the on_checkered_obj
//boolean to false.
if (on_checkered_obj and !place_meeting(x, y, checkered_obj))
{
	on_checkered_obj = false
}

//we only want to start falling
//if the center of our car
//crosses over into the fall
//object, basically,
//if the center of mass is
//on the fall object, we should
//only fall then.
//that way there can be close
//calls and forgiveness for the player.
if (!is_falling)
	cur_fall_obj = collision_point(x, y, fall_obj, true, true)
	

if (cur_fall_obj != noone)
{
	//LD Montello
	//Do the shrinking animation
	//and slow down velocity.
	//vel_vec = [0,0];
	is_falling = true;
	
	
	//reset_to_last_checkpoint();
}

if (is_falling)
{
	//if we aren't fully overlapping
	//our current fall object,
	//make sure we are fully overlapping
	//it.
	if (!is_fully_overlapping)
		fully_overlap_object();
	
	is_jumping = false;
	cur_fall_time++;
	
	//scale car to zero
	//to visualize falling
	image_xscale = lerp(5, 0, cur_fall_time / total_fall_time);
	image_yscale = lerp(5, 0, cur_fall_time / total_fall_time);
	
	//slow down car
	vel_vec = multiply_scalar(vel_vec, 0.9);
	
	//if we've reached the end of our lerp
	if (total_fall_time - cur_fall_time <= 0.1)
	{
		//set scale to 0
		image_xscale = 0;
		image_yscale = 0;
		//reset fall time
		cur_fall_time = 0;
		//say we are no longer falling
		is_falling = false;
		//say we can't move
		can_move = false;
		
		//freeze
		vel_vec = [0,0]
		
		//reset car to last checkpoint.
		reset_to_last_checkpoint_delayed();
		
		//exit this event.
		return;
	}
}

//LD Montello
//check if we're still jumping
if (!is_falling and is_jumping && !place_meeting(x, y, obj_ramp))
{
	//if we aren't on the ramp,
	//set is jumping to false.
	is_jumping = false;
	cur_ramp = noone;
}

//LD Montello
//Change our scale relative to how we're jumping.
if (!is_falling and is_jumping && instance_exists(cur_ramp))
{
	//calculate max distance
	//from centerpoint of
	//the ramp to the outermost corners
	//using pythagorean theorem.
	var max_dist = sqrt((cur_ramp.sprite_width * cur_ramp.sprite_width + cur_ramp.sprite_height * cur_ramp.sprite_height)) / 2;
	//calculate distance from the car to the ramp's center as a vector.
	var dist_vec = [x - cur_ramp.x, y - cur_ramp.y];
	//get the vector of the angle that the ramp is facing
	var dir_vec = angle_to_vector(cur_ramp.image_angle + 90);
	//restrict the distance vector to the direction vector
	//so that we know the distance from the "center line"
	//of the ramp.
	var proj_vec = clamp_vector_to_direction(dist_vec, dir_vec);
	
	
	
	//calculate the percentage from the center that the ramp
	//is at, then invert it, and multiply by our max scale during the jump
	var max_scale = 10;
	var base_scale = 5;
	var new_scale = base_scale + (max_scale - base_scale) * (1 - magnitude(proj_vec) / max_dist);
	image_xscale = new_scale;
	image_yscale = new_scale;
	
	draw_line(x, y, x - proj_vec[0], y - proj_vec[1]);
}
//we only set scale back to 5
//if we aren't falling,
//and we aren't jumping.
else if (!is_falling)
{
	image_xscale = 5;
	image_yscale = 5;
}

//if the angle difference
//between our velocity and 
//the direction we're facing
//is large enough, then play
//the particles for drifting.
if (!is_falling and !is_jumping and abs(angle_difference(vector_to_angle(vel_vec), image_angle)) >= 15)
{
	play_drift_particles();
}

#region pathing


//LD's TODO:
//The commented out code below will find
//the nearest point on the path to our car,
//in the correct driving direction of the track.
//This code is really resource intensive as it loops
//through the entire track and it shouldn't
//I'll have to optimize it. 
//But, basically I need to code something
//that checks if we're either facing the wrong way
//or we're going backwards along the track from our current position.
//then we can run this code.



//var lastDist = point_distance(x, y, target_x, target_y);

////LD Montello,
////loop through the remaining points 
////in the path
//for (var i = 0; i < path_len; i += path_increment)
//{
//	var new_x = path_get_x(track_path, i / path_len)
//	var new_y = path_get_y(track_path, i / path_len) 
	
//	var heading_x = x + lengthdir_x(car_speed, image_angle);
//	var heading_y = y + lengthdir_y(car_speed, image_angle);
//	//show_debug_message(i);
//	//if this is the closest point on the path,
//	//And it is ahead of the current point,
//	//path towards it.
//	var newDist = point_distance(heading_x, heading_y, new_x, new_y);
	
	
	
//	//LD position_empty is where you were.
//	if (current_point < i and position_empty(new_x, new_y) and newDist < lastDist)
//	{
//		//show_message("HERE");
//		lastDist = point_distance(heading_x, heading_y, new_x, new_y);
//		//Reset the nearest point to be the current point
//		current_point = i;
//		target_x = new_x;
//		target_y = new_y;
//	}
	
//	//if we have exceeded the path length,
//	//the path is closed so go back to the beginning
//	//of the path and continue.
//	if (current_point + path_increment > path_len)
//	{
//		//show_message("HERE");
//		//current_point = (current_point + 15) - path_len;
//		current_point++;
		
//		//rollover to next point if we have reached
//		//the "end" of our path.
//		if (current_point - path_len < 1)
//		{
//			current_point = 0;
//		}
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
if (!is_falling and !is_jumping and distance_to_point(target_x,target_y) < arrive_radius)
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

var path_dir = [prev_x - future_x, prev_y - future_y];

left_perp_vec = left_perp(path_dir);
right_perp_vec = right_perp(path_dir);


//Set our target position by
//using our current distance from
//the path, multiplied
//by the normalized perpendicular vector.

left_dist = point_distance(x, y, path_point_x + left_perp_vec[0], path_point_y + left_perp_vec[1]);
right_dist = point_distance(x, y, path_point_x + right_perp_vec[0], path_point_y + right_perp_vec[1])

//if we are on the left side of the path
if (left_dist < right_dist)
{
	left_perp_vec = normalized(left_perp_vec);
	left_perp_vec = multiply_scalar(left_perp_vec, clamp(left_dist, 0, max_dist_from_path));
	
	
	target_x = path_point_x + left_perp_vec[0]
	target_y = path_point_y + left_perp_vec[1]

}
//if we are on the right side of the path
else
{
	right_perp_vec = normalized(right_perp_vec);
	right_perp_vec = multiply_scalar(right_perp_vec, clamp(right_dist, 0, max_dist_from_path));
	
	target_x = path_point_x + right_perp_vec[0]
	target_y = path_point_y + right_perp_vec[1]

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

heading_vec = angle_to_vector(heading);

var targetRot = point_direction(x, y, target_x, target_y);

if (!is_falling and !is_jumping and angle_difference(image_angle, targetRot) > 0)
{
	image_angle -= turn_speed;
	
	////if we're going to intersect
	////when turning, undo the turn.
	//if (place_meeting(x+vel_vec[0], y+vel_vec[1], array_concat(bounceables, [obj_enemy, obj_player_car])))
	//{
	//	image_angle += turn_speed;
	//}
}
else if (!is_falling and !is_jumping and angle_difference(image_angle, targetRot) < 0)
{
	image_angle += turn_speed;
	
	////if we're going to intersect
	////when turning, undo the turn.
	//if (place_meeting(x+vel_vec[0], y+vel_vec[1], array_concat(bounceables, [obj_enemy, obj_player_car])))
	//{
	//	image_angle -= turn_speed;
	//}
}


//Look towards where we want to go,
//NOT our current velocity.
//image_angle = point_direction(x, y, target_x, target_y);
direction = image_angle
#endregion



#region handle car physics

if (!is_falling and !is_jumping and shouldAccel)
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

if (!is_falling and !is_jumping and shouldDeccel)
{
	//Stolen from davis' code.
	car_speed -= acceleration;
    if (car_speed< -max_speed){
		car_speed = -max_speed; 
	}
}

#endregion

#region collision handling




//var goal_x = x + vel_vec.x;
//var goal_y = y + vel_vec.y;

//x += vel_vec.x;
//y += vel_vec.y;

#region steering

#region old steering
steering = custom_arrive()
#endregion

//Arrive code as seen in BOIDS behavior.
//steering = arrive(target_x, target_y);



//LD Montello
//The params for separation
//need to be tuned to make this
//look really good.
#region separation

//only do seperation
//to the point where we stop
//moving, we never want to reverse
//when seperating.
//If a car in front of you stops too
//fast, do you break and then shift into reverse?
//exactly, so just do seperation until we stop.
if (magnitude(vel_vec) > 0)
{

	steering = add(steering, separation());
}
#endregion

#region add the collision avoidance to the steering

//steering = add(steering, collision_avoidance());

#endregion

steering = clamp_magnitude(steering, -max_speed, max_speed);





//WE NO LONGER ADD OUR ACTUAL STEERING
//VECTOR, BECAUSE WE ACCELERATE IN THE DIRECTION WE 
//ARE FACING.
var added_vel = add(vel_vec, steering);

//clamp steering to our current facing direction 
//basically, we have calculated an acceleration
//we want to apply to our velocity,
//but we aren't allowed to apply acceleration
//in any direction other than the car's facing direction,
//so we are just nullifying any values that would
//break our rules. 
added_vel = clamp_vector_to_direction(added_vel, angle_to_vector(image_angle));

//LD needs to make it so any steering
//is clamped to the car's direction
//but that velocity isn't so that
//the cars can drift. 
//then LD just needs to design
//something where the car is aware
//of it's velocity being
//in the wrong direction so that
//it first presses the break to slow down
//until velocity is either 0 or it's
//close enough to the direction the car
//is facing that it can begin accelerating
//once again.
//because technically the line of code
//above essentially makes the AI
//not be able to drift. 


if (!is_falling and !is_jumping)
vel_vec = clamp_magnitude(added_vel, -max_speed, max_speed);



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


//LD Montello 
//Do collision resolution
//only when not jumping/falling.
if (!is_falling and !is_jumping)
	collision_resolution();

x += vel_vec[0];
y += vel_vec[1];

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


