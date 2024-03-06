# remoting - advanced 

## powershell sessions
- temp session: on closing the session, all the data in session in lost

- persistant session: data in runspace is saved

NOTE: runspace - light weight ps thread. used for creating multiple session in parallel

## Session lifecycle

- you can connect back to disconnected sessions
- connectingn back to ps session required ps 3.0 or higher on both ends

there are 3 session states
- opened
- disconnected
- Broken

### session availability
- busy
- available: 
- None: runspace not available

NOTE: data is persistent till session is not removed or broken or timesout


# implicit remoting
allows using modules of remote machine on local machine. 

- use of invoke-command in background, it seems like commands are running locally
- you can use import-pssession or import-module 
- local functions "wrap"

serveral products like exchange 2010+ use implicit remoting

# PS Remoting default settings
- need to be member of admin or remote management user
- on private and domain network, ps remoting allows all connections
- ports: 5985 and 5986

## auth mechanism
- kerberos: default. client is part of domain.
- ntlm: using ip or non-domain server
- basic: not recomended. login and password as plain text. must be enabled explicity with ssl auth.


## trusted hosts
- setting on client - contains list of computers that are trusted.
- can include member of workgroup or different domain

## Workng with credential
- in plain text. most cmdlet don't accept plain text
- [System.Security.SecureString]
- [system.management.automation.pscredential]

