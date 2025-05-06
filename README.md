
## Quick Start Guide (Windows + VS Code)

Follow these steps to get CampusCart up and running with your own Firebase credentials.

----------

### 1. Download & Run
[Download the zip file](https://github.com/omarmeneam/Mobile-App/archive/refs/heads/main.zip)

Open in VS Code and run:
```
flutter pub get
```

----------

### 2. Create & Configure Firebase

1.  **Go to Firebase Console**  
    [https://console.firebase.google.com/](https://console.firebase.google.com/) → **Add project** → give it a name campuscart.
    
2.  **Register Your App**
    
    -   **Android**
        
        -   Package name: match `android/app/src/main/AndroidManifest.xml`
   
            
3.  **Download Config Files**
    
    -   `google-services.json` → place into `android/app/`
                
4.  **Generate `firebase_options.dart`**
    
    ```bash
    flutter pub add flutterfire_cli
    flutterfire configure --project YOUR_PROJECT_ID
    
    ```
    
    This creates `lib/firebase_options.dart` with your API keys.
    

> **Note:** API keys and service files are in `.gitignore`.  
> Each team member must repeat these steps to run the app locally.

----------

### 3. (Optional) Firebase CLI

If you plan to use emulators or deploy functions:

```bash
npm install -g firebase-tools
firebase login
firebase use --add YOUR_PROJECT_ID

```

----------


### 4. Run the App

 -   **VS Code:**
    
    1.  Ctrl+Shift+P → **Flutter: Select Device**
        
    2.  F5 (or Debug ▶️)
 -   **Terminal:**
    
   
    flutter run
    
  

----------

### Troubleshooting

-   **“Missing `firebase_options.dart`”** → re-run `flutterfire configure`.
    
-   **Build errors** → `flutter clean && flutter pub get`.
    
-   **Path issues on Windows** → keep project path short; avoid spaces.
    

----------
