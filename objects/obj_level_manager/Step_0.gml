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
	}
	else
	{
		//LD Montello
		//add the time since
		//we paused the game to the start
		//time so it appears as though
		//no time has passed.
		obj_race_controller.start_time += (current_time - time_when_paused);
	}
}