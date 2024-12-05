/// @description Insert description here
// You can write your code in this editor
// Draw the sprite
draw_self();

// Set the font
draw_set_font(fnt_gamecuben);
draw_set_halign(fa_center)
draw_set_valign(fa_middle)


// Get the sprite's height (assuming the sprite is assigned to the instance)
var curr_sprite_height = sprite_get_height(sprite_index);

// Calculate the y-position for the upper-center text (moving it upward)
var text_y = y - curr_sprite_height / 2;


//draw_text_ext_transformed(x, text_y, text_to_draw, 50, 300,.05,.05,0)

draw_set_valign(-1)
draw_set_halign(-1)
draw_set_font(-1)



