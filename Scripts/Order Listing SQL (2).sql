SELECT
	pom.poid,
	pom.pono,
	pom.createdby,
	pom.createddatetime,
	pom.suppliercode,
	pom.updatedby,
	pom.remarks,
	pom.status,
	ppd.partid,
	ppd.partno,
	ppd.etadate,
	ppd.remarks,
	ppd.orderqty,
	ppd.unitavgcost,
	ppd.unitpoiscost,
	ppd.totalavgcost,
	ppd.totalpoiscost,
	ppm.partdesc,
	ppm.uomcode,
	potm.ordertypedesc,
	ppd.status,
	gdb.qtyrcvd,
	tom.outletcode,
	tom.outletname,
	pptm.parttypecode
FROM
	t_pi_po_mstr          pom
	LEFT JOIN t_pi_po_dtl           ppd ON pom.poid = ppd.poid
	LEFT JOIN t_pi_gin_dtl_bin      gdb ON ppd.poid = gdb.poid
									  AND ppd.partid = gdb.partid,
	t_pi_part_mstr        ppm,
	t_pi_parttype_mstr    pptm,
	t_pi_ordertype_mstr   potm,
	t_outlet_mstr         tom
WHERE
	1 = 1
	AND tom.recstatus = 1
	AND pom.outletcode IN :param
	AND pom.createddatetime >= to_date(:param2, 'DD/MM/YYYY')
	AND pom.createddatetime <= to_date(:param3, 'DD/MM/YYYY')
	AND pom.status IN (
		:param4
	)
	AND ppm.parttypeid = pptm.parttypeid
	AND ppd.partid = ppm.partid
	AND pom.ordertypeid = potm.ordertypeid
	AND tom.outletcode = pom.outletcode