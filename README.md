# QuitApp - Gamified Smoking Cessation iOS App

A native iOS app designed to help you quit smoking and vaping through evidence-based gamification, behavioral psychology, and game theory principles.

## Features

### 🎮 Gamification System
- **Level System (1-100)**: Progress through 5 tiers from Beginner to Immortal
- **XP & Achievements**: Earn XP for resisting cravings, completing challenges, and hitting milestones
- **Streak Tracking**: Build daily streaks with flame visualization and streak shields
- **Daily Challenges**: Complete 3 random challenges each day for bonus XP

### ❤️ Health Timeline
- **12 Major Milestones**: From 20 minutes to 5 years smoke-free
- **Real Health Benefits**: Track actual improvements in your body
- **Visual Progress**: See unlocked vs locked achievements
- **Educational**: Learn what's happening in your body at each stage

### 🆘 Craving Management
- **Panic Button**: Immediate support when cravings hit
- **Intensity Tracker**: Rate cravings from 1-10
- **Trigger Identification**: Identify what causes your cravings
- **Coping Techniques**: 10 evidence-based techniques with instructions
- **4-Minute Timer**: Ride out cravings with countdown support

### 💰 NRT Tracking
- **Product Management**: Track patches, gums, lozenges, sprays, inhalers
- **Nicotine Monitoring**: Log daily nicotine intake in mg
- **Cost Tracking**: Monitor NRT expenses
- **Net Savings Calculator**: See real savings (money saved - NRT costs)
- **Tapering Visualization**: Track nicotine reduction over time

### 📊 Comprehensive Stats
- **Live Counters**: Real-time tracking of time, money, cigarettes avoided
- **Life Regained**: See minutes of life regained (11 min per cigarette)
- **Craving Insights**: Analyze patterns, triggers, and success rates
- **Financial Projections**: Monthly and yearly savings estimates
- **Health Metrics**: Tar avoided, CO₂ avoided, and more

## Tech Stack

- **SwiftUI**: Modern, declarative UI framework
- **SwiftData**: iOS 17+ persistence layer
- **Combine**: Reactive programming for live updates
- **UserNotifications**: Motivational reminders and milestone alerts
- **Charts Framework**: Progress visualization

## Project Structure

```
QuitApp/
├── App/
│   └── QuitAppApp.swift          # App entry point with SwiftData setup
├── Models/
│   ├── UserProfile.swift         # User data and progress
│   ├── Craving.swift             # Craving logs
│   ├── Achievement.swift         # Achievement system
│   ├── NRTProduct.swift          # NRT product tracking
│   ├── NRTUsageLog.swift         # NRT usage logs
│   └── DailyChallenge.swift      # Daily challenges
├── ViewModels/
│   └── AppState.swift            # Shared app state (ObservableObject)
├── Views/
│   ├── MainTabView.swift         # Tab navigation
│   ├── Dashboard/                # Home screen with stats
│   ├── Health/                   # Health timeline
│   ├── Cravings/                 # Craving management
│   ├── Stats/                    # Statistics and graphs
│   ├── NRT/                      # NRT tracking
│   ├── Achievements/             # Achievement gallery
│   ├── Onboarding/               # Initial setup flow
│   └── Components/               # Reusable UI components
├── Services/
│   └── (Future: Notification, Analytics)
└── Utilities/
    ├── Constants.swift           # App constants and colors
    └── Extensions.swift          # Swift extensions
```

## Setup Instructions

### Prerequisites
- macOS 14.0 or later
- Xcode 15.0 or later
- iOS 17.0+ device or simulator

### Creating the Xcode Project

1. **Open Xcode** and create a new project:
   - File → New → Project
   - Select **iOS** → **App**
   - Click **Next**

2. **Configure the project**:
   - Product Name: `QuitApp`
   - Team: Select your Apple Developer team (or "None" for simulator only)
   - Organization Identifier: `com.yourname` (use your own)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None** (we're using SwiftData manually)
   - Click **Next** and choose `/home/avsharma/Documents/personal/quitapp` as the location
   - **IMPORTANT**: Uncheck "Create Git repository" (we're managing structure manually)

3. **Delete the default files**:
   - In Xcode's Project Navigator, delete `ContentView.swift`
   - Keep `QuitAppApp.swift` (we'll replace it)

4. **Add all source files to the project**:
   - In Finder, navigate to `/home/avsharma/Documents/personal/quitapp/QuitApp/`
   - Drag the following folders into Xcode's Project Navigator:
     - `App/`
     - `Models/`
     - `ViewModels/`
     - `Views/`
     - `Utilities/`
   - When prompted:
     - ✅ Check "Copy items if needed"
     - ✅ Select "Create groups"
     - ✅ Add to target: QuitApp

5. **Configure App Groups** (for Widget support later):
   - Select the QuitApp target in the project settings
   - Go to "Signing & Capabilities"
   - Click "+ Capability"
   - Add "App Groups"
   - Click "+" and create: `group.com.quitapp.shared`
   - (Replace `com.quitapp` with your org identifier)

### Building and Running

1. **Select a simulator or device**:
   - Choose iPhone 15 Pro or your physical device from the scheme selector

2. **Build the project**:
   - Press `Cmd + B` to build
   - Fix any errors (there shouldn't be any if all files are added correctly)

3. **Run the app**:
   - Press `Cmd + R` to run
   - The app will launch in the simulator or on your device

### Installing on Your Physical iPhone

1. **Connect your iPhone** to your Mac via USB

2. **Trust the computer** (if prompted on iPhone)

3. **Select your iPhone** as the build target in Xcode

4. **Configure signing**:
   - Select the QuitApp target
   - Go to "Signing & Capabilities"
   - Select your Team (you may need a free Apple Developer account)
   - Xcode will automatically create a provisioning profile

5. **Build and run** (Cmd + R)

6. **Trust the developer** on iPhone:
   - If you see "Untrusted Developer" on iPhone:
   - Go to Settings → General → VPN & Device Management
   - Tap your Apple ID
   - Tap "Trust"

7. **The app is now installed** on your iPhone!

## First Time Setup

When you first launch the app, you'll go through onboarding:

1. **Welcome Screen**: Overview of features
2. **Quit Date**: Set when you quit (or plan to quit)
3. **Product Type**: Choose cigarettes, vaping, or both
4. **Consumption**: Set daily cigarettes/sessions and cost

After onboarding, you'll see the main dashboard with:
- Your level and XP
- Live timer showing time smoke-free
- Money saved, cigarettes avoided, life regained
- Today's challenges
- Next health milestone

## Usage Tips

### Maximizing XP
- **Log cravings** when they happen (+20-70 XP per craving resisted)
- **Complete daily challenges** (+20-50 XP each)
- **Maintain your streak** (exponential XP bonuses)
- **Unlock achievements** (up to +25,000 XP)

### Craving Support
1. Tap the **orange emergency button** in the center of the tab bar
2. Rate your craving intensity
3. Identify the trigger
4. Choose a coping technique
5. Use the 4-minute timer to ride it out
6. Earn XP for resisting!

### NRT Tracking
1. Go to Settings → Manage NRT Products
2. Add your nicotine patches, gums, etc.
3. Log usage throughout the day
4. Monitor your nicotine tapering progress
5. See net savings (money saved - NRT costs)

## Customization

### Changing Quit Date
- Go to Settings → Profile
- Update your quit date
- All stats will recalculate

### Notification Settings
- Settings → Notifications
- Enable motivational reminders
- Set daily reminder time

## Troubleshooting

### Build Errors
- **"Cannot find type 'UserProfile'"**: Make sure all files in Models/ are added to the target
- **SwiftData errors**: Ensure you're using iOS 17.0+ deployment target
- **Missing symbols**: Clean build folder (Cmd + Shift + K) and rebuild

### Runtime Issues
- **App crashes on launch**: Check Console for SwiftData container errors
- **Data not persisting**: Ensure App Groups capability is configured
- **Timer not updating**: Restart the app (this is a simulator issue)

### Data Reset
If you want to start over:
- Settings → Reset All Data
- Or: Delete the app and reinstall

## Privacy & Data

- **All data is stored locally** on your device using SwiftData
- **No analytics or tracking** - your quit journey is completely private
- **No account required** - works offline
- **No data is sent anywhere** - everything stays on your iPhone

## Research Sources

This app's gamification and psychology is based on:
- JMIR: Gamification impact on smoking cessation
- Self-determination theory in health apps
- Game theory applied to addiction recovery
- CDC health recovery timelines

## Future Enhancements

Planned features:
- Home screen widget showing streak and stats
- Apple Watch companion app
- Export data to Health app
- Social features (optional accountability partners)
- Advanced charts and trends
- Customizable themes

## Support

For issues or questions:
- Check the troubleshooting section above
- Review the code comments for implementation details
- Modify the app to fit your needs (it's your personal app!)

## License

This is personal-use software created for educational and health purposes.
You're free to modify it for your own use.

---

## Quick Reference: File Manifest

**Must-have files for the app to work:**
- ✅ App/QuitAppApp.swift
- ✅ Models/UserProfile.swift
- ✅ Models/Craving.swift
- ✅ Models/Achievement.swift
- ✅ Models/NRTProduct.swift
- ✅ Models/DailyChallenge.swift
- ✅ ViewModels/AppState.swift
- ✅ Views/MainTabView.swift
- ✅ Views/Dashboard/DashboardView.swift
- ✅ Views/Onboarding/OnboardingView.swift
- ✅ Utilities/Constants.swift
- ✅ Utilities/Extensions.swift

**Component files (for UI):**
- Views/Components/GlassCard.swift
- Views/Components/ProgressRing.swift
- Views/Components/AnimatedCounter.swift
- Views/Components/StreakFlame.swift
- Views/Components/LevelBadge.swift

**Feature files:**
- Views/Health/HealthTimelineView.swift
- Views/Achievements/AchievementsGalleryView.swift
- Views/Cravings/CravingManagerView.swift
- Views/NRT/*.swift (all NRT tracking files)
- Views/Stats/StatsView.swift

Good luck on your quit journey! 🚭💪
