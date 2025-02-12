# Project Overview

## Goal
Build a simple macOS Menu Bar app that fades the screen black while the 'Fade Screen' button is held down. 

## Core Features
- Menu Bar dropdown with two buttons:
    - Fade Screen: fades the screen black while the 'Fade Screen' button is held down
    - Preferences: opens the preferences window
- Preferences window inludes three buttons:
    - Speed: slider to set how fast the screen fade animation is (0.01 to 0.2 seconds)
    - Color: color picker to set the color of the screen fade
    - "made with love by oxremy": a hyperlink button that goes to "https://github.com/oxremy"

## Architecture

Using a **Model-View-Controller (MVC)** architecture. 

### 1. **Model**
The **Model** is responsible for managing the app’s data and logic. For this project:
   - **App State**: The state of the fade (whether it’s active, speed, color settings, etc.) would be stored here.
   - **Preferences**: The settings for fade speed and color, potentially stored in a local preferences file (like `UserDefaults`) to persist between app launches.
   - **Timer or Animation State**: Handles the animation or screen fade duration as defined by the user via the speed slider.
   - **Fade Logic**: The underlying logic of how the screen fades when the button is pressed (e.g., calculating transparency levels and animation intervals).

### 2. **View**
The **View** represents the user interface elements. These are the components users interact with.
   - **Menu Bar**: The app's icon in the menu bar and its dropdown that contains buttons like:
     - **Fade Screen**: A button that triggers the fade animation while pressed.
     - **Preferences**: A button to open the Preferences window.
   - **Preferences Window**: Contains UI elements like:
     - **Speed Slider**: Adjusts the fade speed.
     - **Color Picker**: Adjusts the color of the fade effect.
     - **Hyperlink ("made with love by oxremy")**: Opens the URL when clicked.

   The View will also be responsible for updating the fade animation and visual effects on the screen.

### 3. **Controller**
The **Controller** manages the flow of data between the Model and View. It acts as the intermediary and updates the UI based on changes to the Model and vice versa.
   - **Menu Bar Buttons**: When the user clicks on the Fade Screen or Preferences button, the controller handles the events:
     - **Fade Screen Button**: The controller handles the fade animation logic (controlling the start and stop of the fade effect based on the button's press state).
     - **Preferences Button**: Opens the Preferences window when clicked.
   - **Preferences Window Actions**: 
     - The controller listens for changes in the preferences (speed slider, color picker) and updates the Model with the new settings.
   - **Fade Logic**: The controller would also handle the start and end of the fade screen animation, adjusting the opacity or color as per the user’s preferences.

### Additional Considerations:
- **Animation Handling**: The fade screen feature would require some graphical animation, and leveraging **Core Animation** could be an efficient way to handle the smooth transition effect of fading to black or other user-defined colors.
  
- **Persistence**: Use **NSUserDefaults** or **App Settings** to persist preferences like speed and color settings, so the app doesn’t lose settings on restart.
