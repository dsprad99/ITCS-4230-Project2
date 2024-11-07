/// @description start the race
// You can write your code in this editor

//LD Montello
//Display something
//that shows the race has started
show_message("GO!")

//LD Montello
//For all enemies
//say that they can move
//when the race starts.
with (obj_enemy)
{
	can_move = true;
}

//LD Montello
//say that the player car can
//move.
with (obj_player_car)
{
	can_move = true;
}