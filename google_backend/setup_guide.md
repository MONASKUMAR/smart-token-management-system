# Google Sheets & Apps Script Setup Guide

Follow these steps to set up your Google Sheets database and deploy the REST API backend for the **Smart Token Management System**. You can set it up manually using the web interface or automatically using the **clasp CLI** (Command Line Apps Script Projects).

---

## Approach A: Manual Web Setup

### Step 1: Create a Google Sheet
1. Open your browser and go to [Google Sheets](https://sheets.google.com).
2. Create a new blank spreadsheet and rename it to `Smart Token Database`.
3. Note: The backend script initializes the sheets ("Tokens" and "Settings") automatically on first launch.

### Step 2: Add the Apps Script Code
1. Click **Extensions** > **Apps Script**.
2. Erase any placeholder code in `Code.gs` and paste the contents of [code.gs](file:///c:/Projects/token%20project/google_backend/code.gs).
3. Click the **Save** icon.

### Step 3: Deploy as a Web App
1. Click **Deploy** > **New deployment**.
2. Click the gear icon and select **Web app**.
3. Configure the settings:
   - **Execute as**: **Me (your-email@gmail.com)**
   - **Who has access**: **Anyone**
4. Click **Deploy**, authorize permissions, and copy the resulting **Web app URL**.

---

## Approach B: Command Line Setup (clasp CLI)

Since your system has Node.js and npm installed, you can manage, push, and deploy this project directly from your terminal using Google's official **clasp** tool.

### Step 1: Install clasp dependencies locally
Run the following command inside your project directory to install clasp:
```bash
npm install
```

### Step 2: Enable Google Apps Script API
Before using clasp, you must enable the Apps Script API in your Google account settings:
1. Go to [https://script.google.com/home/usersettings](https://script.google.com/home/usersettings).
2. Toggle the **Google Apps Script API** status to **ON** (Enabled).

### Step 3: Log in to Google from terminal
Run this command to authenticate:
```bash
npx clasp login
```
This opens your browser. Select your Google account and grant access.

### Step 4: Link your spreadsheet script ID
1. Create a script by opening a Google Sheet and clicking **Extensions** > **Apps Script**.
2. Click **Project Settings** (gear icon on the left panel).
3. Copy the **Script ID** (a long alphanumeric string).
4. Open your local [.clasp.json](file:///c:/Projects/token%20project/.clasp.json) file and paste it:
   ```json
   {
     "scriptId": "YOUR_COPIED_SCRIPT_ID_HERE",
     "rootDir": "google_backend"
   }
   ```

### Step 5: Push and deploy
Run the following commands to upload your local files and deploy the Web App:
```bash
# Push local code (code.gs and appsscript.json) to Google
npm run clasp:push

# Deploy a new web app version
npm run clasp:deploy
```
The terminal will display the active deployment information and print the **Web app URL**. Copy this URL and paste it into your local frontend Settings screen!

---

## Troubleshooting clasp Updates
* If you edit [google_backend/code.gs](file:///c:/Projects/token%20project/google_backend/code.gs), compile and send updates using `npm run clasp:push`.
* Creating a new deployment via `npm run clasp:deploy` ensures Google runs the latest pushed version of your code.
