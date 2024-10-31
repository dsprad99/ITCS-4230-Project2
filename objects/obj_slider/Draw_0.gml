/// @description Insert description here
// You can write your code in this editor

//LD Montello
//Draw self (Slider bar)
draw_self()


//LD Montello
//Draw fill bar for slider
//Draw from x_min + (cur_x / 2)
//to set it at the center of the area between the
//min_x and the slider itself.
//then, for the width we'll calculate
//that by doing width * (cur_value - min_value) / (max_value - min_value)
//(cur_value - min_value) / (max_value - min_value) gives us a 0-1 value
//of how complete the bar is.
//then dividing by 32 as that's the sprite size.
draw_sprite_ext(spr_slider_bar_nine_slice, 0, (center_x - (slider_width / 2)) + (cur_offset / 2), center_y, slider_width * (cur_value - min_value) / (max_value - min_value) / 32, 1, 0, c_fill, 1) 

//LD Montello
//Draw slider
draw_sprite_ext(spr_slider_bar_nine_slice, 0, cur_x, center_y, slider_x_scale, slider_y_scale, 0, slider_color, 1)

//LD Montello
//Set the font
//Make the text pivot be the center of the text.
draw_set_font(fnt_gamecuben)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_set_color(c_white);

//LD Montello
//Draw the text that describes this slider
//above it.
//48 / 72 just gives us a scale equal
//to font size 48 for this font as this font
//is 72 at it's default size, size 1 = 72.
draw_text_transformed(center_x, center_y - text_vertical_offset, display_name, font_size / 72, font_size / 72, 0);

//LD Montello
//Draw the value of the slider on the slider
draw_text_transformed(cur_x, center_y, cur_value, 16 / 72, 16 / 72, 0);

//LD Montello
//Go back to default alignment.
draw_set_valign(-1)
draw_set_halign(-1)
//Go back to default font
draw_set_font(-1)
draw_set_color(-1);

//Draw mouse positino
//draw_text(mouse_x, mouse_y, string(mouse_x) + ", " + string(mouse_y))

//Draw slider hit box.
//draw_rectangle_color(left_bound, lower_bound, right_bound, up_bound, c_blue, c_blue, c_blue, c_blue, true)