BASED SHOULD BE A BUTTON WITH A # QuitApp - Quick Start Guide

## TL;DR - Get the app running in 5 minutes

### Step 1: Create Xcode Project (2 min)
1. Open Xcode
2. File → New → Project
3. iOS → App → Next
4. Name: `QuitApp`, Interface: SwiftUI, Storage: None
5. Save to: `/home/avsharma/Documents/personal/quitapp`
6. Delete `ContentView.swift` from the project

### Step 2: Add Files to Xcode (2 min)
1. In Finder, go to `/home/avsharma/Documents/personal/quitapp/QuitApp/`
2. Drag these folders into Xcode's left sidebar:
   - `App/`
   - `Models/`
   - `ViewModels/`
   - `Views/`
   - `Utilities/`
3. When prompted: ✅ "Copy items" + ✅ "Create groups" + ✅ Add to target

### Step 3: Build & Run (1 min)
1. Select iPhone 15 Pro simulator (or your physical iPhone)
2. Press `Cmd + R` to run
3. Done! 🎉

---

## What You'll See

### First Launch: Onboarding
1. Welcome screen with feature overview
2. Set your quit date (past or future)
3. Choose what you're quitting (cigarettes/vaping/both)
4. Enter daily consumption and cost per pack

### Main App: 5 Tabs

#### 1. 🏠 Home (Dashboard)
- **Level ring** showing your progress
- **Live timer** counting up from quit date
- **Quick stats**: money saved, cigarettes avoided, life regained
- **Today's challenges**: 3 daily tasks for bonus XP
- **Next milestone** preview

#### 2. ❤️ Health Timeline
- **12 milestones** from 20 minutes to 5 years
- See **unlocked achievements** (green checkmark)
- Track **next achievement** with progress bar
- Tap any milestone to see health benefits

#### 3. 🆘 Craving Button (Center, Orange)
**The Panic Button** - Tap when you're having a craving:
1. Rate intensity (1-10)
2. Identify trigger (stress, boredom, etc.)
3. Choose coping technique (breathing, water, walk, etc.)
4. Use 4-minute countdown timer
5. Log victory + earn XP!

#### 4. 📊 Stats
- **Overview**: days smoke-free, streak, level, XP
- **Craving insights**: total logged, most common trigger, average intensity
- **Financial**: money saved, NRT costs, net savings, projections
- **Health**: life regained, tar avoided, CO₂ avoided

#### 5. 🏆 Achievements
- **Gallery view** of all 12 health milestones
- **Unlocked** achievements are colorful
- **Locked** achievements show what's coming
- Tap unlocked ones to see details

---

## Key Features to Try

### Earn XP Fast
- ✅ Log a craving (Craving button) = **+20-70 XP**
- ✅ Complete a daily challenge = **+20-50 XP**
- ✅ Maintain your streak = **bonus XP daily**
- ✅ Unlock achievements = **up to +25,000 XP**

### Track NRT (Optional)
If you're using nicotine patches, gums, etc.:
1. Settings → Manage NRT Products
2. Add your products (type, nicotine mg, cost)
3. Log usage throughout the day
4. See **net savings** (money saved - NRT costs)

### Build Streaks
- Check in daily to maintain your streak
- Earn **streak shields** through challenges
- Shields protect you if you miss a day
- See your **flame animation** grow stronger

---

## Troubleshooting

### "Cannot find type 'UserProfile'" error
→ Make sure ALL folders (App, Models, ViewModels, Views, Utilities) are added to the Xcode project

### App crashes on first launch
→ Check you're using **iOS 17.0+** simulator/device (SwiftData requirement)

### Timer not updating in simulator
→ This is a simulator quirk - works fine on real devices

### Want to reset and start over?
→ Settings (gear icon) → Reset All Data

---

## Tips for Success

1. **Log every craving** - The act of logging helps you resist + you earn XP
2. **Check daily challenges** - Easy XP boost every day
3. **Watch the health timeline** - Seeing your body heal is motivating
4. **Track NRT if using** - See your nicotine tapering progress
5. **Build streaks** - The flame visualization is surprisingly powerful

---

## Installing on Your iPhone

1. Connect iPhone to Mac via USB
2. Select your iPhone in Xcode (top toolbar)
3. Go to Signing & Capabilities → Select your Team
4. Press `Cmd + R` to run
5. On iPhone: Settings → General → VPN & Device Management → Trust
6. Done! App is now installed on your iPhone

---

## What's Built

✅ Full gamification system (levels 1-100, XP, achievements)
✅ Health timeline with 12 real milestones
✅ Craving management with panic button
✅ NRT tracking (patches, gums, lozenges, sprays, inhalers)
✅ Comprehensive stats and insights
✅ Daily challenges system
✅ Streak tracking with shields
✅ Live counters (time, money, cigarettes)
✅ Dark mode UI with smooth animations
✅ All data stored locally (private)

---

## Next Steps

After you get it running:
1. **Customize it** - Edit colors in `Utilities/Constants.swift`
2. **Add features** - Widget, Apple Watch, Health app integration
3. **Share with friends** - Help others quit too!

---

**Remember**: This is YOUR personal app for YOUR quit journey. No tracking, no accounts, no BS. Just you vs. the addiction. You got this! 💪

Good luck! 🚭
