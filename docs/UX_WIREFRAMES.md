# Fitola - UX Wireframes & Design Specifications

## Table of Contents
1. [Design Philosophy](#design-philosophy)
2. [Color Palette](#color-palette)
3. [Typography](#typography)
4. [Screen Flow Diagrams](#screen-flow-diagrams)
5. [Wireframe Descriptions](#wireframe-descriptions)
6. [Interaction Patterns](#interaction-patterns)
7. [Animation Specifications](#animation-specifications)
8. [Accessibility Guidelines](#accessibility-guidelines)

## Design Philosophy

### Core Principles
1. **Simplicity**: Clean, uncluttered interfaces that focus on user tasks
2. **Consistency**: Uniform patterns and behaviors across all screens
3. **Feedback**: Immediate visual feedback for all user actions
4. **Accessibility**: Inclusive design for users of all abilities
5. **Delight**: Subtle animations and interactions that create joy

### Design Language
- **Modern & Friendly**: Rounded corners, soft shadows, vibrant colors
- **Data-Driven**: Charts and visualizations to show progress
- **Social**: Profile pictures, status indicators, connection cues
- **Mobile-First**: Touch-friendly targets, thumb-zone optimization

## Color Palette

### Primary Colors
```
Primary Purple:   #6C63FF (Used for primary actions, branding)
Secondary Green:  #4CAF50 (Success, health indicators)
```

### Gender-Specific Colors
```
Female Pink:      #FF69B4
Male Blue:        #2196F3
Other Purple:     #9C27B0
```

### Status Colors
```
Available Green:  #66BB6A
Busy Orange:      #FFA726
Ghost Gray:       #9E9E9E
```

### Semantic Colors
```
Success:          #4CAF50
Error:            #F44336
Warning:          #FF9800
Info:             #2196F3
```

### Neutral Colors
```
Text Primary:     #212121
Text Secondary:   #757575
Text Hint:        #BDBDBD
Background Light: #FAFAFA
Background Dark:  #121212
Surface Light:    #FFFFFF
Surface Dark:     #1E1E1E
```

## Typography

### Font Family
- **Primary**: Poppins (Google Fonts)
- **Fallback**: System fonts (San Francisco on iOS, Roboto on Android)

### Type Scale
```
Display Large:    32px / Bold   - Hero titles
Display Medium:   28px / Bold   - Section headers
Display Small:    24px / Bold   - Card titles
Headline Medium:  20px / SemiBold - Subsection headers
Headline Small:   18px / SemiBold - List headers
Title Large:      16px / SemiBold - Button text, labels
Body Large:       16px / Regular  - Primary content
Body Medium:      14px / Regular  - Secondary content
Body Small:       12px / Regular  - Captions, timestamps
```

## Screen Flow Diagrams

### Onboarding Flow
```
Splash Screen
    ↓
Language Selection
    ↓
User Information (Name, Email, Password/Google)
    ↓
Body Metrics (Age, Weight, Height, Gender)
    ↓
City & Allergies
    ↓
Body Type Selection
    ↓
Goals & Duration
    ↓
Competition Opt-In
    ↓
Login/Register
    ↓
Home Screen
```

### Main Navigation Flow
```
Home Screen
    ├── Dashboard
    ├── Chat List → Chat Detail → Voice/Video Call
    ├── FitBuddy Map → User Profile → Send Request
    ├── AI Trainer → Workout Plan / Nutrition Plan
    ├── Leaderboard → Rankings
    └── Profile → Settings
```

### Chat Flow
```
Chat List
    ↓
Select/Search User
    ↓
Chat Detail
    ├── Send Text Message
    ├── Send Image/Document
    ├── Send Voice Message
    ├── Share Location (Live/Static)
    ├── Translate Toggle
    └── Initiate Call → Voice/Video Call Screen
```

### Map Flow
```
FitBuddy Map
    ├── Change Radius Filter (5km/10km/25km/50km)
    ├── Status FAB → Change Status (Ghost/Available/Busy)
    ├── Tap Marker → View Profile → Send Chat Request
    └── My Location → Center Map on User
```

## Wireframe Descriptions

### 1. Splash Screen

**Layout:**
```
┌─────────────────────────┐
│                         │
│                         │
│     [Animated Logo]     │
│                         │
│       Fitola            │
│  AI Fitness Companion   │
│                         │
│    [Loading Spinner]    │
│                         │
│                         │
└─────────────────────────┘
```

**Elements:**
- Centered logo with fade-in animation
- App name in large, bold text
- Tagline below name
- Loading spinner at bottom

**Duration:** 2-3 seconds, auto-advance

---

### 2. Language Selection Screen

**Layout:**
```
┌─────────────────────────┐
│   [← Back]   Select     │
│              Language   │
├─────────────────────────┤
│                         │
│  Choose Your Preferred  │
│        Language         │
│                         │
│ ┌─────────────────────┐ │
│ │ ○ English (EN)      │ │
│ ├─────────────────────┤ │
│ │ ○ Spanish (ES)      │ │
│ ├─────────────────────┤ │
│ │ ● Hindi (HI)        │ │
│ ├─────────────────────┤ │
│ │ ○ French (FR)       │ │
│ └─────────────────────┘ │
│                         │
│  [Continue Button]      │
└─────────────────────────┘
```

**Elements:**
- AppBar with title
- Subtitle explaining purpose
- Scrollable list of languages with radio buttons
- Selected language highlighted
- Continue button at bottom

**Interactions:**
- Tap language to select
- Tap Continue to proceed

---

### 3. User Information Screen

**Layout:**
```
┌─────────────────────────┐
│   [← Back]  User Info   │
├─────────────────────────┤
│                         │
│  [Profile Picture]      │
│  Tap to upload          │
│                         │
│ ┌─────────────────────┐ │
│ │ Name: [_________]   │ │
│ ├─────────────────────┤ │
│ │ Email: [________]   │ │
│ ├─────────────────────┤ │
│ │ Password: [*****]   │ │
│ ├─────────────────────┤ │
│ │ OR                  │ │
│ │ [Sign in with Google│ │
│ └─────────────────────┘ │
│                         │
│ Age Group:              │
│ [Baby][Teen][Adult][Elder]│
│                         │
│ Weight: [70] [KG/LBS]   │
│ Height: [170] [CM/FT]   │
│                         │
│ Gender:                 │
│ [Male][Female][Other]   │
│                         │
│ City: [New York_____]   │
│                         │
│  [Continue Button]      │
└─────────────────────────┘
```

**Elements:**
- Profile picture upload area
- Text inputs for name, email, password
- Google sign-in button
- Chip selector for age group
- Weight/height inputs with unit toggles
- Gender selector chips
- City text input
- Continue button

**Validation:**
- Email format validation
- Password strength indicator
- Required field markers

---

### 4. Body Type Selection Screen

**Layout:**
```
┌─────────────────────────┐
│   [← Back]  Body Type   │
├─────────────────────────┤
│                         │
│   Select Your Body Type │
│                         │
│ ┌─────────────────────┐ │
│ │   Ectomorph    ⓘ   │ │
│ │  [Illustration]     │ │
│ │  Lean & Fast        │ │
│ │  Metabolism         │ │
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │   Mesomorph    ⓘ   │ │
│ │  [Illustration]     │ │
│ │  Athletic &         │ │
│ │  Muscular           │ │
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │   Endomorph    ⓘ   │ │
│ │  [Illustration]     │ │
│ │  Larger Bone        │ │
│ │  Structure          │ │
│ └─────────────────────┘ │
│                         │
│  [Continue Button]      │
└─────────────────────────┘
```

**Elements:**
- Title explaining selection
- Three cards for body types
- Illustrations for each type
- Info icons with tooltips
- Selected card has border/highlight
- Continue button

**Interactions:**
- Tap card to select
- Tap info icon for detailed explanation
- Swipe for carousel view (optional)

---

### 5. Goals & Duration Screen

**Layout:**
```
┌─────────────────────────┐
│   [← Back]  Goals       │
├─────────────────────────┤
│                         │
│  What are your goals?   │
│  (Select all that apply)│
│                         │
│ [Weight Loss]           │
│ [Muscle Gain]           │
│ [Maintain Health]       │
│ [Improve Flexibility]   │
│ [Increase Stamina]      │
│                         │
│  How long?              │
│  ┌──────────────────┐  │
│  │ ●────────○──────┘  │
│  └──────────────────┘  │
│  1 month  [3 months]   │
│  6 months  1 year       │
│                         │
│  Join 1-year competition?│
│  [Yes] [No]             │
│                         │
│  [Complete Onboarding]  │
└─────────────────────────┘
```

**Elements:**
- Multi-select goal chips
- Duration slider
- Competition opt-in toggle
- Complete button

**Interactions:**
- Tap chips to select/deselect
- Drag slider for duration
- Tap Yes/No for competition

---

### 6. Home Screen

**Layout:**
```
┌─────────────────────────┐
│ ☰  Fitola        [👤]  │
├─────────────────────────┤
│                         │
│  Good morning, John! 👋 │
│                         │
│ ┌─────────┬─────────┐  │
│ │Dashboard│  Chat   │  │
│ ├─────────┼─────────┤  │
│ │  Map    │AI Trainer│  │
│ ├─────────┼─────────┤  │
│ │Leader-  │ Profile │  │
│ │ board   │         │  │
│ └─────────┴─────────┘  │
│                         │
│  Today's Progress       │
│ ┌─────────────────────┐ │
│ │ Steps: 5,420/10,000 │ │
│ │ [Progress Bar]      │ │
│ ├─────────────────────┤ │
│ │ Calories: 350/2000  │ │
│ │ [Progress Bar]      │ │
│ └─────────────────────┘ │
│                         │
│  Quick Actions          │
│ [Start Workout] [Log Meal]│
│                         │
└─────────────────────────┘
```

**Elements:**
- Top app bar with menu and profile
- Greeting message
- Feature grid (6 main features)
- Today's progress card
- Quick action buttons

**Interactions:**
- Tap feature cards to navigate
- Tap profile picture for profile screen
- Swipe right for drawer menu

---

### 7. Chat List Screen

**Layout:**
```
┌─────────────────────────┐
│ [← Back]  Chats  [🔍]  │
├─────────────────────────┤
│                         │
│ ┌─────────────────────┐ │
│ │ [👤] Jane Doe       │ │
│ │     Last message... │ │
│ │            2m ago ● │ │
│ ├─────────────────────┤ │
│ │ [👤] John Smith     │ │
│ │     Typing...       │ │
│ │            Active 🟢│ │
│ ├─────────────────────┤ │
│ │ [👤] Sarah Lee      │ │
│ │     See you there!  │ │
│ │            1h ago   │ │
│ └─────────────────────┘ │
│                         │
│                         │
│                  [FAB]  │
└─────────────────────────┘
```

**Elements:**
- AppBar with search icon
- List of conversations
- Profile pictures
- Last message preview
- Timestamp or "Active" indicator
- Unread badge (red dot)
- Status/Translate FAB

**Interactions:**
- Tap conversation to open chat
- Swipe left for delete option
- Pull to refresh
- Tap FAB to toggle status/translation

---

### 8. Chat Detail Screen

**Layout:**
```
┌─────────────────────────┐
│ [← Back] Jane Doe [⚙️] │
│          Online 🟢      │
├─────────────────────────┤
│                         │
│        Hi! 👋           │
│        10:30 AM         │
│                         │
│              How are you?│
│              10:31 AM   │
│                         │
│     I'm great, thanks!  │
│        10:32 AM         │
│                         │
│            Want to workout│
│            together?    │
│            10:33 AM     │
│                         │
├─────────────────────────┤
│ [+] [Type message...][📤]│
└─────────────────────────┘
```

**Elements:**
- AppBar with user name and status
- Settings icon for call toggles
- Message bubbles (sent vs received)
- Timestamps
- Input field with attachment and send buttons
- Status/Translate FAB (floating)

**Interactions:**
- Tap + for attachments (image, document, voice, location)
- Tap message bubble to translate (if enabled)
- Long press for reply, forward, delete
- Tap settings for call preferences

---

### 9. FitBuddy Map Screen

**Layout:**
```
┌─────────────────────────┐
│ [← Back]  Map    [Filter]│
├─────────────────────────┤
│                         │
│         [Map View]      │
│    • • •   🔵(You)      │
│  • 💗      •           │
│       •  • •           │
│    •       •           │
│                         │
│ Radius: [5km] 10km 25km │
│                         │
│                  [FAB]  │
│              [My Location]│
└─────────────────────────┘
```

**Elements:**
- Interactive map
- User markers (pink/blue)
- Current user marker (blue with pulse)
- Radius filter chips
- Status/Translate FAB
- My Location button

**Interactions:**
- Pinch to zoom
- Drag to pan
- Tap marker to view profile
- Tap radius chip to change filter
- Tap FAB to change status
- Tap My Location to center map

---

### 10. User Profile Card (Bottom Sheet)

**Layout:**
```
┌─────────────────────────┐
│                         │
│     [Swipe Down]        │
│                         │
│   [Profile Picture]     │
│   Jane Doe, 28          │
│   📍 2.5 km away        │
│                         │
│   Goals:                │
│   • Weight Loss         │
│   • Flexibility         │
│                         │
│   Interests:            │
│   Yoga, Running, Hiking │
│                         │
│   [Send Chat Request]   │
│                         │
│   [Report] [Block]      │
└─────────────────────────┘
```

**Elements:**
- Drag handle at top
- Profile picture
- Name and age
- Distance badge
- Goals list
- Interests tags
- Send Chat Request button
- Report and Block links

**Interactions:**
- Swipe down to dismiss
- Tap Send Chat Request
- Tap Report/Block if needed

---

### 11. AI Trainer Screen

**Layout:**
```
┌─────────────────────────┐
│ [← Back]  AI Trainer    │
├─────────────────────────┤
│                         │
│  Your BMI               │
│ ┌─────────────────────┐ │
│ │   23.5 (Normal)     │ │
│ │   [Gauge Chart]     │ │
│ └─────────────────────┘ │
│                         │
│  Current Plan           │
│ ┌─────────────────────┐ │
│ │ 30-Day Weight Loss  │ │
│ │ Day 5/30            │ │
│ │ [Progress Bar 16%]  │ │
│ └─────────────────────┘ │
│                         │
│  [View Workout Plan]    │
│  [View Nutrition Plan]  │
│  [Generate New Plan]    │
│                         │
│  Chat with AI           │
│ ┌─────────────────────┐ │
│ │ [Message Input]     │ │
│ └─────────────────────┘ │
└─────────────────────────┘
```

**Elements:**
- BMI card with gauge visualization
- Current plan card with progress
- Action buttons
- AI chat interface

**Interactions:**
- Tap plan buttons to view details
- Tap Generate to create new plan
- Type message to chat with AI

---

### 12. Leaderboard Screen

**Layout:**
```
┌─────────────────────────┐
│ [← Back] Leaderboard    │
│ [Global][National][Friends]│
├─────────────────────────┤
│                         │
│ ┌─────────────────────┐ │
│ │  🥇 1. John Doe     │ │
│ │     1,500 pts       │ │
│ ├─────────────────────┤ │
│ │  🥈 2. Jane Smith   │ │
│ │     1,450 pts       │ │
│ ├─────────────────────┤ │
│ │  🥉 3. Bob Lee      │ │
│ │     1,400 pts       │ │
│ ├─────────────────────┤ │
│ │  4. Sarah Chen      │ │
│ │     1,200 pts       │ │
│ ├─────────────────────┤ │
│ │  ...                │ │
│ │  25. You            │ │
│ │     850 pts         │ │
│ └─────────────────────┘ │
│                         │
└─────────────────────────┘
```

**Elements:**
- Tab selector (Global/National/Friends)
- Ranked list with medals for top 3
- User's position highlighted
- Points display

**Interactions:**
- Switch tabs to view different leaderboards
- Scroll to see more users
- Tap user to view profile

---

## Interaction Patterns

### Navigation
- **Bottom Navigation**: For main sections (Home, Chat, Map, Profile)
- **AppBar Actions**: For screen-specific actions
- **Drawer**: For secondary navigation and settings
- **FAB**: For primary actions (Status, Send Message)

### Touch Targets
- **Minimum Size**: 44x44 dp (Apple HIG) / 48x48 dp (Material)
- **Spacing**: 8dp between touch targets
- **Thumb Zone**: Primary actions within easy thumb reach

### Gestures
- **Tap**: Primary action
- **Long Press**: Context menu, additional options
- **Swipe**: Delete, archive, dismiss
- **Pinch**: Zoom (maps, images)
- **Pull to Refresh**: Update content

### Feedback
- **Visual**: Button press states, color changes
- **Haptic**: Light tap for selections, medium for confirmations
- **Audio**: Optional sound effects for key actions

## Animation Specifications

### Durations
- **Fast**: 100-200ms (button press, toggle)
- **Normal**: 200-300ms (screen transitions, card expansion)
- **Slow**: 300-500ms (complex animations, page transitions)

### Curves
- **Linear**: Progress indicators
- **Ease In**: Elements leaving screen
- **Ease Out**: Elements entering screen
- **Ease In Out**: Elements moving on screen

### Specific Animations

#### Splash Screen Logo
- **Type**: Fade In + Scale
- **Duration**: 1000ms
- **Curve**: Ease Out
- **From**: opacity 0, scale 0.8
- **To**: opacity 1, scale 1

#### Screen Transitions
- **Type**: Slide + Fade
- **Duration**: 300ms
- **Curve**: Ease In Out
- **Direction**: Left to right (forward), right to left (back)

#### FAB Expansion
- **Type**: Scale + Rotation
- **Duration**: 300ms
- **Curve**: Ease Out
- **From**: scale 1, rotation 0°
- **To**: scale 1.5, rotation 45°

#### Status Change
- **Type**: Color Transition
- **Duration**: 200ms
- **Curve**: Linear
- **Effect**: Smooth color interpolation

#### Chat Bubble Appearance
- **Type**: Slide Up + Fade
- **Duration**: 200ms
- **Curve**: Ease Out
- **From**: translateY(20), opacity 0
- **To**: translateY(0), opacity 1

#### Loading States
- **Type**: Shimmer Effect
- **Duration**: 1000ms (loop)
- **Curve**: Linear
- **Effect**: Moving gradient across placeholder

#### Map Marker Pulse (Live Location)
- **Type**: Scale + Opacity
- **Duration**: 1500ms (loop)
- **Curve**: Ease In Out
- **From**: scale 1, opacity 1
- **To**: scale 1.3, opacity 0

## Accessibility Guidelines

### WCAG 2.1 Level AA Compliance

#### Color Contrast
- **Text**: 4.5:1 minimum for normal text
- **Large Text**: 3:1 minimum for 18pt+ or 14pt+ bold
- **UI Components**: 3:1 minimum for interactive elements

#### Typography
- **Font Size**: Minimum 14sp for body text
- **Line Height**: 1.5x font size for paragraphs
- **Line Length**: 50-75 characters max for readability

#### Touch Targets
- **Size**: Minimum 44x44 dp (iOS) / 48x48 dp (Android)
- **Spacing**: 8dp between adjacent targets

#### Screen Reader Support
- **Labels**: All interactive elements have semantic labels
- **Hints**: Describe what happens when element is activated
- **States**: Communicate element state (selected, disabled, etc.)
- **Focus Order**: Logical tab order for keyboard navigation

#### Alternative Text
- **Images**: Descriptive alt text for all meaningful images
- **Icons**: Labels for icon-only buttons
- **Charts**: Text alternatives for data visualizations

#### Keyboard Navigation
- **Tab Order**: Logical focus sequence
- **Shortcuts**: Common keyboard shortcuts supported
- **Focus Indicator**: Visible focus state for all interactive elements

### Dark Mode Support
- **Automatic**: Follows system preference
- **Manual Override**: User can force light/dark mode
- **Contrast**: Maintain contrast ratios in both modes
- **Colors**: Adjust all colors for dark background

### Motion Preferences
- **Reduced Motion**: Respect system preference
- **Disable Animations**: Option to disable decorative animations
- **Essential Motion**: Keep only critical animations (loading, progress)

### Text Scaling
- **Support**: 200% text size increase
- **Layout**: Responsive to text size changes
- **Truncation**: Ellipsis or wrapping for long text

---

**Document Version**: 1.0  
**Last Updated**: February 2026  
**Design Team**: Fitola UX Team
