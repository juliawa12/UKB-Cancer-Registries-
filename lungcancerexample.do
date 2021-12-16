/*Cancer prep for Symposium
A. Define prevalent cancers for exclusion
B. Define incident lung cancers
C. Define lung cancer death */

**# Bookmark #1
*A. Prepping PREVALENT CANCER VARIABLE


*****************************************************************************************************
*1. Define malignant and benign neoplasms reported as icd9 and icd10. Check number of var in database with icd9 and icd10
*2. Check how many recorded by both icd9 & icd10 ignoring overlaps, make sure that all malignant are not overwritten by D if both were reported	
*3. Select only malignant codes where diagnosed before the recruitment/screening to exclude them from the analysis. Delete prevalent cancers
**********************************************

*1.*
	*1. Define malignant and benign neoplasms reported as ICD9 and ICD10 (prevalent and incident)
	**remember to check if there are additional icd9 and icd10 var compared with the previous database

	*ICD 9
	**Malignant and benign neoplasms reported as ICD9 neoplasms go from 140-239 (prevalent and incident):
	sum ca_icd9_* // based on 12/08/21 1-8 and 10-13 and 14 available!
	
	* 1: ICD 9 from 140 (Malignant neoplasm of lip) to 208 (Leukemia of unspecified cell type)
	* 2: ICD 9 from 209 (Neuroendocrine tumors) to 234 (Carcinoma in situ of other and unspecified sites): Benign or in situ 
	* 3: ICD 9 = 173 Non melanoma skin or NSB
	* http://www.icd9data.com/2012/Volume1/140-239/179-189/185/185.htm 
	* comands: real: string variable that has only numbers in it and want to convert it to a numeric variable. 
		*substr: string variable; the position of the start of the substring; and the length of the substring to be copied
	
	capture drop icd9_malign prevalent_9
		gen icd9_malign=0
		gen prevalent_9=0
		gen prevalent_9Breast=0
		
		forvalues i=0/8 {  
			replace icd9_malign =1 if real(substr(ca_icd9_`i',1,3))>=140 &  real(substr(ca_icd9_`i',1,3))<=208  & ///
			 real(substr(ca_icd9_`i', 1,3))!=173 
			recode icd9_malign 0=2 if real(substr(ca_icd9_`i',1,3)) >= 209 & real(substr(ca_icd9_`i',1,3)) <=234 
			recode icd9_malign 0=3 if real(substr(ca_icd9_`i',1,3))==173
			recode icd9_malign 2=4 if ca_icd9_`i'=="2330"
			replace prevalent_9 =1 if (ca_Dx_date_`i' < recruit_date) & ///
			(real(substr(ca_icd9_`i', 1,3))>=140 &  real(substr(ca_icd9_`i', 1,3))<=208  &  real(substr(ca_icd9_`i', 1,3))!=173)
			replace prevalent_9Breast =1 if (ca_Dx_date_`i' < recruit_date) & (ca_icd9_`i'=="2330")
		    
		    }
			forvalues i=10/12 {  
			replace icd9_malign =1 if real(substr(ca_icd9_`i', 1,3))>=140 &  real(substr(ca_icd9_`i', 1,3))<=208  & ///
			 real(substr(ca_icd9_`i', 1,3))!=173 
			recode icd9_malign 0=2 if real(substr(ca_icd9_`i',1,3)) >= 209 & real(substr(ca_icd9_`i',1,3)) <=234 
			recode icd9_malign 0=3 if real(substr(ca_icd9_`i',1,3))==173
			recode icd9_malign 2=4 if ca_icd9_`i'=="2330"
			replace prevalent_9 =1 if (ca_Dx_date_`i' < recruit_date) & ///
			(real(substr(ca_icd9_`i', 1,3))>=140 &  real(substr(ca_icd9_`i', 1,3))<=208  &  real(substr(ca_icd9_`i', 1,3))!=173)
			replace prevalent_9Breast =1 if (ca_Dx_date_`i' < recruit_date) & (ca_icd9_`i'=="2330")
		  }
		  			forvalues i=14/14 {  
			replace icd9_malign =1 if real(substr(ca_icd9_`i', 1,3))>=140 &  real(substr(ca_icd9_`i', 1,3))<=208  & ///
			 real(substr(ca_icd9_`i', 1,3))!=173 
			recode icd9_malign 0=2 if real(substr(ca_icd9_`i',1,3)) >= 209 & real(substr(ca_icd9_`i',1,3)) <=234 
			recode icd9_malign 0=3 if real(substr(ca_icd9_`i',1,3))==173
			recode icd9_malign 2=4 if ca_icd9_`i'=="2330"
			replace prevalent_9 =1 if (ca_Dx_date_`i' < recruit_date) & ///
			(real(substr(ca_icd9_`i', 1,3))>=140 &  real(substr(ca_icd9_`i', 1,3))<=208  &  real(substr(ca_icd9_`i', 1,3))!=173)
			replace prevalent_9Breast =1 if (ca_Dx_date_`i' < recruit_date) & (ca_icd9_`i'=="2330")
		  }
				 
	label define icd9_malignl 0 "0:no ICD 9" 1"1:ICD9 140-208 Malignant" 2"2:ICD9 209-234 Benign/Uncertain exc.breastis" 3"3:ICD9 173 NMskin" 4"4: ICD9 233 Breast in situ" 
	label values icd9_malign icd9_malignl
	
	tab icd9_malign
/*

                            icd9_malign |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                             0:no ICD 9 |    491,728       97.86       97.86
               1:ICD9 140-208 Malignant |      5,361        1.07       98.93
2:ICD9 209-234 Benign/Uncertain exc.bre |      3,886        0.77       99.70
                      3:ICD9 173 NMskin |      1,301        0.26       99.96
             4: ICD9 233 Breast in situ |        184        0.04      100.00
----------------------------------------+-----------------------------------
                                  Total |    502,460      100.00


*/
	 
	label define prevalent_9l 0 "0:no prevalent" 1"1:ICD9 Prevalent" 
	label values prevalent_9 prevalent_9l
	
	label define prevalent_9Breastl 0 "0:no prevalent Breast in situ" 1"1:ICD9 Breast in situ prevalent" 
	label values prevalent_9Breast prevalent_9Breastl
	
	ta icd9_malign prevalent_9
	***all icd9 malignancies are prevalent. Prevalent malignant cancers
	ta icd9_malign prevalent_9Breast
	*** all icd9 breast in situ are prevalent

	*ICD 10
	**Malignant and benign neoplasms reported as ICD10 (prevalent and incident):
	sum ca_icd10_* // 0-11, 13, 15-16
	* C (Malignant neoplasm) and not equal to C44 (Other and unspec malignant neoplasm of skin): Malignant
	* D Benign or in situ including D434 treated as bening
	* C44 Non melanoma skin or NSB
	* "D32","D33","D352","D42","D43","D443","D444","D445" other benign neoplash and "D434" (Neoplasm of uncertain behavior of spinal cord) // Need to ask where this comes from


	capture drop icd10_malign prevalent_10 prevalent_Dcns
		gen prevalent_10=0
		gen icd10_malign=0
		gen prevalent_Dcns=0 //D codes on CNS benign cancers
		gen prevalent_Dbreast=0 //D codes in situ breast cancer
		*gen prevalent_9Breast=0 // ICD 9 in situ breast cancer

		forvalues i=0/11 {
			   replace icd10_malign=1  if substr(ca_icd10_`i',1,1)=="C" & substr(ca_icd10_`i',1,3)!="C44"
			   recode icd10_malign 0=2 if substr(ca_icd10_`i',1,1)=="D" 
			   recode icd10_malign 0=3 if substr(ca_icd10_`i',1,3)=="C44"
			   replace prevalent_10 =1 if (ca_Dx_date_`i' < recruit_date) & ///
			   substr(ca_icd10_`i',1,1)=="C" & substr(ca_icd10_`i',1,3)!="C44"
				recode icd10_malign 2=4 if inlist(ca_icd10_`i',"D32","D33","D352","D42","D43") | inlist(ca_icd10_`i',"D443","D444","D445")
				recode icd10_malign 4=2 if substr(ca_icd10_`i', 1, 4) == "D434"
					replace prevalent_Dcns=1 if (ca_Dx_date_`i' < recruit_date) & (inlist(ca_icd10_`i',"D32","D33","D352","D42","D43") | ///
					inlist(ca_icd10_`i',"D443","D444","D445"))
					recode  prevalent_Dcns 1=0 if substr(ca_icd10_`i', 1, 4) == "D434"
				recode icd10_malign 2=5 if inlist(ca_icd10_`i',"D050","D051","D051","D057","D059")
			 replace prevalent_Dbreast=1 if (ca_Dx_date_`i' < recruit_date) & (inlist(ca_icd10_`i',"D050","D051","D051","D057","D059"))
	
			}
			forvalues i=13/13 {
			   replace icd10_malign=1  if substr(ca_icd10_`i',1,1)=="C" & substr(ca_icd10_`i',1,3)!="C44"
			   recode icd10_malign 0=2 if substr(ca_icd10_`i',1,1)=="D" 
			   recode icd10_malign 0=3 if substr(ca_icd10_`i',1,3)=="C44"
			   replace prevalent_10 =1 if (ca_Dx_date_`i' < recruit_date) & ///
			   substr(ca_icd10_`i',1,1)=="C" & substr(ca_icd10_`i',1,3)!="C44"
				recode icd10_malign 2=4 if inlist(ca_icd10_`i',"D32","D33","D352","D42","D43") | inlist(ca_icd10_`i',"D443","D444","D445")
				recode icd10_malign 4=2 if substr(ca_icd10_`i', 1, 4) == "D434"
					replace prevalent_Dcns=1 if (ca_Dx_date_`i' < recruit_date) & (inlist(ca_icd10_`i',"D32","D33","D352","D42","D43") | ///
					inlist(ca_icd10_`i',"D443","D444","D445"))
					recode  prevalent_Dcns 1=0 if substr(ca_icd10_`i', 1, 4) == "D434"
				recode icd10_malign 2=5 if inlist(ca_icd10_`i',"D050","D051","D051","D057","D059")
			replace prevalent_Dbreast=1 if (ca_Dx_date_`i' < recruit_date) & (inlist(ca_icd10_`i',"D050","D051","D051","D057","D059"))
			}
			
		forvalues i=15/16 {
			   replace icd10_malign=1  if substr(ca_icd10_`i',1,1)=="C" & substr(ca_icd10_`i',1,3)!="C44"
			   recode icd10_malign 0=2 if substr(ca_icd10_`i',1,1)=="D" 
			   recode icd10_malign 0=3 if substr(ca_icd10_`i',1,3)=="C44"
			   replace prevalent_10 =1 if (ca_Dx_date_`i' < recruit_date) & ///
			   substr(ca_icd10_`i',1,1)=="C" & substr(ca_icd10_`i',1,3)!="C44"
				recode icd10_malign 2=4 if inlist(ca_icd10_`i',"D32","D33","D352","D42","D43") | inlist(ca_icd10_`i',"D443","D444","D445")
				recode icd10_malign 4=2 if substr(ca_icd10_`i', 1, 4) == "D434"
					replace prevalent_Dcns=1 if (ca_Dx_date_`i' < recruit_date) & (inlist(ca_icd10_`i',"D32","D33","D352","D42","D43") | ///
					inlist(ca_icd10_`i',"D443","D444","D445"))
					recode  prevalent_Dcns 1=0 if substr(ca_icd10_`i', 1, 4) == "D434"
				recode icd10_malign 2=5 if inlist(ca_icd10_`i',"D050","D051","D051","D057","D059")
			replace prevalent_Dbreast=1 if (ca_Dx_date_`i' < recruit_date) & (inlist(ca_icd10_`i',"D050","D051","D051","D057","D059"))
			}	

	label define icd10_malignl 0 "0:no ICD 10" 1"1:ICD10 C code" 2"2:ICD10 D code" 3"3:ICD10 C44 NMSkin" 4"4:ICD10 D NS" 5"5:ICD10 D Breast in situ"
	label values icd10_malign icd10_malignl
	
	label define prevalent_10l 0 "0:no prevalent ICD 10" 1"1:Prevalent ICD10 C"  
	label values prevalent_10 prevalent_10l
	
	label define prevalent_Dcnsl 0 "0:no prevalent D of NS" 1"1:Prevalent ICD10 D NS"  
	label values prevalent_Dcns prevalent_Dcnsl
	
	label define prevalent_Dbreastl 0 "0:no prevalent D in situ breast" 1"1:Prevalent ICD10 D in situ breast"  
	label values prevalent_Dbreast prevalent_Dbreastl

	*label define prevalent_9Breastl 0 "0:no prevalent 9 in situ breast" 1"1:Prevalent ICD9 in situ breast"  
	label values prevalent_9Breast prevalent_9Breastl
	
	
	ta icd10_malign prevalent_10
	

	
*2.*Check how many recorded by both icd9 & icd10 ignoring overlaps
	*** create new var (any_ca) with both ICD9 and ICD10 cancers, independently of prevanlent or incident	
	capture drop any_ca
		gen any_ca=0		  
		recode any_ca 0=1 if icd9_malign ==1 | icd10_malign==1 //31182 changes made
		recode any_ca 0=2 if icd9_malign ==2 | icd10_malign==2 //8295 changes made
		recode any_ca 0=3 if icd9_malign ==3 | icd10_malign==3 //9560  changes made
		recode any_ca 0=4 if icd10_malign ==4 // no 4 in icd9  // 92 changes made
		recode any_ca 0=5 if icd9_malign==4 | icd10_malign==5 // 1974 changes made

		la de any_ca 0 "None reported" 1 "Malignant" 2 "Benign or in situ" 3 "Non melanoma skin or NSB" 4 "Other neoplasm" 5"In situ breast"
		la val any_ca any_ca
		la var any_ca "1 for all malignant tumours reported"
		
	tab2 any_ca prevalent_10 prevalent_9 prevalent_Dcns prevalent_Dbreast prevalent_9Breast, miss

*3.*				
	*3. select only malignant codes where diagnosed before the recruitment to exclude them from the analysis (delete prevalent cancers)
	
	*Decision to be made here: Exclude D-Codes/benign cancers?! (below excluded)
		capture drop prevalent_ca
			gen prevalent_ca=1 if (prevalent_9==1 | prevalent_10==1 | prevalent_Dcns==1 | prevalent_Dbreast==1 | prevalent_9Breast==1)
			
			tab2 any_ca prevalent_ca prevalent_10 prevalent_9 prevalent_Dcns prevalent_Dbreast prevalent_9Breast
			
	tab prevalent_ca //no prevalent cancers incl in situ cancers and benign CNS cancers: 28430
	tab prevalent_ca any_ca
	
**# Bookmark #2
*B. Define incident lung cancers
*1. Generate dates for incident malignant tumours. Only icd10 because all icd9 were prevalent and we have dropped them

drop if prevalent_ca==1 
*(28,297 observations deleted / 26,066 - after baseline ihd was excluded)

	 count 
	 sum ca_icd10_* // 0-11, 13, 15-16
	 
global  prev =  "prevalent_ca==0"
		forvalues i= 0/11 {
		gen cancer_date_`i' = cond(ca_Dx_date_`i' > recruit_date & ///
		(substr(ca_icd10_`i', 1, 1) == "C" | inlist(ca_icd10_`i',"D32","D33","D352","D42","D43") | ///
		inlist(ca_icd10_`i',"D443","D444","D445")) , ca_Dx_date_`i', .) 
		
		replace cancer_date_`i' =. if substr(ca_icd10_`i', 1, 4) == "D434" 
		replace cancer_date_`i' =. if substr(ca_icd10_`i', 1, 3) == "C44"
		gen ca_10_`i'= ca_icd10_`i' if cancer_date_`i'!=. 
		}
				
		forvalues i= 13/13 {
		gen cancer_date_`i' = cond(ca_Dx_date_`i' > recruit_date & ///
		(substr(ca_icd10_`i', 1, 1) == "C" | inlist(ca_icd10_`i',"D32","D33","D352","D42","D43") | ///
		inlist(ca_icd10_`i',"D443","D444","D445")) , ca_Dx_date_`i', .) 
		
		replace cancer_date_`i' =. if substr(ca_icd10_`i', 1, 4) == "D434" 
		replace cancer_date_`i' =. if substr(ca_icd10_`i', 1, 3) == "C44" 
		gen ca_10_`i'= ca_icd10_`i' if cancer_date_`i'!=. 
		}
		
		forvalues i= 15/16 {
		gen cancer_date_`i' = cond(ca_Dx_date_`i' > recruit_date & ///
		(substr(ca_icd10_`i', 1, 1) == "C" | inlist(ca_icd10_`i',"D32","D33","D352","D42","D43") | ///
		inlist(ca_icd10_`i',"D443","D444","D445")) , ca_Dx_date_`i', .) 
		
		replace cancer_date_`i' =. if substr(ca_icd10_`i', 1, 4) == "D434" 
		replace cancer_date_`i' =. if substr(ca_icd10_`i', 1, 3) == "C44" 
		gen ca_10_`i'= ca_icd10_`i' if cancer_date_`i'!=. 
		}
		
	*from ca_Dx_date_30, no cancers, therefore I won't consider 30 and 31 from now on
		
		format ca*_date* %d
sort eid

	list eid ca_Dx_date_0 cancer_date_0 ca_icd10_0 ca_10_0 recruit_date any_ca if any_ca>=1 in 100/500

*2. Replace first ca diagnosis with earliest date of all primaries reported after the recruitment/screening date
	capture drop first_ca_*
		gen first_ca_10_date = cancer_date_0 if cancer_date_0 !=. & $prev
		count  if first_ca_10_date !=.

			forvalues i= 0/11 {
			replace first_ca_10_date =cond(cancer_date_`i' !=. , min(first_ca_10_date,cancer_date_`i'),first_ca_10_date) 
			}
			forvalues i= 13/13 {
			replace first_ca_10_date =cond(cancer_date_`i' !=. , min(first_ca_10_date,cancer_date_`i'),first_ca_10_date)  
			} // with this code: 29,292 like Gina 
			
			forvalues i= 15/16 {
			replace first_ca_10_date =cond(cancer_date_`i' !=. , min(first_ca_10_date,cancer_date_`i'),first_ca_10_date) 
			} // with this code: 29,292 like Gina  
			
	count if first_ca_10_date !=.
	* 23,476 incident total cancers - NEW: 29,292 like Gina  - MAY:  28,408
		format ca*_date* %d
		
*3. Replace first ca diagnosis with earliest date of all primaries reported after the recruitment/screening date
	capture drop first_ca_*
		gen first_ca_10_date = cancer_date_0 if cancer_date_0 !=. & $prev
		count  if first_ca_10_date !=.

			forvalues i= 0/11 {
			replace first_ca_10_date =cond(cancer_date_`i' !=. , min(first_ca_10_date,cancer_date_`i'),first_ca_10_date)
			}
			forvalues i= 13/13 {
			replace first_ca_10_date =cond(cancer_date_`i' !=. , min(first_ca_10_date,cancer_date_`i'),first_ca_10_date) 
			}
			forvalues i= 15/16 {
			replace first_ca_10_date =cond(cancer_date_`i' !=. , min(first_ca_10_date,cancer_date_`i'),first_ca_10_date) 
			}
count if first_ca_10_date !=. // 29255

*4.: CANCER BY CENTRE	
	
		tab region
		
	/* based on UKBB we should use the fellowing censoring dates http://biobank.ctsu.ox.ac.uk/crystal/exinfo.cgi?src=Data_providers_and_dates
	which are 30 nov 2014 for england and wales and 31 dece 2014 for scotland.*/
	
	*5.: SET DATES / TIMING
		**censoring:		
replace first_ca_10_date=. if region!=10 & (first_ca_10_date>mdy(03,31,2016)) // for england - 246 MISSING
replace first_ca_10_date=. if region==10 & (first_ca_10_date>mdy(10,31,2015)) // for scotland - 18 MISSING
		
		**From all valid dates and diagnoses for incident malignant tumours pick up the earliest date if multiple:
		**gen variable to hold the date of the first primary incident cancer, it will be ca_10* :
		sort first_ca_10_date
		sum recruit_date first_ca_10_date, f  //cancer is censored

*exactly like Gina

		** make sure that only first primary icd10 diagnoses considered further before defining incident cancer's type:
			 forvalues i=0/11 {
			   replace ca_10_`i'= "" if cancer_date_`i'!=first_ca_10_date & first_ca_10_date !=. 				
			   }
			   
			forvalues i=13/13 {
			   replace ca_10_`i'= "" if cancer_date_`i'!=first_ca_10_date & first_ca_10_date !=. 
				  }
				  
			forvalues i=15/16 {
			   replace ca_10_`i'= "" if cancer_date_`i'!=first_ca_10_date & first_ca_10_date !=. 
				  }
			*ca_10_*  "" empty fields, no primary cancers
				forvalues i= 0/11 {
				 count if ca_10_`i'  != ""
				}
				forvalues i= 13/13 {
				 count if ca_10_`i'  != ""
				}
				forvalues i= 15/16 {
				 count if ca_10_`i'  != ""
				}

			
**# Bookmark #2
	*9. Set and name cancer endpoint
	*LUNG cancer, ICD-10 CODE 34
			capture drop lung*
			gen lung=0
			la var lung  "Incident cancers of lung  [C34]"

	*All/Any Cancer, except NMSkin
			gen allcan=0
			la var allcan "All incident cancers [C00/C97] excluding [C44]"


	sum ca_10_*  //check this!!! - 0-11, 13, 15-16


	local k1="0/11"
	local k2="13/13"
	local k3="15/16"

foreach a in "1" "2" "3"{
		foreach cancer in "lung" "allcan"{
		forvalues k= `k`a'' {
			local i ca_10_`k'
			global  if =  "& ca_Dx_date_`k' == first_ca_10_date  & first_ca_10_date !=."
			local allcancode `"substr(`i',1,1)=="C"& (`i'!="C440"|`i'!="C441"|`i'!="C442"|`i'!="C443"|`i'!="C444"|`i'!="C445"|`i'!="C446"|`i'!="C447"|`i'!="C448"|`i'!="C449")"'
			local lungcode  `"`i'=="C340"|`i'=="C341"|`i'=="C342"|`i'=="C343"|`i'=="C344"|`i'=="C345"|`i'=="C346"|`i'=="C347"|`i'=="C348"|`i'=="C349""'				
			replace `cancer'=1 if (``cancer'code') $if 
			
		}
	
	}

}

		foreach cancer in "lung" "allcan"{
		gen `cancer'_inc=`cancer' 
		*not anymore recode `outcome'_inc 0=. if allcan==1
		local lbl : var label `cancer'
		label var `cancer'_inc "`lbl'"
}
	
***************************************
*Death outcomes

***********************************************************************
* Death primary //all deaths are now rip_primary 

drop death death_date
rename ts_40000_0 death_date_0
rename ts_40000_1 death_date_1
gen death_date=. // before censored time for DEATH
replace death_date=death_date_0 if (death_date_0<d(28feb2021)) 
format %td death_date
*drop if death_date<screened_date
gen death=0
replace death=1 if death_date!=.
tab death


*Lung Cancer
local death_3="DLung"
local death_primary_3 "C34"


local cause "rip_primary_icd10"

forvalues k=3/3 {
gen death`k'=.
gen death`k'_date=.
local n : word count `death_primary_`k''
forvalues i = 1/`n' {
local include_code : word `i' of `death_primary_`k''
local length=strlen("`include_code'")

forvalues j=0/1 {
* Note we've already dropped people who died before screening(!) so dates aren't important

quietly replace death`k'=1 if substr(`cause'_`j', 1, `length')=="`include_code'" & "`include_code'"!=""
quietly replace death`k'_date=death_date_`j' if substr(`cause'_`j', 1, `length')=="`include_code'" & "`include_code'"!="" & (death_date==. | (death_date_`j'<death_date & death_date!=.))
di "death_`k'"
}
}
}
