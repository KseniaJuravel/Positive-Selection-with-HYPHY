#!/bin/bash

mkdir results; #if you wish to organize all results in one folder 

for seq_file_fasta in *.fasta; do 
    #for every fasta_seq file ending with .fasta in the directory do:
    #simple loop


	name_variable=$(basename $seq_file_fasta | sed 's/\.fasta//'); #create variable to hold the file name
     #you can modify the end of the file to whatever .pep/.fa - any format ending
  echo $name_variable; #make sure the name_variable created, you can skip this line once you sure about it
  mkdir $name_variable; #open new folder named as the file name 
	wait;
  path=$(readlink -fz $name_variable); # full path to new directory
  echo ${path}; #make sure the path variable created, you can skip this line once you sure about it
	
	cp $seq_file_fasta $path/$seq_file_fasta; #copy fasta file from parent directory to new created folder
  
      # all next files added in the project
  cp MEME_batch.bf $path/MEME_batch.bf;
  cp FUBAR_batch.bf $path/FUBAR_batch.bf;
  cp FEL_batch.bf $path/FEL_batch.bf;
  cp SLAC_batch.bf $path/SLAC_batch.bf;
  
	cd $path;     #go into the new folder 
    
        # adjust all_butch.bf files to fite working .fasta file location:
  sed -i 's|PATH|'$path'|' MEME_batch.bf;
  sed -i 's|PATH|'$path'|' FUBAR_batch.bf;
  sed -i 's|PATH|'$path'|' FEL_batch.bf; 
  sed -i 's|PATH|'$path'|' SLAC_batch.bf; 
  wait;
	
       # The next 2 lines get ORF of the proteins in file of interest, Errors will printed to .log
  TransDecoder.LongOrfs -t $seq_file_fasta > trans.longest.log;
  TransDecoder.Predict -t $seq_file_fasta > trans.predict.log;
     
  sed -i 's/[.]/_/' $name_variable.fasta.transdecoder.*;
      #take out underscores from names
	mafft $name_variable.fasta.transdecoder.pep > $name_variable.fasta.transdecoder.pep_mafft.aln; # create protein alignment
	perl /home/Software/pal2nal/pal2nal.pl $name_variable.fasta.transdecoder.pep_mafft.aln $name_variable.fasta.transdecoder.cds -output fasta > original_codon.aln;      # find the codon alignment.
  cp original_codon.aln original_codon.nuc.$name_variable.aln  
        # for future copy to result folder
  trimal -in original_codon.aln -out trimal_for_tree_codon.fa.aln -fasta -automated1 -sgc -scc -sident > trimal.log; 
        #clean the alignment from problematic regions automatically detected. Other parameters can be used. Gblock can be used instead.
	/home/Software/iqtree/bin/iqtree-omp -s trimal_for_tree_codon.fa.aln -pre $name_variable -m MFP -bb 1000 -alrt 1000 -nt AUTO 
        #creat tree for the sequences in the file
        #take out the art and support valuse
  sed -E 's/[0-9]+\.[0-9]+\/[0-9]+//g' $name_variable.treefile | sed -E 's/[0-9]+\/[0-9]+//g' > no_bustrap_$name_variable.treefile
        # take out the pattern of the butstrap values number.number/number or number/number
  wait;
  
        #creat file .nuc to the wrapper use (MEME, FUBAR, FEL, SALC)
  sed -i 's/[|]/ /' original_codon.aln;
  sed -i 's/>/#/' original_codon.aln;
  cat original_codon.aln no_bustrap_$name_variable.treefile > original_codon.nuc;
  
  #call HYPHY
  HYPHYMP MEME_batch.bf;
  wait; 
  #make table of the codons sort by p-value [8 col in excel file]
  grep -Pzo '.*"0":[[](.*\n)*' original_codon.nuc.MEME.json | grep -v '"' | sed 's/],//' | sed 's/[[]//' | sed 's/}//' | sed 's/[]]//' |    sed '/^ *$/d' | cat -n | sort -k8 > original_codon.nuc.$name_variable.MEME.scv ;
  
  #call FUBAR
  HYPHYMP FUBAR_batch.bf;
  wait;
  #make table of the codons sort 0-0.9 
  sed '/settings/,$d' original_codon.nuc.FUBAR.json | grep -Pzo '.*"0":[[](.*\n)*' | grep -v '"' | sed 's/],//' | sed 's/[[]//' | sed 's/}//' | sed 's/[]]//' |    sed '/^ *$/d' | cat -n | sort -k6 > original_codon.nuc.$name_variable.FUBAR.scv;
  
   #call FEL
   HYPHYMP FEL_batch.bf;
   wait;
   #make table of the codons by p-value, IN EXCEL: sort by beta from biggest to smallest than sort by halpha from smallest to biggest.
   grep -Pzo '.*"0":[[](.*\n)*' original_codon.nuc.FEL.json | grep -v '"' | sed 's/],//' | sed 's/[[]//' | sed 's/}//' | sed 's/[]]//' |    sed '/^ *$/d' | cat -n | sort -k6 > original_codon.nuc.$name_variable.FEL.scv;
   
   
   #call SALCK
   HYPHYMP SALC_batch.bf;
   wait;
   #make table of the codons sort by p-value
   sed '/RESOLVED/,$d' original_codon.nuc.SLAC.json | grep -Pzo '.*AVERAGED(.*\n)*' | grep -v '"' | sed 's/],//' | sed 's/[[]//' | sed 's/}//' | sed 's/[]]//' |    sed '/^ *$/d' | cat -n | sort -k10 > original_codon.nuc.$name_variable.SLAC.scv;
   # From the json output:
   # "P [dN/dS > 1]", "Binomial probability that S is no greater than the observed value, with P<sub>s</sub> probability of success", = k10 are candidates to be experiencing positive selection.
   # "P [dN/dS < 1]", "Binomial probability that S is no less than the observed value, with P<sub>s</sub> probability of success"
   # k11 
   
   #copy results files to first created results/ directory
   cp  $path/original_codon.nuc.* /your_path_to/results/;  
   
	cd ..
 
 
 
 
done

