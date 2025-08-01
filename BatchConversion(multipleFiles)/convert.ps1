
# Step 1: Save detailed file list
$i = 1
Get-ChildItem -File | 
    Where-Object { $_.Name -match '\.(mp3|m4a)$' } | 
    ForEach-Object {
        "$i-$($_.Name) (Size: $($_.Length) bytes, Modified: $($_.LastWriteTime))"
        $i++
    } > output.txt

# Step 2: Rename files to "S (1).ext" format
$i = 1
Get-ChildItem -File | 
    Where-Object { $_.Name -match '\.(mp3|m4a)$' } | 
    ForEach-Object {
        $newName = "S ($i)$($_.Extension)"
        Rename-Item -LiteralPath $_.FullName -NewName $newName -ErrorAction SilentlyContinue
        $i++
    }

# Step 3: Loop through files S (1) to S (100)
for ($i = 1; $i -le 100; $i++) {
    $formats = @("m4a", "mp3")
    $foundMain = $false

    # Check for main file
    foreach ($format in $formats) {
        $inputFile = "S ($i).$format"
        $outputFile = "S ($i).wav"

        if (Test-Path $inputFile) {
            try {
                ffmpeg -i "`"$inputFile`"" -acodec pcm_s16le -ac 1 -ar 48000 "`"$outputFile`""
                $foundMain = $true
                break
            } catch {
                Add-Content -Path $logFile -Value "$inputFile failed to convert."
            }
        } else {
            Add-Content -Path $logFile -Value "$inputFile not found."
        }
    }

    # If no main file was found, check alternate versions
    if (-not $foundMain) {
        for ($j = 1; $j -le 2; $j++) {
            foreach ($format in $formats) {
                $altInputFile = "S ($i)_$j.$format"
                $altOutputFile = "S ($i)_$j.wav"

                if (Test-Path $altInputFile) {
                    try {
                        ffmpeg -i "`"$altInputFile`"" -acodec pcm_s16le -ac 1 -ar 48000 "`"$altOutputFile`""
                    } catch {
                        Add-Content -Path $logFile -Value "$altInputFile failed to convert."
                    }
                } else {
                    Add-Content -Path $logFile -Value "$altInputFile not found."
                }
            }
        }
    }
}
