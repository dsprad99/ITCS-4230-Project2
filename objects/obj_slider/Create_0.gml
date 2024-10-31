/// @description Init vars
// You can write your code in this editor

//LD Montello
//the current color of the slider
slider_color = c_idle;

//LD Montello
//These are now variable definitions.
//The min and max values of this slider
//min_value = 0
//max_value = 1

//The size (in pixels) of the slider width
//slider_width = 700;
//Converted slider width to a variable definition.

//The scale we need to set our nine-slice sprite
//to match the slider width.
image_xscale = slider_width / 32

//LD Montello
//the scale of the
//the object the player grabs
//to slide along the bar
slider_x_scale = 2;
slider_y_scale = 2;

//LD Montello
//Is the user's mouse hovering
//over the grabbable slider?
is_hovering_slider = false;


//LD Montello
//Is the user's mouse clicking
//over the grabbable slider?
is_holding_slider = false;

//LD Montello
//Get the camera
cam = view_get_camera(0);

//Calculate our center
//position relative to the camera.
center_x = camera_get_view_x(cam) + screen_x//camera_get_view_width(cam) / 2
center_y = camera_get_view_y(cam) + screen_y/* camera_get_view_height(cam) / 2*/

//LD Montello
//The current offset
//from the min x of the slider
cur_offset = 0

//LD Montello
//The current x value of the grabbable slider
cur_x = 0

//LD Montello
//recalculate center values.
recalculate_center_values = function()
{
	//Recalculate center values.
	center_x = camera_get_view_x(cam) + screen_x//camera_get_view_width(cam) / 2
	center_y = camera_get_view_y(cam) + screen_y//camera_get_view_height(cam) / 2
}

set_cur_value = function(_value)
{
	//LD Montello
	//clamp to min and max values
	cur_value = clamp(_value, min_value, max_value)
	
	recalculate_center_values()
	
	//Calculate offset from the leftmost
	//point to the desired point to calculate
	//where to draw the sprite.
	cur_offset = (slider_width * ((cur_value - min_value) / (max_value-min_value)));
}

//LD Montello,
//Set the current value to match the default value in 
//variable definitions
set_cur_value(cur_value);

//LD Montello
//The bounds of the hitbox 
//for the grabbable slider.
left_bound = cur_x - slider_x_scale / 2
right_bound = cur_x + slider_x_scale / 2
up_bound = center_y - slider_y_scale / 2
lower_bound = center_y + slider_y_scale / 2 