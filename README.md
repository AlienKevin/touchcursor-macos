# TouchCursor on MacOS

Speed up text edits and navigations by using the space bar as a modifier key (while still letting you type spaces).

TouchCursor allows you to use letter keys as navigation keys if you hold down the space bar at the same time:

| letter | navigation |
|-------|----------|
| i | up |
| k | down |
| j | left |
| l | right |
| p | backward delete (most used) |
| m | forward delete |
| h | return |
| u | home |
| o | end |

# Installation

1. TouchCursor relies on the open source automation tool Hammerspoon to operate. If you already have it installed, skip to the next step.
    * [Install Hammerspoon from GitHub](https://github.com/Hammerspoon/hammerspoon/releases/latest)
    * Open Hammerspoon and it will start running in background
    * Click on the Hammerspoon icon on the top tool bar and select `Preferences`
    * You need to enable accessibility for Hammerspoon to function, so click on the `Enable Accessibility` button to enable it in System Preferences
2. Download or clone this repository
3. Inside the repo folder, double click on `TouchCursor.spoon` to add TouchCursor to Hammerspoon
4. Click on the Hammerspoon icon on the top tool bar and select `Open Config`. The configuration file will be open in your text editor
5. Inside the file, paste the following command to activiate TouchCursor:
    ```lua
    hs.loadSpoon("TouchCursor")
    ```
6. Click on the Hammerspoon icon on the top tool bar and select `Reload Config` to run TouchCursor

# Launch at login
You can enable TouchCursor every time at login by going to the `Preferences` of Hammerspoon and check `Launch Hammerspoon at login`.

# Credits
Ported from [TouchCursor on Windows](https://martin-stone.github.io/touchcursor/overview.html) by Martin Stone

# License
GPL-3.0
