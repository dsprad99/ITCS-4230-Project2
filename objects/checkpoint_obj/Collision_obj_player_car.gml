/// @description Insert description here
// You can write your code in this editor
//Davis Spradling
show_message("Checkpoint complete");
if(tutorial_check_bool){
	//function to pull up popup
	show_checkpoint_msg = true;
	instance_create_layer(obj_player_car.x, obj_player_car.y, "Instances", checkpoint_msg_obj);
	
	
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