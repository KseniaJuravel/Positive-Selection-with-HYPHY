#!/bin/bash


/* the options passed to the GUI are encoded here */
inputRedirect = {};
inputRedirect["01"]="Universal";
inputRedirect["02"]="PATH/original_codon.nuc";  ## This will be automatically changed by the .sh script
inputRedirect["03"]="Y";
inputRedirect["04"]="All";
inputRedirect["05"]="Yes";
inputRedirect["06"]="0.1";
ExecuteAFile ( "/usr/local/lib/hyphy/TemplateBatchFiles/SelectionAnalyses/FEL.bf", inputRedirect );


##pay attention to change this file path to the location in your computer:
## /usr/local/lib/hyphy/TemplateBatchFiles/SelectionAnalyses/FEL.bf
