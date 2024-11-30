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
			layer_sequence_play(_sequences[i])
		}
	}
}