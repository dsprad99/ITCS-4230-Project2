/// @description Insert description here
// You can write your code in this editor

//Davis Spradling
//This will check if we have crossed 
//the finish line and gone through all
//the checkpoints


//exit this event if
//we already finished.
if (did_finish)
{
	return;
}

checkpoints_needed = [0,1,2]
show_debug_message(checkpoints_curr)

if(in_tutorial and checkpoints_complete(checkpoints_needed, checkpoints_curr) && other.tutorial_check){
	//Be used to break up the instructions into three different lines
	//for readability
	//var new_tut_next = instance_create_layer(obj_player_car.x, obj_player_car.y+300, "tutorial_popup", next_room_button_obj);
	//new_tut_next.image_xscale = .5;
	//new_tut_next.image_yscale = .5;
	//new_tut_next.room_to = other.room_go
	
	var new_check = instance_create_layer(obj_player_car.x, obj_player_car.y, "tutorial_popup", tut_finish_msg_obj);
	new_check.image_xscale = 1.8;
	new_check.image_yscale = 1.8;
	new_check.room_to = other.room_go
	
	
	var words_array = string_split(other.text, " ");

	// Calculate the total number of words
	var total_words = array_length(words_array);
	var half = total_words div 2;

	var var1 = "";
	var var2 = "";
	
	//Break the text into two seperate lines
	for (var i = 0; i < total_words; i++) {
	    if (i<half) {
	        var1 += words_array[i] + " ";
		}
			else {
	        var2 += words_array[i] + " ";
	    }
}
	
	tut_finish_msg_obj.txt1 = var1;
	tut_finish_msg_obj.txt2 = var2;
	obj_player_car.can_move = false;
	
	other.tutorial_check = false;
}

else if(checkpoints_complete(checkpoints_needed, checkpoints_curr)){
	//show_message("Lap completed");

	//LD Montello
	//Store whatever lap time we're
	//at as the lap time for our current
	//lap 
	if (cur_lap == 1)
	{
		lap1_time = obj_race_controller.time_taken - lap_start_time;
	}
	else if (cur_lap == 2)
	{
		lap2_time = obj_race_controller.time_taken - lap_start_time;
	}
	else if (cur_lap == 3)
	{
		lap3_time = obj_race_controller.time_taken - lap_start_time;
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
		//LD Montello show finish popup.
		if (instance_exists(obj_popup_controller))
		{
			//stop drawing our object.
			should_draw = false;
			obj_popup_controller.show_finish_popup();
			
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
				obj_particle_sys_controller.play_particle_system_angle(ps_cyan_derez_escape, x, y, vector_to_angle(normalized(vel_vec)));
			}
			else
			{
				obj_particle_sys_controller.play_particle_system(ps_cyan_derez_death, x, y);
			}
			
		}
		
		//here we are making sure that
		//when the placements are drawn,
		//we don't overwrite our placement
		//that we finished at with another
		//cars placement by separating them
		//into two lists.
		
		//add ourselves to the finalized list
		//as our placement should no longer change.
		ds_list_add(obj_race_controller.final_placements_list, self);
		//remove ourselves from the priority queue
		ds_priority_delete_value(obj_race_controller.car_placement_queue, self);
		
	}
	else
		cur_lap++;

	//reset the lap start time.
	lap_start_time = obj_race_controller.time_taken;
	
	pass_thru = true
	checkpoints_curr = [];
}
if(!pass_thru){
	car_speed=0;
}


//show_debug_message(checkpoints_curr)


