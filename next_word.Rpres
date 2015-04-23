Next word Prediction
========================================================
author: Anton Lukyanov
date: 4/23/2015 

Key Idea
========================================================

Goal:                 create model that can predict next word based
                      on the previously typed.
                      
Output of the model:  5 word potentially matched to sentence

Under the hood:       N-grams from three corps (blogs, news and Twitter)

Further explanation
========================================================

Preprocessing:  Each corpus was cleaned from punctuation, special characters, 
                extra-white spaces, digits etc.
                
Sampling:       To fit memory constraints preprocessed data was sampled to 1Gb dataframe.

N-grams:        Using `textcnt` function from **stringi** package we create bi-,
                tri- and quad-grams.

Search-function:When we get input phrase from textInput field of app, we start the
                matching   process. We match last 3 words to 4-gram from base, 
                last 2  words to 3-gram and last word to 2-gram.


Example
========================================================

Suppose we type "One of my favorite".
Lets explain process step by step:

We create list of words: "One","of","my","favorite".

After that we merge it again for n-grams comparison:

  - "of my favorite" with 4-grams table,
  
  - "my favorite" with 3-grams table,
  
  - "favorite" with 2-grams table.

And we get some matches. Leave only 5 best matches.
Then we weigt these 3 sets with 0.5, 0.3 and 0.2 retrospectively.
Then we group by unique words and provide final ranking.

