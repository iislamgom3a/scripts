@echo off
setlocal enabledelayedexpansion

:: Define the source directory (current directory)
set "source_dir=%CD%"
set "Docs_dir=%source_dir%\Documents"

:: Create target directories if they don't exist
for %%d in (Images Videos Audio Software Archives Documents src fonts) do (
    if not exist "%source_dir%\%%d" mkdir "%source_dir%\%%d"
)
:: Create subdirectories inside Documents
for %%d in (PDFs spreadsheets presentations docs) do (
    if not exist "%Docs_dir%\%%d" mkdir "%Docs_dir%\%%d"
)

:: Move files to respective folders
call :move_files "Images" jpg jpeg png gif bmp tiff webp heic raw svg
call :move_files "Videos" mp4 mkv mov avi flv webm mpeg 3gp ts
call :move_files "Software" exe msi jar
call :move_files "Documents" pdf one odt odf xps txt rtf tex epub chm djvu xls xlsx xlsm xlt xltx csv ods ppt pptx pps ppsx pot potx odp doc docx dot dotx
call :move_files "Archives" zip rar 7z iso cab lzh ace z arc war apk
call :move_files "Audio" mp3 m4a wav flac aac ogg opus wma alac amr aiff au midi mid
call :move_files "src" py cpp c java ipynb js ts cs rb go rs swift kt php html css json yaml yml xml sh ps1 r lua dart scala pl pm ml hs jl lisp clj ex exs erl hrl pas vhdl verilog asm sql awk tex toml ini cfg makefile dockerfile jenkinsfile gitignore env log
call :move_files "fonts" ttf otf woff woff2 eot

:: Move Documents subcategory files
call :move_docs_files "PDFs" pdf
call :move_docs_files "spreadsheets" xls xlsx xlsm xlt xltx csv ods
call :move_docs_files "presentations" ppt pptx pps ppsx pot potx odp
call :move_docs_files "docs" doc docx dot dotx



:: Cleanup empty directories
for /d %%d in ("%source_dir%\*") do (
    dir /b "%%d" | findstr "." >nul || rd "%%d" 2>nul
)
for /d %%d in ("%Docs_dir%\*") do (
    dir /b "%%d" | findstr "." >nul || rd "%%d" 2>nul
)

:: Functions
:move_files
set "folder=%1"
shift
for %%e in (%*) do (
    for /f "delims=" %%f in ('dir /b /a-d "%source_dir%\*.%%e" 2^>nul') do (
        move "%source_dir%\%%f" "%source_dir%\%folder%\" >nul
    )
)
exit /b

:move_docs_files
set "folder=%1"
shift
for %%e in (%*) do (
    for /f "delims=" %%f in ('dir /b /a-d "%Docs_dir%\*.%%e" 2^>nul') do (
        move "%Docs_dir%\%%f" "%Docs_dir%\%folder%\" >nul
    )
)
exit /b

