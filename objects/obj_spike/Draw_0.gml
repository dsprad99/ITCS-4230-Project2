/// @description Insert description here
// You can write your code in this editor

//draw_self()

var total = 50;

var height_between_segments = 0.2;

for (var i = total; i > 0; i--)
{
	//calculated the scaled width and height of this segment.
	var scaled_width = i / total * sprite_get_width(spr_spike) * 5
	var scaled_height = i / total * sprite_get_height(spr_spike) * 5
	
	//get the center of our building.
	var x_pos = (x - (image_xscale * sprite_get_width(spr_spike) / 2));
	var y_pos = (y - (image_xscale * sprite_get_width(spr_spike) / 2));
	
	//calculate x_offset
	//first gett the center of the camera.
	var x_offset = camera_get_view_x(cam) + camera_get_view_width(cam) / 2;
	//x_offset = distance on the x from
	//camera to the building
	x_offset = x - x_offset;
	//scale relative to our current segment.
	x_offset *= height_between_segments * (1 - i / total);
	
	//calculate y_offset
	//first gett the center of the camera.
	var y_offset = camera_get_view_y(cam) + camera_get_view_height(cam) / 2;
	//y_offset = distance on the y from
	//camera to the building
	y_offset = y - y_offset;
	//scale relative to our current segment.
	y_offset *= height_between_segments * (1 - i / total);
	
	//LD Montello
	//make the depth within our
	//current layer increase
	//when the distance to the camera
	//increases. 
	//Basically, the closest skyscraper
	//is drawn last so that it appears "on top"
	//of other skyscrapers.
	//This works suprisingly well.
	//basically, we get a 0-1 value
	//by taking the offset from the camera position
	//of the skyscraper and then we multiply by 100
	//to figure out how deep within this layer (each layer is 100)
	//we are, and then we add that to the base depth.
	//we do this every frame.
	//we do this for both x and y offset.
	depth = (base_depth + (abs(x_offset) / camera_get_view_width(cam) * 100) + (abs(y_offset) / camera_get_view_height(cam) * 100))
	
	draw_sprite_stretched(spr_spike, 0, x_pos + x_offset, y_pos + y_offset, scaled_width, scaled_height);
}