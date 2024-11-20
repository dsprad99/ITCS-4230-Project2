/// @description Insert description here
// You can write your code in this editor

//LD Montello
//Change our scale relative to how we're jumping.
if (is_jumping && instance_exists(cur_ramp))
{
	//calculate max distance
	//from centerpoint of
	//the ramp to the outermost corners
	//using pythagorean theorem.
	var max_dist = sqrt((cur_ramp.sprite_width * cur_ramp.sprite_width + cur_ramp.sprite_height * cur_ramp.sprite_height)) / 2;
	//calculate distance from the car to the ramp's center as a vector.
	var dist_vec = [x - cur_ramp.x, y - cur_ramp.y];
	//get the vector of the angle that the ramp is facing
	var dir_vec = angle_to_vector(cur_ramp.image_angle + 90);
	//restrict the distance vector to the direction vector
	//so that we know the distance from the "center line"
	//of the ramp.
	var proj_vec = clamp_vector_to_direction(dist_vec, dir_vec);
	
	
	
	//calculate the percentage from the center that the ramp
	//is at, then invert it, and multiply by our max scale during the jump
	var max_scale = 10;
	var base_scale = 5;
	var new_scale = base_scale + (max_scale - base_scale) * (1 - magnitude(proj_vec) / max_dist);
	image_xscale = new_scale;
	image_yscale = new_scale;
	
	draw_line(x, y, x - proj_vec[0], y - proj_vec[1]);
}
else
{
	image_xscale = 5;
	image_yscale = 5;
}

collision_resolution();