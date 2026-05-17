--------------------------------------------------------
--  DDL for Package PCA_PKG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PCA_PKG" is

  -- Author  : KIENPT
  -- Created : 8/17/2019 11:25:51 AM
  -- Purpose : 

  -- check can bo dang nghi phep
  FUNCTION fn_CHECK_CB_DANG_NGHI_PHEP(
    p_ID_CAN_BO DM_CANBO.Id%TYPE,
    p_NGAY varchar2
    ) RETURN NUMBER;

  --check can bo tam ngung cong tac 
    FUNCTION fn_CHECK_CB_TAM_NGUNG_CT(
   p_ID_CAN_BO DM_CANBO.Id%TYPE,
   p_NGAY varchar2
   ) RETURN NUMBER;

   --check can bo da tham gia xet xu
   FUNCTION fn_CHECK_CB_DA_THAM_GIA_XX(
    p_ID_CAN_BO DM_CANBO.Id%TYPE,
    p_id_vu_an ADS_DON.ID%TYPE,
     p_loai_an varchar2 
    ) RETURN NUMBER; 

 --check can bo sap nghi huu   
 FUNCTION fn_TINH_NGAY_NGHI_HUU(
   p_ID_CAN_BO DM_CANBO.Id%TYPE,
   p_NGAY varchar2) 
   RETURN NUMBER;

-- tinh ty le an phan cong min  
FUNCTION fn_CHECK_TL_AN_PC_MIN(
  p_ID_CAN_BO DM_CANBO.Id%TYPE,
  p_ID_TOA_AN DM_TOAAN.ID%TYPE,
  p_NGAY varchar2) 
  RETURN NUMBER;

--check tham phan theo toa chuyen trach  
FUNCTION fn_CHECK_PC_THEO_TOA_CHTR(
  p_ID_CAN_BO DM_CANBO.Id%TYPE,
  p_LOAI_AN varchar2 
  ) RETURN NUMBER;

--tinh ty le an da duoc phan cong 
FUNCTION fn_TINH_TL_AN_DA_PC(
  p_ID_CAN_BO DM_CANBO.ID%TYPE,
  p_ID_TOA_AN DM_TOAAN.ID%TYPE,
  p_NGAY varchar2,
   p_loai_pc number) 
  RETURN NUMBER;  

PROCEDURE pr_get_data_calc(
    p_calc_date pca_calc_expr.calc_date%TYPE,
    p_ID_VU_AN pca_calc_expr.ID_VU_AN%TYPE,
    p_id_can_bo pca_calc_expr.id_can_bo%TYPE ,
    p_loai_an pca_calc_expr.loai_an%type,
    p_id_toa_an pca_calc_expr.id_toa_an%type,
    p_ma_giai_doan pca_calc_expr.ma_giai_doan%TYPE,
    p_rule_id VARCHAR2,
    p_frm_no NUMBER,
    p_calc_id OUT NUMBER);  

PROCEDURE pr_replace_element(
  p_calc_id  IN NUMBER);

FUNCTION fn_exec_expr_PCA(
  p_calc_date pca_calc_expr.calc_date%TYPE,
  p_ID_VU_AN pca_calc_expr.ID_VU_AN%TYPE,
  p_loai_an pca_calc_expr.loai_an%type,
  p_id_can_bo pca_calc_expr.id_can_bo%TYPE ,
  p_id_toa_an pca_calc_expr.id_toa_an%type,
  p_ma_giai_doan pca_calc_expr.ma_giai_doan%TYPE,
  p_rule_id VARCHAR2,
  p_frm_no NUMBER) RETURN NUMBER;

 PROCEDURE pr_get_list_tham_phan(
   p_calc_date pca_calc_expr.calc_date%TYPE,
   p_ID_VU_AN pca_calc_expr.ID_VU_AN%TYPE,
   p_loai_an pca_calc_expr.loai_an%type,
   p_id_toa_an pca_calc_expr.id_toa_an%TYPE,
   p_ma_giai_doan pca_calc_expr.ma_giai_doan%TYPE,
   p_rule_id varchar2);

PROCEDURE pr_get_list_tham_phan2(
  p_calc_date pca_calc_expr.calc_date%TYPE,
  p_ID_VU_AN pca_calc_expr.ID_VU_AN%TYPE,
  p_loai_an pca_calc_expr.loai_an%type,
  p_id_toa_an pca_calc_expr.id_toa_an%TYPE,
  p_ma_giai_doan pca_ds_can_bo_cho_pc.ma_giai_doan%TYPE);

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
  p_rule_id VARCHAR2);     

-- danh sach vu an chua phan cong   
procedure GET_DS_AN_CHO_PC(
   p_giaidoan number,
   p_id_toa_an dm_toaan.id%type,
   p_tu_ngay varchar2,
   p_den_ngay varchar2,
   p_out out sys_refcursor
   );    

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
  );     
-- ds diem phan cong an  
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
  ) ;  
-- them moi lan phan cong an  
PROCEDURE INSERT_QL_PHAN_CONG_AN(
  p_id_can_bo pca_qlpc_phan_cong_an.id_nguoi_phan_cong%TYPE,
  p_ten_can_bo pca_qlpc_phan_cong_an.nguoi_phan_cong%TYPE,
  p_ngay_pc pca_qlpc_phan_cong_an.ngay_phan_cong%TYPE,
  p_id_toa_an pca_qlpc_phan_cong_an.id_toa_an%TYPE,
  p_id_out OUT number
  ); 

-- ds lan phan cong an   
PROCEDURE PRC_GET_QL_PCA(
  p_id_toa_an number,
  p_TEN_CAN_BO varchar2,
  p_TU_NGAY varchar2,
  p_DEN_NGAY varchar2,
  p_PAGE_INDEX NUMBER,
  p_PAGE_SIZE NUMBER,
  p_OUT OUT SYS_REFCURSOR
  );   

-- ds tieu tri
PROCEDURE PRC_GET_TIEU_TRI( 
  p_id_toa number,  
  p_PAGE_INDEX NUMBER,
  p_PAGE_SIZE NUMBER,
  p_OUT OUT SYS_REFCURSOR
  );

-- bao cao ket qua 1 lan phan cong an  
PROCEDURE BAO_CAO_KQPC(
  p_id_pc NUMBER,
  p_out_loaian OUT sys_refcursor,
  p_out_anpc OUT sys_refcursor
  ); 

-- su dung tieu tri  
PROCEDURE INSERT_TIEUTRI_SD(
  p_id_toaan number,
  p_rule_id varchar2,
  p_ds_tieutri varchar2
  );
-- thong ke phan cong an theo ngay
PROCEDURE PRC_BC_KET_QUA_PCA(
    p_TOA_AN_ID number,
    p_TU_NGAY varchar2,
    p_DEN_NGAY varchar2,
    p_PAGE_INDEX NUMBER,
    p_PAGE_SIZE NUMBER,
    p_OUT OUT SYS_REFCURSOR
    );

-- log sua tham phan da phan cong    
PROCEDURE pr_loging_on_QLXX_PHAN_CONG_AN(
  p_id_phan_cong_an PCA_QLXX_PHAN_CONG_AN.id_phan_cong_an%TYPE,
  P_USER_ID NUMBER, 
  p_ID_THAM_PHAN_CT number,
  p_LY_DO varchar2);


-- ds tham phan  
 PROCEDURE DM_TP(
   p_id_toaan NUMBER,
   p_ID_VU_AN number,
   p_loai_an varchar2,
   p_out OUT sys_refcursor
   );

PROCEDURE GET_PCA_BYID(
   p_id_pca number,
   p_out OUT sys_refcursor
   ); 

 PROCEDURE GET_DS_TP_CAUHINH(
   p_id_toaan number,
   p_tham_phan varchar2,  
   p_out OUT sys_refcursor
   );

PROCEDURE GET_TOAAN_CAUHINH(
   p_id_toaan number,
   p_out OUT sys_refcursor
   );  

PROCEDURE INSERT_CAUHINH_TOAAN(
  p_id_toaan number,
  p_pc_don number,
  p_out OUT varchar2
  );

PROCEDURE INSERT_CAUHINH_TP(
  p_id_canbo number,
  p_id_toaan number,
  p_pc_don number,
  p_pc_an number,
  p_out OUT varchar2
  );

procedure DELETE_CAU_HINH_TP(
p_id_toaan NUMBER,
p_out OUT varchar2
);             

PROCEDURE CHECK_TOA_PCDON(
  p_id_toaan number,
  p_out OUT sys_refcursor
  );

PROCEDURE INSERT_DS_AN_DANGPC(
  p_id_vu_an number,
  p_loai_an varchar2,
  p_id_ql_pca number,
  p_loai_pc number,
  p_out OUT varchar2
  );   

procedure DELETE_DS_AN_PC_XONG(
p_id_ql_pca number,
p_out OUT varchar2
);   

procedure GET_LOG_PCA(
p_pca number,
p_out OUT sys_refcursor
);   


PROCEDURE PRC_DONGBO_PCA(
 p_ql_pca number,
 p_out OUT varchar2
  ); 
-- xoa phan cong an theo don vi 
PROCEDURE DELETE_ALL(
  p_id_toaan number,
  p_out OUT varchar2
  );        
end PCA_PKG;
