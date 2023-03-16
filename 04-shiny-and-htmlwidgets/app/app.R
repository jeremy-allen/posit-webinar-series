library(shiny)
library(ggplot2)
library(plotly)

message("\n\n___APP CALLED at ", format(Sys.time(), "%H:%M:%OS4"), "___\n")

server_count <- 1
plot_count <- 0

onStop(function() cat("\n\n___App stopped, cleaning up___\n"))

# this is outside of server() so it's made only once and 
# available for all sessions. If this were inside server()
# it would be made again for each session, taking more memory
df <- data.frame(x = 5.7, y = 5.6)

# this is outside of server() so it's made only once and 
# available for all sessions
color_bucket <- c(
	"#94BDBF", "#297075", "#1F4F4F",
	"#A2B8CB", "#447099", "#213D4F",
	"#949494", "#404041", "#151515",
	"#ADBF99", "#72994E", "#3B4F29",
	"#BF96A3", "#9A4665", "#542938",
	"#EBA38C", "#EE6331", "#80361C"
)

# Define UI for application that graphs a high 5 from Posit
ui <- fluidPage(
	
	# Application title
	titlePanel("Shiny Scopes and Runtime"),
	
	# Sidebar with user inputs 
	sidebarLayout(
		sidebarPanel(
			p("and we sneak in a chat about htmlwidgets, too!"),
			br(),
			h4("Plot Control"),
			actionButton(inputId = "button-plot",
						 label = "New plot colors",
						 width = "100%"),
			br(),
			h4("Talk to the log"),
			actionButton(inputId = "button-a",
						 label = "Hi from out here!",
						 width = "100%"),
			actionButton(inputId = "button-b",
						 label = "Posit says hello!",
						 width = "100%"),
			br(),
			br(),
			h4("What's happening?"),
			p(tags$b("Scoping rule: Between multiple R processes, no objects are shared.")),
			p(tags$b("Scoping rule: In a R process, the server function is called for eack user session.")),
			p(tags$b("Scoping rule: To share an object among user sessions in a R process instead of creating a copy for each user, place it in app.R, but outside of the server function")),
			p("In our server code we added a counter that counts each time the server function is called in a R process, each time the plot changes, and messages from the hello buttons."),
			p("If only 1 connection is allowed per R process, the server count will not go up because that function is called only once per user session."),
			p("In the runtime settings tab on the right, allow more than 1 connection per R process in order to see the server function called more than once."),
			p("Click the notebook icon above to see active processes and messages in the log."),
			p(a(href = "https://shiny.rstudio.com/articles/scoping.html", "More on scoping rules.")),
			p("This app defaults to displaying in Showcase mode, which shows you the app code either beside or below the main app. You can stop Showcase mode by adding ?showcase=0 to the end of the URL in your browser.")
			
		),
		# Show a plot of a high 5
		mainPanel(
			h4("ggplot output"),
			br(),
			plotOutput("gg"),
			br(),
			br(),
			h4("ggplotly output"),
			p("You can see that ggplotly() cannot convert all aspects of a ggplot() graph (no subtitle, no caption, no multiple geoms), so if details matter, use plot_ly() to build your plotly graph from scratch, where you can definitely add things like subtitles, captions, and multiple geoms, and they will be as beautiful as your ggplot() graphs."),
			br(),
			plotlyOutput("pl")
		)
	)
)

# Define server logic required to draw the graphs
#and respond to user inputs
server <- function(input, output, session) {
	
	# things created in here are recreated for every connection
	# to the session and thus consume more memory
	
	message(paste0("\n\n\n***___TIMES SERVER STARTED: ", server_count, "___***\n\n"))
	server_count <<- server_count + 1
	
	# initial plot render when button is pushed, highest priority
	observe(priority = 3, x = {
		
		my_ggplot <<- ggplot(df, aes(x = x, y = x)) +
			geom_point(size = 11, color = sample(color_bucket, 1)) +
			geom_point(size = 9, color = sample(color_bucket, 1)) +
			geom_point(size = 3, color = sample(color_bucket, 1)) +
			labs(
				title = "High Five From Posit!",
				subtitle = "you deserve it",
				caption = paste0("this is plot ", plot_count, " in this session"),
				x = NULL,
				y = NULL
			) +
			scale_x_continuous(limits = c(0,6)) +
			scale_y_continuous(limits = c(0,6)) +
			theme_minimal() +
			theme(
				panel.grid.minor = element_blank(),
				panel.grid.major = element_line(color = sample(color_bucket, 1)),
				plot.background = element_rect(fill = sample(color_bucket, 1),
											   color = sample(color_bucket, 1)),
				axis.text = element_text(color = "#ffffff", size = 18),
				plot.title = element_text(size = 28, color = sample(color_bucket, 1)),
				plot.subtitle = element_text(size = 22,
											 color = sample(color_bucket, 1),
											 margin = margin(t = 10, r = 0, b = 22, l = 0, unit = "pt")),
				plot.caption = element_text(size = 16,
											color = sample(color_bucket, 1),
											margin = margin(t = 10, r = 0, b = 20, l = 0, unit = "pt")),
				plot.margin = margin(t = 22, r = 22, b = 22, l = 22, unit = "pt")
			)
		
	}) |> bindEvent(input$`button-plot`, ignoreNULL = FALSE)
	
	# render ggplot in UI when button is pushed but after higher priorities
	observe(priority = 2, x = {
		output$gg <- renderPlot({
			
			message(paste0("___TIMES PLOT RECREATED: ", plot_count, "___"))
			plot_count <<- plot_count + 1
			
			my_ggplot
			
		})
	}) |> bindEvent(input$`button-plot`, ignoreNULL = FALSE)
	
	
	# render plotly when button is pushed but after higher priorities
	observe(priority = 1, x = {
		output$pl <- renderPlotly({
			
			ggplotly(my_ggplot)
			
		})
	}) |> bindEvent(input$`button-plot`, ignoreNULL = FALSE)
	
	
	# send messages to the log as buttons are pushed or session stopped
	observe(message("___hi from out here at ", format(Sys.time(), "%H:%M:%OS4"), "___")) |>
		bindEvent(input$`button-a`, ignoreInit = TRUE)
	observe(message("___Posit says hello at ", format(Sys.time(), "%H:%M:%OS4"), "___")) |>
		bindEvent(input$`button-b`, ignoreInit = TRUE)
	onStop(function() cat("___Session stopped___"))
}

# Run the application 
shinyApp(ui = ui, server = server)
