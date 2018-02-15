#!/bin/bash


/* the options passed to the GUI are encoded here */
inputRedirect = {};
inputRedirect["01"]="Universal";
inputRedirect["02"]="PATH/original_codon.nuc";  ## This will be automatically changed by the .sh script
inputRedirect["03"]="Y";
inputRedirect["04"]="20";
inputRedirect["05"]="5";
inputRedirect["06"]="2000000";
inputRedirect["07"]="1000000";
inputRedirect["08"]="100";
inputRedirect["09"]="0.5";
ExecuteAFile ( "/usr/local/lib/hyphy/TemplateBatchFiles/SelectionAnalyses/FUBAR.bf", inputRedirect );


## pay attention to change this file path to the location in your computer:
##/usr/local/lib/hyphy/TemplateBatchFiles/SelectionAnalyses/FUBAR.bf


