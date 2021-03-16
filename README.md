# TouchCursor on MacOS

Speed up text edits and navigations by using the space bar as a modifier key (while still letting you type spaces).

## Basics

| keys | functionality |
|-------|----------|
| ␣ i | up (↑) |
| ␣ k | down (↓) |
| ␣ j | left (←) |
| ␣ l | right (→) |
| ␣ p | backward delete (⌫) |
| ␣ m | forward delete |
| ␣ h | return (↩) |
| ␣ u | home |
| ␣ o | end |
| ␣ q | escape (esc) |

## Advanced

### Character Level
| keys | functionality |
|-----|---------------|
| ␣ ⇧ j | Select one character to the left |
| ␣ ⇧ l | Select one character to the right |

### Word Level

| keys | functionality |
|-----|---------------|
| ␣ ⌥ j | Go to start of word |
| ␣ ⌥ l | Go to end of word |
| ␣ ⇧ ⌥ j | Select up to start of word |
| ␣ ⇧ ⌥ l | Select up to end of word |

### Line Level
| keys | functionality |
|-----|---------------|
| ␣ ⇧ u | Select up to start of line |
| ␣ ⇧ o | Select up to end of line |

### Page Level
| keys | functionality |
|-----|---------------|
| ␣ ⌘ i | Go to start of page |
| ␣ ⌘ k | Go to end of page |



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
