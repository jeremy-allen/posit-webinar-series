This Shiny app illustrates Shiny's scoping rules. If it is running in Posit Connect, you can also see session logs in the Connect UI.

Where you define objects will determine where the objects are visible. There are three different levels of visibility that you’ll want to be aware of when writing Shiny apps. Some objects are visible within the server code of each user session; other objects are visible in the server code across all sessions (multiple users could use a shared variable); and yet others are visible in the server and the ui code across all user sessions.
