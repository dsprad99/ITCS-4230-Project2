/// @description Insert description here
// You can write your code in this editor

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