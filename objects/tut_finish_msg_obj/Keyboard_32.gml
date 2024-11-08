/// @description Insert description here
// You can write your code in this editor
checkpoint_obj.show_checkpoint_msg = false
instance_destroy(checkpoint_msg_obj)
instance_destroy()


//Davis Spradling
//This is being pulled from when a player
//presses space it should get this value from
//the collision object of the car and the 
//checkered_obj. The room it is supposed to go to
//is passed into the collsion event (car and checkered object) 
//from the checkered_obj variable defintions 

room_goto(room_to)
obj_player_car.can_move = true;