set history save on
set history size 4096
set history filename ~/.gdb_history

python
import sys
sys.path.insert(0, '/home/fcamel/dev/gdb/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end

python
sys.path.insert(0, '/home/fcamel/dev/gdb/scripts')
import backtrace
end
