import QtQml 2.0
//import Qt.labs.folderlistmodel 2.3
import QOwnNotesTypes 1.0

/**
 * This script creates a custom action to create a new blank note with no headline or other text.
 */

QtObject {

	property string scriptDirPath;

	/**
	* Initializes the custom action
	*/
	function init() {
		script.registerCustomAction("templateNote", "Create a note from a template", "Template", "document-new");
	}

	/**
	* This function is invoked when a custom action is triggered
	* in the menu or via button
	*
	* @param identifier string the identifier defined in registerCustomAction
	*/

	function getSubfolder() {
		var noteSubFolderQmlObj = Qt.createQmlObject("import QOwnNotesTypes 1.0; NoteSubFolder{}", mainWindow, "noteSubFolder");
		var subFolder = noteSubFolderQmlObj.activeNoteSubFolder();
		return subFolder.fullPath();
	}

	function customActionInvoked(identifier) {
		if (identifier != "templateNote") {
			return;
		}

		// Add templates here
		var template_list = [
			"pelican-blog.md",
			"pelican-page.md",
			"weeknotes.md"
			];

		// Select template format
		var template_selection = script.inputDialogGetItem("combo box", "Please select an item", template_list);
		script.log(template_selection);

		// Createa date object
		const date = new Date();

		// Create note name
		var headline = ""
		// Blog/page name
		if (template_selection != "weeknotes.md") {
			headline = script.inputDialogGetText("line edit", "Note title", "");
		} 
		// Weeknotes name / no name specified - use date
		if (headline == "") {
			headline = date.toISOString().slice(0,10);
		}
		script.log(headline);

		// Read from template
		var text = script.readFromFile(scriptDirPath + "/" +template_selection);
		//script.log("File contents:" +text);
		
		// Replace fillers
		text = text.replace(/dateFiller/g,date.toISOString().slice(0,16));
		text = text.replace(/modFiller/g,date.toISOString().slice(0,16));
		text = text.replace(/weeknotesDateFiller/g,date.toISOString().slice(0,10));
		text = text.replace(/titleFiller/g,headline);

		// Make note
		var subFolder = getSubfolder();
		var filePath = subFolder + script.dirSeparator();
		var fileName = headline.replace(/ /g,"_");
		fileName = fileName.toLowerCase();
		fileName = fileName.replace(/[$#@!^*\(\)\'\"]/g,"") ;
		fileName = fileName.replace(/[&:\\\/]/g,"-") + ".md";
		
		// Check for existing file
		if (script.fileExists(filePath + fileName)) {
			script.log("Error: file already exists. Refusing to overwrite.");
			return;
		}

		script.writeToFile(filePath + fileName, text);

		// Force a reload of the note list
		mainWindow.buildNotesIndexAndLoadNoteDirectoryList(true, true);

		var note = script.fetchNoteByFileName(fileName);
		script.setCurrentNote(note);
		script.log("New blank note created: " + filePath + fileName);
	}

}
