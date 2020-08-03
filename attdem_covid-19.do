clear 

cd "D:\Rati\Blog\Blog 25"

use COVID-19_merged_25.06.20.dta

keep if wave == 5

//// Wealth Index => utility
foreach var of varlist d3_1 d3_2 d3_3 d3_4 d3_5 d3_6 d3_7 d3_8 d3_9 d3_10 {
gen `var'r = `var' 
}

foreach var of varlist d3_1r d3_2r d3_3r d3_4r d3_5r d3_6r d3_7r d3_8r d3_9r d3_10r {
recode `var' (-9 / -1 = .)
}

gen utility = (d3_1r + d3_2r + d3_3r + d3_4r + d3_5r + d3_6r + d3_7r + d3_8r + d3_9r + d3_10r)


/// gender
/// recoding Female from 2 to 0  /// female = 0 
gen gender = sex
recode gender (2=0) 


/// education
gen education = d2
recode education (1/2 = 1) (3 = 2) (4/5 = 3) (-9 / -1 = .)


///  d6 -- Ethnicity of the respondent  => minority
/* 0 = Georgian   1 = Non-Georgian   */
gen minority = d6
recode minority (4 = 1)  (3 = 0) (2=1) (1=1) (-9 / -1 = .)

////  d1 => havejob 
/* 1 = empl 0 = no */
gen havejob =  d1
recode havejob (5/6 = 1) (1/4 = 0) (7/8 = 0) (-9 / -1 = . )


/// support for democracy

gen support = p17

recode support (-6 = .) (-9 = .) (-5 = .) (-2 = 0) (-1 = 0) (1=1) (2/3 = 0)   if wave == 5 

gen support2 = p17

recode support2 (-6 = .) (-9 = .) (-5 = .) (-2 = 4) (-1 = 4) (1=1) (2=2) (3 = 3)   if wave == 5 




/////////// democratic governance 

foreach var of varlist o_1 o_2 o_3 o_4 {
gen `var'r = `var' 
}

foreach var of varlist o_1r o_2r o_3r o_4r {
recode `var' (-9 / -2 = .) (1=1) (2=1) (-1= 2) (3=3) (4=3) 
}

foreach var of varlist o_1 o_2 o_3 o_4 {
gen `var'r2 = `var' 
}

foreach var of varlist o_1r2 o_2r2 o_3r2 o_4r2 {
recode `var' (-9 / -2 = .) (1=1) (2=2) (-1=3) (3=4) (4=5) 
}

foreach var of varlist o_1r2  o_3r2 o_4r2 {
recode `var' (-9 / -2 = .) (5=1) (4=2) (3=3) (4=2) (5=2) 
}

gen demo_index = (o_1r2 + o_2r2 + o_3r2 + o_4r)


svyset [pweight=weight]



stop


//// democracy model  => base demo

svy: logit support  i.stratum age gender i.education havejob  minority  utility   


svy: logit support  i.stratum age gender i.education havejob  minority  utility    
margins, at(education=( 1 2 3 ))
marginsplot


svy: logit support  i.stratum age gender i.education havejob  minority  utility   
margins, at(age=( 18 25 35 45 55 65 ))
marginsplot


svy: logit support  i.stratum age gender i.education havejob  minority  utility    
margins, at(gender=( 0 1))
marginsplot

svy: logit support  i.stratum age gender i.education havejob  minority  utility    
margins, at(utility=(0 5 10))
marginsplot



//// democracy model 1 

svy: mlogit o_1r support   i.stratum age gender i.education havejob  minority  utility 
margins, at(support=(0 1))
marginsplot

svy: mlogit  o_2r support i.stratum age gender i.education havejob  minority  utility  
margins, at(support=(0 1))
marginsplot

svy: mlogit  o_3r support i.stratum age gender i.education havejob  minority  utility  
margins, at(support=(0 1))
marginsplot

svy: mlogit  o_4r support  i.stratum age gender i.education havejob  minority  utility
margins, at(support=(0 1))
marginsplot


//// democracy model 2
svy: mlogit  support2  i.o_1r  i.stratum age gender i.education havejob  minority  utility 
margins, at(o_1r=(1 2 3))
marginsplot

svy: mlogit  support2  i.o_2r  i.stratum age gender i.education havejob  minority  utility   
margins, at(o_2r=(1 2 3))
marginsplot


svy: mlogit  support2  i.o_3r  i.stratum age gender i.education havejob  minority  utility  
margins, at(o_3r=(1 2 3))
marginsplot

svy: mlogit  support2  i.o_4r  i.stratum age gender i.education havejob  minority  utility 
margins, at(o_4r=(1 2 3))
marginsplot




