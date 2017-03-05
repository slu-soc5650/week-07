# Lab-07 Replication

## SOC 4650/5650: Intro to GIS

## Christopher Prener, Ph.D.

## 04 Mar 2017

### Description

This do-file replicates the Stata portion of lab-07, which involves creating new variables using Stata.

### Dependencies

This do-file was written and executed using Stata 14.2.

It also uses the latest [MarkDoc](https://github.com/haghish/markdoc/wiki) package via GitHub as well as the latest versions of its dependencies:

```stata
  . version 14

  . which markdoc
  /Users/herb/Library/Application Support/Stata/ado/plus/m/markdoc.ado

  . which weave
  /Users/herb/Library/Application Support/Stata/ado/plus/w/weave.ado

  . which statax
  /Users/herb/Library/Application Support/Stata/ado/plus/s/statax.ado
```

### Import/Open Data

```stata
  . local rawData "MO_HYDRO_Dams.csv"
```

### Question 8

```stata
  . import delimited `rawData', varnames(1)
  (15 vars, 5,271 obs)
```

**8a.** The `import delimited` command imports the raw data into Stata. These data describe the location and characteristics of dams in Missouri.

```stata
  . generate damhtS = damht

  . recode damhtS (0/10 = 1) (11/19 = 2) (20/29 = 3) (30/252 = 4)
  (damhtS: 5271 changes made)

  . tabulate damhtS

       damhtS |      Freq.     Percent        Cum.
  ------------+-----------------------------------
            1 |        120        2.28        2.28
            2 |        381        7.23        9.50
            3 |      2,910       55.21       64.71
            4 |      1,860       35.29      100.00
  ------------+-----------------------------------
        Total |      5,271      100.00
```

**8b.** This approach to recoding data takes a copy of the old variable and uses the `recode` command to manipulate the values. You can see from the follow-up frequency table shows the majority of the dams are twenty feet or greater.

```stata
  . generate str taboCreek = "false"
```

**8c.** This approach to recoding data creates a new string variable that, by default, is filled with `false` values.

```stata
  . replace taboCreek = "true" if strpos(offname, "TABO CREEK")
  (55 real changes made)

  . tabulate taboCreek

    taboCreek |      Freq.     Percent        Cum.
  ------------+-----------------------------------
        false |      5,216       98.96       98.96
         true |         55        1.04      100.00
  ------------+-----------------------------------
        Total |      5,271      100.00
```

**8d.** These are then replaced using the `replace` command if the dam's official name includes the words `TABO CREEK`. Tabo Creek is a tributary of the Missouri River in the western part of the state near Kansas City. The follow-up frequency table shows that there are 55 records in the National Inventory of Dams that contain the name `TABO CREEK`.

```stata
  . generate shortDam = .
  (5,271 missing values generated)
```

**8e.** This approach to recoding data starts by creating a new numeric variable that contains "missing" data.

```stata
  . replace shortDam = 0 if damht < 20
  (501 real changes made)
```

**8f.** These missing values are replace with zeros if the height of the dam is less than twenty feet.

```stata
  . replace shortDam = 1 if damht >= 20 & damht <= 252
  (4,770 real changes made)
```

**8g.** If dams are twenty feet or larger (up to the highest value in the dataset, 252 feet), values for `shortDam` are replaced with ones.

```stata
  . generate str boone = ""
  (5,271 missing values generated)
```

**8h.** This approach to recoding data starts be creating a new string variable that contains "missing" data.

```stata
  . replace boone = "no" if county != "BOONE"
  variable boone was str1 now str2
  (5,144 real changes made)
```

**8i.** If the county is not `BOONE`, values in `boone` are replaced with the text `no`.

```stata
  . replace boone = "yes" if county == "BOONE"
  variable boone was str2 now str3
  (127 real changes made)
```

**8bj.** If the county does equal `BOONE`, values in `boone` are replaced with the text `yes`.

### Save and Export Clean Data

```stata
  . save "DataClean/`projName'.dta", replace
  (note: file DataClean/newDams.dta not found)
  file DataClean/newDams.dta saved

  . export delimited "DataClean/`projName'.csv", replace
  (note: file DataClean/newDams.csv not found)
  file DataClean/newDams.csv saved
```

## Post-Export Edits
After this was exported as `newDams.md`, I saved a copy of the file as `newDamsPost.md` to illustrate how the file was changed after export.

I began by opening it in Atom and running the `tidy-markdown` package. The `tidy-markdown` package made two changes:
1.   Changed the header on line one from the `markdoc` default format, a row of equal signs on the second line, to a single number sign.
2.   Added the code block symbols (three backticks) at the beginning and end of each group of Stata commands and output. `markdoc` relies on tabs to signal to markdown readers that Stata commands and output should be treated as code blocks. We can distinguish these more explicitly by using backticks.

After running the `tidy-markdown` package, I made some additional manual edits. I used `linter-markdown` to check the quality of my markdown syntax and make any changes as necessary.

I also added the word `stata` to the top of each code block. This is done to signal to websites that can automatically add [syntax highlighting](https://en.wikipedia.org/wiki/Syntax_highlighting) that the code should be highlighted as Stata code.

For each code block, I removed the tabs that `markdoc` added by highlighting the entire codeblock and using the combination of `shift+tab` to de-tab each code block. I left a single tab space on each line.

Finally, I used Atom to spell check the output file.
