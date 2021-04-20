from pathlib import Path

def match(command):
    return command.script == "lsd" and Path(command.script_parts[1]).is_file()

def get_new_command(command):
    command.script = "bat"
    return command

priority = 10
enabled_by_default = True
