/// @description Insert description here
// You can write your code in this editor

//destroy the priority queue to avoid memory leaks.
ds_priority_destroy(car_placement_queue);
ds_priority_destroy(copy_queue);

ds_list_destroy(final_placements_list);