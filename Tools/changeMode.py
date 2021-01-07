#coding=utf-8
import os
import sys
import re

csPath = sys.argv[1]
playerMode = sys.argv[2]
wrapPath = sys.argv[3]
wrapMode = sys.argv[4]

# print("00000000000000000000");

# file2
playerReClass = re.compile("public const int PlayerMode\\s=\\s[\\d]+", re.IGNORECASE & ~re.DOTALL);
textFile = open(csPath,'r')
text = textFile.read()
textFile.close()

matchs = playerReClass.findall(text);
result = matchs[0];

text = text.replace(result,'public const int PlayerMode = '+str(playerMode))

textFile = open(csPath,'w')
textFile.write(text)
textFile.close()



# file3
wrapReClass = re.compile('L.RegConstant\("PlayerMode",\\s[\\d]+', re.IGNORECASE & ~re.DOTALL);

textFile = open(wrapPath,'r')
text = textFile.read()
textFile.close()

matchs = wrapReClass.findall(text);
result = matchs[0];

text = text.replace(result,'L.RegConstant("PlayerMode", '+str(wrapMode))

textFile = open(wrapPath,'w')
textFile.write(text)
textFile.close()