/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if (instance_exists(obj_player_car))
{
	//traction is a 0-1 value
	//so we just set traction
	//to be the current value.
	obj_player_car.traction = cur_value;
}