########################################
##getTAL. Download episode transcripts##
########################################
getTAL <- function(ep_num){
  # A function to download episode transcripts from ThisAmericanLife.org
  #
  # Args:
  #       ep_num: an integer corresponding to an episode number
  #
  # Returns:
  #       A list containing one data frame
  #
  
  require(rvest)
  url <- paste0("https://www.thisamericanlife.org/", ep_num, "/transcript")
  tal <- read_html(url)
  
  title <- tal %>%
    html_node("title") %>%
    html_text()
  
  #Get all sections
  sections <- tal %>%
    html_nodes("div.content > div.act") 
  
  #Get section heading
  dialogue <- data.frame()
  for(i in 1:length(sections)){
    
    #Top line
    act_title <- html_nodes(sections[[i]], "h3") %>% html_text()
    act_num <- i
    
    #Inner
    a <- html_nodes(sections[[i]], "div.act-inner > div ")
    for(j in 1:length(a)){
      print(j)
      b <- a[j]
      
      for(m in 1:length(b)){
        speaker <- html_nodes(b[m], "h4") %>% html_text() 
        speaker.type <- html_attr(b[m],"class")
        if(length(speaker) == 0){
          speaker <- ""
        } 
        
        
        line <- html_nodes(b[m], "p") %>% html_text() 
        times <- html_nodes(b[m], "p") %>% html_attr("begin") 
        para <- 1:length(times)
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
  return(dialogue)
}


