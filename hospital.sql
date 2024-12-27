SELECT first_name,last_name,gender FROM patients where gender="M";
---

SELECT first_name,last_name FROM patients where allergies is null;

SELECT first_name FROM patients where first_name like 'C%';

SELECT first_name,last_name FROM patients where weight between 100 and 120;

update patients set allergies='NKA' where allergies is Null;

select distinct(year(birth_date))as birth_year from patients order by birth_year;

Select first_name FROM patients 
group by first_name
having count(first_name)=1;

Select patient_id,first_name FROM patients where first_name like 'S%' and first_name like '%S' 
and LENGTH(first_name)>=6 ;

select patients.patient_id,patients.first_name,patients.last_name FROM patients 
Inner join admissions On patients.patient_id=admissions.patient_id
where diagnosis= 'Dementia';

Select first_name from patients
order by length(first_name), first_name;

Select 
sum(gender='M') as male_count,
sum(gender='F') as female_count
from patients;
  
select concat(first_name," ",last_name) as full_name from patients;

select * from province_names;

Select patients.first_name,patients.last_name,province_names.province_name from patients
Inner join province_names ON 
patients.province_id=province_names.province_id;

Select count(*) as total_patients from patients
where year(birth_date)=2010;

Select first_name,last_name,max(height)as height from patients;

select * from patients where patient_id In('1','45','534','879','1000');

select * from province_names;

Select count(patient_id) from admissions;
Select * from admissions where admission_date=discharge_date;

Select patient_id,count(patient_id) as total_admissions from admissions 
where patient_id=579;

select Distinct(city) AS unique_cities from patients where province_id='NS';

select first_name,last_name,birth_date from patients 
where height>160 and weight>70;

select first_name,last_name,allergies from patients 
where allergies is not NULL and city='Hamilton';
 
Select count(birth_date) AS total_patients from patients
where Year(birth_date)=2010;

Select concat(first_name," ",last_name) AS patient_name, Round(height/30.48,1) As height,round(weight*2.205,0) weight
,birth_date, 
Case
   when gender='M' then 'Male'
   when gender='F' then 'Female'
   else ''
END AS gender_type
from patients ;

select * from patients;

select patient_id, weight,height,
Case 
   when (weight/power(height/100.0,2)) >=30 then 1
   else 0
End As isObese
from patients ;

Select first_name,last_name,allergies from patients 
where allergies='Penicillin' or allergies='Morphine'
order by allergies,first_name,last_name;

Select distinct(patient_id),diagnosis from admissions 
Group by patient_id,diagnosis
having count(*)>1;

select city,count(patient_id) as num_patients from patients
group by city
Order by count(patient_id) desc,city ASC ;

Select first_name,last_name,'Patients' As role from patients
Union all 
Select first_name,last_name,'Doctors' As role from doctors;

select allergies,count(patient_id) As total_diagnosis from patients
where allergies is not NULL
group by allergies
order by total_diagnosis desc;

Select first_name,last_name,birth_date from patients 
where year(birth_date)>=1970 and year(birth_date)<1980
order by birth_date ;


select concat(upper(last_name),',',lower(first_name)) as new_name_format from patients
order by first_name desc ;

select 
Distinct(Case
    When patient_id%2=0 then 'Yes'
    else 'No' 
End) as has_insuarance,
Sum(case 
    when patient_id%2=0  Then 10
    Else 50
End) as cost_after_insuarance
from admissions
group by has_insuarance 
;

select * from province_names;

select * from patients;


Select Max(p_name.province_name) As province_name from province_names As p_name 
Inner JOIN patients
ON p_name.province_id=patients.province_id 
group by p_name.province_name
Having 
SUM(gender='M') > SUM(gender='F');

Select province_name from province_names
order by province_name ='Ontario' Desc,
province_name;


Select patient_id,attending_doctor_id,diagnosis from admissions
where (patient_id%2 <> 0 and attending_doctor_id in('1','5','19')) or
((attending_doctor_id like '%2%') and (patient_id like '___')); 


SELECT do.first_name,do.last_name,COUNT(ad.attending_doctor_id) AS admissions_total
FROM doctors AS do
INNER JOIN 
admissions AS ad  ON do.doctor_id = ad.attending_doctor_id
GROUP BY do.first_name, do.last_name;

select doctor_id,concat(do.first_name," ",do.last_name) AS full_name,
min(ad.admission_date) AS first_admission_date, max(ad.admission_date) AS last_admission_date
FROM doctors AS do
INNER JOIN 
admissions AS ad  ON do.doctor_id = ad.attending_doctor_id
GROUP BY do.first_name, do.last_name;

SELECT 
    pr.province_name AS province_name, 
    COUNT(pa.patient_id) AS patient_count
FROM 
    patients AS pa
INNER JOIN 
    province_names AS pr 
ON 
    pr.province_id = pa.province_id
GROUP BY 
    pr.province_name
ORDER BY 
    patient_count DESC;
    
    
Select Concat(pa.first_name," ",pa.last_name) As patient_name,
ad.diagnosis,concat(do.first_name," ",do.last_name) As doctor_name from
   patients AS pa
INNER JOIN
   admissions As ad  
On 
    pa.patient_id=ad.patient_id

INNER JOIN
     doctors As do 
on 
    ad.attending_doctor_id=do.doctor_id;
    
select first_name As first_name,last_name,count(*) As num_of_duplicate from patients
group by first_name,last_name
having count(*)>1;

SELECT
  patients.patient_id,
  first_name,
  last_name
from patients
  left join admissions on patients.patient_id = admissions.patient_id
where admissions.patient_id is NULL;

select Count(patient_id) As patients_in_group, floor(weight/10)*10  AS weight_group
From patients
group by weight_group
Order by weight_group Desc;


Select do.doctor_id AS doctor_id,concat(do.first_name," ",do.last_name) As doctor_name,
do.specialty AS specialty,Year(ad.admission_date) As selected_year,Count(*) AS total_admissions
from doctors As do 
left Join
admissions As ad
On do.doctor_id=ad.attending_doctor_id
group by doctor_id,selected_year;



Select pa.patient_id As patient_id,pa.first_name AS first_name,pa.last_name AS last_name
,do.specialty As attending_doctor_speciality from patients as pa 
join admissions as a On 
     pa.patient_id=a.patient_id 
join  doctors as do ON
   do.doctor_id = a.attending_doctor_id
where a.diagnosis='Epilepsy' and do.first_name='Lisa';


Select Distinct(p.patient_id) As patient_id,Concat(p.patient_id,len(last_name),
year(birth_date)) AS temp_password
From patients as p
Join admissions As a On
     p.patient_id=a.patient_id;


Select * from patients where 
first_name like "__r%" and gender="F" and (month(birth_date) in(2,5,12))
AND (weight between 60 and 80) and patient_id%2!=0 and city="Kingston";


Select admission_date, Count(patient_id) As admission_day,
COunt(admission_date) - lag(count(admission_date)) over(order by admission_date)AS admission_count_change from admissions
group by admission_date
Order by admission_date;















