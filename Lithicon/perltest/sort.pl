#!/usr/bin/perl

#Sorter array

@alfabet=("t","f","e","c","h","k","g","d","p","j","m","o","n","i","r","s","q","l","b","a");

while ($teller < $#alfabet){
	for $i (0..$#alfabet){
		if ($alfabet[$i] gt $alfabet[$i+1]){
			$temp=splice (@alfabet,$i,1);
			splice (@alfabet,$i+1,0,$temp);
		}
	}
	print "$teller:\t@alfabet\n";
	$teller++;
}
