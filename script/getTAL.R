
#This American Life: Scraping
##Episode Function
  getTAL <- function(ep.num){
    # A function to download episode transcripts from ThisAmericanLife.org
    #
    # Args:
    #       ep.num: an integer corresponding to an episode number
    #
    # Returns:
    #       A list containing two data farmes: an episode table and a transcript table
    #
    
    #Readlines to find content IDs
    library(rvest)
    library(RCurl)
    
    #Create URL
      urlTAL <- paste0("https://www.thisamericanlife.org/radio-archives/episode/",ep.num,"/transcript")

    #Check if episode transcript exists
      check <- url.exists(urlTAL)
      
      if(check){
        
        a <- readLines(urlTAL)
        
        #title
        title <- grep("<a href=\"/radio-archives/episode/", a, value = TRUE)[1]
        title <- substr(title, regexpr(">", title)+1,regexpr("</a>",title)-1)
        
        #date
        radiodate <- grep("class=\"radio\\-date\"",a, value = TRUE)
        date <- regmatches(radiodate, regexpr("\\d{2}\\.\\d{2}\\.\\d{4}",radiodate))
        
        meta <- data.frame(title = title,
                           link = urlTAL,
                           date = date,
                           ep.num = ep.num, 
                           available = TRUE)
        
        scraped <- read_html(urlTAL)
        
        output <- data.frame()
        #get text
        b <- grep("\"act\"",a, value = TRUE)
        c <- paste0("#",gsub("[[:punct:]]","", gsub("^id","", regmatches(b,regexpr("id=\"[[:alnum:]]{1,100}\"",b)))))
        for(k in 1:length(c)){
          temp <- scraped %>%
            html_nodes(c[k]) %>% html_text()
          output <- rbind(output, 
                          data.frame(ep.num = ep.num,
                                     tag = c[k],
                                     text = unlist(temp)))
        }
      } else {
        meta <- data.frame(title = NA,
                           date = NA,
                           ep.num = ep.num, 
                           available = FALSE)
        output <- data.frame(ep.num = ep.num,
                             tag = NA,
                             text = NA)
      }
    
    return(list(meta, output))
  }

