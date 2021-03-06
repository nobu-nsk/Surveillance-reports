# -------------------------------------------------
# Figures in the global report
# Tom Hiatt
# 10 July 2012, revised 28 June 2013
# -------------------------------------------------

source('d:/users/hiattt/Dropbox/Code/Global TB control Reports/Tables and Figures/2013/Setup.r')

# This next chunk is for testing
# --------------------------------------------------------
ggplot(subset(gac, year>=gadstart), aes(year, hivtest_pct, colour=area)) + 
  geom_line(size=1.5) + geom_text(data=subset(gac, year==max(gac$year)), aes(label = area), hjust=-.1, vjust=0, size=5) +
  scale_y_continuous(name = "Percentage of TB patients", limits=c(0,100)) + #, expand=c(0,0)
  scale_x_continuous("", labels=gadstart:(thisyear-1), breaks=gadstart:(thisyear-1)) + 
  scale_color_brewer(name="WHO region", palette="Dark2") +
  expand_limits(x=c(gadstart, thisyear+0.5)) + theme_bw() +
  opts(title=glue('HIV testing for TB patients, globally and by WHO region, ', gadstart, '-', thisyear-1), legend.position="none")


# Bit's I'm going to implement:
#   - Always show 0 (and not 0.0)
#   - Always expand for a comfy fit
#   - Labels be in the color of the lines where applicable
#   - Titles left justified
#   - label range always includes all data
#   - All use same color palette

plot.title=theme_text(size=16, hjust=0)

dat<-data.frame(x=1:10, y=c(11:17,5:3))
ggplot(dat, aes(x,y)) + 
  geom_point() + expand_limits(y=c(min(pretty(c(dat$y, min(dat$y) * (0.95)))), max(pretty(c(dat$y, max(dat$y) * (1.05))))))


#----------------------------------------------------
# Global rates of incidence, prevalence and mortality - est_global
#----------------------------------------------------

eza <- subset(a.t, group_type=='global')

p1 <- qplot(year, e_inc_100k, data=eza, geom='line', colour=I('#00FF33')) +
  geom_ribbon(aes(year, ymin=e_inc_100k_lo, ymax=e_inc_100k_hi), fill=I('#00FF33'), alpha=0.4) +
#   geom_line(aes(year, newrel_100k)) + 
  geom_line(aes(year, e_inc_tbhiv_100k), colour=I('red')) +      
  geom_ribbon(aes(year, ymin=e_inc_tbhiv_100k_lo, ymax=e_inc_tbhiv_100k_hi), fill=I('red'), alpha=0.4) +
  #   facet_wrap(~g_whoregion, scales='free_y') +
  scale_x_continuous('', breaks=c(seq(1990, 2005, 5), thisyear-1)) + ylab('Rate per 100 000 population') +
  expand_limits(y=c(0, max(pretty(c(eza$e_inc_100k_hi, max(eza$e_inc_100k_hi) * (1.20)))))) + theme_bw() + theme(legend.position='none', plot.title = element_text(hjust = 0)) + ggtitle('Incidence')
  
  
  
  
  qplot(year, e_inc_100k, data=subset(a.t, group_type=='global'), geom='line', colour=I('blue')) +
  geom_ribbon(aes(year, ymin=e_inc_100k_lo, ymax=e_inc_100k_hi), fill=I('blue'), alpha=0.4) +
  geom_line(aes(year, e_inc_tbhiv_100k), colour=I('red')) +
  geom_ribbon(aes(year, ymin=e_inc_tbhiv_100k_lo, ymax=e_inc_tbhiv_100k_hi), 
              fill=I('red'), alpha=0.4) +
  ylab('Rate per 100 000 population') + xlab('') +
  expand_limits(y=0) +
  theme_bw(base_size=10) + ggtitle('Incidence') +
  theme(legend.position='none', plot.title = element_text(hjust = 0))

p2 <- qplot(year, mort.nh, data=global.ff, geom='line', colour=I('blue'), linetype=forecast) +
  geom_ribbon(aes(year, ymin=mort.nh.lo, ymax=mort.nh.hi), fill=I('blue'), alpha=0.4) +
  geom_hline(aes(yintercept=mort.nh[1] / 2), linetype=2) +
  ylab('') + xlab('') +
  expand_limits(y=0) +
  theme_bw(base_size=10) +
  opts(legend.position='none', title='Mortality')

p3 <- qplot(year, prev, data=global.ff, geom='line', colour=I('blue'), linetype=forecast) +
  geom_ribbon(aes(year, ymin=prev.lo, ymax=prev.hi), fill=I('blue'), alpha=0.4) +
  geom_hline(aes(yintercept=prev[1] / 2), linetype=2) +
  ylab('') + xlab('') +
  expand_limits(y=0) +
  theme_bw(base_size=10) +
  opts(legend.position='none', title='Prevalence')

pdf(width=8, height=4, file='Figs/fig_global.pdf', 
    title='Global trends in case notification rates and estimated rates of incidence, morality and prevalence.') 

grid.arrange(p1, p2, p3, nrow=1)
dev.off()

write.csv(merge(global[c('year', 'inc', 'inc.lo', 'inc.hi', 'inc.h', 'inc.h.lo', 'inc.h.hi', 'newrel')], 
                global.ff[c('year', 'mort.nh', 'mort.nh.lo', 'mort.nh.hi', 'prev', 'prev.lo', 'prev.hi')], all=T), 
          file=paste(outfolder, "/FigData/", "fig_global", ".csv", sep=""), row.names=F, na="")

# No longer relevant I think
# # Global incidence and case notifications; fig_global_incnotif
# 
# p1.1 <- qplot(year, inc, data=global, geom='line', colour=I('blue')) +
#   geom_ribbon(aes(year, ymin=inc.lo, ymax=inc.hi), fill=I('blue'), alpha=0.4) +
#   # geom_line(aes(year, inc.h), colour=I('red')) +
#   geom_line(aes(year, newrel)) + 
#   # geom_ribbon(aes(year, ymin=inc.h.lo, ymax=inc.h.hi), 
#   # fill=I('red'), alpha=0.4) +
#   ylab('Rate per 100 000 population') + xlab('') +
#   expand_limits(y=0) +
#   theme_bw(base_size=10) +
#   opts(legend.position='none', title='Global trends in estimated incidence and case notification rates, 1990?2010')
# 
# # p1.1; dev.off()
# ggsave(paste(outfolder, "/Figs/", "fig_global_incnotif", ".pdf", sep=""), p1.1, width=7, height=7)


#----------------------------------------------------
# Global rates of incidence, and notifications
#----------------------------------------------------

eha <- subset(a.t, group_type=="global")

ehb <- merge(subset(eha, select=c("group_name", "year", "e_inc_100k", "e_inc_100k_lo", "e_inc_100k_hi", "e_inc_tbhiv_100k", "e_inc_tbhiv_100k_lo", "e_inc_tbhiv_100k_hi", "e_pop_num")), aggregate(n.t['c_newinc'], by=list(year=n.t$year), FUN=sum, na.rm=TRUE))

ehb$newrel_100k <- ehb$c_newinc / ehb$e_pop_num * 100000

ehc <- qplot(year, e_inc_100k, data=ehb, geom='line', colour=I('#00FF33')) +
  geom_ribbon(aes(year, ymin=e_inc_100k_lo, ymax=e_inc_100k_hi), fill=I('#00FF33'), alpha=0.4) +
  geom_line(aes(year, newrel_100k)) + 
  # geom_line(aes(year, inc.h), colour=I('red')) +      
  # geom_ribbon(aes(year, ymin=inc.h.lo, ymax=inc.h.hi), 
  # fill=I('red'), alpha=0.4) +
#   facet_wrap(~g_whoregion, scales='free_y') +
  scale_x_continuous('', breaks=c(seq(1990, 2005, 5), thisyear-1)) + ylab('Rate per 100 000 population per year') +
  expand_limits(y=c(0, max(pretty(c(ehb$e_inc_100k_hi, max(ehb$e_inc_100k_hi) * (1.20)))))) + theme_bw() + 
  opts(title=paste('Global trends in case notification (black) and estimated TB \nincidence (green) rates, 1990–', thisyear-1, sep="")) 

figsave(ehc, ehb, "inc_notif_glo", width=6, height=6)

# Incidence only

ehd <- qplot(year, e_inc_100k, data=ehb, geom='line', colour=I('#00FF33')) +
  geom_ribbon(aes(year, ymin=e_inc_100k_lo, ymax=e_inc_100k_hi), fill=I('#00FF33'), alpha=0.4) +
#   geom_line(aes(year, newrel_100k)) + 
  geom_line(aes(year, e_inc_tbhiv_100k), colour=I('red')) +
  geom_ribbon(aes(year, ymin=e_inc_tbhiv_100k_lo, ymax=e_inc_tbhiv_100k_hi), 
              fill=I('red'), alpha=0.4) +
  #   facet_wrap(~g_whoregion, scales='free_y') +
  scale_x_continuous('', breaks=c(seq(1990, 2005, 5), thisyear-1)) + ylab('Rate per 100 000 population per year') +
  expand_limits(y=c(0, max(pretty(c(ehb$e_inc_100k_hi, max(ehb$e_inc_100k_hi) * (1.20)))))) + theme_bw() + 
  opts(title=paste('Global trends in case notification (black) and estimated TB \nincidence (green) rates, 1990–', thisyear-1, '.', sep="")) 

figsave(ehd, ehb, "inc_glo", width=7)


#----------------------------------------------------
# Regional rates of incidence, and notifications
#----------------------------------------------------

efa1 <- subset(a.t, group_type=="g_whoregion")

# names(regional) <- gsub ('_', '\\.', names (regional))
efa1$g_whoregion <- factor(efa1$group_name, labels=c("Africa", "The Americas", "Eastern Mediterranean", "Europe", "South-East Asia", "Western Pacific"))

efa <- merge(subset(efa1, select=c("group_name", "g_whoregion", "year", "e_inc_100k", "e_inc_100k_lo", "e_inc_100k_hi", "e_inc_tbhiv_100k", "e_inc_tbhiv_100k_lo", "e_inc_tbhiv_100k_hi", "e_pop_num")), aggregate(n.t['c_newinc'], by=list(group_name=n.t$g_whoregion, year=n.t$year), FUN=sum, na.rm=TRUE))

efa$newrel_100k <- efa$c_newinc / efa$e_pop_num * 100000

# a fudging to get values on top
topper <- function(dat){
  dat$top <- max(pretty(c(dat$e_inc_100k_hi, max(dat$e_inc_100k_hi) * (1.1))))
  return(dat)
}
efc <- ddply(efa, "g_whoregion", topper)

efb <- qplot(year, e_inc_100k, data=efc, geom='line', colour=I('#00FF33')) +
  geom_ribbon(aes(year, ymin=e_inc_100k_lo, ymax=e_inc_100k_hi), fill=I('#00FF33'), alpha=0.4) +
  geom_line(aes(year, newrel_100k)) + 
  # geom_line(aes(year, inc.h), colour=I('red')) +      
  # geom_ribbon(aes(year, ymin=inc.h.lo, ymax=inc.h.hi), 
  # fill=I('red'), alpha=0.4) +
  facet_wrap(~g_whoregion, scales='free_y') +
  scale_x_continuous('', breaks=c(seq(1990, 2005, 5), thisyear-1)) + ylab('Rate per 100 000 population per year') +
  expand_limits(y=0) + geom_point(aes(year, top), alpha=0) +
  theme_bw() + 
  opts(title=paste('Case notification and estimated TB incidence rates by WHO region, 1990–', thisyear-1, '.', sep="")) 

figsave(efb, efa, "inc_notif_reg")

# Incidence only

efd <- qplot(year, e_inc_100k, data=efc, geom='line', colour=I('green')) +
  geom_ribbon(aes(year, ymin=e_inc_100k_lo, ymax=e_inc_100k_hi), fill=I('green'), alpha=0.4) +
#   geom_line(aes(year, newrel_100k)) + 
  geom_line(aes(year, e_inc_tbhiv_100k), colour=I('red')) +
  geom_ribbon(aes(year, ymin=e_inc_tbhiv_100k_lo, ymax=e_inc_tbhiv_100k_hi), 
  fill=I('red'), alpha=0.4) +
  facet_wrap(~g_whoregion, scales='free_y') +
  scale_x_continuous('', breaks=c(seq(1990, 2005, 5), thisyear-1)) + ylab('Rate per 100 000 population per year') +
  expand_limits(y=0) + geom_point(aes(year, top), alpha=0) +
  theme_bw() + 
  ggtitle(paste('Estimated TB incidence rates by WHO region, 1990–', thisyear-1, '.', sep="")) 

figsave(efd, efa, "inc_reg")

#----------------------------------------------------
# HBC rates of incidence, and notifications
#----------------------------------------------------

ega <- subset(e.t, g_hbc22=="high")

egb <- .shortnames(merge(subset(ega, select=c("country", "g_whoregion", "year", "e_inc_100k", "e_inc_100k_lo", "e_inc_100k_hi", "e_inc_tbhiv_100k", "e_inc_tbhiv_100k_lo", "e_inc_tbhiv_100k_hi", "e_pop_num")), subset(n.t, select=c('country', 'year', 'c_newinc'))), ord='multiyear')

egb$newrel_100k <- egb$c_newinc / egb$e_pop_num * 100000

# a fudging to get values on top
# topper <- function(dat){
#   dat$top <- max(pretty(c(dat$e_inc_100k_hi, max(dat$e_inc_100k_hi) * (1.1))))
#   return(dat)
# }
# egc <- ddply(egb, "country", topper)

egd <- qplot(year, e_inc_100k, data=egb, geom='line', colour=I('green')) +
  geom_ribbon(aes(year, ymin=e_inc_100k_lo, ymax=e_inc_100k_hi), fill=I('green'), alpha=0.4) +
  geom_line(aes(year, newrel_100k)) + 
  # geom_line(aes(year, inc.h), colour=I('red')) +      
  # geom_ribbon(aes(year, ymin=inc.h.lo, ymax=inc.h.hi), 
  # fill=I('red'), alpha=0.4) +
  facet_wrap(~country, scales='free_y') +
  scale_x_continuous('', breaks=c(seq(1990, 2005, 5), thisyear-1)) + ylab('Rate per 100 000 population per year') +
  expand_limits(y=0) + # geom_point(aes(year, top), alpha=0) +
  theme_bw() + 
  ggtitle(paste('Case notification and estimated TB incidence rates, 22 high-burden countries, 1990–', thisyear-1, '.', sep="")) 

figsave(egd, egb, "inc_notif_hbc")

# Incidence only

ege <- qplot(year, e_inc_100k, data=egb, geom='line', colour=I('green')) +
  geom_ribbon(aes(year, ymin=e_inc_100k_lo, ymax=e_inc_100k_hi), fill=I('green'), alpha=0.4) +
  #   geom_line(aes(year, newrel_100k)) + 
  geom_line(aes(year, e_inc_tbhiv_100k), colour=I('red')) +
  geom_ribbon(aes(year, ymin=e_inc_tbhiv_100k_lo, ymax=e_inc_tbhiv_100k_hi), 
              fill=I('red'), alpha=0.4) +
                facet_wrap(~country, scales='free_y') +
                scale_x_continuous('', breaks=c(seq(1990, 2005, 5), thisyear-1)) + ylab('Rate per 100 000 population per year') +
                expand_limits(y=0) + # geom_point(aes(year, top), alpha=0) +
                theme_bw() + 
                ggtitle(paste('Estimated TB incidence rates, 22 high-burden countries, 1990–', thisyear-1, '.', sep="")) 

figsave(ege, egb, "inc_hbc")

#----------------------------------------------------
# Global rates of TB prevalence
#----------------------------------------------------

# countryestimates <- load(url("https://dl.dropbox.com/u/454007/est.Rdata"))
# regionalestimates <- load(url("https://dl.dropbox.com/u/454007/regional.Rdata"))
# globalestimates <- load(url("https://dl.dropbox.com/u/454007/global.Rdata"))

epb <- subset(a.t, group_type=="global", select=c("group_name", "year", "e_prev_100k", "e_prev_100k_lo", "e_prev_100k_hi"))

epc <- qplot(year, e_prev_100k, data=epb, geom='line', colour=I('orange')) +
  geom_ribbon(aes(year, ymin=e_prev_100k_lo, ymax=e_prev_100k_hi), fill=I('orange'), alpha=0.4) +
  
  #   facet_wrap(~g_whoregion, scales='free_y') +
  scale_x_continuous('', breaks=c(seq(1990, 2005, 5), thisyear-1)) + ylab('Rate per 100 000 population') +
  expand_limits(y=c(0, max(pretty(c(epb$e_inc_100k_hi, max(epb$e_inc_100k_hi) * (1.20)))))) + theme_bw() + 
  opts(title=glue('Global trends in estimated TB prevalence rates, 1990–', thisyear-1, " \nand forecast TB prevalence rates ", thisyear, "–2015, by WHO region.")) 

figsave(epc, epb, "prev_glo", width=6, height=6)


#----------------------------------------------------
# Regional rates of TB prevalence
#----------------------------------------------------

regional <- subset(araw.t, group_type=="g_whoregion")

  
regional$g_whoregion <- factor(regional$group_name, labels=c("Africa", "The Americas", "Eastern Mediterranean", "Europe", "South-East Asia", "Western Pacific"))

efa <- merge(subset(regional, select=c("group_name", "g_whoregion", "year", "e_inc_100k", "e_inc_100k_lo", "e_inc_100k_hi", "e_inc_tbhiv_100k", "e_inc_tbhiv_100k_lo", "e_inc_tbhiv_100k_hi", "e_pop_num")), aggregate(n.t['c_newinc'], by=list(group_name=n.t$g_whoregion, year=n.t$year), FUN=sum, na.rm=TRUE))

efa$newrel_100k <- efa$c_newinc / efa$e_pop_num * 100000

# a fudging to get values on top
topper <- function(dat){
  dat$top <- max(pretty(c(dat$e_inc_100k_hi, max(dat$e_inc_100k_hi) * (1.1))))
  return(dat)
}
efc <- ddply(efa, "g_whoregion", topper)

efb <- qplot(year, e_inc_100k, data=efc, geom='line', colour=I('orange')) +
  geom_ribbon(aes(year, ymin=e_inc_100k_lo, ymax=e_inc_100k_hi), fill=I('orange'), alpha=0.4) +
  geom_line(aes(year, newrel_100k)) + 
  # geom_line(aes(year, inc.h), colour=I('red')) +      
  # geom_ribbon(aes(year, ymin=inc.h.lo, ymax=inc.h.hi), 
  # fill=I('red'), alpha=0.4) +
  facet_wrap(~g_whoregion, scales='free_y') +
  scale_x_continuous('', breaks=c(seq(1990, 2005, 5), thisyear-1)) + ylab('Rate per 100 000 population') +
  expand_limits(y=0) + geom_point(aes(year, top), alpha=0) +
  theme_bw() + 
  opts(title=paste('Case notification and estimated TB incidence rates by WHO region, 1990–', thisyear-1, '.', sep="")) 

figsave(efb, efa, "prev_reg")

#----------------------------------------------------
# HBC rates of incidence, and notifications
#----------------------------------------------------

ega <- .shortnames(subset(e.t, g_hbc22=="high"))

egb <- merge(subset(ega, select=c("country", "g_whoregion", "year", "e_inc_100k", "e_inc_100k_lo", "e_inc_100k_hi", "e_inc_tbhiv_100k", "e_inc_tbhiv_100k_lo", "e_inc_tbhiv_100k_hi", "e_pop_num")), subset(n.t, select=c('country', 'year','c_newinc')))

egb$newrel_100k <- egb$c_newinc / egb$e_pop_num * 100000

# a fudging to get values on top
topper <- function(dat){
  dat$top <- max(pretty(c(dat$e_inc_100k_hi, max(dat$e_inc_100k_hi) * (1.1))))
  return(dat)
}
egc <- ddply(egb, "country", topper)

egd <- qplot(year, e_inc_100k, data=egc, geom='line', colour=I('orange')) +
  geom_ribbon(aes(year, ymin=e_inc_100k_lo, ymax=e_inc_100k_hi), fill=I('orange'), alpha=0.4) +
  geom_line(aes(year, newrel_100k)) + 
  # geom_line(aes(year, inc.h), colour=I('red')) +      
  # geom_ribbon(aes(year, ymin=inc.h.lo, ymax=inc.h.hi), 
  # fill=I('red'), alpha=0.4) +
  facet_wrap(~country, scales='free_y') +
  scale_x_continuous('', breaks=c(seq(1990, 2005, 5), thisyear-1)) + ylab('Rate per 100 000 population per year') +
  expand_limits(y=0) + geom_point(aes(year, top), alpha=0) +
  theme_bw() + 
  opts(title=paste('Case notification and estimated TB incidence rates, 22 high-burden countries, 1990–', thisyear-1, '.', sep="")) 

figsave(egd, egb, "inc_notif_hbc")


#----------------------------------------------------
# Country and regional Profiles - Incidence, prevalence and mortality in 22 HBCs
#----------------------------------------------------

cpfd1 <- merge(n, eraw,)
rpfd <- aggregate(cpfd1['c_newinc'], by=list(group_name=cpfd1$g_whoregion, year=cpfd1$year), FUN=sum, na.rm=TRUE)
rpfd <- merge(rpfd, araw)
cpfd1$group_name <- cpfd1$country
cpfd <- merge(cpfd1, rpfd, all=T)

# Incidence 

hest <- subset(cpfd, g_hbc22=='high' | group_name %in% rpfd$group_name)
levels(hest$group_name)[match('Democratic Republic of the Congo', levels(hest$group_name))] <- 'DR Congo'
levels(hest$group_name)[match('United Republic of Tanzania', levels(hest$group_name))] <- 'UR Tanzania'
hest$c_newinc_100k <- hest$c_newinc / hest$e_pop_num * 1e5

pdf(width=14, height=9.5, file='CPFigs/hbc_cp_inc.pdf')
# windows(14,9.5) windows(3, 0.87)
qplot(year, e_inc_100k, data=hest, geom='line', colour=I('green')) +
  geom_ribbon(aes(year, ymin=e_inc_100k_lo, ymax=e_inc_100k_hi), fill=I('green'), alpha=0.4) +
  geom_line(aes(year, e_inc_tbhiv_100k), colour=I('red')) +
  geom_line(aes(year, c_newinc_100k)) + 
  geom_ribbon(aes(year, ymin=e_inc_tbhiv_100k_lo, ymax=e_inc_tbhiv_100k_hi), 
              fill=I('red'), alpha=0.4) +
  facet_wrap(~group_name, scales='free', ncol=4) +
  scale_y_continuous(name = "") +
  scale_x_continuous(name="", expand = c(0, 0)) + 
  expand_limits(y=0) +
  theme_bw(base_size=6) +
  opts(legend.position='none', title='Incidence',
       # panel.grid.major = theme_line(size = 0.5),
       panel.grid.minor = theme_blank())
dev.off()

# Prevalence

pdf(width=14, height=9.5, file='CPFigs/hbc_cp_prev.pdf')
p1 <- qplot(year, e_prev_100k, data=hest, geom='line', colour=I('blue')) +
  geom_ribbon(aes(year, ymin=e_prev_100k_lo, ymax=e_prev_100k_hi), fill=I('blue'), alpha=0.4) +
  # geom_hline(aes(yintercept=target.prev), linetype=2) +
  facet_wrap(~group_name, scales='free', ncol=4) +
  scale_y_continuous(name = "") +
  scale_x_continuous(name="", expand = c(0, 0)) + 
  expand_limits(y=0) +
  theme_bw(base_size=6) +
  opts(legend.position='none', title='Prevalence',
       panel.grid.minor = theme_blank())
print(p1)
dev.off()


# Mortality

pdf(width=14, height=9.5, file='CPFigs/hbc_cp_mort.pdf')
p2 <- qplot(year, e_mort_exc_tbhiv_100k, data=hest, geom='line', colour=I('orange')) +
  geom_ribbon(aes(year, ymin=e_mort_exc_tbhiv_100k_lo, ymax=e_mort_exc_tbhiv_100k_hi), fill=I('orange'), alpha=0.4) +
  # geom_hline(aes(yintercept=target.mort), linetype=2) +
  facet_wrap(~group_name, scales='free', ncol=4) +
  scale_y_continuous(name = "") +
  scale_x_continuous(name="", expand = c(0, 0)) + 
  expand_limits(y=0) +
  theme_bw(base_size=6) +
  opts(legend.position='none', title='Mortality',
       panel.grid.minor = theme_blank())
print(p2)
dev.off()



#-------------------------------------------------------------------
# hivtest_graph
#-------------------------------------------------------------------

gaa <- subset(tbhiv, year>=2004, select=c('g_whoregion', 'year', 'hivtest_pct_denominator', 'hivtest_pct_numerator'))

gaa$regional <- ifelse(gaa$g_whoregion=='AFR', 'African region', 'Regions outside \n  Africa')

gabr <- aggregate(gaa[c('hivtest_pct_denominator', 'hivtest_pct_numerator')], by=list(area=gaa$regional, year=gaa$year), FUN=sum, na.rm=TRUE)
gabg <- aggregate(gaa[c('hivtest_pct_denominator', 'hivtest_pct_numerator')], by=list(year=gaa$year), FUN=sum, na.rm=TRUE)
gabg$area <- 'Global'

gac <- rbind(gabr, gabg)

gac$hivtest_pct <- gac$hivtest_pct_numerator / gac$hivtest_pct_denominator * 100

gadstart <- 2004

gad <- ggplot(subset(gac, year>=gadstart), aes(year, hivtest_pct, colour=area)) + 
  geom_line(size=1.5) + geom_text(data=subset(gac, year==max(gac$year)), aes(label = area), hjust=-.1, vjust=0, size=5) +
  scale_y_continuous(name = "Percentage of TB patients", limits=c(0,85), expand=c(0,0)) + 
  scale_x_continuous("", labels=gadstart:(thisyear-1), breaks=gadstart:(thisyear-1)) + 
  scale_color_brewer(name="WHO region", palette="Dark2") +
  expand_limits(x=c(gadstart, thisyear+0.5)) + theme_bw() +
  opts(title=glue('Percentage of TB patients with known HIV status, ', gadstart, '-', thisyear-1), legend.position="none")

# windows(11, 7); gad; dev.off()
figsave(gad, gac, "hivtest_graph")


#-------------------------------------------------------------------
# hivtest_num
#-------------------------------------------------------------------

gja <- subset(tbhiv, year>=2004, select=c('country', 'g_whoregion', 'year', 'hivtest', 'hivtest_pos'))

# Some assumptions 
cat(glue('There are ', nrow(subset(gja, is.na(hivtest)&!is.na(hivtest_pos)&hivtest_pos!=0)), ' records that reported hivtest_pos, but didn\'t report hivtest. These come up to ', rounder(sum(subset(gja, is.na(hivtest)&!is.na(hivtest_pos)&hivtest_pos!=0, select='hivtest_pos'))), ' cases in hivtest_pos across all years (', rounder(sum(subset(gja, year==thisyear-1 & is.na(hivtest)&!is.na(hivtest_pos)&hivtest_pos!=0, select='hivtest_pos'))),' in ', thisyear-1,'). These cases are added to hivtest total.'))

cat(glue('There are ', nrow(subset(gja, is.na(hivtest_pos)&!is.na(hivtest)&hivtest!=0)), ' records that reported hivtest, but didn\'t report hivtest_pos. These come up to ', rounder(sum(subset(gja, is.na(hivtest_pos)&!is.na(hivtest)&hivtest!=0, select='hivtest'))), ' cases in hivtest across all years (', rounder(sum(subset(gja, year==thisyear-1 & is.na(hivtest_pos)&!is.na(hivtest)&hivtest!=0, select='hivtest'))),' in ', thisyear-1,'). There is no adjustment made for these. i.e. it appears as if all tested negative.'))


gja$hivtest2 <- ifelse(is.na(gja$hivtest), gja$hivtest_pos, gja$hivtest)
gja$neg <- gja$hivtest2 - gja$hivtest_pos
gja$pos <- gja$hivtest_pos

# gja$unk <- gja$hivtest2 - rowSums(cbind(gja$pos, gja$neg), na.rm=TRUE)

gjb <- aggregate(gja[4:ncol(gja)], by=list(year=gja$year), FUN=sum, na.rm=TRUE)

gje <- melt(gjb,id.vars=c('year'), measure.vars=c('pos', 'neg'))
gje$value2 <- gje$value/1000

gjf <- ggplot(gje, aes(factor(year), value2, fill=variable)) + 
  geom_bar(width=0.6, stat='identity') +
  scale_y_continuous(name = "TB patients (thousands)", expand=c(0,0), limits=c(0,3100)) + 
  scale_x_discrete("") + 
  scale_fill_brewer(name="HIV status", palette="Dark2", breaks=rev(levels(gje$variable)), labels=c('Negative', 'Positive')) +
  theme_bw() +
  opts(title=glue('Number of TB patients with known HIV status, ', min(gje$year), '-', max(gje$year)), legend.position=c(0.15, 0.75))

# windows(11, 7); gjf; dev.off()
figsave(gjf, gje, "hivtest_num")

#-------------------------------------------------------------------
# cpt_art_hiv_graph 
#-------------------------------------------------------------------

gca <- subset(tbhiv, year>=2004, select=c('iso3', 'year', 'hivtest_pos', 'hiv_cpt', 'hiv_art'))

gcb <- aggregate(gca[3:ncol(gca)], by=list(year=gca$year), FUN=sum, na.rm=T)

gcc <- melt(gcb, id=1)

gcc$value <- gcc$value/1000

gcd <- ggplot(gcc, aes(year, value, color=variable)) + geom_line(size=1) +
  scale_y_continuous("Number of TB patients (thousands)") + theme_bw() +
  scale_x_continuous(name="", breaks=2004:(thisyear-1)) +  scale_colour_brewer(name="Data provided", palette="Dark2") +
  #scale_fill_manual(values=c("grey50", "blue")) + 
  geom_text(data=gcc[gcc$year==thisyear-1, ], aes(label=c('Tested HIV-positive','CPT','ART')), vjust=3, hjust=2, colour="black") +
  opts(legend.position="none", title=paste("Number of HIV-positive TB patients enrolled on co-trimoxazole preventive therapy (CPT) \nand antiretroviral therapy (ART), 2004", thisyear-1, sep="–")) + expand_limits(y=c(min(pretty(c(gcc$value, min(gcc$value) * (0.95)))), max(pretty(c(gcc$value, max(gcc$value) * (1.05))))))

# windows (10,7); gcd; dev.off()
figsave(gcd, gcb, "cpt_art_hiv_graph")

ggsave(paste(outfolder, "/Figs/", "cpt_art_hiv_graph", Sys.Date(), ".pdf", sep=""), gcd, width=10, height=7) 

gce <- ggplot(gcc, aes(year, value, color=variable)) + geom_line(size=1) +
  scale_y_continuous("Number of TB patients (thousands)", limits = c(0, 500), expand = c(0, 0)) + theme_bw() +
  scale_x_continuous(name="") +  scale_color_brewer(name="Data provided", palette="Dark2") +
  #scale_fill_manual(values=c("grey50", "blue")) + 
  geom_text(data=gcc[gcc$year==thisyear-1, ], aes(label=c('Tested HIV-positive','CPT','ART')), 
            vjust=3, hjust=2, colour="black", size=6) +
              opts(legend.position="none", title=paste("Co-trimoxazole preventive therapy (CPT) and antiretroviral 
	therapy (ART) for HIV-positive TB patients, 2003", thisyear-1, sep="–"), 
	plot.title=theme_text(size=22), axis.title.y=theme_text(size=15, angle=90),
                   axis.text.y=theme_text(size=15), axis.text.x=theme_text(size=15)) 

# windows (10,7); gce; dev.off()
ggsave(paste(outfolder, "/Slides/", "cpt_art_hiv_graph", ".wmf", sep=""), gce, width=10, height=7) 

write.csv(gcb, file=paste(outfolder, "/FigData/", "cpt_art_hiv_graph", Sys.Date(), ".csv", sep=""), row.names=F, na="")


#-------------------------------------------------------------------
# cpt_graph
#-------------------------------------------------------------------

gda <- subset(tbhiv, year>=2005, select=c('iso3', 'year', 'hiv_cpt_pct_numerator', 'hivtest_pos_pct_denominator'))

# countries with full time series
gdb <- aggregate(gda[3:ncol(gda)], by=list(iso3=gda$iso3), FUN=sum, na.rm=F)
gdb_full <- gdb[!is.na(gdb$hiv_cpt_pct_numerator), 'iso3'] # this is right (59)

# count reporting countries
gdc <- gda[!is.na(gda$hiv_cpt_pct_numerator),]
gdc$rep <- 1
gdc_rep <- aggregate(gdc['rep'], by=list(year=gdc$year), FUN=sum) # Now this works, but why such inflation?

# Pick your plot. Only full time series or all
# gdd <- gda[gda$iso3 %in% gdb_full, ] ; gdd_num <- paste(',', length(gdb_full), 'reporting countries')# Full time series only
gdd <- gda ; gdd_num <- "" # All countries

gdd <- aggregate(gdd[3:ncol(gdd)], by=list(year=gdd$year), FUN=sum, na.rm=T)

gdd$pcnt <- gdd$hiv_cpt_pct_numerator / gdd$hivtest_pos_pct_denominator

gde <- ggplot(gdd, aes(year, pcnt)) + geom_line(size=1) +
  scale_y_continuous("Percentage of HIV-positive TB patients", limits = c(0, 1), 
                     expand = c(0, 0), labels=percent) + theme_bw() +
                       scale_x_continuous(name="") +  
                       geom_text(data=gdd[gdd$year==thisyear-1, ], aes(label='CPT'), vjust=3, hjust=2) +
                       opts(legend.position="none", panel.grid.major = theme_blank(),
                            panel.grid.minor = theme_blank(), 
                            title=paste("Co-trimoxazole preventive therapy for HIV-positive 
	TB patients, 2005–", thisyear-1, gdd_num, sep="")) 

# windows (10,7); gde; dev.off()
figsave(gde, gdd, "cpt_graph")


gdf <- ggplot(gdd, aes(year, pcnt)) + geom_line(size=1) +
  scale_y_continuous("Percentage of HIV-positive TB patients", limits = c(0, 1), 
                     expand = c(0, 0), labels=percent) + theme_bw() +
                       scale_x_continuous(name="") +  
                       geom_text(data=gdd[gdd$year==thisyear-1, ], aes(label='CPT'), vjust=3, hjust=2, size=6) +
                       opts(legend.position="none", panel.grid.major = theme_blank(),
                            panel.grid.minor = theme_blank(), 
                            title=paste("Co-trimoxazole preventive therapy for HIV-positive 
	TB patients, 2005–", thisyear-1, gdd_num, sep=""), 
	plot.title=theme_text(size=22), axis.title.y=theme_text(size=15, angle=90),
                            axis.text.y=theme_text(size=15), axis.text.x=theme_text(size=15)) 

# windows (10,7); gdf; dev.off()

ggsave(file = paste(outfolder, "/Slides/", "cpt_graph", ".wmf", sep=""), gdf, width=10, height=7) 

write.csv(gdd, file=paste(outfolder, "/FigData/", "cpt_graph", Sys.Date(), ".csv", sep=""), row.names=F, na="")

#-------------------------------------------------------------------
# art_graph
#-------------------------------------------------------------------


gde <- subset(tbhiv, year>=2005, select=c('iso3', 'year', 'hiv_art_pct_numerator', 'hiv_art_pct_denominator'))

# countries with full time series
gdf <- aggregate(gde[3:ncol(gde)], by=list(iso3=gde$iso3), FUN=sum, na.rm=F)
gdf_full <- gdf[!is.na(gdf$hiv_art_pct_numerator), 'iso3'] # this is right (59)

# count reporting countries
gdg <- gde[!is.na(gde$hiv_art_pct_numerator),]
gdg$rep <- 1
gdg_rep <- aggregate(gdg['rep'], by=list(year=gdg$year), FUN=sum) # Now this works, but why such inflation?

# Pick your plot. Only full time series or all
# gdh <- gde[gde$iso3 %in% gdf_full, ] ; gdh_num <- paste(',', length(gdf_full), 'reporting countries')# Full time series only
gdh <- gde ; gdh_num <- "" # All countries

gdh <- aggregate(gdh[3:ncol(gdh)], by=list(year=gdh$year), FUN=sum, na.rm=T)

gdh$pcnt <- gdh$hiv_art_pct_numerator / gdh$hiv_art_pct_denominator

gdi <- ggplot(gdh, aes(year, pcnt)) + geom_line(size=1) +
  scale_y_continuous("Percentage of HIV-positive TB patients", limits = c(0, 1), 
                     expand = c(0, 0), labels=percent) + theme_bw() +
                       scale_x_continuous(name="") +  
                       geom_text(data=gdh[gdh$year==thisyear-1, ], aes(label='ART'), vjust=3, hjust=2) +
                       opts(legend.position="none", # panel.grid.major = theme_blank(),
                            panel.grid.minor = theme_blank(), 
                            title=paste("Antiretroviral therapy for HIV-positive TB patients, 2005–", thisyear-1, gdd_num, sep="")) 

# windows (10,7); gdi; dev.off()
figsave(gdi, gdh, "art_graph")




gdj <- ggplot(gdh, aes(year, pcnt)) + geom_line(size=1) +
  scale_y_continuous("Percentage of HIV-positive TB patients", limits = c(0, 1), 
                     expand = c(0, 0), labels=percent) + theme_bw() +
                       scale_x_continuous(name="") +  
                       geom_text(data=gdh[gdh$year==thisyear-1, ], aes(label='ART'), vjust=3, hjust=2, size=6) +
                       opts(legend.position="none", panel.grid.major = theme_blank(),
                            panel.grid.minor = theme_blank(), 
                            title=paste("Antiretroviral therapy for HIV-positive TB patients, 
	2005–", thisyear-1, gdd_num, sep=""), 
	plot.title=theme_text(size=22), axis.title.y=theme_text(size=15, angle=90),
                            axis.text.y=theme_text(size=15), axis.text.x=theme_text(size=15)) 

# windows (10,7); gdj; dev.off()
ggsave(file = paste(outfolder, "/Slides/", "art_graph", ".wmf", sep=""), gdj, width=10, height=7) 

write.csv(gdh, file=paste(outfolder, "/FigData/", "art_graph", Sys.Date(), ".csv", sep=""), row.names=F, na="")

#-------------------------------------------------------------------
# tbscr_graph
#-------------------------------------------------------------------

gea <- merge(subset(n, year>=2005, select=c('iso3', 'year', 'hiv_tbscr')), subset(p, select=c('iso3', 'year', 'e_pop_num')))

# # impute for latest year
# gea$scrrt <- gea$hiv_tbscr / gea$e_pop_num
# impute <- function(x){
#   x[x$year==thisyear-1, 'scrrt'] <- ifelse(is.na(x[x$year==thisyear-1, 'scrrt']), x[x$year==thisyear-2, 'scrrt'], x[x$year==thisyear-1, 'scrrt'])
#   return(x)
# }
# geaa <- ddply(gea, "iso3", impute)
# geaa$tbscr2 <- geaa$scrrt * geaa$e_pop_num
# warning('Data for tbscreen graph have been imputed for the latest year.')

geb <- aggregate(gea['hiv_tbscr'], by=list(year=gea$year), FUN=sum, na.rm=T)
# geb <- aggregate(geaa['tbscr2'], by=list(year=geaa$year), FUN=sum, na.rm=T)

# gec <- melt(geb, id=1)
# gec$value <- gec$value/1000000
geb$tbscr2 <- geb$hiv_tbscr / 1000000
# geb$type <- ifelse(geb$year==thisyear-1, 'imp', 'rep')

fmt <- function(){
  function(x) ifelse(x==0, 0, format(x,nsmall = 1,scientific = FALSE))
}
# , labels=fmt() # This makes formatting look good if needed

ged <- ggplot(geb, aes(year, tbscr2)) + geom_line(size=1) + 
#   geom_line(data=geb[geb$year < thisyear-1,], size=1, linetype=1) + geom_line(data=geb[geb$year >= thisyear-2,], size=1, linetype=2) +
  scale_y_continuous("Number of people screened (millions)") + theme_bw() + aes(ymin=0) +
  scale_x_continuous(name="", breaks=c(min(geb$year):max(geb$year))) +  
#   scale_color_brewer(name="Data provided", palette="Dark2") +
  #scale_fill_manual(values=c("grey50", "blue")) + 
  
  opts(legend.position="none", title=paste("Intensified TB case-finding among people living with HIV, 2005", thisyear-1, sep="–")) + expand_limits(y=c(min(pretty(c(geb$tbscr2, min(geb$tbscr2) * (0.95)))), max(pretty(c(geb$tbscr2, max(geb$tbscr2) * (1.09))))))


# windows (10,7); ged; dev.off()
figsave(ged, geb, "tbscr_graph")



ggsave(file = paste(outfolder, "/Figs/", "tbscr_graph", Sys.Date(), ".pdf", sep=""), ged, width=10, height=7) 

gee <- ggplot(geb, aes(year, value)) + geom_line(size=1) +
  scale_y_continuous("Number of people screened (millions)", limits = c(0, 2.5), expand = c(0, 0)) + theme_bw() +
  scale_x_continuous(name="") +  scale_color_brewer(name="Data provided", palette="Dark2") +
  # scale_fill_manual(values=c("grey50", "blue")) + 
  # geom_text(data=gec[gec$year==thisyear-1, ], aes(label=c('Tested HIV-positive','CPT','ART')), 
  # vjust=3, hjust=2, colour="black", size=6) +
  opts(legend.position="none", panel.grid.major = theme_blank(),
       panel.grid.minor = theme_blank(), 
       title=paste("Intensified TB case-finding among people living with HIV, 
	2005", thisyear-1, sep="–"), 
	plot.title=theme_text(size=22), axis.title.y=theme_text(size=15, angle=90),
       axis.text.y=theme_text(size=15), axis.text.x=theme_text(size=15)) 

# windows (10,7); gee; dev.off()
ggsave(file = paste(outfolder, "/Slides/", "tbscr_graph", ".wmf", sep=""), gee, width=10, height=7) 

write.csv(geb, file=paste(outfolder, "/FigData/", "tbscr_graph", Sys.Date(), ".csv", sep=""), row.names=F, na="")

#-------------------------------------------------------------------
# hiv_ipt_graph
#-------------------------------------------------------------------

gfa <- subset(n, year>=2005, select=c('iso3', 'year', 'hiv_ipt'))

gfb <- aggregate(gfa[3:ncol(gfa)], by=list(year=gfa$year), FUN=sum, na.rm=T)

gfc <- melt(gfb, id=1)

gfc$value <- gfc$value/1000

gfd <- ggplot(gfc, aes(year, value)) + geom_line(size=1) +
  scale_y_continuous("Number of HIV-positive people without active TB (thousands)") + theme_bw() +
  scale_x_continuous(name="", breaks=c(min(gfc$year):max(gfc$year))) +  scale_color_brewer(name="Data provided", palette="Dark2") +
                       #scale_fill_manual(values=c("grey50", "blue")) + 
                       # geom_text(data=gec[gec$year==thisyear-1, ], aes(label=c('Tested HIV-positive','CPT','ART')), 
                       # vjust=3, hjust=2, colour="black") +
                       opts(legend.position="none", title=paste("Provision of isoniazid preventive therapy (IPT) to people living with HIV without active TB, 2005", thisyear-1, sep="–")) + expand_limits(y=c(min(pretty(c(gfc$value, min(gfc$value) * (0.95)))), max(pretty(c(gfc$value, max(gfc$value) * (1.05))))))

# windows (10,7); gfd; dev.off()
figsave(gfd, gfb, "hiv_ipt_graph")




gfe <- ggplot(gfc, aes(year, value)) + geom_line(size=1) +
  scale_y_continuous("Number of HIV-positive people without active TB (thousands)", 
                     limits = c(0, 420), expand = c(0, 0)) + theme_bw() +
                       scale_x_continuous(name="") +  scale_color_brewer(name="Data provided", palette="Dark2") +
                       # scale_fill_manual(values=c("grey50", "blue")) + 
                       # geom_text(data=gec[gec$year==thisyear-1, ], aes(label=c('Tested HIV-positive','CPT','ART')), 
                       # vjust=3, hjust=2, colour="black", size=6) +
                       opts(legend.position="none", panel.grid.major = theme_blank(),
                            panel.grid.minor = theme_blank(), 
                            title=paste("IPT provision among HIV-positive people, 2005", thisyear-1, sep="–"), 
                            plot.title=theme_text(size=22), axis.title.y=theme_text(size=15, angle=90),
                            axis.text.y=theme_text(size=15), axis.text.x=theme_text(size=15)) 

# windows (10,7); gfe; dev.off()
ggsave(file = paste(outfolder, "/Slides/", "hiv_ipt_graph", ".wmf", sep=""), gfe, width=10, height=7) 

write.csv(gfb, file=paste(outfolder, "/FigData/", "hiv_ipt_graph", Sys.Date(), ".csv", sep=""), row.names=F, na="")

#-------------------------------------------------------------------
# TB/HIV graphs for showing burden distribution. 
#-------------------------------------------------------------------

gna <- subset(tbhiv, year>=2003, select=c("country", "year", "g_whoregion", "hiv_art"))
gna <- .shortnames(gna)

highs <- unique(gna[gna$year==thisyear-1 & gna$hiv_art>20000 & !is.na(gna$hiv_art),"country"])

gna$group <- 'All other countries'
gna$group <- ifelse(gna$g_whoregion=='AFR', 'AFR other countries', gna$group)
gna$group <- ifelse(gna$country %in% highs, gna$country, gna$group)


gnb <- aggregate(gna['hiv_art'], by=list(year=gna$year, group=gna$group), FUN=sum, na.rm=T)
gnb$hiv_art_1k <- gnb$hiv_art / 1000


gnc <- ggplot(gnb, aes(year, hiv_art_1k, color=group)) + 
  geom_line(size=1.5, alpha=.5) +
  geom_text(data=gnb[gnb$year==thisyear-1,], aes(label = group, color=group), hjust=-.1, vjust=0, size=3) +
#   geom_line(data=gnb[gnb$group %in% highs,], aes(year, hiv_art_1k, group=group), size=1.5, color="cadetblue3") +
#   geom_text(data=gnb[gnb$year==thisyear-1 & gnb$group %in% highs,], aes(label = group) , color="cadetblue3", hjust=-.1, vjust=0, size=3) +
  scale_y_continuous(name = "Patients (thousands)", expand=c(0.1, 0)) +
  scale_x_continuous("", breaks=2003:(thisyear-1)) + scale_color_brewer(palette="Dark2") +
  theme_bw() + expand_limits(x=c(2003, thisyear + 0.1)) + 
  opts(legend.position="none", title='Antiretroviral therapy for HIV-positive TB patients by WHO region and selected countries, 2003-2010')

# windows(10, 7); gnc; dev.off()
figsave(gnc, gnb, "hivdist_graph")
 

gnd <- ggplot(gnb[gnb$group %in% highs,], aes(year, hiv_art_1k, group=group)) + 
  geom_line(size=1.5, color="light blue") + geom_text(data=gnb[gnb$group %in% highs&gnb$year==thisyear-1,],
                                                      aes(label = group), hjust=-.1, vjust=0, size=5) +
                                                        geom_line(data=gnb[!gnb$group %in% highs,], aes(year, hiv_art_1k, color=group), size=1.5, alpha=.5) +
                                                        scale_y_continuous(name = "Patients (thousands)") +
                                                        scale_x_continuous("") + scale_color_brewer(name="WHO region", palette="Dark2") +
                                                        expand_limits(x=c(2003, 2011.5)) + theme_bw() +
                                                        opts(title='Antiretroviral therapy for HIV-positive TB patients by WHO region and selected countries, 2003-2010', 
                                                             plot.title=theme_text(size=22), axis.title.y=theme_text(size=15, angle=90),
                                                             axis.text.y=theme_text(size=15), axis.text.x=theme_text(size=15), 
                                                             legend.title=theme_text(size=14, hjust=0), legend.text=theme_text(size=12))

# windows(11, 7); gnd; dev.off()
ggsave(paste(outfolder, "/Slides/", "hivdist_graph", ".wmf", sep=""), gnd, width=11, height=7) 

write.csv(gnb, file=paste(outfolder, "/FigData/", "hivdist_graph", Sys.Date(), ".csv", sep=""), row.names=F, na="")

#-------------------------------------------------------------------
# hivprog_graph_all
#-------------------------------------------------------------------

gg <- subset(tbhiv, year>=2003, select=c('iso3', 'year', 'g_hbhiv63', 'hivtest', 'hivtest_pos', 'hiv_cpt', 'hiv_art', 'hiv_cpt_pct_numerator', 'hiv_cpt_pct_denominator', 'hiv_art_pct_numerator', 'hiv_art_pct_denominator', 'c_notified', 'hivtest_pos_pct_denominator', 'hivtest_pos_pct_numerator'))

# replace denominators with interpolated rates across years

gga <- merge(e.t[c('iso3', 'year', 'e_pop_num')], gg, all.y=T)

ggb <- melt(gga, id=1:4)

ggb$rate <- ggb$value / ggb$e_pop_num

ghe <- gga

for(var in c('c_notified', 'hivtest', 'hivtest_pos')) {
  
  gha <- cast(ggb[ggb$variable==var & !is.na(ggb$rate),c('iso3', 'year', 'rate')], year~iso3, value='rate')
  ghb <- timeSeries(as.matrix(as.matrix.cast_df(gha)))
  ghc <- na.omit(ghb, method="ie")
  ghc$year <- 2003:(thisyear-1)
  ghd <- melt(as.data.frame(ghc), id='year', variable='iso3')
  names(ghd)[3] <- paste(var, "ir", sep="_")
  ghe <- merge(ghe, ghd, all.x=T)
}

ghe$c_notified_m <- ghe$c_notified_ir * ghe$e_pop_num
ghe$hivtest_m <- ghe$hivtest_ir * ghe$e_pop_num
ghe$hivtest_pos_m <- ghe$hivtest_pos_ir * ghe$e_pop_num

ggf <- ghe

gl <- within(ggf, {
  c_notified_hnm <- ifelse(!is.na(c_notified) & !is.na(hivtest) & 
    c_notified >= hivtest, c_notified, NA)
  hivtest_hnm <- ifelse(!is.na(c_notified) & !is.na(hivtest) & 
    c_notified >= hivtest, hivtest, NA)
  
  hivtest_lo <- ifelse(!is.na(c_notified_m) & is.na(hivtest), 0, hivtest)
  hivtest_hi <- ifelse(!is.na(c_notified_m) & is.na(hivtest), c_notified_m, hivtest)
  
  hivtest_pos_lo <- ifelse(!is.na(hivtest_m) & is.na(hivtest_pos), 0, hivtest_pos)
  hivtest_pos_hi <- ifelse(!is.na(hivtest_m) & is.na(hivtest_pos), hivtest_m, hivtest_pos)
  
  hiv_cpt_lo <- ifelse(!is.na(hivtest_pos_m) & is.na(hiv_cpt), 0, hiv_cpt)
  hiv_cpt_hi <- ifelse(!is.na(hivtest_pos_m) & is.na(hiv_cpt), hivtest_pos_m, hiv_cpt)
  
  hiv_art_lo <- ifelse(!is.na(hivtest_pos_m) & is.na(hiv_art), 0, hiv_art)
  hiv_art_hi <- ifelse(!is.na(hivtest_pos_m) & is.na(hiv_art), hivtest_pos_m, hiv_art)
  
})

table(gl[!is.na(gl$c_notified_m),'year']) # 214 / 216 countries have reported in at least 1 year
table(gl[!is.na(gl$hivtest_m),'year']) 		# 203 / 216 countries
table(gl[!is.na(gl$hivtest_pos_m),'year'])	# 202 / 216 countries (somehow I lost a country)

unique(e.t[!e.t$iso3  %in% unique(gl[!is.na(gl$c_notified_m),'iso3']),'country'])
unique(e.t[!e.t$iso3  %in% unique(gl[!is.na(gl$hivtest_m),'iso3']),'country'])
unique(e.t[!e.t$iso3  %in% unique(gl[!is.na(gl$hivtest_pos_m),'iso3']),'country'])
# table(tbhiv[!is.na(tbhiv$hivtest),'year'])

gk <- aggregate(gl[6:ncol(gl)], by=list(year=gl$year), FUN=sum, na.rm=T)

gah <- within(gk, {
  pht_best <- hivtest_hnm / c_notified_hnm
  pht_lo <- hivtest_lo / c_notified_m
  pht_hi <- hivtest_hi / c_notified_m
  
  phtp_best <- hivtest_pos_pct_numerator / hivtest_pos_pct_denominator
  phtp_lo <- hivtest_pos_lo / hivtest_m
  phtp_hi <- hivtest_pos_hi / hivtest_m
  
  pcpt_best <- hiv_cpt_pct_numerator / hiv_cpt_pct_denominator
  pcpt_lo <- hiv_cpt_lo / hivtest_pos_m
  pcpt_hi <- hiv_cpt_hi / hivtest_pos_m
  
  part_best <- hiv_art_pct_numerator / hiv_art_pct_denominator
  part_lo <- hiv_art_lo / hivtest_pos_m
  part_hi <- hiv_art_hi / hivtest_pos_m
})

gai <- melt(gah[c('year', "part_hi", "part_lo", "part_best", "pcpt_hi", "pcpt_lo", "pcpt_best", 
                  "phtp_hi", "phtp_lo", "phtp_best", "pht_hi", "pht_lo", "pht_best")], id=1)

for(ro in 1:nrow(gai)){
  
  both <- as.data.frame(str_split(gai[ro,'variable'], "_"))
  gai[ro, 'var'] <- both[1,]
  gai[ro, 'hilo'] <- both[2,]
  
}

gaj <- cast(gai, year+var~hilo)

gaj['Percentages'] <- factor(gaj$var, levels=c("pht", "phtp", "pcpt", "part"),
                             labels=c('% of TB patients with known HIV status', '% of TB patients with known HIV status \nwho are HIV-positive', 
                                      '% of HIV-positive patients on CPT', '% of HIV-positive patients on ART'))

gak <- gaj[gaj$year>=2007 & gaj$Percentages!='% of TB patients with known HIV status',] 

gak[c("best", "hi", "lo")] <- gak[c("best", "hi", "lo")] * 100

gal <- ggplot(gak, aes(year, best)) + geom_line(size=1, alpha=.5) + 
  geom_ribbon(aes (year, best, ymin=lo, ymax=hi), alpha=0.2) + facet_wrap(~Percentages, ncol=3) + 
  scale_y_continuous(limits = c(0, 100), name = "Percentage of TB patients", breaks=c(0, 20, 40, 60, 80, 100)) +
  scale_x_continuous("") + 
  theme_bw() + 
  opts(title=glue('Percentage of TB patients with known HIV status who were HIV positive, and percentage of HIV-positive TB patients \nenrolled on co-trimoxazole preventive therapy (CPT) and antiretroviral therapy (ART), ', min(gak$year), '–', max(gak$year), '(a)'), panel.grid.minor = theme_blank())

# windows(13,6); gal
figsave(gal, gak, "hivprog_graph_all")




# Title: Proportion of TB patients tested for HIV, tested patients found positive and 
# HIV-positive TB patients on CPT and ART, 2003-2010.
# Footnote: Lines indicate percentage from countries who have reported both the 
# numerator and denominator for the percentage. Ranges indicate 0% and 100% for 
# countries reporting the denominator only. Countries reporting neither numerator
# nor denominator for the time series are excluded and account for <1% of the estimated
# Global TB/HIV burden. Missing denominator data were estimated using interpolation and
# continuation of rates outside of the range of reported data.

# Intervals indicate scenarios where non-reporting countries report 0% or 100%.

#-------------------------------------------------------------------
# SLIDE - absolute incidence and mortality (all and hiv-neg)
#-------------------------------------------------------------------

sga <- subset(global, select=c("year", "inc.num", "inc.lo.num", "inc.hi.num",
                               "mort.num", "mort.lo.num", "mort.hi.num",
                               "mort.nh.num", "mort.nh.lo.num", "mort.nh.hi.num"))

sgb <- sga	
sga[,5:10] <- NA
sga$im <- 'Incidence'

sgb[,2:4] <- NA
sgb$im <- 'Mortality (HIV-negative in blue)'

sgc <- rbind(sga, sgb)
sgc[2:10] <- sgc[2:10] / 1000000

sga1 <- ggplot(sgc, aes(x=year, y=inc.num)) + geom_line(colour="green") + 
  geom_ribbon(aes (year, ymin=inc.lo.num, ymax=inc.hi.num), fill=I('green'), alpha=I(0.2)) +
  geom_line(aes(year, mort.num), color='purple') +
  geom_ribbon(aes (year, ymin=mort.lo.num, ymax=mort.hi.num), fill=I('purple'), alpha=I(0.2)) +
  geom_line(aes(year, mort.nh.num), color='blue') +
  geom_ribbon(aes (year, ymin=mort.nh.lo.num, ymax=mort.nh.hi.num), fill=I('blue'), alpha=I(0.2)) +
  facet_wrap(~ im, scales='free') + 
  geom_point(aes(year, inc.num*0), alpha=0) + geom_point(aes(year, mort.num*0), alpha=0) +
  
  scale_y_continuous( name = "Millions of people" ) + theme_bw() +
  scale_x_continuous(name="") +  
  opts(title=paste("Global incidence and mortality, 1990", thisyear-1, sep="–"),
       plot.title=theme_text(size=22), axis.title.y=theme_text(size=15, angle=90),
       axis.text.y=theme_text(size=15), axis.text.x=theme_text(size=15)) 

# windows(11, 7); sga1; dev.off()
ggsave(paste(outfolder, "/Slides/", "inc_mort", ".png", sep=""), sga1, width=11, height=7) 	

#-------------------------------------------------------------------
# just incidence with notifications
#-------------------------------------------------------------------

sgd <- subset(global, select=c("year", "inc.num", "inc.lo.num", "inc.hi.num"))
sge <- aggregate(n['c_newinc'], by=list(year=n$year), FUN=sum, na.rm=T)
sgf <- merge(sgd, sge)
sgf[2:5] <- sgf[2:5] / 1000000

sga2 <- ggplot(sgf, aes(x=year, y=inc.num)) + geom_line(colour="green", size=1) + 
  geom_ribbon(aes (year, ymin=inc.lo.num, ymax=inc.hi.num), fill=I('green'), alpha=I(0.2)) +
  geom_line(aes(year, c_newinc), size=1) +
  scale_y_continuous(name = "Cases (millions)") + theme_bw() +
  scale_x_continuous(name="") +  
  expand_limits(y=c(0,9.9)) +
  theme_bw(base_size=16) +
  opts(legend.position='none', title=
  paste("Global incidence and \nnotifications, 1990", thisyear-1, sep="–"), 
       plot.title = theme_text(hjust=0.3, size=20))

# windows(11, 7); sga1; dev.off()
ggsave(paste(outfolder, "/Slides/", "global_incnotif_num", ".png", sep=""), sga2, width=5, height=6) 	

#-------------------------------------------------------------------
# Revamping Christopher's Global plan plot
#-------------------------------------------------------------------

library(stringr)

setwd('J:/DivData/TME - monitoring & evaluation/M&S/1docs (Annual TB Report)/11/Tables and Figures/For Christopher')

cfa <- read.csv('fin_fig10.csv')

names(cfa) <- c("Region", "year", "DOTS_hi", "DOTS_lo", "DOTS_all", "MDR-TB_hi", 
                "MDR-TB_lo", "MDR-TB_all", "TB/HIV_hi", "TB/HIV_lo", 
                "TB/HIV_all", "Laboratories_hi", "Laboratories_lo", "Laboratories_all", "Total_hi", 
                "Total_lo", "Total_all")
cfb <- melt(cfa, id=1:2)

for(ro in 1:nrow(cfb)){
  
  both <- as.data.frame(str_split(cfb[ro,'variable'], "_"))
  cfb[ro, 'var'] <- both[1,]
  cfb[ro, 'hilo'] <- both[2,]
  
}

cfc <- cast(cfb, Region+year+var~hilo)

cfc$var <- factor(cfc$var, levels=c("DOTS", "MDR-TB", "Total", "TB/HIV", "Laboratories"))
cfc$Region <- factor(cfc$Region, labels=c('Europe', 'Rest of World', 'World'))
cfc['Needed'] <- cfc$Region

alph <- .5

cfd <- ggplot(cfc, aes(year, all, color=Region)) + geom_line(size=1, alpha=alph) + facet_wrap(~var, scales="free_y") +
  geom_point(alpha=alph) + geom_ribbon(aes(year, ymin=lo, ymax=hi, fill=Region), color=NA, alpha=alph) +
  geom_hline(yintercept=0, alpha=0) + scale_y_continuous(name = "US$ millions (nominal)") + 
  scale_x_continuous("") + #scale_color_brewer(name="Funding\n \nAvailable", palette="Dark2") +
  opts(title='Funding available (lines) for TB control, 2010-2012 and funding needed (bands) according
	to the Global Plan, 2011-2015') + theme_bw()

# windows(10,7); cfd
ggsave(paste("fin_fig10", Sys.Date(), ".pdf", sep=""), cfd, width=10, height=7) 

#-------------------------------------------------------------------
# hiv_txout _rep and _tsr
#-------------------------------------------------------------------

h <- o

h[20:ncol(h)] <- ifelse(is.na(h[20:ncol(h)]), NA, 1) # Holy smoke it worked!

gia <- h

gia$count <- 1
gib <- aggregate(gia[20:ncol(gia)], by=list(year=gia$year), FUN=sum, na.rm=T)

gic <- melt(gib[c('year', 'new_sp_coh', 'hiv_new_sp_coh', 'hiv_new_snep_coh', 'hiv_ret_coh', 'count')], id=1)
gid <- qplot(year, value, data=gic, geom='line', color=variable)

gidout <- names(gia[c(1:20)])
gidcsv <- merge(eraw[c('iso3', 'year', 'e_inc_tbhiv_num')], 
                gia[c(gidout, 'new_sp_coh', 'hiv_new_sp_coh', 'hiv_new_snep_coh', 'hiv_ret_coh')], all.y=T)
# csv(gidcsv)

#-------------------------------------------------------------------
# hiv_tsr_graph
#-------------------------------------------------------------------

gie <- o[o$year >= 2007, c('country', 'iso3', 'year', 'new_sp_coh', 'new_sp_cur', 'new_sp_cmplt', 'hiv_new_sp_coh', 
                           'hiv_new_sp_cur', 'hiv_new_sp_cmplt', 'new_sp_died', 'hiv_new_sp_died')]

gif <- aggregate(gie[4:ncol(gie)], by=list(iso3=gie$iso3), FUN=sum, na.rm=F)
gif_full <- gif[!is.na(gif$hiv_new_sp_coh), 'iso3'] # this is right (25)
gif_full <- gif_full[-19] # I'm taking out Romania for weird data in 2008

gig <- gie[gie$iso3 %in% gif_full, ] #; gdd_num <- paste(',', length(gdb_full), 'reporting countries')# Full time series only

gih <- aggregate(gig[3:ncol(gig)], by=list(year=gig$year), FUN=sum, na.rm=T)

gih$nhiv_tsr <- (gih$new_sp_cur + gih$new_sp_cmplt - gih$hiv_new_sp_cur - gih$hiv_new_sp_cmplt) / 
  (gih$new_sp_coh - gih$hiv_new_sp_coh)

gih$hiv_tsr <- (gih$hiv_new_sp_cur + gih$hiv_new_sp_cmplt) / gih$hiv_new_sp_coh

gih$nhiv_dr <- (gih$new_sp_died - gih$hiv_new_sp_died) / 
  (gih$new_sp_coh - gih$hiv_new_sp_coh)

gih$hiv_dr <- gih$hiv_new_sp_died / gih$hiv_new_sp_coh
gii <- melt(gih[c('year', 'nhiv_tsr', 'hiv_tsr', 'nhiv_dr', 'hiv_dr')], id=1)
gij <- qplot(year, value, data=gii, geom='line', color=variable, labels=percent, ylim=c(0,1)) 

gii$hiv <- ifelse(gii$variable=='nhiv_tsr' | gii$variable=='nhiv_dr', 'negative', 'positive')

# o[o$iso3 %in% gif_full & (o$year==2008 | o$year==2009), c('country', 'c_tsr')]
levels(gii$variable) <- c("HIV-negative treatment success", "HIV-positive treatment success", 
                          "HIV-negative died", "HIV-positive died")

gik <-  ggplot(gii, aes(year, value, group=variable, color=hiv)) + 
  geom_line(size=1.5) + geom_text(data=gii[gii$year==thisyear-2,],
                                  aes(label = variable), hjust=-.1, vjust=0, size=3) +
                                    scale_y_continuous(name = "Percent of cohort", labels=percent, expand=c(0,0)) +
                                    scale_x_continuous("", breaks=2004:2009, labels=2004:2009, expand=c(0,0)) + 
                                    theme_bw() + expand_limits(y=c(0, 1), x=c(2004, 2010.6)) + scale_color_brewer(palette="Dark2") +
                                    opts(legend.position="none", panel.grid.minor=theme_blank(),
                                         title=paste('Percentage of treatment cohort successfully treated and died 
	by HIV status in', length(gif_full), 'selected countries, 2004-2009'))

# windows(10, 7); gik; dev.off()
ggsave(paste(outfolder, "/Figs/", "hiv_tsr_graph", Sys.Date(), ".pdf", sep=""), gik, width=10, height=7) 

gil <- ggplot(gii, aes(year, value, group=variable, color=hiv)) + 
  geom_line(size=1.5) + geom_text(data=gii[gii$year==thisyear-2,],
                                  aes(label = variable), hjust=-.1, vjust=0, size=5) +
                                    scale_y_continuous(name = "Percent of cohort", labels=percent, expand=c(0,0)) +
                                    scale_x_continuous("", breaks=2004:2009, labels=2004:2009, expand=c(0,0)) + 
                                    theme_bw() + expand_limits(y=c(0, 1), x=c(2004, 2011.9)) + scale_color_brewer(palette="Dark2") +
                                    opts(legend.position="none", panel.grid.minor=theme_blank(),
                                         title=paste('Percentage of treatment cohort successfully treated and died 
	by HIV status in', length(gif_full), 'selected countries, 2004-2009'), 
	plot.title=theme_text(size=22), axis.title.y=theme_text(size=15, angle=90),
                                         axis.text.y=theme_text(size=15), axis.text.x=theme_text(size=15), 
                                         legend.title=theme_text(size=14, hjust=0), legend.text=theme_text(size=12))

# windows(11, 7); gil; dev.off()
ggsave(paste(outfolder, "/Slides/", "hiv_tsr_graph", ".wmf", sep=""), gil, width=11, height=7) 

write.csv(gii, file=paste(outfolder, "/FigData/", "hiv_tsr_graph", Sys.Date(), ".csv", sep=""), row.names=F, na="")

#-------------------------------------------------------------------
# hiv_txout
#-------------------------------------------------------------------

gha <- subset(o, year==thisyear-2, select=c('iso2', 'country', 'g_hbhiv63', 'year', 'hiv_new_sp_coh', 'hiv_new_sp_cur', 'hiv_new_sp_cmplt', 
                                            'hiv_new_sp_died', 'hiv_new_sp_fail', 'hiv_new_sp_def', 'new_sp_coh', 'new_sp_cur', 
                                            'new_sp_cmplt', 'new_sp_died', 'new_sp_fail', 'new_sp_def', 'hiv_new_snep_coh', 
                                            'hiv_new_snep_cmplt', 'hiv_new_snep_died', 'hiv_new_snep_fail', 'hiv_new_snep_def', 
                                            'new_snep_coh', 'new_snep_cmplt', 'new_snep_died', 'new_snep_fail', 
                                            'new_snep_def', 'hiv_ret_coh', 'hiv_ret_cur', 'hiv_ret_cmplt', 'hiv_ret_died', 
                                            'hiv_ret_fail', 'hiv_ret_def', 'ret_coh', 'ret_cur', 'ret_cmplt', 'ret_died', 'ret_fail', 
                                            'ret_def'))

gha$count <- 1

# Generate tx success and not evaluated vars
gha <- within(gha, {
  new_sp_suc <- rowSums(cbind(new_sp_cur, new_sp_cmplt), na.rm=T)
  hiv_new_sp_suc <- rowSums(cbind(hiv_new_sp_cur, hiv_new_sp_cmplt), na.rm=T)
  
  new_snep_suc <- new_snep_cmplt
  hiv_new_snep_suc <- hiv_new_snep_cmplt
  
  ret_suc <- rowSums(cbind(ret_cur, ret_cmplt), na.rm=T)
  hiv_ret_suc <- rowSums(cbind(hiv_ret_cur, hiv_ret_cmplt), na.rm=T)
  
  new_sp_neval <- new_sp_coh - rowSums(cbind(new_sp_cur, new_sp_cmplt, new_sp_died, new_sp_fail, new_sp_def), na.rm=T)
  hiv_new_sp_neval <- hiv_new_sp_coh - rowSums(cbind(hiv_new_sp_cur, hiv_new_sp_cmplt, hiv_new_sp_died, 
                                                     hiv_new_sp_fail, hiv_new_sp_def), na.rm=T)
  
  new_snep_neval <- new_snep_coh - rowSums(cbind(new_snep_cmplt, new_snep_died, new_snep_fail, new_snep_def), na.rm=T)
  hiv_new_snep_neval <- hiv_new_snep_coh - rowSums(cbind(hiv_new_snep_cmplt, hiv_new_snep_died, 
                                                         hiv_new_snep_fail, hiv_new_snep_def), na.rm=T)
  
  ret_neval <- ret_coh - rowSums(cbind(ret_cur, ret_cmplt, ret_died, ret_fail, ret_def), na.rm=T)
  hiv_ret_neval <- hiv_ret_coh - rowSums(cbind(hiv_ret_cur, hiv_ret_cmplt, hiv_ret_died, 
                                               hiv_ret_fail, hiv_ret_def), na.rm=T)
})

# Remove countries who didn't report HIV outcomes

gha$new_sp_rep <- ifelse(is.na(gha$new_sp_coh) | gha$hiv_new_sp_coh==0 | is.na(gha$hiv_new_sp_coh), 0, 1)
gha$new_snep_rep <- ifelse(is.na(gha$new_snep_coh) | gha$hiv_new_snep_coh==0 | is.na(gha$hiv_new_snep_coh), 0, 1)
gha$ret_rep <- ifelse(is.na(gha$ret_coh) | gha$hiv_ret_coh==0 | is.na(gha$hiv_ret_coh), 0, 1)
gha$all_rep <- ifelse(is.na(gha$new_sp_coh) | gha$hiv_new_sp_coh==0 | is.na(gha$hiv_new_sp_coh) |
  is.na(gha$new_snep_coh) | gha$hiv_new_snep_coh==0 | is.na(gha$hiv_new_snep_coh) |
  is.na(gha$ret_coh) | gha$hiv_ret_coh==0 | is.na(gha$hiv_ret_coh), 0, 1)
gha$any_rep <- ifelse(gha$new_sp_rep==1 | gha$new_snep_rep==1 | gha$ret_rep==1 , 1, 0)

ghb <- gha[gha$new_sp_rep==1, ]
ghb <- aggregate(ghb[5:ncol(ghb)], by=list(year=ghb$year), FUN=sum, na.rm=T)

ghc <- gha[gha$new_snep_rep==1, ]
ghc <- aggregate(ghc[5:ncol(ghc)], by=list(year=ghc$year), FUN=sum, na.rm=T)

ghd <- gha[gha$ret_rep==1, ]
ghd <- aggregate(ghd[5:ncol(ghd)], by=list(year=ghd$year), FUN=sum, na.rm=T)

ghe <- data.frame(type=c('New smear-positive', 'New smear-positive', 'New smear-negative/ extrapulmonary', 
                         'New smear-negative/ extrapulmonary', 'Retreatment', 'Retreatment'), 
                  hiv=c('HIV +', 'HIV -', 'HIV +', 'HIV -', 'HIV +', 'HIV -'))

ghe['Successfully treated'] <- c(
  ghb$hiv_new_sp_suc , 
  (ghb$new_sp_suc - ghb$hiv_new_sp_suc) , 
  ghc$hiv_new_snep_suc , 
  (ghc$new_snep_suc - ghc$hiv_new_snep_suc) , 
  ghd$hiv_ret_suc , 
  (ghd$ret_suc - ghd$hiv_ret_suc) )

ghe['Cohort'] <- c(
  ghb$hiv_new_sp_coh, 
  (ghb$new_sp_coh - ghb$hiv_new_sp_coh), 
  ghc$hiv_new_snep_coh, 
  (ghc$new_snep_coh - ghc$hiv_new_snep_coh), 
  ghd$hiv_ret_coh, 
  (ghd$ret_coh - ghd$hiv_ret_coh))

ghe['Percent successfully treated'] <- c(
  ghb$hiv_new_sp_suc / ghb$hiv_new_sp_coh, 
  (ghb$new_sp_suc - ghb$hiv_new_sp_suc) / (ghb$new_sp_coh - ghb$hiv_new_sp_coh), 
  ghc$hiv_new_snep_suc / ghc$hiv_new_snep_coh, 
  (ghc$new_snep_suc - ghc$hiv_new_snep_suc) / (ghc$new_snep_coh - ghc$hiv_new_snep_coh), 
  ghd$hiv_ret_suc / ghd$hiv_ret_coh, 
  (ghd$ret_suc - ghd$hiv_ret_suc) / (ghd$ret_coh - ghd$hiv_ret_coh))

ghe['Died'] <- c(
  (ghb$hiv_new_sp_died + ghb$hiv_new_sp_def) , 
  (ghb$new_sp_died - ghb$hiv_new_sp_died) , 
  (ghc$hiv_new_snep_died + ghc$hiv_new_snep_def) , 
  (ghc$new_snep_died - ghc$hiv_new_snep_died) , 
  (ghd$hiv_ret_died + ghd$hiv_ret_def) , 
  (ghd$ret_died - ghd$hiv_ret_died)  ) 

ghe['Evaluated cohort'] <- c(
  (ghb$hiv_new_sp_coh - ghb$hiv_new_sp_neval), 
  ((ghb$new_sp_coh - ghb$hiv_new_sp_coh) - (ghb$new_sp_neval - ghb$hiv_new_sp_neval)), 
  (ghc$hiv_new_snep_coh - ghc$hiv_new_snep_neval), 
  ((ghc$new_snep_coh - ghc$hiv_new_snep_coh) - (ghc$new_snep_neval - ghc$hiv_new_snep_neval)), 
  (ghd$hiv_ret_coh - ghd$hiv_ret_neval), 
  ((ghd$ret_coh - ghd$hiv_ret_coh) - (ghd$ret_neval - ghd$hiv_ret_neval))) 


ghe['Percent died'] <- c(
  (ghb$hiv_new_sp_died + ghb$hiv_new_sp_def) / (ghb$hiv_new_sp_coh - ghb$hiv_new_sp_neval), 
  (ghb$new_sp_died - ghb$hiv_new_sp_died) / 
    ((ghb$new_sp_coh - ghb$hiv_new_sp_coh) - (ghb$new_sp_neval - ghb$hiv_new_sp_neval)), 
  (ghc$hiv_new_snep_died + ghc$hiv_new_snep_def) / (ghc$hiv_new_snep_coh - ghc$hiv_new_snep_neval), 
  (ghc$new_snep_died - ghc$hiv_new_snep_died) / 
    ((ghc$new_snep_coh - ghc$hiv_new_snep_coh) - (ghc$new_snep_neval - ghc$hiv_new_snep_neval)), 
  (ghd$hiv_ret_died + ghd$hiv_ret_def) / (ghd$hiv_ret_coh - ghd$hiv_ret_neval), 
  (ghd$ret_died - ghd$hiv_ret_died)  / 
    ((ghd$ret_coh - ghd$hiv_ret_coh) - (ghd$ret_neval - ghd$hiv_ret_neval))) 

ghe['Countries'] <- c(
  ghb$count, ghb$count, 
  ghc$count, ghc$count, 
  ghd$count, ghd$count)

ghe7 <- c('All', 'HIV +', sum(ghe[c(1,3,5), 3]), sum(ghe[c(1,3,5), 4]), sum(ghe[c(1,3,5), 3])/ sum(ghe[c(1,3,5), 4]),
          sum(ghe[c(1,3,5), 6]), sum(ghe[c(1,3,5), 7]), sum(ghe[c(1,3,5), 6]) / sum(ghe[c(1,3,5), 7]), sum(gha$any_rep))

ghe8 <- c('All', 'HIV -', sum(ghe[c(2,4,6), 3]), sum(ghe[c(2,4,6), 4]), sum(ghe[c(2,4,6), 3])/ sum(ghe[c(2,4,6), 4]),
          sum(ghe[c(2,4,6), 6]), sum(ghe[c(2,4,6), 7]), sum(ghe[c(2,4,6), 6]) / sum(ghe[c(2,4,6), 7]), sum(gha$any_rep))

ghe[7, ] <- ghe7
ghe[8, ] <- ghe8

write.csv(ghe, file=paste(outfolder, "/FigData/", "hiv_txout", Sys.Date(), ".csv", sep=""), row.names=F, na="")

#-------------------------------------------------------------------
# txout_reg
#-------------------------------------------------------------------

gia <- subset(o, year==thisyear-2, select=c('iso2', 'country', 'g_whoregion', 'year', 'new_sp_coh', 'new_sp_cur', 'new_sp_cmplt', 'new_sp_died', 'new_sp_fail', 'new_sp_def', 'c_new_sp_neval', 'new_snep_coh', 'new_snep_cmplt', 'new_snep_died', 'new_snep_fail', 'new_snep_def', 'c_new_snep_neval', 'ret_coh', 'ret_cur', 'ret_cmplt', 'ret_died', 'ret_fail', 'ret_def', 'c_ret_neval'))

gia$count <- 1

# Remove non-reporting countries for total countries reporting
gib <- subset(gia, !is.na(new_sp_coh) | !is.na(new_snep_coh) | !is.na(ret_coh))

# Aggregate by region and global

gi.reg <- aggregate(gib[5:ncol(gib)], by=list(area=gib$g_whoregion), FUN=sum, na.rm=T)

gi.glo <- aggregate(gib[5:ncol(gib)], by=list(area=gib$year), FUN=sum, na.rm=T)
gi.glo$area <- 'Global'

gic <- .shortnames(rbind(gi.reg, gi.glo), 'area')
gic$area <- factor(gic$area, levels=rev(gic$area), labels=rev(gic$area))

### Smear-positive cases only
gic1 <- within(gic, {
  Cases <- new_sp_coh# + new_snep_coh  + ret_coh
  Success <- (new_sp_cur + new_sp_cmplt) / Cases # + new_snep_cmplt + ret_cur + ret_cmplt
  Died <- (new_sp_died) / Cases # + new_snep_died + ret_died
  Failed <- (new_sp_fail) / Cases # + new_snep_fail + ret_fail
  Defaulted <- (new_sp_def) / Cases # + new_snep_def + ret_def
  Unevaluated <- (c_new_sp_neval) / Cases # + c_new_snep_neval + c_ret_neval
})

# reshape for the plot
gid1 <- melt(gic1[,c('area', 'Success', 'Died', 'Failed', 'Defaulted', 'Unevaluated')], id=1)
gid1$variable <- factor(gid1$variable, levels=c("Success", "Died", "Failed", "Defaulted", "Unevaluated"), labels=c("Successfully treated", "Died", "Failed", "Defaulted", "Not evaluated"))

gie1 <- ggplot(gid1, aes(area, value, fill = variable) ) + geom_bar(stat='identity', position='fill' ) + scale_y_continuous("", breaks=seq(0, 1, 0.1), labels=percent_format()) + scale_fill_manual("", values=c('goldenrod2', 'firebrick3', 'olivedrab', 'navy', 'orangered')) + coord_flip() + theme_bw() + labs(x="", title=paste('a. New smear-positive cases')) + theme(legend.position='bottom', plot.title = element_text(hjust = 0))

figsave(gie1, gid1, 'txout_reg1')

### New cases only
gic2 <- within(gic, {
  Cases <- new_sp_coh + new_snep_coh  #+ ret_coh
  Success <- (new_sp_cur + new_sp_cmplt + new_snep_cmplt ) / Cases #+ ret_cur + ret_cmplt
  Died <- (new_sp_died + new_snep_died) / Cases # + ret_died
  Failed <- (new_sp_fail + new_snep_fail) / Cases # + ret_fail
  Defaulted <- (new_sp_def + new_snep_def) / Cases # + ret_def
  Unevaluated <- (c_new_sp_neval + c_new_snep_neval) / Cases # + c_ret_neval
})

# reshape for the plot
gid2 <- melt(gic2[,c('area', 'Success', 'Died', 'Failed', 'Defaulted', 'Unevaluated')], id=1)
gid2$variable <- factor(gid2$variable, levels=c("Success", "Died", "Failed", "Defaulted", "Unevaluated"), labels=c("Successfully treated", "Died", "Failed", "Defaulted", "Not evaluated"))
  
gie2 <- ggplot(gid2, aes(area, value, fill = variable) ) + geom_bar(stat='identity', position='fill' ) + scale_y_continuous("", breaks=seq(0, 1, 0.1), labels=percent_format()) + scale_fill_manual("", values=c('goldenrod2', 'firebrick3', 'olivedrab', 'navy', 'orangered')) + coord_flip() + theme_bw() + labs(x="", title=paste('b. All new cases')) + theme(legend.position='bottom', plot.title = element_text(hjust = 0))

figsave(gie2, gid2, 'txout_reg2')

#==========================
# Pieces of the 'top 10 countries' figure (previously a table)

tma <- subset(e.t,e_inc_num > 1e3 & year==thisyear-1)

tma$e_mort_num <- tma$e_mort_100k / 1e5 * tma$e_pop_num
tma$e_mort_num_lo <- tma$e_mort_100k_lo / 1e5 * tma$e_pop_num
tma$e_mort_num_hi <- tma$e_mort_100k_hi / 1e5 * tma$e_pop_num

.maxplus <- function(df, vect, num.rows){
  df1 <- df[order(df[vect], decreasing=TRUE),]
  df1 <- .shortnames(df1[1:num.rows, c('country', vect, glue(vect, '_lo'), glue(vect, '_hi'))])
  df1$var <- vect
  names(df1) <- c("country", 'best', 'lo', 'hi', 'var')
  (df1)
}

tm1 <- .maxplus(tma, 'e_inc_num', 10)
tm2 <- .maxplus(tma, 'e_inc_100k', 10)
tm3 <- .maxplus(tma, 'e_inc_tbhiv_num', 10)
tm4 <- .maxplus(tma, 'e_mort_exc_tbhiv_num', 10)
tm5 <- .maxplus(tma, 'e_mort_exc_tbhiv_100k', 10)
tm6 <- .maxplus(tma, 'e_mort_num', 10)
tm7 <- .maxplus(tma, 'e_mort_100k', 10)

tm.nhiv <- rbind(tm1, tm2, tm3, tm4, tm5, tm6, tm7)
tm.nhiv$var <- factor(tm.nhiv$var, levels=c("e_inc_num", "e_inc_100k",  "e_inc_tbhiv_num", "e_mort_exc_tbhiv_num", "e_mort_exc_tbhiv_100k", 'e_mort_num', 'e_mort_100k'), labels=c("Incidence: absolute numbers", "Incidence: rate per 100 000 population",  "TB/HIV incidence", "Mortality (excluding TB/HIV)", "Mortality per 100 000 (excluding TB/HIV)", "Mortality (including TB/HIV)", "Mortality per 100 000 (including TB/HIV)"))

# ggplot(tm.nhiv, aes(best, country)) + geom_point()  + facet_wrap(~var, scales='free') 
# + geom_errorbar(aes(ymin='lo', ymax='hi'))+ coord_flip()

for(pn in c(1,4,6)){
 vr <- levels(tm.nhiv$var)[pn]
tn <- subset(tm.nhiv, var==vr)
tn$country <- factor(tn$country, levels=rev(tn$country))
tn1 <- ggplot(tn, aes(best/1e6, country, xmin=lo/1e6, xmax=hi/1e6)) + geom_point()  + geom_errorbarh(height=.25) +  theme_bw() + labs(y="", x='Cases per year (millions)', title=vr) + theme(plot.title = element_text(hjust = 0)) 

figsave(tn1, tn, glue('topten_', pn), width=5, height=4) 
}

for(pn in c(2,5,7)){
  vr <- levels(tm.nhiv$var)[pn]
  tn <- subset(tm.nhiv, var==vr)
  tn$country <- factor(tn$country, levels=rev(tn$country))
  tn1 <- ggplot(tn, aes(best, country, xmin=lo, xmax=hi)) + geom_point()  + geom_errorbarh(height=.25) +  theme_bw() + labs(y="", x='Rate per 100 000 per year', title=vr) + theme(plot.title = element_text(hjust = 0)) 
  
  figsave(tn1, tn, glue('topten_', pn), width=5, height=4) 
}






## END ++=================================++
dmod <- lm(price ~ cut, data=diamonds)
cuts <- data.frame(cut=unique(diamonds$cut), predict(dmod, data.frame(cut = unique(diamonds$cut)), se=TRUE)[c("fit","se.fit")])

se <- ggplot(cuts, aes(cut, fit, ymin = 3400, ymax=fit + se.fit, colour = cut))
se + geom_linerange()




