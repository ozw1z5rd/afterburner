### afterburner



## 1.st READ THIS  [HCG18](https://www.homecomputer.group/index/2023/july-2023)



This is an Arduino shield to program GALs


Supported GAL chips:
---------------------

| | Atmel | Lattice | National | ST |
| --- | --- | --- | --- | --- |
| 16V8 | ATF16V8B, ATF16V8BQL, ATF16V8C | GAL16V8A, GAL16V8B, GAL16V8D | GAL16V8 | GAL16V8 |
| 18V10 | - | GAL18V10, GAL18V10B[1] | - | - |
| 20V8 | ATF20V8B | GAL20V8B | GAL20V8 | - |
| 20RA10 | - | GAL20RA10, GAL20RA10B | - | - |
| 20XV10 | - | GAL20XV10B | - | - |
| 22V10 | ATF22V10B, ATF22V10C, ATF22V10CQZ | GAL22V10B, GAL22V10D | - | - |
| 6001 | - | GAL6001B | - | - |
| 6002 | - | GAL6002B | - | - |
| 26CV12 | - | GAL26CV12B[2] | - | - |
| 26V12 | - | GAL26V12C[2] | - | - |
| 750 | ATF750C | - | - | - |

[1]: requires PCB v.3.1 or modified PCB v.3.0 - see Troubleshooting  
[2]: requires adapter - see gerbers, pcb and img directory  
[-]: - represents either this combination does not exist or hasn't been tested yet. Testers are welcome to report their findings.

**This is a new Afterburner design with variable programming voltage control and with single ZIF socket for 20 and 24 pin GAL chips.**
The PC software is backward compatible with the older Afterburner desgin/boards.
You can still access the older/simpler ![design here](https://github.com/ole00/afterburner/tree/version_4_legacy "Afterburner legacy")


The new design features:

* variable programming voltage control via digital potentiometer
* single 24 pin ZIF socket for 16V8, 20V8 and 22V10 GALs. The adapter for GAL20V8 is no longer needed.
* simpler connection to MT3608 module (no need to modify the module)
* both Through Hole and SMT footprints present on a single PCB. This allows
  to mix & match SMT and TH parts based on your skills and components availability.

Drawbacks compared to the old Afterburner design:

* more parts required, most notably the digital pot MCP4131 and a shift register 74hc595
* a few more steps during initial VPP calibration. But once the calibration is done it does not need to be changed for different GAL chips.
* the PCB design for etched  board is no longer provided because of the higher complexity. Please use a PCB fabrication service or use the older Afterburner design (see above).


Setup:
---------------------

* Upload the afterburner.ino sketch to your Arduino UNO. Use Arduino IDE to upload the sketch, both IDE version 1.8.X and 2.X should work.

* Build the Afterburner hardware. Buy the PCB from the an online PCB production service (use provided gerber archive in 'gerbers' directory). Then solder the components on the PCB - check the schematic.pdf and BOM.txt for parts list.

* Compile the afteburner.c to get afterburner executable. Run
  ./compile.sh to do that. Alternatively use the precompiled binaries in the 'releases' directory.


* With the GAL chip inserted and power button pressed (or in ON position) check the chip identification by running the following command:
  <pre>
  ./afterburner i -t [GAL_type]
  </pre>

  If you get some meaningful GAL chip identification like:
  <pre>
  PES info: Atmel ATF16V8B  VPP=10.0 Timing: prog=10 erase=25
  </pre>
  then all should be well and you can try to  erase the chip and then program it to contain your .jed file.

  If you get an unknown chip identification like:
  <pre>
  PES info: 3.3V Unknown GAL,  try VPP=10..14 in 1V steps
  </pre>
  then look at the troubleshooting section

* Read the content fo your GAL chip. This only works if the contents
  of the chip is not protected. Use the following command:
  <pre>
  ./afterburner r -t [GAL_type]
  </pre>
  or to save the printed .jed fuse map  to a file use:
  <pre>
  ./afterburner r -t [GAL_type] > my_gal.jed
  </pre>
  
* Erase the GAL chip. Before writing / programming the chip it must
  be erased - even if it is a brand new chip that has not been used 
  before. Use the following command:
  <pre>
  ./afterburner e -t [GAL type]
  </pre>

* Program and verify the GAL chip via the following command:
  <pre>
  ./afterburner wv -t [GAL type] -f my_new_gal.jed
  </pre>

* If you are not sure which GAL type strings are accepted by Afterburner, simply set a wrong type and it will print the list of supported types: 
  <pre>
  ./afterburner wv -t WHICH
  </pre>

How aferburner works:
---------------------
- PC code reads and parses .jed files, then uploads the data to Arduino via serial port. By default /dev/ttyUSB0 is used, but that can be changed to any other serial port device by passing the following option to afterburner:
  <pre>
  -d /my/serial/device
  </pre>

- PC code of afterburner communicates with Arduino UNO's afterburner
  sketch by a trivial text based protocol to run certain commands (like erase, read, write, upload data etc.). If you are curious, you can also connect directly to Arduino UNO via serial terminal and issue some basic commands manually.

- Arduino UNO's afterburner sketch does 2 things: 
  * parses commands and data sent from the PC afterburner app
  * toggles the GPIO pins and drives programming of the GAL contents

- more information about GAL chips and their programming can be found here:

  http://www.bhabbott.net.nz/atfblast.html
  
  http://www.armory.com/%7Erstevew/Public/Pgmrs/GAL/_ClikMe1st.htm 


PCB:
---------------
The new design no longer has an etched PCB design available. The most convenient way to get the PCB is to order it online on jlcpcb.com, pcbway.com, allpcb.com or other online services. Use the zip archive stored in the gerbers directory and upload it to the manufacturer's site of your choice.
  Upload the afterburner_fab_3_0.zip and set the following parameters (if required). 
  
  * Dimensions are 79x54 mm
  * 2 layer board
  * PCB Thickness: 1.6, or 1.2
  * Copper Weight: 1
  * The rest of the options can stay default or choose whatever you fancy (colors, finish etc.)
  


Other GAL related links:
------------------------
- GAL chip info: https://k1.spdns.de/Develop/Projects/GalAsm/info/galer/gal16_20v8.html

- GAL chip programming protocol info: https://k1.spdns.de/Develop/Projects/GalAsm/info/galer/proggal.html

- GALmate: another open source GAL programmer: https://www.ythiee.com/2021/06/06/galmate-hardware/
  
- JDEC file standard 3A: https://k1.spdns.de/Develop/Projects/GalAsm/info/JEDEC%20File%20Standard%203A.txt
  
- GAL Asm : https://github.com/dwery/galasm

- GAL Asm online compiler: https://rhgndf.github.io/galasm-web/

- PLD and GAL info: https://github.com/peterzieba/5Vpld

- Fusemap info:
    * https://blog.frankdecaire.com/2017/01/22/generic-array-logic-devices/
    * https://blog.frankdecaire.com/2017/02/25/programming-the-gal22v10/
 
- CUPL Reference: https://web.archive.org/web/20220126145737/https://ee.sharif.edu/~logic_circuits_t/readings/CUPL_Reference.pdf
