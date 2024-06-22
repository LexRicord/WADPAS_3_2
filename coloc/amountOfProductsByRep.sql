use coloc_wadpas;

--1.объем заказов опр. REP
select distinct o.MFR, o.REP,
	SUM(o.qty) OVER (order by o.MFR, o.REP RANGE UNBOUNDED PRECEDING)
	as amountOfProductsByRep
	from orders o
			join salesreps s ON s.empl_num = o.rep;