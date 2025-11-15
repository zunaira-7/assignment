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
#Tables load
library(data.table)

film      <- fread("film.csv")
language  <- fread("language.csv")
customer  <- fread("customer.csv")
store     <- fread("store.csv")
staff     <- fread("staff.csv")
payment   <- fread("payment.csv")
inventory <- fread("inventory.csv")
rental    <- fread("rental.csv")
dbListTables(con)
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
#Q1
film[rating == "PG" & rental_duration > 5]
#Q2
film[, .(avg_rental_rate = mean(rental_rate)), by = rating]
#Q3
names(language)
q3_counts <- film[, .(num_films = .N), by = language_id]
q3_counts
q3_result <- q3_counts[language, on = "language_id"]
q3_result
#Q4
customer[, .(
  customer_id,
  customer_name = paste(first_name, last_name),
  store_id
)]
store_city <- store[
  address[city, on = "city_id"],   
  on = "address_id",
  .(store_id, city)                
]
#Q4 with city
store_city
q4_with_city <- customer[
  store_city,
  on = "store_id",
  .(
    customer_id,
    customer_name = paste(first_name, last_name),
    store_id,
    city
  )
]
q4_with_city
#Q5
q5 <- payment[
  staff,
  on = "staff_id",
  .(
    payment_id,
    amount,
    payment_date,
    staff_name = paste(i.first_name, i.last_name)
  )
]
q5
#Q5
#rented film_ids
rented_film_ids <- unique(
  inventory[rental, on = "inventory_id", film_id]
)

# never rented Films
q6 <- film[!film_id %in% rented_film_ids]
q6
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












