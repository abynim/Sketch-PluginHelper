# Sketch-PluginHelper
A sample project that shows how to connect a Sketch 3 plugin to a binary helper app

---

### Test the example plugin
1. Extract the contents of this repository in your plugins folder.  
2. Use the `Make Selection Red` plugin to see an example of custom UI launched by the plugin.  

### The Helper app
1. Open _source/PluginHelper.xcodeproj in Xcode.  
2. `SketchPlugin.swift` is a reusable file which you can drop into your own helper app to communicate with Sketch App.  
3. `AppDelegate.swift` contains code to instantiate SketchPlugin, and show the initial window once set up.  
4. Check out `Main.storyboard` and `HelloViewController.swift` to see how the custom UI is set up and how it uses `SketchPlugin.swift` to load data from and send data to the Sketch App.

---

### Contributing  
If you fork this repository and end up making some useful updates, please do send me pull requests so I can include your work here and give you credit.

### Help and Questions
I will write up a short tutorial explaining this soon, but meanwhile feel free to bug me with questions on Twitter [@abynim](https://twitter.com/abynim).

---

MIT License © Aby Nimbalkar. I'm on [LinkedIn](http://tw.linkedin.com/in/abynim/) and [Twitter](https://twitter.com/abynim).
