# Introduction

This app was mainly created as a way to learn Flutter, but also for my own personal use, and it works well enough for me. I don’t plan to make major updates or improvements, as I’d like to move on to other projects. For fun (and the experience), I also designed the app icon and Play Store screenshots.

(if you plan on building this i changed the NDK version manually in build.gradle.kts so you will need to change it to version that matches yours and add key.properties in android folder, also i only tested the app on Android)
## Gallery

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/2e052f83-6239-4b48-8f12-b20411d5d5c7" width="50" /></td>
    <td style="vertical-align: top; padding-left: 10px;">
      <p><strong>SimpleMusic</strong><br />Easy to use music player for local songs.</p>
    </td>
  </tr>
</table>

<p float="left">
  <img src="https://github.com/user-attachments/assets/060c3baa-96f0-4c81-b99e-2350e218c8a4" width="250" />
  <img src="https://github.com/user-attachments/assets/156fdb8a-6231-4a9b-84fe-48a448e67eba" width="250" />
  <img src="https://github.com/user-attachments/assets/ede1dcfe-7677-4329-9e4a-0976f778ae6c" width="250" />
</p>

## Features

<p>📋 Features: </p>
<ul>
  <li>Playback of .mp4, .flac, .ogg, and .wav audio files</li>
  <li>Ability to loop and shuffle songs</li>
  <li>Ability to select from 7 color themes + dark and light mode</li>
  <li>Ongoing notification with playback controls and a progress bar</li>
  <li>Mark songs as favorites</li>
  <li>Automatically remembers recently played songs</li>
  <li>Simple but nice UI (in my opinion)</li>
  <li>Multilingual support: Polish and English</li>
</ul>

## Summary

<p>💡 Things I Learned:</p>
<ul>
  <li>Using GetIt for dependency injection</li>
  <li>Working with Sqflite for local data storage</li>
  <li>Handling audio playback</li>
  <li>Using basic Flutter notifiers and associated widgets/builders</li>
  <li>Displaying and working with streams</li>
  <li>Creating custom theme extensions</li>
  <li>Implementing multi-language support</li>
  <li>Working with android permissions</li>
  <li>And more: working with widgets, integrating packages, handling notifications, etc.</li>
</ul>

<p>🛠️ Things to Do/Fix <small>(as I said earlier, it works for me and I want to move on to other projects     so probably never)</small>:</p>
<ul>
  <li>Change music library to <code>flutter_soloud</code> for real-time sound waveform</li>
  <li>Ability to swipe left and right on player page to change song</li>
  <li>Fix naming in DB class and other class names</li>
  <li>Add support for custom color themes</li>
  <li>Remove code repetition in some widgets code</li>
  <li>Remember last played song (have it on paused when you open app)</li>
</ul>

