           SELECT   v_date,
                    s.br_code,
                    s.p_code,
                    p.p_name,
                    p.cat_type,
                    p.cat_name,
                    P.SUB_CAT_NAME,
--                    GET_LAST_PUR_MRP(s.br_code,s.p_code) lst_pur_mrp,
                    DECODE(SUBSTR(DOC_TYPE,1,1),'A','ADJ','SALE') DTYPE,
                    ROUND (SUM (DECODE (s.ri, 'I', inv_qty, 'R', -inv_qty))
                          ) sal_qty,
                    ROUND (SUM (DECODE (s.ri,
                                        'I', s.net_sale_value,
                                        'R', -s.net_sale_value
                                       )
                               )
                          ) sal_amt,
                    ROUND (SUM (DECODE (s.ri,
                                        'I', s.net_sale_value - amount,
                                        'R', -s.net_sale_value + amount
                                       )
                               )
                          ) gp_amt
               FROM both_invkey s, vu_product_master p
              WHERE s.doc_type IN ('SO', 'SC', 'SR','AJ')
--                AND S.BR_CODE='SANK'
                AND s.p_code = p.p_code
                and p.CAT_CODE = 13
                AND s.v_date >= TRUNC (SYSDATE - 31)
                AND s.v_date <= TRUNC (SYSDATE - 1)
              group by  s.p_code,
                    s.br_code,
                    s.p_code,
                    p.p_name,
                    s.v_date,
                    p.cat_name,
                    p.sub_cat_name,
                    p.cat_type,
                    DECODE(SUBSTR(DOC_TYPE,1,1),'A','ADJ','SALE')
  
