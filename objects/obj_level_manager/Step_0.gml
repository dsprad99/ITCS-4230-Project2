if keyboard_check_pressed(vk_escape) {
	//game_end();
	global.paused = !global.paused;
	if (global.paused)
	{
		//LD Montello
		//store the current time
		//when we pause so it can be used
		//to calculate how much time has passed
		//when we unpause.
		time_when_paused = current_time;
		
		//LD Montello
		//get all the sequences
		//in the game.
		var _sequences = get_all_sequences();
		
		//LD Montello
		//for all the sequences pause them.
		for (var i = 0; i < array_length(_sequences); i++)
		{
			layer_sequence_pause(_sequences[i])
		}
		
		//LD Montello
		//Set all images speed
		//to 0 to pause them.
		with (all)
		{
			image_speed = 0;
		}
		
		//LD Montello
		//turn off auto-update
		//for all particle systems
		//so they appear frozen.
		for (var i = 0; i < array_length(obj_particle_sys_controller.arr_psystems); i++)
		{
			if (part_system_exists(obj_particle_sys_controller.arr_psystems[i]))
			part_system_automatic_update(obj_particle_sys_controller.arr_psystems[i], false);
		}
	}
	else
	{
		//LD Montello
		//add the time since
		//we paused the game to the start
		//time so it appears as though
		//no time has passed.
		obj_race_controller.start_time += (current_time - time_when_paused);
		
		//LD Montello
		//get all the sequences
		//in the game.
		var _sequences = get_all_sequences();
		
		//LD Montello
		//for all the sequences resume them.
		for (var i = 0; i < array_length(_sequences); i++)
		{
			//LD Montello
			//if a sequence already finished, don't
			//play it again.
			if (!layer_sequence_is_finished(_sequences[i]))
				layer_sequence_play(_sequences[i])
		}
		
		//LD Montello
		//Set all images speed
		//back to 1.
		//Ideally, we'd use an array
		//to store their pre-pause speed
		//speed and restore it here.
		with (all)
		{
			image_speed = 1;
		}
		
		//LD Montello
		//turn on auto-update
		//for all particle systems
		//so they continue playing.
		for (var i = 0; i < array_length(obj_particle_sys_controller.arr_psystems); i++)
		{
			if (part_system_exists(obj_particle_sys_controller.arr_psystems[i]))
			part_system_automatic_update(obj_particle_sys_controller.arr_psystems[i], true);
		}
	}
}