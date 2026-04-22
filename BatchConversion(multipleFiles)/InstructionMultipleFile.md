# Instructions for converting multiple files at the same time (With Phrase Set)

## Convert the Audio File to Correct Format

1. Copy audio files to the location where run_script.bat is located
2. Make sure there are no other audio files (mp3 or m4a) is there
3. Double click on run_script.bat.
4. Once done the previous file names can be found in output.tx


---

## Upload to Google Cloud

1. Go to [Google Cloud Console](https://console.cloud.google.com/).
2. Use the top search bar to find **Buckets** and navigate to the relevant link.
3. Open:
   blolb_speech > Spch2Text > AudioInput
4. Delete all prvious files. 
5. Drag and drop all the files there:


---

## Running the Model

1. Open `BatchConvertMultipleFiles.ipynb` in Visual Studio Code.
2. Update the `END_INDEX` with the maximum number you see. For instance if the last file converted is 'S (4).wav', then `END_INDEX`=4
3. Click **Run All** at the top of the window.
4. All corresponding text file will be generated in the same folder, named after the audio files, once you see  "All files processed!" on the screen.



