import re
import pexpect

def strsplit (string,char=' '):
	try:
		string = str(string)
	except ValueError:
		string = string
	return string.split(char)
	
def install_teamwork (lic_dir,tw_dir):
	install = pexpect.spawn ('%s/teamwork_server -key:%s' % tw_dir lic_dir)
	install.expect ('.\'I agree\':')
	install.sendline ('I agree')
	install.expect ('Apply the key? (y/n)')
	install.sendline('y')