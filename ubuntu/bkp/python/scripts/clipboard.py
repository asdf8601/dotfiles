import os


def to_clipboard(obj, copy_cmd="xclip -selection clipboard"):
    # sudo apt install xclip
    import os
    os.system(f"echo '{obj}' | {copy_cmd}")


def pbcopy(text):
    command = r"echo '%r' | xclip -selection clipboard" % text
    os.system(command)


to_clip = pbcopy

