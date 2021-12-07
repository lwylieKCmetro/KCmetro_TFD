--Daily headcount per location from MFIVE KC Vehicle Maintenance
declare @today datetime
set @today = getdate()
select
	count(DISTINCT lbrchg.EMP_ID) AS HEADCOUNT,
	--Dwell time to infer facility usage
	sum(datediff(hh,lbrchg.START_TIME,lbrchg.END_TIME)) AS 'DWELL_TIME',
	--lbrchg.LOCATION AS MFIVE_LOCATION,
	CASE
		WHEN lbrchg.LOCATION = 'SB' THEN 'SBVM'
		WHEN lbrchg.LOCATION = 'BB' THEN 'BBVM'
		WHEN lbrchg.LOCATION = 'EB' THEN 'EBVM'
		WHEN lbrchg.LOCATION = 'CB' THEN 'CBVM'
		WHEN lbrchg.LOCATION = 'AB' THEN 'ABVM'
		WHEN lbrchg.LOCATION = 'NB' THEN 'NBVM'
		WHEN lbrchg.LOCATION = 'NRV' THEN 'CNRV'
		WHEN lbrchg.LOCATION = 'RB' THEN 'RBVM'
		WHEN lbrchg.LOCATION = 'MO' THEN 'MTOB'
		ELSE lbrchg.LOCATION
	END AS EAM_LOCATION,
	locgen.NAME,
	locgen.ADDRESS,
	CONVERT(DATE,lbrchg.START_TIME) AS 'WORK_DATE',
	--CAST(lbrchg.START_TIME AS DATE) AS 'WORK_DATE',
	scdshf.DESCRIPTION AS 'SHIFT'
from MFIVE.ACC_LAB_CHG lbrchg
LEFT OUTER JOIN [MFIVE].[SCHED_SHIFT] scdshf ON lbrchg.[SHIFT_CODE]=scdshf.SCHED_SHIFT
LEFT OUTER JOIN [MFIVE].[LOC_GEN] locgen ON lbrchg.LOCATION=locgen.LOCATION
WHERE lbrchg.START_TIME >= @TODAY-3
--WHERE lbrchg.START_TIME >= '2017/1/1'
GROUP BY CONVERT(DATE,lbrchg.START_TIME),scdshf.DESCRIPTION,lbrchg.LOCATION,locgen.NAME,locgen.ADDRESS
ORDER BY CONVERT(DATE,lbrchg.START_TIME) DESC
;
