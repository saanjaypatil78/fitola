# Backend Integration - Testing Guide

This document provides a comprehensive testing guide for the backend integration phase.

## Pre-requisites

1. Backend API running at `https://fitola.vercel.app` or locally
2. Flutter mobile app configured with correct API_BASE_URL
3. Supabase credentials configured (for authentication)
4. Valid Gemini API key (for AI features)

## Test Scenarios

### 1. Authentication Flow

#### Email/Password Registration
1. Open the app
2. Click "Sign Up"
3. Enter email, password, and name
4. Submit registration
5. **Expected**: User registered, auto-login, redirect to home

#### Email/Password Login
1. Open the app
2. Click "Login"
3. Enter registered email and password
4. Submit login
5. **Expected**: Successful login, redirect to home

#### Google OAuth
1. Open the app
2. Click "Sign in with Google"
3. Select Google account
4. Authorize app
5. **Expected**: Successful login, redirect to home

#### Auto-Login
1. Close app after successful login
2. Reopen app
3. **Expected**: Auto-login without credentials prompt

#### Logout
1. Navigate to profile/settings
2. Click logout
3. **Expected**: Return to login screen, token cleared

### 2. User Profile Management

#### View Profile
1. Login successfully
2. Navigate to profile screen
3. **Expected**: Display user data (name, email, weight, height, goals)

#### Update Profile
1. Navigate to profile screen
2. Click edit
3. Update fields (weight, height, goals, etc.)
4. Save changes
5. **Expected**: Profile updated, changes reflected immediately

#### BMI Calculation
1. Navigate to profile or health screen
2. Enter/verify weight and height
3. Click calculate BMI
4. **Expected**: Display BMI value and category (Underweight/Normal/Overweight/Obese)

### 3. Chat & Messaging (REST-based)

#### View Conversations List
1. Login successfully
2. Navigate to chat screen
3. **Expected**: List of conversations (may be empty for new users)

#### Send Message
1. Open a conversation or start new one
2. Type a message
3. Click send
4. **Expected**: Message sent, appears in conversation

#### Receive Message (Polling)
1. Have another user send you a message
2. Wait up to 5 seconds (polling interval)
3. **Expected**: New message appears in conversation list

#### Message Translation
1. Open a conversation
2. Type a message
3. Enable translation
4. Send message
5. **Expected**: Message translated to target language

#### Send Chat Request
1. Navigate to map/discovery
2. Find a nearby FitBuddy
3. Click "Send Chat Request"
4. **Expected**: Request sent successfully

#### Accept Chat Request
1. Receive a chat request notification
2. Click "Accept"
3. **Expected**: Conversation created, can now chat

### 4. FitBuddy Discovery & Location

#### Find Nearby FitBuddies
1. Grant location permission
2. Navigate to map screen
3. Wait for location fetch
4. **Expected**: Map shows current location, nearby FitBuddies displayed

#### Filter by Radius
1. On map screen
2. Select radius (5km, 10km, 25km, 50km)
3. **Expected**: Map updates with FitBuddies within selected radius

#### Share Live Location
1. Open a conversation
2. Click location share button
3. Set duration (15min, 30min, 1hr)
4. Confirm sharing
5. **Expected**: Location shared, updates every 10 seconds

#### Stop Location Sharing
1. While sharing location
2. Click "Stop Sharing"
3. **Expected**: Location sharing stopped, notification sent

#### Ghost Mode
1. Navigate to status FAB
2. Enable Ghost Mode
3. **Expected**: Hidden from map, status shown as "Ghost"

### 5. AI Features

#### Chat with AI
1. Navigate to AI chat screen
2. Type a fitness question
3. Send message
4. **Expected**: AI responds with personalized advice

#### Generate Fitness Plan
1. Navigate to plans screen
2. Click "Generate Fitness Plan"
3. Fill in details (age, weight, height, goals)
4. Submit
5. **Expected**: AI generates personalized workout plan

#### Generate Nutrition Plan
1. Navigate to plans screen
2. Click "Generate Nutrition Plan"
3. Fill in details (age, weight, city, allergies, goals)
4. Submit
5. **Expected**: AI generates personalized meal plan

### 6. Leaderboard

#### View Global Leaderboard
1. Navigate to competition/leaderboard screen
2. Select "Global" tab
3. **Expected**: Display top 50 global users with points

#### View National Leaderboard
1. On leaderboard screen
2. Select "National" tab
3. Choose country
4. **Expected**: Display top users from selected country

#### View Friends Leaderboard
1. On leaderboard screen
2. Select "Friends" tab
3. **Expected**: Display your friends' rankings

#### Pagination
1. On any leaderboard
2. Scroll to bottom
3. **Expected**: Load next 50 entries

## Error Handling Tests

### Network Errors

#### No Internet Connection
1. Disable internet connection
2. Try any API operation
3. **Expected**: Error message "Network error", auto-retry 3 times

#### Timeout
1. Set very slow network (airplane mode toggle)
2. Try any API operation
3. **Expected**: Timeout after 30 seconds, retry 3 times

### Authentication Errors

#### Invalid Credentials
1. Try login with wrong password
2. **Expected**: Error message "Invalid credentials"

#### Expired Token
1. Manually expire auth token
2. Try any API operation
3. **Expected**: Error "Unauthorized", redirect to login

### Validation Errors

#### Invalid Email
1. Try registration with invalid email format
2. **Expected**: Error message "Invalid email format"

#### Missing Required Fields
1. Try profile update without required fields
2. **Expected**: Error message listing missing fields

## Performance Tests

### Polling Performance
1. Leave chat screen open for 5 minutes
2. Monitor network requests
3. **Expected**: Polling requests every 5 seconds, no memory leaks

### Location Updates
1. Enable live location sharing
2. Move around
3. **Expected**: Location updates every 10 seconds without lag

### Map Performance
1. Load map with 50+ nearby FitBuddies
2. Pan and zoom
3. **Expected**: Smooth performance, no lag

## Security Tests

### Token Management
1. Login successfully
2. Check secure storage for token
3. Logout
4. Check token is cleared
5. **Expected**: Token securely stored and cleared

### API Authentication
1. Try API request without token
2. **Expected**: 401 Unauthorized error

## Monitoring

### Check for:
- Memory leaks during polling
- Battery drain from location services
- Network usage from polling
- App responsiveness during API calls
- Error message clarity

## Known Issues to Watch For

1. **Polling Delay**: Up to 5-second delay for new messages
2. **Location Accuracy**: May vary based on device GPS
3. **AI Response Time**: May take 5-10 seconds for plan generation
4. **First Load Slow**: Initial API calls may be slower (cold start)

## Debugging and Logs

The app does not expose a dedicated `debugMode` flag for logging. To collect logs during testing, run the app in a debug build and use the standard Flutter and platform tools:

- Run the app with verbose logging:
  ```bash
  flutter run -v
  ```
- For a no-subscription live preview in a browser:
  ```bash
  flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
  ```
## Success Criteria

✅ All authentication methods work
✅ Profile CRUD operations successful
✅ Messages sent and received (with polling delay)
✅ FitBuddies discovered within radius
✅ AI plans generated successfully
✅ Leaderboards load and paginate
✅ Errors handled gracefully with retry
✅ No crashes or memory leaks
✅ Acceptable performance (<5s for most operations)

## Troubleshooting

### "Network error" always shows
- Check API_BASE_URL is correct
- Verify backend is running
- Check device internet connection

### "Unauthorized" error
- Verify Supabase credentials
- Check token not expired
- Try logout and login again

### Messages not appearing
- Wait 5 seconds for polling
- Check conversation list refreshes
- Verify both users in conversation

### Map empty
- Grant location permissions
- Check GPS is enabled
- Verify backend has test data

### AI not responding
- Verify Gemini API key configured
- Check backend logs for errors
- Try simpler prompts first
