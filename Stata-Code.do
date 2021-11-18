*set working directory
cd "/Users/ist2118/Documents/Research Methods II/Assignment 4"


* Install the "estout" package: 
ssc install estout


* Read in data: 
insheet using crime-iv.csv, comma names clear


* Labeling variables
label variable defendantid "Defendant ID"
label variable republicanjudge "Republican Judge"
label variable severityofcrime "Severity of Crime"
label variable monthsinjail "Months in Jail"

    
* Balance table
global balanceopts "bf(%15.2gc) sfmt(%15.2gc) se noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) "
estpost ttest severityofcrime, by(republicanjudge) unequal welch
esttab . using balancetable.rtf, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Control" "Treatment" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)


*First Stage IV design: Predict monthsinjail using republicanjudge as IV + control:
reg monthsinjail republicanjudge severityofcrime  
eststo regression_one


* Exporting table - 1
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2 "
esttab regression_one  using assignment4-Table2.rtf, $tableoptions 


*Reduced form regression: Predict recidivates using republicanjudge as IV + control:
reg recidivates republicanjudge severityofcrime 
eststo regression_two


* Exporting table - 2
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2 "
esttab regression_two  using assignment4-Table3.rtf, $tableoptions 


* Ratio =  .1426641  / 3.221876  = 0.0443


* IV Regression
ssc install ivreg2
ivreg2 recidivates (monthsinjail=republicanjudge) severityofcrime
eststo regression_three


* Exporting table - 3
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2 "
esttab regression_three  using assignment4-Table4.rtf, $tableoptions 


