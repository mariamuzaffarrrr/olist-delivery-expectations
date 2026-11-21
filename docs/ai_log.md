# AI Log

Where AI helped, where it was wrong, and how I caught it.

### Import Wizard suggestion
- **AI said:** Use Workbench's Table Data Import Wizard to load the CSVs.
- **What happened:** It hung on the 100k-row orders file and kept erroring.
- **Fix:** Switched to LOAD DATA LOCAL INFILE, with empty dates converted to NULL.
