/// @description Insert description here
// You can write your code in this editor

//Davis Spradling
//This will check if we have crossed 
//the finish line and gone through all
//the checkpoints


checkpoints_needed = [1,2,3]

if(checkpoints_complete(checkpoints_needed, checkpoints_curr)){
	show_message("Lap completed");
	checkpoints_curr = [];
}
