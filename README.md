# cmdrunner
simple and easy automation tool
'cmdrunner' is the simple automation tool focussed on testing 
simple cli commands.

Most of test cases revolves around executing a command, and checking for the 
output message,and the return value. 
For few other testcases, you will execute a command, you will do a follow up, 
where you do lot of other test steps based on the result.

'cmdrunner' suits the first category of testing. 
For example, ISO testing, rpm testing
Also few other basic testing.

All the test cases are written in a file which is formally called "recipe file"
 with the predefined syntax and provided to the cmdrunner. 
cmdrunner executes the test and logs the output


1. Predefined syntax for recipe file :

Syntax for the every testcase should be of the following format:
column1			column2			column3			
isTestStep(0 or 1)    "cmd to be executed"      returnvalue(0 or 1)   

column4			 column5
outputMessage_substring	 iteration

Here goes the description,

isTestcase - Tell 'cmdrunner', whether its a test step or not. ( 0 or 1 )
             when its a test step, then it affects the total, pass, fail count 
             of the result.

cmd        - Place the commands to be executed within double quotes (string)

returnvalue- The expected $? ( 0 or 1 )

outputmessage_substring
           - Every command executed may or may not have some messages written
             to console.If you wish to compare that output string with your 
             substring, you can go with this option. Else provide "null"

iteration  - The number of times the command should be executed

Examples:
# cat simpleRecipeFile1
1 "ls /var/run/gluster" 0 "null" 1

isTestStep is set to 1 which means this is a test step, and it affects the total
count. If this test passes ( in case the /var/run/gluster is available), it 
adds to the passcount, else adds to the failcount

The command is "ls /var/run/gluster" and this gets executed
The return value expected is 0 ( means presence of /var/run/gluster directory )
There is no output message that is expected, so the column4 is "null"
This test runs only for one time as the column5 says 1


#cat simpleRecipeFile2
1 "systemctl is-enabled glusterd" 0 "enabled" 1

Here the column4 has the value "enabled". So this value substring should be part of
the output message while executing the command "systemctl is-enabled glusterd"


