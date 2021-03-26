SELECT
    dp.outletid       AS outletid,
    dp.outletcode     AS outletcode,
    dp.outletname     AS outletname,
    dp.partid         AS partid,
    dp.partno         AS partno,
    dp.partdesc       AS partdesc,
    dp.parttypedesc   AS parttypedesc,
    dp.binlotcode     AS binlotcode,
    (
        SELECT
            LISTAGG(bm.binlotcode, ','
                                   || CHR(10)
                                   || '') WITHIN GROUP(
                ORDER BY
                    bm.binlotcode
            ) "OTHERBINLOTCODE"
        FROM
            t_pi_part_bin_dtl   bd
            INNER JOIN T_PI_BINLOT_MSTR    bm ON bd.binlotid = bm.binlotid
        WHERE BD.partid = dp.partid
            AND bm.binlotcode != dp.binlotcode
            AND bd.outletid = dp.outletid
            AND bd.qtyonhand > 0
    ) AS otherbinlotcode,
    dp.qtyonhand      AS qtyonhand,
    nvl((
        SELECT
            qtyblocked
        FROM
            t_pi_part_default_bin
        WHERE
            partid = dp.partid
            AND outletid = dp.outletid
    ),0) AS qtyblocked,
    dp.avgpartcost    AS avgpartcost,
    dp.binlotid       AS binlotid,
    TO_DATE(TO_CHAR(dp.createddatetime, 'YYYY-MONDD HH24:MI:SS'), 'YYYY-MON-DD HH24:MI:SS') AS createddatetime,
    dp.parttypecode,
    TO_CHAR((
        SELECT
            last_issued
        FROM
            t_pi_part_default_bin
        WHERE
            partid = dp.partid
            AND outletid = dp.outletid
    ), 'DD/MM/YYYY
HH24:MI:SS') AS last_issued,
    TO_CHAR((
        SELECT
            last_received
        FROM
            t_pi_part_default_bin
        WHERE
            partid = dp.partid
            AND outletid = dp.outletid
    ), 'DD/MM/YYYY HH24:MI:SS') AS last_received,
    TO_CHAR((
        SELECT
            lastpodate
        FROM
            t_pi_part_default_bin
        WHERE
            partid = dp.partid
            AND outletid = dp.outletid
    ), 'DD/MM/YYYY HH24:MI:SS') AS lastpodate,
    (
        SELECT
            nvl(SUM(nvl(orderqty, 0) - nvl(receivedqty, 0) - nvl(cancelledqty, 0)), 0) AS orderqty
        FROM
            t_pi_po_mstr   pom
            INNER JOIN t_pi_po_dtl    podtl ON pom.poid = podtl.poid
                                            AND podtl.etadate < current_date
                                            AND podtl.recstatus = 1
                                            AND nvl(podtl.orderqty, 0) - nvl(podtl.receivedqty, 0) - nvl(podtl.cancelledqty, 0) >
                                            0
                                            AND ( podtl.randid = '0'
                                                  OR podtl.randid IS NULL )
        WHERE
            pom.outletid = dp.outletid
            AND podtl.partid = dp.partid
            AND pom.status IN (
                'F',
                'A'
            )
    ) AS orderqty,
    (
        CASE
            WHEN (
                SELECT
                    trunc(last_received) as
                FROM
                    t_pi_part_default_bin
                WHERE
                    partid = dp.partid
                    AND outletid = dp.outletid
            ) IS NOT NULL THEN
                TO_DATE(current_date, 'DD/MM/YYYY') - TO_DATE((
                    SELECT
                        trunc(last_received)
                    FROM
                        t_pi_part_default_bin
                    WHERE
                        partid = dp.partid
                        AND outletid = dp.outletid
                ), 'DD/MM/YYYY')
            WHEN (
                SELECT
                    trunc(last_received)
                FROM
                    t_pi_part_default_bin
                WHERE
                    partid = dp.partid
                    AND outletid = dp.outletid
            ) IS NULL
                 AND (
                SELECT
                    trunc(last_issued)
                FROM
                    t_pi_part_default_bin
                WHERE
                    partid = dp.partid
                    AND outletid = dp.outletid
            ) IS NOT NULL THEN
                TO_DATE(current_date, 'DD/MM/YYYY') - TO_DATE((
                    SELECT
                        trunc(last_issued)
                    FROM
                        t_pi_part_default_bin
                    WHERE
                        partid = dp.partid
                        AND outletid = dp.outletid
                ), 'DD/MM/YYYY')
            ELSE
                TO_DATE(current_date, 'DD/MM/YYYY') - TO_DATE(trunc(dp.createddatetime), 'DD/MM/YYYY')
        END
    ) AS daysdiff
FROM
    deadstockreport dp
WHERE
    1 = 1
    AND outletcode = '621011'


    --The logic for aging
    AND (
        CASE
            WHEN (
                SELECT
                    trunc(last_received) as
                FROM
                    t_pi_part_default_bin
                WHERE
                    partid = dp.partid
                    AND outletid = dp.outletid
            ) IS NOT NULL THEN
                TO_DATE(current_date, 'DD/MM/YYYY') - TO_DATE((
                    SELECT
                        trunc(last_received)
                    FROM
                        t_pi_part_default_bin
                    WHERE
                        partid = dp.partid
                        AND outletid = dp.outletid
                ), 'DD/MM/YYYY')
            WHEN (
                SELECT
                    trunc(last_received)
                FROM
                    t_pi_part_default_bin
                WHERE
                    partid = dp.partid
                    AND outletid = dp.outletid
            ) IS NULL
                 AND (
                SELECT
                    trunc(last_issued)
                FROM
                    t_pi_part_default_bin
                WHERE
                    partid = dp.partid
                    AND outletid = dp.outletid
            ) IS NOT NULL THEN
                TO_DATE(current_date, 'DD/MM/YYYY') - TO_DATE((
                    SELECT
                        trunc(last_issued)
                    FROM
                        t_pi_part_default_bin
                    WHERE
                        partid = dp.partid
                        AND outletid = dp.outletid
                ), 'DD/MM/YYYY')
            ELSE
                TO_DATE(current_date, 'DD/MM/
YYYY') - TO_DATE(trunc(dp.createddatetime), 'DD/MM/YYYY')
        END
    ) < 180 + 1
ORDER BY
    dp.outletcode,
    dp.partno ASC