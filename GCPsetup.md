# Google Cloud Speech-to-Text Setup

This guide provides instructions for using Google Cloud Speech-to-Text with a custom language model for transcribing audio files, including speaker diarization and saving the output to a DOCX file with speaker change indicators.

## **Python Packages Used**

The Python code provided in this conversation utilizes the following packages:  
- `google-cloud-speech`: The official Google Cloud Speech-to-Text client library for Python.  
- `docx`: A Python library for creating and modifying DOCX files.  
- `pydub`: A Python library for audio manipulation (used in a conceptual example for chunking).  
- `os`: A built-in Python module for interacting with the operating system (used for file paths and working directory).  
- `time`: A built-in Python module for time-related tasks (used in the asynchronous processing example).

## **Setting up Google Cloud for Speech-to-Text**

To use Google Cloud Speech-to-Text, you need to:  
1. **Create a Google Cloud Project:** If you don't have one already, create a new project in the [Google Cloud Console](https://console.cloud.google.com/).  
2. **Enable the Speech-to-Text API:** Navigate to the API Library in your project and enable the "Cloud Speech-to-Text API".  
3. **Create a Google Cloud Storage (GCS) Bucket:** You will need a GCS bucket to store your audio files. You can create one using the [Google Cloud Console](https://console.cloud.google.com/storage) or the `gsutil` command-line tool.  
4. **Upload Your Audio File to GCS:** Upload the audio file you want to transcribe (e.g., in WAV format for better compatibility) to your GCS bucket.  
5. **Set up Authentication:** Your Python script needs credentials to access your Google Cloud project. The recommended way is to set up Application Default Credentials (ADC):  
    - **Install the Google Cloud CLI:** Follow the instructions on the [Google Cloud documentation](https://cloud.google.com/sdk/docs/install-sdk#windows) to install the gcloud CLI.  
    - **Authenticate gcloud:** Open your terminal or command prompt and run:  
      ```sh
      gcloud auth application-default login
      ```
      Follow the prompts to authenticate your Google account with your Google Cloud project.

## Set the key

To set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable so that you can use Google Cloud models in VS Code, you'll need to perform steps both in the Google Cloud Console and on your local computer. Here's a breakdown:

### Step 1: Download the Service Account Key JSON File

This involves actions within the Google Cloud Console.

1. **Go to the Google Cloud Console:** Open your web browser and navigate to the [Google Cloud Console](https://console.cloud.google.com/).  
2. **Select your Project:** Make sure you have the correct Google Cloud Project selected in the top navigation bar.  
3. **Navigate to Service Accounts:** In the left-hand menu, go to **IAM & Admin** and then select **Service Accounts**.  
4. **Create a Service Account (if you don't have one):**  
    - Click on **+ Create Service Account** at the top.  
    - Enter a **Service account name**.  
    - The **Service account ID** will be generated automatically; you can edit it if needed.  
    - Add a **Service account description** (optional).  
    - Click **Create and Continue**.  
    - Under **Grant this service account access to project**, you can assign roles to your service account to grant it necessary permissions. For example, if you are using Cloud Vision API, you might want to grant the "Cloud Vision API User" role. You can add multiple roles by clicking **+ Add another role**.  
    - Click **Continue**.  
    - Under **Grant users and groups access to this service account**, you can add users or groups who can impersonate this service account (optional).  
    - Click **Done**.  
5. **Create and Download the Key:**  
    - Find the service account you just created (or an existing one you want to use) in the list.  
    - Click on the three vertical dots (Actions) on the right side of the service account.  
    - Select **Manage keys**.  
    - Click on **Add Key** and then **Create new key**.  
    - In the **Key type** dialog, select **JSON**.  
    - Click **Create**.  
    - A JSON file containing your service account's private key will be downloaded to your computer. **This is the only time you can download this key, so store it securely.** Take note of where you save this file.  
    - Click **Close**.

### Step 2: Set the `GOOGLE_APPLICATION_CREDENTIALS` Environment Variable

This involves actions on your local computer and within VS Code.

1. **Determine the Path to Your JSON Key File:** Locate the JSON file you downloaded in the previous step and note its full file path on your computer. For example, it might be something like `/Users/your_username/Downloads/your-project-id-xxxxxxxxx-xxxxxxxxxx.json` on macOS/Linux or `C:\Users\Your Username\Downloads\your-project-id-xxxxxxxxx-xxxxxxxxxx.json` on Windows.

2. **Set the Environment Variable:** You have a few options for setting this environment variable:

    **Option 1: Set it in your operating system (Recommended for system-wide access):**

    - **macOS/Linux:**
      - Open your terminal.
      - You can set the variable for the current session using the `export` command:
         ```sh
         export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/downloaded/key.json"
         ```
      - Replace `"/path/to/your/downloaded/key.json"` with the actual path to your JSON file.
      - To make this permanent across sessions, add this line to your shell's configuration file (e.g., `.bashrc`, `.zshrc`). Open the file in a text editor and add the `export` command at the end, then save and close the file. You might need to run `source ~/.bashrc` or `source ~/.zshrc` in your terminal to apply the changes to the current session.

    - **Windows:**
      - Open the Start Menu and search for "environment variables".
      - Select "Edit the system environment variables".
      - In the System Properties dialog, click the "Environment Variables..." button.
      - Under "User variables for [Your Username]" or "System variables", click "New...".
      - Enter `GOOGLE_APPLICATION_CREDENTIALS` as the **Variable name**.
      - Enter the full path to your downloaded JSON file as the **Variable value**.
      - Click **OK** on all open dialogs to save the changes. You might need to restart VS Code or your computer for the changes to take effect.

    **Option 2: Set it within VS Code (for project-specific access):**

    - Open your project in VS Code.
    - Go to **Terminal > New Terminal** to open an integrated terminal.
    - In the terminal, use the `export` command (macOS/Linux) or the `set` command (Windows) to set the environment variable for the current VS Code session:

      **macOS/Linux:**
      ```sh
      export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/downloaded/key.json"
      ```

      **Windows:**
      ```sh
      set GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\your\downloaded\key.json"
      ```

    - This method sets the environment variable only for the current VS Code session and any processes run within its terminal.

    **Alternatively, you can set environment variables in your launch configuration (if you are debugging):**

    - Go to the Run and Debug view (Ctrl+Shift+D or Cmd+Shift+D).
    - If you don't have a `launch.json` file, click "create a launch.json file".
    - In your launch configuration, add an `"env"` section like this:

      ```json
      {
         "version": "0.2.0",
         "configurations": [
            {
              "name": "Python: Current File",
              "type": "python",
              "request": "launch",
              "program": "${file}",
              "console": "integratedTerminal",
              "env": {
                 "GOOGLE_APPLICATION_CREDENTIALS": "/path/to/your/downloaded/key.json"
              }
            }
         ]
      }
      ```

    - Replace `"/path/to/your/downloaded/key.json"` with the actual path. This will set the environment variable when you run or debug your code using this launch configuration.

3. **Verify the Environment Variable (Optional):**

    - **In the VS Code terminal:**  
      - **macOS/Linux:** `echo $GOOGLE_APPLICATION_CREDENTIALS`  
      - **Windows:** `echo %GOOGLE_APPLICATION_CREDENTIALS%`  
      - This should print the path to your JSON key file if the environment variable is set correctly for the current session.

Now, your VS Code environment should be able to find your Google Cloud service account credentials, allowing you to authenticate and use Google Cloud models in your projects. Remember to keep your JSON key file secure and avoid sharing it publicly.
