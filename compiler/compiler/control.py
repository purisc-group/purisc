import syntax
import re

def icmp(expressionString, code):
        condition = re.findall("(?<=icmp)\s+" + icmpConditionsRegex().pattern, expressionString)[0];

     #   print expressionString
      #  print "(?<=icmp)\s+" + icmpConditionsRegex().pattern;        
        
        operations = compareOperations();
        for operation in operations:
                if condition.strip() == operation:
                        operations[operation](expressionString, code);

def compareOperations():
        return {
                "eq" : equal,
                "ne" : notEqual,
                "sgt" : signedGreater,
                "sge" : signedGreaterEq,
                "slt" : signedLess,
                "sle" : signedLessEq};

def equal(expressionString, code):
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

        code.dataMem["negOne"] = -1;

        instructions = [
                "//" + expressionString + "\n",
                str(target) + " " + str(target) + " NEXT\n",
                "t0 t0 NEXT\n",
                str(a) + " t0 NEXT\n",
                "t0 " + target + " NEXT\n",        
                str(b) + " " + str(target) + " possiblyEq\n",
                str(target) + " " + str(target) + " done\n",
                "possiblyEq: " + "t1 t1 NEXT\n",
                str(target) + " t1 eq\n",
                str(target) + " " + str(target) + " done\n",
                "eq: t1 " + target + " NEXT\n",
                "done: t0 t0 NEXT\n"
                ];

        code.programMem += instructions;

def notEqual(expressionString, code):
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

        instructions = [
                "//" + expressionString + "\n",
                str(target) + " " + str(target) + " NEXT\n",
                "t0 t0 NEXT\n",
                str(a) + " t0 NEXT\n",
                "t0 " + str(target) + " NEXT\n",        
                str(b) + " " + str(target) + " NEXT\n"
                ];

        code.programMem += instructions;

def signedGreater(expressionString, code):
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

        instructions = [
                "//" + expressionString + "\n",
                str(target) + " " + str(target) + " NEXT\n",
                "t0 t0 NEXT\n",
                str(a) + " t0 NEXT\n",
                "t0 " + str(target) + " NEXT\n",
                str(b) + " " + str(target) + " less\n",
                "t1 t1 done\n",
                "less: " + str(target) + " "  + str(target) + " NEXT\n"        
                "done: t3 t3 NEXT\n"
                ];

        code.programMem += instructions;

def notEqual(expressionString, code):
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

        instructions = [
                "//" + expressionString + "\n",
                str(target) + " " + str(target) + " NEXT\n",
                "t0 t0 NEXT\n",
                str(a) + " t0 NEXT\n",
                "t0 " + str(target) + " NEXT\n",        
                str(b) + " " + str(target) + " NEXT\n"
                ];

        code.programMem += instructions;

def signedGreaterEq(expressionString, code):
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

        if not "negOne" in code.dataMem:
                code.dataMem["negOne"] = -1;

        instructions = [
                "//" + expressionString + "\n",
                str(target) + " " + str(target) + " NEXT\n",
                "negOne " + str(target) + " NEXT\n",
                "t0 t0 NEXT\n",
                str(a) + " t0 NEXT\n",
                "t0 " + str(target) + " NEXT\n",
                str(b) + " " + str(target) + " less\n",
                "t1 t1 done\n",
                "less: " + str(target) + " "  + str(target) + " NEXT\n"        
                "done: t3 t3 NEXT\n"
                ];

        code.programMem += instructions;

def signedLess(expressionString, code):
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

        instructions = [
                "//" + expressionString + "\n",
                str(target) + " " + str(target) + " NEXT\n",
                "t0 t0 NEXT\n",
                str(b) + " t0 NEXT\n",
                "t0 " + str(target) + " NEXT\n",
                str(a) + " " + str(target) + " less\n",
                "t1 t1 done\n",
                "less: " + str(target) + " "  + str(target) + " NEXT\n"        
                "done: t3 t3 NEXT\n"
                ];

        code.programMem += instructions;

def signedLessEq(expressionString, code):
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

        if not "negOne" in code.dataMem:
                code.dataMem["negOne"] = -1;

        instructions = [
                "//" + expressionString + "\n",
                str(target) + " " + str(target) + " NEXT\n",
                "negOne " + str(target) + " NEXT\n",
                "t0 t0 NEXT\n",
                str(b) + " t0 NEXT\n",
                "t0 " + str(target) + " NEXT\n",
                str(a) + " " + str(target) + " less\n",
                "t1 t1 done\n",
                "less: " + str(target) + " "  + str(target) + " NEXT\n"        
                "done: t3 t3 NEXT\n"
                ];

        code.programMem += instructions;

def isIcmp(expressionString):
        if icmpRegex().match(expressionString):
                return True;
        else:
                return False;

def icmpConditionsRegex():
        return re.compile("eq|ne|ugt|uge|ult|ule|sgt|sge|slt|sle");

def icmpRegex():
        variables = syntax.identifier(True).pattern;
        argument = syntax.argument(True).pattern;
        pattern = "\s*(" + variables + ")\s*=\s*icmp\s+(" + icmpConditionsRegex().pattern + ")\s+i32\s+(" + argument + ")\s*,\s*(" + argument + ")";

        return re.compile(pattern);
