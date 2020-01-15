#!/bin/bash
# j rodriguez medina
# github: rodriguezmDNA
# twitter: @rodriguezmDNA
####################################
## Multi-line FASTA to single lined 
# Remove break lines on a FASTA file
# Created 2019.02.26
# Last modified 2019.02.26


orCall=$@
## Functions
#################
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -h            this helpful help"
    echo "   -i            Input (multilined) FASTA file (.fa|.fasta extension)"
    echo "   -o            [optional] name of output single-lined FASTA"
    echo
    echo " if -o is not submitted, the program generates a new file with extension _SL.fa"
    echo -e "\n Don't panic!"
    # echo some stuff here for the -a or --add-options 
    exit 1
}

# If no argument send help
if [ $# -eq 0 ]
  then
    display_help
fi


while getopts ':h i: o:' option; do
  case "$option" in
    h) display_help
       exit
       ;;
    i) inputFASTA=$OPTARG     ;;
    o) outputFASTA=$OPTARG    ;;
    :) printf "missing value for -%s\n" "$OPTARG" >&2
       display_help
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       display_help
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

## Check that the parameters aren't empty.
if [[  -z  $inputFASTA ]] ; then
	echo -e "\nNeed a FASTA file\n" >&2
	display_help
fi


if [[  -z  $outputFASTA ]] ; then
  
  outputFASTA="${inputFASTA%.fa*}_sl.fa"
  echo "No output given, saving file as $outputFASTA"
fi


echo `gsed ' />/ !{ :Flow N; />/ !{ s/\n// ;} ; tFlow ; P ; D ;} ' $inputFASTA > $outputFASTA`



################################################################################################
####################################


## Record time
start_time=`date +%s`

# ## Get absolute path
# #Get the full path of the current script: Go back one folder (from scripts to main)
# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

# ## Keep track of errors and outputs in a log.
# logDir=$DIR/logs #Create log folder if it doesn't exist
# if [ ! -d $logDir ]; then echo `mkdir -p $logDir`; fi

# # A file for logs
# logPath=$DIR/logs/$(basename $BASH_SOURCE .sh).log #Keeps the name of the script, use .log instead of scripts extension
# ##

# echo `touch $logPath` #Create file to fill with log data
# ##
# echo -e "-----------\nStarted on `date`" 2>&1 | tee $logPath #Start filling 
# ######




########################################################################################################################
########################################################################################################################

## Record time
end_time=`date +%s`

#echo -e "\nParameters used: $bwtParams"  2>&1 | tee -a $logPath
echo -e "\n execution time was `expr $end_time - $start_time` s."  #2>&1 | tee -a $logPath
echo -e "\n Call mode: $0 $orCall"  #2>&1 | tee -a $logPath
echo -e "\nDone `date` \n-----------"  #2>&1 | tee -a $logPath
##Done