/// @description Insert description here
// You can write your code in this editor

//Davis Spradling
//This will check if we have crossed 
//the finish line and gone through all
//the checkpoints


checkpoints_needed = [0,1,2]
show_debug_message(checkpoints_curr)
if(checkpoints_complete(checkpoints_needed, checkpoints_curr)){
	show_message("Lap completed");
	pass_thru = true
	checkpoints_curr = [];
}
if(!pass_thru){
	car_speed=0;
}



//show_debug_message(checkpoints_curr)


