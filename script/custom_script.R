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
  for(k in 286:max.ep){
    print(k)
    Sys.sleep(runif(1)*2)
    out <- getTAL(k)
    episodes <- rbind(episodes,out)
    if(k %% 10 == 0){
      save(episodes, file = "TAL1to641.Rda")
    }
  }
  
#
  save(episodes, file = "TAL1to641.Rda")
  write.csv(episodes, "TAL_episodes.csv", row.names = FALSE)
  