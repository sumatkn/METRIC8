# METRIC8: NoTHX

NoTHX automatically closes the green “You have unspent Talent points.” reminder attached to the talent micro button in WoW: Forever. It runs as soon as it loads. You can bank points and open the talent window normally.

## Install

Copy [METRIC8_NoTHX](src/METRIC8_NoTHX) into the Forever client’s `Interface/AddOns` folder and reload the UI. The TOC should sit directly inside `AddOns/METRIC8_NoTHX/`. Type `/nothx` to open the movable options window. The checkbox starts checked and is saved account-wide. Checking it dismisses an existing reminder immediately. Unchecking it allows the next reminder Blizzard issues. Escape or the close button closes the window.

[Compatibility and verification](docs/MEMORY.md)
