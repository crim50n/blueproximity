### BlueProximity

This fork is based on the project https://github.com/tiktaalik-dev/blueproximity

> This software helps you add a little more security to your desktop. It does so by detecting one of your bluetooth devices, most likely your mobile phone, and keeping track of its distance.

#### Description from the original author

> If you move away from your computer and the distance is above a certain level for a given time, it automatically locks your desktop (or starts any other shell command you want).
>
> Once away your computer awaits its master back - if you are nearer than a given level for a set time your computer unlocks magically without any interaction (or starts any other shell command you want).
>
> See the `doc/` directory or the website which both contain a manual with screenshots.
>
> Please note that there might still some bugs, use the sourceforge site to keep track of them or tell me about new ones not mentioned there.
> Please read the whole manual - it's short enough, hopefully easy understandable and hey - it even got some pretty pictures in there too :-)

### Building and Running

Here are the different ways to build, install, and run the application.

#### Option 1: Build a Debian Package (.deb)

This method is recommended for Debian-based systems (like Ubuntu) to create a package for easy installation and management.

1.  To build a `.deb` package, run:
    ```bash
    make
    ```
2.  After the build process is complete, the package will be available in the `./build` directory.

---

#### Option 2: Install Directly to the System

This method installs the application files directly into your system directories, making it available from your application menu and via a terminal command.

1.  Install the required Python dependencies:
    ```bash
    pip install -r requirements.txt
    ```
2.  Run the installation with administrator privileges:
    ```bash
    sudo make install
    ```
    This will copy all necessary files, icons, desktop entries, and translations to the appropriate system locations.

3.  After installation, the application will be available as `blueproximity` in your application menu or can be launched from the terminal with the command:
    ```bash
    blueproximity
    ```

---

#### Option 3: Run from Source (Without Installation)

This method is ideal for testing, development, or running the application without modifying system files.

1.  Compile the translation files. This creates the necessary localization files.
    ```bash
    make locales
    ```
2.  The compiled files are placed in `build/LANG`. Move them to the project's root directory so the application can find them:
    ```bash
    mv build/LANG .
    ```
3.  Install the required Python dependencies:
    ```bash
    pip install -r requirements.txt
    ```
4.  Run the application directly:
    ```bash
    python3 proximity.py
    ```

### Release History

*   **1.4.0** - Upgrade to Python 3.11 and BLE support