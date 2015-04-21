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
      
      uiOutput("run") 
      
    ),
    mainPanel(
      tableOutput('contents')
    )
  )
          ),
  
  
  tabPanel("Settings"),
  tabPanel("Electropherogram")
  
  
  
  
  
  ))