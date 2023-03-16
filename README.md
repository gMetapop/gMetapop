# <A HREF="https://github.com/gMetapop/gMetapop"> gMetapop </A>
A process-based forward simulator with an intuitive Graphical User Interface integrating multi-locus genetics and complex age-class structure and demography in subdivided populations.

## Overview ##
gMetapop is an individual-based program that includes an intuitive Graphical User Interface (GUI) for choosing the configuration of evolutionary scenarios. One can simulate very simple to very complex scenarios, allowing for different types of selection and age class structure demography in subdivided populations. **The main steps for running a simulation are summarized <A HREF= "gMetapop-overview-Fig.1-4.pdf"> here </A>**, and **a typical life cycle in gMetapop with possible overlapping generations can be seen <A HREF= "gMetapop-life-cycle-Fig.3.pdf"> here</A>** (see the **User Manual <A HREF="https://github.com/gMetapop/gMetapop/tree/master/3-User.Manual-ver.1.0.0"> here</A>** for detailed legends on those figures).

Individuals are characterized by their genotype at many loci and/or by their phenotype at a given trait coded by quantitative trait loci (QTL). Different types of genes (neutral or under selection) can be simulated, in populations connected by gene flow via zygote migration (e.g. seed flow) or male gamete migration (e.g. pollen flow). Demographic models with overlapping generations are easily simulated (e.g. perennial species such as trees with an age class structure), complex mating systems including selfing and clonal reproduction also. Selection can be applied within and among populations, either on a phenotypic trait or directly by assigning fitness values to each genotype. The total number of loci, individuals, populations and/or reproductive events is only limited by the users’ hardware capacities. 

One main advantage of this tool is its flexible Graphical User Interface (GUI), available under Windows and Linux OS (see Download below). The GUI aims at replacing the cumbersome process of 1) building the large (or many) configuration parameter files which are needed for even relatively simple evolutionary scenarios, and of 2) creating the correct formats for various input data files needed for starting simulations. The users can therefore focus on their biological model. Thanks to the GUI, the simulator can also serve as a great learning/teaching tool for understanding evolutionary processes and their interactions.

There are two main components in the program:  

•	gMetapop_GUI, the interface program which guides the user choosing parameter values and designing simulations, launching them, and getting summary statistics and a graphical overview of some results. Technically, the GUI creates an .xml parameter configuration file (*param* hereafter). This file includes all initial settings and files needed for a simulation run.

•	gMetapop_CORE, the program that uses these files as input to perform simulations. gMetapop_CORE can be launched directly from the GUI or using command lines under Linux or Windows DOS command prompt. gMetapop_CORE initially stemmed from previous programs that included separate and complementary features (Le Corre et al., 1997; Austerlitz et al. 2000; Machon et al., 2003; Austerlitz & Garnier-Géré 2003; Le Corre and Kremer, 2003). However in this first release, 72% of the whole program code is new, and 18% of the original code has been largely modified or extended. 

## Download Section 

• Standalone gMetapop executables files for Linux and Windows OS with all files needed without any installation required can be found <A HREF="https://github.com/gMetapop/gMetapop/tree/master/1-GUI+CORE.exe.for.download"> here</A>. Source files for both GUI and CORE gMetapop can be downloaded <A HREF="https://github.com/gMetapop/gMetapop/tree/master/2-GUI+CORE.src.for.download"> here</A>.

•	All files for each tutorial can also be downloaded from <A HREF="https://github.com/gMetapop/gMetapop/tree/master/5-Tutorials"> here</A>

•	Additional format examples can be seen <A HREF="https://github.com/gMetapop/gMetapop/tree/master/4-Format.Examples"> here</A>

•	Updated versions of the R script for plotting summary statistics across generations can be found <A HREF="https://github.com/gMetapop/gMetapop/tree/master/7-Plotting.R.scripts"> here</A> and simply need to be copied into the folder with the \*.exe files.

## Help ##
Various sources of Help are available: 

•	Default parameter values proposed and automatically loaded in the GUI when making a new *param* file. We chose them so that they were plausible in scenarios corresponding to non-extreme biological conditions. Therefore, users can keep those values as starting points for preliminary tests that focus on particular parameters, provided that they carefully checked if those are compatible with the organisms that they have in mind.

•	Tooltips appear on screen that describe tabs and parameters within the GUI, when moving the “mouse” on the each sub-window/group-box part of the GUI in a Tab. Tooltips are small texts providing definitions and main use of the corresponding GUI options, for a rapid and intuitive appraisal of particular aspects of the modelled processes (see more explanations in Chapter 3 of the User Manual for each GUI option). 

•	Step-by-step tutorials that explain how to reproduce simulations are provided in Chapter 5 of the <A HREF="https://github.com/gMetapop/gMetapop/tree/master/3-User.Manual-ver.1.0.0"> User Manual</A>. All files for each tutorial can also be downloaded from <A HREF="https://github.com/gMetapop/gMetapop/tree/master/5-Tutorials"> here</A>: see the corresponding *param* .xml files to load into the GUI, the configuration file "conf.txt", the type of result file "type.txt" for launching simulations, and various types of results files depending on the scenarios simulated. Some of these *param* files might be better starting points than default parameters in some cases.

•	More explanations can be found in the User Manual on different GUI features and processes modelled in gMetapop_CORE (Chapter 3), on all input and output files (Chapter 4), and on detailed step by step procedure for building *param* files (Chapter 5). 

•	Finally, an <A HREF="https://github.com/gMetapop/gMetapop/tree/master/6-Trouble.Shooting"> online appendix</A> provides more help on possible errors, with error messages being listed and described. 


## How to cite gMetapop? ##

Raspail F, Austerlitz F, Mariette S, Machon N, Le Corre V, Baradat D, Gouyon P-H, Godelle B, Kremer A, Garnier-Géré P (2023) gMetapop: a process-based forward simulator with an intuitive GUI integrating multi-locus genetics and complex age class structure demography in subdivided populations. In preparation 

## License ##

The content of this repository is licensed under <A HREF="https://choosealicense.com/licenses/gpl-3.0/">(GNU GPLv3)</A> 

## Contacts and bug reporting ##
For the gMetapop simulator: Frédéric Raspail frederic.raspail@inrae.fr, Pauline Garnier-Géré pauline.garnier-gere@inrae.fr  
For this repository: Pauline Garnier-Géré pauline.garnier-gere@inrae.fr

For bug reporting, you can also declare a New issue (green button on the right) on the "Issues" page


