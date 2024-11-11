/// @description Insert description here
// You can write your code in this editor


//Davis Spradling
//This will rotate through the checkpoint objects
//and take the last object that was iterated through
//and respawn them there

for (var i = 0; i < instance_number(checkpoint_obj); ++i;){
show_debug_message(checkpoints_curr)
    var instanceid = instance_find(checkpoint_obj, i);
	if(fall_obj.checkpoint_go_to ==	instanceid.checkpoint){
        
	    var inst_x = instanceid.x +(instanceid.sprite_width/2);
	    var inst_y = instanceid.y +(instanceid.sprite_height/2);
		
		//save progress made by car before destroying
		curr_checkpoint_arr = obj_player_car.checkpoints_curr;

	    instance_destroy(obj_player_car);

		//Note changed layer to UI where the instance is created 
		//so the object will appear above the checkered race track
	    var new_car_instance = instance_create_layer(inst_x, inst_y, "UI", obj_player_car);
		
		var right_direction = (instanceid.direction+instanceid.rotate_car)%360;
		new_car_instance.image_angle = right_direction;
		
		//readd that progress
		new_car_instance.checkpoints_curr=curr_checkpoint_arr;
		new_car_instance.can_move = true
		
	}
}