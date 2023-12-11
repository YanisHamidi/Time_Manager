# TimeManager Mobile App 

## Overview

This mobile app is designed to complement the Time Manager web interfaces. It allows users to access the Time Manager system on their mobile devices, providing a convenient and on-the-go solution for managing and visualizing working time data.

## Getting Started

Before you start using this mobile app, make sure you have the following prerequisites in place:

- NodeJs


### Installation

To get started with the app, follow these steps:

1. Clone the repository to your local machine:

   ```bash
   $ git clone https://github.com/EpitechMscProPromo2025/T-POO-700-MPL_6.git
   $ cd timeManager-vue
   ```
2. Install the app's dependencies: 

   ```bash
    npm i
   ```

3. Add the platforms you want to target. For example, for Android:

   ```bash
       npx cap add android 
      ```
   
4. Open the native project in your preferred IDE:

    For Android:

    ```bash
    npx cap open android
    ```
    For ios:

    ```bash
    npx cap open ios
    ```

5. Run the app on your device or emulator:

    ```bash
    ionic cap run android
    ```