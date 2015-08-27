import re
import pexpect

def strsplit (string,char=' '):
	try:
		string = str(string)
	except ValueError:
		string = string
	return string.split(char)
	
def install_teamwork (lic_dir,tw_dir):
	inst = pexpect.spawn('%s/bin/teamwork_server -key:%s' % (tw_dir, lic_dir))
	inst.expect('.\'I agree\':')
	inst.sendline('I agree')
	inst.expect('Apply the key? (y/n)')
	inst.sendline('y')