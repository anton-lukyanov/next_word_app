library(shiny)
library(dplyr)
library(stringi)
library(tau)

bigram.data.file <- "./data/2-gram.csv"
trigram.data.file <- "./data/3-gram.csv"
quadrogram.data.file <- "./data/4-gram.csv"

missing.types <- c("NA", "")
column.types <- c('character', 'character', 'character', 'integer')
readData <- function(file.name, column.types, missing.types) {
  read.csv(file.name, colClasses=column.types, na.strings=missing.types )
}

bigram.data<-readData(bigram.data.file, column.types, missing.types)
trigram.data<-readData(trigram.data.file, column.types, missing.types)
quadrogram.data<-readData(quadrogram.data.file, column.types, missing.types)

Ngram_search <- function(stringInput) {
  stringInput<- stri_enc_toascii(stringInput)
  stringInput <- stri_trans_tolower(stringInput)
  stringInput <- stri_replace_all_regex(stringInput, pattern = "[[:cntrl:]]", "")
  stringInput <- stri_replace_all_regex(stringInput, pattern = "[[:digit:]]", "")
  stringInput <- stri_replace_all_regex(stringInput, pattern = "[~!@#$%&-_=:;<>,`\"]", "")
  stringInput <- stri_replace_all_regex(stringInput, pattern = "[\\$\\*\\+\\.\\?\\[\\]\\^\\{\\}\\|\\(\\\\]", "")
  stringInput <- stri_replace_all_regex(stringInput, pattern = "\\s+", " ")
  
  stringToWords <- unlist(stri_split_fixed(stringInput," "))
  lngth<-length(stringToWords)
  
  if(lngth>=3){
    #4-gram:
    check4<-paste(stringToWords[lngth-2],stringToWords[lngth-1],stringToWords[lngth], sep=" ")
    qgramDF<-quadrogram.data[quadrogram.data$Search==check4,]
    #3-gram:
    check3<-paste(stringToWords[lngth-1],stringToWords[lngth], sep=" ")
    trigramDF<-trigram.data[trigram.data$Search==check3,]
    #2-gram:
    check2<-stringToWords[lngth]
    bigramDF<-bigram.data[bigram.data$Search==check2,]
    #ranking
    df <- data.frame(word=rep(NA,each=15), rating=c(40,30,25,20,15,26,21,16,11,6,17,12,7,5,3))
    df$word[1]<-qgramDF$Next[1]
    df$word[2]<-qgramDF$Next[2]
    df$word[3]<-qgramDF$Next[3]
    df$word[4]<-qgramDF$Next[4]
    df$word[5]<-qgramDF$Next[5]
    
    df$word[6]<-trigramDF$Next[1]
    df$word[7]<-trigramDF$Next[2]
    df$word[8]<-trigramDF$Next[3]
    df$word[9]<-trigramDF$Next[4]
    df$word[10]<-trigramDF$Next[5]
    
    df$word[11]<-bigramDF$Next[1]
    df$word[12]<-bigramDF$Next[2]
    df$word[13]<-bigramDF$Next[3]
    df$word[14]<-bigramDF$Next[4]
    df$word[15]<-bigramDF$Next[5]
    
    df<- aggregate(rating ~ word, df, sum)
    df<-head(df[order(-df$rating),],5)$word
    df
  }
  else{
    if(lngth==2){
      #3-gram:
      check3<-paste(stringToWords[lngth-1],stringToWords[lngth], sep=" ")
      trigramDF<-trigram.data[trigram.data$Search==check3,]
      #2-gram:
      check2<-stringToWords[lngth]
      bigramDF<-bigram.data[bigram.data$Search==check2,]
      #ranking
      df <- data.frame(word=rep(NA,each=10), rating=c(40,30,25,20,15,26,21,16,11,6))
      
      df$word[1]<-trigramDF$Next[1]
      df$word[2]<-trigramDF$Next[2]
      df$word[3]<-trigramDF$Next[3]
      df$word[4]<-trigramDF$Next[4]
      df$word[5]<-trigramDF$Next[5]
      
      df$word[6]<-bigramDF$Next[1]
      df$word[7]<-bigramDF$Next[2]
      df$word[8]<-bigramDF$Next[3]
      df$word[9]<-bigramDF$Next[4]
      df$word[10]<-bigramDF$Next[5]
      
      df<- aggregate(rating ~ word, df, sum)
      df<-head(df[order(-df$rating),],5)$word
      df
    }
    else{
      if(lngth==1&stringToWords[lngth]!=""){
        #2-gram:
        check2<-stringToWords[lngth]
        bigramDF<-bigram.data[bigram.data$Search==check2,]
        #ranking
        df <- data.frame(word=rep(NA,each=5), rating=c(40,30,25,20,15))
        
        df$word[1]<-bigramDF$Next[1]
        df$word[2]<-bigramDF$Next[2]
        df$word[3]<-bigramDF$Next[3]
        df$word[4]<-bigramDF$Next[4]
        df$word[5]<-bigramDF$Next[5]
        
        df<- aggregate(rating ~ word, df, sum)
        df<-head(df[order(-df$rating),],5)$word
        df
      }
      else{
        df=""
        df
      }
    }     
    
  }  
}
ll=rep(NA,each=5)

shinyServer(
  function(input,output) {
    observe({
      if (input$submit == 0)
        return()
      
      isolate({
        ll<-Ngram_search(input$a1)
        output$text1<-renderText({ifelse(is.na(ll[1]),"",ll[1])})
        output$text2<-renderText({ifelse(is.na(ll[2]),"",ll[2])})
        output$text3<-renderText({ifelse(is.na(ll[3]),"",ll[3])})
        output$text4<-renderText({ifelse(is.na(ll[4]),"",ll[4])})
        output$text5<-renderText({ifelse(is.na(ll[5]),"",ll[5])})
      })
    })
    
    
  }
)