import syntax
import re




#Compiler operations
        #given the target and operands, output a list of subleq instructions
#def binOperation(target, operands):
                

def add(expressionString, code):

        target, a, b = syntax.parseExpression(expressionString);

        if not target in code.dataMem:
                code.dataMem[target] = 0;

        if not syntax.identifier(True).match(a): #a is a literal
                temp = code.getNextTemp();                
                code.dataMem[temp] = a;
                a = temp;

        if not syntax.identifier(True).match(b):
                temp = code.getNextTemp();
                code.dataMem[temp] = b;
                b = temp;
                        

        t1 = "t1"

        instructions = [
                "//" + expressionString + "\n",
                str(target) + " " + str(target) + " NEXT\n",
                str(t1) + " " + str(t1) + " NEXT\n",
                str(a) + " " + str(t1) + " NEXT\n",
                str(b) + " " + str(t1) + " NEXT\n",
                str(t1) + " " + str(target) + " NEXT\n"];
        
        code.programMem += instructions; 

def sub(expressionString, code):
        target, a, b = syntax.parseExpression(expressionString);

        if not target in code.dataMem:
                code.dataMem[target] = 0;

        if not syntax.identifier(True).match(a): #a is a literal
                temp = code.getNextTemp();                
                code.dataMem[temp] = a;
                a = temp;

        if not syntax.identifier(True).match(b):
                temp = code.getNextTemp();
                code.dataMem[temp] = b;
                b = temp;
                        
        t1 = "t1"

        instructions = [
                "//" + expressionString + "\n",
                str(target) + " " + str(target) + " NEXT\n",
                str(t1) + " " + str(t1) + " NEXT\n",
                str(a) + " " + str(t1) + " NEXT\n",
                str(b) + " " + str(target) + " NEXT\n",
                str(t1) + " " + str(target) + " NEXT\n"];
        
        code.programMem += instructions; 
        
def mul(expressionString, code):
        target, a, b = syntax.parseExpression(expressionString);

        if not target in code.dataMem:
                code.dataMem[target] = 0;

        if not syntax.identifier(True).match(a): #a is a literal
                temp = code.getNextTemp();                
                code.dataMem[temp] = a;
                a = temp;

        if not syntax.identifier(True).match(b):
                temp = code.getNextTemp();
                code.dataMem[temp] = b;
                b = temp;

        code.dataMem["one"] = 1;

        instructions = [
        "//" + expressionString + "\n",
        "counter counter NEXT\n",
        "adder adder NEXT\n",
        "t1 t1 NEXT\n",
        "t2 t2 NEXT\n",
        str(a) + " t1 apos\n",
        "t1 adder NEXT\n",
        str(b) + " t2 bpos\n",
        "bneg: t2 counter NEXT\n",
        "t3 t3 continue\n",
        "bpos: " + str(a) + " adder NEXT\n",
        "t3 t3 continue\n",
        "apos: " + str(a) + " adder NEXT\n",
        "t1 t1 NEXT\n",
        str(b) + " t1 bpos\n",
        str(b) + " t2 NEXT\n",
        "t3 t3 bneg\n",
        "continue: one counter NEXT\n",
        "tempC tempC NEXT\n",
        "again: adder tempC NEXT\n",
        "one counter again\n",
        target + " " + target + " NEXT\n",
        "tempC " + target + " NEXT\n"];

        code.programMem += instructions;


def isAdd(expressionString) :
        if addRegex().match(expressionString):
                return True;
        else:
                return False;

def isSub(expressionString):
        if subRegex().match(expressionString):
                return True;
        else:
                return False;   

def isMul(expressionString):
        if mulRegex().match(expressionString):
                return True;
        else:
                return False;

def isUDiv(expressionString):
        if udivRegex().match(expressionString):
                return True;
        else:
                return False;

def isSDiv(expressionString):
        if sdivRegex().match(expressionString):
                return True;
        else:
                return False;

def isURem(expressionString):
        if uremRegex().match(expressionString):
                return True;
        else:
                return False;

def isSRem(expressionString):
        if sremRegex().match(expressionString):
                return True;
        else:
                return False;          

#Regexes
def target():
        variable = identifier(True).pattern;

        return re.compile(variable + "\s*(?==)");

def binOperation(name):
        variable = syntax.identifier(True).pattern;
        return "(" + variable + ")\s*=\s*" + name + "\s+i32\s+((" + variable + ")|(\d+))\s*,\s*((\d+)|(" + variable + "))";

def addRegex():
        return re.compile(binOperation("add"));

def subRegex():
        return re.compile(binOperation("sub"));

def mulRegex():
        return re.compile(binOperation("mul"));

def udivRegex():
        return re.compile(binOperation("udiv"));

def sdivRegex():
        return re.compile(binOperation("sdiv"));

def uremRegex():
        return re.compile(binOperation("urem"));

def sremRegex():
        return re.compile(binOperation("srem"));
