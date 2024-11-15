/// @description Insert description here
// You can write your code in this editor

draw_self()

draw_path(track_path, 0, 0, true);

draw_vector2_color(multiply_scalar(normalized(heading_vec), 50), 15, x, y, c_yellow);

draw_vector2_color(multiply_scalar(normalized(left_perp_vec), left_dist), 15, path_point_x, path_point_y, c_green);
draw_vector2_color(multiply_scalar(normalized(right_perp_vec), right_dist), 15, path_point_x, path_point_y, c_blue);