##
# functions to process FASTX files
# jrm
# convert a multiline fasta file to a single line
# 


#print("pyctions | Python functions")

def executionTime(execTime):
	"""
    Calculate execution time in hrs, min or s
    """
	if execTime > 3600:
		output="---\n\tExecution time: " + str(round(execTime/3600),3) + " hrs"
	elif execTime >= 60:
		output="---\n\tExecution time: " + str(round(execTime/60),3) + " min"
	else:
		output="---\n\tExecution time: " + str(round(execTime,3)) + " s"
	return output


def fastx2dict(inputFASTX):
    """
    Read a FASTX file into a dictionary where the keys are the ID's and the sequences are the values
    Note: Uses only the unique identifier of each sequence, rather than the 
    entire header, for dict keys. 
    """
    fastxDict = {} #start empty dictionary
    geneID = '' # Start with an empty ID
    sequence = [] # Where the sequence will be stored;If multifastX, the whole sequence will be concatenated.
    for line in open(inputFASTX):
        if line.startswith(">") and geneID == '':
            geneID = line.split(' ')[0].strip().replace('>','')
        elif line.startswith(">") and geneID != '':
            fastxDict[geneID] = ''.join(sequence)
            geneID = line.split(' ')[0].strip().replace('>','')
            sequence = []
        else:
            sequence.append(line.rstrip())
    fastxDict[geneID] = ''.join(sequence)
    return fastxDict


def makeList(inputLOI):
	"""
    Read a single-column file with ID genes and convert to a python list
    """
	tmpList = []
	for line in open(inputLOI):
    		tmpList.append(line.strip())
    ##
	return tmpList
