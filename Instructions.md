# Instructions
# Instructions

## Convert the Audio File to Correct Format

1. Navigate to the file's location, right-click, and select **Open in Terminal**.
2. Run the following command, replacing `file.m4a` with the actual file name:


   
```sh
ffmpeg -i file.m4a -ar 16000 -ac 1 -c:a pcm_s16le output.wav
```

---

## Upload to Google Cloud

1. Go to [Google Cloud Console](https://console.cloud.google.com/).
2. Use the top search bar to find **Buckets** and navigate to the relevant link.
3. Open:
   blolb_speech > Spch2Text > AudioInput 
4. Drag and drop it there:


---

## Running the Model

1. Open `Birch2Sample.ipynb` in Visual Studio Code.
2. Update the `FILE_NAME` variable to match the actual audio file name.
3. Click **Run All** at the top of the window.
4. A corresponding text file will be generated in the same folder, named after the audio file (e.g., `Session1.docx`).



