#!/bin/bash
# j rodriguez medina
# github: rodriguezmDNA
# twitter: @rodriguezmDNA
####################################
## Multi-line FASTA to single lined 
# Remove break lines on a FASTA file
# Created 2019.02.26
# Last modified 2019.02.26


orCall=$0$@
## Functions
#################
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -h            this helpful help"
    echo "   -i            Input (multilined) FASTA file (.fa|.fasta extension)"
    echo "   -f            If selected, will check the whole FASTA file; default checks a subset"
    echo
    
    echo -e "\n Don't panic!"
    # echo some stuff here for the -a or --add-options 
    exit 1
}

useFull=0;

while getopts ':h i: :f' option; do
  case "$option" in
    h) display_help
       exit
       ;;
    i) inputFASTA=$OPTARG     ;;
    f) useFull=1    ;;
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



### Function to get the line number of the file
function getMaxV(){
    maxV=`grep ">" $inputFASTA  | wc -l | awk -F " " '{print $1 }'`
    return $maxV
}

### Function to check if multifasta
function checkMultiline(){
    awk -v useFull=$useFull -v maxV=$maxV '
        BEGIN {  
                minV=1;
                counter=0; #Used to count the number of uneven lines that are not FASTA identifier (start with >)   
                    
                ## Unless specificed, use a portion of the whole dataset.
                if (useFull) {N= int(maxV);} else { N=int(maxV/4/2);} 
                ## The next block will generate a list of random numbers without replacement.
                for (i = 1; i <= N; i++) {\
                        v=int(minV+rand()*(maxV-minV+1)); #Generate a random number between min and max #If already on the list, go back and retry, else, add to list.
                        if(v in ranVar) i-- ; else { ranVar[v]++ }} 
                        }
        # Loop over the text
                # If the row index is on the list to be sampled and it is a
              {
                if (NR in ranVar && NR%2!=0  && $0 !~ />/) {counter+=1} #{print NR, $0; counter+=1} 
              }
        END { print counter}' $inputFASTA  
  
}


getMaxV


if [ `checkMultiline` -ne 0 ]
  then
    echo $inputFASTA "is multifasta";
    #gsed '/>/ !{ :Flow N; />/ !{ s/\n// ;} ; tFlow ; P ; D ;}' $inputFASTA | wc -l 
  else  
    echo $inputFASTA "is single-lined FASTA";
fi


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
echo -e "\n Call mode: $orCall"  #2>&1 | tee -a $logPath
echo -e "\nDone `date` \n-----------"  #2>&1 | tee -a $logPath
##Done