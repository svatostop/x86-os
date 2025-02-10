# OS on x86 assembly
simple OS
# tools
- [fasm](https://flatassembler.net/)
- [QEMU emulator](https://www.qemu.org/)
# build
```
fasm boot.asm boot.bin
fasm print.asm print.bin
cat boot.bin print.bin > result.bin
```
# run
```
qemu-system-x86_64 -drive format=raw,file=result.bin -nographic
```
