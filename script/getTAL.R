########################################
##getTAL: Download episode transcripts##
########################################

getTAL <- function(ep_num){
  # A function to download episode transcripts from ThisAmericanLife.org
  #
  # Args:
  #       ep_num: an integer corresponding to an episode number
  #
  # Returns:
  #      A dataframe containing each episode's transcript
  #
  
  require(rvest)
  require(RCurl)
  url <- paste0("https://www.thisamericanlife.org/", ep_num, "/transcript")
  
  #Check if URL exists
  if(url.exists(url)){
    message("URL Exists!")
    tal <- read_html(url)
    
    #Get Title
    title <- tal %>%
      html_node("title") %>%
      html_text()
    
    #Get all sections
    sections <- tal %>%
      html_nodes("div.content > div.act") 
    
    #Get section heading
    dialogue <- data.frame()
    if(length(sections) > 0){
      for(i in 1:length(sections)){
      
        #Top line
        act_title <- html_nodes(sections[[i]], "h3") %>% html_text()
        act_num <- i
        
        #Inner Content
        a <- html_nodes(sections[[i]], "div.act-inner > div ")
        
        #Loop through each speaking turn
        for(j in 1:length(a)){
          b <- a[j]
          
          #Within each speaking turn
          for(m in 1:length(b)){
            
            #Identify the speaker
            speaker <- html_nodes(b[m], "h4") %>% html_text() 
            if(length(speaker) <=1){
              speaker <- ""
            } 
            
            #The type of speaker (e.g. host, interviewer, subject)
            speaker.type <- html_attr(b[m],"class")

            #Extract what they said and the timing
            line <- html_nodes(b[m], "p") %>% html_text() 
            times <- html_nodes(b[m], "p") %>% html_attr("begin") 
            para <- 1:length(times)
            
            #Log the speaker turn, parapgraph, text, etc.
            if(length(line) >=1 && length(times) >= 1){
              dialogue <- rbind(dialogue, 
                                data.frame(ep_num = ep_num,
                                           title = title,
                                           act_title = act_title, 
                                           act_num = act_num,
                                           speaker = speaker,
                                           speaker_type = speaker.type,
                                           turn = j,
                                           paragraph = para,
                                           times = times,
                                           text = line))
            }
          }
        }
      }
      return(dialogue)
    }
  } else {
      warning(paste0("Episode ", ep_num," transcript does not exist."))
    
    }
}


