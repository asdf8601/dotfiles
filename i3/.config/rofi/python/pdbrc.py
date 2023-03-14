"""
This is an example configuration file for pdb++.

Actually, it is what the author uses daily :-). Put it into ~/.pdbrc.py to use
it.
"""
import pdb
import os

try:
    import numpy as np

    np.set_printoptions(linewidth=120)
except Exception:
    pass


def addToClipBoard(text):
    command = 'echo %r | xclip -selection clipboard' % text
    os.system(command)

def show_variables(variables):
    for k, v in variables.items():
        msj_fmt = "{k:>15} : {type(v)}, {getattr(v, 'shape', '')}"
        msj = msj_fmt.format(k=k, v=v)
        print(msj)


class Config(pdb.DefaultConfig):

    prompt = ">>> "
    editor = 'e'
    stdin_paste = 'epaste'
    filename_color = pdb.Color.lightgray
    use_terminal256formatter = False
    sticky_by_default = True
    line_number_color = pdb.Color.darkred
    current_line_color = 44

    def setup(self, pdb):
        Pdb = pdb.__class__
        # make 'l' an alias to 'longlist'
        # Pdb.do_l = Pdb.do_longlist
        Pdb.do_st = Pdb.do_sticky
