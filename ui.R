shinyUI(navbarPage("PeakR",
          tabPanel("Import",
      
  sidebarLayout(
    sidebarPanel(
      
      
      ## FILE INPUT BOX START ##
      fileInput('file1', 'Choose .csv file to analyse',
            accept = c(
              'text/csv',
              'text/comma-separated-values',
              '.csv'
            )
      ),
      ## FILE INPUT BOX END ##
      
      uiOutput("run"),
      
      uiOutput("hcut"),
      
      sliderInput("scut","Global min size",min=0,max=550,val=50)
      
      
    ),
    mainPanel(
      tableOutput('contents')
    )
  )
          ),
  
  
  tabPanel("Settings"),
  tabPanel("Electropherogram")
  
  
  
  
  
  ))