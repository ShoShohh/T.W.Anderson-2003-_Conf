# T.W.Andersonで導出された，漸近的な受容域(4)を与える検定統計量を用いた信頼区間の検証を行う関数
Anderson <- function(alpha, SAMPLE_NUM, SAMPLE_EV, POP_EV){

  level <- 1 - (alpha / 2) / 100
  z <- qnorm(level, 0, 1)
  T_Anderson <- abs(sqrt((SAMPLE_NUM - 1) / 2) * (SAMPLE_EV - POP_EV) / POP_EV)
  
 return(if(T_Anderson <= z) {1} else {0})

}

# 母集団のデータ数に対して，無作為抽出する標本の数を増やしていき，それぞれの標本の集まりで
# Anderson()関数を用いて信頼区間の検証を行う．そして，信頼区間の検証とはつまり，
# それぞれの標本の集まりの標本固有値で構成されるAndersonの信頼区間に母固有値が含まれているか
# 確認し，与えられた信頼区間が母固有値の100(1-alpha/100)%信頼区間として成り立っているのかを確認して
# 結果をグラフで表す関数
ConfiPlot <- function(alpha, POP_NUM, mu, sd, p){

  SAMPLE_NUM <- seq(5, POP_NUM, by = 5)
  Percents <- numeric(length(SAMPLE_NUM)) 

  POP <- matrix(rnorm(POP_NUM * p, mu, sd), ncol = p)
  POP_EV <- (prcomp(POP)$sdev[1]) ^ 2
  
  decide <- 0

  for(i in 1:length(SAMPLE_NUM)){

    Percent <- 0

    for(j in 1:100){
    SAMPLE <- POP[sample(1:POP_NUM, SAMPLE_NUM[i]), ]
    SAMPLE_EV <- (prcomp(SAMPLE)$sdev[1]) ^ 2
    Percent <- Percent + Anderson(alpha, SAMPLE_NUM[i], SAMPLE_EV, POP_EV)
    }

    Percents[i] <- Percent
    if((Percents[i] >= 100 - alpha) && (decide == 0))
      decide <- SAMPLE_NUM[i]
  }

  plot(SAMPLE_NUM, Percents, xlim = c(0, POP_NUM), ylim = c(0, 100)
       , xaxt = "n", yaxt = "n", xlab = "抽出した標本の数(SAMPLE_NUM)"
       , ylab = "構成した信頼区間に母固有値が入った回数(Percents)", pch = 1)
  abline(h = 100 - alpha, col = 'red')
  abline(v = decide, col = 'black')

  axis(side = 2, at = c(0, 50, 100), labels = c(0, 50, 100), cex.axis=0.6)
  axis(side = 2, at = 100 - alpha,　labels = 100 - alpha, col.ticks ='red', col.axis = "red")

  axis(side = 1, at = c(0, POP_NUM / 2, POP_NUM), labels = c(0, POP_NUM / 2, POP_NUM), cex.axis=0.6)
  axis(side = 1, at = decide,　labels = decide, col.ticks ='black', col.axis = "black")

}

ConfiPlot(5, 1000, 5, 10, 5)