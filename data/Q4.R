#Packages
install.packages("data.table")
install.packages("DBI")
install.packages("RMariaDB")
#Libraries
library(data.table)
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
#Q4
colnames(store)
colnames(address)
colnames(city)

store_address <- merge(store, address, by = "address_id", all.x = TRUE)
head(store_address)
"city_id" %in% colnames(store_address)  
colnames(store_address)

store_city <- merge(store_address, city, by = "city_id", all.x = TRUE)
store_city <- store_city[, .(store_id, city)]
head(store_city)


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

head(q4_with_city)
