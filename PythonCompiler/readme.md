## Info
The build.bat installs Nuitka and Pyinstaller. This is so you can obfuscate or build ur python file into an easy to distribute executeable.
The executeable is automatically packed with upx afterwards, decreasing the size for more avaliability.

## Modes
You can set the modes at line 27 of the build.bat script.
Mode 1 = pyinstaller ( Obfuscates with pyarmor with free and secure flags )
Mode 2 = Nuitka ( Turns python file into a C executeable for windows )

## How To Use
Download and place the build.bat in the directory of ur python script (where the main.py is located)
Then open powershell or cmd in the directory and run .\build.bat

## Notice
If you never used Nuitka before, you may need to specify some choices. But after you won't have to anymore.
