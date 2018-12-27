# GOMos
Real mode operating system with bootloader forged for learning OSdev and low-level hardware hacking

# Expectation
GOMos should work as fast as possible. It won't utilize any drivers and it's natural way is manipulating real mode RAM memory with direct access to BIOS interrupts. My aims is to create an real i386 assembler simulator, that parses user input and assemblies it in real-time for 1:1 experience. This may be extremely dangerous. 

# Expected usage/ kernel explained
Kernel in GOMos is expected to work in different modes changed by F1-12 keys. Every mode has direct memory access and shares the resources with other modes. 

# Expected modes
 * Mode F1 = Assembler console
 * Mode F2 = HEX RAM editor
 * Mode F3 = Test zone/ playground
 
 # F1 assembler console
 Mode F1 resembles console where you are able to type real assembler commands which will be assemblied. It will contain real register statuses updated after every command inputted and action performed. It would be possible to fire BIOS interrupts, therefore one wrong mnemonic can cause unexpected outcome like jumping to 0x0000 and performing rubbish data as CPU mnemonics
 
![F1 proof of concept image](F1.png?raw=true "Title")
 
 # F2 HEX RAM editor
 Mode F2 resembles casual visual HEX editors, but it's possible to actually overwrite any RAM space you want (including VGA memory totally overwriting the current renderer and breaking whole OS). This way you are able to actually text that you'll be able to use to write in BIOS teletype. 
 
 # F3 Playground
 Mode F3 is meant to work as fun place. I'm not quite sure but I'll be trying to introduce some pseudo-3D rendering or things like that
