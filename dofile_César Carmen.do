*** Especialización en construcción e interpretación de indicadores socioeconómicos ***

*** Paper: TIC'Cs "Mujeres rurales y el uso de teléfonos móviles en el Perú. Efecto en el empoderamiento con visión de capital humano" ***

*** Docente: Soledad Ruiz Lopez ***

*** Alumno: César Carmen Crisanto ***

** Usar dos carpetas: DATA y OUTPUTS. Dentro de DATA colocar tres carpetas llamadas: 2017, 2018 y 2019. **

* Instalamos los módulos necesarios
/*
* ----------------------
* AÑO 2017
* ----------------------
local modulos "03 05"
foreach m in `modulos' {
    enahodata, modulo("`m'") año("2017") ///
        path("C:\Users\LENOVO\Desktop\CURSOS EXTRACURRICULARES\INDICADORES EXPERTISEMIND\TRABAJO 1\DATA\2017") ///
        descomprimir load replace
}

* ----------------------
* AÑO 2018
* ----------------------
local modulos "03 05"
foreach m in `modulos' {
    enahodata, modulo("`m'") año("2018") ///
        path("C:\Users\LENOVO\Desktop\CURSOS EXTRACURRICULARES\INDICADORES EXPERTISEMIND\TRABAJO 1\DATA\2018") ///
        descomprimir load replace
}

* ----------------------
* AÑO 2019
* ----------------------
local modulos "03 05"
foreach m in `modulos' {
    enahodata, modulo("`m'") año("2019") ///
        path("C:\Users\LENOVO\Desktop\CURSOS EXTRACURRICULARES\INDICADORES EXPERTISEMIND\TRABAJO 1\DATA\2019") ///
        descomprimir load replace
}
*/

clear all

* Ruta base general
global base "C:\Users\LENOVO\Desktop\CURSOS EXTRACURRICULARES\INDICADORES EXPERTISEMIND\TRABAJO 1"

* 1. Cargamos el módulo 300 y unimos los años
use "$base\DATA\2019\modulo_03_2019\enaho01a-2019-300.dta", clear
append using "$base\DATA\2018\modulo_03_2018\enaho01a-2018-300.dta"
append using "$base\DATA\2017\modulo_03_2017\enaho01a-2017-300.dta"

rename aÑo año, replace
destring año, replace

* 2. Quitamos informantes no válidos
drop if codinfor=="00"

* 3. Dejamos miembros habituales en el hogar
keep if ((p204==1 & p205==2) | (p204==2 & p206==1))

* CÁLCULO DE VARIABLES *

* 4. Zona de residencia
recode estrato (1/5=0 "Urbano") (6/8=1 "Rural") (missing=.), gen(area)

* 5. Sexo
recode p207 (1=0 "Hombre") (2=1 "Mujer") (missing=.), gen(sexo)

* >>> FILTRO MUESTRA DEL PAPER <<<
keep if sexo==1 & area==1   // Mujeres rurales

* 6. Tenencia de teléfono móvil propio 
gen movil_propio = .
replace movil_propio = 1 if p316a1 == 1 // Sí usó teléfono celular propio
replace movil_propio = 0 if p316a1 == 0 // No usó celular propio (pase)
label define lbl_movil_propio 0 "No usó celular propio" 1 "Sí usó celular propio"
label values movil_propio lbl_movil_propio
label variable movil_propio "Uso de teléfono móvil propio (1=sí)"

* 7. Tenencia de teléfono móvil de un familiar 
gen movil_familiar = .
replace movil_familiar = 1 if p316a2 == 2 // Usó celular de familiar o amigo
replace movil_familiar = 0 if p316a2 == 0 // No usó (pase)
label define lbl_movil_fam 0 "No usó celular de familiar" 1 "Sí usó celular de familiar"
label values movil_familiar lbl_movil_fam
label variable movil_familiar "Uso de celular de familiar o amigo (1=sí)"


* 8. Tenencia de teléfono móvil de centro laboral 
gen movil_trabajo = .
replace movil_trabajo = 1 if p316a3 == 3 // Usó celular del trabajo
replace movil_trabajo = 0 if p316a3 == 0 // No usó (pase)
label define lbl_movil_trab 0 "No usó celular del trabajo" 1 "Sí usó celular del trabajo"
label values movil_trabajo lbl_movil_trab
label variable movil_trabajo "Uso de celular del trabajo (1=sí)"

* 9. Años de educación
gener educa=0   if (p301a==1 | p301a==2)

replace educa=1 if (p301a==3 & p301b==0)
replace educa=2 if (p301a==3 & p301b==1)
replace educa=3 if (p301a==3 & p301b==2)
replace educa=4 if (p301a==3 & p301b==3)
replace educa=5 if (p301a==3 & p301b==4)
replace educa=5 if (p301a==3 & p301b==5)
replace educa=6 if (p301a==4 & p301b==5)
replace educa=6 if (p301a==4 & p301b==6)
replace educa=7  if (p301a==5 & p301b==1)
replace educa=8  if (p301a==5 & p301b==2)
replace educa=9  if (p301a==5 & p301b==3)
replace educa=10 if (p301a==5 & p301b==4)
replace educa=10 if (p301a==5 & p301b==5)
replace educa=11 if (p301a==6 & p301b==5)
replace educa=11 if (p301a==6 & p301b==6)
replace educa=12 if (p301a==7 & p301b==1)
replace educa=13 if (p301a==7 & p301b==2)
replace educa=14 if (p301a==7 & p301b==3)
replace educa=14 if (p301a==7 & p301b==4)
replace educa=14 if (p301a==8 & p301b==3)
replace educa=14 if (p301a==8 & p301b==4)
replace educa=15 if (p301a==8 & p301b==5)
replace educa=12 if (p301a==9 & p301b==1)
replace educa=13 if (p301a==9 & p301b==2)
replace educa=14 if (p301a==9 & p301b==3)
replace educa=15 if (p301a==9 & p301b==4)
replace educa=15 if (p301a==9 & p301b==5)
replace educa=15 if (p301a==9 & p301b==6)
replace educa=16 if (p301a==10 & p301b==4)
replace educa=16 if (p301a==10 & p301b==5)
replace educa=16 if (p301a==10 & p301b==6)
replace educa=16 if (p301a==10 & p301b==7)
replace educa=16 if (p301a==11 & p301b==1)
replace educa=16 if (p301a==11 & p301b==2)
replace educa=1  if (p301a==3 & p301c==1)
replace educa=2  if (p301a==3 & p301c==2)
replace educa=3  if (p301a==3 & p301c==3)
replace educa=4  if (p301a==3 & p301c==4)
replace educa=5  if (p301a==3 & p301c==5)
replace educa=6  if (p301a==4 & p301c==5)
replace educa=6  if (p301a==4 & p301c==6)
label variable educa "Años de educación" 
replace educa = . if missing(p301a, p301b)

* 10. Edad
gen edad = p208a if !missing(p208a)

* 11. Estado civil 
recode p209 (6=1 "Soltera") (1/5=0 "No soltera") (missing=.), gen(estado_civil)

* 12. Jefa del hogar 
recode p203 (2/11=0 "No es jefe del hogar") (1=1 "Jefe del hogar") (missing=.), gen(jefehogar)

* >>> Limpieza final de missing (según paper) <<<
drop if missing(movil_propio, movil_familiar, movil_trabajo, educa, edad, estado_civil, jefehogar)

* 12. Guardamos solo variables de interés
keep año conglome vivienda hogar codperso area sexo movil_propio movil_familiar movil_trabajo educa estado_civil jefehogar  edad
isid año conglome vivienda hogar codperso 

save "$base\OUTPUTS\Variables TICs Módulo 300.dta", replace

****************** MODULO 500 ***********************
clear all

* Ruta base general
global base "C:\Users\LENOVO\Desktop\CURSOS EXTRACURRICULARES\INDICADORES EXPERTISEMIND\TRABAJO 1"

* 1. Cargamos el módulo 500 y unir años
use "$base\DATA\2019\modulo_05_2019\enaho01a-2019-500.dta", clear
append using "$base\DATA\2018\modulo_05_2018\enaho01a-2018-500.dta"
append using "$base\DATA\2017\modulo_05_2017\enaho01a-2017-500.dta"

rename aÑo año, replace
destring año, replace

* 2. Quitamos informantes no válidos
drop if codinfor=="00"

* 3. Miembros habituales en el hogar
keep if ((p204==1 & p205==2) | (p204==2 & p206==1))

* CÁLCULO DE VARIABLES *

* 4. Zona de residencia
recode estrato (1/5=0 "Urbano") (6/8=1 "Rural") (missing=.), gen(area)

* 5. Sexo 

recode p207 (1=0 "Hombre") (2=1 "Mujer") (missing=.), gen(sexo)

* 6. Participación en el mercado laboral

gen byte part = .
replace part = 1 if inlist(ocu500,1,2,3)
replace part = 0 if ocu500==4
label define partlbl 1 "Participa" 0 "No participa", replace
label values part partlbl

* 7. Experiencia laboral
rename p513a1 exp_potencial, replace
drop if missing(exp_potencial)

* 8. Cuadrado de la experiencia
gen exp2 = exp_potencial^2

label variable exp_potencial "Experiencia laboral potencial (años)"
label variable exp2 "Experiencia laboral al cuadrado"

* 9. Ingreso mensual

tab ocu500, m
gen r3 = .
replace r3 = 1 if ocu500 == 1                        
replace r3 = 2 if ocu500 == 2                        
replace r3 = 3 if inlist(ocu500, 3, 4)               
label define r3 1 "Ocupados" 2 "Desempleados" 3 "Inactivos"
label values r3 r3

replace d529t = . if d529t == 999999
replace d536  = . if d536  == 999999
replace d540t = . if d540t == 999999
replace d543  = . if d543  == 999999
replace d544t = . if d544t == 999999

egen r6prin = rsum(i524a1 d529t i530a d536) if r3 == 1
egen r6sec  = rsum(i538a1 d540t i541a d543) if r3 == 1
egen r6_lab = rsum(r6prin r6sec)            if r3 == 1
gen  ingreso_mensual = r6_lab/12
label var ingreso_mensual "Ingreso laboral mensual (princ. + sec.)"
drop if missing(ingreso_mensual)

* 10. Filtramos para mujeres rurales y con ingreso>0
keep if area==1 & sexo==1 & part==1 & ingreso_mensual>0

* 11. Guardamos solo variables de interés

keep año conglome vivienda hogar codperso area sexo part ingreso_mensual exp_potencial exp2
isid año conglome vivienda hogar codperso  

save "$base\OUTPUTS\Variables TICs Módulo 500.dta", replace

****************Unimos las dos bases de datos*******************
clear all
* 1. Cargamos base del módulo 300 (Máster)
use "$base\OUTPUTS\Variables TICs Módulo 300.dta", clear
isid año conglome vivienda hogar codperso

* 2. Hacemos merge con módulo 500 
merge 1:1 año conglome vivienda hogar codperso using "$base/OUTPUTS/Variables TICs Módulo 500.dta"

tab _merge
drop if _merge!=3
drop _merge

* Guardamos base combinada
save "$base\OUTPUTS\Variables TICs Combinada.dta", replace

**************** Replicamos algunas tablas *******************
clear all
use "$base/OUTPUTS/Variables TICs Combinada.dta", clear
* -------------------------
* Tabla 2. Estadística descriptiva de las variables explicativas no dicotómicas (año 2017)
* -------------------------
sum ingreso_mensual educa exp_potencial if año == 2017 

* -------------------------
* Tabla 3. Estadística descriptiva de las variables explicativas dicotómicas (año 2017)
* -------------------------
tab part if año == 2017
tab estado_civil if año == 2017
tab movil_propio if año == 2017
tab movil_familiar if año == 2017
tab movil_trabajo if año == 2017
tab jefehogar if año == 2017

* -------------------------
* Tabla 4. Estadística descriptiva de las variables explicativas no dicotómicas (año 2018)
* -------------------------
sum ingreso_mensual educa exp_potencial if año == 2018 

* -------------------------
* Tabla 5. Estadística descriptiva de las variables explicativas dicotómicas (año 2018)
* -------------------------
tab part if año == 2018
tab estado_civil if año == 2018
tab movil_propio if año == 2018
tab movil_familiar if año == 2018
tab movil_trabajo if año == 2018
tab jefehogar if año == 2018

* -------------------------
* Tabla 6. Estadística descriptiva de las variables explicativas no dicotómicas (año 2019)
* -------------------------
sum ingreso_mensual educa exp_potencial if año == 2019 

* -------------------------
* Tabla 7. Estadística descriptiva de las variables explicativas dicotómicas (año 2019)
* -------------------------
tab part if año == 2019
tab estado_civil if año == 2019
tab movil_propio if año == 2019
tab movil_familiar if año == 2019
tab movil_trabajo if año == 2019
tab jefehogar if año == 2019

*************************************************************************************
* ================== BLOQUE FINAL: ESTIMACIÓN Y TABLA 11 ==================
clear all
use "$base\OUTPUTS\Variables TICs Módulo 300.dta", clear  
tempfile base300
save `base300'

* Redefinimos algunas variables del módulo 500 para poder hacer la estimación
use "$base\DATA\2019\modulo_05_2019\enaho01a-2019-500.dta", clear
append using "$base\DATA\2018\modulo_05_2018\enaho01a-2018-500.dta"
append using "$base\DATA\2017\modulo_05_2017\enaho01a-2017-500.dta"
rename aÑo año
destring año, replace
drop if codinfor=="00"
keep if ((p204==1 & p205==2) | (p204==2 & p206==1))

* zona/sexo para filtrar mujeres rurales
recode estrato (1/5=0) (6/8=1), gen(area)
recode p207 (1=0) (2=1), gen(sexo)
keep if area==1 & sexo==1

* participación
gen byte part = .
replace part = 1 if inlist(ocu500,1,2,3)
replace part = 0 if ocu500==4
label define partlbl 1 "Participa" 0 "No participa", replace
label values part partlbl

* Experiencia potencial 
rename p513a1 exp_potencial
drop if missing(exp_potencial)
gen exp2 = exp_potencial^2
label var exp_potencial "Experiencia laboral potencial (años)"
label var exp2           "Experiencia laboral al cuadrado"

* ingreso mensual
replace d529t = . if d529t == 999999
replace d536  = . if d536  == 999999
replace d540t = . if d540t == 999999
replace d543  = . if d543  == 999999
replace d544t = . if d544t == 999999

egen r6prin = rsum(i524a1 d529t i530a d536) if part == 1
egen r6sec  = rsum(i538a1 d540t i541a d543) if part == 1
egen r6_lab = rsum(r6prin r6sec)            if part == 1
gen  ingreso_mensual = r6_lab/12
label var ingreso_mensual "Ingreso laboral mensual (princ. + sec.)"

* Log ingreso solo para ocupadas con ingreso>0 (necesario para etapa 2)
gen ln_ing = ln(ingreso_mensual) if part==1 & ingreso_mensual>0

keep año conglome vivienda hogar codperso part ingreso_mensual ln_ing exp_potencial exp2
tempfile base500
save `base500', replace

* Unimos con la base 300 ya creada
use `base300', clear
merge 1:1 año conglome vivienda hogar codperso using `base500', nogen

* Renombramos las variables similares al paper
rename (educa exp_potencial exp2) (S Exp Exp2)
* Redefinimos EC similar al paper 
gen EC = (estado_civil==0) if !missing(estado_civil)
* dummies con los nombres del paper
gen UCPR = movil_propio
gen UCFM = movil_familiar
gen UCLB = movil_trabajo

* Estimamos Heckman 2 pasos (manual) por año y construimos Tabla 11
tempname post
tempfile tabla11
postfile `post' str4 anio double N UCPR UCFM UCLB lambda using "`tabla11'", replace

foreach yy in 2017 2018 2019 {
    preserve
    keep if año==`yy'

    * Paso 1: selección (sin UCPR/UCFM/UCLB)
    probit part S Exp Exp2 jefehogar if inlist(part,0,1)
    predict xb_sel if e(sample), xb
    gen mills = normalden(xb_sel)/normal(xb_sel) if part==1

    * Paso 2: salarios (ocupadas con ln_ing)
    regress ln_ing S Exp Exp2 EC UCPR UCFM UCLB mills if part==1 & ln_ing<.

    scalar N   = e(N)
    scalar b1  = _b[UCPR]
    scalar b2  = _b[UCFM]
    scalar b3  = _b[UCLB]
    scalar lam = _b[mills]
    post `post' ("`yy'") (N) (b1) (b2) (b3) (lam)

    restore
}
postclose `post'

* -------------------------
* Tabla 11. Coeficiente de las variables de interés
* -------------------------
use "`tabla11'", clear
list, abbrev(14)
