# QOwnNotes Template Script
Adds a button to make a new file using a pre-made template. Gives the option to select from several templates and auto-fills certain parameters within them. 

This script was made with myself in mind so the templates are all for things I use/used: two for the Pelican static site generator and one for personal weeknotes. 

The two Pelican templates will prompt for a title to use. This will be auto-added to the file and used for the filename (after clearing problematic characters). It will also replace the following:
- `dateFiller` and `modFiller` will be replaced with the current date and time in ISO format. 
- `weeknotesDateFiller` will be replaced with the date

This script is probably best used as a basis for making your own script with your own needs, though I may expand it's capabilities in the future. 