import binoperations
import re
import syntax
import init
import control

class Expression:
        def __init__(self,foundTest,operation):
                self.test = foundTest;
                self.operation = operation;

        

supportedExpressions = [
        Expression(init.needsInitialization, init.initializeValue),
        Expression(binoperations.isAdd, binoperations.add),
        Expression(binoperations.isSub, binoperations.sub),
        Expression(binoperations.isMul, binoperations.mul),
        Expression(control.isIcmp, control.icmp)
]

