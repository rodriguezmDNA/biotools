##
# functions to process FASTX files
# jrm | 201908
# github: rodriguezmDNA
# twitter: @rodriguezmDNA
# convert a multiline fasta file to a single line

import datetime
import time
import os
import argparse
# custom
import pyctions

startTime = time.time()

#### Arguments
parser = argparse.ArgumentParser()

parser.add_argument("-l", "--loi", required=True,
					help="List Of Interest: a list with ID's of interest (no header)")

parser.add_argument("-f", "--fastx", required=True,
					help="a FASTX file")

parser.add_argument("-v", "--verbose", 
					help="increase output verbosity",
                    action="store_true")

parser.add_argument("-o", "--output", 
					help="output name. If ommited resulting file is {FASTXfile_filtered_LOIfile.fa}")

parser.add_argument("-p", "--path", 
					help="by default the file is saved to the path of the LoI file. This flag saves it to the current location",
                    action="store_true")

parser.add_argument("-e", "--exact", 
					help="turnes on 'exact' matches between list ID and FASTX",
					action="store_true")

# parser.add_argument("-c", "--choice", type=int, choices=[0, 1, 2],
#                     help="increase output verbosity")

args = parser.parse_args()


######## Execution time
start = time.time()
#### Print time stamp to 

if args.verbose:
	print ("\nStart at", datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") + "/n")


#### Get from arguments
inputLOI = args.loi
inputFASTX = args.fastx


### Names for output files
###############
## If output is provided use as suffix for file
if args.output:
	suffix=args.output
else:
	loiName, loiEXT = os.path.splitext(inputLOI)
	suffix=os.path.basename(inputLOI).replace(loiEXT,'')

# get the basename of the fastx
fxName, fxEXT = os.path.splitext(inputFASTX)
prefix=os.path.basename(inputFASTX).replace(fxEXT,'')
	

pathOut="./"+os.path.split(inputLOI)[0] # Get path of FASTX file
outName=prefix+"_filtered_"+suffix+".fa"
outFile=pathOut + "/" + outName #Final 
if args.verbose:
    print ("\tOutput saved to: " + pathOut + "/")
    print ("\tas: " + outName + "\n")
    #print(outFile) #for debugging

############################################################

## Convert genes of interest to a list
if args.verbose:
    print ("Reading list with IDs of interest from: " + inputLOI + "\n")
GoI=pyctions.makeList(inputLOI)


## convert FASTX to dictionary
if args.verbose:
    print ("Reading FASTX file from: " + inputFASTX + "\n")
multilineFASTX=pyctions.fastx2dict(inputFASTX)
#multilineFASTX.keys()


## filter FASTX by IDs in the list
if args.verbose:
    print ("filtering FASTX by IDs in the list" + "\n")

uniqueGOI = list(set([gene.split(".")[0] for gene in GoI]))
if args.exact:
	uniqueGOI = list(set(GoI))
else:
	uniqueGOI = list(set([gene.split(".")[0] for gene in GoI]))


if args.exact:
	if args.verbose:
		print ("exact matches" + "\n")
	getMatchingKeys = [key for key in list(multilineFASTX.keys()) for gene in uniqueGOI if key==gene]
else:
	if args.verbose:
		print ("partial matches" + "\n")
	getMatchingKeys = [key for key in list(multilineFASTX.keys()) for gene in uniqueGOI if key.split(".")[0] in gene]


filteredFASTA=[">"+key+"\n"+multilineFASTX[key] for key in getMatchingKeys]
#filteredFASTA
# print(getMatchingKeys)
# print(filteredFASTA)


### Save to file

if args.path:
	if args.verbose:
		print("Saving to " + os.getcwd() )
	# Save to current path
	with open(outName, 'w') as filehandle:
		filehandle.writelines("%s\n" % each for each in filteredFASTA)
else:
	if args.verbose:
		print ("Saved to file" + outFile + "\n")
		# Save to path of FASTX
	with open(outFile, 'w') as filehandle:
		filehandle.writelines("%s\n" % each for each in filteredFASTA)



if args.verbose:
	print ("Start at", datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") + "/n")


endTime = time.time()
execTime=endTime - startTime
print(pyctions.executionTime(execTime))



##################################################################
############################################
## Example from https://docs.python.org/2/howto/argparse.html
# import argparse
# parser = argparse.ArgumentParser()
# parser.add_argument("square", 
# 					type=int,
# 					help="display a square of a given number")

# parser.add_argument("-v", "--verbose", 
# 					help="increase output verbosity",
#                     action="store_true")

# parser.add_argument("-c", "--choice", type=int, choices=[0, 1, 2],
#                     help="increase output verbosity")

# ## Reads argument
# args = parser.parse_args()

# answer = args.square**2

# if args.verbose:
#     print ("the square of {} equals {}".format(args.square, answer))
# else:
#     print (answer)


# if args.choice:
# 	if args.choice == 2:
# 	    print ("the choice is two")
# 	elif args.choice == 1:
# 	    print ("the choice is one")
# 	else:
# 	    print ("the choice is zero")
############################################
##################################################################