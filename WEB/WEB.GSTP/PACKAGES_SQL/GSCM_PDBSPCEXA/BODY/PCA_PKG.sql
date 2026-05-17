--------------------------------------------------------
--  DDL for Package Body PCA_PKG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PCA_PKG" is

  --Kiem tra thong tin can bo co phai dang nghi phep, theo ID_CAN_BO & ngay kt
 FUNCTION fn_CHECK_CB_DANG_NGHI_PHEP(
   p_ID_CAN_BO DM_CANBO.Id%TYPE,
   p_NGAY varchar2
   ) RETURN NUMBER IS
  nResult NUMBER:=0;
  BEGIN
   SELECT COUNT(*) 
   INTO nResult
   FROM  DM_CANBO t
   WHERE t.id=p_ID_CAN_BO
   and t.hieuluc = 2;
      -- AND p_NGAY BETWEEN t.tu_ngay AND t.den_ngay AND t.da_duyet='Y';
    RETURN nResult;
    EXCEPTION
      WHEN OTHERS THEN
    RETURN 0;
  END;

   --Kiem tra thong tin can bo co phai dang tam ngung cong tac
 FUNCTION fn_CHECK_CB_TAM_NGUNG_CT(
   p_ID_CAN_BO DM_CANBO.Id%TYPE,
   p_NGAY varchar2
   ) RETURN NUMBER IS
  nResult NUMBER:=0;
  BEGIN
   SELECT COUNT(*) 
   INTO nResult
   FROM DM_CANBO  t
   WHERE t.id=p_ID_CAN_BO
      AND t.hieuluc in (0,3);
    RETURN nResult;
    EXCEPTION
      WHEN OTHERS THEN
    RETURN 0;
  END;

   --Kiem tra thong tin co phai tham phan da tung tham gi xet xu
  FUNCTION fn_CHECK_CB_DA_THAM_GIA_XX(
    p_ID_CAN_BO DM_CANBO.Id%TYPE,
    p_id_vu_an ADS_DON.ID%TYPE,
    p_loai_an varchar2
    ) RETURN NUMBER IS
  nResult NUMBER:=0;
  BEGIN
    CASE p_loai_an
      when 'DS' then
            SELECT COUNT(*) 
                 INTO nResult
                 FROM
                      (SELECT dss.donid
                        FROM ADS_SOTHAM_HDXX dss WHERE dss.donid=p_id_vu_an AND dss.canboid=p_ID_CAN_BO
                       union all
                        SELECT dsp.donid
                        FROM ADS_PHUCTHAM_HDXX dsp WHERE dsp.donid=p_id_vu_an AND dsp.canboid=p_ID_CAN_BO);
     when 'HC' then   
           SELECT COUNT(*) 
                 INTO nResult
                 FROM
                 (SELECT hcs.donid
                    FROM AHC_SOTHAM_HDXX hcs WHERE hcs.donid=p_id_vu_an AND hcs.canboid=p_ID_CAN_BO 
                    union all
                    SELECT hcp.donid
                    FROM AHC_PHUCTHAM_HDXX hcp WHERE hcp.donid=p_id_vu_an AND hcp.canboid=p_ID_CAN_BO);
     when 'HN' then                
           SELECT COUNT(*) 
                 INTO nResult
                 FROM
                        (SELECT hns.donid
                        FROM AHN_SOTHAM_HDXX hns WHERE hns.donid=p_id_vu_an AND hns.canboid=p_ID_CAN_BO 
                        union all
                        SELECT hnp.donid
                        FROM AHN_PHUCTHAM_HDXX hnp WHERE hnp.donid=p_id_vu_an AND hnp.canboid=p_ID_CAN_BO);
      when 'HS' then                   
           SELECT COUNT(*) 
                 INTO nResult
                 FROM
                      (SELECT hss.vuanid
                        FROM AHS_SOTHAM_HDXX hss WHERE hss.vuanid = p_id_vu_an AND hss.canboid=p_ID_CAN_BO 
                        union all
                        SELECT hsp.vuanid
                        FROM AHS_PHUCTHAM_HDXX hsp WHERE hsp.vuanid=p_id_vu_an AND hsp.canboid=p_ID_CAN_BO);
       when 'KT' then   
           SELECT COUNT(*) 
                 INTO nResult
                 FROM
                      (SELECT kts.donid
                        FROM AKT_SOTHAM_HDXX kts WHERE kts.donid = p_id_vu_an AND kts.canboid=p_ID_CAN_BO 
                        union all
                        SELECT ktp.donid
                        FROM AKT_PHUCTHAM_HDXX ktp WHERE ktp.donid=p_id_vu_an AND ktp.canboid=p_ID_CAN_BO);
       when 'LD' then                 
           SELECT COUNT(*) 
                 INTO nResult
                 FROM
                      (SELECT lds.donid
                        FROM ALD_SOTHAM_HDXX lds WHERE lds.donid = p_id_vu_an AND lds.canboid=p_ID_CAN_BO 
                        union all
                        SELECT ldp.donid
                        FROM ALD_PHUCTHAM_HDXX ldp WHERE ldp.donid=p_id_vu_an AND ldp.canboid=p_ID_CAN_BO);
        when 'PS' then  
           SELECT COUNT(*) 
                 INTO nResult
                 FROM
                      (SELECT pss.donid
                        FROM APS_SOTHAM_HDXX pss WHERE pss.donid = p_id_vu_an AND pss.canboid=p_ID_CAN_BO 
                        union all
                        SELECT psp.donid
                        FROM APS_PHUCTHAM_HDXX psp WHERE psp.donid=p_id_vu_an AND psp.canboid=p_ID_CAN_BO);
        when 'XLHC' then   
           SELECT COUNT(*) 
                 INTO nResult
                 FROM
                      (SELECT xlchs.donid
                        FROM XLHC_SOTHAM_HDXX xlchs WHERE xlchs.donid = p_id_vu_an AND xlchs.canboid=p_ID_CAN_BO 
                        union all
                        SELECT xlchp.donid
                        FROM XLHC_PHUCTHAM_HDXX xlchp WHERE xlchp.donid=p_id_vu_an AND xlchp.canboid=p_ID_CAN_BO);
        else
          nResult := 0;
        END CASE;                  

    RETURN nResult;
    EXCEPTION
      WHEN OTHERS THEN
    RETURN 0;
  END;

   --Kiem tra thong tin can bo sap het nhiem ky, theo ID_CAN_BO & ngay kt
 FUNCTION fn_TINH_NGAY_NGHI_HUU(
   p_ID_CAN_BO DM_CANBO.Id%TYPE,
   p_NGAY varchar2) 
   RETURN NUMBER IS
  nResult NUMBER:=0;
  v_Ngay_NN VARCHAR2(8);
  BEGIN
   select NVL(to_char(t.ngayketthuc, 'YYYYMMDD') ,to_char(ADD_MONTHS(t.ngaybonhiem, 5*12),'YYYYMMDD'))
   INTO v_Ngay_NN
   FROM  DM_CANBO t 
   WHERE t.id=p_ID_CAN_BO;

    --
   select to_date(v_Ngay_NN,'YYYYMMDD') - to_date(p_NGAY,'YYYYMMDD') INTO nResult from dual; --cost 2
      IF nResult IS NULL
        THEN 
          RETURN 0;
       Else   
          RETURN nResult;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
    RETURN 0;
  END;

  --
FUNCTION fn_CHECK_TL_AN_PC_MIN(
  p_ID_CAN_BO DM_CANBO.Id%TYPE,
  p_ID_TOA_AN DM_TOAAN.ID%TYPE,
  p_NGAY varchar2) 
  RETURN NUMBER IS
  nResult NUMBER:=0;
  nTyLePCA_min NUMBER:=0;
  nTyLePCA_TP NUMBER:=0;
  nTongSoAn_PC NUMBER:=0;
  nSL_TP_ChuaPC NUMBER:=0;
  BEGIN
   --Tinh tong so luong an da duoc phan cong trong nam 
    select COUNT(t.id_vu_an)  
    INTO nTongSoAn_PC
    from pca_qlxx_phan_cong_an t 
        WHERE SUBSTR(t.ngay_phan_cong,1,4)=substr(p_NGAY,1,4)
        and t.id_toa_xx = p_ID_TOA_AN
        AND t.ma_giai_doan <> 1;
   IF  nTongSoAn_PC >0 THEN   
     --Kiem tra xem con tham phan chua duoc phan cong an trong nam
      select COUNT(*) INTO nSL_TP_ChuaPC
      from DM_CANBO t 
      inner join DM_DATAITEM d on t.chucdanhid = d.id
      WHERE 
      t.toaanid=p_ID_TOA_AN 
      AND t.hieuluc = 1 
      AND t.ngaybonhiem <=p_NGAY
      AND d.ma in ('TPSC','TPTC','TPCC')
      AND NOT EXISTS 
      (SELECT * FROM pca_qlxx_phan_cong_an p WHERE p.id_toa_xx=p_ID_TOA_AN AND substr(p.ngay_phan_cong,1,4)=substr(p_NGAY,1,4) 
      AND p.id_tham_phan_ct=t.id AND p.ma_giai_doan <> 1) ;
      IF nSL_TP_ChuaPC>0
        THEN nTyLePCA_min:=0;
      ELSE
             --Tinh ty le an duoc phan cong nho nhat theo nam
             SELECT round(nvl(MIN(sl_pca/tongso),0),3)
             INTO nTyLePCA_min
              FROM(
                  select COUNT(t.id_vu_an) sl_pca,
                  nTongSoAn_PC AS tongso,
                  t.id_tham_phan_ct from pca_qlxx_phan_cong_an t 
                  WHERE SUBSTR(t.ngay_phan_cong,1,4)=substr(p_NGAY,1,4)
                  and t.id_toa_xx = p_ID_TOA_AN
                  AND t.ma_giai_doan <>1
                  GROUP BY t.id_tham_phan_ct
                  );
       END IF;           
          --Tinh ty le an da phan cong cua 1 tham phan trong nam
          SELECT round(nvl(MIN(sl_pca/tongso),0),3)
          INTO nTyLePCA_TP
          FROM(
              select COUNT(t.id_vu_an) sl_pca,
              (
               select COUNT(t.id_vu_an)  from pca_qlxx_phan_cong_an t 
                  WHERE SUBSTR(t.ngay_phan_cong,1,4)=substr(p_NGAY,1,4)
                  AND t.id_toa_xx = p_ID_TOA_AN
                  AND t.ma_giai_doan <> 1
              )AS tongso,
              t.id_tham_phan_ct from pca_qlxx_phan_cong_an t 
              WHERE SUBSTR(t.ngay_phan_cong,1,4)=substr(p_NGAY,1,4)
              AND t.id_tham_phan_ct =p_ID_CAN_BO
              AND t.id_toa_xx = p_ID_TOA_AN
              AND t.ma_giai_doan <> 1
              GROUP BY t.id_tham_phan_ct
              );    

    --
      IF nTyLePCA_TP <=   nTyLePCA_min THEN
        nResult:=1;
      ELSE
        nResult:=nTyLePCA_TP;
      END IF;       
   ELSE
       nResult:=1;
   END IF;    

    RETURN nResult;
    EXCEPTION
      WHEN OTHERS THEN
    RETURN 0;
  END;

--Kiem ta Tham phan co duoc phan cong theo toa chuyen trach khong  
FUNCTION fn_CHECK_PC_THEO_TOA_CHTR(
  p_ID_CAN_BO DM_CANBO.Id%TYPE,
  p_LOAI_AN varchar2 
  ) RETURN NUMBER IS
  nResult NUMBER:=0;
  nCount NUMBER:=0;

  BEGIN
   select COUNT(*)
   INTO  nCount
   from  (select t.id, (case t.ishinhsu when 1 then 'HS' else null end) as CTR from dm_canbo t where t.id = p_ID_CAN_BO
          union
          select t.id, (case t.ishngd when 1 then 'HN' else null end) as CTR from dm_canbo t where t.id = p_ID_CAN_BO
          union
          select t.id, (case t.iskdtm when 1 then 'KT' else null end) as CTR from dm_canbo t where t.id = p_ID_CAN_BO
          union
          select t.id, (case t.isdansu when 1 then 'DS' else null end) as CTR from dm_canbo t where t.id = p_ID_CAN_BO
          union
          select t.id, (case t.ishanhchinh when 1 then 'HC' else null end) as CTR from dm_canbo t where t.id = p_ID_CAN_BO
          union
          select t.id, (case t.islaodong when 1 then 'LD' else null end) as CTR from dm_canbo t where t.id = p_ID_CAN_BO
          union
          select t.id, (case t.isphasan when 1 then 'PS' else null end) as CTR from dm_canbo t where t.id = p_ID_CAN_BO
          union
          select t.id, (case t.isbpxlhc when 1 then 'XLHC' else null end) as CTR from dm_canbo t where t.id = p_ID_CAN_BO) v     
   WHERE v.CTR = p_LOAI_AN;
  IF nCount>0 THEN
    nResult:=1;
  ELSE
      nResult:=0;
  END IF;
    RETURN nResult;
    EXCEPTION
      WHEN OTHERS THEN
    RETURN 0;
  END; 

FUNCTION fn_TINH_TL_AN_DA_PC(
  p_ID_CAN_BO DM_CANBO.ID%TYPE,
  p_ID_TOA_AN DM_TOAAN.ID%TYPE,
  p_NGAY varchar2,
  p_loai_pc number) 
  RETURN NUMBER 
  IS
  nResult NUMBER:=0;

  nTyLePCA_TP NUMBER:=0;
  nTongSoAn_PC NUMBER:=0;
  BEGIN
   --Tinh tong so luong an da duoc phan cong trong nam 
       IF p_loai_pc > 1 THEN
        select COUNT(t.id_vu_an)  
        INTO nTongSoAn_PC
        from pca_qlxx_phan_cong_an t 
            WHERE SUBSTR(t.ngay_phan_cong,1,4)=substr(p_NGAY,1,4)
            and t.id_toa_xx = p_ID_TOA_AN
            AND t.ma_giai_doan <> 1;
        ELSE    
          select COUNT(t.id_vu_an)  
        INTO nTongSoAn_PC
        from pca_qlxx_phan_cong_an t 
            WHERE SUBSTR(t.ngay_phan_cong,1,4)=substr(p_NGAY,1,4)
            and t.id_toa_xx = p_ID_TOA_AN
            AND t.ma_giai_doan = 1;
         END IF;   
   IF  nTongSoAn_PC >0 THEN    
     --Tinh ty le an da phan cong cua 1 tham phan trong nam

         IF p_loai_pc > 1 THEN
        SELECT  COUNT(t.id_vu_an)/nTongSoAn_PC   
         INTO nTyLePCA_TP
         from pca_qlxx_phan_cong_an t 
                WHERE SUBSTR(t.ngay_phan_cong,1,4)=substr(p_NGAY,1,4)    
                AND t.id_tham_phan_ct =p_ID_CAN_BO 
                AND t.ma_giai_doan<>1 ;
        ELSE    
          SELECT  COUNT(t.id_vu_an)/nTongSoAn_PC   
         INTO nTyLePCA_TP
         from pca_qlxx_phan_cong_an t 
                WHERE SUBSTR(t.ngay_phan_cong,1,4)=substr(p_NGAY,1,4)    
                AND t.id_tham_phan_ct =p_ID_CAN_BO 
                AND t.ma_giai_doan=1 ;
         END IF;      

    --


       IF    nTyLePCA_TP=0 THEN 
          nResult:=0.003;
          ELSE
            nResult:=nTyLePCA_TP;
          END IF;  
   ELSE
       nResult:=0.003;
   END IF;    

    RETURN nResult;
    EXCEPTION
      WHEN OTHERS THEN
    RETURN -9999;
  END;   

  PROCEDURE pr_get_data_calc(
    p_calc_date pca_calc_expr.calc_date%TYPE,
    p_ID_VU_AN pca_calc_expr.ID_VU_AN%TYPE,
    p_id_can_bo pca_calc_expr.id_can_bo%TYPE ,
    p_loai_an pca_calc_expr.loai_an%type,
    p_id_toa_an pca_calc_expr.id_toa_an%type,
    p_ma_giai_doan pca_calc_expr.ma_giai_doan%TYPE,
    p_rule_id VARCHAR2,
    p_frm_no NUMBER,
    p_calc_id OUT NUMBER) 
    IS
  nCalc_ID NUMBER;
  BEGIN
SELECT SQ_PCA_CALC_EXPR.nextval INTO nCalc_ID FROM dual; --lay process_ID
INSERT INTO pca_calc_expr
      (calc_id, 
      calc_date, 
      id_can_bo, 
      rule_id, 
      cond_o, 
      result_o, 
      cond_new, 
      result_new,  
      frm_no, 
      calc_status, 
      id_vu_an, 
      expr_line,
      loai_an,
      id_toa_an,
      ma_giai_doan)   
SELECT nCalc_ID,
       p_calc_date,
       p_id_can_bo,
       t.rule_id,
       t.cond, 
       t.result, 
       t.cond, 
       t.result, 
       t.frm_no,
       'INIT',
       p_id_vu_an, 
       t.expr_line,
       p_loai_an,
       p_id_toa_an,
       p_ma_giai_doan
from pca_expr t
WHERE t.rule_id=p_rule_id AND t.frm_no=p_frm_no AND t.is_active=1
    AND t.value_date=(
                      SELECT MAX(t.value_date)
                      from pca_expr t
                      WHERE t.rule_id=p_rule_id AND t.frm_no=p_frm_no
                      AND t.is_active=1
                      AND trunc(t.value_date)<=trunc(p_calc_date)
                     )
UNION 
SELECT nCalc_ID,
       p_calc_date,
       p_id_can_bo,
       tp.rule_id,
       tp.cond, 
       tp.result, 
       tp.cond, 
       tp.result, 
       tp.frm_no,
       'INIT',
       p_id_vu_an, 
       tp.expr_line,
       p_loai_an,
       p_id_toa_an,
       p_ma_giai_doan
from pca_expr tp
WHERE tp.su_dung = 1 AND (INSTR(p_rule_id, tp.rule_id)> 0 )                   
;
COMMIT;
p_calc_id:=nCalc_ID;
  END;

PROCEDURE pr_replace_element(
  p_calc_id  IN NUMBER) 
  IS
    cs         SYS_REFCURSOR;
    cs_sde     SYS_REFCURSOR;
    v_exec_str VARCHAR2(2000);
    v_result   NUMBER;
    --
    v_exec_str2 VARCHAR2(2000);
    v_result2   NUMBER;
    --
    v_new_expr   VARCHAR2(2000);
    v_new_calc   VARCHAR2(2000);
    --
    v_sde_id    VARCHAR2(50);
    v_sde_value NUMBER;
    --
     v_id_can_bo pca_calc_expr.id_can_bo%TYPE;
     v_ID_VU_AN pca_calc_expr.ID_VU_AN%TYPE;
     v_loai_an pca_calc_expr.loai_an%type;
     v_id_toa_an pca_calc_expr.id_toa_an%type;
     v_ma_giai_doan pca_calc_expr.ma_giai_doan%type;
     v_rule_id    pca_calc_expr.rule_id%TYPE;
     n_frm_no     pca_calc_expr.frm_no%TYPE;
     n_expr_line  pca_calc_expr.expr_line%TYPE;
     v_cond_new   pca_calc_expr.cond_new%TYPE;
     v_result_new pca_calc_expr.result_new%TYPE;
    -- v_ID_VU_AN    pca_calc_expr.ID_VU_AN%TYPE;
  BEGIN
    OPEN cs FOR
    --Doc cong thuc tinh lai
      SELECT t.id_can_bo,
             t.rule_id ,
             t.frm_no,
             t.expr_line,
             t.cond_new,
             t.result_new,
             t.ID_VU_AN,
             t.loai_an,
             t.id_toa_an,
             t.ma_giai_doan
      from pca_calc_expr t
      WHERE t.calc_id=p_calc_id
      ORDER BY t.expr_line;

    LOOP
      FETCH cs
        INTO v_id_can_bo,
             v_rule_id,
             n_frm_no,
             n_expr_line,
             v_cond_new,
             v_result_new,
             v_ID_VU_AN,
             v_loai_an,
             v_id_toa_an,
             v_ma_giai_doan;
      EXIT WHEN cs%NOTFOUND;
      ---------------------
      --dbms_output.put_line('ID_CAN_BO: '||v_id_can_bo||'--'||v_rule_id||'--'||n_expr_line||'--'||v_cond_new||'--'||v_result_new||'--'||v_ID_VU_AN||'--t-'||v_ma_giai_doan);

      --lay danh sach SDE element

      OPEN cs_sde FOR
           SELECT DISTINCT re.element_id
          FROM pca_rule_frm_elements re
         WHERE re.rule_id = v_rule_id
           AND re.element_type = 'S'
           AND re.frm_no = n_frm_no
           AND re.IS_ACTIVE='Y'
           ;
      LOOP
        FETCH cs_sde
          INTO v_sde_id;
        EXIT WHEN cs_sde%NOTFOUND;
        ---------------------
        --dbms_output.put_line(cs_sde||'-->'||v_UDE_value);
           CASE v_sde_id
          WHEN 'NGHI_PHEP' THEN
            v_sde_value := fn_CHECK_CB_DANG_NGHI_PHEP(v_ID_CAN_BO ,to_char(SYSDATE,'YYYYMMDD') );
           WHEN 'NGAY_NGHI_HUU' THEN
            v_sde_value := fn_TINH_NGAY_NGHI_HUU(v_ID_CAN_BO ,to_char(SYSDATE,'YYYYMMDD') );
            WHEN 'TAM_DUNG_CT' THEN
            v_sde_value := fn_CHECK_CB_TAM_NGUNG_CT(v_ID_CAN_BO ,to_char(SYSDATE,'YYYYMMDD') );
            WHEN 'DA_THAM_GIA_XX' THEN
            v_sde_value := fn_CHECK_CB_DA_THAM_GIA_XX(v_ID_CAN_BO,v_ID_VU_AN,v_loai_an);
            /* WHEN 'TL_AN_TON' THEN
            v_sde_value := fn_TINH_TL_AN_TON(v_ID_CAN_BO,to_char(SYSDATE,'YYYYMMDD') );
            WHEN 'CO_AN_MOI_PC' THEN
            v_sde_value := 0;
            --
            WHEN 'TL_AN_PC_MIN' THEN
                v_sde_value := fn_CHECK_TL_AN_PC_MIN(v_ID_CAN_BO ,to_char(SYSDATE,'YYYYMMDD') );*/
            WHEN 'TL_AN_PC_THEO_TOA_CHTR' THEN
                v_sde_value := fn_CHECK_PC_THEO_TOA_CHTR(v_ID_CAN_BO,v_loai_an);
            WHEN 'SO_NGAY_CHUA_PC_MAX' THEN
                v_sde_value := 1;
            WHEN 'TL_AN_DA_PC' THEN
                v_sde_value := fn_TINH_TL_AN_DA_PC(v_ID_CAN_BO, v_id_toa_an,to_char(SYSDATE,'YYYYMMDD'),v_ma_giai_doan );
             /*WHEN 'DIEM_SO' THEN    
                v_sde_value := 100;       
             WHEN 'TEST' THEN
                v_sde_value := 1; */            
          ELSE
            v_sde_value := -999999; --not found       

        END CASE;
        IF v_sde_value <> -999999 THEN
          v_new_expr := REPLACE(v_cond_new,
                                v_sde_id,
                                '(' ||
                                to_char(v_sde_value,
                                        '999999999999999999.9999') || ')');
          v_cond_new := v_new_expr;
          --
          v_new_calc   := REPLACE(v_result_new,
                                  v_sde_id,
                                  '(' ||
                                  to_char(v_sde_value,
                                          '999999999999999999.9999') || ')');
          v_result_new := v_new_calc;
        END IF;
        --

      END LOOP;

      --update bang tam

      --Tinh Quyen loi bao hiem
      BEGIN

        v_exec_str := 'SELECT CASE WHEN ' || v_new_expr || ' THEN 1 ' ||
                      ' ELSE 0  END CASE from dual';
       -- dbms_output.put_line('SQL: ' || v_exec_str);
        -- v_exec_str:=REPLACE(v_exec_str,',','.');
        EXECUTE IMMEDIATE v_exec_str
          INTO v_result;
        --dbms_output.put_line('Ket qua exec cong thuc: ' ||                            to_char(v_result));
        IF v_result = 1 THEN

          v_exec_str2 := 'SELECT ' || v_result_new || ' from dual';
          -- v_exec_str2:=REPLACE(v_exec_str2,',','.');
          -- EXECUTE IMMEDIATE v_exec_str INTO v_result;
         -- dbms_output.put_line('Cust_ac_no,Result '||p_cust_ac_no||'->' || to_char(v_exec_str2));
          EXECUTE IMMEDIATE v_exec_str2
            INTO v_result2;
            --v_result2:=fn_amt_round(v_ccy,v_result2);
          --dbms_output.put_line('Ket qua result '||to_char(v_result2));
        ELSE
          v_result2 := NULL;
        END IF;
        COMMIT;     
      END;
      -----------------------------------------------------------
      UPDATE pca_calc_expr tb
         SET tb.cond_new   = v_new_expr,
             tb.result_new = v_result_new,
             tb.VALUES_CALC    = v_result2,
             tb.calc_status  = decode(v_result2,NULL,tb.calc_status,'SUCCESS')
       WHERE tb.calc_id = p_calc_id
         AND tb.frm_no = n_frm_no
         AND tb.rule_id = v_rule_id
         AND tb.expr_line = n_expr_line;

      COMMIT;
    END LOOP;
    --

  END pr_replace_element;  

FUNCTION fn_exec_expr_PCA(
  p_calc_date pca_calc_expr.calc_date%TYPE,
  p_ID_VU_AN pca_calc_expr.ID_VU_AN%TYPE,
  p_loai_an pca_calc_expr.loai_an%type,
  p_id_can_bo pca_calc_expr.id_can_bo%TYPE ,
  p_id_toa_an pca_calc_expr.id_toa_an%type,
  p_ma_giai_doan pca_calc_expr.ma_giai_doan%TYPE,
  p_rule_id VARCHAR2,
  p_frm_no NUMBER) RETURN NUMBER
  IS nResult NUMBER;
  nCalc_ID NUMBER;
BEGIN
  --Goi ham nap cong thuc tinh QBH
  --pr_get_data_calc(p_ngay,p_ma_the_BHYT,p_ma_dvyt,p_rule_id,p_frm_no,nCalc_id);
  pr_get_data_calc(p_calc_date ,p_ID_VU_AN,p_id_can_bo, p_loai_an, p_id_toa_an,p_ma_giai_doan, p_rule_id ,p_frm_no ,nCalc_id);
  --Goi ham Replace cong thuc de tinh QLBH
  pr_replace_element(nCalc_id);
  SELECT nvl(sum(t.values_calc),0) INTO nResult
  FROM pca_calc_expr   t
  WHERE t.calc_id=nCalc_id
    AND t.calc_status='SUCCESS';
  RETURN nResult;
  EXCEPTION
    WHEN OTHERS THEN RETURN -999999;
END;    

 PROCEDURE pr_get_list_tham_phan(
   p_calc_date pca_calc_expr.calc_date%TYPE,
   p_ID_VU_AN pca_calc_expr.ID_VU_AN%TYPE,
   p_loai_an pca_calc_expr.loai_an%type,
   p_id_toa_an pca_calc_expr.id_toa_an%TYPE,
   p_ma_giai_doan pca_calc_expr.ma_giai_doan%TYPE,
   p_rule_id varchar2)
   IS
   cs         SYS_REFCURSOR;
   v_id_can_bo dm_canbo.id%TYPE;
   nResult NUMBER;
   v_calc_id pca_calc_expr.calc_id%TYPE;
   v_tp_cau_hinh NUMBER;
   BEGIN

      OPEN cs FOR
    --Doc cong thuc tinh lai
      select t.id from dm_canbo t 
      inner join dm_dataitem d on t.chucdanhid = d.id
      WHERE t.toaanid=p_id_toa_an 
      AND t.hieuluc <> 0
      and d.ma in ('TPSC','TPTC','TPCC')
      ;

    LOOP
      FETCH cs
        INTO v_id_can_bo;
      EXIT WHEN cs%NOTFOUND;
      --
      nResult:=fn_exec_expr_PCA(p_calc_date,p_ID_VU_AN, p_loai_an, v_id_can_bo, p_id_toa_an, p_ma_giai_doan, p_rule_id||'_KHONG_PC',1);
      --
      select max(t.calc_id)
           INTO v_calc_id
      from pca_calc_expr t WHERE t.id_can_bo=v_id_can_bo AND t.id_vu_an=p_ID_VU_AN;
      --
      IF p_ma_giai_doan > 1
        THEN
         SELECT COUNT(*) INTO v_tp_cau_hinh
         FROM PCA_CAU_HINH_TP kp
             WHERE  kp.id_canbo=v_id_can_bo and kp.id_toaan = p_id_toa_an AND kp.pca_an = 0;                                                                
        ELSE     
         SELECT COUNT(*) INTO v_tp_cau_hinh
         FROM PCA_CAU_HINH_TP kp
             WHERE  kp.id_canbo=v_id_can_bo and kp.id_toaan = p_id_toa_an AND kp.pca_don = 0; 
       END IF;     
       --
      IF nResult >0 OR v_tp_cau_hinh > 0 THEN
        --Truong hop tham phan khong du dieu kien de phan cong an
       INSERT INTO pca_ds_can_bo_khong_pc(ref_id,id_vu_an,id_can_bo,id_toa_an,loai_an, ma_giai_doan)
                    VALUES(v_calc_id,p_ID_VU_AN,v_id_can_bo,p_id_toa_an,p_loai_an, p_ma_giai_doan);
        ELSE
        --Truong hop tham phan co du dieu kien de phan cong an
        INSERT INTO   pca_ds_can_bo_cho_pc(ref_id,id_vu_an,id_can_bo,tong_diem,id_toa_an,loai_an, ma_giai_doan)
                    VALUES(v_calc_id,p_ID_VU_AN,v_id_can_bo,0,p_id_toa_an,p_loai_an, p_ma_giai_doan);

      END IF;
      COMMIT;
    END LOOP;
   END;
  --

PROCEDURE pr_get_list_tham_phan2(
  p_calc_date pca_calc_expr.calc_date%TYPE,
  p_ID_VU_AN pca_calc_expr.ID_VU_AN%TYPE,
  p_loai_an pca_calc_expr.loai_an%type,
  p_id_toa_an pca_calc_expr.id_toa_an%TYPE,
  p_ma_giai_doan pca_ds_can_bo_cho_pc.ma_giai_doan%TYPE)
   IS

   BEGIN


      --1.INSERT INTO pca_ds_can_bo_khong_pc
      INSERT INTO pca_ds_can_bo_khong_pc(ref_id,id_vu_an,id_can_bo,id_toa_an,loai_an, ma_giai_doan)
              SELECT -1,p_ID_VU_AN,id,p_id_toa_an,p_loai_an, p_ma_giai_doan
              FROM(
                      --lay ds Tham phan theo toa
                      --Kiem tra tinh trang bo nhiem: ngay bo nhiem , trang thai cong tac
                      select c.id
                    from
                     (select t.id,t.hieuluc, fn_CHECK_CB_DA_THAM_GIA_XX(t.id,p_ID_VU_AN,p_loai_an) as xx from dm_canbo t 
                      inner join dm_dataitem d on t.chucdanhid = d.id
                      WHERE t.toaanid=p_id_toa_an
                            -- AND to_char(t.ngaybonhiem,'YYYYMMDD') <= p_calc_date
                           -- AND NVL(to_char(t.ngayketthuc,'YYYYMMDD'),p_calc_date) >= (p_calc_date)                          
                            and d.ma in ('TPSC','TPTC','TPCC')) c
                     where c.hieuluc<>1 or c.xx >= 1       

                      )                       ;   
                    COMMIT;

  IF p_ma_giai_doan > 1
        THEN
         --2. INSERT INTO   pca_ds_can_bo_cho_pc
         INSERT INTO   pca_ds_can_bo_cho_pc(ref_id,id_vu_an,id_can_bo,tong_diem,id_toa_an,loai_an, ma_giai_doan)

                SELECT -1,p_ID_VU_AN,id,0,p_id_toa_an,p_loai_an, p_ma_giai_doan
                FROM(
                        --lay ds Tham phan theo toa

                        select t.id from dm_canbo t 
                       inner join dm_dataitem d on t.chucdanhid = d.id
                        WHERE t.toaanid=p_id_toa_an 
                             -- AND to_char(t.ngaybonhiem,'YYYYMMDD') <= p_calc_date
                             -- AND NVL(to_char(t.ngayketthuc,'YYYYMMDD'),p_calc_date) >= (p_calc_date)
                              AND t.hieuluc<>0  
                              and d.ma in ('TPSC','TPTC','TPCC')           
                              AND NOT EXISTS (
                              SELECT 1

                                 FROM  pca_ds_can_bo_khong_pc k
                                 WHERE  k.id_can_bo=t.id AND k.id_vu_an=p_ID_VU_AN and k.loai_an = p_loai_an
                                 )
                               AND NOT EXISTS (
                                 SELECT 1

                                 FROM  PCA_CAU_HINH_TP kp
                                 WHERE  kp.id_canbo=t.id and kp.id_toaan = p_id_toa_an AND kp.pca_an = 0
                                 )  

                        --Kiem tra da tung tham gia xet xu 
                        ); 
   ELSE     
         --2. INSERT INTO   pca_ds_can_bo_cho_pc
         INSERT INTO   pca_ds_can_bo_cho_pc(ref_id,id_vu_an,id_can_bo,tong_diem,id_toa_an,loai_an, ma_giai_doan)

                SELECT -1,p_ID_VU_AN,id,0,p_id_toa_an,p_loai_an, p_ma_giai_doan
                FROM(
                        --lay ds Tham phan theo toa

                        select t.id from dm_canbo t 
                       inner join dm_dataitem d on t.chucdanhid = d.id
                        WHERE t.toaanid=p_id_toa_an 
                             -- AND to_char(t.ngaybonhiem,'YYYYMMDD') <= p_calc_date
                             -- AND NVL(to_char(t.ngayketthuc,'YYYYMMDD'),p_calc_date) >= (p_calc_date)
                              AND t.hieuluc<>0  
                              and d.ma in ('TPSC','TPTC','TPCC')           
                              AND NOT EXISTS (
                              SELECT 1

                                 FROM  pca_ds_can_bo_khong_pc k
                                 WHERE  k.id_can_bo=t.id AND k.id_vu_an=p_ID_VU_AN and k.loai_an = p_loai_an
                                 )
                               AND NOT EXISTS (
                                 SELECT 1

                                 FROM  PCA_CAU_HINH_TP kp
                                 WHERE  kp.id_canbo=t.id and kp.id_toaan = p_id_toa_an AND kp.pca_don = 0
                                 )   

                        --Kiem tra da tung tham gia xet xu 
                        );                
   END IF;                  
   COMMIT;

   END;
--  

PROCEDURE pr_phan_cong_tham_phan(
  p_calc_date pca_calc_expr.calc_date%TYPE,
  p_ID_VU_AN pca_calc_expr.ID_VU_AN%TYPE,
  p_loai_an pca_calc_expr.loai_an%type,
  p_id_toa_an pca_calc_expr.id_toa_an%TYPE,
  p_ma_giai_doan pca_qlxx_phan_cong_an.ma_giai_doan%type,
  p_ten_vu_an pca_qlxx_phan_cong_an.ten_vu_an%TYPE,
  p_id_ql_pca pca_qlxx_phan_cong_an.id_ql_pca%TYPE,
  p_sothuly pca_qlxx_phan_cong_an.so_thu_ly%TYPE,
  p_ngaythuly pca_qlxx_phan_cong_an.ngay_thu_ly%TYPE,
  p_rule_id VARCHAR2
  )
  IS
  cs         SYS_REFCURSOR;
   v_id_can_bo dm_canbo.id%TYPE;
   nResult NUMBER;
   v_calc_id pca_calc_expr.calc_id%TYPE;
  BEGIN

    --Goi ham chuan bi truoc phan cong an
    --pr_get_list_tham_phan2(p_calc_date,p_ID_VU_AN,p_loai_an, p_id_toa_an, p_ma_giai_doan);
    pr_get_list_tham_phan(p_calc_date,p_ID_VU_AN,p_loai_an, p_id_toa_an, p_ma_giai_doan,p_rule_id);
    --Tinh diem doi voi tung tham phan phu hop
    OPEN cs FOR
    --Doc cong thuc tinh lai
      select t.id_can_bo from pca_ds_can_bo_cho_pc t WHERE t.id_vu_an=p_ID_VU_AN AND t.id_toa_an=p_id_toa_an and t.loai_an = p_loai_an ;

    LOOP
      FETCH cs
        INTO v_id_can_bo;
      EXIT WHEN cs%NOTFOUND;
      --
      nResult:=fn_exec_expr_PCA(p_calc_date,p_ID_VU_AN,p_loai_an, v_id_can_bo, p_id_toa_an,p_ma_giai_doan, p_rule_id||'_PCONG_TP',1);
      --
      select max(t.calc_id)
           INTO v_calc_id
      from pca_calc_expr t WHERE t.id_can_bo=v_id_can_bo AND t.id_vu_an=p_ID_VU_AN and t.loai_an = p_loai_an;
      --
      UPDATE pca_ds_can_bo_cho_pc c 
             SET c.tong_diem= round(nResult,2)
      WHERE c.id_vu_an  = p_ID_VU_AN
        AND c.id_can_bo = v_id_can_bo
        AND c.id_toa_an = p_id_toa_an
        and c.loai_an = p_loai_an;

      COMMIT;

    END LOOP;
    --Insert bang diem phan cong  
    INSERT INTO pca_bang_diem_pc
      (ref_id, id_vu_an, id_can_bo, tong_diem, da_duyet, da_phan_cong, id_toa_an, loai_an, ma_giai_doan)
     SELECT ref_id, id_vu_an, id_can_bo, tong_diem, da_duyet, da_phan_cong, id_toa_an, loai_an, ma_giai_doan
     FROM pca_ds_can_bo_cho_pc
     WHERE  id_vu_an = p_ID_VU_AN
     and loai_an = p_loai_an;

    --Insert bang PCA_EXP_LOG
    INSERT INTO pca_calc_expr_log
      (calc_id, calc_date, rule_id, cond_o, result_o, cond_new, result_new, values_calc, frm_no, calc_status, expr_line, id_can_bo, id_vu_an, loai_an, id_toa_an, ma_giai_doan)

    SELECT calc_id, calc_date, rule_id, cond_o, result_o, cond_new, result_new, values_calc, frm_no, calc_status, expr_line, id_can_bo, id_vu_an, loai_an, id_toa_an, ma_giai_doan

      FROM pca_calc_expr
     WHERE id_vu_an=p_ID_VU_AN
     and loai_an = p_loai_an;


    COMMIT;

    --Insert bang phan cong an 
    SELECT nvl(MAX(t.id_can_bo),0)
    INTO v_id_can_bo
    from pca_ds_can_bo_cho_pc t 
    WHERE t.id_vu_an= p_ID_VU_AN
      AND t.id_toa_an = p_id_toa_an
      and t.loai_an = p_loai_an
      AND t.tong_diem=(
     select nvl(MAX(tong_diem),0)  from pca_ds_can_bo_cho_pc  WHERE id_vu_an=p_ID_VU_AN
     AND id_toa_an=p_id_toa_an and loai_an = p_loai_an);
     --
     IF v_id_can_bo >0 THEN

      --vai tro tham phan
    case p_ma_giai_doan
      when 1 then       
        INSERT INTO pca_qlxx_phan_cong_an
        (id_phan_cong_an, lan_xet_xu, id_vu_an, cap_xet_xu, id_tham_phan_ct, trang_thai_pc, ngay_phan_cong, 
        id_toa_xx, loai_an, ma_giai_doan, vai_tro, ten_vu_an,id_ql_pca, so_thu_ly, ngay_thu_ly)
      VALUES
        (SQ_PHAN_CONG_AN.NEXTVAL, 1, p_ID_VU_AN, 'HO_SO', v_id_can_bo, 0, p_calc_date, 
        p_id_toa_an, p_loai_an, 1, 'VTTP_GIAIQUYETDON', p_ten_vu_an,p_id_ql_pca, p_sothuly, p_ngaythuly);

       when 2 then 
        INSERT INTO pca_qlxx_phan_cong_an
        (id_phan_cong_an, lan_xet_xu, id_vu_an, cap_xet_xu, id_tham_phan_ct, trang_thai_pc, ngay_phan_cong, 
        id_toa_xx, loai_an, ma_giai_doan, vai_tro, ten_vu_an,id_ql_pca, so_thu_ly, ngay_thu_ly)
      VALUES
        (SQ_PHAN_CONG_AN.NEXTVAL, 1, p_ID_VU_AN, 'SO_THAM', v_id_can_bo, 0, p_calc_date, 
        p_id_toa_an, p_loai_an, 2, 'VTTP_GIAIQUYETSOTHAM', p_ten_vu_an, p_id_ql_pca, p_sothuly, p_ngaythuly);

      when 3 then
         INSERT INTO pca_qlxx_phan_cong_an
        (id_phan_cong_an, lan_xet_xu, id_vu_an, cap_xet_xu, id_tham_phan_ct, trang_thai_pc, ngay_phan_cong, 
        id_toa_xx, loai_an, ma_giai_doan, vai_tro, ten_vu_an, id_ql_pca, so_thu_ly, ngay_thu_ly)
      VALUES
        (SQ_PHAN_CONG_AN.NEXTVAL, 1, p_ID_VU_AN, 'PHUC_THAM', v_id_can_bo, 0, p_calc_date, 
        p_id_toa_an, p_loai_an, 3, 'VTTP_GIAIQUYETPHUCTHAM', p_ten_vu_an, p_id_ql_pca, p_sothuly, p_ngaythuly);
      end case;      


     COMMIT;
    -- UPDATE dm_vu_an v SET v.tinh_trang_xx='DA_PC' WHERE v.id_vu_an=p_ID_VU_AN;
     --COMMIT;
     END IF;
  END;  

-- danh sach vu an chua phan cong    
 procedure GET_DS_AN_CHO_PC(
   p_giaidoan number,
   p_id_toa_an dm_toaan.id%type,
   p_tu_ngay varchar2,
   p_den_ngay varchar2,
   p_out out sys_refcursor
   )
   as
   v_tungay varchar2(10);
   v_denngay varchar2(10);
   begin
     if p_tu_ngay is not null
       then
         v_tungay := to_char(to_date(p_tu_ngay, 'DD/MM/YYYY'), 'YYYYMMDD');
     end if;  
      if p_den_ngay is not null
       then
         v_denngay:= to_char(to_date(p_den_ngay, 'DD/MM/YYYY'), 'YYYYMMDD');
     end if;    

   if p_giaidoan = 2
       then      
         open p_out FOR
         SELECT bb.*, ROWNUM stt 
         FROM
         (select b.*, c.ten_dm AS loai_an, gd.ten_dm AS giai_doan
         from
         (select *  
                from (SELECT d.mavuviec, d.magiaidoan, d.tenvuviec, d.id, 'DS' as loaian,  
                     to_char(d.ngaytao,'DD/MM/YYYY') as ngaytao, to_char(d.ngaytao,'YYYYMMDD') as ngayorder, 
                     dl.sothuly, to_char(dl.ngaythuly, 'DD/MM/YYYY') ngaythuly from ads_don d
                     INNER JOIN ads_sotham_thuly dl ON d.id = dl.donid
                     where (d.toaanid = p_id_toa_an)

                     UNION ALL
                     SELECT dp.mavuviec, dp.magiaidoan, dp.tenvuviec, dp.id, 'DS' as loaian, 
                     to_char(dp.ngaytao,'DD/MM/YYYY') as ngaytao, to_char(dp.ngaytao,'YYYYMMDD') as ngayorder, 
                     dpl.sothuly, to_char(dpl.ngaythuly, 'DD/MM/YYYY') ngaythuly from ads_don dp
                     INNER JOIN ADS_PHUCTHAM_THULY dpl ON dp.id = dpl.donid
                     where (dp.toaphucthamid = p_id_toa_an)

                     union all
                     SELECT h.mavuviec, h.magiaidoan, h.tenvuviec, h.id, 'HC' as loaian, 
                     to_char(h.ngaytao,'DD/MM/YYYY') as ngaytao, to_char(h.ngaytao,'YYYYMMDD') as ngayorder,
                     hl.sothuly, to_char(hl.ngaythuly, 'DD/MM/YYYY') ngaythuly from ahc_don h
                     INNER JOIN ahc_sotham_thuly hl ON h.id = hl.donid
                     where (h.toaanid = p_id_toa_an)

                     union all
                     SELECT hp.mavuviec, hp.magiaidoan, hp.tenvuviec, hp.id, 'HC' as loaian, 
                     to_char(hp.ngaytao,'DD/MM/YYYY') as ngaytao, to_char(hp.ngaytao,'YYYYMMDD') as ngayorder,
                     hpl.sothuly, to_char(hpl.ngaythuly, 'DD/MM/YYYY') ngaythuly from ahc_don hp
                     INNER JOIN ahc_phuctham_thuly hpl ON hp.id = hpl.donid
                     where (hp.toaphucthamid = p_id_toa_an)

                     union all
                     SELECT n.mavuviec, n.magiaidoan, n.tenvuviec, n.id, 'HN' as loaian, 
                     to_char(n.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(n.ngaytao,'YYYYMMDD') as ngayorder,
                     nl.sothuly, to_char(nl.ngaythuly, 'DD/MM/YYYY') ngaythuly from ahn_don n
                     INNER JOIN ahn_sotham_thuly nl ON n.id = nl.donid
                     where (n.toaanid = p_id_toa_an)

                     union all
                     SELECT np.mavuviec, np.magiaidoan, np.tenvuviec, np.id, 'HN' as loaian, 
                     to_char(np.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(np.ngaytao,'YYYYMMDD') as ngayorder,
                     npl.sothuly, to_char(npl.ngaythuly, 'DD/MM/YYYY') ngaythuly from ahn_don np
                     INNER JOIN ahn_phuctham_thuly npl ON np.id = npl.donid
                     where (np.toaphucthamid = p_id_toa_an)

                     union all
                     SELECT s.mavuan, s.magiaidoan, s.tenvuan, s.id, 'HS' as loaian, 
                     to_char(s.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(s.ngaytao,'YYYYMMDD') as ngayorder,
                     sl.sothuly, to_char(sl.ngaythuly, 'DD/MM/YYYY') ngaythuly from ahs_vuan s
                     INNER JOIN ahs_sotham_thuly sl ON s.id = sl.vuanid
                     where (s.toaanid = p_id_toa_an )

                     union all
                     SELECT sp.mavuan, sp.magiaidoan, sp.tenvuan, sp.id, 'HS' as loaian, 
                     to_char(sp.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(sp.ngaytao,'YYYYMMDD') as ngayorder,
                     spl.sothuly, to_char(spl.ngaythuly, 'DD/MM/YYYY') ngaythuly from ahs_vuan sp
                     INNER JOIN ahs_phuctham_thuly spl ON sp.id = spl.vuanid
                     where (sp.toaphucthamid = p_id_toa_an)

                     union all
                     SELECT t.mavuviec, t.magiaidoan, t.tenvuviec, t.id, 'KT' as loaian, 
                     to_char(t.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(t.ngaytao,'YYYYMMDD') as ngayorder,
                     tl.sothuly, to_char(tl.ngaythuly, 'DD/MM/YYYY') ngaythuly from akt_don t
                     INNER JOIN akt_sotham_thuly tl ON t.id = tl.donid 
                     where (t.toaanid = p_id_toa_an)

                     union all
                     SELECT tp.mavuviec, tp.magiaidoan, tp.tenvuviec, tp.id, 'KT' as loaian, 
                     to_char(tp.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(tp.ngaytao,'YYYYMMDD') as ngayorder,
                     tpl.sothuly, to_char(tpl.ngaythuly, 'DD/MM/YYYY') ngaythuly from akt_don tp
                     INNER JOIN akt_phuctham_thuly tpl ON tp.id = tpl.donid 
                     where (tp.toaphucthamid = p_id_toa_an)

                     union all 
                     SELECT l.mavuviec, l.magiaidoan, l.tenvuviec, l.id, 'LD' as loaian,
                     to_char(l.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(l.ngaytao,'YYYYMMDD') as ngayorder,
                     ll.sothuly, to_char(ll.ngaythuly, 'DD/MM/YYYY') ngaythuly from ald_don l
                     INNER JOIN ald_sotham_thuly ll ON l.id = ll.donid
                     where (l.toaanid = p_id_toa_an)

                     union all 
                     SELECT lp.mavuviec, lp.magiaidoan, lp.tenvuviec, lp.id, 'LD' as loaian,
                     to_char(lp.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(lp.ngaytao,'YYYYMMDD') as ngayorder,
                     lpl.sothuly, to_char(lpl.ngaythuly, 'DD/MM/YYYY') ngaythuly from ald_don lp
                     INNER JOIN ald_phuctham_thuly lpl ON lp.id = lpl.donid
                     where (lp.toaphucthamid = p_id_toa_an)

                     union all 
                     SELECT p.mavuviec, p.magiaidoan, p.tenvuviec, p.id, 'PS' as loaian, 
                     to_char(p.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(p.ngaytao,'YYYYMMDD') as ngayorder,
                     pl.sothuly, to_char(pl.ngaythuly, 'DD/MM/YYYY') ngaythuly from aps_don p
                     INNER JOIN aps_sotham_thuly pl ON p.id = pl.donid 
                     where (p.toaanid = p_id_toa_an)

                     union all 
                     SELECT pp.mavuviec, pp.magiaidoan, pp.tenvuviec, pp.id, 'PS' as loaian, 
                     to_char(pp.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(pp.ngaytao,'YYYYMMDD') as ngayorder,
                     ppl.sothuly, to_char(ppl.ngaythuly, 'DD/MM/YYYY') ngaythuly from aps_don pp
                     INNER JOIN aps_phuctham_thuly ppl ON pp.id = ppl.donid 
                     where (pp.toaphucthamid = p_id_toa_an)

                     union all 
                     SELECT x.mavuviec, x.magiaidoan, x.tenvuviec, x.id, 'XLHC' as loaian,
                     to_char(x.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(x.ngaytao,'YYYYMMDD') as ngayorder,
                     xl.sothuly, to_char(xl.ngaythuly, 'DD/MM/YYYY') ngaythuly from xlhc_don x
                     INNER JOIN xlhc_sotham_thuly xl ON x.id = xl.donid 
                     where (x.toaanid = p_id_toa_an)

                     union all 
                     SELECT xp.mavuviec, xp.magiaidoan, xp.tenvuviec, xp.id, 'XLHC' as loaian, 
                     to_char(xp.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(xp.ngaytao,'YYYYMMDD') as ngayorder,
                     xpl.sothuly, to_char(xpl.ngaythuly, 'DD/MM/YYYY') ngaythuly from xlhc_don xp
                     INNER JOIN xlhc_phuctham_thuly xpl ON xp.id = xpl.donid 
                     where (xp.toaphucthamid = p_id_toa_an)

                     ) a

                where (a.ngayorder >= v_tungay or p_tu_ngay is null)
                and (a.ngayorder <= v_denngay or p_den_ngay is null)         
                and a.magiaidoan <> 1
                AND
                NOT EXISTS (
                                   SELECT * FROM pca_qlxx_phan_cong_an p
                                   WHERE p.id_vu_an= a.id and p.loai_an = a.loaian and p.ma_giai_doan = a.magiaidoan)
                AND
                NOT EXISTS ( SELECT * FROM PCA_DS_AN_DANGPC pc
                                   WHERE pc.id_vu_an = a.id and pc.loai_an = a.loaian and pc.loai_pc = 2)                   
                ) b
                INNER JOIN PCA_DM_GIA_TRI c ON b.loaian = c.gia_tri_dm AND c.loai_dm='LoaiAn'
                INNER JOIN PCA_DM_GIA_TRI gd ON b.magiaidoan = gd.gia_tri_dm AND gd.loai_dm='GiaiDoan'
                order by b.ngayorder) bb ;
       ELSE
        open p_out FOR
        SELECT bb.*, ROWNUM stt 
         FROM
         (select b.*, c.ten_dm AS loai_an, gd.ten_dm AS giai_doan 
         from
         (select *  
                from (SELECT d.mavuviec, d.magiaidoan, d.tenvuviec, d.id, 'DS' as loaian,
                     to_char(d.ngaytao,'DD/MM/YYYY') as ngaytao, to_char(d.ngaytao,'YYYYMMDD') as ngayorder, 
                     '' sothuly, '' ngaythuly from ads_don d
                     where (d.toaanid = p_id_toa_an)

                     union all
                     SELECT h.mavuviec, h.magiaidoan, h.tenvuviec, h.id, 'HC' as loaian, 
                     to_char(h.ngaytao,'DD/MM/YYYY') as ngaytao, to_char(h.ngaytao,'YYYYMMDD') as ngayorder,
                     '' sothuly, '' ngaythuly from ahc_don h                   
                     where (h.toaanid = p_id_toa_an)

                     union all
                     SELECT n.mavuviec, n.magiaidoan, n.tenvuviec, n.id, 'HN' as loaian, 
                     to_char(n.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(n.ngaytao,'YYYYMMDD') as ngayorder,
                     '' sothuly, '' ngaythuly from ahn_don n
                     where (n.toaanid = p_id_toa_an)

                     union all
                     SELECT s.mavuan, s.magiaidoan, s.tenvuan, s.id, 'HS' as loaian,
                     to_char(s.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(s.ngaytao,'YYYYMMDD') as ngayorder,
                     '' sothuly, '' ngaythuly from ahs_vuan s
                     where (s.toaanid = p_id_toa_an )

                     union all
                     SELECT t.mavuviec, t.magiaidoan, t.tenvuviec, t.id, 'KT' as loaian,
                     to_char(t.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(t.ngaytao,'YYYYMMDD') as ngayorder,
                     '' sothuly, '' ngaythuly from akt_don t
                     where (t.toaanid = p_id_toa_an)

                     union all 
                     SELECT l.mavuviec, l.magiaidoan, l.tenvuviec, l.id, 'LD' as loaian,
                     to_char(l.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(l.ngaytao,'YYYYMMDD') as ngayorder,
                     '' sothuly, '' ngaythuly from ald_don l
                     where (l.toaanid = p_id_toa_an)

                     union all 
                     SELECT p.mavuviec, p.magiaidoan, p.tenvuviec, p.id, 'PS' as loaian,
                     to_char(p.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(p.ngaytao,'YYYYMMDD') as ngayorder,
                     '' sothuly, '' ngaythuly from aps_don p
                     where (p.toaanid = p_id_toa_an)

                     union all 
                     SELECT x.mavuviec, x.magiaidoan, x.tenvuviec, x.id, 'XLHC' as loaian, 
                     to_char(x.ngaytao, 'DD/MM/YYYY') as ngaytao, to_char(x.ngaytao,'YYYYMMDD') as ngayorder,
                     '' sothuly, '' ngaythuly from xlhc_don x
                     where (x.toaanid = p_id_toa_an)

                     ) a
                where (a.ngayorder >= v_tungay or p_tu_ngay is null)
                and (a.ngayorder <= v_denngay or p_den_ngay is null)         
                and a.magiaidoan = 1
                AND
                NOT EXISTS (
                                   SELECT * FROM pca_qlxx_phan_cong_an p
                                   WHERE p.id_vu_an= a.id and p.loai_an = a.loaian and p.ma_giai_doan = a.magiaidoan)
                AND
                NOT EXISTS ( SELECT * FROM PCA_DS_AN_DANGPC pc
                                   WHERE pc.id_vu_an = a.id and pc.loai_an = a.loaian and pc.loai_pc = 1)                     
                ) b
                INNER JOIN PCA_DM_GIA_TRI c ON b.loaian = c.gia_tri_dm AND c.loai_dm='LoaiAn'
                INNER JOIN PCA_DM_GIA_TRI gd ON b.magiaidoan = gd.gia_tri_dm AND gd.loai_dm='GiaiDoan'
                order by b.ngayorder) bb ;
     end if;           

 end;  

 -- danh sach da phan cong an  
 PROCEDURE PRC_GET_KQ_PCA(
  p_giaidoan number,
  p_id_toa_an number,
  p_TEN_VU_AN varchar2,
  p_TEN_THAM_PHAN varchar2,
  p_TU_NGAY varchar2,
  p_DEN_NGAY varchar2,
  p_PAGE_INDEX NUMBER,
  p_PAGE_SIZE NUMBER,
  p_OUT OUT SYS_REFCURSOR
  ) 
  AS
  FirstIndex NUMBER;
  LastIndex NUMBER;
  v_total number;
  BEGIN
    FirstIndex := p_PAGE_SIZE * (p_PAGE_INDEX -1) + 1;
    LastIndex := p_PAGE_SIZE * (p_PAGE_INDEX);
    if p_giaidoan = 2
       then      
         SELECT COUNT(*) into v_total FROM(
          SELECT p.*,
                 p.ten_vu_an,
                 c.hoten TEN_THAM_PHAN
          FROM PCA_QLXX_PHAN_CONG_AN p          
            INNER JOIN DM_CANBO c ON c.id = p.id_tham_phan_ct
            INNER JOIN PCA_DM_GIA_TRI d ON p.vai_tro = d.gia_tri_dm AND d.loai_dm='VaiTro'
          WHERE 
          p.id_toa_xx = p_id_toa_an
          AND p.ma_giai_doan > 1
          and nvl( upper(p.ten_vu_an), '_') like '%'||upper(p_TEN_VU_AN)||'%'  
          and upper(c.hoten) like '%'||upper(p_TEN_THAM_PHAN)||'%'
          and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
          and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)
          order by p.id_phan_cong_an);

            OPEN p_OUT FOR

            SELECT f.*, v_total as count_all from
              (SELECT temp.*, ROWNUM RNUM from
                  (SELECT p.*,
                         c.hoten TEN_THAM_PHAN,
                         to_char(to_date(p.ngay_phan_cong, 'YYYY/MM/DD'), 'DD/MM/YYYY') as ngay_pc,
                         d.ten_dm vai_tro_tp,
                         (SELECT COUNT(*) FROM pca_qlxx_phan_cong_an_log l WHERE l.id_phan_cong_an = p.id_phan_cong_an) log
                    FROM PCA_QLXX_PHAN_CONG_AN p            
                    INNER JOIN DM_CANBO c ON c.id = p.id_tham_phan_ct
                    INNER JOIN PCA_DM_GIA_TRI d ON p.vai_tro = d.gia_tri_dm AND d.loai_dm='VaiTro'
                    WHERE 
                    p.id_toa_xx = p_id_toa_an
                    AND p.ma_giai_doan > 1
                    and nvl( upper(p.ten_vu_an), '_') like '%'||upper(p_TEN_VU_AN)||'%'  
                    and upper(c.hoten) like '%'||upper(p_TEN_THAM_PHAN)||'%'           
                    and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
                    and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)
                    order by p.id_phan_cong_an) temp) f
             where RNUM between FirstIndex and LastIndex;
       ELSE
                  SELECT COUNT(*) into v_total FROM(
                  SELECT p.*,
                         p.ten_vu_an,
                         c.hoten TEN_THAM_PHAN
                  FROM PCA_QLXX_PHAN_CONG_AN p          
                    INNER JOIN DM_CANBO c ON c.id = p.id_tham_phan_ct
                    INNER JOIN PCA_DM_GIA_TRI d ON p.vai_tro = d.gia_tri_dm AND d.loai_dm='VaiTro'
                  WHERE 
                  p.id_toa_xx = p_id_toa_an
                  AND p.ma_giai_doan = 1
                  and nvl( upper(p.ten_vu_an), '_') like '%'||upper(p_TEN_VU_AN)||'%'  
                  and upper(c.hoten) like '%'||upper(p_TEN_THAM_PHAN)||'%'
                  and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
                  and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)
                  order by p.id_phan_cong_an);

            OPEN p_OUT FOR

            SELECT f.*, v_total as count_all from
              (SELECT temp.*, ROWNUM RNUM from
                  (SELECT p.*,
                         c.hoten TEN_THAM_PHAN,
                         to_char(to_date(p.ngay_phan_cong, 'YYYY/MM/DD'), 'DD/MM/YYYY') as ngay_pc,
                         d.ten_dm vai_tro_tp,
                         (SELECT COUNT(*) FROM pca_qlxx_phan_cong_an_log l WHERE l.id_phan_cong_an = p.id_phan_cong_an) log
                    FROM PCA_QLXX_PHAN_CONG_AN p            
                    INNER JOIN DM_CANBO c ON c.id = p.id_tham_phan_ct
                    INNER JOIN PCA_DM_GIA_TRI d ON p.vai_tro = d.gia_tri_dm AND d.loai_dm='VaiTro'
                    WHERE 
                    p.id_toa_xx = p_id_toa_an
                    AND p.ma_giai_doan = 1
                    and nvl( upper(p.ten_vu_an), '_') like '%'||upper(p_TEN_VU_AN)||'%'  
                    and upper(c.hoten) like '%'||upper(p_TEN_THAM_PHAN)||'%'           
                    and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
                    and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)
                    order by p.id_phan_cong_an) temp) f
             where RNUM between FirstIndex and LastIndex;
     end if;           

END; 

procedure GET_DIEM_PCA(
  p_giaidoan number,
  p_id_toa_an number,
  p_TEN_VU_AN varchar2,
  p_TEN_THAM_PHAN varchar2,
  p_TU_NGAY varchar2,
  p_DEN_NGAY varchar2,
  p_PAGE_INDEX NUMBER,
  p_PAGE_SIZE NUMBER,
  p_OUT OUT sys_refcursor,
  p_OUT_DIEM_TP out sys_refcursor
  )      
  as
  FirstIndex NUMBER;
  LastIndex NUMBER;
  v_OUT_TOTAL NUMBER;
  v_tungay varchar2(10);
  v_denngay varchar2(10);
  begin 
    FirstIndex := p_PAGE_SIZE * (p_PAGE_INDEX - 1) + 1;
    LastIndex := p_PAGE_SIZE * (p_PAGE_INDEX);

    if p_tu_ngay is not null
       then
         v_tungay := to_char(to_date(p_tu_ngay, 'DD/MM/YYYY'), 'YYYYMMDD');
     end if;  
      if p_den_ngay is not null
       then
         v_denngay:= to_char(to_date(p_den_ngay, 'DD/MM/YYYY'), 'YYYYMMDD');
     end if;   
    if p_giaidoan = 2
       then      
         select count(*) into v_OUT_TOTAL
            from pca_qlxx_phan_cong_an p            
                           where nvl(upper(p.ten_vu_an), '_') like '%'||upper(p_TEN_VU_AN)||'%'
                           AND p.ma_giai_doan > 1
                           and (p.ngay_phan_cong >= v_tungay or p_TU_NGAY is null )
                           and (p.ngay_phan_cong <= v_denngay or p_DEN_NGAY is null )
                           and p.id_toa_xx = p_id_toa_an;   

            open p_OUT for
            select f.*, v_OUT_TOTAL as count_all from
                    (select temp.*, ROWNUM RNUM 
                           from
                            (select p.id_vu_an, 
                                   p.ten_vu_an,
                                   (select count(*) from pca_bang_diem_pc d 
                                   inner join dm_canbo m on d.id_can_bo = m.id
                                   where d.id_vu_an = p.id_vu_an and d.loai_an = p.loai_an and d.id_toa_an = p.id_toa_xx 
                                   AND p.ma_giai_doan = d.ma_giai_doan
                                   and upper(m.hoten) like '%'||upper(p_TEN_THAM_PHAN)||'%')SO_TP,
                                   p.ngay_phan_cong,
                                   p.id_phan_cong_an,
                                   p.loai_an
                                   from pca_qlxx_phan_cong_an p                                              
                                   where nvl(upper(p.ten_vu_an), '_') like '%'||upper(p_TEN_VU_AN)||'%'
                                   AND p.ma_giai_doan > 1
                                   and (p.ngay_phan_cong >= v_tungay or p_TU_NGAY is null )
                                   and (p.ngay_phan_cong <= v_denngay or p_DEN_NGAY is null )
                                   and p.id_toa_xx = p_id_toa_an
                                   order by id_phan_cong_an) temp
                       ) f
                       where RNUM between FirstIndex and LastIndex;

              open p_OUT_DIEM_TP for
              select c.*, b.hoten, a.id_tham_phan_ct, a.ngay_phan_cong  
                              from (select * from
                                            (select temp.*, ROWNUM RNUM 
                                                   from
                                                    (select p.id_vu_an, 
                                                           p.ten_vu_an,                                                  
                                                           to_char(to_date(p.ngay_phan_cong, 'YYYY/MM/DD'), 'DD/MM/YYYY') ngay_phan_cong,
                                                           p.id_phan_cong_an,
                                                           p.loai_an,
                                                           p.id_tham_phan_ct,
                                                           p.ma_giai_doan
                                                           from pca_qlxx_phan_cong_an p                                              
                                                           where nvl(upper(p.ten_vu_an), '_') like '%'||upper(p_TEN_VU_AN)||'%'
                                                           AND p.ma_giai_doan > 1
                                                           and (p.ngay_phan_cong >= v_tungay or p_TU_NGAY is null )
                                                           and (p.ngay_phan_cong <= v_denngay or p_DEN_NGAY is null )
                                                           and p.id_toa_xx = p_id_toa_an
                                                           order by id_phan_cong_an) temp
                                               )
                                               where RNUM between FirstIndex and LastIndex
                                       ) a
                              inner join PCA_BANG_DIEM_PC c on a.id_vu_an = c.id_vu_an and c.loai_an = a.loai_an AND a.ma_giai_doan = c.ma_giai_doan
                              inner join dm_canbo b on c.id_can_bo = b.id  
                              where upper(b.hoten) like '%'||upper(p_TEN_THAM_PHAN)||'%'                          
                              order by c.tong_diem desc;
       ELSE
            select count(*) into v_OUT_TOTAL
            from pca_qlxx_phan_cong_an p            
                           where nvl(upper(p.ten_vu_an), '_') like '%'||upper(p_TEN_VU_AN)||'%'
                           AND p.ma_giai_doan = 1
                           and (p.ngay_phan_cong >= v_tungay or p_TU_NGAY is null )
                           and (p.ngay_phan_cong <= v_denngay or p_DEN_NGAY is null )
                           and p.id_toa_xx = p_id_toa_an;   

            open p_OUT for
            select f.*, v_OUT_TOTAL as count_all from
                    (select temp.*, ROWNUM RNUM 
                           from
                            (select p.id_vu_an, 
                                   p.ten_vu_an,
                                   (select count(*) from pca_bang_diem_pc d 
                                   inner join dm_canbo m on d.id_can_bo = m.id
                                   where d.id_vu_an = p.id_vu_an and d.loai_an = p.loai_an and d.id_toa_an = p.id_toa_xx 
                                   AND p.ma_giai_doan = d.ma_giai_doan
                                   and upper(m.hoten) like '%'||upper(p_TEN_THAM_PHAN)||'%')SO_TP,
                                   p.ngay_phan_cong,
                                   p.id_phan_cong_an,
                                   p.loai_an
                                   from pca_qlxx_phan_cong_an p                                              
                                   where nvl(upper(p.ten_vu_an), '_') like '%'||upper(p_TEN_VU_AN)||'%'
                                   AND p.ma_giai_doan = 1
                                   and (p.ngay_phan_cong >= v_tungay or p_TU_NGAY is null )
                                   and (p.ngay_phan_cong <= v_denngay or p_DEN_NGAY is null )
                                   and p.id_toa_xx = p_id_toa_an
                                   order by id_phan_cong_an) temp
                       ) f
                       where RNUM between FirstIndex and LastIndex;

              open p_OUT_DIEM_TP for
              select c.*, b.hoten, a.id_tham_phan_ct, a.ngay_phan_cong  
                              from (select * from
                                            (select temp.*, ROWNUM RNUM 
                                                   from
                                                    (select p.id_vu_an, 
                                                           p.ten_vu_an,                                                  
                                                           to_char(to_date(p.ngay_phan_cong, 'YYYY/MM/DD'), 'DD/MM/YYYY') ngay_phan_cong,
                                                           p.id_phan_cong_an,
                                                           p.loai_an,
                                                           p.id_tham_phan_ct,
                                                           p.ma_giai_doan
                                                           from pca_qlxx_phan_cong_an p                                              
                                                           where nvl(upper(p.ten_vu_an), '_') like '%'||upper(p_TEN_VU_AN)||'%'
                                                           AND p.ma_giai_doan = 1
                                                           and (p.ngay_phan_cong >= v_tungay or p_TU_NGAY is null )
                                                           and (p.ngay_phan_cong <= v_denngay or p_DEN_NGAY is null )
                                                           and p.id_toa_xx = p_id_toa_an
                                                           order by id_phan_cong_an) temp
                                               )
                                               where RNUM between FirstIndex and LastIndex
                                       ) a
                              inner join PCA_BANG_DIEM_PC c on a.id_vu_an = c.id_vu_an and c.loai_an = a.loai_an AND a.ma_giai_doan = c.ma_giai_doan
                              inner join dm_canbo b on c.id_can_bo = b.id  
                              where upper(b.hoten) like '%'||upper(p_TEN_THAM_PHAN)||'%'                          
                              order by c.tong_diem desc;
     end if;           

end;   

PROCEDURE INSERT_QL_PHAN_CONG_AN(
  p_id_can_bo pca_qlpc_phan_cong_an.id_nguoi_phan_cong%TYPE,
  p_ten_can_bo pca_qlpc_phan_cong_an.nguoi_phan_cong%TYPE,
  p_ngay_pc pca_qlpc_phan_cong_an.ngay_phan_cong%TYPE,
  p_id_toa_an pca_qlpc_phan_cong_an.id_toa_an%TYPE,
  p_id_out OUT number
  )
  AS
  v_id_qlpc NUMBER;
  BEGIN
    SELECT sq_pca_ql_pca.nextval INTO v_id_qlpc FROM dual; --lay id_ql_pca
    INSERT INTO pca_qlpc_phan_cong_an
          (id_pc, 
          nguoi_phan_cong, 
          id_nguoi_phan_cong, 
          ngay_phan_cong,
          id_toa_an) 
          values  
          (
          v_id_qlpc,
          p_ten_can_bo,
          p_id_can_bo,
          p_ngay_pc,
          p_id_toa_an
          );
COMMIT;
p_id_out:=v_id_qlpc;
END;    

PROCEDURE PRC_GET_QL_PCA(
  p_id_toa_an number,
  p_TEN_CAN_BO varchar2,
  p_TU_NGAY varchar2,
  p_DEN_NGAY varchar2,
  p_PAGE_INDEX NUMBER,
  p_PAGE_SIZE NUMBER,
  p_OUT OUT SYS_REFCURSOR
  ) 
  AS
  FirstIndex NUMBER;
  LastIndex NUMBER;
  v_total number;
  BEGIN
    FirstIndex := p_PAGE_SIZE * (p_PAGE_INDEX -1) + 1;
    LastIndex := p_PAGE_SIZE * (p_PAGE_INDEX);

    SELECT COUNT(*) into v_total FROM(
          SELECT *                
          FROM PCA_QLPC_PHAN_CONG_AN p          
          WHERE 
          p.id_toa_an = p_id_toa_an
          and nvl( upper(p.nguoi_phan_cong), '_') like '%'||upper(p_TEN_CAN_BO)||'%'  
          and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
          and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)
          order by p.id_pc);

    OPEN p_OUT FOR

    SELECT f.*, v_total as count_all from
      (SELECT temp.*, ROWNUM RNUM from
          (SELECT p.*,
                 to_char(to_date(p.ngay_phan_cong, 'YYYY/MM/DD'), 'DD/MM/YYYY') as ngay_phan_cong_text,
                 (SELECT COUNT(*) FROM pca_qlxx_phan_cong_an x WHERE x.id_ql_pca = p.id_pc) AS tong_so
            FROM PCA_QLPC_PHAN_CONG_AN p          
            WHERE  
                  p.id_toa_an = p_id_toa_an
                  and nvl( upper(p.nguoi_phan_cong), '_') like '%'||upper(p_TEN_CAN_BO)||'%'  
                  and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
                  and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)
                  order by p.id_pc) temp) f
     where RNUM between FirstIndex and LastIndex;
END; 

PROCEDURE PRC_GET_TIEU_TRI( 
  p_id_toa number, 
  p_PAGE_INDEX NUMBER,
  p_PAGE_SIZE NUMBER,
  p_OUT OUT SYS_REFCURSOR
  ) 
  AS
  FirstIndex NUMBER;
  LastIndex NUMBER;
  v_total number;
  BEGIN
    FirstIndex := p_PAGE_SIZE * (p_PAGE_INDEX -1) + 1;
    LastIndex := p_PAGE_SIZE * (p_PAGE_INDEX);

    SELECT COUNT(*) into v_total FROM(
          SELECT *                
          FROM PCA_EXPR p  
          WHERE p.id_toa_an = -1        
         );

    OPEN p_OUT FOR    
    SELECT f.*, v_total as count_all from
      (SELECT temp.*, ROWNUM RNUM from
          (
          SELECT p.*,
                  to_char(to_date(p.value_date, 'YYYY/MM/DD'), 'DD/MM/YYYY') as ngay_hl,
                  1 SUDUNG,
                  0 AS KODUNG            
            FROM PCA_EXPR p          
            WHERE p.id_toa_an = -1 AND p.is_active = 1 AND p.su_dung = 1
            UNION ALL
          SELECT p.*,
                  to_char(to_date(p.value_date, 'YYYY/MM/DD'), 'DD/MM/YYYY') as ngay_hl,
                  (SELECT COUNT(*) FROM PCA_EXPR t WHERE t.expr_line = p.expr_line AND t.id_toa_an = p_id_toa) SUDUNG,
                  1 KODUNG            
            FROM PCA_EXPR p          
            WHERE p.id_toa_an = -1 AND p.is_active = 1 AND p.su_dung =0
          ) temp) f
     where RNUM between FirstIndex and LastIndex;
END; 

PROCEDURE BAO_CAO_KQPC(
  p_id_pc NUMBER,
  p_out_loaian OUT sys_refcursor,
  p_out_anpc OUT sys_refcursor
  )
  AS
  BEGIN
    OPEN p_out_loaian FOR
    SELECT to_char(to_date(q.ngay_phan_cong, 'YYYY/MM/DD'), 'DD/MM/YYYY') AS ngay_phan_cong,
    p.loai_an,
    p.ma_giai_doan,
    a.ten,
    p.tong_so
    FROM pca_qlpc_phan_cong_an q
    INNER JOIN (select DISTINCT t.loai_an, t.ma_giai_doan, t.id_ql_pca,  COUNT(*) AS tong_so 
                from PCA_QLXX_PHAN_CONG_AN t WHERE t.id_ql_pca = p_id_pc
                GROUP BY t.loai_an, t.ma_giai_doan, t.id_ql_pca) p ON q.id_pc = p.id_ql_pca
    INNER JOIN dm_toaan a ON q.id_toa_an = a.id;

    OPEN p_out_anpc FOR
    SELECT x.ten_vu_an, c.hoten, x.loai_an, x.ma_giai_doan, ROWNUM RNUM, x.so_thu_ly, x.ngay_thu_ly FROM PCA_QLXX_PHAN_CONG_AN x 
    INNER JOIN dm_canbo c ON x.id_tham_phan_ct = c.id
    WHERE x.id_ql_pca = p_id_pc;
END;

PROCEDURE INSERT_TIEUTRI_SD(
  p_id_toaan number,
  p_rule_id varchar2,
  p_ds_tieutri varchar2
  )
  AS
  BEGIN
    SAVEPOINT do_insert;
    DELETE FROM PCA_EXPR x WHERE x.id_toa_an = p_id_toaan;
    DELETE FROM PCA_RULE_FRM_ELEMENTS s WHERE s.id_toa_an = p_id_toaan;

     INSERT INTO PCA_EXPR
        (RULE_ID, FRM_NO, EXPR_LINE, COND, RESULT, NOTES, VALUE_DATE, IS_ACTIVE, ID_TOA_AN)
        (SELECT p_rule_id||'_'||t.RULE_ID, t.FRM_NO, t.EXPR_LINE, t.COND, t.RESULT, t.NOTES, t.VALUE_DATE, t.IS_ACTIVE, p_id_toaan  
        FROM PCA_EXPR t WHERE t.ID_TOA_AN = -1 
        AND (INSTR(p_ds_tieutri, ','||t.EXPR_LINE||',')> 0 ));

     INSERT INTO PCA_RULE_FRM_ELEMENTS
     (RULE_ID, FRM_NO, ELEMENT_ID, ELEMENT_TYPE, IS_ACTIVE, EXPR_LINE,ID_TOA_AN)
     (SELECT p_rule_id||'_'||e.RULE_ID, e.FRM_NO, e.ELEMENT_ID, e.ELEMENT_TYPE, e.IS_ACTIVE, e.EXPR_LINE,  p_id_toaan
        FROM PCA_RULE_FRM_ELEMENTS e WHERE e.ID_TOA_AN = -1 
        AND (INSTR(p_ds_tieutri, ','||e.EXPR_LINE||',')> 0 )) ;   
     COMMIT;  
     EXCEPTION
   WHEN OTHERS THEN
   ROLLBACK TO do_insert; 
END;  


PROCEDURE PRC_BC_KET_QUA_PCA(
    p_TOA_AN_ID number,
    p_TU_NGAY varchar2,
    p_DEN_NGAY varchar2,
    p_PAGE_INDEX NUMBER,
    p_PAGE_SIZE NUMBER,
    p_OUT OUT SYS_REFCURSOR
    )
    AS
    FirstIndex NUMBER;
    LastIndex NUMBER;
    v_total number;
    BEGIN

    FirstIndex := p_PAGE_SIZE * (p_PAGE_INDEX -1) + 1;
    LastIndex := p_PAGE_SIZE * (p_PAGE_INDEX);

    SELECT COUNT(*) into v_total FROM(
          select *
       from (
        select c.hoten,

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
         where p.id_tham_phan_ct = c.id and p.loai_an = 'HS'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_hs, 

         (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
         where p.id_tham_phan_ct = c.id and p.loai_an = 'DS'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_ds, 

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id and p.loai_an = 'HC'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_hc, 

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id and p.loai_an = 'HN'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_hn,

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id and p.loai_an = 'KT'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_kt,

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id and p.loai_an = 'LD'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_ld,

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id and p.loai_an = 'PS'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_ps,

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id and p.loai_an = 'XLHC'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_xlhc,

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id 
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_tong                         

        from DM_CANBO c where c.toaanid = p_TOA_AN_ID order by c.hoten) 
         where pc_tong > 0      
         );

    OPEN p_OUT FOR    
    SELECT f.*, v_total as count_all from
      (SELECT temp.*, ROWNUM RNUM from
          (select *
       from (
        select c.hoten,

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
         where p.id_tham_phan_ct = c.id and p.loai_an = 'HS'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_hs, 

         (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
         where p.id_tham_phan_ct = c.id and p.loai_an = 'DS'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_ds, 

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id and p.loai_an = 'HC'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_hc, 

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id and p.loai_an = 'HN'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_hn,

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id and p.loai_an = 'KT'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_kt,

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id and p.loai_an = 'LD'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_ld,

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id and p.loai_an = 'PS'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_ps,

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id and p.loai_an = 'XLHC'
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_xlhc,

        (select count(*) from PCA_QLXX_PHAN_CONG_AN p 
        where p.id_tham_phan_ct = c.id 
              and (p.ngay_phan_cong >= to_char(to_date(p_TU_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_TU_NGAY is null)
              and (p.ngay_phan_cong <= to_char(to_date(p_DEN_NGAY,'DD/MM/YYYY'),'YYYYMMDD') or p_DEN_NGAY is null)) pc_tong                         

        from DM_CANBO c where c.toaanid = p_TOA_AN_ID order by c.hoten) 
         where pc_tong > 0) temp) f
     where RNUM between FirstIndex and LastIndex;

END;   

PROCEDURE pr_loging_on_QLXX_PHAN_CONG_AN(
  p_id_phan_cong_an PCA_QLXX_PHAN_CONG_AN.id_phan_cong_an%TYPE,
  P_USER_ID NUMBER, 
  p_ID_THAM_PHAN_CT number,
  p_LY_DO varchar2)
 AS
 v_loai_an varchar2(10);
 BEGIN
 SELECT l.loai_an INTO v_loai_an FROM pca_qlxx_phan_cong_an l WHERE l.id_phan_cong_an = p_id_phan_cong_an;  

 INSERT INTO pca_qlxx_phan_cong_an_log
   (id_phan_cong_an, lan_xet_xu, id_vu_an, cap_xet_xu, id_tham_phan_ct, trang_thai_pc, ngay_phan_cong, id_toa_xx, log_time, edited_by, ly_do)

 SELECT id_phan_cong_an, lan_xet_xu, id_vu_an, cap_xet_xu, id_tham_phan_ct, trang_thai_pc, ngay_phan_cong, id_toa_xx,Sysdate,P_USER_ID, p_LY_DO
     FROM pca_qlxx_phan_cong_an
    WHERE id_phan_cong_an = p_id_phan_cong_an;

     UPDATE PCA_QLXX_PHAN_CONG_AN p
      SET                  
              p.ID_THAM_PHAN_CT = p_ID_THAM_PHAN_CT             
     WHERE p.id_phan_cong_an = p_id_phan_cong_an;

  CASE v_loai_an
          WHEN 'DS' THEN
              UPDATE ADS_DON_THAMPHAN d SET                  
                        d.canboid = p_ID_THAM_PHAN_CT             
                     WHERE d.id_phan_cong_an = p_id_phan_cong_an;
          WHEN 'HC' THEN
              UPDATE AHC_DON_THAMPHAN d SET                  
                        d.canboid = p_ID_THAM_PHAN_CT             
                     WHERE d.id_phan_cong_an = p_id_phan_cong_an;  
          WHEN 'HN' THEN
              UPDATE AHN_DON_THAMPHAN d SET                  
                        d.canboid = p_ID_THAM_PHAN_CT             
                     WHERE d.id_phan_cong_an = p_id_phan_cong_an;
          WHEN 'HS' THEN
              UPDATE AHS_THAMPHANGIAIQUYET d SET                  
                        d.canboid = p_ID_THAM_PHAN_CT             
                     WHERE d.id_phan_cong_an = p_id_phan_cong_an;
          WHEN 'KT' THEN
              UPDATE AKT_DON_THAMPHAN d SET                  
                        d.canboid = p_ID_THAM_PHAN_CT             
                     WHERE d.id_phan_cong_an = p_id_phan_cong_an;
          WHEN 'LD' THEN
              UPDATE ALD_DON_THAMPHAN d SET                  
                        d.canboid = p_ID_THAM_PHAN_CT             
                     WHERE d.id_phan_cong_an = p_id_phan_cong_an;
          WHEN 'PS' THEN
              UPDATE APS_DON_THAMPHAN d SET                  
                        d.canboid = p_ID_THAM_PHAN_CT             
                     WHERE d.id_phan_cong_an = p_id_phan_cong_an;  
          WHEN 'XLHC' THEN
               UPDATE XLHC_DON_THAMPHAN d SET                  
                        d.canboid = p_ID_THAM_PHAN_CT             
                     WHERE d.id_phan_cong_an = p_id_phan_cong_an;                   
    END CASE;

    COMMIT;
 END;

 PROCEDURE DM_TP(
   p_id_toaan NUMBER,
   p_ID_VU_AN number,
   p_loai_an varchar2,
   p_out OUT sys_refcursor
   )
   AS
   BEGIN
     OPEN p_out FOR
      SELECT * FROM
       (select t.*, fn_CHECK_CB_DA_THAM_GIA_XX(t.id,p_ID_VU_AN,p_loai_an) as xx from dm_canbo t 
       inner join dm_dataitem d on t.chucdanhid = d.id
        WHERE t.toaanid=p_id_toaan             
              AND t.hieuluc <>0  
              and d.ma in ('TPSC','TPTC','TPCC'))
              WHERE xx = 0;
 END;   

 PROCEDURE GET_PCA_BYID(
   p_id_pca number,
   p_out OUT sys_refcursor
   )
   AS
   BEGIN
     OPEN p_out FOR
     SELECT * FROM pca_qlxx_phan_cong_an p WHERE p.id_phan_cong_an = p_id_pca;
 END;  

 PROCEDURE GET_DS_TP_CAUHINH(
   p_id_toaan number,
   p_tham_phan varchar2,   
   p_out OUT sys_refcursor
   )
   AS 
   BEGIN     

    OPEN p_out FOR   
    SELECT temp.*, ROWNUM RNUM from
          (SELECT c.id, c.hoten, nvl(t.pca_don, 1) pc_don, nvl(t.pca_an,1) pc_an FROM dm_canbo c 
          Left JOIN pca_cau_hinh_tp t ON c.id = t.ID_CANBO
          inner join dm_dataitem d on c.chucdanhid = d.id
           WHERE c.toaanid=p_id_toaan    
               AND upper(c.hoten) LIKE '%'||upper(p_tham_phan)||'%'          
              AND c.hieuluc <>0  
              and d.ma in ('TPSC','TPTC','TPCC')) temp;

END;   

PROCEDURE GET_TOAAN_CAUHINH(
   p_id_toaan number,
   p_out OUT sys_refcursor
   )
   AS
   BEGIN
   OPEN p_out FOR
   SELECT t.id, t.ten, NVL(c.pca_don,1) pc_don FROM dm_toaan t
    LEFT JOIN pca_cau_hinh_toaan c ON t.id = c.id_toaan
    WHERE t.id = p_id_toaan;
END;   

PROCEDURE INSERT_CAUHINH_TOAAN(
  p_id_toaan number,
  p_pc_don number,
  p_out OUT varchar2
  )
  AS
  BEGIN
    DELETE FROM pca_cau_hinh_toaan t WHERE t.id_toaan = p_id_toaan;
    INSERT INTO pca_cau_hinh_toaan 
    (
    ID_TOAAN,
    PCA_DON
    )values(
    p_id_toaan,
    p_pc_don
    );
  COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      p_out := SQLERRM;
      ROLLBACK;  
END;    

PROCEDURE INSERT_CAUHINH_TP(
  p_id_canbo number,
  p_id_toaan number,
  p_pc_don number,
  p_pc_an number,
  p_out OUT varchar2
  )
  AS
  BEGIN
    INSERT INTO pca_cau_hinh_tp 
    (
    ID_CANBO,
    ID_TOAAN,
    PCA_DON,
    PCA_AN
    )values(
    p_id_canbo,
    p_id_toaan,
    p_pc_don,
    p_pc_an
    );
  COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      p_out := SQLERRM;
      ROLLBACK;  
END; 

procedure DELETE_CAU_HINH_TP(
p_id_toaan NUMBER,
p_out OUT varchar2
)
AS
BEGIN
  DELETE FROM pca_cau_hinh_tp t WHERE t.id_toaan = p_id_toaan;
  COMMIT;
  EXCEPTION
  WHEN OTHERS THEN
    p_out := SQLERRM;
    ROLLBACK;
END;

PROCEDURE CHECK_TOA_PCDON(
  p_id_toaan number,
  p_out OUT sys_refcursor
  )
  AS
  BEGIN 
    OPEN p_out FOR
    SELECT * FROM pca_cau_hinh_toaan t 
    WHERE t.id_toaan = p_id_toaan
    AND t.pca_don =0; 
END; 

PROCEDURE INSERT_DS_AN_DANGPC(
  p_id_vu_an number,
  p_loai_an varchar2,
  p_id_ql_pca number,
  p_loai_pc number,
  p_out OUT varchar2
  )
  AS
  BEGIN
    INSERT INTO pca_ds_an_dangpc
    (
     ID_VU_AN,
     LOAI_AN,
     ID_QL_PCA,
     LOAI_PC      
    )values(
     p_id_vu_an,
     p_loai_an,
     p_id_ql_pca,
     p_loai_pc
    );
 COMMIT;
 EXCEPTION
   WHEN OTHERS THEN
     p_out:= SQLERRM;
     ROLLBACK;   
END; 

procedure DELETE_DS_AN_PC_XONG(
p_id_ql_pca number,
p_out OUT varchar2
)
AS
BEGIN
  DELETE FROM pca_ds_an_dangpc t WHERE t.id_ql_pca = p_id_ql_pca;
  COMMIT;
  EXCEPTION
  WHEN OTHERS THEN
    p_out := SQLERRM;
    ROLLBACK;
END; 

procedure GET_LOG_PCA(
p_pca number,
p_out OUT sys_refcursor
)
AS
BEGIN
  OPEN p_out FOR
  SELECT p.ten_vu_an, to_char(l.log_time, 'DD/MM/YYYY') ngay_sua, l.log_time, l.ly_do,
  c.hoten, tp.hoten tham_phan, ROWNUM RNUM
   FROM pca_qlxx_phan_cong_an_log l
  INNER JOIN pca_qlxx_phan_cong_an p ON l.id_phan_cong_an = p.id_phan_cong_an
  INNER JOIN dm_canbo c ON l.edited_by = c.id
  INNER JOIN dm_canbo tp ON l.id_tham_phan_ct = tp.id
  WHERE l.id_phan_cong_an = p_pca;
END; 

PROCEDURE PRC_DONGBO_PCA(
  p_ql_pca number,
  p_out OUT varchar2
  )
  AS
  BEGIN
     SAVEPOINT do_dongbo;

    INSERT INTO ads_don_thamphan 
    (ID, DONID, CANBOID, MAVAITRO, NGAYPHANCONG, NGUOIPHANCONGID, NGAYTAO, NGUOITAO, ID_PHAN_CONG_AN)
    (SELECT ADS_DON_THAMPHAN_SEQ.NEXTVAL, p.id_vu_an, p.id_tham_phan_ct, p.vai_tro, to_date(p.ngay_phan_cong,'YYYY/MM/DD'), q.id_nguoi_phan_cong, Sysdate, q.nguoi_phan_cong, p.id_phan_cong_an 
      FROM pca_qlpc_phan_cong_an q
      INNER JOIN pca_qlxx_phan_cong_an p ON q.id_pc = p.id_ql_pca
      WHERE q.id_pc = p_ql_pca AND p.loai_an = 'DS');

      INSERT INTO ahc_don_thamphan 
    (ID, DONID, CANBOID, MAVAITRO, NGAYPHANCONG, NGUOIPHANCONGID, NGAYTAO, NGUOITAO, ID_PHAN_CONG_AN)
    (SELECT AHC_DON_THAMPHAN_SEQ.NEXTVAL, p.id_vu_an, p.id_tham_phan_ct, p.vai_tro, to_date(p.ngay_phan_cong,'YYYY/MM/DD'), q.id_nguoi_phan_cong, Sysdate, q.nguoi_phan_cong, p.id_phan_cong_an 
      FROM pca_qlpc_phan_cong_an q
      INNER JOIN pca_qlxx_phan_cong_an p ON q.id_pc = p.id_ql_pca
      WHERE q.id_pc = p_ql_pca AND p.loai_an = 'HC');

      INSERT INTO ahn_don_thamphan 
      (ID, DONID, CANBOID, MAVAITRO, NGAYPHANCONG, NGUOIPHANCONGID, NGAYTAO, NGUOITAO, ID_PHAN_CONG_AN)
      (SELECT AHN_DON_THAMPHAN_SEQ.NEXTVAL, p.id_vu_an, p.id_tham_phan_ct, p.vai_tro, to_date(p.ngay_phan_cong,'YYYY/MM/DD'), q.id_nguoi_phan_cong, Sysdate, q.nguoi_phan_cong, p.id_phan_cong_an 
       FROM pca_qlpc_phan_cong_an q
       INNER JOIN pca_qlxx_phan_cong_an p ON q.id_pc = p.id_ql_pca
       WHERE q.id_pc = p_ql_pca AND p.loai_an = 'HN');

      INSERT INTO AHS_THAMPHANGIAIQUYET 
      (ID, VUANID, CANBOID, MAVAITRO, NGAYPHANCONG, NGUOIPHANCONGID, NGAYTAO, NGUOITAO, ID_PHAN_CONG_AN)
      (SELECT AHS_THAMPHANGIAIQUYET_SEQ.NEXTVAL, p.id_vu_an, p.id_tham_phan_ct, p.vai_tro, to_date(p.ngay_phan_cong,'YYYY/MM/DD'), q.id_nguoi_phan_cong, Sysdate, q.nguoi_phan_cong, p.id_phan_cong_an 
       FROM pca_qlpc_phan_cong_an q
       INNER JOIN pca_qlxx_phan_cong_an p ON q.id_pc = p.id_ql_pca
       WHERE q.id_pc = p_ql_pca AND p.loai_an = 'HS');

        INSERT INTO akt_don_thamphan 
      (ID, DONID, CANBOID, MAVAITRO, NGAYPHANCONG, NGUOIPHANCONGID, NGAYTAO, NGUOITAO, ID_PHAN_CONG_AN)
      (SELECT AKT_DON_THAMPHAN_SEQ.NEXTVAL, p.id_vu_an, p.id_tham_phan_ct, p.vai_tro, to_date(p.ngay_phan_cong,'YYYY/MM/DD'), q.id_nguoi_phan_cong, Sysdate, q.nguoi_phan_cong, p.id_phan_cong_an 
       FROM pca_qlpc_phan_cong_an q
       INNER JOIN pca_qlxx_phan_cong_an p ON q.id_pc = p.id_ql_pca
       WHERE q.id_pc = p_ql_pca AND p.loai_an = 'KT');

        INSERT INTO ald_don_thamphan 
      (ID, DONID, CANBOID, MAVAITRO, NGAYPHANCONG, NGUOIPHANCONGID, NGAYTAO, NGUOITAO, ID_PHAN_CONG_AN)
      (SELECT ALD_DON_THAMPHAN_SEQ.NEXTVAL, p.id_vu_an, p.id_tham_phan_ct, p.vai_tro, to_date(p.ngay_phan_cong,'YYYY/MM/DD'), q.id_nguoi_phan_cong, Sysdate, q.nguoi_phan_cong, p.id_phan_cong_an 
       FROM pca_qlpc_phan_cong_an q
       INNER JOIN pca_qlxx_phan_cong_an p ON q.id_pc = p.id_ql_pca
       WHERE q.id_pc = p_ql_pca AND p.loai_an = 'LD');

        INSERT INTO aps_don_thamphan 
      (ID, DONID, CANBOID, MAVAITRO, NGAYPHANCONG, NGUOIPHANCONGID, NGAYTAO, NGUOITAO, ID_PHAN_CONG_AN)
      (SELECT APS_DON_THAMPHAN_SEQ.NEXTVAL, p.id_vu_an, p.id_tham_phan_ct, p.vai_tro, to_date(p.ngay_phan_cong,'YYYY/MM/DD'), q.id_nguoi_phan_cong, Sysdate, q.nguoi_phan_cong, p.id_phan_cong_an 
       FROM pca_qlpc_phan_cong_an q
       INNER JOIN pca_qlxx_phan_cong_an p ON q.id_pc = p.id_ql_pca
       WHERE q.id_pc = p_ql_pca AND p.loai_an = 'PS');

       INSERT INTO xlhc_don_thamphan 
      (ID, DONID, CANBOID, MAVAITRO, NGAYPHANCONG, NGUOIPHANCONGID, NGAYTAO, NGUOITAO, ID_PHAN_CONG_AN)
      (SELECT XLHC_DON_THAMPHAN_SEQ.NEXTVAL, p.id_vu_an, p.id_tham_phan_ct, p.vai_tro, to_date(p.ngay_phan_cong,'YYYY/MM/DD'), q.id_nguoi_phan_cong, Sysdate, q.nguoi_phan_cong, p.id_phan_cong_an 
       FROM pca_qlpc_phan_cong_an q
       INNER JOIN pca_qlxx_phan_cong_an p ON q.id_pc = p.id_ql_pca
       WHERE q.id_pc = p_ql_pca AND p.loai_an = 'XLHC');

 COMMIT; 
 EXCEPTION
   WHEN OTHERS THEN
     p_out:= SQLERRM;
     ROLLBACK to do_dongbo;            
END;

PROCEDURE DELETE_ALL(
  p_id_toaan number,-- lấy id của đơn vị Ví dụ: SELECT SELECT DV.* FROM DM_TOAAN DV WHERE UPPER(DV.TEN) LIKE '%AN GIANG%';
  p_out OUT varchar2
  )
  AS
  BEGIN
    SAVEPOINT do_delete;

    DELETE FROM ads_don_thamphan t WHERE t.id_phan_cong_an in (select p.id_phan_cong_an from pca_qlxx_phan_cong_an p where p.id_toa_xx = p_id_toaan);
    DELETE FROM ahc_don_thamphan t WHERE t.id_phan_cong_an in (select p.id_phan_cong_an from pca_qlxx_phan_cong_an p where p.id_toa_xx = p_id_toaan);
    DELETE FROM ahn_don_thamphan t WHERE t.id_phan_cong_an in (select p.id_phan_cong_an from pca_qlxx_phan_cong_an p where p.id_toa_xx = p_id_toaan);
    DELETE FROM AHS_THAMPHANGIAIQUYET t WHERE t.id_phan_cong_an in (select p.id_phan_cong_an from pca_qlxx_phan_cong_an p where p.id_toa_xx = p_id_toaan);
    DELETE FROM akt_don_thamphan t WHERE t.id_phan_cong_an in (select p.id_phan_cong_an from pca_qlxx_phan_cong_an p where p.id_toa_xx = p_id_toaan);
    DELETE FROM ald_don_thamphan t WHERE t.id_phan_cong_an in (select p.id_phan_cong_an from pca_qlxx_phan_cong_an p where p.id_toa_xx = p_id_toaan);
    DELETE FROM aps_don_thamphan t WHERE t.id_phan_cong_an in (select p.id_phan_cong_an from pca_qlxx_phan_cong_an p where p.id_toa_xx = p_id_toaan);
    DELETE FROM xlhc_don_thamphan t WHERE t.id_phan_cong_an in (select p.id_phan_cong_an from pca_qlxx_phan_cong_an p where p.id_toa_xx = p_id_toaan);

    DELETE FROM PCA_BANG_DIEM_PC d where d.id_toa_an = p_id_toaan; 
    DELETE FROM PCA_CALC_EXPR_LOG l where l.id_toa_an = p_id_toaan; 
    DELETE FROM PCA_DS_CAN_BO_KHONG_PC k where k.id_toa_an = p_id_toaan; 
    DELETE FROM PCA_QLPC_PHAN_CONG_AN qp where qp.id_toa_an = p_id_toaan; 
    DELETE FROM PCA_QLXX_PHAN_CONG_AN qx where qx.id_toa_xx = p_id_toaan;
    DELETE FROM PCA_QLXX_PHAN_CONG_AN_LOG pl where pl.id_toa_xx = p_id_toaan;


    COMMIT;
      p_out := 'Bạn đã xóa thành công đơn vị có mã:'||p_id_toaan;
    EXCEPTION
      WHEN OTHERS THEN
        p_out := SQLERRM;
        ROLLBACK TO do_delete;
    --ANHVH ADD 25/12/2019 -- đanh định gọi hàm để xóa thêm huyện       
    --DECLARE
    --  P_ID_TOAAN NUMBER;
    --  P_OUT VARCHAR2(200);
    --BEGIN
    --  FOR ITEM IN (
    --             SELECT DV.* FROM DM_TOAAN DV WHERE (DV.ID=63 OR DV.CAPCHAID=63)--AN GIANG
    --             )
    --      LOOP
    --        PCA_PKG.DELETE_ALL(ITEM.ID,P_OUT);
    --        DBMS_OUTPUT.PUT_LINE('P_OUT = ' || P_OUT);
    --      END LOOP;
    --END;
END;  
end PCA_PKG;
