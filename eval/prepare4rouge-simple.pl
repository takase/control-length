#!/usr/bin/perl

# Copyright © 2010 Kavita Ganesan www.kavita-ganesan.com/
# Date:        12/18/2010
# Author:      Kavita Ganesan (kganes2@illinois.edu)
#   This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


use strict;



my $OUTPUT_HOME = $ARGV[2]; #where to generate output 
my $DIR_SYSTEM=$ARGV[0]; # location of system generated files
my $DIR_GOLD=$ARGV[1]; # location of gold standard files

#`rm -r $OUTPUT_HOME `;


`mkdir $OUTPUT_HOME `;
`mkdir $OUTPUT_HOME/systems `;
`mkdir $OUTPUT_HOME/models `;

my $systemFile = shift;
my @models = @ARGV;
my @sentences = ();

opendir(GOLD, "$DIR_GOLD") || die("Cannot open directory"); 
my @thegoldfiles= readdir(GOLD);
#gold standard files are inside a directory
foreach my $goldir (@thegoldfiles) 
{
	my $thepath="$DIR_GOLD/$goldir";

	if ((-d $thepath) && ($goldir ne '.') && ($goldir ne '..') ) {
		
		opendir(GOLDFILES, "$DIR_GOLD/$goldir") || die("Cannot open directory"); 
		my @thefiles= readdir(GOLDFILES);
		
		foreach my $file (@thefiles) 
		{
			if( ($file ne '.') && ($file ne '..')){
				my $abspath="$thepath/$file";
				@sentences = &open_file($abspath);
				open (MODEL,">$OUTPUT_HOME/models/$file.html");
				print MODEL "<html>
				<head>
				<title>$file.html</title>
				</head>
				<body bgcolor=\"white\">\n";
				my $count = 1;
				foreach my $j (0..$#sentences) {
						print MODEL "<a name=\"$count\">[$count]</a> <a href=\"#$count\" id=$count>";
						print MODEL $sentences[$j];
						print MODEL "</a>\n";
						$count++;
				}
				print MODEL "</body>
									 </html>\n";
			close MODEL;
			}
			}
		}
	}



opendir(SYS, "$DIR_SYSTEM") || die("Cannot open directory"); 
my @theSYSfiles= readdir(SYS);
#gold standard files are inside a directory
foreach my $SYSdir (@theSYSfiles) 
{
	my $thepath="$DIR_SYSTEM/$SYSdir";

	if ((-d $thepath) && ($SYSdir ne '.') && ($SYSdir ne '..') ) {
		
		opendir(SYSFILES, "$DIR_SYSTEM/$SYSdir") || die("Cannot open directory"); 
		my @thefiles= readdir(SYSFILES);
		
		foreach my $file (@thefiles) 
		{
			if( ($file ne '.') && ($file ne '..')){
				my $abspath="$thepath/$file";
				@sentences = &open_file($abspath);

				open (SYSTEM, ">$OUTPUT_HOME/systems/$file.html");
				print SYSTEM "<html>
				<head>
				<title>$file.html</title>
				</head>
				<body bgcolor=\"white\">\n";
	
				my $count = 1;
				
				foreach my $i (0..$#sentences) {
					print SYSTEM "<a name=\"$count\">[$count]</a> <a href=\"#$count\" id=$count>";
					print SYSTEM $sentences[$i];
					print SYSTEM "</a>\n";
					$count++;
				}
				print SYSTEM "</body>
				</html>\n";
				close SYSTEM;
				}
			}
		}
}

my $evalID = 1;
my $fileid=0;

`rm $OUTPUT_HOME/settings.xml`;

open (CONFIG, ">$OUTPUT_HOME/settings.xml");
print CONFIG "<ROUGE_EVAL version=\"1.5.5\">\n";

opendir(GOLD, "$DIR_GOLD") || die("Cannot open directory"); 
my @thegoldfiles= readdir(GOLD);
#gold standard files are inside a directory
foreach my $file (@thegoldfiles) 
{

	if ((-d "$DIR_GOLD/$file") && ($file ne '.') && ($file ne '..') ) {
	
	my @models;
	my @peers;
	opendir DIR, "$OUTPUT_HOME/models";
	@models = grep { /$file.*/} readdir DIR;
	closedir DIR;

	opendir DIR, "$OUTPUT_HOME/systems";
	@peers = grep { /$file.*/} readdir DIR;
	closedir DIR;

	my $id=1;

	$fileid++;

	my $msize= @models;
	

	
	
	my $count=0;
	my $limit=$msize;
	
	
	if (scalar(@peers)>0) {
	
	print CONFIG "<EVAL ID=\"$evalID\">\n";
	print CONFIG "<PEER-ROOT>systems</PEER-ROOT>\n";
	print CONFIG "<MODEL-ROOT>models</MODEL-ROOT>\n";
	print CONFIG "<INPUT-FORMAT TYPE=\"SEE\"></INPUT-FORMAT>\n<PEERS>";
	my $id=1;
	foreach my $peer (@peers) 
	{
		my $pid="";

		if($peer =~ m/.*system.*html/ig){
			my @tokens=split('\.system.*',$peer);
			my $tmp=$tokens[0];
			$tmp=~s/\./!/i;
			my @tokens=split('!',$tmp);
			$pid=$pid.$tokens[1];
		}
		
		
		print CONFIG "\n<P ID=\"$pid\">$peer</P>";
		
	}	
	
	print CONFIG "</PEERS>\n
	<MODELS>\n";
	my $id=1;
	foreach my $model (@models) 
	{
			print CONFIG "\n<M ID=\"$id\">$model</M>";
			$id++;
	}
		

	print CONFIG "\n</MODELS>
	</EVAL>\n";
	}
	$evalID++;
	
	 #done eval
	}
}

print CONFIG "\n</ROUGE_EVAL>";
close CONFIG;

#====================================
sub open_file{
my $file = shift;

my @sents = ();

local( $/ ) = undef;

open(FILE, "$file") or die "can't find the file: $file. \n";

my $input = <FILE>;

close FILE;

if ($input =~/DOCTYPE DOCUMENT SYSTEM/){
   my $text = "";
   $input =~/<TEXT>(.*)<\/TEXT>/s;
   $text = $1;
   @sents = split /[\n\r]/, $text;
}

else {

@sents = split /[\n\r]/, $input;

foreach my $s (@sents){
   $s =~s/^\[\d+\]\s+(.*)/$1/;
  }
}
return @sents;
}

