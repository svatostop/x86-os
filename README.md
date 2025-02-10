# OS on x86 assembly
simple OS
## tools
- [fasm](https://flatassembler.net/)
- [QEMU emulator](https://www.qemu.org/)
## build
```
fasm boot.asm boot.bin
fasm print.asm print.bin
cat boot.bin print.bin > result.bin
```
## run
```
qemu-system-x86_64 -drive format=raw,file=result.bin -nographic
```

## Labels and Their Purpose

### `print_string`
Prints a string to the screen using BIOS interrupt. The string is stored in memory at address `si`.

### `type_char`
Waits for a character input from the keyboard. Once a character is received:
- If it is `Backspace`, calls `backspace`.
- If it is `Enter`, calls `cursor_enter`.
- Otherwise, the character is displayed on the screen and added to the buffer, then `print_buffer` is called.

### `print_buffer`
Displays the first character from the buffer using `int 10h`.

### `backspace`
Deletes the last entered character by moving the cursor back, overwriting it with a space, and shifting the cursor back again.

### `cursor_enter`
Moves the cursor to a new line by increasing `dh` (row number) and setting `dl = 0` (beginning of the line).

### `welcome`
Displays a welcome message and moves the cursor to a new line.

