#making R package not an R script
#how many arguments will this accept
#once functions are written, use document()
#' Our first example function
#'
#' @param x number
#' @param ... anything you like!
#'
#' @return another number
#' @export
#'
#' @examples
#' hello(3)
hello = function(x, ...)
{
  print("Que onda")
  x+1
}

#' Initial matrix with corners infected
#'
#' @param nrow  number of rows
#' @param ncol number of columns
#'
#' @return SIRmatrix
#' @export
#'
#' @examples
#' infect_corner(4,6)
infect_corner = function(nrow, ncol)
{
  x = matrix(0, nrow = nrow, ncol = ncol)
  x[1,1] =1
  x[1,ncol] =1
  x[nrow, 1] = 1
  x[nrow, ncol] =1
  #redefine x as a new class
  #allows plot(x) to work (later)
  class(x) = c("SIRmatrix" , class(x))
  return(x)
}

#' One step of SIRmatrix model
#'
#' @param x SIRmatrix
#' @param prob probability of infected neighbors of an infected cell
#'
#' @return SIRmatrix
#' @export
#'
#' @examples
#' A = infect_corner(10,10)
#' A =step(A, 0.25)
step<- function(x, prob)
{

  # make a slightly bigger matrix, so we don't have to worry about the boundaries.
  nr2 = nrow(x) + 2
  nc2 = ncol(x) + 2
  x2 <- matrix(0, nrow = nr2, ncol = nc2)
  infected <- which(x == 1, arr.ind = TRUE) + 1
  ni <- nrow(infected)

  directions <- c(-1, 0, 1)
  # Don't worry about cells that are already infected or removed
  for(i in directions){
    for(j in directions){
      infect_ij <- infected
      infect_ij[, "row"] <- infect_ij[, "row"] + i
      infect_ij[, "col"] <- infect_ij[, "col"] + j
      new_inf_rows <- sample(c(TRUE, FALSE), size = ni,
                             prob = c(prob, 1-prob), replace = TRUE)
      new_infect <- infect_ij[new_inf_rows, , drop= FALSE]
      x2[new_infect] <- 1
    }
  }

  # Remove the edges from the too big matrix
  result <- x2[-c(1, nr2), -c(1, nc2)]

  # Fix the cells that are already infected or removed
  result[1 <= x] <- 2

  class(result) = c("SIRmatrix" , class(result))
  return(result)
}

#' Simulating SIRmatrix until no infected cells remain
#'
#' @param A SIRmatrix
#' @param prob probability to infect neighbors
#'
#' @return list of iterations, probability, proportion infected, and final matrix
#' @export
#'
#' @examples
#' A = infect_corner(10,10)
#' simulate_sir(A, 0.25)
simulate_sir = function(A, prob)
{
  #disease is alive if there is any 1's.
  diseaseAlive = any(A==1)
  i =0

  #while the disease continues...
  while(diseaseAlive)
  {
    A = step(A, prob)
    diseaseAlive = any(A==1)
    i =i+1
  }

  #plot matrix
  #plotMatrix(A)

  proportionInfected = sum(A==2)/(nrow(A)*ncol(A))

  lista= list(iterations =i,
              probability = prob,
              proportion= proportionInfected,
              matrix = A)
  return(lista)
}

#' Plot the SIRmatrix
#'
#' @param x SIRMatrix
#' @param col list of three colors you want to represent SIR
#' @param ... any other parameter to pass into image()
#'
#' @return plot of the matrix
#' @export
#'
#' @examples
#' A = random_infect(10,10)
#' plot(A)
#'
#' @importFrom graphics image
plot.SIRmatrix = function(x, col = c("white","red", "gray"), ...)
{
  # ... means pass through every other argument on to the next function
  rows <- seq(nrow(x))
  x2 <- t(x[rev(rows), ])
  image(x2, zlim=c(0,2), col = col, axes = FALSE, ...)
}

#' Randomly infect SIR model.
#'
#' @param rows number of rows
#' @param columns number of columns
#' @param proportion proportion to initally infect population
#'
#' @return matrix with randomly infected population of proportion p
#' @export
#'
#' @examples
#' random_infect(8,8)
random_infect = function(rows, columns, proportion = 0.1)
{
  #only 10% (or p) of population will be initially infected
  totalPop = rows*columns
  initialInfectedNum = ceiling(totalPop*proportion)

  #get random (rows,columns) cells to be infected
  randRows = sample(1:rows, initialInfectedNum, replace = TRUE)
  randColumns = sample(1:columns, initialInfectedNum, replace = TRUE)


  #initialize matrix
  A = matrix(0, nrow = rows, ncol=columns)

  #infect random population
  #line below didnt work because it would do cross product of rows and columns. i only want corresponding indeces.
  #A[randInfectedTable$row, randInfectedTable$col] = 1

  for (i in 1:length(randRows))
  {
    A[randRows[i], randColumns[i]] = 1
  }

  #change class to SIRmatrix so plot works
  class(A) = c("SIRmatrix" , class(A))
  return(A)
}

#' Summary of each column of SIR matrix
#'
#' @param object matrix
#' @param ... any other parameters to be passed into summary()
#'
#' @return summary list showing total cells, Susceptible, Infected, Removed
#' @export
#'
#' @examples
#' A = infect_corner(10,10)
#' summary(A)
summary.SIRmatrix = function(object,...)
{

  total = length(object)

  list(totalCells= length(object),
       susceptible = sum(object==0)/total,
       infected = sum(object ==1)/total,
       removed = sum(object==2)/total)
}
