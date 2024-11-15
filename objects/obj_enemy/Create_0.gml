/// @description Insert description here
// You can write your code in this editor

//get the wall tile id for collision reasons in Step.
wallTileID = layer_tilemap_get_id("Wall_Tiles_Layer");


//LD Montello
//the array objects that we'll bounce against
bounceables = [wallTileID]

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


//LD Montello
//this function will restrict a given
//vector to a specific direction,
//it's used so that when we calculate
//the velocity needed to reach a point
//we only apply that velocity in the direction
//that the car can drive.
//we apply this to the steering variable
//after all behavior rules have been added
//so that those behaviors don't break 
//the rules of the car's movement. (only allowed
//to move in the axis/direction we are facing).
function clamp_vector_to_direction(vector_to_clamp, direction_vector)
{
	//By normalizing the target vector, you ensure that 
	//the resulting clamped vector will have a magnitude of 
	//1 in the direction of the target vector.
	var unit_vector = normalized(direction_vector);
	
	//The dot product is used to find the component of the 
	//vector to be clamped that aligns with the target vector's 
	//direction.
	var dotProduct = dot(vector_to_clamp, unit_vector);
	
	//Multiplying the dot product with the unit target vector 
	//effectively projects the vector onto the target vector's 
	//direction.
	var clamped_vector = multiply_scalar(unit_vector, dotProduct);
	
	return clamped_vector;
}



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
		show_message(_inst);
		
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