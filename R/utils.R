# ECOS API period setting
EcosTerm <- function(time,type=c("A","Q","M","D")){
  type=match.arg(type)
  switch(
    type,
    A = as.character(time),
    Q = as.yearqtr(time) %>% format(.,"%YQ%q"),
    M = as.yearmon(time) %>% format(.,"%Y%m"),
    D = as.Date(time) %>% format(.,"%Y%m")
  )
}
