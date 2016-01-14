import random
import re
import sys, getopt

#Usage:
#       python regex.py [-i inputfile] [-o outputfile] [-d dataMemoryOffset]
#               [-p programMemoryOffset] [-v]

def main(argv):

        dataMemOffset = 1000;
        programMemOffset = 0;
        outputFileName = "output.machine";
        inputFileName = "input.slq";
        verbose = False;


#Command line arguments
        try:
                opts, args = getopt.getopt(argv, "i:o:d:p:v",["inputFile=", "outputFile="])
        except getopt.GetoptError:
                print "Invalid arguments";
                sys.exit(2);

        for opt, arg in opts:
                if opt in ("-i", "--infile"):
                        inputFileName = arg;

                elif opt in ("-o", "--outfile"):
                        outputFileName = arg;

                elif opt in ("-d", "--dataOffset"):
                        dataMemOffset = arg;

                elif opt in ("-p", "--programOffset"):
                        programMemOffset = arg;

                elif opt == "-v":
                        verbose = True;

        inputFile = open(inputFileName,"r");
        inputText = inputFile.read();
        inputFile.close();
    

#parse program and data memory
        memoryArray = parseInput(inputText);
        programMemString = memoryArray[0];
        dataMemString = memoryArray[1];

#create initial program memory
        programMem = re.findall("\S+:\s*#?\S+|#?\S+|NEXT", programMemString); 

        if len(programMem) > dataMemOffset:
                print "Warning:\n Initial data memory location collides with program memory, setting initial data memory to: " + len(programMem)
                dataMemOffset = len(programMem);

#create initial data memory        
        nextDataMem = dataMemOffset;
        rawDataStrings = re.findall("\S+:\s*#\d*", dataMemString);
        dataMem = {};

        for raw in rawDataStrings:
                variableName = re.findall("\S*(?=:)", raw)[0];
                value = re.findall("(?<=#)\d*", raw)[0];
                dataMem[variableName] = [nextDataMem, value];
                nextDataMem += 1;

#resolve labels in program memory
        for i,val in enumerate(programMem):

                if re.match("\S+:", val):
                        label = re.findall("\S+(?=:)", val)[0];
                        programMem[i] = re.findall("(?<=:)\s*\S+", val)[0];
                        programMem[i] = re.sub("\s*","",programMem[i]);

                        for j,value in enumerate(programMem):
                                if value == label:
                                        programMem[j] = "#"+ str(i + programMemOffset);

        
#resolve NEXT keyword
        for i,val in enumerate(programMem):
                
                if val == "NEXT":
                        programMem[i] = "#" + str(i+1);


#resolve variables into addresses
        for i,val in enumerate(programMem):

                if val in dataMem:
                        programMem[i] = "#" + str(dataMem[val][0]);

                elif re.match("#",val):
                        continue;

                else:
                        dataMem[val] = [nextDataMem, "0"]; #initialize data to 0
                        programMem[i] = "#" + str(nextDataMem);                        
                        nextDataMem += 1;

#output results
        outputFile = open(outputFileName, "w");
        outputString = ""        

        for index, val in enumerate(programMem):
                outputFile.write(str(val));
                outputString += str(val);
                if (index + 1) % 3 == 0:
                        outputFile.write("\n");
                        outputString += "\n";
                else:
                        outputFile.write(" ");
                        outputString += " ";          

        outputFile.write("\n");
        outputString += "\n";
        
        for key in dataMem:
                address = dataMem[key][0];
                value = dataMem[key][1];

                outputFile.write("#" + str(address) + " " + "#" + str(value));
                outputString += "#" + str(address) + " " + "#" + str(value);

                outputFile.write("\n");
                outputString += "\n";

        outputFile.close();
        
        if verbose:
                print outputString;



def randomInsult():
        insults = [
                "you cunt",
                "you dick",
                "motherfucker",
                "father fister",
                "you eater of broken meat",
                "twat",
                "it's no wonder your parents don't love you",
                "you worthless piece of shit",
                "you failure",
                "idiot",
                "eat shit and die"]

        return insults[random.randrange(0,9)];

def parseInput(inputText):
#Pass the raw code from the input
#Return an array containing the program memory and data memory strings
#The program memory comes first

        #Order of program memory and data memory doesn't matter
        programMem = re.findall("(?<=PROGRAM_MEM:).*(?=DATA_MEM:)", inputText, re.DOTALL);
        if len(programMem) == 0:
                programMem = re.findall("(?<=PROGRAM_MEM:).*", inputText, re.DOTALL);
        programMem = programMem[0];

        dataMem = re.findall("(?<=DATA_MEM:).*(?=PROGRAM_MEM:)", inputText, re.DOTALL);
        if len(dataMem) == 0:
                dataMem = re.findall("(?<=DATA_MEM:).*", inputText, re.DOTALL);
        dataMem = dataMem[0];


        programMem = filterComments(programMem);
        dataMem = filterComments(dataMem);

        return [programMem, dataMem];



def filterComments(string):
        multiLinePattern = re.compile("\\/\\*.*\\*\\/", re.DOTALL);
        singleLinePattern = re.compile("\\/\\/.*");

        string = multiLinePattern.sub("", string, re.DOTALL);
        string = singleLinePattern.sub("", string);

        return string;

if __name__ == '__main__':
    main(sys.argv[1:])
