# ssh-x
Cli tool for fast connection to servers via ssh

## Installation
  ⚠️ Linux only. Install zig, make, sshpass
```
git clone https://github.com/blockkwork/ssh-x ; make BUILD # compiles and then copies sx (bin name) to /bin/
```

```
Available commands: --add-server (-a), --ssh (-s), --delete (-d)

Examples:
  sx -a server_name root:password@127.0.0.1:22
  sx -s server_name
  sx -d server_name
```
