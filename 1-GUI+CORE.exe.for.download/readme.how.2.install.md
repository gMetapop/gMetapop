UPDATES
The first release v1.0.0 will be uploaded soon

INSTALLATION INSTRUCTIONS

Download the compressed files corresponding to your Operating System (Windows 64 bits=Win64 or Linux 64 bits=Linux64, the currently supported versions are for UBUNTU 20.04 LTS, which support will be discontinued mid-2024, and UBUNTU 22.04 LTS), and extract them into a folder of your choice:

* Under Win64, click on the gMetapop_GUI_Win64.exe to launch gMetapop_GUI, from which gMetapop_CORE_Win64.exe can be launched.

* Under Linux64, unzip the Linux version of the program then check that both GUI (i.e. gMetapop_GUI_Lin64.exe) and CORE (i.e. gMetapop_CORE_Lin64.exe), and associated library (i.e. lib*) files have executable rights (or type "chmod +x  \*.\* [or  \*]  to allow for executable permissions). 
gMetapop_GUI is developed in C++ with open-source Qt libraries (https://www.qt.io). These are provided in the current distribution, but additional libraries might be needed if they are not already available from your OS, so please type first (once only): 
> sudo apt-get install libxcb-xinerama0

Then in the folder where the files have been unzipped, the GUI application is launched by typing in the command lines:
> sh run_gM_GUI_Linux64.sh 

 or simply 
> ./ run_gM_GUI_Linux64.sh 

which should launch the GUI application. 

* In case of installation problems, in particular for gMetapop_GUI under some Linux OS, please contact Frédéric Raspail (frederic.raspail@inrae.fr) or Pauline Garnier-Géré (pauline.garnier-gere@inrae.fr). If needed, we can also provide \*.exe files for older 32-bit Windows OS. 

* Connecting the R software to the GUI: to obtain plots of results after a simulation run, you need to: 

a) Click on "File/Choose R path" in the Menu, once only, 

b) Select the main folder where the last version of R has been installed (e.g. .../R-3.5.0 or later versions), 

c) Then the "File/Default plot" or "File/Custom plot" menus will be active once a Working directory is selected in the "Run tab" of the GUI.


* Connecting the most recent version of the User Manual to the GUI: 

If an updated version of the User Manual is produced (see the date for update), it is available **<A HREF="https://github.com/gMetapop/gMetapop/tree/master/3-User.Manual-ver.1.0.0"> here</A>**. You just need to replace the previous version (located in the program *.exe* folder) with this one to access it from the GUI. 
