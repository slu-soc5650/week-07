// ==========================================================================

// SOC 4650/560 - LAB-07 REPLICATION

// ==========================================================================

// define project name

local projName "newDams"

// ==========================================================================

// standard opening options

log close _all
graph drop _all
clear all
set more off
set linesize 80

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// construct directory structure for tabular data

capture mkdir "CodeArchive"
capture mkdir "DataClean"
capture mkdir "DataRaw"
capture mkdir "LogFile"
capture mkdir "Output"

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// create permanent text-based log file
log using "LogFile/`projName'.txt", replace text name(permLog)

// create temporary smcl log file for MarkDoc
quietly log using "LogFile/`projName'.smcl", replace smcl name(tempLog)

// ==========================================================================
// ==========================================================================
// ==========================================================================

/***
# Lab-07 Replication
#### SOC 4650/5650: Intro to GIS
#### Christopher Prener, Ph.D.
#### 04 Mar 2017

### Description
This do-file replicates the Stata portion of lab-07, which involves creating
new variables using Stata.

### Dependencies
This do-file was written and executed using Stata 14.2.

It also uses the latest [MarkDoc](https://github.com/haghish/markdoc/wiki)
package via GitHub as well as the latest versions of its dependencies:
***/

version 14
which markdoc
which weave
which statax

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/***
### Import/Open Data
***/

local rawData "MO_HYDRO_Dams.csv"

/***
### Question 8
***/

import delimited `rawData', varnames(1)

/***
**8a.** The `import delimited` command imports the raw data into Stata.
These data describe the location and characteristics of dams in Missouri.
***/

generate damhtS = damht
recode damhtS (0/10 = 1) (11/19 = 2) (20/29 = 3) (30/252 = 4)
tabulate damhtS

/***
**8b.** This approach to recoding data takes a copy of the old variable and
uses the `recode` command to manipulate the values. You can see from the
follow-up frequency table shows the majority of the dams are twenty feet or
greater.
***/

generate str taboCreek = "false"

/***
**8c.** This approach to recoding data creates a new string variable that,
by default, is filled with `false` values.
***/

replace taboCreek = "true" if strpos(offname, "TABO CREEK")
tabulate taboCreek

/***
**8d.** These are then replaced using the `replace` command if the dam's
official name includes the words `TABO CREEK`. Tabo Creek is a tributary
of the Missouri River in the western part of the state near Kansas City.
The follow-up frequency table shows that there are 55 records in the
National Inventory of Dams that contain the name `TABO CREEK`.
***/

generate shortDam = .

/***
**8e.** This approach to recoding data starts by creating a new numeric
variable that contains "missing" data.
***/

replace shortDam = 0 if damht < 20

/***
**8f.** These missing values are replace with zeros if the height of
the dam is less than twenty feet.
***/

replace shortDam = 1 if damht >= 20 & damht <= 252

/***
**8g.** If dams are twenty feet or larger (up to the highest value in the
dataset, 252 feet), values for `shortDam` are replaced with ones.
***/

generate str boone = ""

/***
**8h.** This approach to recoding data starts be creating a new string
variable that contains "missing" data.
***/

replace boone = "no" if county != "BOONE"

/***
**8i.** If the county is not `BOONE`, values in `boone` are replaced with
the text `no`.
***/

replace boone = "yes" if county == "BOONE"

/***
**8bj.** If the county does equal `BOONE`, values in `boone` are replaced
with the text `yes`.
***/

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/***
### Save and Export Clean Data
***/

save "DataClean/`projName'.dta", replace
export delimited "DataClean/`projName'.csv", replace

// ==========================================================================
// ==========================================================================
// ==========================================================================

// end MarkDoc log

/*
quietly log close tempLog
*/

// convert MarkDoc log to Markdown

markdoc "LogFile/`projName'", replace export(md)
copy "LogFile/`projName'.md" "Output/`projName'.md", replace
shell rm -R "LogFile/`projName'.md"
shell rm -R "LogFile/`projName'.smcl"

// ==========================================================================

// archive code and raw data

copy "`projName'.do" "CodeArchive/`projName'.do", replace
copy "`rawData'" "DataRaw/`rawData'", replace

// ==========================================================================

// standard closing options

log close _all
graph drop _all
set more on

// ==========================================================================

exit
