install.packages("RMySQL")
library(RMySQL)
library(DBI)
library(tidyverse)
library(showtext)

font_add_google("Nanum Myeongjo", family = 'ExtraBold 800')
showtext_auto()

#construct the SQL driver
concat <- dbConnect(RMySQL::MySQL(), 
                    dbname = 'ukaccidents',
                    host = '127.0.0.1',
                    port = 3306,
                    user ='root',
                    password = 'Jiac199727')

dbListTables(concat)
Avg_severity <- dbReadTable(concat,'avg_severity') #import table to build chart

Avg_severity$Vehicle_type <- str_wrap(Avg_severity$Vehicle_type,5)
plt <-Avg_severity %>% filter(Vehicle_type != Avg_severity$Vehicle_type[15]) %>%
  ggplot(aes(reorder(Vehicle_type,Total),Total,fill=Vehicle_type)) +  
  geom_col(position= 'dodge2',
           alpha=0.9) +
  geom_hline(aes(yintercept = y),
             data.frame(y=c(0,60000,115000,170000)),
             color= 'grey',
             size= 0.2) +
  geom_segment(aes(
    x = Vehicle_type,
    y = 0,
    xend = Vehicle_type,
    yend = 170000
  ),
  linetype = 'dashed',
  color = 'black',
  size= 0.5) +
  coord_polar() +
  annotate(x = 11.5,
           y= 160000,
           label='170000',
           geom='text',
           color='black',
           angle=-65,
           family='Nanum Myeongjo')+
  annotate(x = 11.5,
           y= 105000,
           label='115000',
           geom='text',
           color='black',
           angle=-65,
           family='Nanum Myeongjo')+
  annotate(x = 11.5,
           y= 50000,
           label='60000',
           geom='text',
           color='black',
           angle=-65,
           family='Nanum Myeongjo')+
  scale_y_continuous(
    limits = c(-75000, 185000),
    expand = expansion(c(0, 0)),
    breaks = c(0, 70000 , 14000, 180000)) + 
  theme_minimal()+
  labs(
    title= '\nUK Accidents in 2022',
    subtitle=  paste('\nThis visualization shows the total ammount of accidents',
                     'in UK territory in 2022 grouped by the type of vehicle involved.',
                     sep='\n'),
    caption= "\n\nData Visualisation by Jorge Aranda \nSource: 
    UK Goverment, Road accidents and safety statistics\nLink to Data: 
    https://www.gov.uk/government/collections/road-accidents-and-safety-statistics#road-safety-data") +
  theme_minimal(base_size = 15) +
  theme(
    text = element_text(color = "black", 
                        family = 'Nanum Myeongjo'),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text.y = element_blank(),
    axis.text.x = element_text(color= 'black',
                               size = 12),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_blank(),
    legend.position = "none",
    plot.title = element_text(size=25,
                              hjust=0.05,
                              vjust=1),
    plot.subtitle = element_text(size=15,
                                 hjust=0.05),
    plot.caption= element_text(size = 10, 
                               hjust =.5))
plt

ggsave("plot.pdf",plt, width=9, height=12.6, scale=1)
     
      