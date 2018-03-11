Lab 06 Replication Notebook
================
Christopher Prener, Ph.D.
(March 10, 2018)

Introduction
------------

This is the replication notebook for Lab-04 from the course SOC 4650/5650: Introduction to GISc.

Load Dependencies
-----------------

The following code loads the package dependencies for our analysis:

``` r
# tidyverse packages
library(dplyr) # data wrangling
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(lubridate) # working with dates
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

``` r
library(stringr) # working with strings

# other packages
library(here) # working directory tools
```

    ## here() starts at /Users/chris/Desktop/lab-06-replication

    ## 
    ## Attaching package: 'here'

    ## The following object is masked from 'package:lubridate':
    ## 
    ##     here

``` r
library(sf) # spatial data tools
```

    ## Linking to GEOS 3.6.1, GDAL 2.1.3, proj.4 4.9.3

Load Data
---------

The following code loads the data package and assigns our data to a data frame in our global environment:

``` r
hailEvents <- st_read(here("data","rawData", "METRO_WX_Hail.shp"), stringsAsFactors = FALSE)
```

    ## Reading layer `METRO_WX_Hail' from data source `/Users/chris/Desktop/lab-06-replication/data/rawData/METRO_WX_Hail.shp' using driver `ESRI Shapefile'
    ## Simple feature collection with 2155 features and 22 fields
    ## geometry type:  LINESTRING
    ## dimension:      XY
    ## bbox:           xmin: 643088 ymin: 4214150 xmax: 835220.7 ymax: 4345017
    ## epsg (SRID):    26915
    ## proj4string:    +proj=utm +zone=15 +datum=NAD83 +units=m +no_defs

Part 3
------

### Question 10

The following block removes the pre-existing year, month, and day variables.

``` r
hailEvents <- select(hailEvents, -yr, -mo, -dy)
```

### Question 11

The following pipe takes the edited hail data and converts the `date` variable from a string to a properly formatted date. Individual variables are then produced for the different components of the date, include day, month, and year.

``` r
hailEvents %>%
  mutate(date = ymd(date)) %>%
  mutate(year = year(date)) %>%
  mutate(month = month(date)) %>%
  mutate(day = date(date)) -> hailEvents
```

We now have a well formatted, and clearly named (unlike the initial variables), set of the date variables to work with.

### Question 12

The following `ifelse()` statement below is the way we have been working with strings up to this point. If a string literally contains an exact match, we make one change. Otherwise, we make a different change. In this case, we take the state abbreviation data and modify them so we can practice working with strings:

``` r
hailEvents %>%
  mutate(st = ifelse(st == "MO", "State of Missouri;", "State of Illinois;")) -> hailEvents
```

We now have an edited state name variable that contains both the valid data as well as a semi-colon.

### Question 13

The following pipe replaces the semi-colon with nothing, then edits both state names without dealing with the literal contents of each variable. If the words "Missouri" or "Illinois" are detected, they are replaced with the appropriate abbreviation. The values are then capitalized completely. We make use of the `word()` function to be able to re-create a state abbreviation variable, again without dealing with the full contents of each value. We also create two logical variables identifying both Illinois and Missouri.

``` r
hailEvents %>%
  mutate(st = str_replace(st, "[;]", "")) %>%
  mutate(st = str_replace(st, "Missouri", "MO")) %>% 
  mutate(st = str_replace(st, "Illinois", "IL")) %>%
  mutate(st = str_to_upper(st)) %>%
  mutate(stAbbrev = ifelse(word(st, 3) == "MO", "MO", "IL")) %>%
  mutate(illinois = ifelse(str_detect(stAbbrev, "IL"), TRUE, FALSE)) %>%
  mutate(missouri = ifelse(str_detect(stAbbrev, "MO"), TRUE, FALSE)) -> cleanHail
```

We have now re-modified the string data so that we have a set of variables with the full name of the state as well as an abbreviation and a logical indicator.

### Question 14

We can use skills from earlier in the semester to subset our data by year. There are two ways to do this. One is to use the `year` variable we created:

``` r
hailPre2000 <- filter(cleanHail, year < 2000)
hailPost2000 <- filter(cleanHail, year >= 2000)
```

The other is to use the `date` variable:

``` r
hailPre2000_v2 <- filter(cleanHail, year(date) < 2000)
hailPost2000_v2 <- filter(cleanHail, year(date) >= 2000)
```

Since the `date` variable has been converted to a date from a character variable, we can use operators on it just like we would a numeric variable!

### Question 15

Finally, we can save our newly created data to shapefiles:

``` r
st_write(hailPre2000, here("data", "cleanedData", "hailPre2000.shp"), delete_dsn = TRUE)
```

    ## ignoring columns with unsupported type:
    ## [1] "illinois missouri"
    ## Deleting source `/Users/chris/Desktop/lab-06-replication/data/cleanedData/hailPre2000.shp' using driver `ESRI Shapefile'
    ## Writing layer `hailPre2000' to data source `/Users/chris/Desktop/lab-06-replication/data/cleanedData/hailPre2000.shp' using driver `ESRI Shapefile'
    ## features:       644
    ## fields:         23
    ## geometry type:  Line String

``` r
st_write(hailPost2000, here("data", "cleanedData", "hailPost2000.shp"), delete_dsn = TRUE)
```

    ## ignoring columns with unsupported type:
    ## [1] "illinois missouri"
    ## Deleting source `/Users/chris/Desktop/lab-06-replication/data/cleanedData/hailPost2000.shp' using driver `ESRI Shapefile'
    ## Writing layer `hailPost2000' to data source `/Users/chris/Desktop/lab-06-replication/data/cleanedData/hailPost2000.shp' using driver `ESRI Shapefile'
    ## features:       1511
    ## fields:         23
    ## geometry type:  Line String

Notice that the two logical variables - `illinois` and `missouri` - were not included in the export because they are in a format that is not supported by shapefiles. If you have logical data, convert it to character before exporting it:

``` r
hailPost2000 %>%
  mutate(illinois = as.character(illinois)) %>%
  mutate(missouri = as.character(missouri)) -> hailPost2000
```
