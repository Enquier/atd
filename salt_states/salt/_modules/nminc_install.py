import pexpect

def teamwork (lic_dir,tw_dir):
	inst = pexpect.spawn('%s/bin/teamwork_server_nogui -key:%s' % (tw_dir, lic_dir))
	inst.expect('.\'I agree\':')
	inst.sendline('I agree')
	inst.expect('.Apply the key\? \(y/n\)')
	inst.sendline('y')


def gen_expect (name,pattern,response):
	inst = pexpect.spawn('%s' % name)
	inst.expect('%s' % pattern)
	inst.sendline('%s' % response)
	
def config_vnc (password):
	inst = pexpect.spawn('vncserver')
	inst.expect('.Password:')
	inst.sendline('%s' % password)
	inst.expect('.Verify:')
	inst.sendline('%s' % password)