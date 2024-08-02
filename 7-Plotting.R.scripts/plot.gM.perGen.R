###########################################################
## plot.gM.perGen.R: Script for the "Default plot" option in the File menu of gMetapop_GUI
## Pauline GARNIER-GERE 
## R script in the gMetapop *.exe folder 
## SEE most recent CHANGES history below

## This script uses Base R packages only, to ease installation and possible changes of legend choices
## Updated scripts after the first release will be uploaded on the gMetapop website
## at https://github.com/gMetapop/gMetapop/tree/master/7-Plotting.R.scripts
## for an exhaustive list and definitions of plotted statistics and their abbreviations in the legend, 
## and also for a list of the main parameter values from the conf.txt summarized in the legend also,
## please see Table 4.4.2  of the User Manual.

## 1) It can be launched from gMetapop GUI with the Default plot option (normal use)
## 2) OR from the gMetapop GUI with the "Custom plot" option with its 2 main arguments (i.e., res1_per_pop_1.txt and a plot name, compulsory), 
#     and more arguments if minor modifications are made to the script (see end of script)
## 3) OR in a command line under a dos or linux prompt
## 4) or from a Tinn-R or Rstudio editor

## 1) Normal use: "Default plot"  (See the part 3.9 of the User Manual for more informations) 
# Choose "Default plot" in the Menu
# --> this copies the R program in the working folder from where it is launched
# --> the files needed are the text configuration file named "conf.txt" and the corresponding "res1_per_gen_1.txt" file
# "res1_per_pop_1.txt" is also used if available. If a configuration text file was used that has a different name, 
#you need to rename it "conf.txt" before using the default R script, otherwise modify the script. 

# This script can also be modified and used as a new default script from the gMetapop *.exe folder with the same name
# plot.gM.perGen.r, as long as the plot.perGen FUN keeps its first 2 arguments (i.e res.2.plot=result.file,plot.name=plot.na) (see end of script)
# More changes can be done throughout FUN other arguments and the legend description

## 2) "Custom plot" use from the GUI File Menu (see part 3.9.2 and various examples in the tutorials (Chapter 5) in the User Manual)
#  This option can be used with any R script having a minimum of 2 arguments:
#  argument 1 for a result file name (or any other file name that does exist or is created, even a dummy one),
#  and argument 2 for a plot name that will saved, and visualized as a *.png file in the GUI

#  This option can also be used with the Default plot script (modified or not)
#  For example, click "Menu/Custom plot" from the Run Tab, then type  "plot.gM.perGen.R res1_per_gen_1.txt newplot" in the command window (with no quotes)
# --> the same plot than the default plot is produced with the name "newplot.png".
# The interest in using the Default plot script with the Custom plot option is to change some argument values for particular simulations while keeping the original script in the *.exe folder 
# In this command plot.gM.perGen.R can be renamed (recommended), "res1_per_gen_1.txt" also as long as it has the same format and similar colnames than
# the original "res1_per_gen_1.txt". Any plot name can be used.
# the default plot script can be modified to detect additional arguments directly from the command line window for custom plot 
#(for example for selecting which statistics to plot), see the # define argument X ... lines at the end of the script and add argument 3, 4 etc 

## 3) Command line under a Dos or Linux prompt:
# for example
# C:\path.of.Rscript.exe\Rscript.exe plot.gM.perGen.R res1_per_gen_1.txt plot.name
# Example  # "C:\Program Files\R\R-3.3.3\bin\x64\Rscript.exe" plot.gM.perGen.R res1_per_gen_1.txt plot.name

# Warning: in the case of selection on genotypes, if the range of max number of alleles for loci under selection is edited by hand (and thus varies)
#  information about migration, mutation, and recombination rates, and paternal inheritance won't be indicated in the plot legend, unless you edit this script 

# Plot.perGen() function arguments details (see launch of function at the end of script for making changes):
# plot.perGen(res.2.plot=result.file,plot.name=plot.na,conf2="conf.txt",def2plot=T,list2plot.user=NULL,
#            stat2rem=c("Generation","St","Nt","Nremt","Nsext","Nclot"),max.y=1,min.y=-1,plot.legend=T,leg.mar=9,plot.dev="png")

             # result.file is "res1_per_gen_1.txt" by default
             # plot.na is "plot.perGen" by default (see end of script), no extension is needed here
             # conf2="conf.txt" # text configuration file used for the simulation run
             # plot.legend=T    # default, can be changed to "=F" not to plot the legend
             # def2plot=T       # all statistics but the ones in stat2rem are plotted, if =F, list2plot.user is used
             # leg.mar=9        # size width for the legend rectangle on the right of the plot, can be increased for particular plots
             # list2plot.user=NULL # vector which can be filled with a subset of the res1_per_gen_1.txt file header for plotting, needs def2plot=F
             # def2plot=F with list2plot.user assigned to a vec of statistics from "res1_per_gen_1.txt is the alternative to the default with def2plot=T and
             # stat2rem  
             # in :
             # stat2rem=c("Generation","St","Nt","Nremt","Nsext","Nclot") # default statistics are removed due to their larger scale values,
             #  e.g.1 to remove Fit & Fism statistics from "res1_per_gen_1.txt" and only keep Ht lines (in a scenario with many loci, e.g. 50) 
             # just add c(paste("Fit_l",1:50,sep=""),paste("Fism_l",1:50,sep="")) to the stat2rem vector
             # e.g.2 the list.sta.max.loc and list.sta.max.m objects could be added as arguments in the function for more flexibility
             # max.y<-1 ; min.y<--1 # maximum coordinates values on the X & Y axes, can be changed
             # plot.dev="png"  # indicates the plot device: *.png format used in the GUI by the Qt language, a pdf file is also produced
                               # any type of plots available in R can be added, but then check the pdf() line and change accordingly
                               # in both plot.perGen() and plot.quanti2() FUN

## Most recent CHANGES:
# 27/11/22: more flexibility for plot if res per pop has been renamed, added scientific notation to mutation print in legend, changes of legend syntax
# for clarity (see table 4.4.2 in the User Manual), managing "NA values" for some summary statistics in more cases
# 08/02/23
# Allow reading of scientific format in case different values are used in loaded file for range mutation. 





rm(list=ls())
options(scipen = 999)  # allows reading numbers in possible scientific format 
#########################################################################################################
## A) Fun to extract plot legend info from the conf.txt file

plot.leg.info<-function(conf1) {  # conf1="conf.txt"
## Warning: conf.txt needs to correspond to the res1_per_gen_1.txt produced by gMetapop

conf <- scan(file=conf1,what=character(0), sep="\n", quiet=TRUE)   # conf1<-"conf.txt"
extract.num.last<-function(x) as.numeric( strsplit(x,split=" ")[[1]][length(strsplit(x,split=" ")[[1]])] )
extract.char<-function(x)  strsplit(x,split=" ")[[1]][length(strsplit(x,split=" ")[[1]])]
nb.nl<-extract.num.last(conf[1])
nb.cl<-extract.num.last(conf[2])
nb.pop<-extract.num.last(conf[3])
nb.cla<-extract.num.last(conf[5])
clon.offsp.cla<-extract.num.last(conf[6])
veg.fec<-extract.num.last(conf[11])   
off.d<-extract.char(conf[12])
if (off.d=="d") {off.d<-"det"
                } else if (off.d=="p") {off.d<-"Poi"
                } else off.d<-c(paste("Norm ",extract.num.last(conf[12]),sep=""))
                                
mating.sys<-extract.char(conf[7])
if (mating.sys=="s"){
fem.fec.mean<-round(mean( as.numeric(strsplit( strsplit(conf[9],split=":")[[1]][2] , split=" ")[[1]])[-1] ),1) 
fem.fec.range<-range( as.numeric(strsplit( strsplit(conf[9],split=":")[[1]][2] , split=" ")[[1]])[-1] )
if (fem.fec.range[1]==fem.fec.range[2]) ffr<-round(fem.fec.range[1],1) else ffr<-paste(round(fem.fec.range[1],1),"-",round(fem.fec.range[2],1),sep="")
ffec.var<-round(var( as.numeric(strsplit( strsplit(conf[9],split=":")[[1]][2] , split=" ")[[1]])[-1] ), 3)
} else if (mating.sys=="v") {fem.fec.mean<-0; ffr<-0; ffec.var<-0} # correct current conf.txt values at 1.1 for the legend in case of clonal reproduction only (although not read by the CORE)

#Kcc<-extract.num.last(conf[4]) #OK only if same values
Kcc.range<-range( as.numeric(strsplit( strsplit(conf[4],split=":")[[1]][2] , split=" ")[[1]])[-1] )
if (Kcc.range[1]==Kcc.range[2]) kccr<-Kcc.range[1] else kccr<-paste(Kcc.range[1],"-",Kcc.range[2],sep="")
Kcc.mean<-mean( as.numeric(strsplit( strsplit(conf[4],split=":")[[1]][2] , split=" ")[[1]])[-1] )
self.rate<-extract.num.last(conf[8])+ 1/Kcc.mean # to account for natural selfing in non-Auto IC organisms

## Extracting information on soft or hard selection
if (extract.char(grep('Selection Hard or Soft', conf, value=TRUE))=="s") shsel<-"Soft"   
if (extract.char(grep('Selection Hard or Soft', conf, value=TRUE))=="h") shsel<-"Hard"   

## Extracting class informations
cla.eqsi.range<-range( as.numeric(strsplit( strsplit(conf[15],split=":")[[1]][2] , split=" ")[[1]])[-1] )
if (cla.eqsi.range[1]==cla.eqsi.range[2]) cer<-cla.eqsi.range[1] else cer<-paste(cla.eqsi.range[1],"-",cla.eqsi.range[2],sep="")
cla.tra.val<-as.numeric(strsplit( strsplit(conf[13],split=":")[[1]][2] , split=" ")[[1]])[-1] 
 if (length(cla.tra.val)==0) ctvr<-NA else {
    ctvrange<-range(cla.tra.val)
    if (ctvrange[1]==ctvrange[2]) ctvr<-ctvrange[1] else ctvr<-paste(ctvrange[1],"-",ctvrange[2],sep="")
 }
 
## extract allele nb for all types of loci (cod1 & possible cod 2 taken together for now)
alnucline<-grep('Number of alleles for each nuc', conf, value=TRUE)                                    
al.val<-as.numeric(strsplit( strsplit(alnucline,split=":")[[1]][2] , split=" ")[[1]])[c(-1,-2)]

  if (extract.char(grep('Kind of sel', conf, value=TRUE))=="n") { # case of no selection --> only neutral nucl loci possible 
    if (length(al.val)==0 | !F %in% is.na(al.val)) nar<-NA else {  # no FALSE ie !F means no allele value for is.na(al.val) so nar=NA
     neu.al.nb.range<-range( al.val[which(is.na(al.val)==F)] )
     if (neu.al.nb.range[1]==neu.al.nb.range[2]) nar<-neu.al.nb.range[1] else nar<-paste(neu.al.nb.range[1],"-",neu.al.nb.range[2],sep="")
    } 
     nb.sel<-0
     sar<-NA
  } else { # if selection on genotypes or phenotypes 
     seline<-grep('Selected nuclear', conf, value=TRUE)
     selloc<-as.numeric(strsplit( strsplit(seline,split=":")[[1]][2] , split=" ")[[1]])
     selloc.nona<-selloc[which(is.na(selloc)==F)]
     nb.sel<-sum( selloc.nona )

   all.sel.al.df<-as.data.frame(cbind( selloc.nona ,al.val[which(is.na(al.val)==F)] ))
   sel.al<- all.sel.al.df[which(all.sel.al.df$selloc.nona==1),"V2"]
   neu.al<- all.sel.al.df[which(all.sel.al.df$selloc.nona==0),"V2"]
   sel.al.nb.range<-range(sel.al)
    if (length(neu.al)!=0) { # if both selected loci/qtl and neutral (cod)loci types 
        neu.al.nb.range<-range(neu.al)
    if (neu.al.nb.range[1]==neu.al.nb.range[2]) nar<-neu.al.nb.range[1] else nar<-paste(neu.al.nb.range[1],"-",neu.al.nb.range[2],sep="")
    if (sel.al.nb.range[1]==sel.al.nb.range[2]) sar<-sel.al.nb.range[1] else sar<-paste(sel.al.nb.range[1],"-",sel.al.nb.range[2],sep="")     
    } else { # only selected loci OR qtl so neu.al==numeric(0)
    if (sel.al.nb.range[1]==sel.al.nb.range[2]) sar<-sel.al.nb.range[1] else sar<-paste(sel.al.nb.range[1],"-",sel.al.nb.range[2],sep="")
    nar<-NA
    }
  }

## extract nb of alleles for cyto loci
      if (nb.cl!=0) {
       cy.alline<-grep('Number of alleles for each cyto', conf, value=TRUE)  
       cy.al.values<-as.numeric(strsplit( strsplit(cy.alline,split=":")[[1]][2] , split=" ")[[1]])
       cy.al.range<-range( cy.al.values[which(is.na(cy.al.values)==F)] ) 
       if (cy.al.range[1]==cy.al.range[2]) cyar<-cy.al.range[1] else cyar<-paste(cy.al.range[1],"-",cy.al.range[2],sep="")
      } else cyar<-NULL

## Extract migration rate info
  if (nb.pop>1) {
     pop.pol<-geno.mat1<-conf[(pmatch('Pollen flow matrix',conf)+1):(pmatch('Seed flow matrix',conf)-1)] #pmatch for single match of line in conf.txt  
     pop.pol2<-apply(as.matrix(pop.pol),1,function(x) as.numeric(strsplit(x,split="\t")[[1]]))  
     mp.range<-formatC(range(pop.pol2-diag( NA ,nrow=nb.pop,ncol=nb.pop ),na.rm=T) , format="e", digits=2)
     if (mp.range[1]==mp.range[2]) mpr<-mp.range[1] else mpr<-paste(mp.range[1]," ",mp.range[2],sep="")

     pop.zyg<-conf[(pmatch('Seed flow matrix',conf)+1):(pmatch('Mutation rate of each nuc',conf)-1)] 

stop_quietly_zygm <- function() {
  opt <- options(show.error.messages = FALSE)
  on.exit(options(opt))
  cat("ERR: Separator(s) of zygote migration rate values is not among {Tab, whitespace} thus fun ended, please check conf.txt format.","\n")
  stop()
}
  if (length(grep("\t",pop.zyg[1]))!=0) {
      pop.zyg2<-apply(as.matrix(pop.zyg),1,function(x) as.numeric(strsplit(x,split="\t")[[1]]))
  } else if (length(grep(" ",pop.zyg[1]))!=0) {
    pop.zyg2<-apply(as.matrix(pop.zyg,col=length(pop.zyg)/2),1,function(x) as.numeric(strsplit(x,split=" ")[[1]]))                                     
  } else stop_quietly_zygm()

     mz.range<-formatC(range(pop.zyg2-diag( NA ,nrow=nb.pop,ncol=nb.pop ),na.rm=T) , format="e", digits=2)
     if (mz.range[1]==mz.range[2]) mzr<-mz.range[1] else mzr<-paste(mz.range[1]," ",mz.range[2],sep="")
  } else {mzr<-NULL; mpr<-NULL} 

## Extract pheno selection strength parameters or fitness genotype values
  if (extract.char(grep('Kind of sel', conf, value=TRUE))=="t") { # selection on phenotypes
                          conf[(pmatch('Pollen flow matrix',conf)+1):(pmatch('Seed flow matrix',conf)-1)] 
      w2.range<-range(as.numeric(strsplit( strsplit(conf[pmatch('Selection intensity',conf)],split=":")[[1]][2] , split=" ")[[1]])[-1] ) 
      if (w2.range[1]==w2.range[2]) w2r<-w2.range[1] else w2r<-paste(w2.range[1],"-",w2.range[2],sep="")
      if (nb.pop>1) { 
      zopt<-as.numeric(strsplit( strsplit(conf[pmatch('Optimal pheno',conf)],split=":")[[1]][2] , split=" ")[[1]])[-1]
      Vzopt<-round((1/nb.pop)*sum( (zopt-mean(zopt))**2 ) ,3)    
      } else Vzopt<-NA 
  } else {w2r<-NA;Vzopt<-NA}
   
 if (extract.char(grep('Kind of sel', conf, value=TRUE))=="g") {
     geno.mat1<-conf[(pmatch('Fitness coefficients',conf)+1):(pmatch('Recombination rates',conf)-1)]      
     geno.mat2<-apply(as.matrix(geno.mat1),1,function(x) as.numeric(strsplit( tail(unlist(strsplit(x,split=" ")),1),split="\t")[[1]]))
     w.range<-range(geno.mat2,na.rm=T)
     if (w.range[1]==w.range[2]) wr<-w.range[1] else wr<-paste(w.range[1],"-",w.range[2],sep="")
     } else wr<-NA 

## extract mutation rates range 
     mutline<-grep('Mutation rate of each nuc', conf, value=TRUE)  
     mut.values<-as.numeric(strsplit( strsplit(mutline,split=":")[[1]][2] , split=" ")[[1]])
     cymutline<-grep('Mutation rate of each cyto', conf, value=TRUE)  
     cymut.values<-as.numeric(strsplit( strsplit(cymutline,split=":")[[1]][2] , split=" ")[[1]])

    if (length(mut.values)==0 | !F %in% is.na(mut.values)) mur<-NA else {
       mut.range<-range(mut.values[which(is.na(mut.values)==F)]) # covers case of only cyto loci 
       if (mut.range[1]==mut.range[2]) mur<-formatC(mut.range[1], format="e", digits=2) else {
           mur<-paste(formatC(mut.range[1], format="e", digits=2)," ",formatC(mut.range[2],format="e", digits=2),sep="")
       }
       }
    if (length(cymut.values)==0 | !F %in% is.na(cymut.values)) cymur<-NA else {
       cymut.range<-range(cymut.values[which(is.na(cymut.values)==F)]) # covers case of only nuclear loci
       if (cymut.range[1]==cymut.range[2]) cymur<-formatC(cymut.range[1], format="e", digits=2) else { 
           cymur<-paste(formatC(cymut.range[1], format="e", digits=2)," ",formatC(cymut.range[2],format="e", digits=2),sep="")
       }         
       }

## extract recombination rates range and paternal inheritance value
    recline<-grep('Recombination', conf, value=TRUE)  
    rec.values<-as.numeric(strsplit( strsplit(recline,split=":")[[1]][2] , split=" ")[[1]])
    if (length(rec.values)==0 | !F %in% is.na(rec.values)) recr<-NA else {
      rec.range<-range(rec.values[which(is.na(rec.values)==F)]) # covers case only cyto loci
    if (rec.range[1]==rec.range[2]) recr<-formatC(rec.range[1], format="e", digits=2) else {
        recr<-paste(formatC(rec.range[1], format="e", digits=2)," ",formatC(rec.range[2],format="e", digits=2),sep="")
    }
    }

    pat.inherit.line<-grep('Paternal', conf, value=TRUE)   
    inherit.values<-as.numeric(strsplit( strsplit(pat.inherit.line,split=":")[[1]][2] , split=" ")[[1]])
    if (length(inherit.values)==0 | !F %in% is.na(inherit.values)) cypir<-NA else {
      cypi.range<-range(inherit.values[which(is.na(inherit.values)==F)]) 
    if (cypi.range[1]==cypi.range[2]) cypir<-cypi.range[1] else cypir<-paste(cypi.range[1],"-",cypi.range[2],sep="")
    }

## correcting for conf.txt values not used in the CORE: Rec at 0.5 for only 1 locus
## and ffr, ffec.var, fem.fec.mean in the case of clonal reproduction only --> put at 0 at FUN top in case mating.system is "v"
if (nb.nl==1) recr<-NA

pl<-list(nb.nl,nb.cl,nb.pop,nb.cla,clon.offsp.cla,cer,ctvr,veg.fec,off.d,self.rate,fem.fec.mean,ffr,ffec.var,kccr,Kcc.mean,shsel,w2r,Vzopt,wr,mzr,mpr,
         nb.sel,nar,sar,mur,cymur,cyar,cypir,recr)
names(pl)<-c("nb.nl","nb.cl","nb.pop","nb.cla","clon.offsp.cla","cer","ctvr","veg.fec","off.d","self.rate","fem.fec.mean","ffr","ffec.var",
             "kccr","Kcc.mean","shsel","w2r","Vzopt","wr","mzr","mpr","nb.sel","nar","sar","mur","cymur","cyar","cypir","recr")
return(pl)
} # end Fun plot.leg.info(conf.txt)

#########################################################################
## B) function plot.pG.info to extract info from res per Gen for plot across generations

plot.pG.info<-function(res.2.plot.pGi) {  #res.2.plot.pGi<-"res1_per_gen_1.txt"

perGen <- read.table(res.2.plot.pGi, header = T, dec= ".", sep =";")

 mG<-max(perGen[,"Generation"])    
 if ("Nt" %in% names(perGen)) { Ntm<-round(mean(perGen[,"Nt"]),1)
    Nt.last.gen<-perGen[which(perGen$Generation==mG),"Nt"]
 } else { Ntm<-NULL ; Nt.last.gen<-NULL }
 if ("St" %in% names(perGen)) { Stm<-round(mean(perGen[,"St"]),1)
    St.last.gen<-perGen[which(perGen$Generation==mG),"St"]
 } else { Stm<-NULL ; St.last.gen<-NULL }                                       

 if ("Nremt" %in% names(perGen)) {
    if (perGen[1,"Generation"]==0 & mG == 0) Nremtm<-round(perGen[1,"Nremt"],1)    # if printing only gen 0
    if (perGen[1,"Generation"]==0 & mG > 0) Nremtm<-round(mean(perGen[-1,"Nremt"]),1)  # exclude first "0" at gen 0 for averaging offspring values across re
    if (perGen[1,"Generation"]>0) Nremtm<-round(mean(perGen[,"Nremt"]),1)
 } else Nremtm<-NULL  
 
 if ("Nsext" %in% names(perGen)) {
    if (perGen[1,"Generation"]==0 & mG == 0) Nsextm<-round(perGen[1,"Nsext"],1) 
    if (perGen[1,"Generation"]==0 & mG > 0) Nsextm<-round(mean(perGen[-1,"Nsext"]),1)  
    if (perGen[1,"Generation"]>0) Nsextm<-round(mean(perGen[,"Nsext"]),1)
 } else Nsextm<-NULL
 
 
 if ("Nclot" %in% names(perGen)) {
    if (perGen[1,"Generation"]==0 & mG == 0) Nclotm<-round(perGen[1,"Nclot"],1) 
    if (perGen[1,"Generation"]==0 & mG > 0) Nclotm<-round(mean(perGen[-1,"Nclot"]),1) 
    if (perGen[1,"Generation"]>0) Nclotm<-round(mean(perGen[,"Nclot"]),1)
 } else Nclotm<-NULL

pGi<-list(mG,Ntm,Stm,Nt.last.gen,St.last.gen,Nremtm,Nsextm,Nclotm)
names(pGi)<-c("mG","Ntm","Stm","Nt.last.gen","St.last.gen","Nremtm","Nsextm","Nclotm")
return(pGi)
} #end Fun plot.pG.info

##############################################################################################"
### C) FUN for plotting statistics extracted from res1_per_gen_1.txt output file from gMetapop

plot.perGen<-function(res.2.plot,plot.name,conf2,def2plot=T,list2plot.user=NULL,stat2rem=c("Generation","St","Nt","Nremt","Nsext","Nclot"),
max.y=1,min.y=-1, plot.legend=T,leg.mar=9,plot.dev=c("png","pdf")  ) {

  # conf2="conf.txt"; res.2.plot<-"res1_per_gen_1.txt"; plot.legend=T;def2plot=T ; plot.dev="png"; leg.mar=9
  # list2plot.user=NULL; stat2rem=c("Generation","St","Nt","Nremt","Nsext","Nclot") ; max.y<-1 ; min.y<--1; plot.name<-"plot.perGen"

############################################################################################################
## A) Prepare file for plot

# apply Fun extracting info from conf & perGen for plot legend 
pli<-plot.leg.info(conf1=conf2) #"conf.txt"
pGi<-plot.pG.info(res.2.plot.pGi=res.2.plot)

perGen <- read.table(res.2.plot, header = T, dec= ".", sep =";") 
init.stat<-names(perGen)

# Computing mean for h2.pan h2.c and fitness if statistics are requested in per_pop output file
  warn.pop.nb<-NULL
  if (length( grep("^res1_per_pop_1.txt$", list.files(, all.files=F,full.names=F, recursive=F) ) )!=0) { # search only for exact string res1_per_pop_1.txt
     perPop <- read.table("res1_per_pop_1.txt", header = T, dec= ".", sep =";") # reading it   head( perPop)
     lgen<- levels(as.factor(perPop$Generation))

     pr.stats.pop<-c("h2.pan","h2.gc","mean_fitness","Ho","He","Fis","Ho_cod1","Ho_cod2","He_cod1","He_cod2","Ho_sel","He_sel","He_qtl","Ho_qtl")
     sst.lq1<-c("mh2.p","mh2.gc","mW","Hom","Hem","Fism","Hom_cod1","Hom_cod2","Hem_cod1","Hem_cod2","Hom_sel","Hem_sel","Hem_qtl","Hom_qtl")
                   # initialisation mean h2 & W stats to compute across pop
                   # also "Hom", "Hem", "Fism" etc... for averages across pop AND loci

     warn.count.00<-0
     for (sst in pr.stats.pop) { 
        sstlq<-sst.lq1[which(pr.stats.pop==sst)]
        if (sst %in% names(perPop)) {
          ss.df<-perPop[,c("Generation",sst)]
          ss.mat<-matrix(NA,ncol=2,nrow=length(lgen) )
          for (gen in lgen )  { # gen=1
            i<- which(lgen==gen) ; ss.mat[i,1]<- round(as.numeric(gen),0)
            ss.mat[i,2]<-mean(ss.df[which(ss.df$Generation==as.numeric(gen)),][,sst],na.rm=T)
            if (warn.count.00==0 & gen==0) {
                if (is.na(mean(ss.df[which(ss.df$Generation==as.numeric(gen)),][,sst]))==T)  { # since na.rm=T not used, if one NA in 1 pop, mean is NA
                    warn.pop.nb<-paste("WARNING: some statistics are NA at RE 0 in res1_per_pop_1.txt")
                    warn.count.00<-warn.count.00+1
                }
            }
            if (warn.count.00==0 & gen>0) {
                if (is.na(mean(ss.df[which(ss.df$Generation==as.numeric(gen)),][,sst]))==T)  {
                    warn.pop.nb<-paste("WARNING: some statistics are NA in 1 or more populations since RE",gen)
                    warn.count.00<-warn.count.00+1
                }
            }
          } # end loop compute mean across gen
            colnames(ss.mat)<-c("Generation",sstlq)
            perGen<-merge(perGen,ss.mat,by.x="Generation",by.y="Generation",all.x=T,all.y=T,sort=T)
            init.stat<-c(init.stat,sstlq)
        }   
     }
  } # end loop presence of res_per_pop file
  
# define all stats to plot using the max of default stat within a consistent scale  
  if (def2plot==T) {   
    stat2rem2<-c("mVg","mVG","mVP","mthetaW.p.g","mthetaW.p.t","mthetaW.gc.g","mthetaW.gc.t","VA.p.tot","VA.gc.tot") # in plot.perGen.quanti plot
    stat2rem<-levels(factor(c(stat2rem2,stat2rem)))
    stat2plot<-init.stat[! init.stat %in% stat2rem]
  } else stat2plot<-list2plot.user      # list2plot.user <-c("mW","Hom")
 
# function to get boundaries of plot

  minmax<-function(x) { c(minss = min(na.omit(x)), maxss = max(na.omit(x))) }

# Filter stat2plot in cases one or all stats are only NA (if threshold due to nb of ind in Output Tab)
# this should occur only for all loci at once or for none of them
  check.na.f<-function(x) { nona = length(which(is.na(x)==F)) }
  datoc<-sapply(perGen[,stat2plot,drop=F],check.na.f)  # occurence of data   names(datoc)
  stat2drop<-which(datoc==0)  #stat2drop<-as.vector(which(datoc==0))  
   
   if (length( stat2drop)!=0) stat2plot2<-stat2plot[!stat2plot %in% names(stat2drop)] else stat2plot2<-stat2plot               

############################################################################################################
## B) opening plot device
if (plot.dev=="png") png(filename=paste(plot.name,".png",sep=""),unit = "cm", width = 20, height = 20 , res = 200)
if (plot.dev=="pdf") pdf(file=paste(plot.name,".pdf",sep=""), width = 9, height = 9 )

  ### Start PLOT function
  if (perGen[1,"Generation"]==0 & max(perGen[,"Generation"])==0) { # if asking results only for generation 0    
  par(mar= c(5,4,4,8))
  plot(perGen$Gen,rep(0,length(perGen$Gen)), ylab="res1_per_gen_1.txt statistics", xlab="Reproductive events", ylim=c(-1,1), type="l",
  sub=("WARNING: result file(s) likely contain initial values at generation 0 only") )
  } else if (dim(perGen[,stat2plot2,drop=F])[2]==0) {  # condition for not stats to plot --> all NA values included here
  par(mar= c(5,4,4,8))
  plot(perGen$Gen,rep(0,length(perGen$Gen)), ylab="res1_per_gen_1.txt statistics", xlab="Reproductive events", ylim=c(-1,1), type="l",
  sub=("WARNING: result file(s) likely contain demography statistics or NA values only") )
  } else {
  bound.df<-sapply(perGen[,stat2plot2,drop=F],minmax)  #in fact if only NA, inf returned so case needed to be treated before
  ylim.maxbound<-max(bound.df["maxss",], na.rm= TRUE)
  ylim.minbound<-min(bound.df["minss",], na.rm= TRUE)
  if (ylim.maxbound > max.y) ylim.maxbound<-max.y
  if (ylim.minbound < min.y) ylim.minbound<-min.y

  if (is.na(ylim.maxbound) == TRUE | is.na(ylim.minbound) == TRUE ){ # only NA data in res file  --> NO, in ylim. etc file, but case should never occur
  par(mar= c(5,4,4,8))
  plot(perGen$Gen,rep(0,length(perGen$Gen)), ylab="res1_per_gen_1.txt statistics", xlab="Reproductive events", ylim=c(-1,1), type="l",
   sub=("WARNING: result file(s) likely contain NA or missing data only ") )
  } else if (ylim.maxbound-ylim.minbound== 0) {
  par(mar= c(5,4,4,8))
  plot(perGen$Gen,rep(0,length(perGen$Gen)), ylab="res1_per_gen_1.txt statistics", xlab="Reproductive events", ylim=c(-1,1), type="l",
    sub=("WARNING: result file(s) likely contain invariant statistics only") )
  } else if (is.na(ylim.maxbound) == FALSE & is.na(ylim.minbound) == FALSE ){
  par(mar= c(5,4,4,leg.mar))
  plot(perGen$Gen,rep(0,length(perGen$Gen)), ylab="", xlab="Reproductive events",
  ylim=c(ylim.minbound,ylim.maxbound), type="l")
  if (length(warn.pop.nb)!=0) mtext(side=1, line=2,at=-0.5, adj=0, cex=0.8, warn.pop.nb)
  }
  }
  ## Scanning possible stats across nuclear loci in res file & Extracting those to be plotted
    list.sta.max.loc<-c("Fit","Fism","Hem","Ht","Gst","Gstcor")
  # colour nuclear loci
    all.col<-c("grey","darkgrey","maroon","violet","turquoise","green")
    all.lty<-c("dotdash","solid","solid","solid","solid","solid")
    true.legend<-NULL
    true.col<-NULL
    true.lty<-NULL
  # colour cyto loci
    cyt.col<-c("orange","pink","darkblue","darkgreen")
    cyt.lty<-c("solid","solid","solid","solid")
    cytt.col<-NULL
    cytt.lty<-NULL

############## ERROR messages below would be printed in LOG window
   ## extract nb nuclear loci directly from stat2plot to cross check nb of nuclear loci from conf.txt
   extract.loci.res.nuc<-function(x) { # x<-stat2plot2[1]  # FUN applied on each vector element
                   if ("_" %in% unlist(strsplit(x,split=""))) {
                    y<-as.numeric(strsplit(x,split="_l")[[1]][length(strsplit(x,split="_l")[[1]])] )
                   } else y<-0
                   return(y)
                   }
    stat2plot.nuc<-grep('_l', stat2plot, value=TRUE)
    if (length(stat2plot.nuc)!=0) {
    nnuc<-max( sapply(stat2plot.nuc,extract.loci.res.nuc))
    if (nnuc!=pli$nb.nl) cat("ERR: number of nuclear loci in conf.txt file is different to that in result file","\n") 
   }
  ## extract nb cyto loci directly from stat2plot to cross check with nb of cyto loci from conf.txt
    extract.loci.res.cyto<-function(x) { 
                   if ("_" %in% unlist(strsplit(x,split=""))) {
                    y<-as.numeric(strsplit(x,split="_cl")[[1]][length(strsplit(x,split="_cl")[[1]])] )
                   } else y<-0
                   return(y)
                   }
    stat2plot.cyto<-grep('_cl', stat2plot, value=TRUE)
    if (length(stat2plot.cyto)!=0) {
    ncyto<-max( sapply(stat2plot.cyto,extract.loci.res.cyto))
    if (ncyto!=pli$nb.cl) cat("ERR: number of cytoplasmic loci in conf.txt file is different to that in result file","\n")  
    }
############## END ERROR messages printed in LOG window

    #  plotting loop across possible stats per nuclear locus
    for (ss in list.sta.max.loc) {         # ss<-"Gst"
        i<-which(list.sta.max.loc==ss)     
        ssl<-paste(ss,"_l",sep="")         
        lssl<-length( unlist(strsplit(ssl,NULL))) 
        pos.ss<-which(substr(stat2plot2,1,lssl) %in% ssl)  
        if (length(pos.ss)!=0) {           
          perGen.ss <-perGen[, stat2plot2,drop=F][,pos.ss,drop=F]   
           for (loc in 1:length( pos.ss) ) { #loc<-1
             lines(perGen$Gen,perGen.ss[,loc], col = all.col[i], type = "l", lty=all.lty[i] )
           }
         true.legend<-c(true.legend,ssl);true.col<-c(true.col,all.col[i]); true.lty<-c(true.lty,all.lty[i])
        } # end cond stat across loci in stat2plot2 is present
     }  # end loop across possible stats per locus

 ## Plotting cytoplasmic loci  #  plotting loop across possible stats per cyto locus
    for (ss in c("Hem","Ht","Gst","Gstcor") ) {  #ss<-"Hem"
        i<-which(c("Hem","Ht","Gst","Gstcor")==ss)
        ssl<-paste(ss,"_cl",sep="")
        lssl<-length( unlist(strsplit(ssl,NULL)))
        pos.ss<-which(substr(stat2plot2,1,lssl) %in% ssl)
        if (length(pos.ss)!=0) {
          perGen.ss <-perGen[, stat2plot2,drop=F][,pos.ss,drop=F]
           for (loc in 1:length( pos.ss)) { # loc<-22
             lines(perGen$Gen,perGen.ss[,loc], col = cyt.col[i], type = "l", lty=cyt.lty[i] )
           }
         true.legend<-c(true.legend,ssl);cytt.col<-c(cytt.col,cyt.col[i]); cytt.lty<-c(cytt.lty,cyt.lty[i])
        } # end cond stat across loci in stat2plot2 is present
     }

  ## idem for possible list of statistics for mean across loci
    list.sta.max.m<-c("Hom","Hem","Fism","Hom_cod1","Hom_cod2","Hem_cod1","Hem_cod2","Hom_sel","Hem_sel","Hem_qtl","Hom_qtl",
"Gstm","Gstcorm","Gstcod1","Gstcorcod1","Gstcod2","Gstcorcod2","Gstqtl","Gstcorqtl","Gstsel","Gstcorsel")
    all.col.m<-c("deeppink2","maroon","springgreen4","pink","pink","cyan","cyan","darkred","darkred","darkred","darkred",
"black","black","blue","blue","forestgreen","forestgreen","orange","orange","brown","brown") 
    # maybe use red also for sel since not at same time? until now to update alternative 2 other colour than black for second one
    all.lty.m<-c("dotted","dotted","dotted","dashed","dotdash","dashed","dotdash","solid","dotdash","solid","dotdash",
"solid","longdash","solid","longdash","solid","longdash","solid","longdash","solid","longdash") # alternative 2: solid line for second one
    true.col.m<-NULL
    true.lty.m<-NULL

   for (ssm in list.sta.max.m) { #ssm<-"Gstm"
      if ( ssm %in% stat2plot2) {
         j<-which(list.sta.max.m==ssm)
         issm<-which(stat2plot2==ssm)
         lines(perGen$Gen,perGen[,stat2plot2,drop=F][,issm], col = all.col.m[j], type="l", lwd=2, lty=all.lty.m[j] )
  true.legend<-c(true.legend,ssm);
  true.col.m<-c(true.col.m,all.col.m[j]);
  true.lty.m<-c(true.lty.m,all.lty.m[j])
      }  # end cond stat is in res per gen file
   }  # end loop across stats as means across loci

## Plotting possible list of quantitative traits statistics within a range of y coordinates
list.quanti1<-c("Qst.p","Qst.gc","mh2.p","mh2.gc","mW")
    col.quanti1<-c("red","red","springgreen4","springgreen4","red")
    lty.quanti1<-c("solid","longdash","solid","dashed","dotted")
    true.colq1<-NULL
    true.ltyq1<-NULL

   for (ssq in list.quanti1) {
      if ( ssq %in% stat2plot2) {
         j<-which(list.quanti1==ssq)
         issq<-which(stat2plot2==ssq)
        if (min(range(perGen[,stat2plot2,drop=F][,issq],na.rm=T))<=max.y) {   # na.rm=T deals with case of NA in stat range across gen
                                                                               # min instead of max allow plotting some values for h2 if they are
                                                                               # below the max.y chosen
        lines(perGen$Gen,perGen[,stat2plot2,drop=F][,issq], col = col.quanti1[j], type="l", lwd=2, lty=lty.quanti1[j] )
        true.legend<-c(true.legend,ssq); true.colq1<-c(true.colq1,col.quanti1[j]); true.ltyq1<-c(true.ltyq1,lty.quanti1[j])
        }
      }  # end cond stat is in res per gen file
   }  # end loop across quanti stats

  ## modif true.legend if more than one pop (patch to change name mW or W to "mean fitness"  (ie across ind in one pop & across pop)
  ## if more than 1 pop:
  if("mW" %in% true.legend) true.legend[which(true.legend=="mW")]<-"mean fitness"

  ## modifs true.legend if only 1 pop:
  if (pli$nb.pop==1) {
   # if("mW" %in% true.legend) true.legend[which(true.legend=="mW")]<-"W"
    if("mh2.p" %in% true.legend) true.legend[which(true.legend=="mh2.p")]<-"h2.p"
    if("mh2.gc" %in% true.legend) true.legend[which(true.legend=="mh2.gc")]<-"h2.gc"
    if("Hom" %in% true.legend) true.legend[which(true.legend=="Hom")]<-"Ho"
    if("Hem" %in% true.legend) true.legend[which(true.legend=="Hem")]<-"He"
    if("Fism" %in% true.legend) true.legend[which(true.legend=="Fism")]<-"Fis"
    if("Hom_cod1" %in% true.legend) true.legend[which(true.legend=="Hom_cod1")]<-"Ho_cod1"
    if("Hom_cod2" %in% true.legend) true.legend[which(true.legend=="Hom_cod2")]<-"Ho_cod2"
    if("Hem_cod1" %in% true.legend) true.legend[which(true.legend=="Hem_cod1")]<-"He_cod1"
    if("Hem_cod2" %in% true.legend) true.legend[which(true.legend=="Hem_cod2")]<-"He_cod2"
    if("Hom_sel" %in% true.legend) true.legend[which(true.legend=="Hom_sel")]<-"Ho_sel"
    if("Hem_sel" %in% true.legend) true.legend[which(true.legend=="Hem_sel")]<-"He_sel"
    if("Hom_qtl" %in% true.legend) true.legend[which(true.legend=="Hom_qtl")]<-"Ho_qtl"
    if("Hem_qtl" %in% true.legend) true.legend[which(true.legend=="Hem_qtl")]<-"He_qtl"
  }
############################################################################################################
## C) plot legend
  if (plot.legend==T) {
   extract.char<-function(x)  strsplit(x,split=" ")[[1]][length(strsplit(x,split=" ")[[1]])]
   conf.2 <- scan(file=conf2,what=character(0), sep="\n", quiet=TRUE)

  ## Add info to the legend list
   if (pli$nb.pop==1) {
     if (pli$nb.cla==1) {
   add.legend0<-c(paste("Npop ",pli$nb.pop," Ncla ",pli$nb.cla,sep=""),
                  paste("Offspring ",pli$off.d,sep=""),paste("Equil S rate ",round(pli$self.rate,6),sep=""))
     } else {
   add.legend0<-c(paste("Npop ",pli$nb.pop," Ncla ",pli$nb.cla,sep=""),
                  paste("Clon.offspring.cla ",pli$clon.offsp.cla),
                  paste("Cla.transition ",pli$ctvr,sep=""),
                  paste("Cla.eq.size ",pli$cer,sep=""),
                  paste("Offspring ",pli$off.d,sep=""),paste("Equil S rate ",round(pli$self.rate,6),sep=""))
     }
   } else {
     if (pli$nb.cla==1) {
   add.legend0<-c(paste("Npop ",pli$nb.pop," Ncla ",pli$nb.cla,sep=""),
                  paste("Offspring ",pli$off.d,sep=""),paste("Equil S rate ",round(pli$self.rate,6),sep=""),
                  paste("t.zy.m ",pli$mzr,sep=""), paste("t.mg.m ",pli$mpr,sep=""))
     } else {
   add.legend0<-c(paste("Npop ",pli$nb.pop," Ncla ",pli$nb.cla,sep=""),
                  paste("Clon.offspring.cla ",pli$clon.offsp.cla),
                  paste("Cla.transition ",pli$ctvr,sep=""),
                  paste("Cla.eq.size ",pli$cer,sep=""),
                  paste("Offspring ",pli$off.d,sep=""),paste("Equil S rate ",round(pli$self.rate,6),sep=""),
                  paste("t.zy.m ",pli$mzr,sep=""), paste("t.mg.m ",pli$mpr,sep=""))
     }
   }

   if (extract.char(grep('Kind of sel', conf.2, value=TRUE))=="t") { # selection on phenotypes
          if (pli$nb.cl==0) {
   add.legend<-c(paste("Ncyto ",pli$nb.cl,sep=""),paste("Ncod ",pli$nb.nl-pli$nb.sel," Nqtl ",pli$nb.sel,sep=""),
                 paste(pli$shsel," selection",sep=""),         
                 paste("w2.rg ",pli$w2r,sep=""),paste("Vzopt ",round(pli$Vzopt,4),sep=""),
                 paste("nuMut ",pli$mur,sep=""),  # both types of nuc loci
                 paste("Rec ",pli$recr,sep=""), 
                 paste("Al.rg cod/qtl ",pli$nar,"/",pli$sar,sep=""),
                 paste("K.rg ",pli$kccr,sep=""), paste("K.m ",pli$Kcc.mean,sep=""),
                 paste("ffec.m/var ",round(pli$fem.fec.mean,3),"/",round(pli$ffec.var,3),sep=""),paste("ffec.rg ",pli$ffr,sep="") )
          } else {
   add.legend<-c(paste("Ncyto ",pli$nb.cl,sep=""),paste("cyMut ",pli$cymur,sep=""),paste("cyAl.rg ",pli$cyar,sep=""),
                 paste("cy.pat.inherit ",pli$cypir,sep=""),    
                 paste("Ncod ",pli$nb.nl-pli$nb.sel," Nqtl ",pli$nb.sel,sep=""),
                 paste(pli$shsel," selection",sep=""),
                 paste("w2.rg ",pli$w2r,sep=""),paste("Vzopt ",round(pli$Vzopt,4),sep=""),
                 paste("nuMut ",pli$mur,sep=""),
                 paste("Rec ",pli$recr,sep=""), 
                 paste("Al.rg cod/qtl ",pli$nar,"/",pli$sar,sep=""),
                 paste("K.rg ",pli$kccr,sep=""), paste("K.m ",pli$Kcc.mean,sep=""),
                 paste("ffec.m/var ",round(pli$fem.fec.mean,3),"/",round(pli$ffec.var,3),sep=""),paste("ffec.rg ",pli$ffr,sep="") )
          }
   } else if (extract.char(grep('Kind of sel', conf.2, value=TRUE))=="g") { # selection on phenotypes
          if (pli$nb.cl==0) {
   add.legend<-c(paste("Ncyto ",pli$nb.cl,sep=""),
                 paste("Ncod ",pli$nb.nl-pli$nb.sel," Nsel ",pli$nb.sel,sep=""),
                 paste(pli$shsel," selection",sep=""),
                 paste("fitness.val ",pli$wr,sep=""),
                 paste("nuMut ",pli$mur, sep=""), # all nuc loci
                 paste("Rec ",pli$recr,sep=""), 
                 paste("Al.rg cod/sel ",pli$nar,"/",pli$sar,sep=""),
                 paste("K.rg ",pli$kccr,sep=""), paste("K.m ",pli$Kcc.mean,sep=""),
                 paste("ffec.m/var ",round(pli$fem.fec.mean,3),"/",round(pli$ffec.var,3),sep=""),paste("ffec.rg ",pli$ffr,sep="")  )
          } else {
   add.legend<-c(paste("Ncyto ",pli$nb.cl,sep=""),paste("cyMut ",pli$cymur,sep=""),paste("cyAl.rg ",pli$cyar,sep=""),
                 paste("cy.pat.inherit ",pli$cypir,sep=""),    
                 paste("Ncod ",pli$nb.nl-pli$nb.sel," Nsel ",pli$nb.sel,sep=""),
                 paste(pli$shsel," selection",sep=""),
                 paste("fitness.val ",pli$wr,sep=""),
                 paste("nuMut ",pli$mur, sep=""),
                 paste("Rec ",pli$recr,sep=""), 
                 paste("Al.rg cod/sel ",pli$nar,"/",pli$sar,sep=""),
                 paste("K.rg ",pli$kccr,sep=""), paste("K.m ",pli$Kcc.mean,sep=""),
                 paste("ffec.m/var ",round(pli$fem.fec.mean,3),"/",round(pli$ffec.var,3),sep=""),paste("ffec.rg ",pli$ffr,sep="")  )
          }
   } else if (extract.char(grep('Kind of sel', conf.2, value=TRUE))=="n") { # no selection
          if (pli$nb.cl==0) {
   add.legend<-c(paste("Ncyto ",pli$nb.cl,sep=""),paste("Ncod ",pli$nb.nl,sep=""),
                 paste("nuMut ",pli$mur, sep=""),
                 paste("Rec ",pli$recr,sep=""), 
                 paste("Al.rg cod ",pli$nar,sep=""), paste("K.rg ",pli$kccr,sep=""), paste("K.m ",pli$Kcc.mean,sep=""),
                 paste("ffec.m/var ",round(pli$fem.fec.mean,3),"/",round(pli$ffec.var,3),sep=""),paste("ffec.rg ",pli$ffr,sep="")  )

          } else if (pli$nb.cl!=0 &  pli$nb.nl==0) {
   add.legend<-c(paste("Ncyto ",pli$nb.cl,sep=""),paste("cyMut ",pli$cymur,sep=""),paste("cyAl.rg ",pli$cyar,sep=""),
                 paste("cy.pat.inherit ",pli$cypir,sep=""),
                 paste("Ncod ",pli$nb.nl,sep=""),paste("K.rg ",pli$kccr,sep=""), paste("K.m ",pli$Kcc.mean,sep=""),
                 paste("ffec.m/var ",round(pli$fem.fec.mean,3),"/",round(pli$ffec.var,3),sep=""),paste("ffec.rg ",pli$ffr,sep="")  )
          } else { # both !=0
   add.legend<-c(paste("Ncyto ",pli$nb.cl,sep=""),paste("cyMut ",pli$cymur,sep=""),paste("cyAl.rg ",pli$cyar,sep=""),
                 paste("cy.pat.inherit ",pli$cypir,sep=""),
                 paste("Ncod ",pli$nb.nl,sep=""),paste("nuMut ",pli$mur, sep=""), paste("Rec ",pli$recr,sep=""), 
                 paste("Al.rg cod ",pli$nar,sep=""), paste("K.rg ",pli$kccr,sep=""), paste("K.m ",pli$Kcc.mean,sep=""),
                 paste("ffec.m/var ",round(pli$fem.fec.mean,3),"/",round(pli$ffec.var,3),sep=""),paste("ffec.rg ",pli$ffr,sep="")  )
          }
   }
   add.legend1<-paste("Clonal.fec ",pli$veg.fec,sep="")
   add.lty<-rep(NA,length(add.legend0)+length(add.legend)+length(add.legend1))

   if (length(pGi$Ntm)!=0) add.leg2<-paste("Nt.m ",pGi$Ntm,sep="") else add.leg2<-NULL
   if (length(pGi$Stm)!=0) add.leg3<-paste("St.m ",pGi$Stm,sep="") else add.leg3<-NULL
   if (length(pGi$Nt.last.gen)!=0) add.leg4<-paste("Nt.",pGi$mG," ",pGi$Nt.last.gen,sep="") else add.leg4<-NULL
   if (length(pGi$St.last.gen)!=0) add.leg5<-paste("St.",pGi$mG," ",pGi$St.last.gen,sep="") else add.leg5<-NULL
   if (length(pGi$Nremtm)!=0) add.leg6<-paste("Nremt.m ",pGi$Nremtm,sep="") else add.leg6<-NULL
   if (length(pGi$Nsextm)!=0) add.leg7<-paste("Nsext.m ",pGi$Nsextm,sep="") else add.leg7<-NULL
   if (length(pGi$Nclotm)!=0) add.leg8<-paste("Nclot.m ",pGi$Nclotm,sep="") else add.leg8<-NULL

  loc <- par("usr")
  legend( loc[2], loc[4] , legend = c(true.legend,add.legend0,add.legend,add.legend1,add.leg2,add.leg3,add.leg4,add.leg5,add.leg6,add.leg7,add.leg8), col = c(true.col,cytt.col,true.col.m,true.colq1,""),
  lty = c(true.lty,cytt.lty,true.lty.m,true.ltyq1,add.lty,NA,NA,NA,NA,NA,NA,NA), lwd=2, cex = 0.7 , xpd=TRUE)  
  }

  title ("Summary statistics across reproductive events",cex.main=1)
dev.off()
} # end FUN plot.perGen
############################################################################################################

## separate plot if list.quanti with values above 1 (theta coefficients can be on both plots, here only for this plot)

plot.quanti2<-function(res.2.plot.q,conf3,def2plot=T,list2plot.user=NULL,stat2rem=c("Generation","St","Nt","Nremt","Nsext","Nclot"),
plot.legend=T,leg.mar=9) {
             # res.2.plot.q<-"res1_per_gen_1.txt"; plot.legend=T;def2plot=T ; plot.dev="png"
             # list2plot.user=NULL;stat2rem=c("Generation","St","Nt","Nremt","Nsext","Nclot")
             # conf3<-"conf.txt"
pli<-plot.leg.info(conf1=conf3)
pGi<-plot.pG.info(res.2.plot.pGi=res.2.plot.q)

perGen <- read.table(res.2.plot.q, header = T, dec= ".", sep =";") # reading per Gen result file
init.stat<-names(perGen)

 # potentiel quanti 2 trait stats list
 list.quanti2<-c("mthetaW.p.g","mthetaW.p.t","mthetaW.gc.g","mthetaW.gc.t","mVg","mVG","mVP","VA.p.tot","VA.gc.tot","mh2.p","mh2.gc")
 # need full list here to match later line type and col

# if (length(list.files(, all.files=F,full.names=F, recursive=F, pattern="res1_per_pop_1.txt") )!=0) { # Pb if older res1_per_pop_1.txt with added prefix or suffix & exact name not in folder --> cond is T & exact filename not found
  if (length( grep("^res1_per_pop_1.txt$", list.files(, all.files=F,full.names=F, recursive=F) ) )!=0) { # search only for exact string res1_per_pop_1.txt

     perPop.1 <- read.table("res1_per_pop_1.txt", header = T, dec= ".", sep =";",nrows=1)
     pr.stats.pop<-c("VP","h2.pan","h2.gc")
     pspinpp<-pmatch(pr.stats.pop,names(perPop.1)); pspinpp<-pspinpp[!is.na(pspinpp)]
     if (length(pspinpp)!=0) {# if any quanti stat wanted in perPop
      perPop <- read.table("res1_per_pop_1.txt", header = T, dec= ".", sep =";")
      lgen<- levels(as.factor(perPop$Generation))
      sst.lq2<-c("mVP","mh2.p","mh2.gc")
      for (sst in pr.stats.pop) { #  sst<-"mean_fitness"
        if (sst %in% names(perPop)) {
          sstlq<-sst.lq2[which(pr.stats.pop==sst)]
          ss.df<-perPop[,c("Generation",sst)]
          ss.mat<-matrix(NA,ncol=2,nrow=length(lgen) )
          for (gen in lgen )  {
            i<- which(lgen==gen) ; ss.mat[i,1]<- round(as.numeric(gen),0)
            ss.mat[i,2]<-mean(ss.df[which(ss.df$Generation==as.numeric(gen)),][,sst])
          }
         colnames(ss.mat)<-c("Generation",sstlq)
         perGen<-merge(perGen,ss.mat,by.x="Generation",by.y="Generation",all.x=T,all.y=T,sort=T)
         init.stat<-c(init.stat,sstlq)
        }
      }
    }
} # end loop presence of res1_per_pop_1.txt in working folder
  # choose list of statistics to plot
   if (def2plot==T) { 
     stat2plot<-init.stat[! init.stat %in% stat2rem]
   } else stat2plot<-list2plot.user 
 
## Filter stat2plot in cases one or all stats are only NA (if threshold due to nb of ind in Output Tab)
# should occur only for all loci at once or for none of them
  check.na.f<-function(x) { nona = length(which(is.na(x)==F)) }
  datoc<-sapply(perGen[,stat2plot,drop=F],check.na.f)  # occurence of data   names(datoc)

 stat2drop<-which(datoc==0)  
   if (length( stat2drop)!=0) stat2plot2<-stat2plot[!stat2plot %in% names(stat2drop)] else stat2plot2<-stat2plot               

 listq2<-pmatch(list.quanti2,stat2plot2); listq2<-listq2[!is.na(listq2)] # to get position of quanti stat2plot in perGen

# get boundaries of plot from all stats
 minmax<-function(x) { c(minss = min(na.omit(x)), maxss = max(na.omit(x))) }
 if ( length(listq2)!=0 ) { # cond plot added quanti stats
 pdf(file="plot.perGen.quanti.pdf", width = 7, height = 6 )
 bound.df<-sapply(perGen[,stat2plot2,drop=F][,listq2,drop=F],minmax)
 ylim.maxbound<-max(bound.df["maxss",], na.rm= TRUE)
 ylim.minbound<-min(bound.df["minss",], na.rm= TRUE)

  if (is.na(ylim.maxbound) == TRUE | is.na(ylim.minbound) == TRUE ){ # only NA data in res file
  par(mar= c(5,4,4,8))
  plot(perGen$Gen,rep(0,length(perGen$Gen)), ylab="res1_per_gen_1.txt statistics", xlab="Reproductive events", ylim=c(-1,1), type="l",
   sub=("WARNING: result file(s) likely contain NA or missing data only ") )
  } else if (ylim.maxbound-ylim.minbound== 0) {
  par(mar= c(5,4,4,8))
  plot(perGen$Gen,rep(0,length(perGen$Gen)), ylab="res1_per_gen_1.txt statistics", xlab="Reproductive events", ylim=c(-1,1), type="l",
    sub=("WARNING: result file(s) likely contain invariant statistics only") )
  } else if (is.na(ylim.maxbound) == FALSE & is.na(ylim.minbound) == FALSE ){
  par(mar= c(5,4,4,leg.mar))
  plot(perGen$Gen,rep(0,length(perGen$Gen)), ylab="", xlab="Reproductive events",ylim=c(ylim.minbound,ylim.maxbound), type="l")
  }
#c("mthetaW.p.g","mthetaW.p.t","mthetaW.gc.g","mthetaW.gc.t","mVg","mVG","mVP","VA.p.tot","VA.gc.tot","mh2.p","mh2.gc")
 col.quanti2<-c("firebrick","firebrick","darkseagreen","darkseagreen","purple","violetred2","purple4","blue","blue","springgreen4","springgreen4")
#colors()
 lty.quanti2<-c("solid","dashed","solid","dashed","solid","solid","solid","solid","longdash","solid","dashed") # "dotted" "dotdash" "dashed"
 true.legend<-NULL
 true.colq2<-NULL
 true.ltyq2<-NULL

   for (ssq in list.quanti2) {  #ssq<-"mh2.gc"
         if ( ssq %in% stat2plot2) {
         j<-which(list.quanti2==ssq)
         issq<-which(stat2plot2==ssq)
         lines(perGen$Gen,perGen[,stat2plot2,drop=F][,issq], col = col.quanti2[j], type="l", lwd=2, lty=lty.quanti2[j] )
         true.legend<-c(true.legend,ssq); true.colq2<-c(true.colq2,col.quanti2[j]); true.ltyq2<-c(true.ltyq2,lty.quanti2[j])
    }
   }  # end loop across quanti2 stats
  ## modif true.legend if only one pop
  if (pli$nb.pop==1) {                                
    if("mthetaW.p.g" %in% true.legend) true.legend[which(true.legend=="mthetaW.p.g")]<-"thetaW.p.g"
    if("mthetaW.p.t" %in% true.legend) true.legend[which(true.legend=="mthetaW.p.t")]<-"thetaW.p.t"
    if("mthetaW.gc.g" %in% true.legend) true.legend[which(true.legend=="mthetaW.gc.g")]<-"thetaW.gc.g"
    if("mthetaW.gc.t" %in% true.legend) true.legend[which(true.legend=="mthetaW.gc.t")]<-"thetaW.gc.t"
    if("mVG" %in% true.legend) true.legend[which(true.legend=="mVG")]<-"VG"
    if("mVg" %in% true.legend) true.legend[which(true.legend=="mVg")]<-"Vg"
    if("mVP" %in% true.legend) true.legend[which(true.legend=="mVP")]<-"VP"
    if("mh2.p" %in% true.legend) true.legend[which(true.legend=="mh2.p")]<-"h2.p"
    if("mh2.gc" %in% true.legend) true.legend[which(true.legend=="mh2.gc")]<-"h2.gc"
  }

  if (plot.legend==T) {
  ## Add info to the legend list
   extract.char<-function(x)  strsplit(x,split=" ")[[1]][length(strsplit(x,split=" ")[[1]])]
   conf.3 <- scan(file=conf3,what=character(0), sep="\n", quiet=TRUE)

  if (pli$nb.pop==1) {
    if (pli$nb.cla==1) {
   add.legend0<-c(paste("Npop ",pli$nb.pop," Ncla ",pli$nb.cla,sep=""),paste("Ncyto ",pli$nb.cl,sep=""),
                  paste("Offspring ",pli$off.d,sep=""),paste("Equil S rate ",round(pli$self.rate,6),sep=""))
    } else {
   add.legend0<-c(paste("Npop ",pli$nb.pop," Ncla ",pli$nb.cla,sep=""),
                  paste("Clon.offspring.cla ",pli$clon.offsp.cla),
                  paste("Offspring ",pli$off.d,sep=""),paste("Equil S rate ",round(pli$self.rate,6),sep=""))

    }              
   } else {
    if (pli$nb.cla==1) {
   add.legend0<-c(paste("Npop ",pli$nb.pop," Ncla ",pli$nb.cla,sep=""),paste("Ncyto ",pli$nb.cl,sep=""),
                  paste("Offspring ",pli$off.d,sep=""),paste("Equil S rate ",round(pli$self.rate,6),sep=""),
                  paste("t.zy.m ",pli$mzr,sep=""), paste("t.mg.m ",pli$mpr,sep=""))
    } else {
   add.legend0<-c(paste("Npop ",pli$nb.pop," Ncla ",pli$nb.cla,sep=""),
                  paste("Clon.offspring.cla ",pli$clon.offsp.cla),
                  paste("Offspring ",pli$off.d,sep=""),paste("Equil S rate ",round(pli$self.rate,6),sep=""),
                  paste("t.zy.m ",pli$mzr,sep=""), paste("t.mg.m ",pli$mpr,sep=""))
    }               
   }

   if (extract.char(grep('Kind of sel', conf.3, value=TRUE))=="t") { # selection on phenotypes, only cond for printing any quanti2 stats      
          if (pli$nb.cl==0) {
   add.legend<-c(paste("Ncod ",pli$nb.nl-pli$nb.sel," Nqtl ",pli$nb.sel,sep=""),
                 paste(pli$shsel," selection",sep=""),
                 paste("w2.rg ",pli$w2r,sep=""),paste("Vzopt ",round(pli$Vzopt,4),sep=""),
                 paste("nuMut ",pli$mur, sep=""), 
                 paste("Rec ",pli$recr,sep=""), 
                 paste("Al.rg cod/qtl ",pli$nar,"/",pli$sar,sep=""),
                 paste("K.rg ",pli$kccr,sep=""), paste("K.m ",pli$Kcc.mean,sep=""),
                 paste("ffec.m/var ",round(pli$fem.fec.mean,3),"/",round(pli$ffec.var,3),sep=""),paste("ffec.rg ",pli$ffr,sep="") )
          } else {
   add.legend<-c(paste("cyMut ",pli$cymur,sep=""),paste("cyAl.rg ",pli$cyar,sep=""),paste("cy.pat.inherit ",pli$cypir,sep=""),
                 paste("Ncod ",pli$nb.nl-pli$nb.sel," Nqtl ",pli$nb.sel,sep=""),
                 paste(pli$shsel," selection",sep=""),
                 paste("w2.rg ",pli$w2r,sep=""),paste("Vzopt ",round(pli$Vzopt,4),sep=""),
                 paste("nuMut ",pli$mur, sep=""),
                 paste("Rec ",pli$recr,sep=""), 
                 paste("Al.rg cod/qtl ",pli$nar,"/",pli$sar,sep=""),
                 paste("K.rg ",pli$kccr,sep=""), paste("K.m ",pli$Kcc.mean,sep=""),
                 paste("ffec.m/var ",round(pli$fem.fec.mean,3),"/",round(pli$ffec.var,3),sep=""),paste("ffec.rg ",pli$ffr,sep="") )
          }
   }
   add.legend1<-paste("Clonal.fec ",pli$veg.fec,sep="")

 #  find how many no line symbols
   add.lty<-rep(NA,length(add.legend0)+length(add.legend)+length(add.legend1))   

   if (length(pGi$Ntm)!=0) add.leg2<-paste("Nt.m ",pGi$Ntm,sep="") else add.leg2<-NULL
   if (length(pGi$Stm)!=0) add.leg3<-paste("St.m ",pGi$Stm,sep="") else add.leg3<-NULL
   if (length(pGi$Nt.last.gen)!=0) add.leg4<-paste("Nt.",pGi$mG," ",pGi$Nt.last.gen,sep="") else add.leg4<-NULL
   if (length(pGi$St.last.gen)!=0) add.leg5<-paste("St.",pGi$mG," ",pGi$St.last.gen,sep="") else add.leg5<-NULL
   if (length(pGi$Nremtm)!=0) add.leg6<-paste("Nremt.m ",pGi$Nremtm,sep="") else add.leg6<-NULL
   if (length(pGi$Nsextm)!=0) add.leg7<-paste("Nsext.m ",pGi$Nsextm,sep="") else add.leg7<-NULL
   if (length(pGi$Nclotm)!=0) add.leg8<-paste("Nclot.m ",pGi$Nclotm,sep="") else add.leg8<-NULL

  loc <- par("usr")
  legend( loc[2], loc[4] , legend = c(true.legend,add.legend0,add.legend,add.legend1,add.leg2,add.leg3,add.leg4,add.leg5,add.leg6,add.leg7,add.leg8),
   col = c(true.colq2,""),lty = c(true.ltyq2,add.lty,NA,NA,NA,NA,NA,NA,NA), lwd=2, cex = 0.7 , xpd=TRUE)
  }
  title ("Quantitative trait statistics across Reproductive events",cex.main=1)
dev.off()
}  # end cond plot additional quanti stats

} # end FUN plot.quanti2
############################################################################################################


### apply plot FUN for those arguments written in the command line window when asking Custom plot in the menu
cmd_args <- commandArgs(trailingOnly = TRUE) ##  allowing Rscript from command line
result.file<-cmd_args[1] # define argument 1 = a result file with the same structure than "res1_per_gen_1.txt" 
plot.na<-cmd_args[2]     # define argument 2 so that the same script can be used with the Default plot and the Custom plot options from the GUI
#def2p<-cmd_args[3]      # possible to add a 3rd arg here for using a modified script with the custom plot option 
# etc...

plot.perGen(res.2.plot=result.file,plot.name=plot.na,conf2="conf.txt",def2plot=T,list2plot.user=NULL,
stat2rem=c("Generation","St","Nt","Nremt","Nsext","Nclot"),max.y=1,min.y=-1,plot.legend=T,leg.mar=9,plot.dev="png")
plot.perGen(res.2.plot=result.file,plot.name=plot.na,conf2="conf.txt",def2plot=T,list2plot.user=NULL,
stat2rem=c("Generation","St","Nt","Nremt","Nsext","Nclot"),max.y=1,min.y=-1,plot.legend=T,leg.mar=9,plot.dev="pdf")
 
## run plot quanti stats list 2
plot.quanti2(res.2.plot.q=result.file,conf3="conf.txt",def2plot=T,list2plot.user=NULL,
stat2rem=c("Generation","St","Nt","Nremt","Nsext","Nclot"),plot.legend=T,leg.mar=9)


# if running the script from TinnR or Rstudio editors
#plot.perGen(res.2.plot="res1_per_gen_1.txt",plot.name="plot.perGen",conf2="conf.txt",def2plot=T,list2plot.user=NULL,
#stat2rem=c("Generation","St","Nt","Nremt","Nsext","Nclot"), max.y=1,min.y=-1,plot.legend=T,leg.mar=9,plot.dev="png" )

#plot.quanti2(res.2.plot.q="res1_per_gen_1.txt",conf3="conf.txt",def2plot=T,list2plot.user=NULL,
#stat2rem=c("Generation","St","Nt","Nremt","Nsext","Nclot"),plot.legend=T,leg.mar=9)

