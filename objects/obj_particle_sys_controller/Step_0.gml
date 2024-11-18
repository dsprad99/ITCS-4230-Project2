/// @description Destroy particle system if it has completed.
// You can write your code in this editor

//loop through all of the existing
//particle systems.
for (i = 0; i < array_length(arr_psystems); i++)
{
	var psystem = arr_psystems[i]
	
	//LD Montello
	//Check if this particle system exists and
	//Check if all particles have been 
	//destroyed then destroy the particle
	//system itself.
	if (part_system_exists(psystem) and part_particles_count(psystem) == 0)
	{
		//LD Montello
		//If you want to make sure the particles are destroyed
		//uncomment the following 2 lines:
		//show_debug_log(true);
		//show_debug_message(psystem/*part_particles_count(psystem)*/)
		
		//Destroy the system
		part_system_destroy(psystem);
		//Remove system (it isn't null yet) from our array
		array_delete(arr_psystems, i, 1)
		
	}	
}

