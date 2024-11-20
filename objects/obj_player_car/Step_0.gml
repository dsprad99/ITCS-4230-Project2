/// @description Insert description here
// You can write your code in this editor

#region underglow

if (should_draw)
{

	//LD Montello
	//Draw underglow
	layer_sprite_x(ug1, x);
	layer_sprite_y(ug1, y);
	layer_sprite_xscale(ug1, image_xscale);
	layer_sprite_yscale(ug1, image_yscale);
	layer_sprite_alpha(ug1, 1)

}
else
{
	layer_sprite_alpha(ug1, 0)
}


#endregion

//LD Montello
//if we  can't move,
//don't execute the step event.
if (!can_move)
{
	return;
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
		
		//reset player car to last checkpoint.
		reset_to_last_checkpoint_delayed();
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
	
	//used to make sure we were
	//drawing the line from the center 
	//of the ramp, this whole if statement
	//used to be in "Draw End"
	//draw_line(x, y, x - proj_vec[0], y - proj_vec[1]);
}
else if (!is_falling and image_xscale != 5 and image_yscale != 5)
{
	image_xscale = 5;
	image_yscale = 5;
}


//LD Montello
//if the angle difference
//between our velocity and 
//the direction we're facing
//is large enough, then play
//the particles for drifting.
if (!is_falling and !is_jumping and abs(angle_difference(vector_to_angle(vel_vec), image_angle)) >= 15)
{
	play_drift_particles();
}

if (!is_falling and !place_meeting(x, y, checkered_obj)) {
    pass_thru = false
}



//James Reneo
//Max_Speed changed
if base_max_speed != prev_base_max_speed {
    // base_max_speed has changed
    show_debug_message("base_max_speed has been updated: " + string(base_max_speed));
    
    // Update max_speed if needed
    max_speed = base_max_speed;
    
    // Update prev_base_max_speed to the current value
    prev_base_max_speed = base_max_speed;
}

//Davis Spradling
//If in tutorial room make in_tutorial true
if (room == tutorial) {
	in_tutorial = true
}
else{
	in_tutorial = false
}




//Davis Spradling
//If up key is pressed accelerate car in a forward motion
if (!is_falling and !is_jumping and !is_colliding and (keyboard_check(vk_up) || keyboard_check(ord("W")))){
    //car_speed+=acceleration;
    //if(car_speed>max_speed){
	//	car_speed = max_speed; 
	//}
	
	//if we're not moving,
	//decide what "gear" we're
	//in by setting is_reversing to false.
	//this tells the code for reversing
	//to know that it needs to brake
	//to a stop before switching to actually
	//reversing.
	if (magnitude(vel_vec) == 0)
	{
		is_reversing = false;
	}
	
	//Before we start driving forwards 
	//if we're reversing, we need to slow
	//down to zero before
	//we can switch into drive to go forward.
	if (is_reversing)
	{
		brake();
	}
	else
	{
		vel_vec[0] += lengthdir_x(acceleration, image_angle);
		vel_vec[1] += lengthdir_y(acceleration, image_angle); 
		vel_vec = clamp_magnitude(vel_vec, -max_speed, max_speed);
	}
	
	press_up = true;
}
else
{
	press_up = false;
}

//Davis Spradling
//If down key is pressed declerate car
if(!is_falling and !is_jumping and !is_colliding and ( keyboard_check(vk_down) || keyboard_check(ord("S")))){
    
	
	if (magnitude(vel_vec) == 0)
	{
		is_reversing = true;
	}
	
	
	//Before we start reversing in our backwards direction,
	//our velocity must first slow down to 0.
	if (!is_reversing)
	{
		brake();
	}
	else
	{
		//apply acceleration to velocity.
		vel_vec[0] -= lengthdir_x(acceleration, image_angle);
		vel_vec[1] -= lengthdir_y(acceleration, image_angle); 
		vel_vec = clamp_magnitude(vel_vec, -max_speed, max_speed);
	}
	
	
	
	//car_speed -= acceleration;
    //if (car_speed< -max_speed){
	//	car_speed = -max_speed; 
	//}
	//press_up = false;
	press_down = true;
}
else
{
	//press_up = true;
	press_down = false;
}

//breaking
if (!is_falling and !is_jumping and keyboard_check(vk_space))
{
	brake();
}



//Davis Spradling
//Apply firction when slowing down to help stop the car when decelerating
if(!is_falling and !is_jumping and !keyboard_check(vk_up) && !keyboard_check(vk_down) && !keyboard_check(ord("W")) && !keyboard_check(ord("S"))){
    
	//Note the sign flips a value to 1 if pos and 0 if not
	//this will help with deciding if the car is going forward/backward
	//thus slowing the car down each way and applying friction
	//car_speed -= sign(car_speed)*car_friction;
    //if (abs(car_speed)<car_friction){
	//	car_speed=0; 
	//}
	
	
	vel_vec[0] -= sign(vel_vec[0])*car_friction;
	vel_vec[1] -= sign(vel_vec[1])*car_friction;
	if (abs(magnitude(vel_vec))<car_friction){
		vel_vec[0] = 0;
		vel_vec[1] = 0;
	}
	
	
}




//Davis Spradling
//Give player ability to steer but only if the car is moving
//Steer Left
if (!is_falling and !is_jumping and (keyboard_check(vk_right) || keyboard_check(ord("D"))) ) {
    
	image_angle -= turn_speed; 
}

//Davis Spradling
//Steer Right
if (!is_falling and !is_jumping and (keyboard_check(vk_left) || keyboard_check(ord("A"))) ) {
    image_angle += turn_speed;
}

image_angle = image_angle % 360;



//LD Montello
//The intention of traction
//is for max traction
//to cancel out momentum when turning
//So, if you turn, the momentum that would
//normally push you right or left will be canceled
//out.
#region traction application

//traction should only apply when moving.
var forward_vec = angle_to_vector(image_angle);
var target_vec = clamp_vector_to_direction(vel_vec, forward_vec);
vel_vec[0] = lerp(vel_vec[0], target_vec[0], traction)
vel_vec[1] = lerp(vel_vec[1], target_vec[1], traction)
//var drift = subtract(vel_vec, target_vec);

//var left_vec = angle_to_vector(image_angle + 90)
//var left_constricted = clamp_vector_to_direction(vel_vec, left_vec);

//vel_vec = subtract(vel_vec, multiply_scalar(left_constricted, traction));

//vel_vec = add(target_vec, multiply_scalar(drift, (1 - traction)));

#endregion


//LD Montello
//Do collision resolution 
//algorithm.
collision_resolution();



//new Vector2(lengthdir_x(vel_vec[0], image_angle), lengthdir_y(vel_vec[1], image_angle))
	
//vel_vec = vel_vec.multiply_scalar(prev_vel);
	
//Davis Spradling
//Update car object based on curr speed and the angle of the the object
//LD Montello
//apply velocity to current
//position.
x += vel_vec[0];
y += vel_vec[1];

#region draw arrow for velocity debug

//calculate velocity using 
//current and previous position
//and convert it to an angle using point_direction.
//layer_sprite_angle(arrow, point_direction(xprevious, yprevious, x, y));

//LD Montello
//Draw velocity arrow
//layer_sprite_x(arrow, x);
//layer_sprite_y(arrow, y);

#endregion



//Set previous velocity
prev_vel = vel_vec;