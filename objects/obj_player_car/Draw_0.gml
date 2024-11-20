/// @description Insert description here
// You can write your code in this editor

if (should_draw)
	draw_self()
	
	
if (global.in_debug)
{

//draws the bounding box of the object
draw_sprite_ext(spr_pixel, 0, x, y, sprite_width / 2, sprite_height / 2, image_angle, c_white, 0.5);

draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_top, false); // Top line



//LD Montello
#region used to verify that vectors worked as expected.

//I draw tempVec twice
//so that I know for sure
//when calling tempVec.normalized()
//that tempVec isn't getting set to it's normalized
//value.
//var tempVec = new Vector2(50,50);
//Vector2.draw_vector2(tempVec, 15, x, y);

//var normalizedVec = tempVec.normalized();
//Vector2.draw_vector2(normalizedVec, 505, x, y);
//show_debug_message(string(normalizedVec.x) + ", " + string(normalizedVec.y));

//Vector2.draw_vector2_color(tempVec, 15, x, y, c_aqua);

//LD Montello
//we normalize the velocity vector so that it's magnitude
//is 1, this means when we multiply by a scalar we are
//essentially "setting" it's magnitude to that scalar value.
//while still maintaining the original direction.
//This is a concept known as "Vector Projection"
//We'll decide the length of the draw vector
//by multiplying our desired max length
//for the visual of the vector by the percentage
//for how close we are to the max speed.
var scaled_vec = normalized(vel_vec);
scaled_vec = multiply_scalar(scaled_vec, 100 * (magnitude(vel_vec) / max_speed));

//Draw the velocity vector
//so we can see how fast they
//are going.
draw_vector2_color(scaled_vec, 15, x, y, c_yellow);
//show_debug_message(string(vel_vec.x) + ", " + string(vel_vec.y) + ", magnitude:" + string(vel_vec.magnitude()));

//Draw the normal vector of any objects we hit.
draw_vector2_color(multiply_scalar(normalized(normal), 100), 15, normal_x, normal_y, c_white);

draw_text_transformed_color(x, y, image_angle, 5, 5, 0, c_black, c_black, c_black, c_black, 1);

}

//Davis Spradling
//This will be used for when in a tutorial to 
//show the controls for the player to move a car
if(in_tutorial){
	var cam = view_camera[0];
	var cam_x = camera_get_view_x(cam)-100;
	var cam_y = camera_get_view_y(cam)+100;

	//add margin to create an offset
	var margin = 20;
	var draw_x = cam_x+camera_get_view_width(cam)-margin;
	var draw_y = cam_y+margin;
	var arrow_size = 20;

	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);

	//spacing variables to help space out text for arrow controls
	var horizontal_spacing = 200;  
	var vertical_spacing = 80;   

	draw_set_color(c_white);

	draw_set_font(fnt_gamecuben);
	draw_text_transformed(draw_x - horizontal_spacing-200, draw_y-50, "Controls", 0.4, 0.4, 0);

	//draw up arrow
	draw_triangle(draw_x-horizontal_spacing, draw_y, draw_x-horizontal_spacing-arrow_size, draw_y+arrow_size, draw_x-horizontal_spacing + arrow_size, draw_y+arrow_size, false);
	draw_text_transformed(draw_x-horizontal_spacing-200, draw_y, "Forward", 0.3, 0.3, 0); 

	//draw right arrow
	draw_triangle(draw_x-horizontal_spacing, draw_y + vertical_spacing, draw_x-horizontal_spacing+arrow_size, draw_y+vertical_spacing - arrow_size, draw_x-horizontal_spacing+arrow_size, draw_y+vertical_spacing+arrow_size, false);
	draw_text_transformed(draw_x-horizontal_spacing-200, draw_y + vertical_spacing, "Left", 0.3, 0.3, 0);

	//draw left arrow
	draw_triangle(draw_x-horizontal_spacing, draw_y+vertical_spacing*2, draw_x-horizontal_spacing-arrow_size, draw_y+vertical_spacing*2 - arrow_size, draw_x-horizontal_spacing - arrow_size, draw_y+vertical_spacing*2+arrow_size, false);
	draw_text_transformed(draw_x-horizontal_spacing-200, draw_y+vertical_spacing * 2, "Right", 0.3, 0.3, 0); 

	//draw down arrow
	draw_triangle(draw_x-horizontal_spacing, draw_y + vertical_spacing*3, draw_x-horizontal_spacing-arrow_size, draw_y+vertical_spacing*3 - arrow_size, draw_x-horizontal_spacing + arrow_size, draw_y+vertical_spacing*3-arrow_size, false);
	draw_text_transformed(draw_x-horizontal_spacing-200, draw_y + vertical_spacing * 3, "Down", 0.3, 0.3, 0);

	//reset allignment for any other drawing
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

}

#endregion