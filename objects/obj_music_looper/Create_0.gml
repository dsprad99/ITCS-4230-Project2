/// @description Insert description here
// You can write your code in this editor




//LD Montello
//if there is a song
//in the cur_song variable
//end the song.
if (audio_exists(global.cur_song))
{
	audio_stop_sound(global.cur_song);
}

//play the song and loop it.
global.cur_song = audio_play_sound_on(global.music_emitter, song_to_loop, true, 1);

//LD Montello,
//if we are supposed
//to set the music loop times,
//do it now.
if (use_loop_start_time)
audio_sound_loop_start(global.cur_song, loop_start_time);

if (use_loop_end_time)
audio_sound_loop_end(global.cur_song, loop_end_time);
