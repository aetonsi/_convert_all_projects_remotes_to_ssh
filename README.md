# \_convert_all_projects_remotes_to_ssh

Simple powershell script to convert git remotes from HTTPS to SSH of all working directories in a given root folder.

For any child directory containing a `.git` folder, it runs `git remote -v` to determine if the remote is HTTPS or not, then it runs `git remote set-url origin git@github.com:...` to update the remote if necessary. Then it runs `git fetch` to check if everything is fine.

# Usage

In `powershell`:

```powershell
# to trigger folder browser dialog
.\_convert_all_projects_remotes_to_ssh.ps1
# or specifying a folder
.\_convert_all_projects_remotes_to_ssh.ps1 -dir c:\somefolder
```

In Windows `cmd`:

```batch
rem to trigger folder browser dialog
_convert_all_projects_remotes_to_ssh
rem or specifying a folder
_convert_all_projects_remotes_to_ssh -dir c:\somefolder
```

In Linux shell:

```bash
# to trigger folder browser dialog
./_convert_all_projects_remotes_to_ssh.sh
# or directly
./_convert_all_projects_remotes_to_ssh.ps1
# as always you can specify a folder
./_convert_all_projects_remotes_to_ssh.ps1 -dir /somefolder
```

In Windows Explorer, just double click `_convert_all_projects_remotes_to_ssh.cmd`. It will trigger the folder browser dialog.
