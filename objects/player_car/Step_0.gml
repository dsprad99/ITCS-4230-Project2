/// @description Insert description here
// You can write your code in this editor

if (!place_meeting(x, y, checkered_obj)) {
    pass_thru = false
}

//Davis Spradling
//If up key is pressed accelerate car in a forward motion
if (keyboard_check(vk_up) || keyboard_check(ord("W"))){
    car_speed+=acceleration;
    if(car_speed>max_speed){
		car_speed = max_speed; 
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
    car_speed -= acceleration;
    if (car_speed< -max_speed){
		car_speed = -max_speed; 
	}
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
	car_speed -= sign(car_speed)*car_friction;
    if (abs(car_speed)<car_friction){
		car_speed=0; 
	}
}


//Davis Spradling
//Give player ability to steer but only if the car is moving
//Steer Left
if ((keyboard_check(vk_right) || keyboard_check(ord("A"))) && car_speed!=0) {
    image_angle -= turn_speed; 
}

//Davis Spradling
//Steer Right
if ((keyboard_check(vk_left) || keyboard_check(ord("D"))) && car_speed!=0) {
    image_angle += turn_speed; 
}


//LD Montello, if we 
//hit a track wall.
if (place_meeting(x /*+ lengthdir_x(car_speed, image_angle)*/, y /*+ lengthdir_y(car_speed, image_angle)*/, wallTileID))
{
	//Davis Spradling
	//This will act as the outline of our track and will make the 
	//player bounce off the wall it hits
	//LD Montello,
	//just apply opposite speed so we bounce
	//of in the direction we entered.
	var enter_speed = car_speed;
	car_speed = -enter_speed;
}

//Davis Spradling
//Update car object based on curr speed and the angle of the the object
x += lengthdir_x(car_speed, image_angle);
y += lengthdir_y(car_speed, image_angle);   

#region draw arrow for velocity debug

//calculate velocity using 
//current and previous position
//and convert it to an angle using point_direction.
layer_sprite_angle(arrow, point_direction(xprevious, yprevious, x, y));

//LD Montello
//Draw velocity arrow
layer_sprite_x(arrow, x);
layer_sprite_y(arrow, y);

#endregion