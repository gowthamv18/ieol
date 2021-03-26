SELECT CRO.SVCADVNAME AS CREATEDBY, (SELECT SVCADVISORNAME
    FROM T_SVC_ADVISOR_MSTR
    WHERE STAFFID = CRO.SVCADVNAME AND OUTLETID = CRO.OUTLETID AND ROWNUM = 1) AS SVCNAME, DTL.PARTID, OUTLET.OUTLETCODE, OUTLET.OUTLETNAME, OUTLET.OUTLETTYPE, OUTLET.OUTLETID, (SELECT POA.ACTIONDATETIME
    FROM T_PI_PO_AUDIT POA
    WHERE PO.STATUS = 'C' AND POA.PROCESSTYPE = 'Order Cancellation' AND POA.POID = PO.POID AND ROWNUM = 1) AS CROCANCELDATE, (SELECT POA.REMARKS
    FROM T_PI_PO_AUDIT POA
    WHERE PO.STATUS = 'C' AND POA.PROCESSTYPE = 'Order Cancellation' AND POA.POID = PO.POID AND ROWNUM = 1) AS CROCANCELREMARKS, CRO.CRONO, CRO.CRODATE, CRO.STATUS, CRO.REGNO, CRO.CUSTNAME, CRO.CUSTID, CRO.CUSTTELNO, DTL.ORDERQTY, PO.PONO, OT.ORDERTYPECODE, TO_DATE(TO_CHAR(PO.PODATE,'dd/mm/yyyy'),'dd/mm/yyyy') AS PODATE, CRO.APPTDATE1, CRO.APPTDATE2, CRO.CROREMARKS, DTL.UNITBASEPRICE, DTL.UNITDISCPRICE, DTL.UNITAVGCOST, DTL.UNITPOISCOST, DTL.TOTALBASEPRICEWOGST, DTL.TOTALDISCPRICE, DTL.TOTALAVGCOST, DTL.TOTALPOISCOST, DTL.STATUS AS DTLSTATUS, TO_DATE(PODTL.ETADATE) AS ETADATE, (PODTL.UNITRETAILPRICE * PODTL.ORDERQTY) AS TOTALRETAIL, PODTL.UNITRETAILPRICE, PODTL.ORDERQTY AS POORDERQTY, NVL(PODTL.RECEIVEDQTY,0) AS RECEIVEDQTY, PODTL.GSTTAXRATE AS GSTTAXRATE, (PODTL.UNITBASECOST * DTL.ORDERQTY) AS TOTALCOST, PODTL.POID, PODTL.PARTID AS POPARTID, CRO.TAXMETHOD , 0 AS QTYRCVD, 0 AS GINDTLBINID, PART.PARTDESC, 0 AS GINAVGCOST, 0 AS GINTTLPOIS, PART.PARTNO, null AS GINDATE, (CASE WHEN (SELECT PGDB.SUPPLYPARTNO
    FROM T_PI_GIN_DTL_BIN PGDB INNER JOIN T_PI_GIN_MSTR PGM ON PGM.GINID = PGDB.GINID AND PGM.STATUS = 'V' INNER
        JOIN T_PI_PART_MSTR PARTMSTR ON PGDB.SUPPLYPARTID = PARTMSTR.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PARTTYPE ON PARTMSTR.PARTTYPEID = PARTTYPE.PARTTYPEID INNER JOIN T_PI_PART_DEFAULT_BIN PDB ON PGM.OUTLETID = PDB.OUTLETID AND PGDB.SUPPLYPARTID = PDB.PARTID
    WHERE PGDB.POID = PODTL.POID AND PGDB.PARTID = DTL.PARTID AND ROWNUM = 1) IS NULL THEN PART.PARTNO END) AS SUPPLYPARTNO, (CASE WHEN (SELECT PGDB.SUPPLYPARTNO
    FROM T_PI_GIN_DTL_BIN PGDB INNER JOIN T_PI_GIN_MSTR PGM ON PGM.GINID = PGDB.GINID AND PGM.STATUS = 'V' INNER JOIN T_PI_PART_MSTR PARTMSTR ON PGDB.SUPPLYPARTID = PARTMSTR.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PARTTYPE ON PARTMSTR.PARTTYPEID = PARTTYPE.PARTTYPEID INNER JOIN T_PI_PART_DEFAULT_BIN PDB ON PGM.OUTLETID = PDB.OUTLETID AND PGDB.SUPPLYPARTID = PDB.PARTID
    WHERE PGDB.POID = PODTL.POID AND PGDB.PARTID = DTL.PARTID AND ROWNUM = 1) IS NULL THEN PART.PARTDESC END) AS SUPPLYPARTDESC, (SELECT NVL(SUM(PGDB.QTYRCVD), 0)
    FROM T_PI_GIN_DTL_BIN PGDB INNER JOIN T_PI_GIN_MSTR PGM ON PGM.GINID = PGDB.GINID AND PGM.STATUS = 'V' INNER JOIN T_PI_PART_MSTR PARTMSTR ON PGDB.SUPPLYPARTID = PARTMSTR.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PARTTYPE ON PARTMSTR.PARTTYPEID = PARTTYPE.PARTTYPEID INNER JOIN T_PI_PART_DEFAULT_BIN PDB ON PGM.OUTLETID = PDB.OUTLETID AND PGDB.SUPPLYPARTID = PDB.PARTID
    WHERE PGDB.POID = PODTL.POID AND PGDB.PARTID = DTL.PARTID AND ROWNUM = 1) AS GINQTYRCVD, (SELECT (CASE WHEN OUTLET.OUTLETTYPE = 'DEALER' THEN PGDB.TOTALAVGCOST ELSE PGDB.TOTALPOISCOSTWOGST END) AS GINTOTALCOST
    FROM T_PI_GIN_DTL_BIN PGDB INNER JOIN T_PI_GIN_MSTR PGM ON PGM.GINID =
PGDB.GINID AND PGM.STATUS = 'V' INNER JOIN T_PI_PART_MSTR PARTMSTR ON PGDB.SUPPLYPARTID = PARTMSTR.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PARTTYPE ON PARTMSTR.PARTTYPEID = PARTTYPE.PARTTYPEID INNER JOIN T_PI_PART_DEFAULT_BIN PDB ON PGM.OUTLETID = PDB.OUTLETID AND PGDB.SUPPLYPARTID = PDB.PARTID
    WHERE PGDB.POID = PODTL.POID AND PGDB.PARTID = DTL.PARTID AND ROWNUM = 1) AS GINTOTALCOST, (SELECT PGM.GINDATE
    FROM T_PI_GIN_DTL_BIN PGDB INNER JOIN T_PI_GIN_MSTR PGM ON PGM.GINID = PGDB.GINID AND PGM.STATUS = 'V' INNER JOIN T_PI_PART_MSTR PARTMSTR ON PGDB.SUPPLYPARTID = PARTMSTR.PARTID INNER JOIN T_PI_PARTTYPE_MSTR PARTTYPE ON PARTMSTR.PARTTYPEID = PARTTYPE.PARTTYPEID INNER JOIN T_PI_PART_DEFAULT_BIN PDB ON PGM.OUTLETID = PDB.OUTLETID AND PGDB.SUPPLYPARTID = PDB.PARTID
    WHERE PGDB.POID = PODTL.POID AND PGDB.PARTID = DTL.PARTID AND ROWNUM = 1) AS GINDATE2
FROM T_PI_CRO_MSTR CRO INNER JOIN T_PI_CRO_DTL DTL ON CRO.CROID = DTL.CROID AND DTL.RECSTATUS = 1 INNER JOIN T_OUTLET_MSTR OUTLET ON OUTLET.OUTLETID = CRO.OUTLETID INNER JOIN T_PI_ORDERTYPE_MSTR OT ON OT.ORDERTYPEID = DTL.ORDERTYPEID INNER JOIN T_PI_PO_MSTR PO ON CRO.CROID = PO.CROID INNER JOIN T_PI_PO_DTL PODTL ON PO.POID = PODTL.POID AND DTL.PARTID = PODTL.PARTID AND PODTL.RECSTATUS = 1 INNER JOIN T_PI_PART_MSTR PART ON DTL.PARTID = PART.PARTID
WHERE 1=1 AND CRO.OUTLETCODE = :PARAMOUTLETCODE AND PO.PODATE >= TO_DATE('01/12/2020','DD/MM/YYYY') AND PO.PODATE < TO_DATE('31/12/2020','DD/MM/YYYY') + 1 AND DTL.STATUS IN ('N','S','F','W','R','L')
ORDER BY CRO.SVCADVNAME, CRO.CRONO, DTL.PARTNO