/// @description Insert description here
// You can write your code in this editor

//if we're paused,
//just return.
if (global.paused)
{
	return;
}

//LD Montello
//decrement cur_time
//when reversing,
//increment otherwise.
if (is_reversing)
{
	//LD Montello
	//if we're
	//close enough to the
	//end of our lerp, 
	//switch directions
	//and reset lerping.
	if (cur_time < 0.1)
	{
		is_reversing = false;
		
		//LD Montllo
		//randomly pick right most angle.
		cur_angle_max = random_range(angle_min, angle_max);
		
		//LD Montello
		//scale lerp speed
		//so it's always the same
		//speed regardless of distance
		//between max and min angles.
		scale_lerp_speed();
		
		//LD Montello
		//Set to 0
		//so we start from
		//the end of the current
		//lerp.
		cur_time = 0;
	}
	
	//LD Montello
	//set our image
	//angle using the lerp function
	//based on our current time's progression.
	//smoothstep makes the function ease to each target
	//instead of just locking to it, this makes
	//it look much more natural.
	image_angle = lerp(cur_angle_min, cur_angle_max, smoothstep(cur_time / total_time));
	
	//LD Montello
	//Create varying speed
	//every frame
	//so it looks jittery
	//cur_lerp_speed_scaled = random_range(min_lerp_speed, max_lerp_speed);
	
	//LD Montello
	//decrement time
	//because we are reversing.
	cur_time -= cur_lerp_speed_scaled;
}
else
{
	
	//LD Montello
	//if we're
	//close enough to the
	//end of our lerp, 
	//switch directions
	//and reset lerping.
	if (abs(total_time - cur_time) < 0.1)
	{
		is_reversing = true;
		
		//LD Montllo
		//randomly pick left most angle.
		cur_angle_min = -1 * random_range(angle_min, angle_max);
		
		//LD Montello
		//scale lerp speed
		//so it's always the same
		//speed regardless of distance
		//between max and min angles.
		scale_lerp_speed();
		
		//LD Montello
		//Set to total time
		//so we start reversing
		//from the end of the current
		//lerp.
		cur_time = total_time;
	}
	
	//LD Montello
	//set our image
	//angle using the lerp function
	//based on our current time's progression.
	//smoothstep makes the function ease to each target
	//instead of just locking to it, this makes
	//it look much more natural.
	image_angle = lerp(cur_angle_min, cur_angle_max, smoothstep(cur_time / total_time));
	
	//LD Montello
	//Create varying speed
	//every frame
	//so it looks jittery
	//cur_lerp_speed_scaled = random_range(min_lerp_speed, max_lerp_speed);
	
	//LD Montello
	//increment time
	//because we are NOT reversing.
	cur_time += cur_lerp_speed_scaled;
}

//LD Montello.
//clamp time to a minimum of zero and maximum of the total time
//to avoid negative values.
cur_time = clamp(cur_time, 0, total_time);