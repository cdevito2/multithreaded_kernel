all:
	nasm -f bin ./boot.asm -o ./boot.bin
	#
	dd if=./message.txt >> ./boot.bin
	#write 1 sector just after the message that we put in 
	#dd is responsible for reading , >> pipes to file to append it
	#boot.bin is our virtual hard disk
	dd if=/dev/zero bs=512 count=1 >> ./boot.bin