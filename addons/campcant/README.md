# METRIC8: CampCant

Copy [METRIC8_CampCant](src/METRIC8_CampCant) into the Forever client's Interface/AddOns folder. Reload and type `/campcant`. The movable player opens at 316 × 104 UI units.

Click the song title to open the songbook. The second row switches racial cadence on or off. **Start** performs the first verse through the button's native /say macro. Each **Next Verse** click performs one more. The player hides during combat and returns afterward. The last verse stays visible until you press **Stop**. **Stop** ends the performance immediately and collapses the lyrics. You can also type `/campcant stop`. The player expands to fit the current verse while keeping its controls in place.

In the songbook, browse songs and verses with the arrows. Choose **Select song** to return to the player or **Rehearse privately** to step through the verses without sending chat. **New song** starts a draft. Enter a title and the first verse, then use **Add verse** to insert another. **Save song** stores it account-wide. **Edit a copy** lets you adapt a built-in. Each verse fits in one chat message (255 UTF-8 bytes).

The 16 built-ins follow the CampCant research songbook in order. Fifteen contain short lyric excerpts. The Traveler's Path is a reference entry with an editable copy because a verified transcription was unavailable. Use **Edit a copy** to build a longer performance. Custom songs are stored separately from the built-ins.
