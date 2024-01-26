#include "kernel.h"
#include <stddef.h>
#include <stdint.h>
#include "idt/idt.h"

uint16_t *video_mem = 0;
uint16_t terminal_row = 0;
uint16_t terminal_col = 0;

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

//take in x coordinate, y coordinate, character and color for character
void terminal_put_char(int x, int y, char c, char colour)
{
    video_mem[(y * VGA_WIDTH)+x] = terminal_make_char(c,colour);
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
            terminal_put_char(x,y,' ',0);

        }
    }
}

/* function to print a string on the terminal */
void terminal_writechar(char c, char colour)
{
    //this function will take char and colour, write to terminal
    //and increment a position to ensure next time its called it will
    //write to a different column


    //handle newline character - need to inccrmeent
    if (c =='\n')
    {
        terminal_row+=1;
        terminal_col = 0;
        return;
    }
    terminal_put_char(terminal_col, terminal_row, c, colour);

    //ensure column incremented by 1 each time to not overwrite chars
    terminal_col += 1;
    //if we reach the end of the column we have to loop around
    if (terminal_col >= VGA_WIDTH)
    {
        terminal_col = 0;
        terminal_row += 1;
    }
}

/* Function to determine length of string*/
size_t strlen(const char *str)
{
    size_t length = 0;
    //loop until we hit the nuuuuull terminating character
    while (str[length])
    {
        length++;
    }
    return length;
}

void print(const char *str)
{
    //get the length of the string
    //then print the string character by character
    size_t length = strlen(str);
    for (int i=0;i<length;i++)
    {
        terminal_writechar(str[i],15);
    }

}

void kernel_main()
{
    terminal_initialize();
    print("Hello World!");
    idt_init();//initialize interrupt descriptor table
}