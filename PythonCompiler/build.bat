@echo off
del /f .\pyarmor.error.log
del /f .\main.exe
del /f .\main2.exe
RMDIR /Q /S .\dist
RMDIR /Q /S .\build
RMDIR /Q /S .\main.build
RMDIR /Q /S .\main.dist
RMDIR /Q /S .\main.onefile-build
cls

:: Compatibility
pip install -U pyinstaller
pip3 install -U pyinstaller
python -m pip install nuitka
python3 -m pip install nuitka
cls

if not exist ".\upx\" (
    mkdir .\upx\
    curl -o .\upx\upx.exe https://reallinen.github.io/Files/DLL/upx.exe
)

:: Mode 1 = pyinstaller | Mode 2 = nuika
set "MODE=2"
echo Current Mode: %MODE%

:: Requirements, you can specify
pip install -r requirements.txt

:: Check if dir exist
cls
if "%MODE%"=="1" (
    pyarmor gen --enable-jit --assert-call --period 2 --assert-import .\main.py
    cls
    echo :: Applying Obfuscation
    pyinstaller .\dist\main.py --onefile --exclude-module=pytest --hidden-import=requests --hidden-import=time
) else (
    echo :: Using Nuitka
    if exist ".\dist\" (
        python -m nuitka --onefile .\dist\main.py
    ) else (
        python -m nuitka --onefile .\main.py
    )
    RMDIR /Q /S .\main.build
    RMDIR /Q /S .\main.dist
    RMDIR /Q /S .\main.onefile-build
)

:: Renaming Files
if "%MODE%"=="1" (
    if exist ".\dist\main.exe" (
        move .\dist\main.exe .\main2.exe
        RMDIR /Q /S .\dist
        RMDIR /Q /S .\build 
        endlocal
    )
)

del /f .\main.spec
cls

:: Minification
if "%MODE%"=="1" (
    echo Minifying executeable...
    .\upx\upx.exe --force --brute --no-lzma main2.exe -o main.exe
    del /f .\main2.exe
) else (
    echo Minifying C executeable...
    .\upx\upx.exe --force --brute main.exe -o main2.exe
    del /f .\main.exe
    move .\main2.exe .\main.exe
)

:: Result
echo Project Obfuscated and Compiled to main.exe
exit
