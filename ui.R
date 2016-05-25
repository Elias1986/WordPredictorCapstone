library(shiny)

shinyUI(fluidPage(
        
        # Application title
        titlePanel("Smart Word Predictor"),
        h4("SwiftKey", style="color:gray"),
        hr(),
        
        fluidRow(width=2,
                 p("Enter a sentence, hit enter (or press the 'Predict next' button), and see what the 
                   algorithm thinks will come next!"),
                 p("The model used to predict is an",
                   a(href="http://en.wikipedia.org/wiki/N-gram", "n-gram"),
                   "model, that includes quadgrams from a dataset of Twitter, news articles, 
             and blog posts.")),
        hr(),
        
        # Sidebar with a slider input for the number of bins
        sidebarLayout(
                sidebarPanel(
                        textInput("text", label = h3("Input"), value = "happy birthday to"),
                        helpText("Type a sentence above, hit enter or press the button below, and prepare yourself to be astonished by my power prediction capabilties."),
                        submitButton("Predict next"),
                        hr()
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                        br(),
                        h2(textOutput("sentence"), align="center"),
                        h1(textOutput("predicted"), align="center", style="color:blue"),
                        hr(),
                        h3("Top 4 Possibilities:", align="center"),
                        div(tableOutput("alts"), align="center")
                )
        )
        ))