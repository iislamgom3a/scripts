@echo off
setlocal enabledelayedexpansion

:: Define the source directory (current directory)
set "source_dir=%CD%"

:: Create target directories based on file type if they don't exist
for %%d in (Images Videos Software Archives Docs Audio src spreadsheets presentations fonts) do (
    if not exist "%source_dir%\%%d" mkdir "%source_dir%\%%d"
)

:: Function to move files based on extension
call :move_files "Images" jpg jpeg png gif bmp tiff webp heic raw svg JPG
call :move_files "Videos" mp4 mkv mov avi flv webm mpeg 3gp ts wav
call :move_files "Software" exe msi deb rpm dmg pkg appimage sh ps1 jar bin run
call :move_files "Docs" doc docx dot dotx xls xlsx xlsm xlt xltx ppt pptx pps ppsx pot potx mdb accdb pub one odt ods odp odg odf pdf xps txt rtf csv log md xml html htm json tex epub chm djvu
call :move_files "Archives" zip rar 7z tar gz bz2 xz iso cab arj lzh ace z arc jar war apk deb rpm pkg tar.gz tar.bz2 tar.xz tgz tbz txz
call :move_files "Audio" mp3 m4a wav flac aac ogg opus wma alac amr aiff au midi mid
call :move_files "src" py cpp c java ipynb js ts cs rb go rs swift kt php html css json yaml yml xml sh ps1 r lua dart scala pl pm ml hs jl lisp clj ex exs erl hrl pas vhdl verilog asm sql awk tex md toml ini cfg makefile dockerfile jenkinsfile gitignore env
call :move_files "spreadsheets" xls xlsx csv ods numbers 
call :move_files "presentations" ppt pptx pps ppsx key odp
call :move_files "fonts" ttf otf woff woff2 eot


:: Clean up empty directories
for /d %%d in ("%source_dir%\*") do (
    if exist "%%d\" (
        dir /b "%%d" | findstr "." >nul || rd "%%d"
    )
)

exit /b

:move_files
set "folder=%1"
shift
for %%e in (%*) do (
    for /f "delims=" %%f in ('dir /b /a-d "%source_dir%\*.%%e" 2^>nul') do (
        move "%source_dir%\%%f" "%source_dir%\%folder%\" >nul
    )
)
exit /b
