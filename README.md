# Plank OS

Plank OS is a tiny interactive x86 system written in 16-bit assembly. Its whole image fits in one 512-byte boot sector. It uses legacy PC BIOS services for display and keyboard input and runs a single foreground console.

The image contains 153 bytes of code and text, 357 bytes of padding, and a two-byte boot signature. A ready-to-boot image is included as [`plank.img`](plank.img).

Build in PowerShell with GNU `as` and `objcopy` on your PATH.

```powershell
.\build.ps1
```

Boot with QEMU.

```powershell
qemu-system-x86_64 -drive file=plank.img,format=raw,if=floppy -boot a
```

Type printable characters to echo them. Press `?` for help, `Enter` for a new line, `Ctrl+L` to clear the screen, or `Esc` to halt the CPU.
