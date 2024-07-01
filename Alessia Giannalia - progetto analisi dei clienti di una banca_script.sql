create database progetto;

create view progetto.parte_1 as
select
    c.id_cliente,
    timestampdiff(year,c.data_nascita,current_date()) as "età",
    count(distinct co.id_conto) as "num_totale_conti",
    count(case when tc.desc_tipo_conto = "Conto Base" then 1 end) as "conti_base",
    count(case when tc.desc_tipo_conto = "Conto Business" then 1 end) as "conti_business",
    count(case when tc.desc_tipo_conto = "Conto Privati" then 1 end) as "conti_privati",
    count(case when tc.desc_tipo_conto = "Conto Famiglie" then 1 end) as "conti_famiglie"
from banca.cliente c
inner join banca.conto co 
on c.id_cliente = co.id_cliente
inner join banca.tipo_conto tc 
on co.id_tipo_conto = tc.id_tipo_conto
group by 1 ;                 
                    
 create view progetto.parte_2 as                    
  select 
    c.id_cliente,
    
	sum(case when tt.segno = "-" then 1 else 0 end) as "num_transazioni_uscita",
    
    sum(case when tt.segno = "+" then 1 else 0 end) as "num_transazioni_entrata",
    
    sum(case when tt.segno = "-" then t.importo else 0 end) as "importo_uscita",
    
    sum(case when tt.segno = "+" then t.importo else 0 end) as "importo_entrata",
    
    sum(case when tt.desc_tipo_trans = "Acquisto su Amazon" then 1 else 0 end) as "acquisti_amazon",
    sum(case when tt.desc_tipo_trans = "Rata mutuo" then 1 else 0 end) as "rata_mutuo",
    sum(case when tt.desc_tipo_trans = "Hotel" then 1 else 0 end) as "hotel",
    sum(case when tt.desc_tipo_trans = "Biglietto aereo" then 1 else 0 end) as "biglietto_aereo",
    sum(case when tt.desc_tipo_trans = "Supermercato" then 1 else 0 end) as "supermercato",
    
    sum(case when tt.desc_tipo_trans = "Stipendio" then 1 else 0 end) as "entrte_stipendio",
    sum(case when tt.desc_tipo_trans = "Pensione" then 1 else 0 end) as  "entrate_pensione",
    sum(case when tt.desc_tipo_trans = "Dividendi" then 1 else 0 end) as "entrate_dividendi",
    
	sum(case when tt.segno = "-" and tc.desc_tipo_conto = "Conto Base" then t.importo else 0 end) as "importo_uscita_cbase",
    sum(case when tt.segno = "-" and tc.desc_tipo_conto = "Conto Business" then t.importo else 0 end) as "importo_uscita_cbusiness",
    sum(case when tt.segno = "-" and tc.desc_tipo_conto = "Conto Privati" then t.importo else 0 end) as "importo_uscita_cprivati",
    sum(case when tt.segno = "-" and tc.desc_tipo_conto = "Conto Famiglie" then t.importo else 0 end) as "importo_uscita_cfamiglie",
    
    sum(case when tt.segno = "+" and tc.desc_tipo_conto = "Conto Base" then t.importo else 0 end) as "importo_entrata_cbase",
    sum(case when tt.segno = "+" and tc.desc_tipo_conto = "Conto Business" then t.importo else 0 end) as "importo_entrata_cbusiness",
    sum(case when tt.segno = "+" and tc.desc_tipo_conto = "Conto Privati" then t.importo else 0 end) as "importo_entrata_cprivati",
    sum(case when tt.segno = "+" and tc.desc_tipo_conto = "Conto Famiglie" then t.importo else 0 end) as "importo_entrata_cfamiglie"
from banca.cliente c
left join banca.conto co 
on c.id_cliente = co.id_cliente
left join banca.tipo_conto tc 
on co.id_tipo_conto = tc.id_tipo_conto
left join banca.transazioni t 
on co.id_conto = t.id_conto
left join banca.tipo_transazione tt 
on t.id_tipo_trans = tt.id_tipo_transazione
group by 1 ;           

create table progetto.tabella_analisi as (
select 
p1.id_cliente,
p1.età,
p2.num_transazioni_uscita,
p2.num_transazioni_entrata,
p2.importo_uscita,
p2.importo_entrata,
p1.num_totale_conti,
p1.conti_base, 
p1.conti_business, 
p1.conti_privati, 
p1.conti_famiglie,
p2.acquisti_amazon,
p2.rata_mutuo,
p2.hotel,
p2.biglietto_aereo, 
p2.supermercato,
p2.entrte_stipendio,
p2.entrate_pensione, 
p2.entrate_dividendi,  
p2.importo_uscita_cbase,
p2.importo_uscita_cbusiness,
p2.importo_uscita_cprivati,
p2.importo_uscita_cfamiglie,
p2.importo_entrata_cbase, 
p2.importo_entrata_cbusiness,
p2.importo_entrata_cprivati, 
p2.importo_entrata_cfamiglie
from progetto.parte_1  p1
left join progetto.parte_2  p2
on p1.id_cliente=p2.id_cliente
)