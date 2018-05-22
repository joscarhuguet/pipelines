#!/usr/bin/perl
##script to wrap TAL effectors multifasta and extract RVDs
use strict ;
use warnings;

#print STDOUT "Enter the motif: ";
#my $motif = <STDIN>;
#chomp $motif;

my %seqs = %{ read_fasta_as_hash( 'tal_effector_example.fa' ) };
foreach my $id ( keys %seqs ) {
    #system "bash RVD_extractor.sh";
	#if ( $seqs{$id} =~ /$motif/ ) {
    open (OUT, '>inputsequence' );
	print OUT $id, "\n", $seqs{$id};
	close(OUT);
	print "$id", "\n";
	system 'bash RVD_extractor.sh';
	    
	
#}
}



sub read_fasta_as_hash {
    my $fn = shift;

    my $current_id = '';
    my %seqs;
    open FILE, "<$fn" or die $!;
    while ( my $line = <FILE> ) {
        chomp $line;
        if ( $line =~ /^(>.*)$/ ) {
            $current_id  = $1;
        } elsif ( $line !~ /^\s*$/ ) { # skip blank lines
            $seqs{$current_id} .= $line
        }
    }
    close FILE or die $!;

    return \%seqs;
}