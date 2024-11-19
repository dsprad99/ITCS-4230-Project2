/// @description Insert description here
// You can write your code in this editor

should_draw = true;

//positions where the normal should be
//drawn from.
normal_x = 0;
normal_y = 0;
//vector for the normal 
//of the obejct we hit.
normal = [0,0]

//LD Montello,
//the name of this car
//that we display on the leaderboard
car_name = "USER"

//LD Montello,
//variables to store the
//time for each lap
#region lap info

//did the car finish the race.
did_finish = false;
cur_lap = 1;

lap_start_time = 0;

lap1_time = 999999;
lap2_time = 999999;
lap3_time = 999999;

#endregion

#region update ourselves in the car placement queue

function update_placement()
{
	if (instance_exists(obj_race_controller))
	{
		//if this car is in the priority queue already,
		//then update it's priority.
		if (ds_priority_find_priority(obj_race_controller.car_placement_queue, self) != undefined)
		{
			//calculate the progression along the current path.
			current_track_path_progression = obj_race_controller.get_closest_point_on_path(x, y) / obj_race_controller.path_len;
		
			//calculate priority by adding the current lap to our
			//distance in the track.
			var priority = cur_lap + current_track_path_progression;
			
			//change the priority of ourselves
			ds_priority_change_priority(obj_race_controller.car_placement_queue, self, priority);
		}
		//if we aren't in the priority queue,
		//we need to add ourselves.
		else
		{
			//calculate the progression along the current path.
			current_track_path_progression = obj_race_controller.get_closest_point_on_path(x, y) / obj_race_controller.path_len;
			
			//calculate priority by adding the current lap to our
			//distance in the track.
			var priority = cur_lap + current_track_path_progression;
			
			//add our priority to the priority queue.
			ds_priority_add(obj_race_controller.car_placement_queue, self, priority)
		}
	}
}

#endregion

pass_thru = false;

//Davis Spradling
//Used to keep track of if in tutorial or not
in_tutorial = false

//get the wall tile id for collision reasons in Step.
wallTileID = layer_tilemap_get_id("Wall_Tiles_Layer");


is_colliding = false;

//LD Montello
//the array objects that we'll bounce against
bounceables = [wallTileID]

//LD Montello
//the array of objects that we'll get pushed
//by or stopped by.
collideables = [obj_enemy]

//LD Montello
//scale object 5 times larger
image_xscale = 5;
image_yscale = 5;

ui_layer = layer_get_id("UI");
//LD Montello
//Arrow used to show the
//direction of the player's
//current velocity.
//arrow = layer_sprite_create(ui_layer, x, y, spr_arrow);
//layer_sprite_xscale(arrow, 5);
//layer_sprite_yscale(arrow, 5);

//LD Montello
//Vector to store directional built up momentum
vel_vec = [0, 0];
cur_vel = vel_vec;
prev_vel = [0,0];


is_reversing = false;


//LD Montello
//used when breaking.
braking_force = 0.5;

function brake()
{
	//play drift particles
	//to represent braking
	play_drift_particles()
	
	//subtract the current velocity direction
	//scaled by braking force from the current
	//velocity to slow down linearly.
	vel_vec = subtract(vel_vec, multiply_scalar(normalized(vel_vec), braking_force))
	
	//set velocity to zero if we're close enough.
	if (abs(magnitude(vel_vec))<=0.5)
	{
		vel_vec = [0,0]
	}
}

//The speed at which
//the car can convert it's current
//velocity to face the driving direction,
//basically, how fast the car can recover
//when turning quickly or spinning out.
traction = 0.03;
cur_traction = 0.03;

//Davis SPradling
car_speed = 0; 
//Apply acceleration through step event ot gradually increase/decrease speed of card
acceleration = 0.2;     
base_max_speed = 16;   
max_speed = 16;
prev_base_max_speed = base_max_speed;

//The car friction will act as a constant if we want to slow the card down more
car_friction = 0.05;     
turn_speed = 1.73;              

//Davis Spradling
//Keep track of checkpoints completed
checkpoints_curr = [];
press_up = false;
press_down = false;


//Davis Spradling
//Will be used to check if all the checkpoints have been completed
//checkpoints_current are completed checkpoints
//checkpoints_needed are all the ones that must be completed
//for a full lap to count
function checkpoints_complete(checkpoints_needed,checkpoints_current) {
    for (var i = 0; i < array_length(checkpoints_needed); i++) {
        var curr_val = checkpoints_needed[i]; 
        
        var found = false;
        for (var j = 0; j < array_length(checkpoints_current); j++) {
            if (checkpoints_current[j] == curr_val) {
                found = true;
                break; 
            }
        }

        if(!found) {
            return false;
        }
    }
    return true;
}



#region underglow

//LD Montello
//https://manual.gamemaker.io/beta/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/Background_Layers/layer_background_xscale.htm#:~:text=This%20function%20can%20be%20used,then%20set%20the%20scale%20value.
//This changes 
//the size of the grid background
//to the size I want.
grid_id = layer_get_id("Grid");
grid_background_id = layer_background_get_id(grid_id);
layer_background_xscale(grid_background_id, 2.5);
layer_background_yscale(grid_background_id, 2.5);

//LD Montello
//The underglow effect
//that we place between
//the background and the grid
//to make it look like the lines are glowing
//because of the object's color.
ug1 = layer_sprite_create(grid_id, x, y, spr_cyan_underglow);
layer_sprite_xscale(ug1, 5);
layer_sprite_yscale(ug1, 5);

#endregion


//LD Montello,
//I turned davis'
//code into this function so
//we can just call this when a car
//is "destroyed" by an obstacle
//or power up.
function reset_to_last_checkpoint()
{
	//Davis Spradling
	//This will rotate through the checkpoint objects
	//and take the last object that was iterated through
	//and respawn them there

	for (var i = 0; i < instance_number(checkpoint_obj); ++i;){
	show_debug_message(checkpoints_curr)
	    var instanceid = instance_find(checkpoint_obj, i);
		if(fall_obj.checkpoint_go_to ==	instanceid.checkpoint){
        
		    var inst_x = instanceid.x //+(instanceid.sprite_width/2);
		    var inst_y = instanceid.y //+(instanceid.sprite_height/2);
		
			//save progress made by car before destroying
			curr_checkpoint_arr = obj_player_car.checkpoints_curr;
		
		
			//remove ourselves from the priority queue.
			//otherwise we end up with duplicates
			ds_priority_delete_value(obj_race_controller.car_placement_queue, self);
		
		    instance_destroy(obj_player_car);

			//Note changed layer to UI where the instance is created 
			//so the object will appear above the checkered race track
		    var new_car_instance = instance_create_layer(inst_x, inst_y, "Instances", obj_player_car);
		
			var right_direction = (instanceid.image_angle+90)%360;
			new_car_instance.image_angle = right_direction;
		
		
		
			//readd that progress
			new_car_instance.checkpoints_curr=curr_checkpoint_arr;
			new_car_instance.can_move = true
			new_car_instance.cur_lap = cur_lap;
			new_car_instance.lap_start_time = lap_start_time;
			new_car_instance.lap1_time = lap1_time;
			new_car_instance.lap2_time = lap2_time;
			new_car_instance.lap3_time = lap3_time
		}
	}
}

function play_drift_particles()
{
	obj_particle_sys_controller.play_particle_system_layer("Instances_drawn_under_cars", ps_cyan_drift, x, y);
}