def teamwork (lic_dir,tw_dir):
	inst = pexpect.spawn('%s/bin/teamwork_server -key:%s' % (tw_dir, lic_dir))
	inst.expect('.\'I agree\':')
	inst.sendline('I agree')
	inst.expect('.Apply the key\? \(y/n\)')
	inst.sendline('y')