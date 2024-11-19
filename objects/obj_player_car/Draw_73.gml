/// @description Insert description here
// You can write your code in this editor

var target_x = x + vel_vec[0];
var target_y = y + vel_vec[1];

if (place_meeting(target_x, target_y, bounceables))
{

	// Get the car's 4 corners based on its position and rotation (image_angle)
	var half_width = sprite_width / 2;
	var half_height = sprite_height / 2;

	// Car's center point (current position)
	var cx = x;
	var cy = y;

	// Calculate each corner relative to the center, rotated by image_angle
	var corners = [
	    [cx + dcos(-image_angle) * half_width - dsin(-image_angle) * half_height, cy + dsin(-image_angle) * half_width + dcos(-image_angle) * half_height], // Top-right corner
	    [cx - dcos(-image_angle) * half_width - dsin(-image_angle) * half_height, cy - dsin(-image_angle) * half_width + dcos(-image_angle) * half_height], // Top-left corner
	    [cx - half_width * dcos(-image_angle) + half_height * dsin(-image_angle), cy - half_width * dsin(-image_angle) - half_height *  dcos(-image_angle)], // Bottom-left corner
	    [cx + half_width * dcos(-image_angle) + half_height * dsin(-image_angle), cy + half_width * dsin(-image_angle) - half_height * dcos(-image_angle)]  // Bottom-right corner
	];

	//calculate the normal for the overall collision
	//this will help us calculate depth.
	normal = normalized(angle_to_vector(collision_normal(x, y, bounceables, 32 * 5, 1)));

	// Check each corner for collision and calculate the distance to the nearest edge of the bounding box
	for (var i = 0; i < 4; i++) {
	    var corner = corners[i];
        
		corner[0] += vel_vec[0]
		corner[1] += vel_vec[1]
		
		// If the corner is colliding with a wall
	    if (collision_point(corner[0], corner[1], bounceables, true, true)) {
	        //draw the circle as red,
			//because it is colliding with something
			draw_circle_color(corner[0], corner[1], 5, c_red, c_red, false);
			
			// Calculate the penetration depth in the direction of the normal
	        //var penetration_depth = point_distance(corner[0], corner[1], target_x, target_y) - point_distance(x, y, corner[0], corner[1]);  // Distance to target position
	        
			var penetration_vec = [0,0];
			
			var sentinel = 100;
			
			show_debug_message("START");
			//if (floor(point_distance(corner[0], corner[1], target_x, target_y)) >= 4)
			for (j = floor(point_distance(corner[0], corner[1], target_x, target_y)); j > 0; j--)
			{
				//show_message(i);
				show_debug_message(j);
				//if (i > sentinel)
				//{
				//	break;
				//}
				
				var depth_normal = multiply_scalar(normal, j);
				if (collision_point(corner[0] + depth_normal[0], corner[1] + depth_normal[1], bounceables, true, true))
				{
					penetration_vec = depth_normal;
					x += penetration_vec[0];
					y += penetration_vec[1];
					vel_vec = add(vel_vec, penetration_vec);
					//vel_vec = [0,0]
					break;
				}
				else
				{
					//we are no longer colliding,
					//so this is the final distance to 
					//get the point out of this object.
					penetration_vec = depth_normal;
					continue
				}
			}
			
			draw_line_width(corner[0], corner[1], corner[0] + penetration_vec[0], corner[1] + penetration_vec[1], 4);
			//penetration = max(penetration, penetration_depth); // Track maximum penetration depth
	    }
		else
		{
			//draw as white because we aren't colliding
			draw_circle_color(corner[0], corner[1], 4, c_white, c_white, false);
		}
	}
}