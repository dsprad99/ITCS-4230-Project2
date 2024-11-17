/// @description Insert description here
// You can write your code in this editor

//LD Montello
//if we  can't move,
//don't execute the step event.
if (!can_move)
{
	return;
}

if (!place_meeting(x, y, checkered_obj)) {
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
if (keyboard_check(vk_up) || keyboard_check(ord("W"))){
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
if(keyboard_check(vk_down) || keyboard_check(ord("S"))){
    
	
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
if (keyboard_check(vk_space))
{
	brake();
}

//Davis Spradling
//Apply firction when slowing down to help stop the car when decelerating
if(!keyboard_check(vk_up) && !keyboard_check(vk_down) && !keyboard_check(ord("W")) && !keyboard_check(ord("S"))){
    
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
if ((keyboard_check(vk_right) || keyboard_check(ord("D"))) ) {
    
	image_angle -= turn_speed; 
}

//Davis Spradling
//Steer Right
if ((keyboard_check(vk_left) || keyboard_check(ord("A"))) ) {
    image_angle += turn_speed;
}

image_angle = image_angle % 360;






if (!is_nan(vel_vec[0]) and !is_nan(vel_vec[1]))
{

if (cur_traction >= 1)
{
	cur_traction = traction;
}
else
{
	cur_traction += traction;
}

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


#region collision handling.

//LD Montello, if we 
//hit a track wall.
if (place_meeting(x+vel_vec[0], y+vel_vec[1], bounceables))
{
	//LD Montello,
	//finding the normal vector
	//of the object we hit,
	//just find the direction from the other
	//object to us.
	//normal = //[(x+vel_vec[0]) - x, (y+vel_vec[1]) - y]
	normal_x = x+vel_vec[0];
	normal_y = y+vel_vec[1];
	
	//where LD found the code to get the normal
	//https://web.archive.org/web/20230810151732/https://www.gmlscripts.com/script/collision_normal
	var angle = collision_normal(x+vel_vec[0], y+vel_vec[1], bounceables, 32 * 2, 1);
	if (angle != -1)
	{
		normal = angle_to_vector(angle);
	}

	
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
	vel_vec = multiply_scalar(vel_vec, -1);
	
	var reflected = reflect(vel_vec, normalized(normal));
	
	vel_vec = clamp_magnitude(reflected, -max_speed, max_speed)
	
	//this is for handling
	//when the car rotates and could
	//clip into an object.
	//we always add the normal vector if
	//we hit something.
	vel_vec = add(vel_vec, multiply_scalar(normalized(normal), 1));
}  



//LD Montello, if we hit an enemy car,
//let that car push us, or bounce out 
//of it's way.
//LD Montello
//Research:https://stackoverflow.com/questions/1736734/circle-circle-collision
var _inst = instance_place(x + vel_vec[0], y + vel_vec[1], obj_enemy);
if (_inst != noone)
{

	//get collision direction.
	var _dir = [_inst.x - x, _inst.y - y];

    //var normal_x = dx / distance;
	//var normal_y = dy / distance;
		
	//Calculate overlap (for circle collision)
	//we'll say the radius is 24 for now.
	var car_radius = 24;
	var overlap = max(0, car_radius * 2 - magnitude(_dir));

	//normalize the direction
	_dir = normalized(_dir);

	//Resolve the overlap
	if (overlap > 0)
	{
	    vel_vec[0] += overlap * _dir[0];
	    vel_vec[1] += overlap * _dir[1];
	}

	//Project velocity onto the collision direction
	var self_proj = vel_vec[0] * _dir[0] + vel_vec[1] * _dir[1];

	//LD Montello
	//Adjust only enough velocity to resolve collision
	//it took me lots of trial and error to figure
	//this out.
	if (self_proj > 0)
	{
		//0.5 because the other car in the collision 
		//will also do this calculation.
	    var resolve_factor = 0.5; 
	    vel_vec[0] -= self_proj * _dir[0] * resolve_factor;
	    vel_vec[1] -= self_proj * _dir[1] * resolve_factor;
	}
}

#endregion

//new Vector2(lengthdir_x(vel_vec[0], image_angle), lengthdir_y(vel_vec[1], image_angle))
	
//vel_vec = vel_vec.multiply_scalar(prev_vel);
	
//Davis Spradling
//Update car object based on curr speed and the angle of the the object
x += vel_vec[0];
y += vel_vec[1];
}
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

#region underglow

//LD Montello
//Draw underglow
layer_sprite_x(ug1, x);
layer_sprite_y(ug1, y);

#endregion

//Set previous velocity
prev_vel = vel_vec;