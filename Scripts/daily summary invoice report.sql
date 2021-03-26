SELECT OUTLETCODE ,RONO ,ROINVSORTNO ,ROINVNO ,ROINVTYPECODE ,CURRMILEAGE ,REGNO ,REGDATE ,APPTBKNO ,ROINVDATE ,CUSTNO ,CUSTNAME ,CUSTGRP ,MFAMILYCODE ,SVCADVISORNAME ,CUST_TYPE_DESC ,ROSTATUS ,COALESCE(SUM(LABOURNORMAL),0) AS LABOURNORMAL ,COALESCE(SUM(LABOURFS),0) AS LABOURFS ,COALESCE(SUM(LABOURWTY),0) AS
LABOURWTY ,COALESCE(SUM(LABOUREWP),0) AS LABOUREWP ,COALESCE(SUM(LABOURACC),0) AS LABOURACC ,COALESCE(SUM(PARTPARTS),0) AS PARTPARTS ,COALESCE(SUM(PARTACC),0) AS PARTACC ,COALESCE(SUM(PARTLUB),0) AS PARTLUB ,COALESCE(SUM(PARTLUBESUB),0) AS PARTLUBESUB ,COALESCE(SUM(PARTMTL),0) AS PARTMTL ,COALESCE(SUM(PARTWTY),0) AS PARTWTY ,COALESCE(SUM(PARTEWP),0) AS
PARTEWP ,COALESCE(SUM(PARTWACC),0) AS PARTWACC ,COALESCE(SUM(DISCLABOUR),0) AS DISCLABOUR ,COALESCE(SUM(DISCPARTS),0) AS DISCPARTS ,COALESCE(SUM(DISCACC),0) AS DISCACC ,COALESCE(SUM(DISCLUB),0) AS DISCLUB ,COALESCE(SUM(DISCMTL),0) AS DISCMTL ,COALESCE(SUM(DISCCASH),0) AS DISCCASH ,COALESCE(SUM(CAMPDISC),0) AS
CAMPDISC ,COALESCE(SUM(PKGOPDISCAMT+PKGPARTDISCAMT),0) AS PCKGDISC ,COALESCE(SUM(OTHERADDDISC),0) AS OTHERADDDISC ,COALESCE(SUM(TAX),0) AS TAX ,NVL(FSTAX,0) AS FSTAX ,COALESCE(SUM(WTYTAX),0) AS WTYTAX ,COALESCE(SUM(EXCESS),0) AS EXCESS ,COALESCE(SUM(ROUNDINGADJAMOUNT),0) AS ROUNDINGADJAMOUNT ,COALESCE(SUM(TOTALAMOUNT),0) AS
TOTALAMOUNT ,COALESCE(SUM(PAIDAMOUNT),0) AS PAIDAMOUNT ,COALESCE(SUM(CASHCOLL),0) AS CASHCOLL ,COALESCE(SUM(CREDITCOLL),0) AS CREDITCOLL ,COALESCE(SUM(CREDITCARDCOLL),0) AS CREDITCARDCOLL ,COALESCE(SUM(CASHDEPOSIT),0) AS CASHDEPOSIT ,COALESCE(SUM(COSTLABOUR),0) AS COSTLABOUR ,COALESCE(SUM(COSTSUBLET),0) AS COSTSUBLET ,COALESCE(SUM(COSTMAT),0) AS
COSTMAT ,COALESCE(SUM(COSTPARTS),0) AS COSTPARTS ,COALESCE(SUM(COSTACC),0) AS COSTACC ,COALESCE(SUM(COSTLUB),0) AS COSTLUB ,COALESCE(SUM(ML_SUBLETCOST),0) AS ML_SUBLETCOST ,0 AS CCDEPOSIT ,COALESCE(SUM(OPTAXAMT),0) AS OPTAXAMT ,COALESCE(SUM(PARTTAXAMT),0) AS PARTTAXAMT ,COALESCE(CASHDISCAMT,0) AS CASHDISCAMT ,COALESCE(SUBTOTAL,0) AS
SUBTOTAL ,COALESCE(GSTTAXAMOUNT,0) AS GSTTAXAMOUNT ,COALESCE(VOUCHER,0) AS VOUCHER ,COALESCE(EDISCAMT,0) AS EDISCAMT ,COALESCE(TTLINVAMT,0) AS TTLINVAMT ,COALESCE(TTLEVAMT,0) AS TTLEVAMT ,TAXMETHOD ,COALESCE(SUM(CASH),0) AS CASH ,COALESCE(SUM(CREDIT),0) AS CREDIT ,COALESCE(SUM(CREDITCARD),0) AS CREDITCARD ,COALESCE(SUM(CASHDEPOSIT1),0) AS
CASHDEPOSIT1 ,COALESCE(SUM(CREDITCARDDEPOSIT),0) AS CREDITCARDDEPOSIT ,ROTYPE ,INVSTATUS ,COALESCE(SUM(SUBLETLUBAVGCOST),0) AS SUBLETLUBAVGCOST ,COALESCE(SUM(SUBLETMATAVGCOST),0) AS SUBLETMATAVGCOST ,COALESCE(SUM(SUBLETACCAVGCOST),0) AS SUBLETACCAVGCOST ,COALESCE(SUM(SUBLETPARTAVGCOST),0) AS SUBLETPARTAVGCOST ,COALESCE(SUM(INSBETTERMENTAMT),0) AS
INSBETTERMENTAMT ,COALESCE(SUM(SBLETCOSTLABOR), 0) AS SBLETCOSTLABOR ,COALESCE(SUM(SBLETCOSTTAXLABOR), 0) AS SBLETCOSTTAXLABOR ,COALESCE(SUM(SBLETCOSTWTAXLABOR), 0) AS SBLETCOSTWTAXLABOR ,COALESCE(SUM(SBLETCOSTPART), 0) AS SBLETCOSTPART ,COALESCE(SUM(SBLETCOSTTAXPART), 0) AS SBLETCOSTTAXPART ,COALESCE(SUM(SBLETCOSTWTAXPART), 0) AS
SBLETCOSTWTAXPART FROM ( SELECT RO.OUTLETCODE ,RO.RONO ,SUBSTR(IM.ROINVNO,-8,8) AS ROINVSORTNO ,IM.ROINVNO ,IM.ROINVTYPECODE ,RO.CURRMILEAGE ,RO.REGNO ,RO.REGDATE ,RO.APPTBKNO ,IM.ROINVDATE ,CP.CUSTNO ,CP.CUSTNAME ,CP.CUSTGRP ,( SELECT VF.MFAMILYCODE FROM T_VEH_MVARIANT MV INNER JOIN T_VEH_MFAMILY VF ON MV.MFAMILYID = VF.MFAMILYID WHERE RO.MVARIANTID =
MV.MVARIANTID ) AS MFAMILYCODE ,( SELECT AM.SVCADVISORNAME FROM T_SVC_ADVISOR_MSTR AM WHERE AM.STAFFID = RO.SVCADVISORID AND AM.OUTLETID = RO.OUTLETID AND ROWNUM = 1 ) AS SVCADVISORNAME ,( SELECT CUSTGRP.CUSTGROUPDESC FROM t_custgroup_mstr CUSTGRP WHERE CP.CUSTGRP = CUSTGRP.CUSTGROUPCODE ) AS CUST_TYPE_DESC ,(CASE WHEN RO.STATUS = 'I' THEN 'INVOICED'
WHEN RO.STATUS = 'P' THEN 'PAYMENT RECEIVED' ELSE RO.STATUS END) AS ROSTATUS ,( SELECT COALESCE(SUM(RIO.TTLAMTWOGSTNDISC),0) FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_OP RIO ON RIM.ROINVID = RIO.ROINVID WHERE RIO.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INT','SO-INS') AND RIM.ROINVID = IM.ROINVID ) AS
LABOURNORMAL ,( SELECT COALESCE(SUM(RIO.TTLAMTWOGSTNDISC),0) FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_OP RIO ON RIM.ROINVID = RIO.ROINVID WHERE RIO.CHARGETYPECODE IN ('SO-F') AND RIM.ROINVID = IM.ROINVID ) AS LABOURFS ,( SELECT COALESCE(SUM(INR.FINALPRICE),0) FROM ( SELECT
RIM.ROINVID ,SRM.ROID ,ROP.ROOPID ,( SELECT RIO.FINALPRICEWOGST FROM T_SVC_RO_INV_OP RIO WHERE RIO.ROINVID = RIM.ROINVID AND RIO.ROOPID = ROP.ROOPID ) AS FINALPRICE FROM T_SVC_RO_WTYINC_MSTR WIM INNER JOIN T_SVC_RO_OP ROP ON ROP.WTYINCID = WIM.WTYINCID INNER JOIN T_SVC_RO_MSTR SRM ON ROP.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_MSTR RIM ON SRM.ROID =
RIM.ROID WHERE WIM.WTYTYPE = 'WTY' AND WIM.STATUS <> 'C' AND ROP.CHARGETYPECODE = 'SO-W' ) INR WHERE INR.ROINVID = IM.ROINVID AND INR.ROID = RO.ROID ) AS LABOURWTY ,( SELECT COALESCE(SUM(INR.FINALPRICE),0) FROM ( SELECT RIM.ROINVID ,SRM.ROID ,ROP.ROOPID ,( SELECT RIO.FINALPRICEWOGST FROM T_SVC_RO_INV_OP RIO WHERE RIO.ROINVID = RIM.ROINVID AND RIO.ROOPID =
ROP.ROOPID ) AS FINALPRICE FROM T_SVC_RO_WTYINC_MSTR WIM INNER JOIN T_SVC_RO_OP ROP ON ROP.WTYINCID = WIM.WTYINCID INNER JOIN T_SVC_RO_MSTR SRM ON ROP.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_MSTR RIM ON SRM.ROID = RIM.ROID WHERE WIM.WTYTYPE = 'EWP' AND WIM.STATUS <> 'C' AND ROP.CHARGETYPECODE = 'SO-W' ) INR WHERE INR.ROINVID = IM.ROINVID AND INR.ROID =
RO.ROID ) AS LABOUREWP ,( SELECT COALESCE(SUM(INR.FINALPRICE),0) FROM ( SELECT RIM.ROINVID ,SRM.ROID ,ROP.ROOPID ,( SELECT RIO.FINALPRICEWOGST FROM T_SVC_RO_INV_OP RIO WHERE RIO.ROINVID = RIM.ROINVID AND RIO.ROOPID = ROP.ROOPID ) AS FINALPRICE FROM T_SVC_RO_WTYINC_MSTR WIM INNER JOIN T_SVC_RO_OP ROP ON ROP.WTYINCID = WIM.WTYINCID INNER JOIN T_SVC_RO_MSTR
SRM ON ROP.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_MSTR RIM ON SRM.ROID = RIM.ROID WHERE WIM.WTYTYPE = 'ACC' AND WIM.STATUS <> 'C' AND ROP.CHARGETYPECODE = 'SO-W' ) INR WHERE INR.ROINVID = IM.ROINVID AND INR.ROID = RO.ROID ) AS LABOURACC ,( SELECT COALESCE(SUM(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE RIP.TTLAMTWOGSTNDISC END),0) FROM
T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID WHERE UPPER(PTM.PARTTYPECODE) = 'PARTS' AND RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INT','SO-INS','SO-F') AND
RIM.ROINVID =IM.ROINVID ) AS PARTPARTS ,( SELECT COALESCE(SUM(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE RIP.TTLAMTWOGSTNDISC END),0) FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID INNER JOIN
T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID WHERE UPPER(PTM.PARTTYPECODE) = 'ACCESSORIES' AND RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INT','SO-INS','SO-F') AND RIM.ROINVID = IM.ROINVID) AS PARTACC ,( SELECT COALESCE(SUM(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE RIP.TTLAMTWOGSTNDISC END),0) FROM T_SVC_RO_MSTR SRM INNER JOIN
T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID WHERE UPPER(PTM.PARTTYPECODE) = 'OIL & LUBRICANT' AND RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INT','SO-INS','SO-F') AND RIM.ROINVID = IM.ROINVID) AS
PARTLUB ,( SELECT COALESCE(SUM(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE RIP.TTLAMTWOGSTNDISC END),0) FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID =PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID
= PTM.PARTTYPEID WHERE UPPER(PTM.PARTTYPECODE) = 'LUBE SUB PRODUCT' AND RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INT','SO-INS','SO-F') AND RIM.ROINVID = IM.ROINVID ) AS PARTLUBESUB ,( SELECT COALESCE(SUM(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN TOTALCOST ELSE RIP.TTLAMTWOGSTNDISC END),0) FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID
INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID =RIP.ROINVID INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID WHERE UPPER(PTM.PARTTYPECODE) = 'MTL' AND RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INT','SO-INS','SO-F') AND RIM.ROINVID = IM.ROINVID ) AS PARTMTL ,( SELECT COALESCE(SUM(B.TOTALPRICEWOGST),0)
FROM ( SELECT SRM.ROID ,RIM.ROINVID ,ROP.ROOPPARTID FROM T_SVC_RO_INV_MSTR RIM INNER JOIN T_SVC_RO_MSTR SRM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_OP_PART ROP ON SRM.ROID = ROP.ROID INNER JOIN T_SVC_RO_WTYINC_MSTR WIM ON ROP.WTYINCID = WIM.WTYINCID WHERE ROP.CHARGETYPECODE = 'SO-W' AND WIM.WTYTYPE = 'WTY' AND WIM.STATUS <> 'C' AND ROP.STATUS <> 'C' )
A INNER JOIN (SELECT RIP.ROINVID ,RIP.ROOPPARTID ,RIP.ROINVPARTID ,RIP.TOTALPRICEWOGST FROM T_SVC_RO_INV_PART RIP ) B ON A.ROINVID = B.ROINVID AND A.ROOPPARTID =B.ROOPPARTID WHERE B.ROINVID = IM.ROINVID AND A.ROID = RO.ROID ) AS PARTWTY ,( SELECT COALESCE(SUM(B.TOTALPRICEWOGST),0) FROM ( SELECT SRM.ROID ,RIM.ROINVID ,ROP.ROOPPARTID FROM T_SVC_RO_INV_MSTR
RIM INNER JOIN T_SVC_RO_MSTR SRM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_OP_PART ROP ON SRM.ROID = ROP.ROID INNER JOIN T_SVC_RO_WTYINC_MSTR WIM ON ROP.WTYINCID = WIM.WTYINCID WHERE ROP.CHARGETYPECODE = 'SO-W' AND WIM.WTYTYPE = 'EWP' AND WIM.STATUS <> 'C' AND ROP.STATUS <> 'C' ) A INNER JOIN (SELECT RIP.ROINVID ,RIP.ROOPPARTID ,RIP.ROINVPARTID ,RIP.TOTALPRICEWOGST FROM T_SVC_RO_INV_PART RIP ) B ON A.ROINVID = B.ROINVID AND A.ROOPPARTID = B.ROOPPARTID WHERE B.ROINVID = IM.ROINVID AND A.ROID = RO.ROID ) AS PARTEWP ,( SELECT COALESCE(SUM(B.TOTALPRICEWOGST),0) FROM ( SELECT SRM.ROID ,RIM.ROINVID ,ROP.ROOPPARTID FROM T_SVC_RO_INV_MSTR RIM INNER JOIN
T_SVC_RO_MSTR SRM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_OP_PART ROP ON SRM.ROID = ROP.ROID INNER JOIN T_SVC_RO_WTYINC_MSTR WIM ON ROP.WTYINCID =WIM.WTYINCID WHERE ROP.CHARGETYPECODE = 'SO-W' AND WIM.WTYTYPE = 'ACC' AND WIM.STATUS <> 'C' AND ROP.STATUS <> 'C' ) A INNER JOIN (SELECT RIP.ROINVID ,RIP.ROOPPARTID ,RIP.ROINVPARTID ,RIP.TOTALPRICEWOGST FROM T_SVC_RO_INV_PART RIP ) B ON A.ROINVID = B.ROINVID AND A.ROOPPARTID = B.ROOPPARTID WHERE B.ROINVID = IM.ROINVID AND A.ROID = RO.ROID ) AS PARTWACC ,( SELECT COALESCE(SUM(ROOP.DISCOUNTBPRICE*ROOP.DISCOUNTPERC/100),0) FROM T_SVC_RO_INV_MSTR RIM INNER JOIN T_SVC_RO_INV_OP ROOP ON RIM.ROINVID = ROOP.ROINVID WHERE RIM.ROINVID = IM.ROINVID AND RIM.ROINVTYPECODE IN
('SOFLEKSIB','SOINT') ) AS DISCLABOUR ,NVL(IM.DISCOUNT,0) AS DISCCASH ,NVL(( SELECT (RIM.CAMPOVERAMT + RIM.CAMPPARTAMT + RIM.CAMPLBAMT) FROM T_SVC_RO_INV_MSTR RIM WHERE RIM.ROINVID = IM.ROINVID AND RIM.ROINVTYPECODE IN ('SOFLEKSIB','SOINT') ),0) AS CAMPDISC ,( SELECT CASE WHEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE
RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) > 0 THEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) ELSE
COALESCE(ROUND(SUM(RIP.DISCOUNTRM),2),0) END FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID WHERE UPPER(PTM.PARTTYPECODE) = 'PARTS' AND
RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') AND RIM.ROINVID = IM.ROINVID ) AS DISCPARTS ,( SELECT CASE WHEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) > 0 THEN
COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) ELSE COALESCE(ROUND(SUM(RIP.DISCOUNTRM),2),0) END FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN
T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID WHERE UPPER(PTM.PARTTYPECODE) IN ('ACCESSORIES','CONSUMABLES') AND RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') AND RIM.ROINVID = IM.ROINVID ) AS DISCACC ,( SELECT CASE WHEN
COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) > 0 THEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN
RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) ELSE COALESCE(ROUND(SUM(RIP.DISCOUNTRM),2),0) END FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID =PM.PARTID INNER JOIN
T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID WHERE UPPER(PTM.PARTTYPECODE) IN ('OIL & LUBRICANT' , 'LUBE SUB PRODUCT','ATF') AND RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') AND RIM.ROINVID = IM.ROINVID) AS DISCLUB ,( SELECT CASE WHEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END
*(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) > 0 THEN COALESCE(SUM(round((ROUND((CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.UNITCOST ELSE RIP.UNITBASEPRICE END *(CASE WHEN RIP.CHARGETYPECODE = 'SO-INS' THEN RIP.PTDISCPCT ELSE RIP.DISCOUNTPERC END /100)),2)*RIP.QTY),2)),0) ELSE
COALESCE(ROUND(SUM(RIP.DISCOUNTRM),2),0) END FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID WHERE UPPER(PTM.PARTTYPECODE) = 'MTL' AND
RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') AND RIM.ROINVID = IM.ROINVID ) AS DISCMTL ,( CASE WHEN (SELECT COALESCE(SUM(round((RIP.UNITBASEPRICE*(RIP.DISCOUNTPERC)/100*RIP.QTY),2)),0) FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID INNER JOIN T_PI_PART_MSTR PM ON
RIP.PARTID =PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID WHERE RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') AND RIM.ROINVID = IM.ROINVID) > 0 OR (SELECT COALESCE(SUM(RIP.DISCOUNTRM),0) FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID
INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID =PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID WHERE RIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-INS','SO-W','SO-INT') AND RIM.ROINVID = IM.ROINVID) > 0 OR (SELECT COALESCE(SUM(ROOP.DISCOUNTBPRICE*ROOP.DISCOUNTPERC/100),0) FROM T_SVC_RO_INV_MSTR RIM INNER JOIN T_SVC_RO_INV_OP ROOP ON RIM.ROINVID =
ROOP.ROINVID WHERE RIM.ROINVID = IM.ROINVID AND RIM.ROINVTYPECODE IN ('SOFLEKSIB','SOINT')) > 0 THEN 0 ELSE NVL(IM.OTHERDISC,0) END )AS OTHERADDDISC ,( SELECT COALESCE(SUM(RIM.TAXAMOUNT),0) FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID WHERE RIM.ROINVTYPECODE IN ('SOFLEKSIB','SOINT','SOINS','SOF') AND RIM.ROINVID = IM.ROINVID ) AS TAX ,( SELECT
COALESCE(SUM(RIM.GSTTAXAMOUNT),0) FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID WHERE RIM.ROINVTYPECODE = 'SOF' AND RIM.ROINVID = IM.ROINVID ) AS FSTAX ,( SELECT COALESCE(SUM(RIM.GSTTAXAMOUNT),0) FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID WHERE RIM.ROINVTYPECODE = 'SOW' AND RIM.ROINVID =
IM.ROINVID ) AS WTYTAX ,( SELECT COALESCE(SUM(ROIO.DISCOUNT),0) FROM T_SVC_RO_INV_OP ROIO WHERE ROIO.ROINVID = IM.ROINVID AND ROIO.CHARGETYPECODE IN ('SO-FLEKSIB','SO-F') ) AS PKGOPDISCAMT ,( SELECT COALESCE(SUM(ROIP.DISCOUNT),0) FROM T_SVC_RO_INV_PART ROIP WHERE ROIP.ROINVID = IM.ROINVID AND ROIP.CHARGETYPECODE IN ('SO-FLEKSIB','SO-F') ) AS
PKGPARTDISCAMT ,COALESCE(IM.INSEXCESSAMT,0) AS EXCESS ,COALESCE(IM.ROUNDINGADJAMOUNT,0) AS ROUNDINGADJAMOUNT ,COALESCE(IM.TOTALAMOUNT,0) AS TOTALAMOUNT ,COALESCE(IM.PAIDAMOUNT,0) AS PAIDAMOUNT ,( SELECT COALESCE(SUM(PD.PMTAMT),0) FROM T_SVC_PMTRECEIPT_MSTR PM INNER JOIN T_SVC_PMTRECEIPT_DTL PD ON PM.PRID = PD.PRID INNER JOIN T_SVC_PMTRECEIPT_DTL_INFO PDI
ON PM.PRID = PDI.PRID INNER JOIN T_SVC_RO_INV_MSTR RIM ON PDI.DOCNO = RIM.ROINVNO WHERE PDI.DOCTYPE = 'INVOICE' AND PD.PAYMODECODE IN ('CASH','CREDITCARD') AND PM.PAYTYPECODE IN ('NOR','INS') AND PDI.RECSTATUS =1 AND RIM.ROINVID = IM.ROINVID ) AS CASHCOLL ,( SELECT COALESCE(SUM(PD.PMTAMT),0) FROM T_SVC_PMTRECEIPT_MSTR PM INNER JOIN T_SVC_PMTRECEIPT_DTL PD ON PM.PRID =
PD.PRID INNER JOIN T_SVC_PMTRECEIPT_DTL_INFO PDI ON PM.PRID =PDI.PRID INNER JOIN T_SVC_RO_INV_MSTR RIM ON PDI.DOCNO = RIM.ROINVNO INNER JOIN T_CUSTPROFILE CP ON PM.CUSTPROFILEID = CP.CUSTPROFILEID WHERE PDI.DOCTYPE = 'INVOICE' AND CP.PAYMENTTYPE = 'D' AND RIM.ROINVTYPECODE IN ('SOFLEKSIB','SOINS') AND PDI.RECSTATUS = 1 AND RIM.ROINVID = IM.ROINVID ) AS CREDITCOLL ,( SELECT
COALESCE(SUM(PD.PMTAMT),0) FROM T_SVC_PMTRECEIPT_MSTR PM INNER JOIN T_SVC_PMTRECEIPT_DTL PD ON PM.PRID = PD.PRID INNER JOIN T_SVC_PMTRECEIPT_DTL_INFO PDI ON PM.PRID = PDI.PRID INNER JOIN T_SVC_RO_INV_MSTR RIM ON PDI.DOCNO = RIM.ROINVNO WHERE PDI.DOCTYPE ='INVOICE' AND PD.PAYMODECODE = 'CHQ' AND PM.PAYTYPECODE IN ('NOR','INS') AND PDI.RECSTATUS = 1 AND RIM.ROINVID =
IM.ROINVID ) AS CREDITCARDCOLL ,( SELECT COALESCE(SUM(PD.PMTAMT),0) FROM T_SVC_PMTRECEIPT_MSTR PM INNER JOIN T_SVC_PMTRECEIPT_DTL PD ON PM.PRID = PD.PRID INNER JOIN T_SVC_PMTRECEIPT_DTL_INFO PDI ON PM.PRID = PDI.PRID INNER JOIN T_SVC_RO_INV_MSTR RIM ON PDI.DOCNO = RIM.ROINVNO WHERE PDI.DOCTYPE = 'INVOICE' AND (PD.PAYMODECODE ='VOUCHER' OR PM.PAYTYPECODE = 'DEP')
AND PDI.RECSTATUS = 1 AND RIM.ROINVID = IM.ROINVID ) AS CASHDEPOSIT ,0 AS CCDEPOSIT ,( SELECT COALESCE(SUM(NVL(RIO.FRU * RIO.COST,0)),0) FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID INNER JOIN T_SVC_RO_INV_OP RIO ON RIM.ROINVID = RIO.ROINVID INNER JOIN T_SVC_RO_OP ROOP ON RIO.ROOPID = ROOP.ROOPID INNER JOIN T_OUTLET_MSTR OM ON
SRM.OUTLETID = OM.OUTLETID INNER JOIN T_REGION_MSTR RM ON OM.REGIONID = RM.REGIONID WHERE RIM.ROINVID = IM.ROINVID AND ROOP.OPOWNERCODE = 'M' ) AS COSTLABOUR ,( SELECT COALESCE(SUM(RIP.TOTALPRICEWOGST),0) FROM T_SVC_SUBLET_WO_MSTR WM INNER JOIN T_SVC_SUBLET_WO_PART WP ON WM.SUBLETWOID = WP.SUBLETWOID INNER JOIN T_SVC_RO_INV_PART RIP ON RIP.ROOPPARTID =
WP.ROOPPARTID WHERE WM.ROID = RO.ROID AND RIP.ROINVID = IM.ROINVID) AS COSTSUBLET ,( nvl((SELECT SUM(nvl(sj.TOTALAMTWOGST,0)) AS TotalSubeletJobCost FROM T_SVC_SUBLET_WO_MSTR sw INNER JOIN t_svc_sublet_wo_op sj ON sw.subletwoid = sj.subletwoid INNER JOIN t_svc_ro_op rop ON sj.roopid = rop.roopid WHERE sw.status != 'C' AND rop.subletcode is not null AND rop.recstatus = 1 AND rop.status != 'C' AND
REPLACE(rop.chargetypecode,'-','') = IM.ROINVTYPECODE AND rop.roid = RO.ROID) ,0) + nvl(( SELECT SUM(nvl(sp.TOTALAMTWOGST,0)) AS TotalSubeletPartCost FROM T_SVC_SUBLET_WO_MSTR sw INNER JOIN t_svc_sublet_wo_part sp ON sw.subletwoid = sp.subletwoid INNER JOIN t_svc_ro_op_part ropp ON sp.rooppartid = ropp.rooppartid WHERE sw.status != 'C' AND ropp.recstatus = 1 AND ropp.status != 'C' AND REPLACE(ropp.chargetypecode,'-','') =
IM.ROINVTYPECODE AND ropp.roid = RO.ROID) ,0) ) AS ML_SUBLETCOST ,( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0) FROM T_SVC_RO_INV_PART RIP INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID WHERE UPPER(PTM.PARTTYPECODE) = 'MTL' AND
RIM.ROINVID = IM.ROINVID ) AS COSTMAT ,( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0) FROM T_SVC_RO_INV_PART RIP INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID WHERE UPPER(PTM.PARTTYPECODE) = 'PARTS' AND RIM.ROINVID = IM.ROINVID ) AS
COSTPARTS ,( SELECT NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0) FROM T_SVC_RO_INV_PART RIP INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID =PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID WHERE UPPER(PTM.PARTTYPECODE) = 'ACCESSORIES' AND RIM.ROINVID = IM.ROINVID ) AS COSTACC ,( SELECT
NVL(SUM(COALESCE(RIP.UNITAVGCOST,0)),0) FROM T_SVC_RO_INV_PART RIP INNER JOIN T_PI_PART_MSTR PM ON RIP.PARTID = PM.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PTM ON PM.PARTTYPEID = PTM.PARTTYPEID INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIP.ROINVID = RIM.ROINVID WHERE UPPER(PTM.PARTTYPECODE) IN ( 'OIL & LUBRICANT','LUBE SUB PRODUCT') AND RIM.ROINVID = IM.ROINVID ) AS COSTLUB ,0 AS
CCDEPOSIT ,( SELECT COALESCE(SUM(RIO.GSTTAXAMT),0) FROM T_SVC_RO_INV_MSTR RIM INNER JOIN T_SVC_RO_INV_OP RIO ON RIM.ROINVID =RIO.ROINVID WHERE RIM.ROINVID = IM.ROINVID ) AS OPTAXAMT ,( SELECT COALESCE(SUM(RIP.GSTTAXAMT),0) FROM T_SVC_RO_INV_MSTR RIM INNER JOIN T_SVC_RO_INV_PART RIP ON RIM.ROINVID = RIP.ROINVID WHERE RIM.ROINVID = IM.ROINVID ) AS
PARTTAXAMT ,NVL(IM.GSTDISCAMT,0) AS CASHDISCAMT ,COALESCE(IM.SUBTOTAL,0) AS SUBTOTAL ,( SELECT COALESCE(SUM(RIM.GSTTAXAMOUNT),0) FROM T_SVC_RO_MSTR SRM INNER JOIN T_SVC_RO_INV_MSTR RIM ON RIM.ROID = SRM.ROID WHERE RIM.ROINVTYPECODE NOT IN ('SOW','SOF') AND RIM.ROINVID = IM.ROINVID ) AS GSTTAXAMOUNT ,NVL(( SELECT SUM(NVL( ( CASE WHEN PI.TOPAYAMT > PD.PMTAMT THEN
PD.PMTAMT ELSE PI.TOPAYAMT END ),0)) AS VOUCHER FROM T_SVC_PMTRECEIPT_DTL_INFO PI INNER JOIN T_SVC_PMTRECEIPT_DTL PD ON PD.PRID = PI.PRID AND PD.PAYMODECODE = 'VOUCHER' WHERE PI.RECSTATUS = 1 AND PI.DOCNO = IM.ROINVNO AND PI.DOCFLAG = 'APPLY' AND PI.DOCTYPE ='INVOICE' AND NVL(PI.TOPAYAMT,0) > 0 ),0) AS VOUCHER ,NVL(IM.EDISCAMT,0) AS EDISCAMT ,NVL(IM.TTLINVAMT,0) AS
TTLINVAMT ,NVL(IM.TTLEVAMT,0) AS TTLEVAMT ,IM.TAXMETHOD ,(SELECT SUM(NVL(PI.TOPAYAMT,0)) FROM T_SVC_PMTRECEIPT_DTL_INFO PI INNER JOIN T_SVC_PMTRECEIPT_MSTR PM ON PM.PRID = PI.PRID WHERE PI.RECSTATUS = 1 AND PAYMODECODE IN('CASH','TT','FPX','BANK SLIP') AND PI.DOCNO = IM.ROINVNO AND PM.PAYTYPECODE IN ('NOR','CASH') AND PI.DOCFLAG = 'APPLY' AND PI.DOCTYPE = 'INVOICE' AND
NVL(PI.TOPAYAMT,0) > 0) AS CASH ,CASE WHEN IM.ROINVTYPECODE = 'SOFLEKSIB' THEN NVL((SELECT SUM(NVL( (CASE WHEN PI.TOPAYAMT > PD.PMTAMT THEN PD.PMTAMT ELSE PI.TOPAYAMT END ),0)) AS CREDIT FROM T_SVC_PMTRECEIPT_DTL_INFO PI INNER JOIN T_SVC_PMTRECEIPT_DTL PD ON PD.PRDTLID = PI.PRDTLID INNER JOIN T_SVC_PMTRECEIPT_MSTR PM ON PM.PRID = PD.PRID INNER JOIN T_OUTLET_MSTR OM ON
OM.OUTLETID = PM.OUTLETID WHERE PI.RECSTATUS = 1 AND PI.DOCNO = IM.ROINVNO AND PM.PAYTYPECODE IN ('INS','CC') AND PI.PAYMODECODE IN ('CASH')AND PI.DOCFLAG = 'APPLY' AND PI.DOCTYPE = 'INVOICE' AND NVL(PI.TOPAYAMT,0) > 0),0)ELSE IM.TOTALAMOUNT END AS CREDIT ,NVL((SELECT SUM(NVL(PI.TOPAYAMT,0)) FROM T_SVC_PMTRECEIPT_DTL_INFO PI INNER JOIN T_SVC_PMTRECEIPT_MSTR PM ON PM.PRID =
PI.PRID WHERE PI.DOCNO = IM.ROINVNO AND PAYMODECODE IN(SELECT PAYMENTMODECODE FROM T_PAYMENTMODE WHERE RECSTATUS = 1 AND EFFSTARTDATE < CURRENT_DATE AND (EFFENDDATE > CURRENT_DATE-1 OR EFFENDDATE IS NULL) AND BIZUNITCODE = 'AFTERSALES' AND CREDITCARDFLAG = 'Y') AND PM.PAYTYPECODE IN ('NOR','CASH') AND PI.DOCFLAG = 'APPLY' AND PI.DOCTYPE = 'INVOICE' AND
PI.RECSTATUS = 1 AND NVL(PI.TOPAYAMT,0) > 0 OR PI.DOCNO = IM.ROINVNO AND PAYMODECODE IN ('CC','CREDITCARD') AND PM.PAYTYPECODE IN ('NOR','CASH') AND PI.DOCFLAG = 'APPLY' AND PI.DOCTYPE = 'INVOICE' AND PI.RECSTATUS = 1 AND NVL(PI.TOPAYAMT,0) > 0),0) AS CREDITCARD ,(SELECT SUM(NVL(PI.TOPAYAMT,0)) FROM T_SVC_PMTRECEIPT_DTL_INFO PI INNER JOIN T_SVC_PMTRECEIPT_MSTR PM ON
PM.PRID = PI.PRID WHERE PI.RECSTATUS = 1 AND PAYMODECODE IN('CASH','TT','FPX','BANK SLIP') AND PI.DOCNO = IM.ROINVNO AND PM.PAYTYPECODE IN ('DEP','OD') AND PI.DOCFLAG = 'APPLY' AND PI.DOCTYPE = 'INVOICE' AND NVL(PI.TOPAYAMT,0) > 0) AS CASHDEPOSIT1 ,(SELECT SUM(NVL(PI.TOPAYAMT,0)) FROM T_SVC_PMTRECEIPT_DTL_INFO PI INNER JOIN T_SVC_PMTRECEIPT_MSTR PM ON PM.PRID = PI.PRID WHERE
PI.DOCNO = IM.ROINVNO AND PAYMODECODE IN(SELECT PAYMENTMODECODE FROM T_PAYMENTMODE WHERE RECSTATUS = 1 AND EFFSTARTDATE < CURRENT_DATE AND (EFFENDDATE > CURRENT_DATE-1 OR EFFENDDATE IS NULL) AND BIZUNITCODE = 'AFTERSALES' AND CREDITCARDFLAG = 'Y') AND PI.DOCFLAG = 'APPLY' AND PM.PAYTYPECODE IN ('DEP','OD') AND PI.DOCTYPE = 'INVOICE' AND PI.RECSTATUS = 1 AND
NVL(PI.TOPAYAMT,0) > 0 OR PI.DOCNO = IM.ROINVNO AND PAYMODECODE IN ('CC','CREDITCARD') AND PM.PAYTYPECODE IN ('DEP','OD') AND PI.DOCFLAG = 'APPLY' AND PI.DOCTYPE = 'INVOICE' AND PI.RECSTATUS = 1 AND NVL(PI.TOPAYAMT,0) > 0) AS CREDITCARDDEPOSIT ,(CASE WHEN RO.ROTYPE = 'BP' THEN 'Body & Paint' WHEN RO.ROTYPE = 'CBJ' THEN 'Come Back Job' WHEN RO.ROTYPE = 'FOC' THEN 'Free of Charge' WHEN
RO.ROTYPE = 'MSR' THEN 'Maintenance Service Repair' ELSE 'ALL' END) AS ROTYPE ,(IM.STATUS) AS INVSTATUS, (select COALESCE(sum(RIP.UNITAVGCOST),0) from T_PI_PART_MSTR PM INNER JOIN T_PI_PARTTYPE_MSTR PTM ON pm.parttypeid = ptm.parttypeid INNER JOIN T_svc_ro_op_part ropp ON ropp.partid = pm.partid and ropp.recstatus = 1 and ropp.status != 'C' INNER JOIN T_svc_sublet_wo_part sp ON sp.rooppartid = ropp.rooppartid
and sp.suggestedamount > 0 INNER JOIN T_SVC_SUBLET_WO_MSTR sw ON sw.subletwoid = sp.subletwoid and sw.status != 'C' INNER JOIN T_PI_PART_DEFAULT_BIN PBIN ON ropp.PARTID = PBIN.PARTID INNER JOIN T_SVC_RO_INV_PART RIP ON RIP.ROOPPARTID = ropp.ROOPPARTID where UPPER(PTM.PARTTYPECODE) IN ( 'OIL '||chr(38)||' LUBRICANT','LUBE SUB PRODUCT') and replace(ropp.chargetypecode,'-','') = IM.ROINVTYPECODE
AND IM.ROID = RO.ROID and ropp.roid = RO.ROID AND RIP.ROINVID = IM.ROINVID AND RO.OUTLETID = PBIN.OUTLETID ) as SUBLETLUBAVGCOST, (select COALESCE(sum(RIP.UNITAVGCOST),0) from T_PI_PART_MSTR PM INNER JOIN T_PI_PARTTYPE_MSTR PTM ON pm.parttypeid = ptm.parttypeid INNER JOIN T_svc_ro_op_part ropp ON ropp.partid = pm.partid and ropp.recstatus = 1 and ropp.status != 'C' INNER JOIN T_svc_sublet_wo_part sp
ON sp.rooppartid = ropp.rooppartid and sp.suggestedamount > 0 INNER JOIN T_SVC_SUBLET_WO_MSTR sw ON sw.subletwoid = sp.subletwoid and sw.status != 'C' INNER JOIN T_PI_PART_DEFAULT_BIN PBIN ON ropp.PARTID = PBIN.PARTID INNER JOIN T_SVC_RO_INV_PART RIP ON RIP.ROOPPARTID = ropp.ROOPPARTID where UPPER(PTM.PARTTYPECODE) = 'MTL' and replace(ropp.chargetypecode,'-','') = IM.ROINVTYPECODE AND IM.ROID =
RO.ROID and ropp.roid = RO.ROID AND RIP.ROINVID = IM.ROINVID AND RO.OUTLETID = PBIN.OUTLETID ) as SUBLETMATAVGCOST, (select COALESCE(sum(RIP.UNITAVGCOST),0) from T_PI_PART_MSTR PM INNER JOIN T_PI_PARTTYPE_MSTR PTM ON pm.parttypeid = ptm.parttypeid INNER JOIN T_svc_ro_op_part ropp ON ropp.partid = pm.partid and ropp.recstatus = 1 and ropp.status != 'C' INNER JOIN T_svc_sublet_wo_part sp ON sp.rooppartid
= ropp.rooppartid and sp.suggestedamount > 0 INNER JOIN T_SVC_SUBLET_WO_MSTR sw ON sw.subletwoid = sp.subletwoid and sw.status != 'C' INNER JOIN T_PI_PART_DEFAULT_BIN PBIN ON ropp.PARTID = PBIN.PARTID INNER JOIN T_SVC_RO_INV_PART RIP ON RIP.ROOPPARTID = ropp.ROOPPARTID where UPPER(PTM.PARTTYPECODE) = 'ACCESSORIES' and replace(ropp.chargetypecode,'-','') = IM.ROINVTYPECODE AND IM.ROID =
RO.ROID and ropp.roid = RO.ROID AND RIP.ROINVID = IM.ROINVID AND RO.OUTLETID = PBIN.OUTLETID ) as SUBLETACCAVGCOST, (select COALESCE(sum(RIP.UNITAVGCOST),0) from T_PI_PART_MSTR PM INNER JOIN T_PI_PARTTYPE_MSTR PTM ON pm.parttypeid = ptm.parttypeid INNER JOIN T_svc_ro_op_part ropp ON ropp.partid = pm.partid and ropp.recstatus = 1 and ropp.status != 'C' INNER JOIN T_svc_sublet_wo_part sp ON sp.rooppartid
= ropp.rooppartid and sp.suggestedamount > 0 INNER JOIN T_SVC_SUBLET_WO_MSTR sw ON sw.subletwoid = sp.subletwoid and sw.status != 'C' INNER JOIN T_PI_PART_DEFAULT_BIN PBIN ON ropp.PARTID = PBIN.PARTID INNER JOIN T_SVC_RO_INV_PART RIP ON RIP.ROOPPARTID = ropp.ROOPPARTID where UPPER(PTM.PARTTYPECODE) = 'PARTS' and replace(ropp.chargetypecode,'-','') = IM.ROINVTYPECODE AND IM.ROID = RO.ROID and
ropp.roid = RO.ROID AND RIP.ROINVID = IM.ROINVID AND RO.OUTLETID = PBIN.OUTLETID ) as SUBLETPARTAVGCOST , COALESCE(IM.INSBETTERMENTAMT,0) AS INSBETTERMENTAMT, NVL((SELECT SUM(ROUND(NVL(SOP.TOTALAMTWOGST,0),2)) AS SOPTOTALAMTWOGST FROM T_SVC_SUBLET_WO_OP SOP INNER JOIN T_SVC_SUBLET_WO_MSTR SWO ON SWO.SUBLETWOID = SOP.SUBLETWOID AND SWO.STATUS != 'C' INNER JOIN
T_SVC_RO_INV_OP INVOP ON INVOP.ROOPID = SOP.ROOPID WHERE 1=1 AND SWO.ROID = RO.ROID AND INVOP.ROINVID = IM.ROINVID),0) AS SBLETCOSTLABOR, NVL((SELECT SUM(ROUND(NVL(SOP.GSTTAXAMT,0),2)) AS SOPTAXAMT FROM T_SVC_SUBLET_WO_OP SOP INNER JOIN T_SVC_SUBLET_WO_MSTR SWO ON SWO.SUBLETWOID = SOP.SUBLETWOID AND SWO.STATUS != 'C' INNER JOIN T_SVC_RO_INV_OP INVOP ON
INVOP.ROOPID = SOP.ROOPID WHERE 1=1 AND SWO.ROID = RO.ROID AND INVOP.ROINVID = IM.ROINVID),0) AS SBLETCOSTTAXLABOR, NVL((SELECT SUM(ROUND(NVL(SOP.TOTALAMTWGST,0),2)) AS SOPTOTALAMTWGST FROM T_SVC_SUBLET_WO_OP SOP INNER JOIN T_SVC_SUBLET_WO_MSTR SWO ON SWO.SUBLETWOID = SOP.SUBLETWOID AND SWO.STATUS != 'C' INNER JOIN T_SVC_RO_INV_OP INVOP ON INVOP.ROOPID =
SOP.ROOPID WHERE 1=1 AND SWO.ROID = RO.ROID AND INVOP.ROINVID = IM.ROINVID),0) AS SBLETCOSTWTAXLABOR, NVL((SELECT SUM(ROUND(NVL(SP.TOTALAMTWOGST,0),2)) AS SPTOTALAMTWOGST FROM T_SVC_SUBLET_WO_PART SP INNER JOIN T_SVC_SUBLET_WO_MSTR SWO ON SWO.SUBLETWOID = SP.SUBLETWOID AND SWO.STATUS != 'C' INNER JOIN T_SVC_RO_INV_PART INVPART ON INVPART.ROOPPARTID =
SP.ROOPPARTID WHERE 1=1 AND SWO.ROID = RO.ROID AND INVPART.ROINVID = IM.ROINVID),0) AS SBLETCOSTPART, NVL((SELECT SUM(ROUND(NVL(SP.GSTTAXAMT,0),2)) AS SPTAXAMT FROM T_SVC_SUBLET_WO_PART SP INNER JOIN T_SVC_SUBLET_WO_MSTR SWO ON SWO.SUBLETWOID = SP.SUBLETWOID AND SWO.STATUS != 'C' INNER JOIN T_SVC_RO_INV_PART INVPART ON INVPART.ROOPPARTID = SP.ROOPPARTID
WHERE 1=1 AND SWO.ROID = RO.ROID AND INVPART.ROINVID = IM.ROINVID),0) AS SBLETCOSTTAXPART, NVL((SELECT SUM(ROUND(NVL(SP.TOTALAMTWGST,0),2)) AS SPTOTALAMTWGST FROM T_SVC_SUBLET_WO_PART SP INNER JOIN T_SVC_SUBLET_WO_MSTR SWO ON SWO.SUBLETWOID = SP.SUBLETWOID AND SWO.STATUS != 'C' INNER JOIN T_SVC_RO_INV_PART INVPART ON INVPART.ROOPPARTID = SP.ROOPPARTID WHERE
1=1 AND SWO.ROID = RO.ROID AND INVPART.ROINVID = IM.ROINVID),0) AS SBLETCOSTWTAXPART FROM T_SVC_RO_INV_MSTR IM INNER JOIN T_SVC_RO_MSTR RO ON IM.ROID = RO.ROID INNER JOIN T_CUSTPROFILE CP ON RO.CUSTPROFILEID = CP.CUSTPROFILEID INNER JOIN T_VEHCUSTPROFILE VCP ON RO.VCPROFILEID = VCP.VCPROFILEID INNER JOIN T_OUTLET_MSTR M ON RO.OUTLETCODE = M.OUTLETCODE WHERE 1=1
AND IM.STATUS NOT IN ('C','A','S') AND RO.OUTLETCODE = :PARAMOUTLETCODE AND IM.OUTLETCODE = :PARAMOUTLETCODE AND IM.ROINVDATE >= TO_DATE('01/12/2020','DD/MM/YYYY') AND IM.ROINVDATE < TO_DATE('31/12/2020','DD/MM/YYYY') + 1 AND RO.STATUS IN ('I','P') ) GROUP BY
OUTLETCODE ,RONO ,ROINVSORTNO ,ROINVNO ,ROINVTYPECODE ,CURRMILEAGE ,REGNO ,REGDATE ,APPTBKNO ,ROINVDATE ,CUSTNO ,CUSTNAME ,CUSTGRP ,MFAMILYCODE ,SVCADVISORNAME ,CUST_TYPE_DESC ,ROSTATUS ,FSTAX ,CASHDISCAMT ,SUBTOTAL,GSTTAXAMOUNT,VOUCHER,EDISCAMT,TTLINVAMT,TTLEVAMT,TAXMETHOD ,ROTYPE ,INVSTATUS ORDER BY OUTLETCODE ,ROINVSORTNO ,ROINVNO