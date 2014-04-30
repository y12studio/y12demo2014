@echo off
SET DART_EDITOR_DIR=C:\y12Download\dart\darteditor-windows-x64
SET DART_SDK=%DART_EDITOR_DIR%\dart-sdk
SET PATH=%PATH%;%DART_SDK%\bin;
SET KARMA=node .\node_modules\karma\bin\karma
dart.exe --version
%KARMA% --version
%KARMA% start test/karma.conf.js --p 9876