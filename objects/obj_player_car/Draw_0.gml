/// @description Insert description here
// You can write your code in this editor

draw_self()

//LD Montello
#region used to verify that vectors worked as expected.

var tempVec = new Vector2(50,50);
Vector2.draw_vector2(tempVec, 15, x, y);

var normalizedVec = tempVec.normalized();
Vector2.draw_vector2(normalizedVec, 505, x, y);
show_debug_message(string(normalizedVec.x) + ", " + string(normalizedVec.y));

#endregion