import pexpect

def teamwork (lic_dir,tw_dir):
	inst = pexpect.spawn('%s/bin/teamwork_server_nogui -key:%s' % (tw_dir, lic_dir))
    try:
        i = inst.expect(['.\'I agree\':','JAVA_HOME ok: /usr/lib/jvm/java')
        if i==0:
            print('Key application required')
            inst.sendline('I agree')
            try:
                j = inst.expect('.Apply the key\? \(y/n\)')
                if j==0:
                    inst.sendline('y')
                    return (True, 'Key Successfully Applied')
                else:
                    return (False, str(inst))
            except:
                print("There was something wrong with the key")
                print(str(inst))
                return False
        elif i==1:
            return (True, 'Key has already been applied')
    except EOFError:
        return (False, str(inst))


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