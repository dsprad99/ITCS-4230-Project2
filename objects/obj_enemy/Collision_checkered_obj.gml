/// @description Insert description here
// You can write your code in this editor

//exit this event if
//we already finished.
if (did_finish)
{
	return;
}

//LD Copied most of this from davis' code.
checkpoints_needed = [0,1,2]
//show_debug_message(checkpoints_curr)


if(checkpoints_complete(checkpoints_needed, checkpoints_curr)){
	//show_message("Lap completed");

	//LD Montello
	//Store whatever lap time we're
	//at as the lap time for our current
	//lap 
	if (cur_lap == 1)
	{
		lap1_time = obj_race_controller.time_taken;
	}
	else if (cur_lap == 2)
	{
		lap2_time = obj_race_controller.time_taken;
	}
	else if (cur_lap == 3)
	{
		lap3_time = obj_race_controller.time_taken;
	}
	
	if (cur_lap == 3)
	{
		//The race should end for the player here,
		//and we should do some waiting for the other
		//cars to finish and then the race controller
		//will know which cars have finished
		//because our car will tell it here that we've
		//finished, we'll do the same thing in the enemies.
		did_finish = true;
		can_move = false;
		
		//stop drawing the car
		should_draw = false;
		
		//LD Montello
		//Draw the "death" particles
		//if they aren't in first,
		//or draw the "escape" particles
		//if they are in first
		//This is because in the "story" of our game,
		//they player's car is racing to escape before
		//the malware can, so the first place winner
		//will always be the one that "escapes".
		//maybe we can make it so that you have to get first
		//on each track to unlock the next?
		//ehh, that may be too much work for such a small
		//amount of time.
		if (ds_list_empty(obj_race_controller.final_placements_list))
		{
			obj_particle_sys_controller.play_particle_system_angle(ps_magenta_derez_escape, x, y, vector_to_angle(normalized(vel_vec)));
		}
		else
		{
			obj_particle_sys_controller.play_particle_system(ps_magenta_derez_death, x, y);
		}
		
		//instance_destroy();
		//add ourselves to the finalized list
		//as our placement should no longer change.
		ds_list_add(obj_race_controller.final_placements_list, self);
		
		//move our position to be out far off from the track.
		
		x = 0;
		y = 0;
		
		//remove ourselves from the priority queue
		ds_priority_delete_value(obj_race_controller.car_placement_queue, self);
			
	}
	else
		cur_lap++;

	
	//pass_thru = true
	checkpoints_curr = [];
}