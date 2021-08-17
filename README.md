This project is the lobby system from the [Bomberman demo](https://godotengine.org/asset-library/asset/139) combined with the [lan discovery plugin](https://github.com/Wavesonics/LANServerBroadcast) made to be plug-and-play to aid in learning Godot's networking capabilities

If you would like to test this out there is a [compiled demo](https://figroot.itch.io/godot-discovery-lobby) on Itch

Plug-And-play
=============

To use this in your own projects you just need to copy the lobby file and the plugin file into your project's file, then make gamestate.gd a singleton and enable the plugin. You can then change the scene gamestate.gd instances in the start game function with your project's main scene 
