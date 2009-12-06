##### We will 'require' necessary modules first.
# Comments can be C-style or bash/perl/python style

require [ "fileinto" ];


##### Filter the spam into your spam folder. This is done 
# on the global sieve script by default IF you don't have 
# a .dovecot.sieve file.  When you create your sieve script,
# the global one will be disabled so you have to filter 
# the spam in your own script.
if header :is "X-Spam-Flag" "YES" {
    fileinto "spam";
    stop; #---- this stops further processing; 
    #prevents sending replies and/or redirecting(forwarding)
}
