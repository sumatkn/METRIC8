# Compatibility and verification

Reviewed Forever 1.60.1 build 71037, interface 16001, on November 21, 2026. The Forever UI export still points to the November 20 baseline. The supplied frame stack identifies Blizzard_SharedXML/HelpTip.lua and an anchor on TalentMicroButton.

The [micro menu](https://github.com/Gethe/wow-ui-source/blob/734f065329cff4992835b01a84f210a297db91b6/Interface/AddOns/Blizzard_MicroMenu/Mainline/MainMenuBarMicroButtons.lua) shows the localized message in the MicroButtons system and records the active button after HelpTip:Show returns. The [Forever overrides](https://github.com/Gethe/wow-ui-source/blob/734f065329cff4992835b01a84f210a297db91b6/Interface/AddOns/Blizzard_MicroMenu/Camelot/MainMenuBarMicroButtonsOverrides.lua) identify the separate TalentMicroButton. NoTHX hooks the completed alert call and asks [HelpTip](https://github.com/Gethe/wow-ui-source/blob/734f065329cff4992835b01a84f210a297db91b6/Interface/AddOns/Blizzard_SharedXML/HelpTip.lua) to close matching system and text. The nonempty-text guard matters because nil matches every tip in a system. The sole saved preference is account-wide. Settings initialize on this addon's ADDON_LOADED event.

On November 21, 2026, the maintainer confirmed NoTHX 0.1.0 worked in game. Individual test steps were not reported.

For future regression checks, reload with an unspent point, gain another point, hover the talent button, and open talents. Check that the bubble stays gone, the point remains spendable, and an unrelated help tip still appears.

Local Lua mock checks passed for default and saved-off startup, repeat alerts, unrelated alerts, both checkbox states, and window reopening. Full Forever simulator startup stopped during Blizzard UI cache initialization before the addon loaded. The installed game manifest lists 1.60.1.71037.
