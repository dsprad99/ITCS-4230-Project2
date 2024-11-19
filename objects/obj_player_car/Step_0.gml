/// @description Insert description here
// You can write your code in this editor

#region underglow

if (should_draw)
{

	//LD Montello
	//Draw underglow
	layer_sprite_x(ug1, x);
	layer_sprite_y(ug1, y);
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


//if the angle difference
//between our velocity and 
//the direction we're facing
//is large enough, then play
//the particles for drifting.
if (abs(angle_difference(vector_to_angle(vel_vec), image_angle)) >= 15)
{
	play_drift_particles();
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
if (!is_colliding and (keyboard_check(vk_up) || keyboard_check(ord("W")))){
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
if(!is_colliding and ( keyboard_check(vk_down) || keyboard_check(ord("S")))){
    
	
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


   //normal_x = x + vel_vec[0];
   //normal_y =  y + vel_vec[1];

//LD Montello, if we 
//hit a track wall.
//// Get the car's 4 corners based on its position and rotation (image_angle)
//var half_width = sprite_width / 2;
//var half_height = sprite_height / 2;

//// Car's center point (current position)
//var cx = x;
//var cy = y;

//// Calculate each corner relative to the center, rotated by image_angle
//var corners = [
//    [cx + dcos(-image_angle) * half_width - dsin(-image_angle) * half_height, cy + dsin(-image_angle) * half_width + dcos(-image_angle) * half_height], // Top-right corner
//    [cx - dcos(-image_angle) * half_width - dsin(-image_angle) * half_height, cy - dsin(-image_angle) * half_width + dcos(-image_angle) * half_height], // Top-left corner
//    [cx - half_width * dcos(-image_angle) + half_height * dsin(-image_angle), cy - half_width * dsin(-image_angle) - half_height *  dcos(-image_angle)], // Bottom-left corner
//    [cx + half_width * dcos(-image_angle) + half_height * dsin(-image_angle), cy + half_width * dsin(-image_angle) - half_height * dcos(-image_angle)]  // Bottom-right corner
//];

//// Store original velocity vector for sliding and restoring speed later
//var original_vel_vec = [vel_vec[0], vel_vec[1]];

//// Get the target position (car's next position after applying velocity)
//var target_x = x + vel_vec[0];
//var target_y = y + vel_vec[1];


//// Check if the car will collide at the target position (using place_meeting)
//if (place_meeting(target_x, target_y, bounceables)) {
    
//	is_colliding = true;
	
//    // Get the collision normal (this is the direction we need to offset the car)
//    normal = angle_to_vector(collision_normal(x, y, bounceables, 32 * 5, 1));
    
//    // Track maximum penetration and direction to resolve collision
//    var penetration = 0;
//    var max_penetration = 0;
//    var step_size = 1;  // Increment size for offsetting position gradually
    
//    // Check each corner for collision and calculate the overlap with the normal
//    for (var i = 0; i < 4; i++) {
//        var corner = corners[i];
        
//        // If the corner is colliding with a wall
//        if (place_meeting(corner[0] + vel_vec[0], corner[1] + vel_vec[1], bounceables)) {
//            // Calculate the penetration depth in the direction of the normal
//            var penetration_depth = point_distance(corner[0], corner[1], target_x, target_y) - point_distance(x, y, corner[0], corner[1]);  // Distance to target position
//            penetration = max(penetration, penetration_depth); // Track maximum penetration depth
//        }
//    }
    
//    // Step back from collision based on the maximum penetration and normal
//    if (penetration > 0) {
//        x += normal[0] * penetration; // Offset position along the normal direction
//        y += normal[1] * penetration;
//    }
    
//    // Reflect the velocity vector based on the collision normal (bounce effect)
//    //var dp = dot(vel_vec, normal);
//    //vel_vec[0] -= 2 * dp * normal[0];
//    //vel_vec[1] -= 2 * dp * normal[1];
    
//    //// Calculate the tangent vector (perpendicular to the normal)
//    //var tangent = [-normal[1], normal[0]];

//    //// Project velocity onto the tangent to achieve sliding effect
//    //var dot_tangent = dot(vel_vec, tangent);
//    //var slide_vec = [dot_tangent * tangent[0], dot_tangent * tangent[1]];

//    //// Maintain the original speed magnitude
//    //var original_speed = point_distance(0, 0, original_vel_vec[0], original_vel_vec[1]);
//    //vel_vec[0] = slide_vec[0];
//    //vel_vec[1] = slide_vec[1];

//    //// Re-normalize velocity and scale to maintain original speed
//    //var slide_speed = point_distance(0, 0, vel_vec[0], vel_vec[1]);
//    //if (slide_speed > 0) {
//    //    vel_vec[0] *= (original_speed / slide_speed);
//    //    vel_vec[1] *= (original_speed / slide_speed);
//    //}
    
//}
//else
//{
//	is_colliding = false;
//}






//LD Montello, if we hit an enemy car,
//let that car push us, or bounce out 
//of it's way.
//LD Montello
//Research:https://stackoverflow.com/questions/1736734/circle-circle-collision
var _inst = instance_place(x + vel_vec[0], y + vel_vec[1], obj_enemy);
if (_inst != noone)
{
	normal = angle_to_vector(collision_normal(x + vel_vec[0], y + vel_vec[1], obj_enemy, 32 * 2, 1));

	vel_vec = add(vel_vec, normalized(normal));

	////get collision direction.
	//var _dir = [_inst.x - x, _inst.y - y];

    ////var normal_x = dx / distance;
	////var normal_y = dy / distance;
		
	////Calculate overlap (for circle collision)
	////we'll say the radius is 24 for now.
	//var car_radius = 24;
	//var overlap = max(0, car_radius * 2 - magnitude(_dir));

	////normalize the direction
	//_dir = normalized(_dir);

	////Resolve the overlap
	//if (overlap > 0)
	//{
	//    vel_vec[0] += overlap * _dir[0];
	//    vel_vec[1] += overlap * _dir[1];
	//}

	////Project velocity onto the collision direction
	//var self_proj = vel_vec[0] * _dir[0] + vel_vec[1] * _dir[1];

	////LD Montello
	////Adjust only enough velocity to resolve collision
	////it took me lots of trial and error to figure
	////this out.
	//if (self_proj > 0)
	//{
	//	//0.5 because the other car in the collision 
	//	//will also do this calculation.
	//    var resolve_factor = 0.5; 
	//    vel_vec[0] -= self_proj * _dir[0] * resolve_factor;
	//    vel_vec[1] -= self_proj * _dir[1] * resolve_factor;
	//}
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



//Set previous velocity
prev_vel = vel_vec;