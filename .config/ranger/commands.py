from ranger.api.commands import Command
from pathlib import Path
from shutil import copy
import subprocess

here = Path(__file__).parent

class paste_as_root(Command):
	def execute(self):
		if self.fm.do_cut:
			self.fm.execute_console('shell sudo mv %c .')
		else:
			self.fm.execute_console('shell sudo cp -r %c .')

class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        import os.path
        if self.quantifier:
            # match only directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m --reverse --header='Jump to file'"
        else:
            # match files and directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m --reverse --header='Jump to filemap <C-f> fzf_select'"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)

class screen_to_crop(Command):
    def execute(self):
        thisfile = self.fm.thisfile
        output = Path(self.fm.thisdir.path) / "cropped" / thisfile.basename
        output.parent.mkdir(exist_ok=True, parents=True)
        subprocess.run('picom-trans --toggle --current', shell=True)
        subprocess.run(f"scrot --select --freeze -e 'mv $f {output}'", shell=True)
        subprocess.run('picom-trans --toggle --current', shell=True)
        self.fm.notify(f"Saved crop to {output}")

class move_to_subfolder(Command):
    def execute(self):
        selection = self.fm.thisdir.get_selection() or [self.fm.thisfile]
        if not selection:
            return

        self.fm.notify("Work in progress, sowwy !")
        return

        self.fm.ui.console.ask(
            "Move to: ./",
            lambda ans: self.move_to(ans, selection),
        )

    def move_to(self, dest, selection):
        if dest:
            for f in selection:
                Path(f.path).rename(Path(f.path).parent / dest / f.basename)
