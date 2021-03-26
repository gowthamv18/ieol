DROP VIEW DSS.DEADSTOCKREPORT;

/* Formatted on 2021/01/07 14:45 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW dss.deadstockreport (partid,
                                                  partno,
                                                  partdesc,
                                                  parttypedesc,
                                                  binlotcode,
                                                  qtyonhand,
                                                  qtyblocked,
                                                  avgpartcost,
                                                  binlotid,
                                                  createddatetime,
                                                  parttypecode,
                                                  last_received,
                                                  last_issued,
                                                  outletid,
                                                  outletcode,
                                                  outletname
                                                 )
AS
   SELECT pdb.partid AS partid, pm.partno AS partno, pm.partdesc AS partdesc,
          pt.parttypedesc AS parttypedesc, bm.binlotcode AS binlotcode,
          pdb.qtyonhand AS qtyonhand, NVL (pdb.qtyblocked, 0) AS qtyblocked,
          CASE
             WHEN outlet.outlettype = 'BRANCH'
                THEN pdb.pois_costprice
             ELSE pdb.avgpartcost
          END AS avgpartcost,
          pdb.binlotid AS binlotid,
		  
          TO_DATE (TO_CHAR (pdb.createddatetime, 'YYYY-MON-DD HH24:MI:SS'),
                   'YYYY-MON-DD HH24:MI:SS'
                  ) AS createddatetime,
				  
          pt.parttypecode, pdb.last_received, pdb.last_issued, pdb.outletid,
          outlet.outletcode, outlet.outletname
     FROM t_pi_part_default_bin pdb INNER JOIN t_pi_part_mstr pm
          ON pm.partid = pdb.partid
          INNER JOIN t_pi_parttype_mstr pt ON pm.parttypeid = pt.parttypeid
          INNER JOIN t_pi_binlot_mstr bm ON pdb.binlotid = bm.binlotid
          INNER JOIN t_outlet_mstr outlet ON outlet.outletid = pdb.outletid
    WHERE pdb.qtyonhand > 0 AND outlet.recstatus = 1;


DROP SYNONYM DSSUSR.DEADSTOCKREPORT;

CREATE SYNONYM DSSUSR.DEADSTOCKREPORT FOR DSS.DEADSTOCKREPORT;


DROP SYNONYM DWQVUSR.DEADSTOCKREPORT;

CREATE SYNONYM DWQVUSR.DEADSTOCKREPORT FOR DSS.DEADSTOCKREPORT;


DROP SYNONYM FRMUSR.DEADSTOCKREPORT;

CREATE SYNONYM FRMUSR.DEADSTOCKREPORT FOR DSS.DEADSTOCKREPORT;


GRANT SELECT ON DSS.DEADSTOCKREPORT TO DWQVUSR;
