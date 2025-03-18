# pip install git+farisachugthai/gruvbox_pygments
# from traitlets.config import get_config
# from IPython.terminal.prompts import ClassicPrompts

# c = get_config()

# c.TerminalInteractiveShell.colors = 'linux'
# c.TerminalInteractiveShell.highlighting_style = 'gruvbox-dark'
# c.TerminalInteractiveShell.highlight_matching_brackets = True
# c.TerminalInteractiveShell.xmode = 'context'

c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.banner1 = ""
# c.TerminalInteractiveShell.prompts_class = ClassicPrompts
# c.TerminalInteractiveShell.editing_mode = "vim"
# c.TerminalInteractiveShell.editor = "vi"
# c.TerminalInteractiveShell.extra_open_editor_shortcuts = True
# c.InteractiveShellApp.exec_files = ["*.ipy*"]
# c.TerminalInteractiveShell.highlighting_style = 'GruvboxDarkHard'
c.PlainTextFormatter.max_width = 90
c.PlainTextFormatter.pprint = True
# c.TerminalInteractiveShell.editor = 'nvim'
# c.TerminalInteractiveShell.editing_mode = 'vi'
# c.InteractiveShellApp.exec_lines = []
c.InteractiveShellApp.extensions = [
    "autoreload",
    # "rich",
    # "pyflyby",
]
c.InteractiveShellApp.exec_lines = [
    "%autoreload 3",
]

# c.InteractiveShell.colors = 'NoColor'
# c.TerminalInteractiveShell.highlight_matching_brackets = True
# c.PlainTextFormatter.newline = '\\n'
# c.TerminalInteractiveShell.xmode = "Minimal"
# c.TerminalInteractiveShell.autoformatter = "black"
# c.TerminalInteractiveShell.autoformatter = None
