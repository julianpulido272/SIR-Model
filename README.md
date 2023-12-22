

## Introduction

The Susceptible Infected Removed (SIR) model is designed to simulate how a disease spreads across a region.

Susceptible (**S**) - cells that are susceptible to the disease

Infected (**I**) - cells that are currently infected

Removed (**R**) - cells that have gotten the disease, and now are recovered and the disease has been completely removed from the system.

This package utilizes a matrix to design the model with values of 0, 1 and 2 representing Susceptible, Infected, and Removed states respectively. The matrix can be instantiated with a random infected population, or can be instantiated with infected cells in the corner. The model is simulated by taking `step` functions to simulate a spread of the disease. For each step, an infected cell has `p` probability of infecting neighbors, that is any adjacent cell to the infected cell. After each step, every current infected cells turns into **(R)** removed cells which don't contain the infection.

It is reasonable to assume that an infected cell spreading to its neighbor are independent events, and since two infected cells can both infect a common susceptible cell, the event of the susceptible cell getting infected is not mutually exclusive. Given that a susceptible cell has `k` neighbors of infected cells, the probability of getting infected is given by:

$$
P(Susceptible Cell) = 1 - (1- p)^k
$$

Additionally, the infected probability `p` can be altered to model different results. The simulation ends after all infected cells are removed. In a real-case scenario, this model can be simulate how real-world diseases like COVID-19 spread among populations.

## SIR Model

The initial SIR model can be either infected randomly, or only infected by the corners.

### Randomly Infected

Given a number of rows `nrow`, number of columns `ncol` and a `proportion` such that 0 < `proportion` < 1, the function will randomly infect a proportion of the cells of the matrix. Note that the `proportion` is defaulted to 0.1, but can be changed by the user. Shown below we create a matrix with 10 rows and columns with 1 values representing infected states.


```{r}

A =random_infect (10,10, 0.25)
A

#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#>  [1,]    0    0    0    0    0    1    0    0    0     0
#>  [2,]    0    0    1    0    1    0    0    0    0     0
#>  [3,]    1    0    0    1    0    0    0    1    0     1
#>  [4,]    1    0    0    0    1    0    1    0    0     0
#>  [5,]    0    0    0    0    0    0    0    0    1     0
#>  [6,]    0    0    0    1    0    0    0    0    0     0
#>  [7,]    1    0    0    0    0    0    1    0    0     1
#>  [8,]    0    0    0    0    0    1    0    0    0     0
#>  [9,]    0    0    0    0    0    0    0    1    1     0
#> [10,]    1    0    0    0    1    1    1    1    0     0
#> attr(,"class")
#> [1] "SIRmatrix" "matrix"    "array"
```

### Corner Infect

Likewise, the model can initially set to only the corners being infected.

```{r}
library(SIR)

infect_corner(10,10)
#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#>  [1,]    1    0    0    0    0    0    0    0    0     1
#>  [2,]    0    0    0    0    0    0    0    0    0     0
#>  [3,]    0    0    0    0    0    0    0    0    0     0
#>  [4,]    0    0    0    0    0    0    0    0    0     0
#>  [5,]    0    0    0    0    0    0    0    0    0     0
#>  [6,]    0    0    0    0    0    0    0    0    0     0
#>  [7,]    0    0    0    0    0    0    0    0    0     0
#>  [8,]    0    0    0    0    0    0    0    0    0     0
#>  [9,]    0    0    0    0    0    0    0    0    0     0
#> [10,]    1    0    0    0    0    0    0    0    0     1

```

## Plotting

The SIR model can be plotted for easier comprehension on how the model simulates. Note that this function is a wrapper function for `image()`, so any arguments for `image()` are also accepted in this method. The default colors are set to:

white - susceptible

red- infected

gray - removed

However, they can also be changed.

```{r}
library(SIR)

plot(A, main = "SIR Model", frame.plot =TRUE )
```
![image](https://github.com/julianpulido272/SIR-Model/assets/102627602/86afeef4-6942-47ed-b485-483383c3b668)


## Simulation

The SIR model can be simulated to see how the disease spreads among the population. Given matrix `A` and a `probability` , the model can be simulated one step at a time:

```{r}
library(SIR)

A =step(A, 0.15)
plot(A, main = "SIR Model", frame.plot =TRUE )

```
![image](https://github.com/julianpulido272/SIR-Model/assets/102627602/b914c0a0-420a-4f75-bd77-2caaf3c1dbf6)


After each step in the infection stage, every current infected cell (red) becomes gray, and any nearby neighbors who get infected will become red.

The model can also be continuously infected until no more infected cells remain by using the `simulate_sir()` function. Note that this function returns a **list** of the final matrix, iterations, probability, and the proportion that was infected.

```{r}
#A is simulated in the function, but not changed 
listA = simulate_sir(A, 0.2)

subTitle = sprintf("Proportion Infected: %f\nIterations: %d" ,
                   listA$proportion , listA$iterations)

plot(listA$matrix, main= "SIR Model", sub= subTitle)

```
![image](https://github.com/julianpulido272/SIR-Model/assets/102627602/07c867eb-79e4-4a30-9d73-653ec81f029d)


## Summarizing Results

Each model simulation be summarized using the `summary()`, which returns a list displaying the following:

`$totalCells` - number of cells in the total model

`$susceptible` - proportion of cells that have not gotten the disease and are susceptible.

`$infected` - proportion of cells that are currently infected.

`$removed` - proportion of cells removed the disease (immune).

```{r}
summary(listA$matrix)

#> $totalCells
#> [1] 100
#> 
#> $susceptible
#> [1] 0.41
#> 
#> $infected
#> [1] 0
#> 
#> $removed
#> [1] 0.59
```

## Conclusion

The SIR model package incorporates several features to simulate a disease utilizing a matrix. Experiment with different probabilities, matrix sizes, and infection start points to best simulate a real-world disease outbreak.
