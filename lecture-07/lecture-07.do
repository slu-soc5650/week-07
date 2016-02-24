// ==========================================================================

// SOC 4650/5650 - WEEK 07 LECTURE

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

log using lecture07.txt, text replace

// ==========================================================================

/* 
file name - lecture07.do

project name -	SOC 4650/5650 - Intro to GISc - Spring 2016
                                                                                 
purpose - replicate lecture 07 stata commands
	                                                                               
created - 24 Feb 2016

updated - 24 Feb 2016
                                                                                
author - CHRIS
*/                                                                              

// ==========================================================================
                                                                                 
/* 
full description - 
This do-file replicates lecture 07 Stata commands for working with string
data in Stata.
*/

/* 
updates - 
none
*/

// ==========================================================================

/* 
superordinates  - 
none
*/

/* 
subordinates - 
none
*/

// ==========================================================================
// ==========================================================================
// ==========================================================================

// open data and save

sysuse census.dta
save censusWeek07.dta, replace

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// convert pop to string

tostring pop, generate(popStr) force

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// convert popStr back to numeric

destring pop, generate(popNum)

// ==========================================================================
// ==========================================================================
// ==========================================================================

// standard closing options

log close _all
graph drop _all
set more on

// ==========================================================================

exit
