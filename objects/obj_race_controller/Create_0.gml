/// @description Insert description here
// You can write your code in this editor

//LD Montello.
//Start the race
//in this many seconds.
seconds_till_race_start = 3;

//LD Montello
//On create 
//we'll have the countdown happen
//and start the race
show_message("Start Race")
alarm_set(0, game_get_speed(gamespeed_fps)*seconds_till_race_start);