/// @description Insert description here
// You can write your code in this editor

//LD Montello
//if the car is on the checkered
//object.
on_checkered_obj = false;

//LD Montello
//Get the current path
//from our race controller.
track_path = obj_race_controller.track_path;

//LD Montello
//if the car is falling
is_falling = false;
total_fall_time = game_get_speed(gamespeed_fps)*1;
cur_fall_time = 0;
cur_fall_obj = noone;

is_jumping = false;
cur_ramp = noone;

car_name = "malware_" + string(instance_number(obj_enemy));

//get the wall tile id for collision reasons in Step.
wallTileID = layer_tilemap_get_id("Wall_Tiles_Layer");

//should we draw this car?
should_draw = true;

//LD Montello
//the array objects that we'll bounce against
collideables = [obj_player_car, obj_enemy, wallTileID]

last_checkpoint = noone;

//LD Montello
#region davis' params from the player

//Davis SPradling
car_speed = 0; 
//Apply acceleration through step event ot gradually increase/decrease speed of card
acceleration = 0.2;     
base_max_speed = 16;   
max_speed = 16;
prev_base_max_speed = base_max_speed;
//The car friction will act as a constant if we want to slow the card down more
car_friction = 0.05;     
turn_speed = 1;    

//LD Montello
//whether the enemy should accelerate or deccelerate.
shouldAccel = false;
shouldDeccel = false;

path_increment = 15;

//LD Montello
//How many pixels away from
//a position we can be before
//resetting our current target to be that position.
target_accuracy = 5;

vel_vec = [0, 0];

//stored when
//we collide with something,
//so that we can bounce off of it
//properly.
normal = [0,0]
normal_x = 0;
normal_y = 0;

heading_vec = [0, 0];

left_perp_vec = [0, 0];
right_perp_vec = [0, 0];

path_point_x = 0;
path_point_y = 0;

left_dist = 0;
right_dist = 0;

#endregion

//LD Montello
#region pathing

//LD Montello,
//the length of the path.
path_len = path_get_length(track_path)

//Set the scale to be 5 times it's pixel size
image_xscale = 5;
image_yscale = 5;

//Set the current point
//to go to in the premade path
//to be the very first point.
current_point = 0;

//the radius we must be within
//to count as arriving at the point
//to be allowed to move on to the next
//target point along the track.
arrive_radius = 128

//Get the target x and y 
//positions to path to
target_x = path_get_point_x(track_path, current_point);
target_y = path_get_point_y(track_path, current_point);

//I was setting the position
//at start but I'd rather see the object path
//to the first point if it isn't on it.
//x = path_get_point_x(track_path, path_get_number(track_path));
//y = path_get_point_y(track_path, path_get_number(track_path))

//path_start(track_path, 5, path_action_restart, true);





function custom_arrive()
{
	//LD's Research source:
	//https://code.tutsplus.com/understanding-steering-behaviors-seek--gamedev-849t

	//calculate desired velocity
	//var desired_velocity = Vector2.angle_to_vector(image_angle).normalized().multiply_scalar(max_speed);;;
	var desired_velocity = normalized([target_x - x, target_y - y]);
	desired_velocity = multiply_scalar(desired_velocity, max_speed);
	var steering = desired_velocity;
	steering = subtract(steering, vel_vec)
	steering = clamp_magnitude(steering, -max_speed, max_speed);
	//0-1 value for how fast
	//we want to change velocity.
	//Research: https://gamedev.stackexchange.com/questions/73361/understanding-the-seek-steering-behavior
	scalar = 0.05;
	steering = multiply_scalar(steering, scalar);

	//mass = 1;
	//steering = steering.multiply_scalar(steering.magnitude() / mass);
	return steering;
}

#region arrive

slowing_radius = 32 * 3;

//calculate force
//to arrive at position
//given target x and target y values.
function arrive(_tx, _ty)
{
	//calculate desired velocity to reach target
	var _desired_velocity = [_tx - x, _ty - y];

	//Calculate distance from target
	var _target_dist = magnitude(_desired_velocity);
	
	
	//arrival slowdown if we are
	//within the slowdown radius
	if (_target_dist < slowing_radius)
	{
		_desired_velocity = normalized(_desired_velocity);
		
		_desired_velocity = multiply_scalar(_desired_velocity, max_speed * (_target_dist / slowing_radius))
		
		
	}
	else
	{
		_desired_velocity = normalized(_desired_velocity);

		_desired_velocity = multiply_scalar(_desired_velocity, max_speed)
		

	}
	
	
	
	return subtract(_desired_velocity, vel_vec);
}

#endregion

#region collision avoidance

max_avoid_force = 15;

function collision_avoidance()
{
	//calculate the dynamic magnitude
	//so we make the length of ahead be
	//relative to if we're slowing down or speeding up.
	dynamic_magnitude =100// magnitude(vel_vec) / max_speed

	////find the 
	//with ([obj_player_car, obj_enemy])
	//{
	//	//if the object is within our radius, add it's
	//	//force to our avoidance force.
	//	if (distance_to_object(other) <= avoidance_radius)
	//	{
	//		array_push(self);
	//	}
	//}
	
	ahead = normalized(vel_vec);
	ahead = multiply_scalar(ahead, dynamic_magnitude);
	ahead_world = add([x, y], ahead);
	//ahead2 = velocity.normalized().multiply_scalar(max_see_ahead * 0.5);
	var _inst = collision_line(x, y, x + ahead[0], y + ahead[1], [obj_player_car, obj_enemy], false, true)
	
	//var _inst = collision_line(x, y, x + ahead[0], y + ahead[1], wallTileID, false, true)
	if (_inst)
	{
		//show_message(_inst);
		
		var obstacle_vec = [_inst.x, _inst.y]
	
		//if our line intersects the cell
		//if (distance(obstacle_vec, ahead) <= 16 || distance(obstacle_vec, ahead2) <= 16)
		//{
		//	cur_obst_dist = distance_to_object(_inst);
		//	avoidance_force = new Vector2((ahead.x) - _inst.x, (ahead.y) - _inst.y)
	
		//	avoidance_force = avoidance_force.normalized().multiply_scalar(max_avoid_force);
		//	steering = steering.add(avoidance_force);	
		//}
	
		cur_obst_dist = distance_to_object(_inst);
		//avoidance_force = [(ahead_world[0]) - _inst.x, (ahead_world[1]) - _inst.y]
		avoidance_force = [(ahead_world[0]) - _inst.x, (ahead_world[1]) - _inst.y]
		
		avoidance_force = normalized(avoidance_force);
		avoidance_force = multiply_scalar(avoidance_force, max_avoid_force);
		
		return avoidance_force;
		//steering = steering.add(avoidance_force);
	
	}	
	return [0, 0];
}

#endregion

#region separation
//separation
separation_radius = (24 * 5) * 2;

max_separation = 0.9;

function separation()
{
	var force = [0,0];
	var neighbourCount = 0;
	
	
	//loop through all
	//cells near us and find
	//our neighbours.
	with (obj_enemy)
	{
		//self in this with statement
		//is the current cell we are looping
		//through, and other is the object
		//calling the with statement.
		
		//if our current cell is within the separation radius
		//to this calling cell and not this calling cell
		if (self != other and point_distance(other.x, other.y, self.x, self.y) <= separation_radius)
		{
			//show_message("HERE");
			#region attempt to smooth out avoidance.
			//var _dynamic_magnitude = velocity.magnitude() / max_velocity
			//var _ahead = velocity.normalized().multiply_scalar(_dynamic_magnitude);
			//var _ahead_world = new Vector2(x, y).add(_ahead);
			
			//var _avoidance_force = new Vector2((_ahead_world.x) - self.x, (_ahead_world.y) - self.y)
	
			//_avoidance_force = _avoidance_force.normalized().multiply_scalar(max_avoid_force);
			
			//force = force.add(_avoidance_force);
			
			#endregion
			
			//add the vector
			//from the neighbouring cell
			//to the calling cell
			//to our force.
			force[0] += self.x - other.x;
			force[1] += self.y - other.y;
			
			
			
			//increment neighbourcount
			//so we know how to scale our separation values.
			neighbourCount++;
		}
	}
	
	if (neighbourCount != 0)
	{
		//make sure
		//each neighbour has an
		//equal effect on our force.
		force[0] /= neighbourCount;
		force[1] /= neighbourCount;
		
		//invert force
		force = multiply_scalar(force, -1);
	}
	
	force = normalized(force);
	force = multiply_scalar(force, max_separation);
	
	return force;
}

#endregion

#endregion




//LD Montello
//Arrow used to show the
//direction of the player's
//current velocity.
ui_layer = layer_get_id("UI");

current_track_path_progression = 0;


//LD Montello,
//variables to store the
//time for each lap
#region lap info

//did the car finish the race.
did_finish = false;
cur_lap = 1;

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


//Davis Spradling
//Keep track of checkpoints completed
checkpoints_curr = [];

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


function play_drift_particles()
{
	obj_particle_sys_controller.play_particle_system_layer("Instances_drawn_under_cars", ps_magenta_drift, x, y);
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
ug1 = layer_sprite_create(grid_id, x, y, spr_magenta_underglow);
layer_sprite_xscale(ug1, 5);
layer_sprite_yscale(ug1, 5);

#endregion


function resolve_penetration(sample_x, sample_y, normal, max_depth) {
   var penetration_vec = [0,0];
			
	var sentinel = 100;
	
	penetration_vec = multiply_scalar(normal, max_depth / 2);
	
	
	
	//show_debug_message("START");
	//if (floor(point_distance(corner[0], corner[1], target_x, target_y)) >= 4)
	for (j = max_depth; j > 0; j--)
	{
		//show_message(i);
		//show_debug_message(j);
		//if (i > sentinel)
		//{
		//	break;
		//}
				
		var depth_normal = multiply_scalar(normal, j);
		if (collision_point(sample_x + depth_normal[0], sample_y + depth_normal[1], collideables, true, true))
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
	
	//if (pass_thru == false)
	//{
	//	updated_collideables = collideables_and_checkered;
	//}
	
	
	

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
			//	break;
			//}
			
			//if (instance_exists(_inst) and (_inst.object_index == obj_player_car and (_inst.is_falling or _inst.is_jumping)))
			//{
			//	break;
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
//LD Montello
//I copied this function from the 
//player car's code.
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
			//curr_checkpoint_arr = obj_enemy.checkpoints_curr;
		
		
			//remove ourselves from the priority queue.
			//otherwise we end up with duplicates
			ds_priority_delete_value(obj_race_controller.car_placement_queue, self);
		
			//Note changed layer to UI where the instance is created 
			//so the object will appear above the checkered race track
		    var new_car_instance = instance_create_layer(inst_x, inst_y, "Instances", obj_enemy);
		
			var right_direction = (last_checkpoint.image_angle+90)%360;
			new_car_instance.image_angle = right_direction;
		
		
		
			//Copy our data to the new car's data.
			new_car_instance.checkpoints_curr = checkpoints_curr;
			new_car_instance.last_checkpoint = last_checkpoint;
			new_car_instance.can_move = true
			new_car_instance.cur_lap = cur_lap;
	
			new_car_instance.lap1_time = lap1_time;
			new_car_instance.lap2_time = lap2_time;
			new_car_instance.lap3_time = lap3_time
			new_car_instance.car_name = car_name;
		
		    instance_destroy();

			
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
	obj_particle_sys_controller.play_particle_system(ps_magenta_derez_death, x, y);
	
	alarm_set(3, game_get_speed(gamespeed_fps)*1);
}

//LD Montello
//start the timer
//for searching
//for the nearest point
//along the path.
alarm_set(2, 1);