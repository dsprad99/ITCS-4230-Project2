/// @description Insert description here
// You can write your code in this editor


//Where LD got the basis for this tiling
//code: https://www.reddit.com/r/gamemaker/comments/46g3zm/is_it_possible_to_tile_a_sprite_over_a_single/

//heavily modified code is below:

//get start_x and y assuming the pivot of the object is set to "center"
var start_x = x - (image_xscale*sprite_get_width(sprite_index)/2)
var start_y = y - (image_yscale*sprite_get_height(sprite_index)/2)

var end_x = x + (image_xscale*sprite_get_width(sprite_index)/2);
var end_y = y + (image_yscale*sprite_get_height(sprite_index)/2);

//calculate the size of each tile
//by getting the size of the sprite
//we want to use and then multiply
//by the scale we want the tile to be
//drawn at which is five.
var tile_width = sprite_get_width(FinishLineRainbow_Small) * 5;
var tile_height = sprite_get_height(FinishLineRainbow_Small) * 5;

//loop based off of how many sprites we can
//fit in the current scale.
for(i=0; i<image_xscale*sprite_get_width(sprite_index) / tile_width; i++){
    for(j=0; j<image_yscale*sprite_get_height(sprite_index) / tile_height; j++){
        
		//find difference in size and then divide by 5 so it's
		//scaled down properly.
		//this ensures the image cuts off at the width
		//of the current object.
		var xdif = ((start_x + i*tile_width + tile_width) - end_x) / 5;
		var ydif = ((start_y + j*tile_height + tile_height) - end_y) / 5;
		//if there is some amount overlap for the edges of this
		//object, draw it with the cutoff part implemented.
		if (xdif > 0 and ydif <= 0)
		//if we only overlap on the right 
			draw_sprite_part_ext(FinishLineRainbow_Small, image_index, 0, 0, sprite_get_width(FinishLineRainbow_Small)-xdif, sprite_get_height(FinishLineRainbow_Small), start_x+(i*tile_width), start_y+(j*tile_height), 5, 5, c_white, 1)
		else if (xdif <= 0 and ydif > 0)
		//if we only overlap on the bottom
			draw_sprite_part_ext(FinishLineRainbow_Small, image_index, 0, 0, sprite_get_width(FinishLineRainbow_Small), sprite_get_height(FinishLineRainbow_Small)-ydif, start_x+(i*tile_width), start_y+(j*tile_height), 5, 5, c_white, 1)
		else if (xdif > 0 and ydif > 0)
		//if we overlap on both the right and the bottom.
			draw_sprite_part_ext(FinishLineRainbow_Small, image_index, 0, 0, sprite_get_width(FinishLineRainbow_Small)-xdif, sprite_get_height(FinishLineRainbow_Small)-ydif, start_x+(i*tile_width), start_y+(j*tile_height), 5, 5, c_white, 1)
		//draw normally.
		else
		{
			//draw_sprite(FinishLineRainbow_Small, image_index, x+(i*sprite_get_width(FinishLineRainbow_Small)), y+(j*sprite_get_height(FinishLineRainbow_Small)));
			draw_sprite_stretched(FinishLineRainbow_Small, image_index, start_x+(i*tile_width), start_y+(j*tile_height), tile_width,tile_height);
		}
		//LD's debug to draw a black and white checker board
		//to make sure tiling works.
		//if (i % 2 == 0 and j % 2 == 1 or i % 2 == 1 and j % 2 == 0)
		//{
		//	draw_rectangle(start_x+(i*tile_width), start_y+(j*tile_height), start_x+tile_width+(i*tile_width), start_y+tile_height+(j*tile_height), false);
			
		//}
	}
}

//LD Debug
//for drawing the borders of the original sprite.
draw_rectangle_color(x - (image_xscale*sprite_get_width(sprite_index)/2), y - (image_yscale*sprite_get_height(sprite_index)/2), x + (image_xscale*sprite_get_width(sprite_index)/2), y + (image_yscale*sprite_get_height(sprite_index)/2), c_white, c_white, c_white, c_white, true);