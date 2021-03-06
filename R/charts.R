#' sun shadow chart

#'@title sun shadow chart
#'@description create sun shadow chart using ggplot2
#'@param name coordidnate in RD New or WGS84 (LON)
#'@param data.path data path of shadow angles csv
#'@param AHN3 Default TRUE. Set to FALSE if AHN2 needs to be used.
#'@author Jelle Stuurman
#'@return  data frame with all Projected shading Cass of all calculated shadow angles
sun_shade_angles_chart <- function(name, data.path, AHN3 = FALSE, name.supplement = "", angle_selection_byIndexNr = "all", extract_method = 'bilinear'){
  if(missing(name)){
    name <- ""
  }
  if(AHN3 == TRUE){
    AHN <- "AHN3"
  } else {
    AHN <- "AHN2"
  }
  
  name_trim <- getName_trim(name = name, name.supplement = name.supplement)
  
  data_exists <- file.exists(data_path)
  if(angle_selection_byIndexNr == "all"){
    data <- fread(data_path, data.table = FALSE)
  } else {
    data <- fread(data_path, data.table = FALSE)[angle_selection_byIndexNr]
  }
  #View(data)
  
  # plot(month_all_solar_angles[[1]]$azimuth, month_all_solar_angles[[1]]$elevation, type="l", xlim=c(0,360), ylim=c(0,70), xlab="azimuth", ylab="elevation")
  # for (p in 2:length(month_solar_angles)){
  #   par(new=T)
  #   plot(month_all_solar_angles[[p]]$azimuth, month_all_solar_angles[[p]]$elevation, type="l",  xlim=c(0,360), ylim=c(0,70), axes = FALSE, xlab="", ylab="")
  # }
  # 
  # 
  # plot(ah_sangles[[1]]$azimuth, month_ah_solar_angles[[1]]$elevation, type="l", xlim=c(0,360), ylim=c(0,70), xlab="azimuth", ylab="elevation")
  # for (p in 2:length(month_solar_angles)){
  #   par(new=T)
  #   plot(ah_sangles[[p]]$azimuth, month_ah_solar_angles[[p]]$elevation, type="l",  xlim=c(0,360), ylim=c(0,70), axes = FALSE, xlab="", ylab="")
  # }
  
  if("elevation" %in% colnames(data)){
    solar_angles <- TRUE
  } else {
    solar_angles <- FALSE
  }
  
  if("shadow_angle" %in% colnames(data)){
    shadow_angles <- TRUE
  } else {
    shadow_angles <- FALSE
  }
  
  if((solar_angles == TRUE & shadow_angles == TRUE) | data_exists == TRUE){
    #add shadow chart, layout, axes and labels
    chart <- ggplot(data, aes(x=azimuth, y=shadow_angle)) + geom_area() +
      #ggtitle(paste("Sun and shadow chart for", name_trim)) +
      #labs(fill = "Your Title") +
      #labs(x = "azimuth (degrees)", y = "elevation (degrees)") +
      #xlim(48,312) +
      scale_x_continuous(name="azimuth (degrees)", limits=c(50, 310), breaks=seq(50,310,50)) +
      scale_y_continuous(name="elevation (degrees)", limits=c(0, 65), breaks=seq(0,65,10)) +
      #ylim(0,65) +# scale_y_continuous(breaks=seq(0,70,10)) +
      theme_bw() +
      theme(text = element_text(size=12))
      #scale_colour_manual("", breaks = c("21 June", "21 May", "21 April", "21 March", "21 February", "21 January", "21 December"), values = c("21 December"="black", "21 January"="purple", "21 February"="orange", "21 March"="brown", "21 April"="green", "21 May"="yellow", "21 June"="red"))
    
    breaks_list <- c()
    values_list <- c()
    
    #add present months
    if("21-Jun" %in% data$day == TRUE){
      chart <- chart + geom_line(data = filter(data, day == "21-Jun"), aes(x=azimuth, y=elevation, colour="21 June")) 
      breaks_list <- cbind(breaks_list, "21 June")
      values_list <- cbind(values_list, "21 June"="yellow")
    }
    if("21-May" %in% data$day == TRUE){
      chart <- chart + geom_line(data = filter(data, day == "21-May"), aes(x=azimuth, y=elevation, colour="21 May")) 
      breaks_list <- cbind(breaks_list, "21 May")
      values_list <- cbind(values_list, "21 May"="black")
    }
    if("21-Apr" %in% data$day == TRUE){
      chart <- chart + geom_line(data = filter(data, day == "21-Apr"), aes(x=azimuth, y=elevation,  colour="21 April"))
      breaks_list <- cbind(breaks_list, "21 April")
      values_list <- cbind(values_list, "21 April"="blue")
    }
    if("21-Mar" %in% data$day == TRUE){
      chart <- chart + geom_line(data = filter(data, day == "21-Mar"), aes(x=azimuth, y=elevation, colour="21 March"))
      breaks_list <- cbind(breaks_list, "21 March")
      values_list <- cbind(values_list, "21 March"="purple")
    } 
    if("21-Feb" %in% data$day == TRUE){
      chart <- chart + geom_line(data = filter(data, day == "21-Feb"), aes(x=azimuth, y=elevation, colour="21 February"))
      breaks_list <- cbind(breaks_list, "21 February")
      values_list <- cbind(values_list, "21 February"="red")
    } 
    if("21-Jan" %in% data$day == TRUE){
      chart <- chart + geom_line(data = filter(data, day == "21-Jan"), aes(x=azimuth, y=elevation, colour="21 January"))
      breaks_list <- cbind(breaks_list, "21 January")
      values_list <- cbind(values_list, "21 January"="green")
    }
    if("21-Dec" %in% data$day == TRUE){
      chart <- chart + geom_line(data = filter(data, day == "21-Dec"), aes(x=azimuth, y=elevation, colour="21 December"))
      breaks_list <- cbind(breaks_list, "21 December")
      values_list <- cbind(values_list, "21 December"="orange")
    }  
    
    #add legend
    chart <- chart + scale_colour_manual("", breaks = breaks_list, values = values_list)
    
    if(name != ""){
      ggsave(paste0("output/", name_trim, "/solar_shadow_angles/", name_trim, "_", AHN, "_", extract_method, "_solar_shadow_chart.png"))
      #ggsave("test.png")
    } else {
      #ggsave(paste0("output/solar_shadow_angles/", AHN, "_", extract_method, "_solar_shadow_chart.png"))
      #ggsave("test.png")
    }
    
    return(chart)
  }
}