/// @description Insert description here
// You can write your code in this editor

//LD Montello
//if the car is on the checkered
//object.
on_checkered_obj = false;

//if the car is falling
is_falling = false;
total_fall_time = game_get_speed(gamespeed_fps)*1;
cur_fall_time = 0;
cur_fall_obj = noone;

//if the car is jumping.
is_jumping = false;
cur_ramp = noone;

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

//LD Montello,
//this car's race position.
race_position = -1;

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
			//When on the 
			//finish line, ignore
			//their current
			//progression
			//because it may be innacurate.
			if (on_checkered_obj)
			{
				current_track_path_progression = 0;
			}
			else
			{
				//calculate the progression along the current path.
				current_track_path_progression = floor(obj_race_controller.get_closest_point_on_path(x, y)) / obj_race_controller.path_len;
			}
			
		
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
			//When on the 
			//finish line, ignore
			//their current
			//progression
			//because it may be innacurate.
			if (on_checkered_obj)
			{
				current_track_path_progression = 0;
			}
			else
			{
				//calculate the progression along the current path.
				current_track_path_progression = floor(obj_race_controller.get_closest_point_on_path(x, y)) / obj_race_controller.path_len;
			}
			
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
//the array of objects that we'll get pushed
//by or stopped by.
collideables = [obj_enemy, wallTileID]

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



//LD Montello
//get all the checkpoints for this track.
checkpoints_needed = array_create(0);
with (checkpoint_obj)
{
	//add checkpoint to the checkpoints needed
	//list
	array_push(other.checkpoints_needed, self);
}

//Davis Spradling
//Will be used to check if all the checkpoints have been completed
//checkpoints_current are completed checkpoints
//checkpoints_needed are all the ones that must be completed
//for a full lap to count
function checkpoints_complete(checkpoints_needed,checkpoints_current) {
    
	//Debug checkpoint progression.
	//show_message("Count: " + string(array_length(checkpoints_current)) + "Total: " + string(array_length(checkpoints_needed)))
	
	//LD Montello
	//modified this method.
	//if the player is missing any checkpoints,
	//then return false.
	//if they have the exact correct number of checkpoints,
	//return true.
	return array_length(checkpoints_current) == array_length(checkpoints_needed);
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


last_checkpoint = noone;

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

	if (instance_exists(last_checkpoint))
	{
			var inst_x = last_checkpoint.x //+(instanceid.sprite_width/2);
		    var inst_y = last_checkpoint.y //+(instanceid.sprite_height/2);
		
			//save progress made by car before destroying
			//curr_checkpoint_arr = obj_player_car.checkpoints_curr;
		
		
			//remove ourselves from the priority queue.
			//otherwise we end up with duplicates
			ds_priority_delete_value(obj_race_controller.car_placement_queue, self);
		
		  

			//Note changed layer to UI where the instance is created 
			//so the object will appear above the checkered race track
		    var new_car_instance = instance_create_layer(inst_x, inst_y, "Instances", obj_player_car);
		
			var right_direction = (last_checkpoint.image_angle+90)%360;
			new_car_instance.image_angle = right_direction;
		
		
			//copy our data to the new instance's data.
			new_car_instance.checkpoints_curr=checkpoints_curr;
			new_car_instance.can_move = true
			new_car_instance.cur_lap = cur_lap;
			new_car_instance.lap_start_time = lap_start_time;
			new_car_instance.lap1_time = lap1_time;
			new_car_instance.lap2_time = lap2_time;
			new_car_instance.lap3_time = lap3_time
			
			//destroy ourselves,
			//the instance that "died"
			instance_destroy()
	}
}

//LD Montello
//reset the player after some delay,
//currently 1 second.
function reset_to_last_checkpoint_delayed()
{
	//LD Montello
	//play the particle system
	//for dying
	obj_particle_sys_controller.play_particle_system(ps_cyan_derez_death, x, y);
	
	alarm_set(2, game_get_speed(gamespeed_fps)*1);
}

function play_drift_particles()
{
	obj_particle_sys_controller.play_particle_system_layer("Instances_drawn_under_cars", ps_cyan_drift, x, y);
}

function resolve_penetration(sample_x, sample_y, normal, max_depth) {
   var penetration_vec = [0,0];
			
	var sentinel = 100;
	
	penetration_vec = multiply_scalar(normal, max_depth / 2);
	
	var updated_collideables = collideables;
	
	if (pass_thru == false)
	{
		updated_collideables = collideables_and_checkered;
	}
	
	

	//if (floor(point_distance(corner[0], corner[1], target_x, target_y)) >= 4)
	for (j = max_depth; j > 0; j--)
	{
		//show_message(i);
		
		//if (i > sentinel)
		//{
		//	break;
		//}
				
		var depth_normal = multiply_scalar(normal, j);
		if (collision_point(sample_x + depth_normal[0], sample_y + depth_normal[1], updated_collideables, true, true))
		{
			penetration_vec = depth_normal;
			//x += penetration_vec[0];
			//y += penetration_vec[1];
			//vel_vec = add(vel_vec, penetration_vec);
			//vel_vec = [0,0]
			break;
		}
		else
		{
			//we are no longer colliding,
			//so this is the final distance to 
			//get the point out of this object.
			penetration_vec = depth_normal;
			continue;
		}
	}

    return penetration_vec;
}

//LD Montello
//the collideables and the checkered_obj
collideables_and_checkered = array_concat(collideables, [checkered_obj]);

function collision_resolution()
{
	
	var target_x = x + vel_vec[0];
	var target_y = y + vel_vec[1];
	
	//LD Montello,
	//we need to change the collideables
	//we check depending on if we're allowed
	//to pass through the checkered_obj or not.
	var updated_collideables = collideables;
	
	if (pass_thru == false)
	{
		updated_collideables = collideables_and_checkered;
	}
	
	
	

	if (place_meeting(target_x, target_y, updated_collideables)) {
	    
		//LD Montello
		//if pass_through is false,
		//we need to call the on collision code
		//if we collide with the checkered_obj
		//so that we can descide if we're
		//allowed to go through it or not.
		//if (pass_thru == false)
		//{
		//	_inst = instance_place(target_x, target_y, checkered_obj);
		//	if (instance_exists(_inst))
		//	{
		//		//show_message("HERE");
		//		on_checkered_obj_collision(_inst);
		//	}
		//}
		// Calculate the normal for the overall collision
		//These are the most optimal params for accuracy
		//and speed of calculation.
		//I wish I could bake the normals but I don't have time
		//to figure that out.
		//this line is what slows down this code,
		//theoretically if we didn't limit the points to check
		//code here should only be O(n^3)
	    normal = normalized(angle_to_vector(collision_normal(target_x, target_y, updated_collideables, 32 * 4, 5)));

	    // Get the car's half dimensions
	    var half_width = sprite_width / 2;
	    var half_height = sprite_height / 2;

	    // Car's center point (current position)
	    var cx = x;
	    var cy = y;

	    // Calculate each corner relative to the center, rotated by image_angle
	    var corners = [
	        [cx + dcos(-image_angle) * half_width - dsin(-image_angle) * half_height, cy + dsin(-image_angle) * half_width + dcos(-image_angle) * half_height], // Top-right
	        [cx - dcos(-image_angle) * half_width - dsin(-image_angle) * half_height, cy - dsin(-image_angle) * half_width + dcos(-image_angle) * half_height], // Top-left
	        [cx - half_width * dcos(-image_angle) + half_height * dsin(-image_angle), cy - half_width * dsin(-image_angle) - half_height * dcos(-image_angle)], // Bottom-left
	        [cx + half_width * dcos(-image_angle) + half_height * dsin(-image_angle), cy + half_width * dsin(-image_angle) - half_height * dcos(-image_angle)]  // Bottom-right
	    ];

	    // Calculate midpoints of edges
	    var edges = [
	        [(corners[0][0] + corners[1][0]) / 2, (corners[0][1] + corners[1][1]) / 2], // Top edge
	        [(corners[1][0] + corners[2][0]) / 2, (corners[1][1] + corners[2][1]) / 2], // Left edge
	        [(corners[2][0] + corners[3][0]) / 2, (corners[2][1] + corners[3][1]) / 2], // Bottom edge
	        [(corners[3][0] + corners[0][0]) / 2, (corners[3][1] + corners[0][1]) / 2]  // Right edge
	    ];

	    // Combine corners and edges into a single list of sample points
	    var sample_points = array_concat(corners, edges);

	    //Loop through all points
	    for (var i = 0; i < array_length(sample_points); i++) {
	        var point = sample_points[i];
		
			//add our velocity as we're 
			//trying to prevent future collisions
			//before they happen.
	        point[0] += vel_vec[0];
	        point[1] += vel_vec[1];
			
			//var _inst = collision_point(point[0], point[1], updated_collideables, true, true);
			
			////if the object we're colliding
			////with is jumping or falling
			////ignore that collision.
			//if (instance_exists(_inst) and (_inst.object_index == obj_enemy and (_inst.is_falling or _inst.is_jumping)))
			//{
			//	show_debug_message(string(_inst.is_falling));
			//	continue;
			//}
			
			//if there's a collision with
			//an object at this point
	        if (collision_point(point[0], point[1], updated_collideables, true, true)) {
	            //Draw a red circle for colliding points
	            //draw_circle_color(point[0], point[1], 5, c_red, c_red, false);

	            //Resolve penetration depth
				//by iterating through points
				//along our normal until there's
				//no longer a collision.
				//we use pythagorean theorem
				//to find the longest distance between
				//any two points on our car, (the diagonal corners)
				//and use that as our maximum depth to check against,
				//because if we're somehow deeper than that we don't
				//want an infinite loop.
	            var penetration_vec = resolve_penetration(point[0], point[1], normal, sqrt((sprite_width * sprite_width + sprite_height * sprite_height)));

	            //Adjust position and velocity based on the penetration vector
				//Why do we adjust both position and velocity you may ask?
				//that's because moving the position will instantly
				//resolve a collision, but we also want to simulate having
				//lost momentum as if we hit it and were pushed out of it.
				//it's an easy way to cut corners without having to do any
				//derivation to only use acceleration and velocity.
	            x += penetration_vec[0];
	            y += penetration_vec[1];
	            vel_vec = add(vel_vec, penetration_vec);

	            //draw a line using our point and the
				//penetration depth to visualize 
				//the penetration amount.
				//You can comment the section where we 
				//push an object out of the other object
				//to visualize how our depth is calculated.
	            //draw_line_width(point[0], point[1], point[0] + penetration_vec[0], point[1] + penetration_vec[1], 4);
	        } else {
	            //Draw a white circle for non-colliding points
	            //draw_circle_color(point[0], point[1], 4, c_white, c_white, false);
	        }
	    }
	}
}

//used to indicate
//if the car is fully
//overlapping the fall object.
is_fully_overlapping = false;

//make sure the car fully
//overlaps the fall object
//when the player falls onto it.
function fully_overlap_object()
{
		var target_x = x + vel_vec[0];
		var target_y = y + vel_vec[1];


	if (place_meeting(target_x, target_y, cur_fall_obj)) {
	    // Calculate the normal for the overall collision
		//These are the most optimal params for accuracy
		//and speed of calculation.
		//I wish I could bake the normals but I don't have time
		//to figure that out.
		//this line is what slows down this code,
		//theoretically if we didn't limit the points to check
		//code here should only be O(n^3)
	    normal = normalized(angle_to_vector(collision_normal(target_x, target_y, cur_fall_obj, 32 * 4, 5)));

	    // Get the car's half dimensions
	    var half_width = sprite_width / 2;
	    var half_height = sprite_height / 2;

	    // Car's center point (current position)
	    var cx = x;
	    var cy = y;

	    // Calculate each corner relative to the center, rotated by image_angle
	    var corners = [
	        [cx + dcos(-image_angle) * half_width - dsin(-image_angle) * half_height, cy + dsin(-image_angle) * half_width + dcos(-image_angle) * half_height], // Top-right
	        [cx - dcos(-image_angle) * half_width - dsin(-image_angle) * half_height, cy - dsin(-image_angle) * half_width + dcos(-image_angle) * half_height], // Top-left
	        [cx - half_width * dcos(-image_angle) + half_height * dsin(-image_angle), cy - half_width * dsin(-image_angle) - half_height * dcos(-image_angle)], // Bottom-left
	        [cx + half_width * dcos(-image_angle) + half_height * dsin(-image_angle), cy + half_width * dsin(-image_angle) - half_height * dcos(-image_angle)]  // Bottom-right
	    ];

	    // Calculate midpoints of edges
	    var edges = [
	        [(corners[0][0] + corners[1][0]) / 2, (corners[0][1] + corners[1][1]) / 2], // Top edge
	        [(corners[1][0] + corners[2][0]) / 2, (corners[1][1] + corners[2][1]) / 2], // Left edge
	        [(corners[2][0] + corners[3][0]) / 2, (corners[2][1] + corners[3][1]) / 2], // Bottom edge
	        [(corners[3][0] + corners[0][0]) / 2, (corners[3][1] + corners[0][1]) / 2]  // Right edge
	    ];

	    // Combine corners and edges into a single list of sample points
	    var sample_points = array_concat(corners, edges);

		var total_overlapping_points = 0;
		
	    //Loop through all points
	    for (var i = 0; i < array_length(sample_points); i++) {
	        var point = sample_points[i];
		
			//add our velocity as we're 
			//trying to prevent future collisions
			//before they happen.
	        point[0] += vel_vec[0];
	        point[1] += vel_vec[1];
		
			//if there's a collision with
			//an object at this point
	        if (collision_point(point[0], point[1], cur_fall_obj, true, true)) {
	            //Draw a red circle for colliding points
	            //draw_circle_color(point[0], point[1], 5, c_red, c_red, false);

	            //Resolve penetration depth
				//by iterating through points
				//along our normal until there's
				//no longer a collision.
				//we use pythagorean theorem
				//to find the longest distance between
				//any two points on our car, (the diagonal corners)
				//and use that as our maximum depth to check against,
				//because if we're somehow deeper than that we don't
				//want an infinite loop.
	            var penetration_vec = resolve_penetration(point[0], point[1], normal, sqrt((sprite_width * sprite_width + sprite_height * sprite_height)));

	            //Adjust position and velocity based on the penetration vector
				//Why do we adjust both position and velocity you may ask?
				//that's because moving the position will instantly
				//resolve a collision, but we also want to simulate having
				//lost momentum as if we hit it and were pushed out of it.
				//it's an easy way to cut corners without having to do any
				//derivation to only use acceleration and velocity.
	            x -= penetration_vec[0];
	            y -= penetration_vec[1];
	            //vel_vec = add(vel_vec, penetration_vec);

	            //draw a line using our point and the
				//penetration depth to visualize 
				//the penetration amount.
				//You can comment the section where we 
				//push an object out of the other object
				//to visualize how our depth is calculated.
	            //draw_line_width(point[0], point[1], point[0] + penetration_vec[0], point[1] + penetration_vec[1], 4);
				
				
				//increment total overlapping
				//points 
				total_overlapping_points++;
				
				//if every point is overlapping
				//then we're fully overlapping
				//so the falling code should
				//stop calling us.
				if (total_overlapping_points == array_length(sample_points))
				{
					is_fully_overlapping = true;
				}
			} else {
				//we are not fully overlapping.
				is_fully_overlapping = false;
	            //Draw a white circle for non-colliding points
	            //draw_circle_color(point[0], point[1], 4, c_white, c_white, false);
	        }
	    }
	}
}


function check_pass_through()
{
	
	if (checkpoints_complete(checkpoints_needed, checkpoints_curr))
	{
		pass_thru = true;
	}
	else
	{
		pass_thru = false;
	}
}


function on_checkered_obj_collision(_other)
{
	//Davis Spradling
	//This will check if we have crossed 
	//the finish line and gone through all
	//the checkpoints


	//exit this event if
	//we already finished.
	if (did_finish)
	{
		return;
	}

	
	//show_debug_message(checkpoints_curr)

	if(in_tutorial and checkpoints_complete(checkpoints_needed, checkpoints_curr) && _other.tutorial_check){
		//Be used to break up the instructions into three different lines
		//for readability
		//var new_tut_next = instance_create_layer(obj_player_car.x, obj_player_car.y+300, "tutorial_popup", next_room_button_obj);
		//new_tut_next.image_xscale = .5;
		//new_tut_next.image_yscale = .5;
		//new_tut_next.room_to = other.room_go
	
		var new_check = instance_create_layer(obj_player_car.x, obj_player_car.y, "tutorial_popup", tut_finish_msg_obj);
		new_check.image_xscale = 1.8;
		new_check.image_yscale = 1.8;
		new_check.room_to = _other.room_go
	
	
		var words_array = string_split(_other.text, " ");

		// Calculate the total number of words
		var total_words = array_length(words_array);
		var half = total_words div 2;

		var var1 = "";
		var var2 = "";
	
		//Break the text into two seperate lines
		for (var i = 0; i < total_words; i++) {
		    if (i<half) {
		        var1 += words_array[i] + " ";
			}
				else {
		        var2 += words_array[i] + " ";
		    }
	}
	
		tut_finish_msg_obj.txt1 = var1;
		tut_finish_msg_obj.txt2 = var2;
		obj_player_car.can_move = false;
	
		_other.tutorial_check = false;
	}

	else if(checkpoints_complete(checkpoints_needed, checkpoints_curr)){
		//show_message("Lap completed");

		//LD Montello
		//Store whatever lap time we're
		//at as the lap time for our current
		//lap 
		if (cur_lap == 1)
		{
			lap1_time = obj_race_controller.time_taken - lap_start_time;
		}
		else if (cur_lap == 2)
		{
			lap2_time = obj_race_controller.time_taken - lap_start_time;
		}
		else if (cur_lap == 3)
		{
			lap3_time = obj_race_controller.time_taken - lap_start_time;
		}
	
		if (cur_lap == 3)
		{
			//The race should end for the player here,
			//and we should do some waiting for the other
			//cars to finish and then the race controller
			//will know which cars have finished
			//because our car will tell it here that we've
			//finished, we'll do the same thing in the enemies.
			did_finish = true;
			
			//Tell the race controller
			//that the player has finished
			obj_race_controller.player_finished = true;
			
			can_move = false;
			//LD Montello show finish popup.
			if (instance_exists(obj_popup_controller))
			{
				//stop drawing our object.
				should_draw = false;
				obj_popup_controller.show_finish_popup();
			
				//LD Montello
				//Draw the "death" particles
				//if they aren't in first,
				//or draw the "escape" particles
				//if they are in first
				//This is because in the "story" of our game,
				//they player's car is racing to escape before
				//the malware can, so the first place winner
				//will always be the one that "escapes".
				//maybe we can make it so that you have to get first
				//on each track to unlock the next?
				//ehh, that may be too much work for such a small
				//amount of time.
				if (ds_list_empty(obj_race_controller.final_placements_list))
				{
					obj_particle_sys_controller.play_particle_system_angle(ps_cyan_derez_escape, x, y, vector_to_angle(normalized(vel_vec)));
				}
				else
				{
					obj_particle_sys_controller.play_particle_system(ps_cyan_derez_death, x, y);
				}
			
			}
		
			//here we are making sure that
			//when the placements are drawn,
			//we don't overwrite our placement
			//that we finished at with another
			//cars placement by separating them
			//into two lists.
		
			//add ourselves to the finalized list
			//as our placement should no longer change.
			ds_list_add(obj_race_controller.final_placements_list, self);
			//remove ourselves from the priority queue
			ds_priority_delete_value(obj_race_controller.car_placement_queue, self);
		
		}
		else
			cur_lap++;

		//reset the lap start time.
		lap_start_time = obj_race_controller.time_taken;
	
		pass_thru = true
		checkpoints_curr = [];
	}
	if(!pass_thru){
		car_speed=0;
	}


	//show_debug_message(checkpoints_curr)
}