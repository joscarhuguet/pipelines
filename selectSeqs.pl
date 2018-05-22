#!/usr/bin/perl

my $usage="Select specified sequences from a fasta file and print them out\n" .
    "Usage: $0 [-hv] -f seqNamesFile [fastaFile]\n" .
    "   or  $0 [-hv] -m 'pattern' [fastaFile]\n" .
    "   or  $0 [-hv] -n 'i,j,k,...' [fastaFile]\n" .
    " -f: specify the filename which contains a list of sequence names\n" .
    "     Each line contains a name. Comments can be added with \"#\".\n" .
    " -m 'pattern': extract the sequences whose name contains the pattern. \n".
    "               You can use perl type regular expressions\n".
    " -n 'range': take list of integers or lists.  e.g. -n '-3,5,7-9, 12-' will\n".
    "             select sequences 1,2,3,5,7,8,9,12,13,...\n".
    "             This option can be used to reorder or doubling up some seqs\n".
    "             e.g., -n '3,1,2,2' will bring the 3rd sequence to the front,\n".
    "             and the 2nd sequence get doubled\n".
    " -v: Select the sequences which are NOT specified or NOT matching the " .
       "pattern\n".
    "If name of input file (fastaFile) is not given, STDIN is used.\n" .
    "But -f, -m, or -n is mandatory.\n" .
    "Note -vs is not tested well.\n";

# Version 090716
#  - -n option get added.

my $sep = "\t";
my $lineWidth = 70;   # used to break the long sequences into lines.

use Getopt::Std;
getopts('hf:m:n:v') || die "$usage\n";
die "$usage\n" if (defined($opt_h));

if (defined ($opt_f)) {
    @selectedSeqs = ReadSeqNameFile($opt_f);
} elsif (! defined ($opt_m) && ! defined ($opt_n)) {
    die "Please supply a filename containing list of names for -s\n" .
	"or a pattern with -m or integers/range with -n.\n$usage\n";
}

@ARGV = ('-') unless @ARGV; # take STDIN when no arg.
my $seqFile = shift @ARGV;
my @dat = ReadInFASTA($seqFile);

if (defined ($opt_f)) {
    if (defined ($opt_v)) {
	# this part isn't tested well, so check it.
	@dat = SelectSeqsNotSpecified(\@dat, \@selectedSeqs);
    } else {
	@dat = SelectSeqs(\@dat, \@selectedSeqs);
    }
} elsif (defined ($opt_m)) {
    @dat = SelectSeqsByPattern(\@dat, $opt_m);
} elsif (defined ($opt_n)) {
    @dat = SelectSeqsByNumber(\@dat, $opt_n);
}

PrintFASTA(@dat);

exit(0);

# takes an arg; name of a file from which data are read Then read in
# the data and make an array.  Each element of this array corresponds
# to a sequence, name tab data.
sub ReadInFASTA {
    my $infile = shift;
    my @line;
    my $i = -1;
    my @result = ();
    my @seqName = ();
    my @seqDat = ();

    open (INFILE, "<$infile") || die "Can't open $infile\n";

    while (<INFILE>) {
        chomp;
        if (/^>/) {  # name line in fasta format
            $i++;
            s/^>\s*//; s/^\s+//; s/\s+$//;
            $seqName[$i] = $_;
            $seqDat[$i] = "";
        } else {
            s/^\s+//; s/\s+$//;
	    s/\s+//g;                  # get rid of any spaces
            next if (/^$/);            # skip empty line
            s/[uU]/T/g;                  # change U to T
            $seqDat[$i] = $seqDat[$i] . uc($_);
        }

	# checking no occurence of internal separator $sep.
	die ("ERROR: \"$sep\" is an internal separator.  Line $. of " .
	     "the input FASTA file contains this charcter. Make sure this " . 
	     "separator character is not used in your data file or modify " .
	     "variable \$sep in this script to some other character.\n")
	    if (/$sep/);

    }
    close(INFILE);

    foreach my $i (0..$#seqName) {
	$result[$i] = $seqName[$i] . $sep . $seqDat[$i];
    }
    return (@result);
}

sub GetSeqDat {
    my @data = @_;
    my @line;
    my @result = ();

    foreach my $i (@data) {
	@line = split (/$sep/, $i);
	push @result, $line[1];
    }

    return (@result)
}

sub GetSeqName {
    my @data = @_;
    my @line;
    my @result = ();

    foreach my $i (@data) {
	@line = split (/$sep/, $i);
	push @result, $line[0];
    }
    return (@result)
}

sub ReadSeqNameFile {
    my $file = shift;
    my @result = ();
    open(INFILE, "<$file") || die "Can't open $file\n";

    while (<INFILE>) {
        chomp;
        s/#.*$//;    # remove comments (#)
        s/^\s+//; s/\s+$//;
        next if (/^$/);
        push @result, $_;
    }
    close(INFILE);
    return @result;
}

sub SelectSeqsNotSpecified {
    my ($seqARef, $nameARef) = @_;
    my @seqName = GetSeqName(@$seqARef);
    my @seqDat = GetSeqDat(@$seqARef);

    my %nameH = ();
    foreach my $n (@$nameARef) {
	$nameH{$n} = 1;
    }
    
    my @result = ();
    for(my $i = 0; $i < @seqName; $i++) {
	next if (defined($nameH{$seqName[$i]}));
	push @result, $seqName[$i] . $sep . $seqDat[$i];
    }
    return (@result);
}

sub SelectSeqs {
    my ($seqARef, $nameARef) = @_;
    my @seqName = GetSeqName(@$seqARef);
    my @seqDat = GetSeqDat(@$seqARef);

    # make a hash table
    my %seqHash = ();
    for my $i (0..$#seqName) {
	if (exists($seqHash{$seqName[$i]})) {
	    die "ERROR: In fasta file, there are more than 1 entry " .
		"which has the name $seqName[$i]\n";
	} else {
	    $seqHash{$seqName[$i]} = $seqDat[$i];
	}
    }

    # select the specified seqs
    foreach my $name (@$nameARef) {
	if (exists($seqHash{$name})) {
	    my $tmp = $name . $sep . $seqHash{$name};
	    push @result, $tmp;
	} else {
	    warn "WARN: $name didn't occur in the input file\n";
	}
    }
    return @result;
}

sub SelectSeqsByNumber {
    my ($seqARef, $rangeTxt) = @_;

    my $numSeqs = scalar(@$seqARef);

    my @index = MkSelIndex($numSeqs, $rangeTxt);

    if (defined($opt_v)) {
	my @allIndex = 0..($numSeqs-1);
	my @complementIndex = InANotInB(\@allIndex, \@index);
	@index = @complementIndex;
    }

    my @result = ();

    foreach my $i (@index) {
	push @result, $$seqARef[$i];
    }
    return @result;
}

# This is from selectSites.pl
# returns 0 offset index
sub MkSelIndex {
    my ($max, $siteList) = @_;
    $siteList =~ s/^\s+//;
    $siteList =~ s/\s+$//;

    my @sites = split(/\s*,\s*/, $siteList);

    my @result = ();
    foreach my $item (@sites) {
	if ($item =~ /^(\d+)-(\d+)$/) {
	    die "ERROR: 1st number is larger than 2nd in $item\n" if ($1 > $2);
	    $beginPos = $1 - 1;
	    $endPos = $2 - 1;
	} elsif ($item =~ /^-(\d+)$/) {
	    $beginPos = 0;
	    $endPos = $1 - 1;
	} elsif ($item =~ /^(\d+)-$/) {
	    $beginPos = $1 - 1;
	    $endPos = $max-1;
	} elsif ($item =~ /^(\d+)$/) {
	    $beginPos = $1 - 1;
	    $endPos = $1 - 1;
	} else {
	    die "$siteList given as the list of sites.  " . 
		"Make sure it is comma delimitted, and each element is " .
		    " one of the forms: 23-26, 29, -10, 40-\n";  
	}
	push (@result, $beginPos..$endPos);
    }
    return(@result);
}

sub SelectSeqsByPattern {
    my ($seqARef, $pattern) = @_;
    my @seqName = GetSeqName(@$seqARef);
    my @seqDat = GetSeqDat(@$seqARef);

    my @result = ();
    my @matchedNames = ();
    for(my $i = 0; $i <@seqName; $i++) {
	if ( ( (!defined($opt_v)) && $seqName[$i] =~ /$pattern/ ) || 
	     ( ( defined($opt_v)) && $seqName[$i] !~ /$pattern/ ) ) {
	    push @result, $seqName[$i] . $sep . $seqDat[$i];
	    push @matchedNames, $seqName[$i];
	}
    }

    print STDERR "INFO: ". scalar(@result) ." names matched the pattern " .
	"'$pattern'.\n".
	join("\n", @matchedNames) . "\n";
    
    return @result;
}

sub PrintFASTA {
    my @seqName = GetSeqName(@_);
    my @seqDat = GetSeqDat(@_);
    for my $i (0..$#seqDat) {
#	print ">$seqName[$i]\n$seqDat[$i]\n";
	print ">$seqName[$i]\n";
	my $seq = $seqDat[$i];
	for (my $pos=0 ; $pos < length ($seq) ;  $pos += $lineWidth) {
	    print substr($seq, $pos, $lineWidth), "\n";
	}
	
    }
}

sub InANotInB {
    my ($aRef, $bRef) =@_;
    my %seen = ();
    my @aonly =();

    foreach my $item (@$bRef) { $seen{$item} = 1};
    foreach my $item (@$aRef) {
	push (@aonly, $item) unless $seen{$item};
    }
    return (@aonly);
}
