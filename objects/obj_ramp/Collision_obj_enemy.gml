/// @description Insert description here
// You can write your code in this editor

//when we collide with the player's
//car say that they are jumping.
//while they are jumping we need to make
//it so that they can't lose/gain
//velocity from acceleration 
//and will instead just keep
//applying their previous velocity until they
//stop colliding with the ramp.

other.is_jumping = true;
other.cur_ramp = self;