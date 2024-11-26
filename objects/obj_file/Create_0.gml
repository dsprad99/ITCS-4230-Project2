/// @description Insert description here
// You can write your code in this editor

image_xscale = 5;
image_yscale = 5;

//LD Montello
//vars used when lerping image_direction.
//Set to be 1 second based on the game's speed.
total_time = 1*game_get_speed(gamespeed_fps);
cur_time = 0;

//LD Montello
//are we lerping
//backwards
is_reversing = false;

//The max and min
//for randomly selecting 
//the next lerp angles.
angle_max = 45;
angle_min = 15;

//LD Montello
//The current lerp
//angles.
cur_angle_max = random_range(angle_min, angle_max);
cur_angle_min = -1 * random_range(angle_min, angle_max);


min_lerp_speed = 1;
max_lerp_speed = 1.5;


//current lerp speed
cur_lerp_speed = 1//random_range(min_lerp_speed, max_lerp_speed);
//scale lerp speed based on our 
//max angle distance for lerping.
//that way it's the same speed
//the entire time regardless
//of lerp distance between angles.
//this means smaller angles
//are lerping faster
//than larger angles.
cur_lerp_speed_scaled = cur_lerp_speed * ((2*angle_max) / (cur_angle_max + abs(cur_angle_min)))

//scale the total time
//so that it takes the same
//scaled_total_time = total_time * (90 / (cur_angle_max + abs(cur_angle_min)));

//LD Montello
//Recalculate the 
//scaled lerp speed.
function scale_lerp_speed()
{
	//cur_lerp_speed_scaled = cur_lerp_speed * ((cur_angle_max + abs(cur_angle_min)) / 90);
	//scaled_total_time = total_time * (90 / (cur_angle_max + abs(cur_angle_min)));
	
	//we want to increase the speed
	//of the lerp as if the entire
	//lerp distance was 2*angle_max
	//that way it's the "same speed" 
	//the entire time, regardless
	//of the distance between angles.
	//this means smaller angles
	//are lerping faster
	//than larger angles.
	cur_lerp_speed_scaled = cur_lerp_speed * ((2*angle_max) / (cur_angle_max + abs(cur_angle_min)));
}