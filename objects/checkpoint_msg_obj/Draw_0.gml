/// @description Insert description here
// You can write your code in this editor
// Draw the sprite
draw_self();

// Set the font
draw_set_font(fnt_gamecuben);

// Get the sprite's height (assuming the sprite is assigned to the instance)
var curr_sprite_height = sprite_get_height(sprite_index);

// Calculate the y-position for the upper-center text (moving it upward)
var text_y = y - curr_sprite_height / 2;

// Draw the text at the upper center of the sprite
draw_text(x, text_y, txt1);
draw_text(x, text_y + 80, txt2);  // Adjusted for the smaller font size
draw_text(x, text_y + 160, txt3);

