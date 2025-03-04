####################################################################
## a linear regression example
## section 6.3, pp256ff
library(pscl)
data(absentee)

attach(absentee)

## create variables for regression analysis
y <- (absdem - absrep)/(absdem + absrep)*100
x <- (machdem - machrep)/(machdem + machrep)*100

## environment for passing to JAGS
forJags <- list(y=y[1:21],
                x=x[1:21],
                n=21,
                xstar=x[22])

## initial values, list containing one list, one chain
inits <- list(list(beta=c(0,0),
                   sigma=5,
                   ystar=0,
                   .RNG.seed=1234,   ## seed the RNG explicitly
                   .RNG.name="base::Mersenne-Twister"))

## p259 book
foo <- jags.model(file="regression.bug",
                  data=forJags,
                  inits=inits)

out <- coda.samples(model=foo,
                    variable.names=c("beta","sigma","ystar"),
                    n.iter=50e3)
