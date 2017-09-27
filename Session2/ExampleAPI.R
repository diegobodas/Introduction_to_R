###############################################################################
# Date: 29/09/2016
# Author: Diego J. Bodas Sagi
# Company: BBVA Data & Analytics
# File: ExampleAPI.R
# Description: analyze arrival and departure delays (R course)
##############################################################################

# ----- Libraries section -----
library(httr) 
library(RCurl)
library(jsonlite)

# ----- Functions -----
GetEncodedKey <- function(key ="ask for a key: https://www.bbvaapimarket.com/products/paystats"){
  return(base64(key))
}
#OJO: los datos de la conexión caducan en el día
ConnectApi <- function(url = "... credentials"){
  key <- paste("Basic ", GetEncodedKey(), sep = "")
  #print(key)
  type <- "application/json"
  req <- POST(url, add_headers(Authorization = key, Accept = type))
  json <- content(req, as = "text")
  info <- fromJSON(json)
  #print(info)
  return(info$access_token)
}

GetJSONdata <- function(url){
  access_token <- paste("jwt ", ConnectApi(), sep = "")
  print(access_token)
  
  type <- "application/json"
  req <- GET(url, add_headers(Authorization = access_token, Accept = type), content = "json")
  json <- content(req, as = "text")
  info <- fromJSON(json)
  #print(info)
  return(info)
}

#Actual API call
url <- "https://apis.bbva.com/paystats_sbx/2/info/merchants_categories"
GetJSONdata(url)

# Ref: https://www.bbvaapimarket.com/web/api_market/bbva/paystats/documentation
# Gets distribution of payments per category/subcategory and payment amount for a zipcode
# ZipCode = 28002 - Barrio de Prosperidad en Madrid
# De enero a marzo de 2014
# Salida: histograma con los siguientes datos
# El intervalo está delimitado por los límites inferior y superior del pago
# Se muestra el número de transacciones en cada intervalo y el importe medio
url2 <- "https://apis.bbva.com/paystats_sbx/2/zipcodes/28002/payment_distribution?group_by=month&date_min=20140101&date_max=20140331"
info <- GetJSONdata(url2)
# El histograma es una lista con un elemento que es, a su vez, una lista de 3 posiciones (una por mes)
# Traducción: un único histograma que contiene un histograma por mes
histogramData <- as.data.frame(info$data$stats$histogram)

# ----- "Visual Analytics" section -----

# Creamos una función para tratar el histograma de un mes concreto
# Lo de abajo NO funciona, porque "hist" calcula el histograma,
# sin embargo nosotros ya los tenemos calculado, solo queremos
# pintar un gráfico de barras
PrintHistograma <- function(datos, zipcode){
  
  hist(datos$txs, main = paste("Histogram for payments amount for zipcode", zipcode, sep = " "),
       xlab = "Amount", ylab = "Frequency (transactions)",
       border = "blue", col = "green")
}

PrintBarPlot <- function(datos, zipcode){
  
  barplot(datos$txs, main = paste("Histogram for payments amount for zipcode", zipcode, sep = " "),
       xlab = "Amount", ylab = "Frequency (transactions)",
       names.arg = datos$amounts, cex.names=0.8, col = "green")
}

PrintBarPlot(info$data$stats$histogram[[1]], "28002")

PrintGroupedBarPlot <- function(datos, zipcode){
  counts <- cbind(datos[[1]]$txs, datos[[2]]$txs, datos[[3]]$txs)
  namesX <- rep(datos[[1]]$amounts, each = 3)
  barplot(counts, main = paste("Histogram for payments amount for zipcode", zipcode, sep = " "),
          xlab = "Amount", ylab = "Frequency (transactions)",
          # Ahhhhh!!!! Error in barplot.default(counts, main = paste("Histogram for payments amount for zipcode",  
          # : incorrect number of names
          names.arg = namesX, cex.names = 0.8, col = c("darkblue", "red", "green"),
          legend = c("enero", "febrero", "marzo"), beside = TRUE)
}

PrintGroupedBarPlot(info$data$stats$histogram, "28002")
