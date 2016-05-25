library(shiny)
library(RSQLite)
library(magrittr)
library(stringr)
library(tm)

ngramrev <- function(raw, db) {
        
        max = 4  # max n-gram - 1
        sentence <- tolower(raw) %>%
                removePunctuation %>%
                removeNumbers %>%
                stripWhitespace %>%
                str_trim %>%
                strsplit(split=" ") %>%
                unlist
        
        for (i in min(length(sentence), max):1) {
                gram <- paste(tail(sentence, i), collapse=" ")
                sql <- paste("SELECT word, freq FROM NGram WHERE ", 
                             " pre=='", paste(gram), "'",
                             " AND n==", i + 1, " LIMIT 4", sep="")
                res <- dbSendQuery(conn=db, sql)
                predicted <- dbFetch(res, n=-1)
                names(predicted) <- c("Next Possible Word", "Score (Adjusted Freq)")
                print(predicted)
                
                if (nrow(predicted) > 0) return(predicted)
        }
        
        return("You overcame my cyborg supercomputer capabilties, try other word :)")
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        # input$text and input$action are available
        # output$sentence and output$predicted should be made available
        db <- dbConnect(SQLite(), dbname="test.db")
        dbout <- reactive({ngramrev(input$text, db)})
        
        output$sentence <- renderText({input$text})
        output$predicted <- renderText({
                out <- dbout()
                if (out[[1]] == "You overcame my cyborg supercomputer capabilties, try other word :)") {
                        return(out)
                } else {
                        return(unlist(out)[1])
                }})
        output$alts <- renderTable({dbout()})
})