/// @description Insert description here
// You can write your code in this editor
//Davis Spradling
//show_message("Checkpoint complete");

if(tutorial_check_bool){
	//function to pull up popup
	
	var new_tut_next = instance_create_layer(obj_player_car.x, obj_player_car.y+300, "Instances", tutorial_next_button_obj);
	new_tut_next.image_xscale = 1;
	new_tut_next.image_yscale = 1;
	
	var new_check = instance_create_layer(obj_player_car.x, obj_player_car.y, "Instances", checkpoint_msg_obj);
	new_check.image_xscale = 1.8;
	new_check.image_yscale = 1.8;
	new_check.text_to_draw = text
	
	obj_player_car.can_move = false;
	
	
	
	tutorial_check_bool = false;
}


if(tutorial_check_bool and obj_player_car.tutorial_check_1){
	if(!array_contains(obj_player_car.checkpoints_curr, checkpoint)) {
		array_push(obj_player_car.checkpoints_curr, checkpoint);
	}
	show_debug_message(obj_player_car.checkpoints_curr)
	
}
else{
	show_debug_message("nope");
}