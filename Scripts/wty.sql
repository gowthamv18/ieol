SELECT
    *
FROM
    (
        SELECT
            table1.*,
            ROWNUM r
        FROM
            (
                SELECT
                    swm.wcfid           AS "WCFID",
                    swm.wcfno           AS "WCFNO",
                    rwm.wcsrefno        AS "WCSREFNO",
                    CAST(ri.roinvdate AS DATE) AS "ROINVDATE",
                    swm.rono            AS "RONO",
                    CAST(srm.rodate AS DATE) AS "RODATE",
                    swm.paymentstatus   AS "PAYMENTSTATUS",
                    swm.refno           AS "REFNO",
                    CAST(swm.paymentdate AS DATE) AS "PAYMENTDATE",RWM.wtytype         AS "WTYTYPE",
                    rwm.claimtype       AS "WCFTYPE",
                    srm.regno           AS "VEHNO",
                    cp.custname         AS "CUSTNAME",
                    srm.mvariantcode    AS "MVCODE",
                    swm.wtyamt          AS "WTYAMT",
                    CASE swm.status
                        WHEN 'N'   THEN
                            'NEW'
                        WHEN 'P'   THEN
                            'IN PROGRESS'
                        WHEN 'A'   THEN
                            'APPROVED'
                        WHEN 'R'   THEN
                            'RETURNED'
                        WHEN 'D'   THEN
                            'DENIED'
                        WHEN 'C'   THEN
                            'CANCELLED'
                    END "STATUS",
                    trunc(current_date) - trunc(ri.roinvdate) AS "CLAIMTRAVELDATE",
                    srm.svcadvisorid    AS "SVCADVISORID",
                    (
                        SELECT
                            settingvalue
                        FROM
                            t_wty_global_setting
                        WHERE
                            settingcode = 'TRAVELCLAIMTIMEYELLOWFR'
                    ) AS "TRAVELCLAIMTIMEYELLOWFR",
                    (
                        SELECT
                            settingvalue
                        FROM
                            t_wty_global_setting
                        WHERE
                            settingcode = 'TRAVELCLAIMTIMEYELLOWTO'
                    ) AS "TRAVELCLAIMTIMEYELLOWTO",
                    (
                        SELECT
                            settingvalue
                        FROM
                            t_wty_global_setting
                        WHERE
                            settingcode = 'TRAVELCLAIMTIMERED'
                    ) AS "TRAVELCLAIMTIMERED",
                    rwm.wtyaidcode      AS "WTYAIDCODE"
                FROM
                    t_svc_wcf_mstr         swm
                    INNER JOIN t_svc_ro_mstr          srm ON swm.roid = srm.roid
                    INNER JOIN t_svc_ro_inv_mstr      ri ON srm.roid = ri.roid
                                                       AND swm.roinvid = ri.roinvid
                    INNER JOIN t_svc_ro_wtyinc_mstr   rwm ON srm.roid = rwm.roid
                                                           AND swm.wtyincid = rwm.wtyincid
                    INNER JOIN t_custprofile          cp ON srm.custprofileid = cp.custprofileid
                    LEFT JOIN t_svc_frssub_dtl       sfd ON sfd.roid = srm.roid
                    LEFT JOIN t_svc_frssub_mstr      sfm ON sfm.frssubmstrid = sfd.frssubmstrid
                WHERE
                    1 = 1
                    AND srm.outletcode = ( '621011' )
                    AND srm.taxmethod = ( 'SST' )
                    AND TO_CHAR(ri.roinvdate, 'MM') = '02'
                    AND TO_CHAR(ri.roinvdate, 'YYYY') = '2021'
                    AND swm.status IN (
                        'N',
                        'P',
                        'A',
                        'R',
                        'D',
                        'C'
                    )
                ORDER BY
                    1 ASC
            ) table1
        WHERE
            ROWNUM <= 20
    )
WHERE
    r >= 1