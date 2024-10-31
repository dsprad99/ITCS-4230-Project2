/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if (instance_exists(obj_player_car))
{
	obj_player_car.acceleration = cur_value;
}