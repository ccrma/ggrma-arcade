@import "../ChuGUI/src/ChuGUI.ck"
@import "player.ck"
@import "npc.ck"
@import "dialogEngine.ck"
@import "radio.ck"
@import "../ui/dialogBox.ck"

public class DialogManager {
    Player @ _player;
    NPC @ _npc;

    string _npcAssets[0]; // NPC name -> asset path mapping
    string _currentNpcName;
    string _lastNpcName;

    DialogBox dialogBox;

    // Radio mechanic for dialogue choices
    RadioMechanic @ _radio;

    // Prompt state
    Prompt @ _currentPrompt;
    Prompt @ _firstPrompt; // saved for restart
    Prompt @ _lastChoicePrompt; // saved for continue

    int _deathTriggered;
    int _endTriggered;
    int _selectionShown;
    int _confirmedSelectionIdx;
    int _awaitingChoiceReveal;
    int _inTransition;
    int _pendingRadioActivation;

    fun DialogManager() {
        dialogBox.scale(1.0);
        dialogBox.text("...");
        -1 => _confirmedSelectionIdx;
    }

    fun void setRadio(RadioMechanic @ radio) {
        radio @=> _radio;
    }

    fun void setPlayer(Player @ p) {
        p @=> _player;
    }

    fun void setNpc(NPC @ n) {
        n @=> _npc;
    }

    fun void registerNpc(string name, string assetPath) {
        assetPath => _npcAssets[name];
    }

    fun void update(ChuGUI gui) {
        dialogBox.update(gui);

        // Activate radio once typewriter finishes showing the choice template
        if (_pendingRadioActivation && !dialogBox.isTyping()) {
            false => _pendingRadioActivation;
            if (_radio != null) _radio.activate();
        }
    }

    fun void showPlayer() {
        if (_player != null) _player.show();
    }

    fun void hidePlayer() {
        if (_player != null) _player.hide();
    }

    fun void showNpc() {
        if (_npc != null) _npc.show();
    }

    fun void hideNpc() {
        if (_npc != null) _npc.hide();
    }

    fun void setDialog(string speaker, string text) {
        dialogBox.speakerName(speaker);
        dialogBox.text(text);
    }

    fun void showDialog() {
        spork ~ dialogBox.show();
    }

    fun void hideDialog() {
        spork ~ dialogBox.hide();
    }

    fun DialogBox dialog() {
        return dialogBox;
    }

    fun Player player() {
        return _player;
    }

    fun NPC npc() {
        return _npc;
    }

    fun void playerSays(string text) {
        if (_player != null) {
            dialogBox.speakerName(_player.name());
            _player.highlight();
        }
        if (_npc != null) _npc.dim();
        if (_radio != null) spork ~ _radio.highlight();
        dialogBox.text(text);
    }

    fun void npcSays(string text) {
        if (_npc != null) {
            dialogBox.speakerName(_npc.name());
            _npc.highlight();
        }
        if (_player != null) _player.dim();
        if (_radio != null) spork ~ _radio.dim();
        dialogBox.text(text);
    }

    fun void narratorSays(string text) {
        dialogBox.speakerName("");
        if (_npc != null) _npc.dim();
        if (_player != null) _player.dim();
        if (_radio != null) spork ~ _radio.dim();
        dialogBox.text(text);
    }

    fun void clearSpeaker() {
        if (_player != null) _player.highlight();
        if (_npc != null) _npc.highlight();
    }

    // Prompt handling

    fun void startDialogue(Prompt prompts[]) {
        prompts[0] @=> _firstPrompt;
        prompts[0] @=> _currentPrompt;
        false => _deathTriggered;
        null @=> _lastChoicePrompt;

        // nocheckin azaday
        // prompts[30] @=> _currentPrompt;
        // prompts[150] @=> _currentPrompt;

        showCurrentPrompt();
    }


    fun string npcName(string name) {
        name.find(':') => int colonIdx;
        if (colonIdx >= 0) return name.substring(0, colonIdx);
        else return name;
    }

    // Blocking: transitions NPC portrait then shows text. Call via spork.
    fun void switchNpcAndSpeak(string assetPath, string text) {
        npcName(_npc.name()) => string name;
        npcName(_lastNpcName) => string lastName;

        if (lastName.trim() == name.trim() && lastName != "") {
            _npc.setAssetPath(assetPath);
        } else {
            _npc.transition(assetPath);
        }

        npcSays(text);
        false => _inTransition;
    }

    // Activates radio and shows response template for current prompt.
    fun void showChoices() {
        if (_radio == null || _currentPrompt == null) return;
        if (_currentPrompt.responses.size() <= 0) return;

        _currentPrompt @=> _lastChoicePrompt;

        string labels[0];
        for (int i; i < _currentPrompt.responses.size(); i++) {
            labels << _currentPrompt.responses[i].text;
        }
        _radio.setOptions(labels);

        if (_currentPrompt.responseTemplate.length() > 0) {
            _currentPrompt.responseTemplate.rfind("...") => int ellipsisIdx;
            playerSays(_currentPrompt.responseTemplate.substring(0, ellipsisIdx) + "...");
        }

        // Radio will be activated by update() once typewriter finishes
        true => _pendingRadioActivation;
    }

    fun int inTransition() {
        return _inTransition;
    }

    fun void showCurrentPrompt() {
        if (_currentPrompt == null) {
            clearSpeaker();

            if (_radio != null) _radio.deactivate();
            return;
        }

        // Always show prompt text (even when prompt has responses)
        if (_currentPrompt.speaker == Prompt.Speaker_NPC) {
            // Check if NPC identity needs to switch
            if (_currentPrompt.speakerName.length() > 0 && _currentPrompt.speakerName != _currentNpcName) {
                _currentPrompt.speakerName => _currentNpcName;
                if (_npc != null && _npcAssets.isInMap(_currentNpcName)) {
                    if (_npc.portrait.visible()) _npc.name() => _lastNpcName;
                    _npc.setName(_currentNpcName);
                    true => _inTransition;
                    spork ~ switchNpcAndSpeak(_npcAssets[_currentNpcName], _currentPrompt.text);
                } else {
                    npcSays(_currentPrompt.text);
                }
            } else {
                npcSays(_currentPrompt.text);
            }
        } else if (_currentPrompt.speaker == Prompt.Speaker_Player) {
            playerSays(_currentPrompt.text);
        } else if (_currentPrompt.speaker == Prompt.Speaker_Narrator) {
            narratorSays(_currentPrompt.text);
        }

        // If there are responses, wait for user to advance before showing choices
        if (_currentPrompt.responses.size() > 0) {
            true => _awaitingChoiceReveal;
        } else {
            false => _awaitingChoiceReveal;
            if (_radio != null) _radio.deactivate();
        }
    }

    fun void revealSelected() {
        if (_currentPrompt == null) return;
        if (_currentPrompt.responses.size() == 0) return;
        true => _selectionShown;

        _radio.getSelectedIndex() => int selectedIdx;
        selectedIdx => _confirmedSelectionIdx;
        _currentPrompt.responses[selectedIdx].text => string responseText;

        // Insert selection after "..."
        _currentPrompt.responseTemplate.find("...") => int ellipsisIdx;
        _currentPrompt.responseTemplate.substring(0, ellipsisIdx + 3) + " " +
            responseText.rtrim() +
            _currentPrompt.responseTemplate.substring(ellipsisIdx + 3) => string fullText;
        fullText.rtrim() => fullText;

        dialogBox.text(fullText, ellipsisIdx + 3);
    }

    fun void advanceDialogue() {
        if (_currentPrompt == null) return;

        // If NPC line was shown before choices, reveal choices now
        if (_awaitingChoiceReveal) {
            false => _awaitingChoiceReveal;
            showChoices();
            return;
        }

        if (_currentPrompt.responses.size() > 0) {
            if (_selectionShown) {
                // Check for death trigger on selected response
                if (_currentPrompt.responses[_confirmedSelectionIdx].next_tag == "die") {
                    true => _deathTriggered;
                    false => _selectionShown;
                    -1 => _confirmedSelectionIdx;
                    return;
                }
                // Selection already confirmed — advance using saved index
                _currentPrompt.responses[_confirmedSelectionIdx].next @=> _currentPrompt;
                false => _selectionShown;
                -1 => _confirmedSelectionIdx;
            } else if (_radio != null && _radio.hasSelection()) {
                // Show selection in dialog box, don't advance yet
                _radio.playSelectionSfx();
                _radio.deactivate();
                spork ~ revealSelected();
                return;
            } else {
                // Radio active but no selection — don't advance
                return;
            }
        } else {
            // Check for death trigger
            if (_currentPrompt.next_tag == "die") {
                true => _deathTriggered;
                return;
            }
            if (_currentPrompt.next_tag == "end") {
                true => _endTriggered;
                return;
            }
            _currentPrompt.next @=> _currentPrompt;
        }

        showCurrentPrompt();
    }

    // For Enter key: can advance including confirming radio selections
    fun int canAdvance() {
        if (_currentPrompt == null) return 0;
        if (_inTransition) return 0;
        if (_awaitingChoiceReveal) return 1;
        if (_selectionShown) {
            // Block until radio finishes deactivating to prevent spam advance
            if (_radio != null && _radio.isActive()) return 0;
            return 1;
        }
        if (_currentPrompt.responses.size() > 0) {
            if (_radio != null) {
                return _radio.hasSelection();
            }
            return 1;
        }
        return 1;
    }

    // For Space key: can advance everything except confirming radio selections
    fun int canAdvanceNonChoice() {
        if (_currentPrompt == null) return 0;
        if (_inTransition) return 0;
        if (_awaitingChoiceReveal) return 1;
        if (_selectionShown) {
            if (_radio != null && _radio.isActive()) return 0;
            return 1;
        }
        if (_currentPrompt.responses.size() == 0) return 1;
        return 0;
    }

    fun void skipTypewriter() {
        dialogBox.skipTypewriter();
    }

    fun int isTyping() {
        return dialogBox.isTyping();
    }

    fun int deathTriggered() {
        return _deathTriggered;
    }
    fun int endTriggered() {
        return _endTriggered;
    }

    fun void resetState() {
        false => _selectionShown;
        -1 => _confirmedSelectionIdx;
        false => _awaitingChoiceReveal;
        false => _inTransition;
        false => _pendingRadioActivation;
        false => _deathTriggered;
        false => _endTriggered;
        "" => _currentNpcName;
        "" => _lastNpcName;
    }

    fun void restartDialogue() {
        resetState();
        _firstPrompt @=> _currentPrompt;
        showCurrentPrompt();
    }

    fun void continueFromLastChoice() {
        resetState();
        if (_lastChoicePrompt != null) {
            _lastChoicePrompt @=> _currentPrompt;
        } else {
            _firstPrompt @=> _currentPrompt;
        }
        showCurrentPrompt();
    }
}
