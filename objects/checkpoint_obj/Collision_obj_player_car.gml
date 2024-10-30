/// @description Insert description here
// You can write your code in this editor
//Davis Spradling
if(!array_contains(obj_player_car.checkpoints_curr, checkpoint)) {
	array_push(obj_player_car.checkpoints_curr, checkpoint);
}
show_debug_message(obj_player_car.checkpoints_curr)