nasm Sector1/bootloader.asm -f bin -o bin/bootloader.bin
nasm Sector2+/ExtProg.asm -f elf64 -o bin/ExtProg.o
x86_64-elf-gcc -ffreestanding -mno-red-zone -m64 -c "cpp/Kernal.cpp" -o "bin/Kernal.o"
custom-ld -o bin/kernal.tmp -Ttext 0x7e00 bin/ExtProg.o bin/Kernal.o
objcopy -O binary bin/kernal.tmp bin/kernal.bin
copy /b bin\bootloader.bin+bin/kernal.tmp bootloader.flp
pause
