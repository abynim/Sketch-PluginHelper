#import 'lib/common.js'

// Define functions that can be called from Xcode

function applyColorToSelection(hex) {
	
	if(!selectionIsEmpty()) {
		
		var loop = [selection objectEnumerator]
		while (layer = [loop nextObject]) {
			setColor(layer, hex)
		}
		
	}
}