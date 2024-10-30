/// @description Insert description here
// You can write your code in this editor

//get the wall tile id for collision reasons in Step.
wallTileID = layer_tilemap_get_id("Wall_Tiles_Layer");

//LD Montello
//scale object 5 times larger
image_xscale = 5;
image_yscale = 5;

ui_layer = layer_get_id("UI");
//LD Montello
//Arrow used to show the
//direction of the player's
//current velocity.
arrow = layer_sprite_create(ui_layer, x, y, spr_arrow);
layer_sprite_xscale(arrow, 5);
layer_sprite_yscale(arrow, 5);

//LD Montello
//Vector to store directional built up momentum
vel_vec = new Vector2(0, 0);

//Davis SPradling
car_speed = 0; 
//Apply acceleration through step event ot gradually increase/decrease speed of card
acceleration = 0.2;     
max_speed = 8;   
//The car friction will act as a constant if we want to slow the card down more
car_friction = 0.05;     
turn_speed = 1;              

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