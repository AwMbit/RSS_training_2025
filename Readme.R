# README.R

# Note:
# We have chosen to use the Nimble package because JAGS (Just Another Gibbs Sampler) could not be used on our internal systems.
# Nimble provides similar functionality and is compatible with our infrastructure, making it a suitable alternative.
# Installation Instructions for the Nimble R Package

# 1. Install the Nimble package from CRAN
install.packages("nimble",INSTALL_opts= c("--no-multiarch","--no-lock"))

# 2. Load the Nimble package
library(nimble)

# 3. If you encounter an error stating that the URL is unavailable, please check your Artifactory credentials.
#    Ensure that you have the correct access rights and that your credentials are up to date.

# Feel free to edit this document with any additional information or instructions that you think might be useful.

Try the following code and if you have any problems raise an issue on github or send me an instant message

# Load the Nimble package
library(nimble)

# Define a simple Bayesian model
code <- nimbleCode({
  for (i in 1:N) {
    y[i] ~ dnorm(mu, sd = sigma)
  }
  mu ~ dnorm(0, sd = 100)
  sigma ~ dunif(0, 10)
})

# Simulated data
set.seed(123)
N <- 100
y <- rnorm(N, mean = 5, sd = 2)

# Constants and data
constants <- list(N = N)
data <- list(y = y)

# Initial values
inits <- list(mu = 0, sigma = 1)

# Build the model
model <- nimbleModel(code, constants = constants, data = data, inits = inits)

# Compile the model
Cmodel <- compileNimble(model)

# Configure and build MCMC
mcmcConf <- configureMCMC(model)
Rmcmc <- buildMCMC(mcmcConf)

# Compile the MCMC
Cmcmc <- compileNimble(Rmcmc, project = model)

# Run the MCMC
samples <- runMCMC(Cmcmc, niter = 10000, nburnin = 2000, thin = 5)

# Summarize the results
summary(samples)