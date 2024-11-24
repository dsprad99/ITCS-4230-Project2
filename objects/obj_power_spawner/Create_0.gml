/// @description Insert description here
// You can write your code in this editor
powerup_exists = false;

powerups = [obj_speed_boost]; // Add your powerup objects here

function spawn_power_up() {
	if (powerup_exists == false){
		var random_powerup = powerups[irandom(array_length(powerups) - 1)];
	    var spawned_instance = instance_create_layer(x, y, "UI", random_powerup);
        
        // Set the rotation of the spawned instance
        spawned_instance.image_angle = rotation_angle;
		
	    powerup_exists = true; // Mark that the powerup is now on the field
	}
}

spawn_power_up();
