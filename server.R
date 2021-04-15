#Libraries
library(shiny)
library(hyperSpec)
library(plotly)
library(miniUI)
library(dplyr)
library(tidyr)
library("reshape2")
library("data.table")


shinyServer(function(input,output) {
    
    

#To display info about the dataframe
    output$filedf <- renderTable({
        if(is.null(input$file)){return ()}
        input$file 
    })
    
    output$filedf2 <- renderTable({
        if(is.null(input$file)){return ()}
        input$file$datapath 
    })
   
##Displayed UI after loading the files    
    output$selectfile <- renderUI({
        if(is.null(input$file)) {return()}
        list(hr(), 
             helpText("Select spectral data you want to visualize"),
             selectInput("Select", "Select", choices=input$file$name)
        )
        
    })

    output$DataColN <- renderUI({
        if(is.null(input$file)) {return()}
        list(hr(), 
             helpText("Select the number of non-spectral Columns descriptive data (must be on the left of the spectral data and end with the categories columns)"),
             numericInput("DataColN", "Number of Non-Spectral Columns:", 1, min = 0, max = 10000)
        )
    })
    
    
    #  Showing 20 rows of the table after pressing the submit button
    output$table <- renderTable({ 
        if(is.null(input$file)){return()}
        DCN<- input$DataColN
        b<-read.table(file=input$file$datapath[input$file$name==input$Select], sep=input$sep, header = input$header)
        names(b)[DCN]<-"Category"
        names(b)<-sub("X", "", names(b))
        b[,1:20]
        
    })
    #  Visualising the spectra using the package hyperspec
    output$plot <- renderPlotly({ 
        if(is.null(input$file)){return()}
        DCN<- input$DataColN
        a<-read.table(file=input$file$datapath[input$file$name==input$Select], sep=input$sep, header = input$header)
        names(a)[DCN]<-"Category"
        a$Category<-as.factor(a$Category)
        names(a)<-sub("X", "", names(a))
        Edata<-a[,1:DCN]
        spc<-a[,-(1:DCN)]
        wl<-names(spc)
        hspc <- new ("hyperSpec", spc = as.matrix(spc), wavelength = as.numeric(wl), data = Edata)
        hspcn<-normalize01(hspc)
        qg<-qplotspc(hspcn, spc.nmax= Inf) +  aes(colour=Category) 
        qp<-ggplotly(qg)
        qp
    })
    
})
