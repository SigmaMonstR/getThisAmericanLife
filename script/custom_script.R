#####################################
##Custom code to download TAL files##
#####################################

#Set directory
  dir <- "[working directory]"
  max.ep <- 641
  
#Load getTAL(), requires rvest
  source("https://raw.githubusercontent.com/SigmaMonstR/getThisAmericanLife/master/script/getTAL.R")
  
#Set up tables
  setwd(dir)
  episodes <- data.frame()
  transcripts <- data.frame()
  
#Loop through each episode
  for(k in 1:max.ep){
    print(k)
    Sys.sleep(runif(1)*2)
    out <- getTAL(k)
    episodes <- rbind(episodes, as.data.frame(out[1]))
    transcripts <- rbind(transcripts, as.data.frame(out[2]))
    if(k %% 10 == 0){
      save(episodes, transcripts, file = "TAL1to600.Rda")
    }
  }
  
#
  save(episodes, transcripts, file = "TAL1to600.Rda")
  write.csv(transcripts, "TAL_transcript.csv", row.names = FALSE)
  write.csv(episodes, "TAL_episodes.csv", row.names = FALSE)
  