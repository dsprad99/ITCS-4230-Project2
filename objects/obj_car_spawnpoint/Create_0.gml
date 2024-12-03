/// @description Insert description here
// You can write your code in this editor




//LD Montello
//is there already
//a car occupying this slot?
slot_taken = false;

image_xscale = 5;
image_yscale = 5;

//if we're the player's
//slot, indicate that using a boolean.
if (global.player_start_slot == slot_index)
{
	slot_taken = true;
}

//this only spawns enemy cars
function spawn_car() 
{
	//LD Montello
	//move the player car here instead
	//of an enemy.
	if (slot_taken)
	{
		obj_player_car.x = x;
		obj_player_car.y = y;
		obj_player_car.direction = image_angle;
		obj_player_car.image_angle = image_angle;

		return;
	}
	
	var _inst = instance_create_layer(x, y, "Instances", obj_enemy)
	_inst.image_angle = image_angle;
	_inst.direction = image_angle;
}