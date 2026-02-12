# 🎓 Study App

**Study App** is a flexible learning platform designed to empower students. Unlike traditional schools limited by fixed curriculums, Study App allows students to take control of their education.

**Our Mission:**

* **Learn Anything:** Students can pay for specific topics or full courses—whatever they need.
* **Choose Your Tutor:** Students select who teaches them based on their preferences.
* **Flexible Learning:** Students decide when, where, and how they learn—whether with a tutor or through self-paced study.
* **Stand Out:** We aim to make every student confident enough to stand up in front of their class and shine.

and don't be fucked with anything
---

## 🚀 How to Contribute

Welcome to the team! If this is your first time using GitHub or Flutter, don't worry. Follow these steps exactly, and you'll be coding in no time.

### **Phase 1: Get the Code (One-time Setup)**

**1. Fork the Repository**

* Look at the top-right corner of this page.
* Click the **Fork** button.
* This creates a *copy* of this project into your own GitHub account. This is your safe space to break things without affecting the main project!

**2. Clone Your Repository**

* Open your terminal (or Command Prompt/Git Bash).
* Run the command below (replace `YOUR-USERNAME` with your actual GitHub username):

```bash
# ⚠️ IMPORTANT: Clone YOUR fork, not the original hiyokun-d repo!
git clone https://github.com/YOUR-USERNAME/study-app.git

```

**3. Open in VS Code (or Project IDX)**

* Open VS Code.
* Go to **File > Open Folder**.
* Select the `study-app` folder you just downloaded.

---

### **Phase 2: How to Run the Project**

Before you start coding, let's make sure the app actually runs on your machine.

**1. Open the Terminal in VS Code**

* Press `Ctrl + `` (backtick) to open the terminal inside VS Code.

**2. Install Dependencies**

* Flutter needs to download all the libraries we are using (like google_fonts, http, etc.). Run this command:

```bash
flutter pub get

```

**3. Run the App**

* Make sure you have a device connected (or an emulator running).
* Check the bottom right of VS Code to see your connected device (e.g., "Chrome", "Pixel 5", "iPhone").
* Run this command:

```bash
flutter run

```

* *Tip:* If you just want to see it quickly without a heavy emulator, choose **Chrome** or **Edge** as your device.

---

### **Phase 3: Making Changes (The Workflow)**

**⚠️ NEVER work directly on the `main` branch!**
Always create a "branch" for your specific task. Think of a branch as a "parallel universe" where you can make changes safely.

**1. Create a New Branch**

* Before you write any code, create a branch with a name that describes what you are doing.
* *Example:* If you are making the login screen:

```bash
git checkout -b feature/login-screen

```

* *Example:* If you are fixing a typo:

```bash
git checkout -b fix/typo-on-home

```

**2. Write Your Code**

* Do your magic! Edit the files, save them, and test the app to make sure it works.

**3. Save Your Changes (Commit)**

* Once you are happy with your work, you need to save it to Git.
* First, add the files to the "staging area" (getting them ready):

```bash
git add .

```

* Next, commit them with a message explaining **what** you did:

```bash
git commit -m "Added the login button and styled the input fields"

```

**4. Upload Your Changes (Push)**

* Now, send your "parallel universe" branch to your GitHub:

```bash
git push origin feature/login-screen

```

---

### **Phase 4: Submitting Your Work (Pull Request)**

You've pushed your code to *your* GitHub, but now you need to get it into the *main* project.

1. Go to **your** GitHub repository (the one you forked).
2. You will see a yellow banner saying **"Compare & pull request"**. Click it!
3. Write a title and a short description of what you did.
* *Good Title:* "Added Login Screen UI"
* *Bad Title:* "Update"


4. Click **Create Pull Request**.
5. Wait for the team lead (hiyokun-d) to review your code. If everything is good, it will be merged!

---

### **💡 Troubleshooting (Read this if you're stuck)**

* **"Flutter command not found":** You haven't installed Flutter or added it to your PATH. Ask the group chat!
* **"Permission denied" when pushing:** You might be trying to push to the main repo instead of your fork. Check `git remote -v` to see where you are pushing.
* **App is red/error screen:** You might have a syntax error. Check the "Debug Console" in VS Code for red text.

**Happy Coding! 🚀**