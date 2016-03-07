// ==========================================================================

// SOC 4650/5650 - Lab-07

// ==========================================================================

// standard opening options

version 14
log close _all
graph drop _all
clear all
set more off
set linesize 80

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// change directory

if "`c(os)'" == "MacOSX" {
	cd "/Users/`c(username)'/Documents/Working"
}

else if "`c(os)'" == "Windows" {
	cd "C:\Users\`c(username)'\Documents\Working"	
}

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// log process

log using lab07.txt, text replace

// ==========================================================================

/* 
file name - lab07.do

project name - SOC 4650/5650 - Intro to GISc - Spring 2016
                                                                                 
purpose - replicating lab-07
	                                                                               
created - 24 Feb 2016

updated - 24 Feb 2016
                                                                                
author - CHRIS
*/                                                                              

// ==========================================================================
                                                                                 
/* 
full description - 
This file fully replicates the Stata portion of Lab-07 (Part 4)
*/

/* 
updates - 
none
*/

// ==========================================================================

/* 
superordinates  - 
This file requires the file census.dta, which comes pre-installed with Stata
*/

/* 
subordinates - 
none
*/

// ==========================================================================
// ==========================================================================
// ==========================================================================

// 1. open data
sysuse census.dta

// 2. save copy of data
save censusLab07.dta, replace

// 3. create string versions
tostring death, generate(deathStr) force
tostring marriage, generate(marriageStr) force
tostring divorce, generate(divorceStr) force

// 4. destring variables created in step 3
destring deathStr, generate(deathNum)
destring marriageStr, generate(marriageNum)
destring divorceStr, generate(divorceNum)

// ==========================================================================
// ==========================================================================
// ==========================================================================

// standard closing options

log close _all
graph drop _all
set more on

// ==========================================================================

exit
