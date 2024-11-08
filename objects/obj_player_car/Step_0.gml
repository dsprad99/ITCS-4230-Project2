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
	
	vel_vec.x += lengthdir_x(acceleration, image_angle);
	vel_vec.y += lengthdir_y(acceleration, image_angle); 
	vel_vec = vel_vec.clamp_magnitude(-max_speed, max_speed);
	
	press_up = true;
}
else
{
	press_up = false;
}

//Davis Spradling
//If down key is pressed declerate car
if(keyboard_check(vk_down) || keyboard_check(ord("S"))){
    
	//apply acceleration to velocity.
	vel_vec.x -= lengthdir_x(acceleration, image_angle);
	vel_vec.y -= lengthdir_y(acceleration, image_angle); 
	vel_vec = vel_vec.clamp_magnitude(-max_speed, max_speed);
	
	//car_speed -= acceleration;
    //if (car_speed< -max_speed){
	//	car_speed = -max_speed; 
	//}
	press_up = false;
}
else
{
	press_up = true;
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
	
	
	vel_vec.x -= sign(vel_vec.x)*car_friction;
	vel_vec.y -= sign(vel_vec.y)*car_friction;
	if (abs(vel_vec.magnitude())<car_friction){
		vel_vec.x = 0;
		vel_vec.y = 0;
	}
	
	
}


//Davis Spradling
//Give player ability to steer but only if the car is moving
//Steer Left
if ((keyboard_check(vk_right) || keyboard_check(ord("D"))) && vel_vec.magnitude()!=0) {
    
	image_angle -= turn_speed; 
	
	//Check if we are currently intersecting
	//a wall, and if we are, push us out of it.
	if (place_meeting(x, y, bounceables))
	{
		//We would be hitting the wall at this angle,
		//so rotate back to the previous position,
		//so we aren't clipping into the wall.
		image_angle += turn_speed;
		
		//Move us away from the wall we were hitting.
		var dirVec = Vector2.angle_to_vector(image_angle);
		dirVec = dirVec.normalized().multiply_scalar(acceleration);
	}
	
	
}

//Davis Spradling
//Steer Right
if ((keyboard_check(vk_left) || keyboard_check(ord("A"))) && vel_vec.magnitude()!=0) {
    image_angle += turn_speed;
	
	//Check if we are currently intersecting
	//a wall, and if we are, push us out of it.
	if (place_meeting(x, y, bounceables))
	{
		//We would be hitting the wall at this angle,
		//so rotate back to the previous position,
		//so we aren't clipping into the wall.
		image_angle -= turn_speed;
		
		//Move us away from the wall we were hitting.
		var dirVec = Vector2.angle_to_vector(image_angle);
		dirVec = dirVec.normalized().multiply_scalar(acceleration);
	}
}

image_angle = image_angle % 360;

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



//LD Montello, if we hit an enemy car,
//let that car push us, or bounce out 
//of it's way.
var _inst = instance_place(x, y, obj_enemy)
if (_inst != noone)
{
	//Decrease speed of car,
	vel_vec.multiply_scalar(0);
	//add speed of the car we hit.
	//that way we are pushed by it.
	//vel_vec.add(new Vector2(1,1).normalized().multiply_scalar(_inst.car_speed));
	//Calculate vector from our car to the other car,
	//to make sure we can't collide
	var newVec = new Vector2(x - _inst.x, y - _inst.y);
	//Normalize the vector, and multiply it's scale by 2
	//so you bounce off at a speed of 2
	vel_vec.add(newVec.normalized().multiply_scalar(4));
}



if (!is_nan(vel_vec.x) and !is_nan(vel_vec.y))
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
if (press_up or press_down) {

	//show_message("HERE");
	var prev_vel = vel_vec.magnitude();
	var target_vec = Vector2.angle_to_vector(image_angle).multiply_scalar(prev_vel);
	
	vel_vec.x = lerp(vel_vec.x, target_vec.x, traction)
	vel_vec.y = lerp(vel_vec.y, target_vec.y, traction)

}

#endregion

//new Vector2(lengthdir_x(vel_vec.x, image_angle), lengthdir_y(vel_vec.y, image_angle))
	
//vel_vec = vel_vec.multiply_scalar(prev_vel);
	
//Davis Spradling
//Update car object based on curr speed and the angle of the the object
x += vel_vec.x;
y += vel_vec.y;
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