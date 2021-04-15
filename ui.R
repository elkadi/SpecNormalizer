

library(shiny)
library(shiny)
library(hyperSpec)
library(plotly)
library(miniUI)
library(dplyr)
library(tidyr)
library("reshape2")
library("data.table")

shinyUI(fluidPage(
    titlePanel("SpecNormalizer"),
    sidebarLayout(
        sidebarPanel(
            fileInput("file","Upload the file", multiple = TRUE), 
            helpText("Select if your data has a header or not"),
            checkboxInput(inputId = 'header', label = 'Header', value = TRUE),
            radioButtons(inputId = 'sep', label = 'Separator', choices = c(Comma=',',Semicolon=';',Tab='\t', Space=''), selected = ','),
            uiOutput("selectfile"),
            uiOutput("DataColN"),
            submitButton("Normalize")
        ),
        mainPanel(tabsetPanel(
            tabPanel("About", p("This application normalize spectal data and allow you to visualize it using plotly letting you use the abilities of ploty including zooming to specific location and downloading the normalized spectra")),
            tabPanel("Tutorial", p("1.Download the following file as an example for the application:"),
                     a(href = "https://specupsampler.neocities.org/Example.csv", "Example"),
            p("2.Browse for the downloaded file and upload it"),
            p("3.Select the uploaded file (the degault)"),
            p("4.Select the header option (the default)"),
            p("5.Select Comma as seperator (the default)"),
                p("6.Enter 2 Number as number Non-Spectral Columns"),
              p("7.Press Normalize then in the tab visualize you can see the spectral data after normailzation and notice how the spectra is between 1 and 0"),
             p("8.In the Dataset tab, you can see the original data and it includes data outside the 0-1 range such as negative data")),
            tabPanel("Input File Object DF ", tableOutput("filedf"), tableOutput("filedf2")),
            tabPanel("Dataset", tableOutput("table")),
            tabPanel("Visualize", plotlyOutput("plot"))
        )
        )
        
    )
))