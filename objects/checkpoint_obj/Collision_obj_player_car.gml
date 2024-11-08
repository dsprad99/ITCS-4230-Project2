/// @description Insert description here
// You can write your code in this editor


//Davis Spradling
//show_message("Checkpoint complete");
//Be used for when in tutorial room to know if a checkpoint is for a tutorial or
//needs to be ignored for regular game
if(tutorial_check_bool){
	//function to pull up popup
	
	//var new_tut_next = instance_create_layer(obj_player_car.x, obj_player_car.y+300, "Instances", tutorial_next_button_obj);
	//new_tut_next.image_xscale = 1;
	//new_tut_next.image_yscale = 1;
	
	var new_check = instance_create_layer(obj_player_car.x, obj_player_car.y, "Instances", checkpoint_msg_obj);
	new_check.image_xscale = 1.8;
	new_check.image_yscale = 1.8;
	
	//new_check.text_to_draw = text
	
	
	//Be used to break up the instructions into three different lines
	//for readability
	var words_array = string_split(text, " ");

	// Calculate the total number of words
	var total_words = array_length(words_array);
	var third = total_words div 3;

	var var1 = "";
	var var2 = "";
	var var3 = "";
	
	for (var i = 0; i < total_words; i++) {
	    if (i < third) {
	        var1 += words_array[i] + " ";
	    } else if (i < third * 2) {
	        var2 += words_array[i] + " ";
	    } else {
	        var3 += words_array[i] + " ";
	    }
}
	
	checkpoint_msg_obj.txt1 = var1;
	checkpoint_msg_obj.txt2 = var2;
	checkpoint_msg_obj.txt3 = var3;
	
	obj_player_car.can_move = false;
	
	
	
	tutorial_check_bool = false;
}

//Davis Spradling
//Logic for keep track of player going through checkpoints
if(tutorial_check_bool and obj_player_car.tutorial_check_1){
	if(!array_contains(obj_player_car.checkpoints_curr, checkpoint)) {
		array_push(obj_player_car.checkpoints_curr, checkpoint);
	}
	show_debug_message(obj_player_car.checkpoints_curr)
	
}
else{
	show_debug_message("nope");
}