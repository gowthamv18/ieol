
  CREATE OR REPLACE FORCE VIEW "DSS"."VIEW_REP_EXTRACT_CUST_DATA" ("INVTYPE", "INVNO", "RNO", "INVDATE", "BRANCH", "REGDATE", "AGINGDAYS", "REGNO", "MVARIANTCODE", "MVARIANTDESC", "CHASSISNO", "ENGINENO", "REPAIRTYPE", "INSCOMP", "REVLBRTL", "REVLBINT", "REVFS", "REVWARLB", "REVPARTSRTL", "REVPARTSINT", "REVPARTSWTY", "REVACCRTL", "REVACCINT", "REVACCWTY", "REVLUBRTL", "REVLUBINT", "REVLUBWTY", "REVMATRTL", "REVMATINT", "REVMATWTY", "CAMPDISC", "ADDDISCOUNT", "PKGOPDISCAMT", "PKGPARTDISCAMT", "EDISCAMT", "INSEXCESSAMT", "GSTEXCESS", "GSTAMOUNT", "VOUCHER", "EVAMOUNT", "TTLINVAMT", "ROUNDADJAMT", "TOTALAMTPAYABLE", "CURRMILEAGE", "CUSTNAME", "PDPA", "CUSTID", "MOBILENO", "HSETELNO", "OFFICETELNO", "SENDERNAME", "SENDERCONTACTNO", "SVCADVISORID", "SVCADVISORNAME", "CUST_TYPE_DESC", "CUSTRACE", "GENDER", "POSTCODE", "CITY", "STATE", "CUSTADDRESS", "CUSTCOMPLAINTREMARK", "NEXTSVCMILEAGE", "NEXTSVCDATE", "OUTLETID", "CREATEDDATETIME", "WTYSTATUS", "OUTLETTYPE", "TAXMETHOD", "ROINVTYPECODE", "DISCLABOUR", "DISCPARTS", "DISCACC", "DISCLUB", "DISCLUBSUB", "DISCMTL", "RDATE", "COSTLABOUR", "COSTPARTS", "COSTPARTSWTY", "COSTACC", "COSTACCWTY", "COSTLUB", "COSTLUBSUB", "COSTLUBWTY", "COSTLUBSUBWTY", "SUBLETCOST", "SUBLETCOSTWTY", "COSTMAT", "COSTMATWTY", "MECHSTAFFID", "MECHNAME") AS 
  SELECT
'RO'                                                        AS INVTYPE, -- Transaction Type
ROINV.ROINVNO                                               AS INVNO,   -- Invoice No
ROMSTR.RONO                                                 AS RNO,
TO_CHAR(ROINV.ROINVDATE, 'DD/MM/YYYY')                      AS INVDATE, -- Invoice Date
OT.OUTLETCODE                                               AS BRANCH,  -- Branch
TO_CHAR(VCP.REGDATE,'DD/MM/YYYY')                           AS REGDATE, -- Reg Date
((((86400*(TRUNC(ROMSTR.RODATE)-VCP.REGDATE))/60)/60)/24) AS AGINGDAYS,
-- Aging Days
ROMSTR.REGNO,        -- Vehicle #
(SELECT MVARIANTCODE FROM T_VEH_MVARIANT MV
WHERE VCP.DSSMVARIANTCODE = MV.MVARIANTCODE
AND MV.RECSTATUS = 1) AS MVARIANTCODE, -- Model Code
(SELECT MVARIANTDESC FROM T_VEH_MVARIANT MV
WHERE VCP.DSSMVARIANTCODE = MV.MVARIANTCODE
AND MV.RECSTATUS = 1) AS MVARIANTDESC,     -- Model Desc
VCP.CHASSISNO,       -- Chassis No
VCP.ENGINENO,        -- Engineno
(
SELECT
    CODEDTL.DETAILDESCRIPTION
FROM
    T_PI_CODE_DTL CODEDTL
WHERE
    CODEDTL.DETAILVALUE = ROMSTR.ROTYPE
)                        AS REPAIRTYPE,
(SELECT INSCOMPNAME FROM T_VI_INSCOMP_MSTR INS WHERE  INS.INSCOMPID = ROMSTR.INSCOMPID
AND (INS.EFFENDDATE >= SYSDATE OR INS.EFFENDDATE IS NULL)) AS INSCOMP,
NVL(
(
SELECT
    NVL(SUM(NVL(ROOP.TTLAMTWOGSTNDISC,0)),0)
FROM
    T_SVC_RO_INV_OP ROOP
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    ROOP.ROINVID = INVM.ROINVID
WHERE
    ROOP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS')
AND INVM.ROID          = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0) AS REVLBRTL, --Rev Labour Retail
NVL(
(
SELECT
    NVL(SUM(NVL(ROOP.TTLAMTWOGSTNDISC,0)),0)
FROM
    T_SVC_RO_INV_OP ROOP
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    ROOP.ROINVID = INVM.ROINVID
WHERE
    ROOP.CHARGETYPECODE IN ('SO-INT')
AND INVM.ROID          = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0) AS REVLBINT, --Rev Labour Internal
NVL(
(
SELECT
    NVL(SUM(NVL(ROOP.TTLAMTWOGSTNDISC,0)),0)
FROM
    T_SVC_RO_INV_OP ROOP
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    ROOP.ROINVID = INVM.ROINVID
WHERE
    ROOP.CHARGETYPECODE ='SO-F'
AND INVM.ROID         = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0) AS REVFS, --Rev Free Service
NVL(
(
SELECT
    NVL(SUM(NVL(ROOP.FINALPRICEWOGST,0)),0)
FROM
    T_SVC_RO_INV_OP ROOP
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    ROOP.ROINVID = INVM.ROINVID
WHERE
    ROOP.CHARGETYPECODE ='SO-W'
AND INVM.ROID         = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)AS REVWARLB,--Rev Warranty Labour
NVL(
(
SELECT
    COALESCE(SUM(CASE WHEN SROP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE SROP.TTLAMTWOGSTNDISC END),0) 
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_PART SROP
ON
    PPM.PARTID = SROP.PARTID
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    SROP.ROINVID = INVM.ROINVID
WHERE
    PPTM.PARTTYPECODE      = 'PARTS'
AND SROP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS')
AND INVM.ROID            = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)AS REVPARTSRTL, --Rev Parts Retail
NVL(
(
SELECT
    COALESCE(SUM(CASE WHEN SROP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE SROP.TTLAMTWOGSTNDISC END),0) 
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_PART SROP
ON
    PPM.PARTID = SROP.PARTID
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    SROP.ROINVID = INVM.ROINVID
WHERE
    PPTM.PARTTYPECODE      = 'PARTS'
AND SROP.CHARGETYPECODE IN ('SO-INT')
AND INVM.ROID            = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)AS REVPARTSINT, --Rev Parts Internal
NVL(
(
SELECT
    COALESCE(SUM(CASE WHEN SROP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE SROP.TTLAMTWOGSTNDISC END),0) 
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_PART SROP
ON
    PPM.PARTID = SROP.PARTID
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    SROP.ROINVID = INVM.ROINVID
WHERE
    PPTM.PARTTYPECODE      = 'PARTS'
AND SROP.CHARGETYPECODE IN ('SO-W')
AND INVM.ROID            = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)AS REVPARTSWTY, --Rev Parts Warranty
NVL(
(
SELECT
    COALESCE(SUM(CASE WHEN SROP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE SROP.TTLAMTWOGSTNDISC END),0) 
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_PART SROP
ON
    PPM.PARTID = SROP.PARTID
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    SROP.ROINVID = INVM.ROINVID
WHERE
    PPTM.PARTTYPECODE      = 'ACCESSORIES'
AND SROP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS')
AND INVM.ROID            = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)AS REVACCRTL,--Rev Accessories Retail
NVL(
(
SELECT
    COALESCE(SUM(CASE WHEN SROP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE SROP.TTLAMTWOGSTNDISC END),0) 
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_PART SROP
ON
    PPM.PARTID = SROP.PARTID
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    SROP.ROINVID = INVM.ROINVID
WHERE
    PPTM.PARTTYPECODE      = 'ACCESSORIES'
AND SROP.CHARGETYPECODE IN ('SO-INT')
AND INVM.ROID            = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)AS REVACCINT,--Rev Accessories Internal
NVL(
(
SELECT
    COALESCE(SUM(CASE WHEN SROP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE SROP.TTLAMTWOGSTNDISC END),0) 
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_PART SROP
ON
    PPM.PARTID = SROP.PARTID
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    SROP.ROINVID = INVM.ROINVID
WHERE
    PPTM.PARTTYPECODE      = 'ACCESSORIES'
AND SROP.CHARGETYPECODE IN ('SO-W')
AND INVM.ROID            = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)AS REVACCWTY,--Rev Accessories Warranty
NVL(
(
SELECT
    COALESCE(SUM(CASE WHEN SROP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE SROP.TTLAMTWOGSTNDISC END),0) 
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_PART SROP
ON
    PPM.PARTID = SROP.PARTID
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    SROP.ROINVID = INVM.ROINVID
WHERE
    PPTM.PARTTYPECODE IN ('OIL '
    || chr(38)
    || ' LUBRICANT','LUBE SUB PRODUCT')
AND SROP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS')
AND INVM.ROID            = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)AS REVLUBRTL, --Rev Lubricants Retail
NVL(
(
SELECT
    COALESCE(SUM(CASE WHEN SROP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE SROP.TTLAMTWOGSTNDISC END),0) 
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_PART SROP
ON
    PPM.PARTID = SROP.PARTID
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    SROP.ROINVID = INVM.ROINVID
WHERE
    PPTM.PARTTYPECODE IN ('OIL '
    || chr(38)
    || ' LUBRICANT','LUBE SUB PRODUCT')
AND SROP.CHARGETYPECODE IN ('SO-INT')
AND INVM.ROID            = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)AS REVLUBINT, --Rev Lubricants Internal
NVL(
(
SELECT
    COALESCE(SUM(CASE WHEN SROP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE SROP.TTLAMTWOGSTNDISC END),0) 
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_PART SROP
ON
    PPM.PARTID = SROP.PARTID
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    SROP.ROINVID = INVM.ROINVID
WHERE
    PPTM.PARTTYPECODE IN ('OIL '
    || chr(38)
    || ' LUBRICANT','LUBE SUB PRODUCT')
AND SROP.CHARGETYPECODE IN ('SO-W')
AND INVM.ROID            = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)AS REVLUBWTY, --Rev Lubricants Warranty
NVL(
(
SELECT
    COALESCE(SUM(CASE WHEN SROP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE SROP.TTLAMTWOGSTNDISC END),0) 
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_PART SROP
ON
    PPM.PARTID = SROP.PARTID
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    SROP.ROINVID = INVM.ROINVID
WHERE
    PPTM.PARTTYPECODE      = 'MTL'
AND SROP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS')
AND INVM.ROID            = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)AS REVMATRTL, -- Rev Material Retail
NVL(
(
SELECT
    COALESCE(SUM(CASE WHEN SROP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE SROP.TTLAMTWOGSTNDISC END),0) 
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_PART SROP
ON
    PPM.PARTID = SROP.PARTID
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    SROP.ROINVID = INVM.ROINVID
WHERE
    PPTM.PARTTYPECODE      = 'MTL'
AND SROP.CHARGETYPECODE IN ('SO-INT')
AND INVM.ROID            = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)AS REVMATINT, -- Rev Material Internal
NVL(
(
SELECT
    COALESCE(SUM(CASE WHEN SROP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE SROP.TTLAMTWOGSTNDISC END),0) 
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_PART SROP
ON
    PPM.PARTID = SROP.PARTID
INNER JOIN T_SVC_RO_INV_MSTR INVM
ON
    SROP.ROINVID = INVM.ROINVID
WHERE
    PPTM.PARTTYPECODE      = 'MTL'
AND SROP.CHARGETYPECODE IN ('SO-W')
AND INVM.ROID            = ROMSTR.ROID
AND INVM.STATUS NOT IN ('C','S')
GROUP BY
    INVM.ROID
)
,0)                 AS REVMATWTY, -- Rev Material Warranty
( CASE WHEN (SELECT COALESCE(SUM(round((RIP.UNITBASEPRICE*(RIP.DISCOUNTPERC)/100*RIP.QTY),2)),0) 
FROM T_SVC_RO_MSTR SRM 
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID 
INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID 
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID =PM.PARTID 
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID 
WHERE RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') 
AND RIM.ROINVID = ROINV.ROINVID) > 0 
OR (SELECT COALESCE(SUM(RIP.DISCOUNTRM),0) 
FROM T_SVC_RO_MSTR SRM 
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID 
INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID 
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID =PM.PARTID 
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID 
WHERE RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') 
AND RIM.ROINVID = ROINV.ROINVID) > 0 
OR (SELECT COALESCE(SUM(ROOP.DISCOUNTBPRICE*ROOP.DISCOUNTPERC/100),0) 
FROM T_SVC_RO_INV_MSTR RIM 
INNER JOIN T_SVC_RO_INV_OP ROOP ON RIM.ROINVID = ROOP.ROINVID 
WHERE RIM.ROINVID = ROINV.ROINVID 
AND RIM.ROINVTYPECODE IN ('SOFLEKSIB','SOINT')) > 0 
THEN 0 ELSE NVL(ROINV.OTHERDISC,0) END 
)AS CAMPDISC ,
NVL(ROINV.DISCOUNT, 0) AS ADDDISCOUNT, -- Additional Discount
( SELECT COALESCE(SUM(ROIO.DISCOUNT),0)  
FROM T_SVC_RO_INV_OP ROIO 
WHERE ROIO.ROINVID = ROINV.ROINVID 
AND ROIO.CHARGETYPECODE IN ('SO-FLEKSIB','SO-F')  
) AS PKGOPDISCAMT 
,( SELECT COALESCE(SUM(ROIP.DISCOUNT),0)  
FROM T_SVC_RO_INV_PART ROIP 
WHERE ROIP.ROINVID = ROINV.ROINVID 
AND ROIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-F')  
) AS PKGPARTDISCAMT,  --Package Discount
NVL(ROINV.EDISCAMT, 0) AS EDISCAMT, -- E-Discount
( SELECT NVL(RIM.INSEXCESSAMT,0) + NVL(RIM.INSBETTERMENTAMT,0)
 FROM T_SVC_RO_INV_MSTR RIM
 WHERE RIM.ROINVID = ROINV.ROINVID 
 AND RIM.ROINVTYPECODE IN ('SOFLEKSIB')) AS INSEXCESSAMT,
--Excess Amount
0 AS GSTEXCESS
,                                            -- GST For Excess
NVL(ROINV.GSTTAXAMOUNT, 0) AS GSTAMOUNT, -- GST Amount
NVL(
(
SELECT
    SUM(NVL((
        CASE
        WHEN PI.TOPAYAMT > PD.PMTAMT
        THEN PD.PMTAMT
        ELSE PI.TOPAYAMT
        END),0)) AS VOUCHER
FROM
    T_SVC_PMTRECEIPT_DTL_INFO PI
INNER JOIN T_SVC_PMTRECEIPT_DTL PD
ON
    PD.PRID          = PI.PRID
AND PD.PAYMODECODE = 'VOUCHER'
WHERE
    PI.RECSTATUS         = 1
AND PI.DOCNO           = ROINV.ROINVNO
AND PI.DOCFLAG         = 'APPLY'
AND PI.DOCTYPE         = 'INVOICE'
AND NVL(PI.TOPAYAMT,0) > 0
)
,0)                             AS VOUCHER,                            -- Voucher Amount
NVL(ROINV.TTLEVAMT, 0)          AS EVAMOUNT,                           -- Evoucher Amount
NVL(ROINV.TTLINVAMT, 0)         AS TTLINVAMT,                          -- Total Invoice Amount After GSt
NVL(ROINV.ROUNDINGADJAMOUNT, 0) AS ROUNDADJAMT,                        -- Rounding Adjustment
NVL(ROINV.TOTALAMOUNT,0)        AS TOTALAMTPAYABLE,                    -- Total Amount Payable
NVL(ROMSTR.CURRMILEAGE, 0)      AS CURRMILEAGE,                        -- Current Mileage
CP.CUSTNAME,                                                           -- Customer Name
NVL(CP.PDPA, '-') AS PDPA,                                             -- PDPA Status
CP.CUSTID,                                                             -- Customer IC
CP.MOBILENO,                                                           -- Cust Mobile No
CP.HSETELNO,                                                           -- House Tel No
CP.OFFICETELNO,                                                        -- Office Tel No
ROMSTR.SENDERNAME,                                                     -- Sender Name
ROMSTR.SENDERCONTACTNO,                                                -- Sender Contact No
ROMSTR.SVCADVISORID,                                                   -- SA ID
SA.SVCADVISORNAME,                                                     -- SA Name
SCT.CUST_TYPE_DESC,                                                    -- Customer Type
DECODE(CP.RACE,1,'Malay',2,'Chinese',3,'Indian','Others') AS CUSTRACE, --
-- Race
CP.GENDER,   -- Gender
CP.POSTCODE, -- Postcode
CP.CITY,     -- Town
(
SELECT
    STATE.STATEDESC
FROM
    T_STATE_MSTR STATE
WHERE
    STATE.STATEID = CP.STATEID
) AS STATE, -- State
CP.ADDRESS1
||' '
|| CP.ADDRESS2
||' '
|| CP.ADDRESS3
||' '
|| CP.ADDRESS4 AS CUSTADDRESS,                         -- Cust Address
ROMSTR.CUSTCOMPLAINTREMARK,                            -- Cust Own Words
VCP.NEXTSVCMILEAGE,                                    -- Next Mileage
TO_CHAR(VCP.NEXTSVCDATE, 'DD/MM/YYYY') AS NEXTSVCDATE, -- Next Service Date
OT.OUTLETID,
TO_CHAR(ROMSTR.CREATEDDATETIME, 'DD/MM/YYYY') AS CREATEDDATE,
NVL(ROMSTR.WTYSTATUS,'-') AS WTYSTATUS,
OT.OUTLETTYPE,
ROINV.TAXMETHOD AS TAXMETHOD,
DECODE(ROINVTYPECODE,'SOFLEKSIB','1','SOINT','2','SOINS','3','SOW','4' ,'SOF','5') AS ROINVTYPECODE,
( SELECT COALESCE(SUM(ROOP.DISCOUNTBPRICE*ROOP.DISCOUNTPERC/100),0)  
FROM T_SVC_RO_INV_MSTR RIM 
INNER JOIN T_SVC_RO_INV_OP ROOP ON RIM.ROINVID = ROOP.ROINVID 
WHERE RIM.ROINVID = ROINV.ROINVID 
AND RIM.ROINVTYPECODE IN ('SOFLEKSIB','SOINT') 
) AS DISCLABOUR, 
( SELECT CASE WHEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) > 0 
THEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) 
ELSE COALESCE(ROUND(SUM(RIP.DISCOUNTRM),2),0) END 
FROM T_SVC_RO_MSTR SRM 
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID 
INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID 
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID 
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID 
WHERE UPPER(PTM.PARTTYPECODE) = 'PARTS' 
AND RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') 
AND RIM.ROINVID = ROINV.ROINVID 
) AS DISCPARTS, 
( SELECT CASE WHEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) > 0 
THEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) 
ELSE COALESCE(ROUND(SUM(RIP.DISCOUNTRM),2),0) END 
FROM T_SVC_RO_MSTR SRM 
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID 
INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID 
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID 
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID 
WHERE UPPER(PTM.PARTTYPECODE) IN ('ACCESSORIES','CONSUMABLES') 
AND RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') 
AND RIM.ROINVID = ROINV.ROINVID 
) AS DISCACC ,
( SELECT CASE WHEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) > 0 
THEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) 
ELSE COALESCE(ROUND(SUM(RIP.DISCOUNTRM),2),0) END 
FROM T_SVC_RO_MSTR SRM 
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID 
INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID 
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID =PM.PARTID 
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID 
WHERE UPPER(PTM.PARTTYPECODE) IN ('OIL '|| chr(38) || ' LUBRICANT') 
AND RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') 
AND RIM.ROINVID = ROINV.ROINVID) AS DISCLUB, 
( SELECT CASE WHEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) > 0 
THEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) 
ELSE COALESCE(ROUND(SUM(RIP.DISCOUNTRM),2),0) END 
FROM T_SVC_RO_MSTR SRM 
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID 
INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID 
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID =PM.PARTID 
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID 
WHERE UPPER(PTM.PARTTYPECODE) IN ('LUBE SUB PRODUCT') 
AND RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') 
AND RIM.ROINVID = ROINV.ROINVID) AS DISCLUBSUB,
( SELECT CASE WHEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) > 0 
THEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) 
ELSE COALESCE(ROUND(SUM(RIP.DISCOUNTRM),2),0) END 
FROM T_SVC_RO_MSTR SRM 
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID 
INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID 
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID 
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID 
WHERE UPPER(PTM.PARTTYPECODE) = 'MTL' 
AND RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') 
AND RIM.ROINVID = ROINV.ROINVID 
) AS DISCMTL ,
TO_CHAR(ROMSTR.RODATE, 'DD/MM/YYYY') AS RDATE,
( SELECT COALESCE(SUM(NVL(RIO.FRU * RIO.COST,0)),0) 
FROM T_SVC_RO_MSTR SRM
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID
INNER JOIN T_SVC_RO_INV_OP RIO ON RIM.ROINVID = RIO.ROINVID
INNER JOIN T_OUTLET_MSTR OM ON SRM.OUTLETID = OM.OUTLETID
INNER JOIN T_REGION_MSTR RM ON OM.REGIONID = RM.REGIONID
WHERE RIM.ROINVID = ROINV.ROINVID ) AS COSTLABOUR,
( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0)
FROM T_SVC_RO_INV_PART RIP
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID
WHERE UPPER(PTM.PARTTYPECODE) = 'PARTS'
AND RIP.CHARGETYPECODE != 'SO-W'
AND RIM.ROINVID = ROINV.ROINVID
) AS COSTPARTS,
( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0)
FROM T_SVC_RO_INV_PART RIP
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID
WHERE UPPER(PTM.PARTTYPECODE) = 'PARTS'
AND RIP.CHARGETYPECODE = 'SO-W'
AND RIM.ROINVID = ROINV.ROINVID
) AS COSTPARTSWTY,
( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0)
FROM T_SVC_RO_INV_PART RIP
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID =PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID
WHERE UPPER(PTM.PARTTYPECODE) = 'ACCESSORIES'
AND RIP.CHARGETYPECODE != 'SO-W'
AND RIM.ROINVID = ROINV.ROINVID
) AS COSTACC,
( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0)
FROM T_SVC_RO_INV_PART RIP
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID =PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID
WHERE UPPER(PTM.PARTTYPECODE) = 'ACCESSORIES'
AND RIP.CHARGETYPECODE = 'SO-W'
AND RIM.ROINVID = ROINV.ROINVID
) AS COSTACCWTY,
( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0)
FROM T_SVC_RO_INV_PART RIP
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID
WHERE UPPER(PTM.PARTTYPECODE) IN ('OIL '|| chr(38) || ' LUBRICANT')
AND RIP.CHARGETYPECODE != 'SO-W'
AND RIM.ROINVID = ROINV.ROINVID
) AS COSTLUB,
( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0)
FROM T_SVC_RO_INV_PART RIP
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID
WHERE UPPER(PTM.PARTTYPECODE) IN ( 'LUBE SUB PRODUCT')
AND RIP.CHARGETYPECODE != 'SO-W'
AND RIM.ROINVID = ROINV.ROINVID
) AS COSTLUBSUB,
( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0)
FROM T_SVC_RO_INV_PART RIP
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID
WHERE UPPER(PTM.PARTTYPECODE) IN ('OIL '|| chr(38) || ' LUBRICANT')
AND RIP.CHARGETYPECODE = 'SO-W'
AND RIM.ROINVID = ROINV.ROINVID
) AS COSTLUBWTY,
( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0)
FROM T_SVC_RO_INV_PART RIP
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID
WHERE UPPER(PTM.PARTTYPECODE) IN ( 'LUBE SUB PRODUCT')
AND RIP.CHARGETYPECODE = 'SO-W'
AND RIM.ROINVID = ROINV.ROINVID
) AS COSTLUBSUBWTY,
( nvl((SELECT SUM(nvl(sj.TOTALAMTWOGST,0)) AS TotalSubeletJobCost 
FROM T_SVC_SUBLET_WO_MSTR sw
INNER JOIN t_svc_sublet_wo_op sj ON sw.subletwoid = sj.subletwoid
INNER JOIN T_SVC_RO_INV_OP rop ON sj.roopid = rop.roopid
WHERE sw.status != 'C'
AND REPLACE(rop.chargetypecode,'-','') != 'SO-W'
AND rop.ROINVID = ROINV.ROINVID)
,0)
+ 
nvl(( SELECT SUM(nvl(sp.TOTALAMTWOGST,0)) AS TotalSubeletPartCost 
FROM T_SVC_SUBLET_WO_MSTR sw
INNER JOIN t_svc_sublet_wo_part sp ON sw.subletwoid = sp.subletwoid
INNER JOIN T_SVC_RO_INV_PART ropp ON sp.rooppartid = ropp.rooppartid
WHERE sw.status != 'C'
AND REPLACE(ropp.chargetypecode,'-','') != 'SO-W'
AND ropp.ROINVID = ROINV.ROINVID)
,0) 
) AS SUBLETCOST,
( nvl((SELECT SUM(nvl(sj.TOTALAMTWOGST,0)) AS TotalSubeletJobCost 
FROM T_SVC_SUBLET_WO_MSTR sw
INNER JOIN t_svc_sublet_wo_op sj ON sw.subletwoid = sj.subletwoid
INNER JOIN t_svc_ro_op rop ON sj.roopid = rop.roopid
WHERE sw.status != 'C'
AND rop.subletcode is not null
AND rop.recstatus = 1
AND rop.status != 'C'
AND REPLACE(rop.chargetypecode,'-','') = 'SO-W'
AND rop.roid = ROMSTR.ROID)
,0)
+ 
nvl(( SELECT SUM(nvl(sp.TOTALAMTWOGST,0)) AS TotalSubeletPartCost 
FROM T_SVC_SUBLET_WO_MSTR sw
INNER JOIN t_svc_sublet_wo_part sp ON sw.subletwoid = sp.subletwoid
INNER JOIN t_svc_ro_op_part ropp ON sp.rooppartid = ropp.rooppartid
WHERE sw.status != 'C'
AND ropp.recstatus = 1
AND ropp.status != 'C'
AND REPLACE(ropp.chargetypecode,'-','') = 'SO-W'
AND ropp.roid = ROMSTR.ROID)
,0) 
) AS SUBLETCOSTWTY,
( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0)
FROM T_SVC_RO_INV_PART RIP
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID
WHERE UPPER(PTM.PARTTYPECODE) = 'MTL'
AND RIP.CHARGETYPECODE != 'SO-W'
AND RIM.ROINVID = ROINV.ROINVID
) AS COSTMAT,
( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0)
FROM T_SVC_RO_INV_PART RIP
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID
WHERE UPPER(PTM.PARTTYPECODE) = 'MTL'
AND RIP.CHARGETYPECODE = 'SO-W'
AND RIM.ROINVID = ROINV.ROINVID
) AS COSTMATWTY,
(SELECT LISTAGG(STAFFID, ' | ')
Within Group (Order By MECHNO Desc) 
From T_Svc_Mech_Mstr Mm
Inner Join T_Svc_Taskassignment Ta On Mm.Mechid = Ta.Mechanicid
Where  TA.ROID = ROMSTR.ROID
) MECHSTAFFID,
(SELECT LISTAGG(MECHNAME, ' | ')
Within Group (Order By MECHNO Desc) 
From T_Svc_Mech_Mstr Mm
Inner Join T_Svc_Taskassignment Ta On Mm.Mechid = Ta.Mechanicid
Where  TA.ROID = ROMSTR.ROID
) MECHNAME
FROM
T_SVC_RO_MSTR ROMSTR
INNER JOIN T_SVC_RO_INV_MSTR ROINV
ON
ROMSTR.ROID = ROINV.ROID
INNER JOIN T_OUTLET_MSTR OT
ON
ROMSTR.OUTLETID = OT.OUTLETID
INNER JOIN T_VEHCUSTPROFILE VCP
ON
VCP.VCPROFILEID = ROMSTR.VCPROFILEID
INNER JOIN T_CUSTPROFILE CP
ON
ROMSTR.CUSTPROFILEID = CP.CUSTPROFILEID
INNER JOIN T_SVC_ADVISOR_MSTR SA
ON
SA.STAFFID    = ROMSTR.SVCADVISORID
AND OT.OUTLETID = SA.OUTLETID
LEFT JOIN SVC_CUSTOMER_TYPES SCT
ON
CP.CUSTGRP = SCT.CUST_TYPE_CODE

WHERE ROMSTR.STATUS IN ('I','P') AND ROINV.STATUS NOT IN ('C','S')
UNION
SELECT
'PRO'                                                      AS INVTYPE,   -- Transaction Type
PROINV.PROINVNO                                            AS INVNO,     -- Invoice No
PROMSTR.PRONO                                           AS RNO,
TO_CHAR(PROINV.INVDATE, 'DD/MM/YYYY')                      AS INVDATE,   -- Invoice Date
OT.OUTLETCODE                                              AS BRANCH,    -- Branch
TO_CHAR(VCP.REGDATE,'DD/MM/YYYY')                          AS REGDATE,   -- Reg Date
((((86400*(TRUNC(PROMSTR.PRODATE)-VCP.REGDATE))/60)/60)/24) AS AGINGDAYS, --
-- Aging Days
PROMSTR.REGNO,     -- Vehicle #
(SELECT MVARIANTCODE FROM T_VEH_MVARIANT MV
WHERE VCP.DSSMVARIANTCODE = MV.MVARIANTCODE
AND MV.RECSTATUS = 1) AS MVARIANTCODE, -- Model Code
(SELECT MVARIANTDESC FROM T_VEH_MVARIANT MV
WHERE VCP.DSSMVARIANTCODE = MV.MVARIANTCODE
AND MV.RECSTATUS = 1) AS MVARIANTDESC,     -- Model Desc
VCP.CHASSISNO,     -- Chassis No
VCP.ENGINENO,      -- Engine No
'-' AS REPAIRTYPE, -- Repair Type
'-' AS INSCOMP,    -- Insurance
0   AS REVLBRTL,   -- Rev Labour Retail
0   AS REVLBINT,   -- Rev Labour Internal
0   AS REVFS,      -- Rev Free Service
0   AS REVWARLB,   -- Rev Labour Warranty
NVL(
(
SELECT
    SUM(PAYDTL.TOTALBASEPRICE)
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_PI_PRO_INVPAY_DTL PAYDTL
ON
    PAYDTL.PARTID = PPM.PARTID
WHERE
    PAYDTL.PROINVID     = PROINV.PROINVID
AND PPTM.PARTTYPECODE = 'PARTS'
)
,0) AS REVPARTSRTL, -- Rev Parts Retail
0   AS REVPARTSINT, -- Rev Parts Internal
0   AS REVPARTSWTY, -- Rev Parts Warranty
NVL(
(
SELECT
    SUM(PAYDTL.TOTALBASEPRICE)
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_PI_PRO_INVPAY_DTL PAYDTL
ON
    PAYDTL.PARTID = PPM.PARTID
WHERE
    PAYDTL.PROINVID     = PROINV.PROINVID
AND PPTM.PARTTYPECODE = 'ACCESSORIES'
)
,0) AS REVACCRTL, -- Rev Accessories Retail
0   AS REVACCINT, -- Rev Accessories Internal
0   AS REVACCWTY, -- Rev Accessories Warranty
NVL(
(
SELECT
    SUM(PAYDTL.TOTALBASEPRICE)
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_PI_PRO_INVPAY_DTL PAYDTL
ON
    PAYDTL.PARTID = PPM.PARTID
WHERE
    PAYDTL.PROINVID      = PROINV.PROINVID
AND PPTM.PARTTYPECODE IN ('OIL '
    || chr(38)
    || ' LUBRICANT','LUBE SUB PRODUCT')
)
,0) AS REVLUBRTL, -- Rev Lubricants Retail
0   AS REVLUBINT, -- Rev Lubricants Internal
0   AS REVLUBWTY, -- Rev Lubricants Warranty
NVL(
(
SELECT
    SUM(PAYDTL.TOTALBASEPRICE)
FROM
    T_PI_PARTTYPE_MSTR PPTM
INNER JOIN T_PI_PART_MSTR PPM
ON
    PPM.PARTTYPEID = PPTM.PARTTYPEID
INNER JOIN T_PI_PRO_INVPAY_DTL PAYDTL
ON
    PAYDTL.PARTID = PPM.PARTID
WHERE
    PAYDTL.PROINVID     = PROINV.PROINVID
AND PPTM.PARTTYPECODE = 'MTL'
)
,0)                            AS REVMATRTL,    -- Rev Material Retail
0                              AS REVMATINT,    -- Rev Material Internal
0                              AS REVMATWTY,    -- Rev Material Warranty
(SELECT COALESCE(PIPRO.OTHERDISC,0) AS OTHERALLDISC
FROM T_PI_PRO_MSTR PIPRO
WHERE PIPRO.PROID = PROMSTR.PROID) AS CAMPDISC,      -- Campaign Discount
NVL(PROINV.PAYMENTDISCAMT,0)   AS ADDDISCOUNT,  -- Additional Discount
0                              AS PKGOPDISCAMT,
0                              AS PKGPARTDISCAMT,      -- Package Discount
NVL(PROINV.EDISCAMT,0)         AS EDISCAMT,     -- E-Discount
0                              AS INSEXCESSAMT, -- Excess Amount
0                              AS GSTEXCESS,    -- GST For Excess
NVL(PROINV.GSTBEFOREDISCAMT,0) AS GSTAMOUNT,    -- GST Amount
NVL(
(
SELECT
    SUM(NVL((
        CASE
        WHEN PI.TOPAYAMT > PD.PMTAMT
        THEN PD.PMTAMT
        ELSE PI.TOPAYAMT
        END),0)) AS VOUCHER
FROM
    T_SVC_PMTRECEIPT_DTL_INFO PI
INNER JOIN T_SVC_PMTRECEIPT_DTL PD
ON
    PD.PRID          = PI.PRID
AND PD.PAYMODECODE = 'VOUCHER'
WHERE
    PI.RECSTATUS         = 1
AND PI.DOCNO           = PROINV.PROINVNO
AND PI.DOCFLAG         = 'APPLY'
AND PI.DOCTYPE         = 'INVOICE'
AND NVL(PI.TOPAYAMT,0) > 0
)
,0)                        AS VOUCHER,         -- Voucher Amount
NVL(PROINV.TTLEVAMT, 0)    AS EVAMOUNT,        -- Evoucher Amount
NVL(PROINV.TTLINVAMT, 0)   AS TTLINVAMT,       -- Total Invoice Amount After GST
NVL(PROINV.ROUNDINGAMT, 0) AS ROUNDADJAMT,     -- Rounding Adjustment
NVL(PROINV.FINALINVAMT, 0) AS TOTALAMTPAYABLE, -- Total Amount Payable
NVL(VCP.CURRENTMILEAGE, 0) AS CURRMILEAGE,     -- Current Mileage
CP.CUSTNAME,                                   -- Customer Name
NVL(CP.PDPA, '-') AS PDPA,                     -- PDPA Status
CP.CUSTID,                                     -- Customer IC
CP.MOBILENO,                                   -- Cust Mobile No
CP.HSETELNO,                                   -- House Tel No
CP.OFFICETELNO,                                -- Office Tel No
'-'               AS SENDERNAME,                             -- Sender Name
'-'               AS SENDERCONTACTNO,                        -- Sender Contact No
PROMSTR.CREATEDBY AS SVCADVISORID,                           -- SA ID
(
SELECT
    USERMSTR.USERNAME
FROM
    T_USER_MSTR USERMSTR
WHERE
    USERMSTR.USERID = PROMSTR.CREATEDBY
) AS SVCADVISORNAME,                                                   -- SA Name
SCT.CUST_TYPE_DESC,                                                    -- Customer Type
DECODE(CP.RACE,1,'Malay',2,'Chinese',3,'Indian','Others') AS CUSTRACE, --
-- Race
CP.GENDER,   -- Gender
CP.POSTCODE, -- Postcode
CP.CITY,     -- Town
(
SELECT
    STATE.STATEDESC
FROM
    T_STATE_MSTR STATE
WHERE
    STATE.STATEID = CP.STATEID
) AS STATE, -- State
CP.ADDRESS1
||' '
|| CP.ADDRESS2
||' '
|| CP.ADDRESS3
||' '
|| CP.ADDRESS4 AS CUSTADDRESS,                         -- Cust Address
'-'            AS CUSTCOMPLAINTREMARK,                 -- Cust Own Words
VCP.NEXTSVCMILEAGE,                                    -- Next Mileage
TO_CHAR(VCP.NEXTSVCDATE, 'DD/MM/YYYY') AS NEXTSVCDATE, -- Next Service Date
OT.OUTLETID,
TO_CHAR(PROMSTR.CREATEDDATETIME, 'DD/MM/YYYY') AS CREATEDDATE,
'-'                                            AS WTYSTATUS,
OT.OUTLETTYPE,
PROINV.TAXMETHOD AS TAXMETHOD,
'1' AS ROINVTYPECODE,
0 AS DISCLABOUR ,

NVL((SELECT
coalesce(SUM(round((ipd.unitbaseprice * ipd.discperc / 100), 2) * ipd.invqty), 0)
FROM
t_pi_pro_invpay_mstr ipm
INNER JOIN t_pi_pro_invpay_dtl ipd ON ipm.proinvid = ipd.proinvid
INNER JOIN t_pi_part_mstr pm ON ipd.partid = pm.partid
INNER JOIN t_pi_parttype_mstr ptm ON pm.parttypeid = ptm.parttypeid
WHERE
upper(ptm.parttypecode) = 'PARTS'
AND ipm.proinvid = PROINV.proinvid),0) AS DISCPARTS , 
NVL((SELECT
coalesce(SUM(round((ipd.unitbaseprice * ipd.discperc / 100), 2) * ipd.invqty), 0)
FROM
t_pi_pro_invpay_mstr ipm
INNER JOIN t_pi_pro_invpay_dtl ipd ON ipm.proinvid = ipd.proinvid
INNER JOIN t_pi_part_mstr pm ON ipd.partid = pm.partid
INNER JOIN t_pi_parttype_mstr ptm ON pm.parttypeid = ptm.parttypeid
WHERE
upper(ptm.parttypecode) = 'ACCESSORIES'
AND ipm.proinvid = PROINV.proinvid),0) AS DISCACC , 
NVL((SELECT
coalesce(SUM(round((ipd.unitbaseprice * ipd.discperc / 100), 2) * ipd.invqty), 0)
FROM
t_pi_pro_invpay_mstr ipm
INNER JOIN t_pi_pro_invpay_dtl ipd ON ipm.proinvid = ipd.proinvid
INNER JOIN t_pi_part_mstr pm ON ipd.partid = pm.partid
INNER JOIN t_pi_parttype_mstr ptm ON pm.parttypeid = ptm.parttypeid
WHERE
upper(ptm.parttypecode) = 'OIL '|| chr(38) || ' LUBRICANT'
AND ipm.proinvid = PROINV.proinvid),0) AS DISCLUB , 
NVL((SELECT
coalesce(SUM(round((ipd.unitbaseprice * ipd.discperc / 100), 2) * ipd.invqty), 0)
FROM
t_pi_pro_invpay_mstr ipm
INNER JOIN t_pi_pro_invpay_dtl ipd ON ipm.proinvid = ipd.proinvid
INNER JOIN t_pi_part_mstr pm ON ipd.partid = pm.partid
INNER JOIN t_pi_parttype_mstr ptm ON pm.parttypeid = ptm.parttypeid
WHERE
upper(ptm.parttypecode) = 'LUBE SUB PRODUCT'
AND ipm.proinvid = PROINV.proinvid),0) AS DISCLUBSUB , 
NVL((SELECT
coalesce(SUM(round((ipd.unitbaseprice * ipd.discperc / 100), 2) * ipd.invqty), 0)
FROM
t_pi_pro_invpay_mstr ipm
INNER JOIN t_pi_pro_invpay_dtl ipd ON ipm.proinvid = ipd.proinvid
INNER JOIN t_pi_part_mstr pm ON ipd.partid = pm.partid
INNER JOIN t_pi_parttype_mstr ptm ON pm.parttypeid = ptm.parttypeid
WHERE
upper(ptm.parttypecode) = 'MTL'
AND ipm.proinvid = PROINV.proinvid),0) AS DISCMTL , 
TO_CHAR(PROMSTR.PRODATE, 'DD/MM/YYYY') AS RDATE,
0 AS COSTLABOUR,
(SELECT NVL(SUM(COALESCE(PID.UNITAVGCOST,0)*PID.INVQTY),0)
FROM T_PI_PRO_DTL PD
INNER JOIN T_PI_PRO_INVPAY_DTL PID ON PID.PRODTLID = PD.PRODTLID
INNER JOIN T_PI_PART_MSTR PM ON PID.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_PI_PRO_INVPAY_MSTR PIM ON PIM.PROINVID = PID.PROINVID
WHERE UPPER(PTM.PARTTYPECODE) = 'PARTS'
AND PIM.STATUS != 'C'
AND PIM.PROINVID = PROINV.PROINVID
) AS COSTPARTS,
0 AS COSTPARTSWTY,
(SELECT NVL(SUM(COALESCE(PID.UNITAVGCOST,0)*PID.INVQTY),0)
FROM T_PI_PRO_DTL PD
INNER JOIN T_PI_PRO_INVPAY_DTL PID ON PID.PRODTLID = PD.PRODTLID
INNER JOIN T_PI_PART_MSTR PM ON PID.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_PI_PRO_INVPAY_MSTR PIM ON PIM.PROINVID = PID.PROINVID
WHERE UPPER(PTM.PARTTYPECODE) = 'ACCESSORIES'
AND PIM.STATUS != 'C'
AND PIM.PROINVID = PROINV.PROINVID
) AS COSTACC,
0 AS COSTACCWTY,
(SELECT NVL(SUM(COALESCE(PID.UNITAVGCOST,0)*PID.INVQTY),0)
FROM T_PI_PRO_DTL PD
INNER JOIN T_PI_PRO_INVPAY_DTL PID ON PID.PRODTLID = PD.PRODTLID
INNER JOIN T_PI_PART_MSTR PM ON PID.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_PI_PRO_INVPAY_MSTR PIM ON PIM.PROINVID = PID.PROINVID
WHERE UPPER(PTM.PARTTYPECODE) IN ('OIL '|| chr(38) || ' LUBRICANT')
AND PIM.STATUS != 'C'
AND PIM.PROINVID = PROINV.PROINVID
) AS COSTLUB,
(SELECT NVL(SUM(COALESCE(PID.UNITAVGCOST,0)*PID.INVQTY),0)
FROM T_PI_PRO_DTL PD
INNER JOIN T_PI_PRO_INVPAY_DTL PID ON PID.PRODTLID = PD.PRODTLID
INNER JOIN T_PI_PART_MSTR PM ON PID.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_PI_PRO_INVPAY_MSTR PIM ON PIM.PROINVID = PID.PROINVID
WHERE UPPER(PTM.PARTTYPECODE) IN ( 'LUBE SUB PRODUCT')
AND PIM.STATUS != 'C'
AND PIM.PROINVID = PROINV.PROINVID
) AS COSTLUBSUB,
0 AS COSTLUBWTY,
0 AS COSTLUBSUBWTY,
0 AS SUBLETCOST,
0 AS SUBLETCOSTWTY,
(SELECT NVL(SUM(COALESCE(PID.UNITAVGCOST,0)*PID.INVQTY),0)
FROM T_PI_PRO_DTL PD
INNER JOIN T_PI_PRO_INVPAY_DTL PID ON PID.PRODTLID = PD.PRODTLID
INNER JOIN T_PI_PART_MSTR PM ON PID.PARTID = PM.PARTID
INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID
INNER JOIN T_PI_PRO_INVPAY_MSTR PIM ON PIM.PROINVID = PID.PROINVID
WHERE UPPER(PTM.PARTTYPECODE) = 'MTL'
AND PIM.STATUS != 'C'
AND PIM.PROINVID = PROINV.PROINVID
) AS COSTMAT,
0 AS COSTMATWTY,
'' AS MECHSTAFFID,
'' AS MECHNAME
FROM
T_PI_PRO_MSTR PROMSTR
INNER JOIN T_PI_PRO_INVPAY_MSTR PROINV
ON
PROMSTR.PROID = PROINV.PROID
INNER JOIN T_OUTLET_MSTR OT
ON
PROMSTR.OUTLETID = OT.OUTLETID
INNER JOIN T_CUSTPROFILE CP
ON
PROMSTR.CUSTID = CP.CUSTID
LEFT JOIN T_VEHCUSTPROFILE VCP
ON
VCP.CUSTPROFILEID = CP.CUSTPROFILEID
And VCP.Recstatus = 1
AND VCP.REGNO       = PROMSTR.REGNO
LEFT JOIN SVC_CUSTOMER_TYPES SCT
ON
CP.CUSTGRP = SCT.CUST_TYPE_CODE
Where Promstr.Status != 'C';
 