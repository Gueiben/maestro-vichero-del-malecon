@echo off
title MAESTRO VICHERO DEL MALECON 3D
set "DIR=%~dp0"
set "G2=%DIR%index.html"
start msedge --app="file:///%G2:\=/%" --start-fullscreen 2>nul || start chrome --app="file:///%G2:\=/%" --start-fullscreen 2>nul || start "" "%G2%"
