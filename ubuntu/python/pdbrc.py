"""
This is an example configuration file for pdb++.

Actually, it is what the author uses daily :-). Put it into ~/.pdbrc.py to use
it.
"""
# flake8: noqa
import pdb
import os

try:
    import numpy as np

    np.set_printoptions(linewidth=120)
except ImportError:
    pass


def addToClipBoard(text):
    command = 'echo %r | xclip -selection clipboard' % text
    os.system(command)


def show_variables(variables):
    for k, v in variables.items():
        msj_fmt = "{k:>15} : {type(v)}, {getattr(v, 'shape', '')}"
        msj = msj_fmt.format(k=k, v=v)
        print(msj)


def whose():
    show_variables(pdb.globals)


class Config(pdb.DefaultConfig):

    prompt = ">>> "
    editor = 'nvim'
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


def setup(self, pdb):
    pass


def read_breakpoints():
    pdb_bp = os.getenv("PDB_BP")
    if pdb_bp is None:
        return
    print("rading breakpoints from", pdb_bp)
    with open(pdb_bp, 'r') as f:
        contenido = f.read()
    exec(contenido)


read_breakpoints()
