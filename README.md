# Positive-Selection-with-HYPHY
Here is a simple code for PS detection loop that can be used on several files in fasta format. Take it as inspiration, modify it for your needs.

Before start:
This script using different softwares and additional code you need to make sure downloaded and installed on your computer.\
TransDecoder -> get ORF \
pal2nal.pl -> create codon alignment \
mafft -> make alignment \
trimal/Gblocks -> clean and trim the alignment\
iqtree-omp -> create tree \
HYPHYMP -> Datamonkey

Table of Contents:\
 Positive_Selection.sh - main script\
 *_batch.bf  - additional files for PS testes
 
 
 To use this script make a fasta format file with all your sequences of interest (as many as you wish in number) for the positive selection detection. Then download all the batch  files and the .sh script, put them in same directory with the fasta and simpely run it: sh file_name  

One problem I still have no idea how to overcome:\
If your sequences have more than 1 ORF, after the Transdecoder you will get duplication of the gene.
My solution for this kind of genes: \
Divide the .sh into 2 and after the Transdecoder to go over manually and chose the longest ORF in the pep and cds files.
I have also tried to cluster with USEARCH for 99%, but sometimes it can collapse very identical genes.

Credits:\
@Diego Santos Garcia\
https://www.researchgate.net/profile/Diego_Santos-Garcia
\
For help in creating the batch.bf files.

