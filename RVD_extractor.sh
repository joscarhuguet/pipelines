#!/bin/bash

#!/bin/bash
#perl selectsites.pl -f RVDs_coordinates tal_effector_example.fa
#pipeline to extract RVDs from sequences
#frist blast RVD motif against  prdicted cds of TAL effector
#>TAL_REPEAT
#LTPEQVVAIASHDGGKQALETVQRLLPVLCQAHG
#!/usr/bin/perl -w
# usage : perl toolExample.pl <FASTA file> <output file>makeblastdb -in RVD_bait -dbtype prot

grep '>' inputsequence | sed 's/>//g' > IDs
#blast RVD with the target sequence
blastp -query inputsequence -db RVD_bait -outfmt 6 -out tal_effector_example_results
#prepare a file with coordinate list
cut -f 7,8 tal_effector_example_results | sort -n -k 2 | tr '\t' '-' > RVDs_coordinates
#extract the RVDs
count=1;for x in `cat RVDs_coordinates`;do perl selectsites.pl -s $x inputsequence > TAL_$count; count=`expr $count+1`;done 
cat TAL_* > repeatsV1.fa
awk '/^>/{print ">" sprintf("%05d",++i); next}{print}' < repeatsV1.fa > repeats.fa
#align RVDs to obtain the 12th and 13th position
echo "aligning repeats with clustal....."
./clustalw2 repeats.fa -OUTPUT=fasta -QUIET
#The output of clustakw is funny and the RVDs have to be re-orderered
sed -e '/>/s/^/@/' -e '/>/s/$/#/' repeats.fasta | tr -d "\n" | tr "@" "\n" | sort -t "_" -k2n | tr "#" "\n" | sed -e '/^$/d' > aligment_repeats.fa
#rm -f repeats.fasta
#select 12th and 13th position
perl selectsites.pl -s 12-13 aligment_repeats.fa | grep -v '>' > colunm_RVD
#write 12th and 13th position in single line format
awk 'BEGIN { ORS = " " } { print }'col colunm_RVD > parsed_colunm_RVD
sed 's/-/*/g' parsed_colunm_RVD > replace_parsed_colunm_RVD
awk '{printf "%s\r\n", $0}' replace_parsed_colunm_RVD > RDV.out
rm -f TAL_*
##warning protocol
grep "-" colunm_RVD | head -n 1 > string
if [[ `cat string` = '-'* ]] || [[ `cat string` = "--" ]] ; then 
        echo "WARNING 12th POSITION in `cat IDs` IS EMPTY, POSIBLY MISS-ALIGMENT-CHECK MANUALLY `cat IDs` !!!" 
else
        echo "done! check Results_RVD ......"
fi;
#echo  `cat string`

paste IDs RDV.out >> Results_RVD

