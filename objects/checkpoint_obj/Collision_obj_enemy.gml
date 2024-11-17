/// @description Insert description here
// You can write your code in this editor

//LD Montello,
//Copied davis' code and
//modified to wokr for the obj_enemy.

if(!array_contains(obj_enemy.checkpoints_curr, checkpoint)) {

	//Add the checkpoint to the array.
	array_push(obj_enemy.checkpoints_curr, checkpoint);
}