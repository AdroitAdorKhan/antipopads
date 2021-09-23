#!/bin/bash
#-------------------------------------------------------------------------------#
#-------------------------- I N F O  &  L I C E N S E --------------------------#
#-------------------------------------------------------------------------------#
#
#
#                _   _                             _     _
#     __ _ _ __ | |_(_)_ __   ___  _ __   __ _  __| |___| |
#   / _` | '_ \| __| | '_ \ / _ \| '_ \ / _` |/ _` / __| |
#  | (_| | | | | |_| | |_) | (_) | |_) | (_| | (_| \__ \_|
#  \__,_|_| |_|\__|_| .__/ \___/| .__/ \__,_|\__,_|___(_)
#                   |_|         |_|
#
#
#
#
# Author: adroitadorkhan
# Usage: bash apa.sh
# Description: antipopads reborn.
# @adroitadorkhan
# License: CC BY-NC-SA 4.0

#-------------------------------------------------------------------------------#
#--------------------------------- C O L O R S ---------------------------------#
#-------------------------------------------------------------------------------#
R='\033[0;31m'  # Red
LR='\033[1;31m' # Light Red
G='\033[0;32m'  # Green
LG='\033[1;32m' # Light Green
Y='\033[1;33m'  # Yellow
B='\033[0;34m'  # Blue
LB='\033[1;34m' # Light Blue
P='\033[0;35m'  # Purple
LP='\033[1;35m' # Light Purple
C='\033[0;36m'  # Cyan
LC='\033[1;36m' # Light Cyan
O='\033[0;33m'  # Orange
W='\033[1;37m'  # White
N='\033[0m'     # No Color

#-------------------------------------------------------------------------------#
#------------------------------ V A R I A B L E S ------------------------------#
#-------------------------------------------------------------------------------#
date=$(date +%d.%m.%Y)
fileDir=./formats
oFileDir=./
whitelist=unbloc.k
blocklist=bloc.k
formats=formats
hosts=$formats/hosts
hostsTXT=$formats/hosts.txt
hostsV6=$formats/hosts-ipv6.txt
domains=$formats/domains.txt
filter=$formats/filter
dnsMasq=$formats/dnsmasq.conf
dnsMasqIPV6=$formats/dnsmasq-ipv6.conf
unbound=$formats/unbound.conf
rpz=$formats/rpz.txt
oneline=$formats/one-line.txt
file=list
fileTemp=list.temp
urls=urls
footer=$formats/footer
footerAB=$formats/footerAB
footerRPZ=$formats/footerRPZ
footerOL=$formats/footerOL
temp=$formats/temp
atemp=$formats/a.temp
wtemp=$formats/w.temp
divider='------------------------------------------------------------' 2>/dev/null

#-------------------------------------------------------------------------------#
#--------------------------- P A C K  D E T A I L S ----------------------------#
#-------------------------------------------------------------------------------#
#----------------------------- FILL THE INFO HERE ------------------------------#
#-------------------------------------------------------------------------------#
dividerTiny="--------------------------------------------"

headerLogo="#
#              _   _                             _     _
#   __ _ _ __ | |_(_)_ __   ___  _ __   __ _  __| |___| |
#  / _  |  _ \| __| |  _ \ / _ \|  _ \ / _  |/ _  / __| |
# | (_| | | | | |_| | |_) | (_) | |_) | (_| | (_| \__ \_|
#  \__,_|_| |_|\__|_| .__/ \___/| .__/ \__,_|\__,_|___(_)
#                   |_|         |_|
#
#      R        E        B        O        R        N
# $dividerTiny
#
# $dividerTiny
# P A C K  D E T A I L S
# $dividerTiny
# Title: antipopads! - reborn
# Maintainer: Ador <mail@nayemador.com>
# Description: block pesky pop ads.
# Homepage: https://github.com/AdroitAdorKhan/antipopads
# License: MIT"

headerLogoAB="!
!              _   _                             _     _
!   __ _ _ __ | |_(_)_ __   ___  _ __   __ _  __| |___| |
!  / _  |  _ \| __| |  _ \ / _ \|  _ \ / _  |/ _  / __| |
! | (_| | | | | |_| | |_) | (_) | |_) | (_| | (_| \__ \_|
!  \__,_|_| |_|\__|_| .__/ \___/| .__/ \__,_|\__,_|___(_)
!                   |_|         |_|
!
!      R        E        B        O        R        N           N
! $dividerTiny
!
! $dividerTiny
! P A C K  D E T A I L S
! $dividerTiny
! Title: antipopads! - reborn
! Maintainer: Ador <mail@nayemador.com>
! Description: block pesky pop ads.
! Homepage: https://github.com/AdroitAdorKhan/antipopads
! License: MIT"

buildVersion=$(date +%y.%m.%j)
releaseVersion=$(date +%j)
raw="https://raw.githubusercontent.com/AdroitAdorKhan/antipopads/master/formats"
updateDate=$(date +"%a, %d %b %y %H:%M:%S %Z")
expiry="1 day (update frequency)"
echo -e "# $dividerTiny\n# A N T I P O P A D S  E N D S\n# $dividerTiny" >> $footer
echo -e "! $dividerTiny\n! A N T I P O P A D S  E N D S\n! $dividerTiny" >> $footerAB

#-------------------------------------------------------------------------------#
#--------------------------- W H I T E L I S T I N G ---------------------------#
#-------------------------------------------------------------------------------#
# Remove Headers & Comments
sed '/#/d' -i $whitelist
# Remove Blank/Empty Lines
sed '/^$/d' -i $whitelist
# Removes Whitespace
cat $whitelist | tr -d '\r' >> $temp
# Sort, Remove Duplicate and Write
sed -i 's/ *$//' $temp && sort $temp |uniq |tee > $whitelist
# Clear Cache
rm -f $temp

#-------------------------------------------------------------------------------#
#-------------------------------- S O U R C E S --------------------------------#
#-------------------------------------------------------------------------------#
{ wget -qO- https://raw.githubusercontent.com/Yhonay/antipopads/master/hosts; \
} > $file
{ cat $blocklist; \
} >> $file

#-------------------------------------------------------------------------------#
#--------------------------- P R O C E S S  P A C K ----------------------------#
#-------------------------------------------------------------------------------#
# Remove 0.0.0.0
sed 's/0.0.0.0 //' -i $file
# Remove Headers & Comments
sed '/#/d' -i $file
# Remove Unwanted Craps
sed '/\//d;/:/d;/(/d;/|/d;/\[/d;/\]/d' -i $file
# Remove Blank/Empty Lines
sed '/^$/d' -i $file
# Removes Whitespace
cat $file | tr -d '\r' >> $temp
# Sort, Remove Duplicate and Write
sed -i 's/ *$//' $temp && sort $temp |uniq |tee > $file
# Clear Cache
rm -f $temp
# Remove Whitelisted Domains
comm -23 $file $whitelist > $temp
mv -f $temp $file
# Remove Blank/Empty Lines
sed '/^$/d' -i $file
# Build Diff Formats
awk '$0="0.0.0.0 "$0' $file > $hosts
awk '$0=":: "$0' $file > $hostsV6
awk '$0=$0' $file > $domains
awk '$0="||"$0"^"' $file > $filter

#-------------------------------------------------------------------------------#
#--------------------------------- E C H O S -----------------------------------#
#-------------------------------------------------------------------------------#
# Read Total Domain Number
totaldomains=$(awk '!/^#/ && !/^$/{c++}END{print c}' $file | awk '{ len=length($0); res=""; for (i=0;i<=len;i++) { res=substr($0,len-i+1,1) res; if (i > 0 && i < len && i % 3 == 0) { res = "," res } }; print res }')
# Echo Pack, Domains and Size
echo -e $LB"!              _   _                             _     _   "$N
echo -e $LB"!   __ _ _ __ | |_(_)_ __   ___  _ __   __ _  __| |___| |  "$N
echo -e $LB"!  / _  |  _ \| __| |  _ \ / _ \|  _ \ / _  |/ _  / __| |  "$N
echo -e $LB"! | (_| | | | | |_| | |_) | (_) | |_) | (_| | (_| \__ \_|  "$N
echo -e $LB"!  \__,_|_| |_|\__|_| .__/ \___/| .__/ \__,_|\__,_|___(_)  "$N
echo -e $LB"!                   |_|         |_|                        "$N
echo -e $LB"!                                                           "$N
echo -e $LB"!      R        E        B        O        R        N       "$N
echo -e $LB"! $dividerTiny"$N
echo -e $LB"! B U I L D I N G  P A C K S"$N
echo -e $LB"! $dividerTiny"$N
echo -e $LB"! Domains: "$N$W"$totaldomains"$N
echo -e $LB"! Version: "$N$W"$buildVersion"$N
echo -e $LB"! $dividerTiny"$N

#-------------------------------------------------------------------------------#
#-------------------------- B U I L D  F O R M A T S ---------------------------#
#-------------------------------------------------------------------------------#
# Clear Cache
rm -f $temp $atemp
echo -e $LB"! Building "$N$Y"hosts"$N$G" Format"$N
# Hosts Header
echo -e "$headerLogo
# Format: hosts
# Version: $buildVersion
# Release: $releaseVersion
# Entries: $totaldomains
# Updated: $updateDate
# RAW: $raw/hosts
# $dividerTiny
#
# $dividerTiny
# A N T I P O P A D S  B E G I N S
# $dividerTiny" >> $temp
# Build Hosts
cat $temp $hosts $footer > $atemp
mv -f $atemp $hosts
#-------------------------------------------------------------------------------#
# Clear Cache
rm -f $temp $atemp
echo -e $LB"! Building "$N$Y"hosts ipv6"$N$G" Format"$N
# Hosts IPV6 Header
echo -e "$headerLogo
# Format: hosts
# Version: $buildVersion
# Release: $releaseVersion
# Entries: $totaldomains
# Updated: $updateDate
# RAW: $raw/hosts
# $dividerTiny
# A N T I P O P A D S  B E G I N S
# $dividerTiny" >> $temp
# Build Hosts
cat $temp $hostsV6 $footer > $atemp
mv -f $atemp $hostsV6
#-------------------------------------------------------------------------------#
# Clear Cache
rm -f $temp $atemp
echo -e $LB"! Building "$N$Y"domain list"$N$G" Format"$N
# Domain List Header
echo -e "$headerLogo
# Format: domains
# Version: $buildVersion
# Release: $releaseVersion
# Entries: $totaldomains
# Updated: $updateDate
# RAW: $raw/hosts
# $dividerTiny
#
# $dividerTiny
# A N T I P O P A D S  B E G I N S
# $dividerTiny" >> $temp
# Build Domain List
cat $temp $domains $footer > $atemp
mv -f $atemp $domains
#-------------------------------------------------------------------------------#
# Clear Cache
rm -f $temp $atemp
echo -e $LB"! Building "$N$Y"adblock filter"$N$G" Format"$N
# Adblock Filter Header
echo -e "$headerLogoAB
! Format: domains
! Version: $buildVersion
! Release: $releaseVersion
! Expires: $expiry
! Entries: $totaldomains
! Updated: $updateDate
! RAW: $raw/filter
! $dividerTiny
!
! $dividerTiny
! A N T I P O P A D S  B E G I N S
! $dividerTiny" >> $temp
# Build Filter
cat $temp $filter $footerAB > $atemp
mv -f $atemp $filter
#-------------------------------------------------------------------------------#

# Complete
echo -e $LB"! $dividerTiny"$N
echo -e $LB"! DONE BUILDING PACK & FORMATS."$N
echo -e $LB"! $dividerTiny"$N

# Remove Stales
rm -f "$temp" "$atemp" "$file" "$footer" "$footerAB"

#-------------------------------------------------------------------------------#
#---------------------------------- D O N E  -----------------------------------#
#-------------------------------------------------------------------------------#
