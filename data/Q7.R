#Packages
install.packages("data.table")
install.packages("DBI")
install.packages("RMariaDB")
install.packages("ggplot2")
#Libraries
library(data.table)
library(ggplot2)
library(DBI)
library(RMariaDB)
#DB connection
con <- dbConnect(
  RMariaDB::MariaDB(),
  host = "localhost",
  port = 3306,
  user = "root",
  password = "root1122",
  dbname = "sakila"
)

library(data.table)
film      <- as.data.table(dbReadTable(con, "film"))
language  <- as.data.table(dbReadTable(con, "language"))
customer  <- as.data.table(dbReadTable(con, "customer"))
store     <- as.data.table(dbReadTable(con, "store"))
staff     <- as.data.table(dbReadTable(con, "staff"))
payment   <- as.data.table(dbReadTable(con, "payment"))
inventory <- as.data.table(dbReadTable(con, "inventory"))
rental    <- as.data.table(dbReadTable(con, "rental"))
address   <- as.data.table(dbReadTable(con, "address"))
city      <- as.data.table(dbReadTable(con, "city"))

#Q7
library(ggplot2)

avg_rate_by_rating <- film[
  , .(avg_rental_rate = mean(rental_rate)), by = rating
]

ggplot(avg_rate_by_rating,
       aes(x = rating, y = avg_rental_rate)) +
  geom_col() +
  labs(
    title = "Average Rental Rate by Rating",
    x = "Rating",
    y = "Average Rental Rate"
  )












