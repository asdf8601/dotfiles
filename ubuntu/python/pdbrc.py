"""
This is an example configuration file for pdb++.

Actually, it is what the author uses daily :-). Put it into ~/.pdbrc.py to use
it.
"""
# flake8: noqa
import pdb


class Config(pdb.DefaultConfig):
    # default
    stdin_paste = 'epaste'
    filename_color = pdb.Color.lightgray
    use_terminal256formatter = False
    # current_line_color = 44  # Blue

    # custom
    prompt = ">>> "  # Ready to copy as an example
    editor = 'nvim'  # I love it btw
    sticky_by_default = True
    line_number_color = pdb.Color.darkred
    truncate_long_lines = True  # Avoid ugly line wraps...
    enable_hidden_frames = True  # Show hidden frames by default
    exec_if_unfocused = None  # TODO: this is broken, open a issue.

    def setup(self, pdb):
        Pdb = pdb.__class__
        # Pdb.do_l = Pdb.do_longlist
        Pdb.do_st = Pdb.do_sticky

def setup(self, pdb):
    pass

def read_pdbrc():
    # https://github.com/pdbpp/pdbpp/issues/497
    import os
    pdbrc = os.getenv("PDBRC")
    print(f"Reading {pdbrc}")
    if pdbrc is None:
        return
    with open(pdbrc, 'r') as f:
        # HACK: Unexpected side-effect, using try-except...  ¯\_ (ツ) _/¯
        try:
            exec(f.read())
        except Exception as e:
            pass


read_pdbrc()
