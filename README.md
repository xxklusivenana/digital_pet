# Digital Pet State State Lab
Digital pet simulation.
This app gives clear feedback when the pet is fed, played with, or left over time.

## Team Members & Roles
| **Janiya Green** | **Iyana Halliburton** |
|------------------|-----------------------|
|Project Coordinator & State Owner|UI Owner & Quality Reviwer|
|Care Systems|Pet Personality|



## Setup, Build, and Test Commands

flutter run

flutter build apk --release

flutter test

## Pathway/Features
Care Systems
Feed, Play, Rest, and Reset interactions
Happiness, hunger, and energy meters
Hunger timer
Three-minute happiness win condition
Game Over condition
Bounded meter values from 0–100

Pet Personality
Custom pet name
Derived pet messages
Mood label and mood feedback
Mood color tint based on happiness
Animated pet feedback
Animated meter feedback

## Feature to outcome Rubric map

## Screenshots & Test Evidence
// ![Alt text](assets/screenshot.png)

## Assets Liscenses
The pet image asset is included in the project under the assets/ directory.

Free Stock Image. Free use. 

## Issue/PR Links

https://github.com/xxklusivenana/digital_pet/edit/team-2/pet-personality/README.md



## Test Evidence

Note: All screenshots and test video in /evidence folder
### Test: Feed at hunger 5; feed at hunger 95
Expected: Hunger stays between 0–100 and the documented happiness rule is applied.
Result: Good
Before Value: 95 -- After = 85
Before Value: 5 -- After = 0
Evidence: Screenshots involving before and after low/high hunger test

### Play at happiness 95; if Energy is selected, play at energy 5
Expected: All implemented meters stay within 0–100; the documented limit rule is applied and the UI explains the result.
Result: Good
Before: 95 -- After= 100
Before: 5 -- After= 5
Evidence: Screenshots involving before and after happiness

### Happiness at 29, 30, 70, and 71
Expected: 29 is unhappy/red; 30–70 is neutral/yellow; 71 is happy/green. Text communicates mood without color alone.
Result: Happy = 29 -- Outcome: Red, Mood:Unhappy
Result: Happy = 30 -- Outcome: Yellow, Mood:Neutral
Result: Happy = 70 -- Outcome: Yellow, Mood:Neutral
Result: Happy = 71 -- Outcome: Green, Mood:Happy
Evidence: Screenshots involving state recording at "normal", "Mood under 30", and "30-mood-70_test".

### Happiness stays above 80 for 2:59, then drops to 80
Test: Keep happiness above 80 for 3 minutes.
Expected: No win; the pending win timer is canceled and cleared.
Result: Good
Result: Did not win. Happiness level dropped before the 3 minutes. Timer cancelled
Evidence: Screenshots involving happiness at 2-59 and 3.

### Happiness rises above 80 again and stays there for 3:00
Expected: Win at three continuous minutes; the hunger timer stops.
Result: Good
Result: 80 remained for 3 minutes and won. Hunger timer stopped.
Evidence: Screenshots involving win-timer


### Hunger moves from 95 to 100, then receives another timer tick
Expected: The first tick reaches 100 without a happiness penalty; the next overflow tick clamps hunger and reduces happiness by 20.
Result: Good
Evidence: Screenshots stating before and after timer (hunger).

### Hunger reaches 100 and happiness reaches 10
Test: Hunger = 100 and happiness <= 10.
Expected: Game Over appears and care actions are disabled.
Result: Good
Result: Game Over appeared when hunger reached 100 while happiness was 10
Evidence: screenshots - Hunger Limits + game_over_hunger

## Leave the pet screen while the timer is active
Expected: Timer is canceled; no post-dispose update occurs.
Evidence: Screenshots stating before and after timer (hunger).
Result: Pet was left alone and the screen was exited. Timer stopped.
Result: Good
