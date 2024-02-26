# Project Setup Guide

This guide outlines the steps to set up your project with CocoaPods for iOS development in Xcode and how to run a Node.js server with Yarn.

## Prerequisites

- Xcode (for iOS development)
- CocoaPods (for iOS dependencies)
- Node.js (for the server)
- Yarn (for managing Node.js packages)

## Setting Up iOS Project with CocoaPods

### 1. Install CocoaPods

If you haven't installed CocoaPods, open Terminal and run:

```bash
sudo gem install cocoapods
```

### 2. Install Dependencies

Run the following command in the terminal within your project directory:

```bash
pod install
```

This installs the specified dependencies and creates an `.xcworkspace` file. Use this file for all future development in Xcode.

### 3. Open Your Project in Xcode

Open the `.xcworkspace` file to start working on your project in Xcode.

## Running Swift Code on Xcode

- After opening your project in Xcode, you can build and run your project by pressing the `Run` button or using the shortcut `Cmd + R`.

## Setting Up and Running the Node.js Server with Yarn

### 1. Install required dependencies

To install dependencies, use:

```bash
yarn install
```

### 3. Start Your Node.js Server

To start your server, run:

```bash
yarn start
```

This will run your Node.js application as defined in the `start` script of your `package.json`.

## Video

For code execution watch the video:

[Click here to watch the video](https://auburn.app.box.com/file/1453907920667?s=odc4xnmec2sum03vxmtq3umjwh7fmshe)
