/// @description Insert description here
// You can write your code in this editor

on_checkered_obj = true;

//LD Montello
//This event is
//only called when we're allowed
//to pass through it.
//this is because within our collision
//resolution code we call this method below as well
//to know if we're allowed to pass through the 
//checkered_obj or not.
//if we're preventing collisions with the checkered_obj
//this collision event is never called, so we have to 
//do this in 2 places.
on_checkered_obj_collision(other);


