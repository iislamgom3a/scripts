# yt-dlp-downloader.ps1

# Get the user's Downloads folder
$DownloadDir = [Environment]::GetFolderPath("UserProfile") + "\Downloads"

# Check if yt-dlp is installed
if (-not (Get-Command yt-dlp -ErrorAction SilentlyContinue)) {
    Write-Host "yt-dlp is not installed or not in PATH." -ForegroundColor Red
    Write-Host "Installing ty-dlp package......" -ForegroundColor Yellow
    winget install yt-dlp -y
    exit
}

function Test-ValidUrl {
    param([string]$url)
    try {
        $uri = [System.Uri]::new($url)
        return $uri.Scheme -match '^https?$'
    }
    catch {
        return $false
    }
}

function Test-ValidQuality {
    param([string]$quality)
    return $quality -match '^\d+$' -and [int]$quality -gt 0
}

function Show-Menu {
    Clear-Host
    Write-Host "==== yt-dlp Downloader ====" -ForegroundColor Cyan
    Write-Host "1. Download a video"
    Write-Host "2. Download an audio"
    Write-Host "3. Downlaod a playlist"
    Write-Host "4. Set custom download directory"
    Write-Host "5. Exit"
}

function Set-CustomDownloadDir {
    $newDir = Read-Host "Enter custom download directory path"
    if (Test-Path $newDir) {
        $script:DownloadDir = $newDir
        Write-Host "Download directory set to: $DownloadDir" -ForegroundColor Green
    }
    else {
        Write-Host "Invalid directory path. Using default Downloads folder." -ForegroundColor Red
    }
}

function Download-Video {
    $url = Read-Host "Enter the video URL"
    if (-not (Test-ValidUrl $url)) {
        Write-Host "Invalid URL format. Please enter a valid URL." -ForegroundColor Red
        return
    }

    $quality = Read-Host "Enter desired video quality (e.g. 720, 1080)"
    if (-not (Test-ValidQuality $quality)) {
        Write-Host "Invalid quality value. Please enter a positive number." -ForegroundColor Red
        return
    }
    
    try {
        Write-Host "Starting download..." -ForegroundColor Yellow
        yt-dlp `
            -f "bestvideo[height<=$quality]+bestaudio/best[height<=$quality]" `
            --merge-output-format mp4 `
            --no-keep-video `
            -P "$DownloadDir" `
            $url
        Write-Host "Download completed successfully!" -ForegroundColor Green 
    }
    catch {
        Write-Host "Error during download: $_" -ForegroundColor Red
    }
}

function Download-Audio {
    $url = Read-Host "Enter the video or audio URL"
    if (-not (Test-ValidUrl $url)) {
        Write-Host "Invalid URL format. Please enter a valid URL." -ForegroundColor Red
        return
    }
    
    try {
        Write-Host "Starting audio extraction..." -ForegroundColor Yellow
        yt-dlp `
            -x `
            --audio-format mp3 `
            --audio-quality 0 `
            -P "$DownloadDir" `
            $url
        Write-Host "Audio extraction completed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error during audio extraction: $_" -ForegroundColor Red
    }
}

function Download-Playlist {
    $url = Read-Host "Enter the playlist URL"
    if (-not (Test-ValidUrl $url)) {
        Write-Host "Invalid URL format. Please enter a valid URL." -ForegroundColor Red
        return
    }
    

    $quality = Read-Host "Enter desired video quality (e.g. 480, 720, 1080)"
    if (-not (Test-ValidQuality $quality)) {
        Write-Host "Invalid quality value. Please enter a positive number." -ForegroundColor Red
        return
    }
    
    try {
        $playlistDir = Join-Path $DownloadDir "My_Playlist"

        # Create playlist directory if it doesn't exist
        if (-not (Test-Path $playlistDir)) {
            New-Item -ItemType Directory -Path $playlistDir | Out-Null
            Write-Host "Created directory: $playlistDir" -ForegroundColor Green
        }

        Write-Host "Starting playlist download to: $playlistDir" -ForegroundColor Yellow
        yt-dlp `
            -f "bestvideo[height<=$quality]+bestaudio/best[height<=$quality]" `
            --merge-output-format mp4 `
            --no-keep-video `
            --yes-playlist `
            --no-playlist-reverse `
            --paths "$playlistDir" `
            --output "%(title)s.%(ext)s" `
            $url

        Write-Host "Playlist download completed successfully!" -ForegroundColor Green
        Write-Host "Files saved in: $playlistDir" -ForegroundColor Cyan
    }
    catch {
        Write-Host "Error during playlist download: $_" -ForegroundColor Red
    }
}

do {
    Show-Menu
    $choice = Read-Host "Choose an option (1-5)"

    switch ($choice) {
        "1" { Download-Video }
        "2" { Download-Audio }
        "3" { Download-Playlist }
        "4" { Set-CustomDownloadDir }
        "5" { Write-Host "Exiting..." -ForegroundColor red }
        default { Write-Host "Invalid option, please choose again." -ForegroundColor Red }
        
    }

    if ($choice -ne "5") {
        Pause
    }

} while ($choice -ne "5")
