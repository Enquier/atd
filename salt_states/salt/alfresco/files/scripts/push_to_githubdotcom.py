#!/usr/bin/python

import commands
import os
import sys

CMD_ECHO_ONLY = False

JPL_GIT_2_COM_GIT = {
  'angular-mms': 'EMS-Webapp',
  'alfresco-view-repo': 'EMS-Repo',
  'alfresco-view-share': 'EMS-Share',
  'bae': 'bae',
  'docbook': 'docbook',
  'docbookgen': 'docbookgen',
  'emsscala': 'emsscala',
  'K':'K',
  'MDK':'MDK',
  'sysml':'sysml',
  'util':'util'
}


JPL_REMOTE_GIT = 'git@github.jpl.nasa.gov:mbee-dev/'
COM_REMOTE_GIT = 'git@github.com:Open-MBEE/'
GIT_EXTENSION = '.git'


'''
Clone the specified repository and change into the cloned directory
'''
def cloneRepository(repositoryName):
  cmd = 'git clone %s%s%s' % (JPL_REMOTE_GIT, repositoryName, GIT_EXTENSION)
  results = execCmd(cmd)
  try:
    os.chdir(repositoryName)
  except:
    # do nothing
    print 'could not change directory to %s' % (repositoryName)
  


'''
Checkout OpenSource branch, merge master into os branch, then push to github.com
'''
def openSourceIt(repositoryName, versionTag):
  # orphan the checkout to commit history isn't available
  cmd = 'git checkout opensource'
  results = execCmd(cmd)

  cmd = 'git pull -u origin opensource'
  results = execCmd(cmd)

  # FIXME: want to merge in from release - done by hand temporarily
  #cmd = 'git merge master'
  #results = execCmd(cmd)

  # want to remove all commit history... so remove git and add everything as initial commit
  cmd = 'rm -rf .git'
  results = execCmd(cmd)

  cmd = 'git init'
  results = execCmd(cmd);

  cmd = 'git add .'
  results = execCmd(cmd);

  cmd = 'git commit -m "Initial commit"'
  results = execCmd(cmd);


  cmd = 'git remote add github %s%s%s' % (COM_REMOTE_GIT, repositoryName, GIT_EXTENSION)
  results = execCmd(cmd)

  cmd = 'git branch %s' % (versionTag)
  results = execCmd(cmd)

  cmd = 'git push -u github %s --force' % (versionTag)
  results = execCmd(cmd)

#  cmd = 'git push --tag -u github opensource'
#  results = execCmd(cmd)

  
'''
Execute command and return the results
'''
def execCmd(cmd):
  print cmd
  if not CMD_ECHO_ONLY:
    results = commands.getoutput(cmd)
    print results
    return results


if __name__ == "__main__":
  if len(sys.argv) != 2:
    print 'usage: push_to_githubdotcom.py versionTag'
    exit(0)
  versionTag = sys.argv[1]
  for key, value in JPL_GIT_2_COM_GIT.items():
    cloneRepository(key)

    openSourceIt(value, versionTag=versionTag)
