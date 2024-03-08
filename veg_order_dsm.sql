           SELECT   v_date,
                    s.br_code,
                    s.p_code,
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
               FROM both_invkey s, product_master p
              WHERE s.doc_type IN ('SO', 'SC', 'SR')
                AND S.BR_CODE='SANK'
                AND s.p_code = p.p_code
                and p.CAT_CODE = 13
                AND s.v_date >= TRUNC (SYSDATE - 31)
                AND s.v_date <= TRUNC (SYSDATE - 1)
              group by  s.p_code,
                    s.br_code,
                    s.v_date                    
