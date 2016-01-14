import re
import syntax
import binoperations
import sys
import parser
import sys, getopt

nextTemp = 0;

def main(argv):
        
        inputFileName = "input.ir"
        outputFileName = "assembly.sl"
        verbose = False;

        #Command line arguments
        try:
                opts, args = getopt.getopt(argv, "i:o:v",["inputFile=", "outputFile="])
        except getopt.GetoptError:
                print "Invalid arguments";
                sys.exit(2);

        for opt, arg in opts:
                if opt in ("-i", "--infile"):
                        inputFileName = arg;

                elif opt in ("-o", "--outfile"):
                        outputFileName = arg;

                elif opt == "-v":
                        verbose = True;



        inputfile = open(inputFileName, "r");
        inputstring = inputfile.read();
        inputfile.close();

        code = Code();

        lines = re.findall("^[^;^\n]+", inputstring, re.M);

        #TODO: syntax checking here!

        for expression in lines:
                if len(re.findall("=",expression)) == 1:
                        handleAssignment(expression, code);

                        
        outputfile = open(outputFileName, "w");
        outputfile.write(formatProgramMemOutput(code.programMem));
        outputfile.write("\n\n");
        outputfile.write(formatDataMemOutput(code.dataMem));

        if verbose:
                print formatProgramMemOutput(code.programMem);
                print formatDataMemOutput(code.dataMem);
        

class Code:
        def __init__(self):
                self.dataMem = {};
                self.programMem = [];
                self.nextTemp = 0;

        def getNextTemp(self):
                temp = self.nextTemp;
                self.nextTemp += 1;
                return temp;

def formatDataMemOutput(memoryStack):
        #creates the initial data memory string
        #input: dictionary containing the variable names and initial values

        dataString = "DATA_MEM:\n";

        for key in memoryStack:
                dataString += str(key) + ": #" + str(memoryStack[key]).strip() + "\n";

        return dataString;

def formatProgramMemOutput(programMemArr):
        
        programString = "PROGRAM_MEM:\n";

        for i,instruction in enumerate(programMemArr):
                programString += instruction;
                

        return programString;

def handleAssignment(expressionString, code):
        supportedOperations = parser.supportedExpressions;

        for expression in supportedOperations:
                if expression.test(expressionString):
                        expression.operation(expressionString,code);
        
        
                








def getNextTemp():
        global nextTemp;
        temp = "%" + str(nextTemp);        
        nextTemp += 1;
        return temp;

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



        
        

if __name__ == '__main__':
        main(sys.argv[1:]);
