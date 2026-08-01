# Batter-Invaders-game

A fun SpriteKit-based arcade game inspired by classic space invader gameplay. Defend your ship, shoot incoming aliens, collect gems, and survive as long as possible.

## Overview

Batter-Invaders-game is a simple 2D iOS game built with Swift and SpriteKit. The player controls a spaceship, fires bullets at enemies, collects gems for points, and tries to beat their high score before the timer runs out.

## Features

- Tap or touch to move the ship
- Shoot bullets at incoming aliens
- Collect gems to increase your score
- Track time left and high score
- Smooth scene transitions between start, gameplay, and game over screens

## Project Structure

- AppDelegate.swift – app lifecycle entry point
- Scenes/
  - GameScene.swift – main gameplay scene and game logic
  - StartGameScene.swift – start screen
  - GameOverScene.swift – game over screen
  - Bullet.swift – bullet sprite class
- View Controller/
  - GameViewController.swift – main view controller that presents the initial scene
- Storyboards/ – UI storyboard files
- Assets.xcassets/ – app assets and icons
- images/ – game artwork such as ship, alien, gem, galaxy, and bullet sprites

## Requirements

- Xcode
- iOS simulator or a physical iPhone/iPad
- Swift 5+

## How to Run

1. Open the Xcode project file:
   - Batter-Invaders-game.xcodeproj
2. Select a simulator or connected device.
3. Press Run in Xcode.

## Gameplay Instructions

- Touch anywhere on the screen to move the ship toward that position.
- Tapping fires bullets automatically.
- Avoid colliding with aliens.
- Collect gems to gain points.
- Try to survive until the timer ends and beat your high score.

## Customization Ideas

You can extend the project by adding:

- sound effects and background music
- more enemy types
- different levels and difficulty settings
- power-ups and special attacks
- animated explosions and visual effects

## Notes

This project is a beginner-friendly SpriteKit game and is ideal for learning:

- Swift programming
- SpriteKit scene management
- physics-based collision handling
- touch input and animation

## License

This project is for educational and personal use.
