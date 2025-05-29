# GCP_Sp2txt
For audio conversions to text
---

### Preparation:
- Install chcocolately if needed
- Install ffmpeg	# for audio conversion
  - ex: ffmpeg -i "file.m4a" -acodec pcm_s16le -ac 1 -ar 48000 "file.wav"    # Converting files to suitable format
  - if you wish to run couple of files in batch run the command below. Just don't forget to adjust the number associated with i and file name according to your need. Save it in a ps1 file (ex. convert.ps1) and then run it in powershell.
~~~sh
# Define log file
$logFile = "conversion_log.txt"
Set-Content -Path $logFile -Value "Failed Conversions:`n"  # Initialize log file

# Loop through files S1 to S60
for ($i = 1; $i -le 60; $i++) {
    $formats = @("m4a", "mp3")
    $foundMain = $false

    # Check for main file
    foreach ($format in $formats) {
        $inputFile = "S$i.$format"
        $outputFile = "S$i.wav"

        if (Test-Path $inputFile) {
            try {
                ffmpeg -i $inputFile -acodec pcm_s16le -ac 1 -ar 48000 $outputFile
                $foundMain = $true
                break
            } catch {
                Add-Content -Path $logFile -Value "$inputFile failed to convert."
            }
        }
    }

    # If no main file was found, check alternate versions
    if (-not $foundMain) {
        for ($j = 1; $j -le 2; $j++) {
            foreach ($format in $formats) {
                $altInputFile = "S${i}_${j}.$format"
                $altOutputFile = "S${i}_${j}.wav"

                if (Test-Path $altInputFile) {
                    try {
                        ffmpeg -i $altInputFile -acodec pcm_s16le -ac 1 -ar 48000 $altOutputFile
                    } catch {
                        Add-Content -Path $logFile -Value "$altInputFile failed to convert."
                    }
                }
            }
        }
    }
}

~~~



