/// @description Insert description here
// You can write your code in this editor

image_xscale = 5;
image_yscale = 5;


//this only spawns enemy cars
function spawn_car() 
{
	var _inst = instance_create_layer(x, y, "Instances", obj_enemy)
	_inst.image_angle = image_angle;
	_inst.direction = image_angle;
}