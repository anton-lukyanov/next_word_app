library(shiny)
shinyUI(fluidPage(
  
  titlePanel("Next word prediction model"),
  
  fluidRow(
   column(3,
          textInput("a1",label="Type some text in frame below and press Submit button"),
          actionButton("submit","Submit")
          ),
   column(3,
          h4('next word: '),
          textOutput("text1"),
          textOutput("text2"),
          textOutput("text3"),
          textOutput("text4"),
          textOutput("text5")
          )
    
  )
  
  )
)