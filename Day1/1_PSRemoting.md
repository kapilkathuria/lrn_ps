# PS Remoting
Remoting was introduced in v2

Allows running command on remote machine(s). Session connects to a runspace on remote machine

# Remoting requirements
  • PS version 3.0 or above
  • Ps remoting need to be enabled on remote server. 
    ○ Servers: Ps remoting is enabled by default unless blocked by GPO or something similar
    ○ Clients: disabled by default
  • Permission: must of be member of admin or remote management users

# Cmdlets and protocol
Earlier - RPC

Modern: uses WS-Man
  • Invoke command
  • Enter-PsSession, new-PsSession
  • Get-CimClassInstance, Invoke-CimMethod, Set-CimInstance


# Object serialization
Transform ps object into compact . This is useful for sending to remote machine or when we want to save to a file.

Once we have data, we can deserialize the data to object.

Couple of properties get added/ lost during deserlization 
Property added: PSComputerName
