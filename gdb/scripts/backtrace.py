import gdb

class ShorternBacktraceCommand(gdb.Command):
    '''Show a backtrace without argument info in each frame.'''

    def __init__(self):
        super(ShorternBacktraceCommand, self).__init__ ("bt",
                                                        gdb.COMMAND_SUPPORT,
                                                        gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty):
        num = 0;
        try:
            num = int(arg)
        except Exception, e:
            pass

        lines = []
        f = gdb.newest_frame()
        fn = 0
        while f is not None:
            symtab_and_line = gdb.Frame.find_sal(f)
            frame_name = gdb.Frame.name(f)
            if frame_name:
                args = [
                    fn,
                    frame_name,
                    symtab_and_line.symtab.filename,
                    symtab_and_line.line,
                ]
            else:
                args = [fn, '??', 'unknown', 0]
            lines.append('#%2d  %s at %s:%s' % tuple(args))

            f = gdb.Frame.older(f)
            fn += 1

        if num > 0:
            lines = lines[:num]
        elif num < 0:
            lines = lines[len(lines) + num:]

        for line in lines:
            print line


ShorternBacktraceCommand()
