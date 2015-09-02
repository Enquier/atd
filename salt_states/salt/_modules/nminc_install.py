import pexpect

def teamwork (lic_dir,tw_dir):
	inst = pexpect.spawn('%s/bin/teamwork_server -key:%s' % (tw_dir, lic_dir))
	inst.expect('.\'I agree\':')
	inst.sendline('I agree')
	inst.expect('.Apply the key\? \(y/n\)')
	inst.sendline('y')


def gen_expect (name,pattern,response):
	inst = pexpect.spawn('%s' % name)
	inst.expect('%s' % pattern)
	inst.sendline('%s' % response)