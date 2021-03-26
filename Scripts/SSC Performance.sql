DROP VIEW DSS.VIEW_REP_SSC_PERFORMANCE;

/* Formatted on 2021/02/21 10:57 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW dss.view_rep_ssc_performance (outletcode,
                                                           outletname,
                                                           rono,
                                                           ofpno,
                                                           opcode,
                                                           partno,
                                                           roinvdate,
                                                           rodate,
                                                           svcadvisorname,
                                                           region,
                                                           totalop,
                                                           totalpart,
                                                           status,
                                                           datefilter,
                                                           outletid,
                                                           wtyincid
                                                          )
AS
   SELECT   ot.outletcode, ot.outletname, incmstr.rono, incmstr.ofpno,
            op.opcode, NVL (part.partno, '-') AS partno,
            TO_CHAR (roinv.roinvdate, 'DD/MM/YYYY') AS roinvdate,
            TO_CHAR (romstr.rodate, 'DD/MM/YYYY') AS rodate,
            adv.svcadvisorname, reg.regiondesc,
            NVL ((SELECT SUM (opdtl.finalpricewgst)
                    FROM t_svc_ro_op opdtl INNER JOIN t_svc_ro_wtyinc_mstr inc
                         ON inc.rono = opdtl.rono
                   WHERE opdtl.wtyincid = incmstr.wtyincid
                     AND inc.ofpno = incmstr.ofpno
                     AND opdtl.roid = romstr.roid),
                 0
                ) AS totalop,
            NVL ((SELECT SUM (oppart.totalpricewgst)
                    FROM t_svc_ro_op_part oppart INNER JOIN t_svc_ro_wtyinc_mstr inc
                         ON inc.rono = oppart.rono
                   WHERE oppart.wtyincid = incmstr.wtyincid
                     AND inc.ofpno = incmstr.ofpno
                     AND oppart.roid = romstr.roid),
                 0
                ) AS totalpart,
            wcfmstr.status, roinv.roinvdate AS datefilter, ot.outletid,
            part.wtyincid
       FROM t_svc_ro_wtyinc_mstr incmstr INNER JOIN t_svc_ro_mstr romstr
            ON incmstr.roid = romstr.roid
            INNER JOIN t_svc_ro_inv_mstr roinv
            ON romstr.roid = roinv.roid
          AND roinv.roinvtypecode = 'SOW'
          AND roinv.status <> 'C'
            INNER JOIN t_outlet_mstr ot ON ot.outletid = romstr.outletid
            INNER JOIN t_region_mstr reg ON ot.regionid = reg.regionid
            INNER JOIN t_svc_advisor_mstr adv
            ON adv.staffid = romstr.svcadvisorid
               AND adv.outletid = ot.outletid
            INNER JOIN t_svc_wcf_mstr wcfmstr ON incmstr.wcfno = wcfmstr.wcfno
            LEFT JOIN t_svc_ro_op op ON incmstr.wtyincid = op.wtyincid
            LEFT JOIN t_svc_ro_op_part part
            ON part.wtyincid = incmstr.wtyincid AND part.opcode = op.opcode
      WHERE incmstr.claimtype = 'SC'
   ORDER BY romstr.rono;


DROP SYNONYM DSSUSR.VIEW_REP_SSC_PERFORMANCE;

CREATE SYNONYM DSSUSR.VIEW_REP_SSC_PERFORMANCE FOR DSS.VIEW_REP_SSC_PERFORMANCE;


DROP SYNONYM DWQVUSR.VIEW_REP_SSC_PERFORMANCE;

CREATE SYNONYM DWQVUSR.VIEW_REP_SSC_PERFORMANCE FOR DSS.VIEW_REP_SSC_PERFORMANCE;


DROP SYNONYM FRMUSR.VIEW_REP_SSC_PERFORMANCE;

CREATE SYNONYM FRMUSR.VIEW_REP_SSC_PERFORMANCE FOR DSS.VIEW_REP_SSC_PERFORMANCE;


GRANT SELECT ON DSS.VIEW_REP_SSC_PERFORMANCE TO DWQVUSR;
