/// @description Insert description here
// You can write your code in this editor

//LD Montello
#region davis' params from the player

//Davis SPradling
car_speed = 0; 
//Apply acceleration through step event ot gradually increase/decrease speed of card
acceleration = 0.2;     
max_speed = 8;   
//The car friction will act as a constant if we want to slow the card down more
car_friction = 0.05;     
turn_speed = 1;    

//LD Montello
//whether the enemy should accelerate or deccelerate.
shouldAccel = false;
shouldDeccel = false;

path_increment = 15;

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

#endregion