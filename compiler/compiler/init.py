import syntax
import re

def initializeValue(expressionString, code):
        variable = syntax.identifier(False).findall(expressionString)[0];        
        value = re.findall("(?<=)\s*\d+", expressionString)

        if(len(value) == 0):
                value = 0;
        else:
                value = value[0]
        if not variable in code.dataMem:
                code.dataMem[variable] = value;

def needsInitialization(expressionString):
        if not syntax.identifier(True).match(expressionString):
                return False;

        if not re.search("=", expressionString):
                return True;

        if re.search("=\s*\d+", expressionString):                
                return True;
        
        else:
                return False;
                
