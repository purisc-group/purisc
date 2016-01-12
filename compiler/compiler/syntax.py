import re

#named variables
#set scope to true if you want to include the % or @ in front of the name
def nidentifier(scope):
        patternString = "[a-zA-Z$._][a-zA-Z$._0-9]*";
        if scope:
                patternString = "[%@]" + patternString;
        else:
                patternString = "(?<=[%@])" + patternString;

        return re.compile(patternString);

#unnamed temp variable
def uidentifier(scope):
        patternString = "\d+";
        if scope:
                patternString = "[%@]" + patternString;
        else:
                patternString = "(?<=[%@])" + patternString;

        return re.compile(patternString);

#either name or unnamed temp variable
def identifier(scope):
        return re.compile("" + nidentifier(scope).pattern + "|" + uidentifier(scope).pattern  + "");

def argument(scope):
        return re.compile(nidentifier(scope).pattern + "|" + uidentifier(scope).pattern + "|\d+");


def comment():
        return re.compile(";[^\n]*\n");

def operand1():
        return re.compile("(\d+|" + identifier(True).pattern + ")\s*(?=,)");

def operand2():
        return re.compile("(?<=,)\s*(\d+|" + identifier(True).pattern + ")");

def parseExpression(expressionString):
#Assume expression string looks like:
# <target> = keywords operand1, operand2
        target = identifier(False).findall(expressionString)[0];

        operandOne = operand1().findall(expressionString)[0];
        operandTwo = operand2().findall(expressionString)[0];

        return [target, operandOne, operandTwo];
