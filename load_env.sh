ps aux | grep chuck | tr -s " " | cut -d" " -f2 | xargs -I PID kill -9 PID
ps aux | grep chuck | grep -v "grep chuck"
chuck --loop &
chuck + arg_parser_imports.ck
chuck + arg_parser.ck:--controller-port-in:0:--controller-port-out:1:--internal-port-out:2:--channel-in:3:--channel-out:4 
