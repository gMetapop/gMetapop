UPDATES
22-11-09 --> The first release v1.0.0 will be uploaded soon

INSTALLATION INSTRUCTIONS

Download the compressed files corresponding to your Operating System (Windows 64 bits=Win64 or Linux 64 bits=Linux64), and extract them into a folder of your choice:

* Under Win64, click on the gMetapop_GUI_Win64.exe to launch gMetapop_GUI, from which gMetapop_CORE_Win64.exe can be launched.

* Under Linux64, unzip the linux version of the program then check that both GUI (i.e. gMetapop_GUI_Lin64.exe) and CORE (i.e. gMetapop_CORE_Lin64.exe), and associated library (i.e. lib*) files have executable rights (or type "chmod +x  \*.\* [or  \*]  to allow for executable permissions). 
gMetapop_GUI is developed in C++ with open-source Qt libraries (https://www.qt.io). These are provided in the current distribution, but additional libraries might be needed if they are not already available from your OS, so please type first (once only): 
> sudo apt-get install libxcb-xinerama0

Then in the folder where the files have been unzipped, the GUI application is launched by typing in command lines:
> sh run_gM_GUI_Linux64.sh 

 or simply 
> ./ run_gM_GUI_Linux64.sh 

which should launch the GUI application. 

* Connecting the R software to the GUI: in order to obtain plots of results after a simulation run, you need to: 

a) Click on "File/Choose R path" in the Menu, once only, 

b) Select the main folder where the last version of R has been installed (e.g. .../R-3.5.0 or later versions), 

c) Then click on "File/Default plot" in the Menu.

In case of installation problems, in particular for gMetapop_GUI under some Linux OS, please contact Frédéric Raspail (frederic.raspail@inrae.fr) or Pauline Garnier-Géré (pauline.garnier-gere@inrae.fr). If needed, we can also provide \*.exe files for a 32-bit Windows OS. 

* Connecting the last version of the User Manual to the GUI: 

a) The last updated version of the User Manual is available **<A HREF="https://github.com/gMetapop/gMetapop/tree/master/3-User.Manual-ver.1.0.0"> here</A>**

b) The first complete version of the User Manual will be distributed with the release 1.0.0 of the program is identified by its date and version on the first page. 

c) In case of a separate update of the User Manual from that of the GUI, it will be included in the current distributed files with changes described here. Just copy the new version in the *.exe* folder to access the new version from the GUI.  
