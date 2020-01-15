#!/bin/bash
# j rodriguez medina
# github: rodriguezmDNA
# twitter: @rodriguezmDNA
## Wrapper to call other programs
# Created 2019.02.26
# Last modified 2019.02.26

mainDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
## Functions
#################
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   --checkMulti          (bash) Calls a program to check if a file is multi-lined fasta"
    echo "   --multi2single        (bash) Calls a program to remove line breaks from a multi-lined fasta"
    echo "   --filterFASTA         (python) Filter FASTA file based on a list of genes of interest"
    echo "   -v                    verbose"
    echo "   -h, --help            this helpful help"
    echo
    # echo some stuff here for the -a or --add-options 
    exit 1
}

# If no argument send help
if [ $# -eq 0 ]
  then
    display_help
fi


while getopts ':h -: io:' option; do
  case "$option" in
    h) display_help
       exit
       ;;

    -)
      case ${OPTARG} in
          "multi2single"*) 
                           shift #Moves over to the next parameters
                           $mainDIR/multi2single_FASTA.sh $@ #Calls the bash script with the rest of the arguments
                           ;;
          "checkMulti"*) 
                           shift #Moves over to the next parameters
                           $mainDIR/checkMulti.sh $@ #Calls the bash script with the rest of the arguments
                           ;; 
          "filterFASTA"*) 
                           shift
                           python $mainDIR/filter_fastx.py $@ #Calls the bash script with the rest of the arguments
                           ;;
          "help"*) display_help
                           ;;
      esac
    ;;
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


# ################################################################################################
# ####################################


# ## Record time
# start_time=`date +%s`
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



# ############ Here be functions
# #############################################
# #Functions help keep code minimal, avoid repeating lines, and just doing the same with diff values. 

# #songOftheLonelyFunction () {
#   #Write functions like this;
#   #Do something with a $variable
#   #}

# #songOftheLonelyFunction variable1 #Call functions like this
# #songOftheLonelyFunction variable2 

# ############ Code here 
# #############################################







# ########################################################################################################################
# ########################################################################################################################

# ## Record time
# end_time=`date +%s`

# #echo -e "\nParameters used: $bwtParams"  2>&1 | tee -a $logPath
# echo -e "\n execution time was `expr $end_time - $start_time` s."  2>&1 | tee -a $logPath
# echo -e "\nDone `date` \n-----------"  2>&1 | tee -a $logPath
# ##Done