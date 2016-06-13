import pexpect
import logging

def teamwork (lic_dir,tw_dir):
    log = logging.getLogger(__name__)
    inst = pexpect.spawn('%s/bin/teamwork_server_nogui -key:%s' % (tw_dir, lic_dir))
    try:
        i = inst.expect(['.\'I agree\':', 'JAVA_HOME ok: /usr/lib/jvm/java'])
    except EOFError:
        return (False, str(inst))
    else:
        if i==0:
            log.info('Key application required')
            inst.sendline('I agree')
            try:
                j = inst.expect('.Apply the key\? \(y/n\)')
            except:
                log.error('There was something wrong with the key')
                print(str(inst))
                return False
            else:
                if j==0:
                    inst.sendline('y')
                    return (True, 'Key Successfully Applied')
                else:
                    return (False, str(inst))
            
        elif i==1:
            return (True, 'Key has already been applied')
    


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