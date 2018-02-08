
A small minecraft focused RCON client.

NOTE: Does not yet handle large/ multi packet responses.


# Installation

```
gem install zrcon
```

# Command Line Usage

To talk to your RCON server, you'll need three pieces of information.  The
RCON_HOST, RCON_PORT, and RCON_PASSWORD.  If not provided to the command line
or API explicitly, they will be retrieved from environment variables having
these names.

```
$ zrcon --help
Usage: zrcon rcon-command
-H, --host=HOSTNAME              hostname of rcon server
-p, --port=PORT                  tcp port
-P, --password=PASS              rcon password
-h, --help


$ zrcon list
There are 0/20 players online:
```

# The API

```
require 'zrcon'
rcon = Zrcon.new host: 'hostname', port: 25565, password: 'somethingsupersecret'
rcon.auth
rcon.command 'list'
```

Semaphore Build Status:

[![Build Status](https://semaphoreci.com/api/v1/alibby/zrcon/branches/master/shields_badge.svg)](https://semaphoreci.com/alibby/zrcon)

