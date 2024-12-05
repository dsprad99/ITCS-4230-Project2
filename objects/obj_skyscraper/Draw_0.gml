/// @description Insert description here
// You can write your code in this editor

//draw_self()

var total = 10;

var height_between_segments = 1;

for (var i = total; i > 0; i--)
{
	//calculated the scaled width and height of this segment.
	var scaled_width = i / total * sprite_get_width(spr_building_segment) * 5
	var scaled_height = i / total * sprite_get_height(spr_building_segment) * 5
	
	//get the center of our building.
	var x_pos = (x - (image_xscale * 96 / 2));
	var y_pos = (y - (image_xscale * 96 / 2));
	
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
	
	draw_sprite_stretched(spr_building_segment, 0, x_pos + x_offset, y_pos + y_offset, scaled_width, scaled_height);
}