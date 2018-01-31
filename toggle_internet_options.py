import subprocess
import os, sys
home = os.path.expanduser("~")
sys.path.append(os.path.join(home,'Documents','GitHub'))
from Logger import customLogger
logger = customLogger('root')
logger.setLevel('INFO')
# Set some variables
query = 'reg query'
setting = 'reg add'
path = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections"'
key_name = 'DefaultConnectionSettings'
key_type = 'REG_BINARY'

# Define a build_command function
def build_command(list_obj):
    command = ''
    for com in list_obj:
        command += com + ' '
    return command.strip()

# Perform query and get string
quer_command = build_command([query,path,'/v',key_name])
logger.debug('Running Command: %s'%(quer_command))
p = subprocess.Popen(quer_command, stdout=subprocess.PIPE)
stdout, stderr = p.communicate()

if not stderr is None:
    logger.warn('STDERR output was not None as expected: %s\nContinueing anyway...'%(stderr))

# Split the string on keytype and look for value
splits = stdout.split(key_type)
splits_key = 1
if (len(splits) < 2):
    logger.critical('Could not split output by %s...look at raw output: \n%s'%(key_type,stdout))
    raise ValueError('See logger output')
elif (len(splits) > 2):
    logger.warn('Had multiple splits...using this value:%s. Raw output was: \n%s'%(splits[splits_key],stdout))

binary = splits[splits_key].strip()

# Now we look for the proper key
start_pos = 16 #Inclusive
end_pos = 18 # exclusive
box_checked = '05'
box_unchecked = '01'

if binary[start_pos:end_pos] ==box_checked:
    logger.info('Was using Config Script...Turning it off')
    new_binary = binary[:start_pos] + box_unchecked + binary[end_pos:]
elif binary[start_pos:end_pos] =='04':
    logger.info('Was using Config Script...Turning it off')
    logger.debug('04 was detected...assuming 04 and 05 are the same.')
    new_binary = binary[:start_pos] + box_unchecked + binary[end_pos:]
elif binary[start_pos:end_pos] ==box_unchecked:
    logger.info('Wasn"t using Config Script...Turning it on')
    new_binary = binary[:start_pos] + box_checked + binary[end_pos:]

else:
    logger.critical('Unexpected key value for config script: %s'%(binary[start_pos:end_pos]))
    raise ValueError('See logger output')

# Now we actually set it
set_command = build_command([setting,path,'/v',key_name,'/t',key_type,'/d',new_binary,'/f'])
logger.debug('Running Command: %s'%(set_command))
p = subprocess.Popen(set_command, stdout=subprocess.PIPE)
stdout, stderr = p.communicate()

if not stderr is None:
    logger.warn('STDERR output was not None as expected: %s\nContinueing anyway...'%(stderr))

logger.info('DONE...')
