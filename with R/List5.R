library(ggplot2)
library(MASS)

T_Anderson <- function(N, L, Lam){
  
 return (sqrt((N - 1) / 2) * (L - Lam) / Lam)

}

AndersonHist <- function(Mu, Sigma, N, Trial){
 
  Lam <- eigen(Sigma)$values[1] # 母固有値

  L <- numeric(100 * Trial) # 標本を抽出する度にその固有値を入れるためのベクトル
  values <- numeric(100 * Trial) # (100 * Trial)の回数だけAnderson()の結果を得て，
                                   # それを入れるベクトル

    for(i in 1:(100 * Trial)){ # (100 * Trial)の回数だけAnderson()の結果を得る．
                               # その結果をAndersonに蓄積する．

      Sam <- mvrnorm(N, Mu, Sigma) #多次元正規分布に従う独立な確率ベクトルをN組発生．
                                   #ただしSigmaは対称行列で正定値行列
      L[i] <- (prcomp(Sam)$sdev[1]) ^ 2 # 標本固有値
      values[i] <- T_Anderson(N, L[i], Lam) # 標本数Nをi回目に抽出して計算したT_Anderson()を
                                              # Anderson[i]に代入する．

    }

  df <- data.frame(values)
  return(df)
}

Mu0　<-　c(1, 2, 3, 4, 5) #母期待値ベクトル
Sigma0 <- rbind( #母共分散行列，独立な方が標本数が必要
  c(1, 0, -1, 1, -1),
  c(0, 2, 0, 1, 1),
  c(-1, 0, 3, 0, 2),
  c(1, 1, 0, 4, -1),
  c(-1, 1, 2, -1, 5)
)

Mu1　<-　c(-1, -90, -3, -6, -52) #母期待値ベクトル
Sigma1 <- rbind( #母共分散行列，独立な方が標本数が必要
  c(521, 0, -1, 1, -1),
  c(0, 235, 0, 1, 1),
  c(-1, 0, 352, 0, 2),
  c(1, 1, 0, 433, -1),
  c(-1, 1, 2, -1, 5523)
)

Mu2　<-　c(0, 0, 0, 0, 0) #母期待値ベクトル
Sigma2 <- rbind( #母共分散行列，独立な方が標本数が必要
  c(1, 0, 0, 0, 0),
  c(0, 1, 0, 0, 0),
  c(0, 0, 1, 0, 0),
  c(0, 0, 0, 1, 0),
  c(0, 0, 0, 0, 1)
)

Trials <- c(10, 10, 10)

An_a <- AndersonHist(Mu0, Sigma0, 100, Trials[1])
An_b <- AndersonHist(Mu1, Sigma1, 100, Trials[2])
An_c <- AndersonHist(Mu2, Sigma2, 100, Trials[3])

df <- rbind(An_a, An_b, An_c)
trt <- factor(rep(c("Anderson_a", "Anderson_b", "Anderson_c")
                  , Trials * 100))
df_A <- cbind(df, trt)
colnames(df_A) <- c("values", "type")

g <- ggplot(data = df_A, aes(x = values, fill = type))
g <- g + geom_histogram(position="identity", alpha = 0.8, binwidth = 0.1)
plot(g)