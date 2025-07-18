# Define log file
$logFile = "conversion_log.txt"
Set-Content -Path $logFile -Value "Failed Conversions and Missing Files:`n"  # Initialize log file

# Saves all file names with index
$i=1
ls | Where-Object {$_.Name -match '\.(m4a|mp3)$'}|
	Select-Object -ExpandProperty Name | 
		ForEach-Object {"$i-$_" 
		$i++ 
	} > output.txt

# Loop through files S (1) to S (100)
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
