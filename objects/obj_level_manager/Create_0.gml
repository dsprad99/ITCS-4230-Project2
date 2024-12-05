/// @description Insert description here
// You can write your code in this editor

//LD Montello
//used to store the current_time
//when the game was paused,
//so that we can calculate how much
//time has passed
//to properly set the race controller's start_time
//when unpausing so that it
//appears no time has passed.
time_when_paused = 0;

//Store the FX struct, and its parameters struct, in variables
pause_fx = layer_get_fx("PauseGreyOutEffect");

function pause()
{
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
		
		//LD Montello
		//Tint the entire screen with grey so that it appears paused.
		fx_set_parameter(pause_fx, "g_TintCol", [0.8, 0.8, 0.8])
		
		//LD Montello
		//Activate the pause UI so that it is
		//visible and interactible
		instance_activate_object(obj_pause_UI);
		instance_activate_object(obj_quit_to_menu_button);
		instance_activate_object(obj_resume_button);
		
		//LD Montello
		//Pause all audio.
		audio_pause_all();
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
		
		//LD Montello
		//reset the tint effect to be completely white.
		fx_set_parameter(pause_fx, "g_TintCol", [1, 1, 1])
		
		//LD Montello
		//Deactivate the pause UI so that it is
		//invisible and can't be interacted with.
		instance_deactivate_object(obj_pause_UI);
		instance_deactivate_object(obj_quit_to_menu_button);
		instance_deactivate_object(obj_resume_button);
		
		//LD Montello
		//Resume all audio.
		audio_resume_all();
	}
}



