#include "kernel.h"


uint16_t *video_mem = 0;

/* given a character and a color code make the char to print on the screen */
uint16_t terminal_make_char(char character, char colour)
{
    //example color A = 0x0341 . what this function does
    //is moves color 0x03 to the second byte
    //so it first look : 0x0300
    //then it does an OR with 0x41 which results in it
    //looking like 0x0341 which is the proper format
    return (colour << 8) | character;
}

/* this function loops throough terminal and clears it */
void terminal_initialize()
{
    video_mem = (uint16_t*) (0xB8000); //pointer to where the video mem should start
    
    for (int y=0;y<VGA_HEIGHT;y++)
    {
        for (int x=0;x<VGA_WIDTH;x++)
        {
            //clear the 2D grid
            video_mem[(y * VGA_WIDTH)+x] = terminal_make_char(' ',0);

        }
    }
}

void kernel_main()
{
    terminal_initialize();
}