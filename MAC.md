- `python -m pip install virtualenv`

- I notice you're using PowerShell on macOS, which is why the activation commands aren't working. For PowerShell on macOS, you need to use a different activation command. Here are your options:

1. If you want to continue using PowerShell, use:
```powershell
venv/bin/Activate.ps1
```

2. If you switch to bash or zsh (which are more common on macOS), you would use:
```bash
source venv/bin/activate
```

3. Alternatively, you can also directly execute the Python interpreter from the virtual environment:
```bash
./venv/bin/python
```

To switch to bash or zsh terminal (which might be easier on macOS), you can:
1. Open Terminal.app instead of PowerShell
2. Or type `bash` or `zsh` in your PowerShell to switch shells
3. Then use `source venv/bin/activate`

Choose whichever method works best for your workflow. Let me know if you need any clarification!