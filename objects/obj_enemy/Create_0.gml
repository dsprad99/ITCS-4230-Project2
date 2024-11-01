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
max_speed = 8;   
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

vel_vec = new Vector2(0, 0);

heading_vec = new Vector2(0, 0);

left_perp_vec = new Vector2(0, 0);
right_perp_vec = new Vector2(0, 0);

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

//LD Montello
//Arrow used to show the
//direction of the player's
//current velocity.
ui_layer = layer_get_id("UI");
arrow = layer_sprite_create(ui_layer, x, y, spr_arrow);
layer_sprite_xscale(arrow, 5);
layer_sprite_yscale(arrow, 5);