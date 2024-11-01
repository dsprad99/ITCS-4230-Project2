/// @description Insert description here
// You can write your code in this editor

draw_self()

draw_path(track_path, 0, 0, true);

Vector2.draw_vector2_color(heading_vec.normalized().multiply_scalar(50), 15, x, y, c_yellow);