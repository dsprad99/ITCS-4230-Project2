/// @description Init all particle systems
// You can write your code in this editor

//https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Data_Structures/DS_Lists/ds_list_create.htm#:~:text=If%20you%20wish%20to%20ensure,list%20slots%20will%20be%20undefined.
//Create a large array
//for allocating particle systems
//during gameplay
arr_psystems = array_create(100)

//LD Montello
//Game maker does a horrible job
//of explaining how to use it's particle systems.
//They make it seem like creating a system 
//is really bad for performance because there's no
//garbage collection.
//It took me ~4 hours to figure out that I can
//just check if there are any particles remaining
//in the system and if there are destroy it.
//For more info, check the step function.
play_particle_system = function(_p_system, x, y)
{
	//Create a non-persistent particle system on the FX layer and
	//Push the new particle system to the end of our list.
	array_push(arr_psystems, part_system_create_layer("FX", false, _p_system))
	
	//The newly created system will be at the end of the current aray
	var psystem = arr_psystems[array_length(arr_psystems) - 1]
	
	//Set the position of the newly created system 
	//to be the given position
	part_system_position(psystem, x, y);
}

//override for choosing a specific layer to use
play_particle_system_layer = function(_layer, _p_system, x, y)
{
	//Create a non-persistent particle system on the FX layer and
	//Push the new particle system to the end of our list.
	array_push(arr_psystems, part_system_create_layer(_layer, false, _p_system))
	
	//The newly created system will be at the end of the current aray
	var psystem = arr_psystems[array_length(arr_psystems) - 1]
	
	//Set the position of the newly created system 
	//to be the given position
	part_system_position(psystem, x, y);
}

play_particle_system_angle = function(_p_system, x, y, _angle)
{
	//Create a non-persistent particle system on the FX layer and
	//Push the new particle system to the end of our list.
	array_push(arr_psystems, part_system_create_layer("FX", false, _p_system))
	
	//The newly created system will be at the end of the current aray
	var psystem = arr_psystems[array_length(arr_psystems) - 1]
	
	//Set the position of the newly created system 
	//to be the given position
	part_system_position(psystem, x, y);
	part_system_angle(psystem, _angle)
}

//override for choosing a specific layer to use
play_particle_system_layer_angle = function(_layer, _p_system, x, y, _angle)
{
	//Create a non-persistent particle system on the FX layer and
	//Push the new particle system to the end of our list.
	array_push(arr_psystems, part_system_create_layer(_layer, false, _p_system))
	
	//The newly created system will be at the end of the current aray
	var psystem = arr_psystems[array_length(arr_psystems) - 1]
	
	//Set the position of the newly created system 
	//to be the given position
	part_system_position(psystem, x, y);
	part_system_angle(psystem, _angle);
}