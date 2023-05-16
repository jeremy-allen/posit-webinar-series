rsconnect::deployApp(appDir = "/Users/jeremyallen/projects/posit-webinar-series/webinar_materials/ide-tips",
					 appPrimaryDoc = "into-the-unknown.html",
					 appSourceDoc = "into-the-unknown.qmd",
					 account = "jeremy.allen",
					 server = "colorado.posit.co",
					 appTitle = "test-publish",
					 logLevel = "normal",
					 quarto = quarto::quarto_path()) 

# must add empty _quarto.yml to directory
# https://docs.posit.co/connect/user/publishing-cli-quarto/#limitations

# quarto::quarto_path() or in terminal: which quarto
