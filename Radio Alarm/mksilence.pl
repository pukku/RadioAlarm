#!/usr/bin/perl
# see http://www.boutell.com/scripts/silence.html

my $minutes = 240;
my $seconds = $minutes * 60;
my $file = '/Users/pukku/git/xcode/Radio\\ Alarm/silence/' . $minutes . '.aiff';
if ((!$seconds) || ($file eq "")) {
        die "Usage: silence seconds newfilename.wav\n";
}

my $samplerate = 60;

open(OUT, ">/tmp/$$.dat");
print OUT "; SampleRate $samplerate\n";
$samples = $seconds * $samplerate;
for ($i = 0; ($i < $samples); $i++) {
        print OUT $i / $samplerate, "\t0\n";
}
close(OUT);

system("sox /tmp/$$.dat $file");
unlink("/tmp/$$.dat");
