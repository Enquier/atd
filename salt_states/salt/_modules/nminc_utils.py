import re
import pexpect

def strsplit (string,char=' '):
	try:
		string = str(string)
	except ValueError:
		string = string
	return string.split(char)