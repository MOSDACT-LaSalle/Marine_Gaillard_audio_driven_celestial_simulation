This project is an interactive audio-visual simulation that combines elements of astronomy with reactive music-driven effects. The sketch visualizes planets, stars, and nebulae, and syncs their movement and appearance to audio input. The celestial objects include planets with rings, orbiting planets, shooting stars, nebula particles, and kaleidoscopic effects, all dynamically influenced by the amplitude of the playing music.




FEATURES

Audio Visualization: Real-time visualization of audio through Minim, with planet and star effects synced to the amplitude of the music.

Dynamic Celestial Objects: Simulation of planets, orbiting planets, background stars, shooting stars, nebula particles, and galaxy particles.

Phase Transitions: Different planet visual modes are cycled through, each with a unique look and feel.

Kaleidoscope Effect: Kaleidoscope particles and rotating axes create an otherworldly, synchronized display.

Flow Field: Flow particles and kaleidoscopic particles that respond to music and phase changes.

User Interaction: The user can toggle between different visual modes and effects, including planet rings, axes, and appearance.




PREREQUISITES

Processing: You must have the Processing environment installed.

Minim Library: Download and install the Minim library in Processing. You can do this via Sketch -> Import Library -> Add Library and search for Minim.

Audio File: Place an MP3 file named Toxicity.mp3 in the data folder of the sketch. You can change the file by replacing Toxicity.mp3 with your desired track, ensuring the filename is updated in the code.




INSTALLATION

Download or clone this repository.
Open the .pde file in Processing.
Ensure you have the Toxicity.mp3 file in the data folder.
Run the sketch.


HOW TO USE

Visual Modes: Press the following keys to toggle between different modes.

1: Displays the first planet mode (basic planets without rings and axes).

2: Displays orbiting planets.

3: Orbiting planets with rotating axes.

4: Planets with rings and rotating axes.

5: Toggle planet appearance (color variations based on amplitude).

6: Show only rings without planets.

7: Toggle the kaleidoscope particle effect.

8: Toggle axes on/off.

9: Randomly activate visual elements, synchronized with music.

0: Restart the animation and reset to initial states.




KEY VISUAL ELEMENTS

Planets:
Planet simulation, including phases such as "realistic planet," "Mars-like planet," and "glowing planet."
Planets can display rings and rotate with axes, with an option to toggle various visual effects.

Nebula Particles:
A field of nebula particles simulating interstellar dust and gases.

Shooting Stars:
Randomly appearing shooting stars that streak across the screen.

Flow Field & Kaleidoscope:
Flow particles and kaleidoscope patterns respond to phase transitions and audio amplitude, creating a dynamic, music-synced display.


CUSTOMIZATION

Music Sync: Toggle syncWithMusic to true to sync the rotations and pulsations with the audio.

Phase Duration: You can modify the duration of each phase by adjusting the transitionDuration, phase2Start, and phase3Start variables.

Number of Particles: Adjust the number of flow, ring, nebula, and galaxy particles by modifying the corresponding array sizes (e.g., numFlowParticles, numWhiteStars, etc.).


DEPENDENCIES

Minim (Audio library for Processing)

Processing 3.5.x or later


FUTURE IMPROVEMENTS

Audio Analysis Enhancements: More granular audio analysis for more sophisticated synchronization with specific musical elements.

Customization Options: Allow for dynamic control over audio input and visual parameters through a user interface.


AUTHOR

Marine Gaillard

