--------------------------------------------------------
--  DDL for Package Body PKG_TUPHAP_REPORT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_TUPHAP_REPORT" AS
FUNCTION GET_DONVI_BC
(
 v_capxx in varchar2,
 v_object_select in varchar2
)
RETURN SYS_REFCURSOR
IS 
  V_CURSOR sys_refcursor;
BEGIN
      IF(v_object_select='H') THEN
      OPEN V_CURSOR FOR
         SELECT 1 ID,0 CAPCHAID,'Danh sách đơn vị' TEN FROM DUAL
       UNION ALL 
         SELECT TT.ID,TT.CAPCHAID,TO_CHAR(TT.TEN)TEN FROM (
                 SELECT MN.ID,DECODE(MN.CAPCHAID,4,1,5,1,6,1,MN.CAPCHAID)CAPCHAID,MN.TEN FROM DM_DONVITHIHANHAN MN 
                 WHERE MN.LOAITOA IN ('CAPTINH','CAPHUYEN')
                 ORDER BY MN.ARRTHUTU
         )TT;
      ELSIF(v_object_select='TH' OR v_object_select='T') THEN
       OPEN V_CURSOR FOR
             SELECT 1 ID,0 CAPCHAID,'Danh sách đơn vị' TEN FROM DUAL
           UNION ALL 
             SELECT TT.ID,TT.CAPCHAID,TO_CHAR(TT.TEN)TEN FROM (
             SELECT MN.ID,1 CAPCHAID,MN.TEN FROM DM_DONVITHIHANHAN MN 
             WHERE MN.LOAITOA ='CAPTINH'
             ORDER BY MN.ARRTHUTU
            )TT;
       END IF;
  RETURN v_cursor;   
END;
FUNCTION GET_DONVI_TINH
(
 V_CAPCHAID in varchar2
)
RETURN SYS_REFCURSOR
IS 
  V_CURSOR sys_refcursor;
BEGIN
  OPEN V_CURSOR FOR
         SELECT 1 ID,0 CAPCHAID,'Danh sách đơn vị' TEN FROM DUAL
       UNION ALL 
         SELECT TT.ID,TT.CAPCHAID,TO_CHAR(TT.TEN)TEN FROM (
                 SELECT MN.ID,1 CAPCHAID,MN.TEN FROM DM_DONVITHIHANHAN MN 
                 WHERE MN.CAPCHAID=V_CAPCHAID   
                 ORDER BY MN.ARRTHUTU
         )TT;
  RETURN v_cursor;   
END;
FUNCTION GET_REPORT_THADS
(
  V_TT_TRUCTUYEN IN VARCHAR2 DEFAULT NULL, 
  v_Names NVARCHAR2 DEFAULT NULL,
  V_OPTIONS IN NUMBER,
  V_DATE_FROM IN VARCHAR2 DEFAULT NULL,  
  V_DATE_TO IN VARCHAR2 DEFAULT NULL, 
  V_DONVITHA_ID IN NVARCHAR2 DEFAULT NULL,
  V_CAP_THA IN VARCHAR2 DEFAULT NULL
)
RETURN SYS_REFCURSOR
IS 
  V_CURSOR sys_refcursor;
  V_EXPORT_TEXT CLOB; v_table TUPHAP_ANPHI_REPORT;
  V_COUNT_ALL NUMBER;V_COUNT_CHUANOP NUMBER;V_COUNT_DANOP NUMBER;
  V_TIEN_ALL NUMBER;V_TIEN_DANOP NUMBER;V_TIEN_CHUANOP NUMBER;V_TIEN_HOANTRA NUMBER:=0;V_VUVIEC_HOANTRA NUMBER:=0;
  V_LOAITOA VARCHAR2(150):=NULL; v_dem_tinh NUMBER:=0; v_dem_huyen NUMBER:=0;
  VV_DATE_FROM VARCHAR2(150):=NULL;VV_DATE_TO VARCHAR2(150):=NULL;V_TUNGAY DATE;V_DENNGAY DATE;
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
 v_table := TUPHAP_ANPHI_REPORT(); --dung bang ding nghia
 -----------------------
     IF(V_DATE_FROM IS NOT NULL) THEN
        V_TUNGAY:=TO_DATE(V_DATE_FROM||'00:00:00','dd/mm/yyyy hh24:mi:ss');
     END IF;
     IF(V_DATE_TO IS NOT NULL)THEN
        V_DENNGAY:=TO_DATE(V_DATE_TO||'23:59:59','dd/mm/yyyy hh24:mi:ss');
     END IF;
 ------------------------
 SELECT DECODE(V_DATE_FROM,NULL,'.....',V_DATE_FROM),DECODE(V_DATE_TO,NULL,'.....',V_DATE_TO) INTO VV_DATE_FROM,VV_DATE_TO FROM DUAL;
 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
            <tr style="text-align: center;">
                <th colspan="2" style="text-align: center; vertical-align: middle; height: 36px;">BỘ TƯ PHÁP</th>
                <th colspan="8" style="text-align: center; vertical-align: middle; font-size: 14pt;">THÔNG KÊ THÔNG TIN TẠM ỨNG ÁN PHÍ</th>
                <th colspan="2" style="text-align: center; vertical-align: middle;">Mẫu 1</th>
            </tr>
            <tr>
                <th colspan="2" style="text-align: center; vertical-align: top; height: 30px; font-weight: bold;">'||v_Names||'</th>
                <td colspan="8" style="text-align: center; vertical-align: top; font-style: italic;">Từ ngày '||VV_DATE_FROM||' đến ngày '||VV_DATE_TO||'</td>
                <td colspan="2" style="text-align: center; vertical-align: top; font-style: italic;"></td>
            </tr>
            <tr style="">
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 135px;">STT</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Đơn vị</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tổng số thông báo nộp tiền tạm ứng án phí</th>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tổng số thông báo đã nộp tiền tạm ứng án phí</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tổng số thông báo chưa nộp tiền tạm ứng án phí </td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tổng số vụ việc hoàn trả tạm ứng án phí</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tổng số vụ việc đình chỉ nộp tạm ứng án phí</td>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tổng số tiền tạm ứng án phí phải thu</th>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tổng số tiền tạm ứng án phí đã thu</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tổng số tiền tạm ứng án phí chưa nộp</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tổng số tiền tạm ứng án phí hoàn trả</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tổng số tiền đình chỉ nộp tạm ứng án phí</td>
            </tr>
            <tr style="font-style: italic;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">1</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">2</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">3</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">4</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">5</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">6</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">7</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">8</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">9</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">10</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">11</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">12</td>
            </tr>
           ');
          ----------------------TT lấy từ ngày dến ngày đã thanh toán cần code này
--            select to_char(jj.CREATED_DATE,'dd/MM/yyyy hh24:mi:ss'),tt.ma_thongbao from dvcqg_thanh_toan  tt 
--            left join dvcqg_thanh_toan_logs jj on jj.MA_THONGBAO=tt.ma_thongbao
--            where jj.ERROR_CODE=1 and tt.TRANGTHAITHANHTOAN=1 and tt.TT_TRUCTUYEN=1
--            order by jj.CREATED_DATE desc; nộp trực tuyến
--            TUPHAP_ANPHI lấy ngày "biên lai" để từ ngày đến ngày nếu nộp trực tiếp

          FOR item_tp IN 
            (
           SELECT COUNT(*) VUVIEC_HOANTRA,SUM(TA.ANPHIHOANTRA)ANPHIHOANTRA,THA.TEN,THA.ID
           FROM ADS_TONGDAT TD 
                INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ADS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id 
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID    
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID--THA.ARRTOAANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ADS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN (SELECT QD.DONID FROM ADS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi    
                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.MALOAIVUVIEC='2'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID 
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND TA.ANPHIHOANTRA !=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381) 
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
            GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
        item_tp.ID,item_tp.TEN,
        '2','Dân sự',0,0,0,0,item_tp.VUVIEC_HOANTRA,item_tp.ANPHIHOANTRA,
        0,0
        );  
    END LOOP;
         FOR item_tp IN 
            (
           SELECT COUNT(*) COUNT_DANOP,SUM(AI.TAMUNGANPHI)TIEN_DANOP,THA.TEN,THA.ID
            FROM ADS_TONGDAT TD 
                INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ADS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID    
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ADS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN (SELECT QD.DONID FROM ADS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi    
                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID  AND TT.MALOAIVUVIEC='2'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID 
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND TT.TRANGTHAITHANHTOAN=1  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                 ------
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
--                AND( ( ((gs.CREATED_DATE>=V_TUNGAY AND V_TUNGAY IS NOT NULL) OR V_TUNGAY IS NULL)  AND ((gs.CREATED_DATE<=V_DENNGAY AND V_DENNGAY IS NOT NULL)OR V_DENNGAY IS NULL)
--                     AND tt.TT_TRUCTUYEN=1)--thanh toán TT
--                    OR 
--                    ( ((TA.NGAYBIENLAI>=V_TUNGAY AND V_TUNGAY IS NOT NULL) OR V_TUNGAY IS NULL)  AND ((TA.NGAYBIENLAI<=V_DENNGAY AND V_DENNGAY IS NOT NULL)OR V_DENNGAY IS NULL)
--                     AND tt.TT_TRUCTUYEN=0  )--thanh toán trực tiếp
--                 )
           GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '2','Dân sự',item_tp.COUNT_DANOP,0,item_tp.TIEN_DANOP,0,0,0,
        0,0
        );  
    END LOOP;
     FOR item_tp IN 
            (
            SELECT COUNT(*) COUNT_DINHCHI,SUM(AI.TAMUNGANPHI)TIEN_DINHCHI,THA.TEN,THA.ID
            FROM ADS_TONGDAT TD 
                 INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ADS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID    
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID--THA.id thay = THA.ARRTOAANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ADS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                INNER JOIN (SELECT QD.DONID FROM ADS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi    
                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.MALOAIVUVIEC='2'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID 
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND TT.TRANGTHAITHANHTOAN=1  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '2','Dân sự',0,0,0,0,0,0,
        item_tp.COUNT_DINHCHI,item_tp.TIEN_DINHCHI
        );  
    END LOOP;
     FOR item_tp IN 
            (
            SELECT COUNT(*) COUNT_CHUANOP,SUM(AI.TAMUNGANPHI)TIEN_CHUANOP,THA.TEN,THA.ID
           FROM ADS_TONGDAT TD 
                 INNER JOIN ADS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ADS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID     
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ADS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN (SELECT QD.DONID FROM ADS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi    
                LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID=AI.DUONGSU_ID AND TT.MALOAIVUVIEC='2'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID AND TA.DUONGSU_ID=TT.DUONGSU_ID 
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                 AND TT.TRANGTHAITHANHTOAN=0  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381) 
                 AND AI.TAMUNGANPHI !=0
                  AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                 AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '2','Dân sự',0,item_tp.COUNT_CHUANOP,0,item_tp.TIEN_CHUANOP,0,0,
        0,0
        );  
    END LOOP;
         FOR item_tp IN 
            (
           SELECT COUNT(*) VUVIEC_HOANTRA,SUM(TA.ANPHIHOANTRA)ANPHIHOANTRA,THA.TEN,THA.ID
             FROM AHN_TONGDAT TD 
                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHN_ANPHI_DUONGSU DU LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID 
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM AHN_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='3'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE
                 TA.ANPHIHOANTRA !=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
                 AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '3','Hôn nhân',0,0,0,0,item_tp.VUVIEC_HOANTRA,item_tp.ANPHIHOANTRA,
        0,0
        );  
    END LOOP;
         FOR item_tp IN 
            (
           SELECT COUNT(*) COUNT_DANOP,SUM(AI.TAMUNGANPHI)TIEN_DANOP,THA.TEN,THA.ID
           FROM AHN_TONGDAT TD 
                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHN_ANPHI_DUONGSU DU LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID 
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM AHN_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='3'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE
                 TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
          GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '3','Hôn nhân',item_tp.COUNT_DANOP,0,item_tp.TIEN_DANOP,0,0,0,
        0,0
        );  
    END LOOP;
     FOR item_tp IN 
            (
           SELECT COUNT(*) COUNT_DINHCHI,SUM(AI.TAMUNGANPHI)TIEN_DINHCHI,THA.TEN,THA.ID
            FROM AHN_TONGDAT TD 
                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHN_ANPHI_DUONGSU DU LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID 
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                INNER JOIN (SELECT QD.DONID FROM AHN_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='3'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE TT.TRANGTHAITHANHTOAN=1  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
            GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '3','Hôn nhân',0,0,0,0,0,0,
        item_tp.COUNT_DINHCHI,item_tp.TIEN_DINHCHI
        );  
    END LOOP;
      FOR item_tp IN 
            (
            SELECT COUNT(*) COUNT_CHUANOP,SUM(AI.TAMUNGANPHI)TIEN_CHUANOP,THA.TEN,THA.ID
            FROM AHN_TONGDAT TD 
                INNER JOIN AHN_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHN_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHN_ANPHI_DUONGSU DU LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN AHN_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM AHN_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='3'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE TT.TRANGTHAITHANHTOAN=0  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '3','Hôn nhân',0,item_tp.COUNT_CHUANOP,0,item_tp.TIEN_CHUANOP,0,0,
        0,0
        );  
    END LOOP;
     FOR item_tp IN 
            (
             SELECT COUNT(*) VUVIEC_HOANTRA,SUM(TA.ANPHIHOANTRA)ANPHIHOANTRA,THA.TEN,THA.ID
              FROM AKT_TONGDAT TD 
                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AKT_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID   
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN AKT_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM AKT_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='4'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
                 AND TA.ANPHIHOANTRA !=0   AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                 AND AI.TAMUNGANPHI !=0
                 AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                 AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '4','Kinh tế',0,0,0,0,item_tp.VUVIEC_HOANTRA,item_tp.ANPHIHOANTRA,
        0,0
        );  
    END LOOP;
         FOR item_tp IN 
            (
             SELECT COUNT(*) COUNT_DANOP,SUM(AI.TAMUNGANPHI)TIEN_DANOP,THA.TEN,THA.ID
            FROM AKT_TONGDAT TD 
                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AKT_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID 
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN AKT_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM AKT_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='4'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
                AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
          GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '4','Kinh tế',item_tp.COUNT_DANOP,0,item_tp.TIEN_DANOP,0,0,0,
        0,0
        );  
    END LOOP;
      FOR item_tp IN 
                (
                SELECT COUNT(*) COUNT_DINHCHI,SUM(AI.TAMUNGANPHI)TIEN_DINHCHI,THA.TEN,THA.ID
                FROM AKT_TONGDAT TD 
                 INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AKT_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID   
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN AKT_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                INNER JOIN (SELECT QD.DONID FROM AKT_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='4'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
                AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
                 AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                 AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
                GROUP BY THA.TEN,THA.ID
               )
        LOOP
            v_table.extend;
            v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
            item_tp.ID,item_tp.TEN,
            '4','Kinh tế',0,0,0,0,0,0,
             item_tp.COUNT_DINHCHI,item_tp.TIEN_DINHCHI
            );  
        END LOOP;
         FOR item_tp IN 
            (
            SELECT COUNT(*) COUNT_CHUANOP,SUM(AI.TAMUNGANPHI)TIEN_CHUANOP,THA.TEN,THA.ID
             FROM AKT_TONGDAT TD 
                INNER JOIN AKT_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AKT_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID 
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN AKT_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM AKT_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='4'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
                AND TT.TRANGTHAITHANHTOAN=0  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
                 AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                 AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '4','Kinh tế',0,item_tp.COUNT_CHUANOP,0,item_tp.TIEN_CHUANOP,0,0,
        0,0
        );  
    END LOOP;
     FOR item_tp IN 
            (
             SELECT COUNT(*) VUVIEC_HOANTRA,SUM(TA.ANPHIHOANTRA)ANPHIHOANTRA,THA.TEN,THA.ID
           FROM ALD_TONGDAT TD 
                INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ALD_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID 
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ALD_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM ALD_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='5'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND TA.ANPHIHOANTRA !=0   AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '5','Lao động',0,0,0,0,item_tp.VUVIEC_HOANTRA,item_tp.ANPHIHOANTRA,
        0,0
        );  
    END LOOP;
         FOR item_tp IN 
            (
             SELECT COUNT(*) COUNT_DANOP,SUM(AI.TAMUNGANPHI)TIEN_DANOP,THA.TEN,THA.ID
           FROM ALD_TONGDAT TD 
                 INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ALD_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID  
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ALD_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM ALD_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='5'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
                AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '5','Lao động',item_tp.COUNT_DANOP,0,item_tp.TIEN_DANOP,0,0,0,
        0,0
        );  
    END LOOP;
     FOR item_tp IN 
            (
            SELECT COUNT(*) COUNT_DINHCHI,SUM(AI.TAMUNGANPHI)TIEN_DINHCHI,THA.TEN,THA.ID
             FROM ALD_TONGDAT TD 
               INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ALD_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID 
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ALD_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                INNER JOIN (SELECT QD.DONID FROM ALD_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='5'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0 
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))       
                GROUP BY THA.TEN,THA.ID
           )
    LOOP
        v_table.extend;
        v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '5','Lao động',0,0,0,0,0,0,
        item_tp.COUNT_DINHCHI,item_tp.TIEN_DINHCHI
        );  
    END LOOP;
      FOR item_tp IN 
            (
            SELECT COUNT(*) COUNT_CHUANOP,SUM(AI.TAMUNGANPHI)TIEN_CHUANOP,THA.TEN,THA.ID
            FROM ALD_TONGDAT TD 
                INNER JOIN ALD_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN ALD_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID  
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN ALD_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM ALD_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='5'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE DU.TUCACHTOTUNG_MA='NGUYENDON'
                AND TT.TRANGTHAITHANHTOAN=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '5','Lao động',0,item_tp.COUNT_CHUANOP,0,item_tp.TIEN_CHUANOP,0,0,
        0,0
        );  
    END LOOP;
    FOR item_tp IN 
            (
             SELECT COUNT(*)VUVIEC_HOANTRA,SUM(TA.ANPHIHOANTRA)ANPHIHOANTRA,THA.TEN,THA.ID
            FROM AHC_TONGDAT TD 
               INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHC_ANPHI_DUONGSU DU LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID   
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM AHC_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='6'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE TA.ANPHIHOANTRA !=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID=121
                AND AI.TAMUNGANPHI !=0
                 AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                 AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
          GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '6','Hành chính',0,0,0,0,item_tp.VUVIEC_HOANTRA,item_tp.ANPHIHOANTRA,
        0,0
        );  
    END LOOP;
         FOR item_tp IN 
            (
             SELECT COUNT(*) COUNT_DANOP,SUM(AI.TAMUNGANPHI)TIEN_DANOP,THA.TEN,THA.ID
            FROM AHC_TONGDAT TD 
                INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHC_ANPHI_DUONGSU DU LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM AHC_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='6'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID=121
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '6','Hành chính',item_tp.COUNT_DANOP,0,item_tp.TIEN_DANOP,0,0,0,
        0,0
        );  
    END LOOP;
    FOR item_tp IN 
            (
            SELECT COUNT(*) COUNT_DINHCHI,SUM(AI.TAMUNGANPHI)TIEN_DINHCHI,THA.TEN,THA.ID
               FROM AHC_TONGDAT TD 
               INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHC_ANPHI_DUONGSU DU LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID  
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                INNER JOIN (SELECT QD.DONID FROM AHC_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='6'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID=121
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID
           )
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '6','Hành chính',0,0,0,0,0,0,
        item_tp.COUNT_DINHCHI,item_tp.TIEN_DINHCHI
        );  
    END LOOP;
    FOR item_tp IN 
            (
            SELECT COUNT(*) COUNT_CHUANOP,SUM(AI.TAMUNGANPHI)TIEN_CHUANOP,THA.TEN,THA.ID
              FROM AHC_TONGDAT TD 
                INNER JOIN AHC_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN AHC_ANPHI AI ON TD.DONID=AI.DONID
                LEFT JOIN (SELECT LISTAGG('Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>', '')
                                   WITHIN GROUP (ORDER BY 'Họ tên:<b> '||HN.TENDUONGSU||'</b><br/> Năm sinh: '||HN.NAMSINH||'<br/> CCCD: '||HN.SOCMND||'<br/> Điên thoại: '||HN.DIENTHOAI||'<br/> Email: '||HN.EMAIL||'<br/>') TENDUONGSU ,
                             DU.ANPHI_ID
                             FROM AHC_ANPHI_DUONGSU DU LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID=DU.DUONGSU_ID
                             GROUP BY DU.ANPHI_ID
                          )AP ON AP.ANPHI_ID=AI.ID
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID 
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN AHC_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM AHC_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
                LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='6'
                --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
                LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
                WHERE TT.TRANGTHAITHANHTOAN=0  AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID=121
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '6','Hành chính',0,item_tp.COUNT_CHUANOP,0,item_tp.TIEN_CHUANOP,0,0,
        0,0
        );  
    END LOOP;
    FOR item_tp IN 
            (
             SELECT COUNT(*) VUVIEC_HOANTRA,SUM(TA.ANPHIHOANTRA)ANPHIHOANTRA,THA.TEN,THA.ID
            FROM APS_TONGDAT TD 
                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN APS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
               -- INNER JOIN APS_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID   
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN APS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
--                LEFT JOIN APS_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
                LEFT JOIN (SELECT QD.DONID FROM APS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
               LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='7'
               --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
               LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
               WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
                AND TA.ANPHIHOANTRA !=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381) 
                AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
             GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '7','Phá sản',0,0,0,0,item_tp.VUVIEC_HOANTRA,item_tp.ANPHIHOANTRA,
        0,0
        );  
    END LOOP;
         FOR item_tp IN 
            (
             SELECT COUNT(*) COUNT_DANOP,SUM(AI.TAMUNGANPHI)TIEN_DANOP,THA.TEN,THA.ID
             FROM APS_TONGDAT TD 
                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN APS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID  
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN APS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM APS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
               LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='7'
               --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
               LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
               WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
               AND TA.ANPHIHOANTRA !=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
               AND AI.TAMUNGANPHI !=0
               AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
               AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
           GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '7','Phá sản',item_tp.COUNT_DANOP,0,item_tp.TIEN_DANOP,0,0,0,
        0,0
        );  
    END LOOP;
    FOR item_tp IN 
            (
            SELECT COUNT(*) COUNT_DINHCHI,SUM(AI.TAMUNGANPHI)TIEN_DINHCHI,THA.TEN,THA.ID
             FROM APS_TONGDAT TD 
                 INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN APS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN APS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                INNER JOIN (SELECT QD.DONID FROM APS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
               LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='7'
               --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
               LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
               WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
               AND TT.TRANGTHAITHANHTOAN=1 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
               AND AI.TAMUNGANPHI !=0
                AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
            GROUP BY THA.TEN,THA.ID
           )
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '7','Phá sản',0,0,0,0,0,0,
        item_tp.COUNT_DINHCHI,item_tp.TIEN_DINHCHI
        );  
    END LOOP;
    FOR item_tp IN 
            (
            SELECT COUNT(*) COUNT_CHUANOP,SUM(AI.TAMUNGANPHI)TIEN_CHUANOP,THA.TEN,THA.ID
            FROM APS_TONGDAT TD 
                INNER JOIN APS_DON DO ON TD.DONID=DO.ID     
                INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
                INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                INNER JOIN APS_ANPHI AI ON TD.DONID=AI.DONID
                INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID=DU.id
                INNER JOIN DM_TOAAN_THIHANHAN_MAP THM ON THM.TOAANID=TN.ID 
                INNER JOIN DM_DONVITHIHANHAN THA ON THA.id=THM.THIHANHANID
                LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
                LEFT JOIN APS_DON_XULY DX ON DX.DONID=TD.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
                LEFT JOIN (SELECT QD.DONID FROM APS_SOTHAM_QUYETDINH  QD 
                            INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi 
               LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID=TD.DONID AND TT.MALOAIVUVIEC='7'
               --LEFT JOIN (select mm.* from dvcqg_thanh_toan_logs mm where mm.ERROR_CODE=1)gs on gs.MA_THONGBAO=tt.ma_thongbao
               LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID=TT.ID
               WHERE DU.TUCACHTOTUNG_MA='NGUYENDON' 
               AND TT.TRANGTHAITHANHTOAN=0 AND TT.MA_THONGBAO IS NOT NULL AND TD.BIEUMAUID IN(67,381)
               AND AI.TAMUNGANPHI !=0
               AND (V_TT_TRUCTUYEN IS NULL OR (TT.TT_TRUCTUYEN=V_TT_TRUCTUYEN))
                AND ((V_TUNGAY IS NULL OR AI.NGAYTHONGBAO>=V_TUNGAY) AND (V_DENNGAY IS NULL  OR AI.NGAYTHONGBAO<=V_DENNGAY))
          GROUP BY THA.TEN,THA.ID)
    LOOP
        v_table.extend;
         v_table(v_table.count) := TUPHAP_ANPHI_REPORT_ROW(
         item_tp.ID,item_tp.TEN,
        '7','Phá sản',0,item_tp.COUNT_CHUANOP,0,item_tp.TIEN_CHUANOP,0,0,
        0,0
        );  
    END LOOP;
    ----------------------------
    ----------------------------
    ----------------------------
    IF (V_CAP_THA='TH') THEN
    --------cap tinh------------------------------------
     FOR item_court IN (
        SELECT TT.DONVITHA_ID,TT.DONVITHA_TEN,TT.ARRTHUTU,SUM(TT.ALL_COUNTS)ALL_COUNTS,
        SUM(TT.COUNT_DANOP)COUNT_DANOP,SUM(TT.COUNT_CHUANOP)COUNT_CHUANOP,SUM(TT.VUVIEC_HOANTRA)VUVIEC_HOANTRA,
        SUM(ALL_TIEN) ALL_TIEN,SUM(TT.TIEN_DANOP)TIEN_DANOP,SUM(TT.TIEN_CHUANOP)TIEN_CHUANOP,
        SUM(TT.TIEN_HOANTRA)TIEN_HOANTRA,SUM(TT.COUNT_DINHCHI)COUNT_DINHCHI,SUM(TT.TIEN_DINHCHI)TIEN_DINHCHI
        FROM (
                 SELECT TP.DONVITHA_ID,TP.DONVITHA_TEN,TH.ARRTHUTU,SUM(TP.COUNT_DANOP+TP.COUNT_CHUANOP) ALL_COUNTS,
                 SUM(TP.COUNT_DANOP)COUNT_DANOP,SUM(TP.COUNT_CHUANOP)COUNT_CHUANOP,SUM(TP.VUVIEC_HOANTRA)VUVIEC_HOANTRA,
                 SUM(TP.TIEN_DANOP+TP.TIEN_CHUANOP) ALL_TIEN,SUM(TP.TIEN_DANOP)TIEN_DANOP,SUM(TP.TIEN_CHUANOP)TIEN_CHUANOP,
                 SUM(TP.TIEN_HOANTRA)TIEN_HOANTRA,SUM(TP.COUNT_DINHCHI)COUNT_DINHCHI,SUM(TP.TIEN_DINHCHI)TIEN_DINHCHI
                 FROM TABLE(v_table) TP 
                 LEFT JOIN DM_DONVITHIHANHAN TH ON TH.ID=TP.DONVITHA_ID
                 WHERE TH.LOAITOA='CAPTINH' --lay du lieu cap tinh va lay SUM(TP.COUNT_DANOP+TP.COUNT_CHUANOP) ALL_COUNTS
                 AND ((instr(','||V_DONVITHA_ID||',',','||TP.DONVITHA_ID||',')>0 AND V_DONVITHA_ID IS NOT NULL) OR (V_DONVITHA_ID IS NULL))
                 GROUP BY TP.DONVITHA_ID,TP.DONVITHA_TEN,TH.ARRTHUTU
             UNION ALL 
                 SELECT TH1.ID DONVITHA_ID,TH1.TEN DONVITHA_TEN,TH1.ARRTHUTU,SUM(0) ALL_COUNTS,SUM(0) COUNT_DANOP,SUM(0) COUNT_CHUANOP,
                 SUM(0)VUVIEC_HOANTRA,SUM(0)ALL_TIEN,SUM(0)TIEN_DANOP,SUM(0)TIEN_CHUANOP,SUM(0)TIEN_HOANTRA,
                 SUM(0)COUNT_DINHCHI,SUM(0)TIEN_DINHCHI
                 FROM TABLE(v_table) TP 
                 LEFT JOIN DM_DONVITHIHANHAN TH ON TH.ID=TP.DONVITHA_ID
                 LEFT JOIN DM_DONVITHIHANHAN TH1 ON TH1.ID=TH.CAPCHAID
                 WHERE TH.LOAITOA='CAPHUYEN' -- dua vao cap huyen de lay cap cha thuoc tinh nao
                 AND ((instr(','||V_DONVITHA_ID||',',','||TH1.ID||',')>0 AND V_DONVITHA_ID IS NOT NULL) OR (V_DONVITHA_ID IS NULL))
                 GROUP BY TH1.ID,TH1.TEN,TH1.ARRTHUTU
            )TT GROUP BY TT.DONVITHA_ID,TT.DONVITHA_TEN,TT.ARRTHUTU
        )
    LOOP    
    v_dem_tinh:=v_dem_tinh+1;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <tr>
                <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||v_dem_tinh||'</td>
                <th style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||item_court.DONVITHA_TEN||'</th>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.ALL_COUNTS||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.VUVIEC_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_DINHCHI||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.ALL_TIEN||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_DINHCHI||'</td>
            </tr>
       ');
       v_dem_huyen:=0;
       --cap huyen
       FOR item_court_chil IN (
                 SELECT TP.DONVITHA_ID,TP.DONVITHA_TEN,SUM(TP.COUNT_DANOP+TP.COUNT_CHUANOP) ALL_COUNTS,
                 SUM(TP.COUNT_DANOP)COUNT_DANOP,SUM(TP.COUNT_CHUANOP)COUNT_CHUANOP,SUM(TP.VUVIEC_HOANTRA)VUVIEC_HOANTRA,
                 SUM(TP.TIEN_DANOP+TP.TIEN_CHUANOP) ALL_TIEN,SUM(TP.TIEN_DANOP)TIEN_DANOP,SUM(TP.TIEN_CHUANOP)TIEN_CHUANOP,
                 SUM(TP.TIEN_HOANTRA)TIEN_HOANTRA,SUM(TP.COUNT_DINHCHI)COUNT_DINHCHI,SUM(TP.TIEN_DINHCHI)TIEN_DINHCHI
                 FROM TABLE(v_table) TP INNER JOIN DM_DONVITHIHANHAN TH ON TH.ID=TP.DONVITHA_ID
                 WHERE TH.CAPCHAID=item_court.DONVITHA_ID
                 GROUP BY TP.DONVITHA_ID,TP.DONVITHA_TEN,TH.ARRTHUTU ORDER BY TH.ARRTHUTU
                )
    LOOP
     v_dem_huyen:=v_dem_huyen+1;
      DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <tr>
                <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;"></td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||v_dem_tinh||'.'||v_dem_huyen||'.'||item_court_chil.DONVITHA_TEN||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court_chil.ALL_COUNTS||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court_chil.COUNT_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court_chil.COUNT_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court_chil.VUVIEC_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court_chil.COUNT_DINHCHI||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court_chil.ALL_TIEN||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court_chil.TIEN_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court_chil.TIEN_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court_chil.TIEN_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court_chil.TIEN_DINHCHI||'</td>
            </tr>
       ');
     END LOOP;
    END LOOP;
    ---------Tong cong
     FOR item_court IN (
                 SELECT SUM(TP.COUNT_DANOP+TP.COUNT_CHUANOP) ALL_COUNTS,
                 SUM(TP.COUNT_DANOP)COUNT_DANOP,SUM(TP.COUNT_CHUANOP)COUNT_CHUANOP,SUM(TP.VUVIEC_HOANTRA)VUVIEC_HOANTRA,
                 SUM(TP.TIEN_DANOP+TP.TIEN_CHUANOP) ALL_TIEN,SUM(TP.TIEN_DANOP)TIEN_DANOP,SUM(TP.TIEN_CHUANOP)TIEN_CHUANOP,
                 SUM(TP.TIEN_HOANTRA)TIEN_HOANTRA,SUM(TP.COUNT_DINHCHI)COUNT_DINHCHI,SUM(TP.TIEN_DINHCHI)TIEN_DINHCHI
                 FROM TABLE(v_table) TP 
                 INNER JOIN DM_DONVITHIHANHAN TH ON TH.ID=TP.DONVITHA_ID
                 WHERE   ((instr(','||V_DONVITHA_ID||',',','||TH.ID||',')>0 AND V_DONVITHA_ID IS NOT NULL) OR (V_DONVITHA_ID IS NULL))
                         OR ((instr(','||V_DONVITHA_ID||',',','||TH.CAPCHAID||',')>0 AND V_DONVITHA_ID IS NOT NULL) OR (V_DONVITHA_ID IS NULL))
                )
    LOOP
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="font-weight:bold;">
                <th style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;" colspan="2">Tổng cộng</th>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.ALL_COUNTS||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.VUVIEC_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_DINHCHI||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.ALL_TIEN||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_DINHCHI||'</td>
            </tr>
    ');
    END LOOP;
    ------------------------------------------------
   ELSIF(V_CAP_THA='T') THEN
     --------cap tinh------------------------------------
     FOR item_court IN (
                 SELECT TP.DONVITHA_ID,TP.DONVITHA_TEN,TH.ARRTHUTU,SUM(TP.COUNT_DANOP+TP.COUNT_CHUANOP) ALL_COUNTS,
                 SUM(TP.COUNT_DANOP)COUNT_DANOP,SUM(TP.COUNT_CHUANOP)COUNT_CHUANOP,SUM(TP.VUVIEC_HOANTRA)VUVIEC_HOANTRA,
                 SUM(TP.TIEN_DANOP+TP.TIEN_CHUANOP) ALL_TIEN,SUM(TP.TIEN_DANOP)TIEN_DANOP,SUM(TP.TIEN_CHUANOP)TIEN_CHUANOP,
                 SUM(TP.TIEN_HOANTRA)TIEN_HOANTRA,SUM(TP.COUNT_DINHCHI)COUNT_DINHCHI,SUM(TP.TIEN_DINHCHI)TIEN_DINHCHI
                 FROM TABLE(v_table) TP INNER JOIN DM_DONVITHIHANHAN TH ON TH.ID=TP.DONVITHA_ID
                 WHERE TH.LOAITOA='CAPTINH' --lay du lieu cap tinh va lay SUM(TP.COUNT_DANOP+TP.COUNT_CHUANOP) ALL_COUNTS
                 AND ((instr(','||V_DONVITHA_ID||',',','||TP.DONVITHA_ID||',')>0 AND V_DONVITHA_ID IS NOT NULL) OR (V_DONVITHA_ID IS NULL))
                 GROUP BY TP.DONVITHA_ID,TP.DONVITHA_TEN,TH.ARRTHUTU
        )
    LOOP    
    v_dem_tinh:=v_dem_tinh+1;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <tr>
                <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||v_dem_tinh||'</td>
                <th style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||item_court.DONVITHA_TEN||'</th>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.ALL_COUNTS||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.VUVIEC_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_DINHCHI||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.ALL_TIEN||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_DINHCHI||'</td>
            </tr>
       ');
    END LOOP;
    ---------Tong cong
     FOR item_court IN (
                 SELECT SUM(TP.COUNT_DANOP+TP.COUNT_CHUANOP) ALL_COUNTS,
                 SUM(TP.COUNT_DANOP)COUNT_DANOP,SUM(TP.COUNT_CHUANOP)COUNT_CHUANOP,SUM(TP.VUVIEC_HOANTRA)VUVIEC_HOANTRA,
                 SUM(TP.TIEN_DANOP+TP.TIEN_CHUANOP) ALL_TIEN,SUM(TP.TIEN_DANOP)TIEN_DANOP,SUM(TP.TIEN_CHUANOP)TIEN_CHUANOP,
                 SUM(TP.TIEN_HOANTRA)TIEN_HOANTRA,SUM(TP.COUNT_DINHCHI)COUNT_DINHCHI,SUM(TP.TIEN_DINHCHI)TIEN_DINHCHI
                 FROM TABLE(v_table) TP 
                 INNER JOIN DM_DONVITHIHANHAN TH ON TH.ID=TP.DONVITHA_ID
                 WHERE  TH.LOAITOA='CAPTINH'
                AND ((instr(','||V_DONVITHA_ID||',',','||TH.ID||',')>0 AND V_DONVITHA_ID IS NOT NULL) OR (V_DONVITHA_ID IS NULL))
                )
    LOOP
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="font-weight:bold;">
                <th style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;" colspan="2">Tổng cộng</th>   
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.ALL_COUNTS||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.VUVIEC_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_DINHCHI||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.ALL_TIEN||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_DINHCHI||'</td>
            </tr>
    ');
    END LOOP;
   ELSIF(V_CAP_THA='H') THEN
     FOR item_court IN (
                 SELECT TP.DONVITHA_ID,TP.DONVITHA_TEN,TH.ARRTHUTU,SUM(TP.COUNT_DANOP+TP.COUNT_CHUANOP) ALL_COUNTS,
                 SUM(TP.COUNT_DANOP)COUNT_DANOP,SUM(TP.COUNT_CHUANOP)COUNT_CHUANOP,SUM(TP.VUVIEC_HOANTRA)VUVIEC_HOANTRA,
                 SUM(TP.TIEN_DANOP+TP.TIEN_CHUANOP) ALL_TIEN,SUM(TP.TIEN_DANOP)TIEN_DANOP,SUM(TP.TIEN_CHUANOP)TIEN_CHUANOP,
                 SUM(TP.TIEN_HOANTRA)TIEN_HOANTRA,SUM(TP.COUNT_DINHCHI)COUNT_DINHCHI,SUM(TP.TIEN_DINHCHI)TIEN_DINHCHI
                 FROM TABLE(v_table) TP INNER JOIN DM_DONVITHIHANHAN TH ON TH.ID=TP.DONVITHA_ID
                 WHERE TH.LOAITOA='CAPHUYEN' --lay du lieu cap tinh va lay SUM(TP.COUNT_DANOP+TP.COUNT_CHUANOP) ALL_COUNTS
                 AND ( (V_OPTIONS=1 AND ((instr(','||V_DONVITHA_ID||',',','||TP.DONVITHA_ID||',')>0 AND V_DONVITHA_ID IS NOT NULL) OR (V_DONVITHA_ID IS NULL)))
                        OR (V_OPTIONS=2 AND (TH.CAPCHAID=V_DONVITHA_ID))
                    )
                 GROUP BY TP.DONVITHA_ID,TP.DONVITHA_TEN,TH.ARRTHUTU
        )
    LOOP    
    v_dem_tinh:=v_dem_tinh+1;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <tr>
                <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||v_dem_tinh||'</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||item_court.DONVITHA_TEN||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.ALL_COUNTS||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.VUVIEC_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_DINHCHI||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.ALL_TIEN||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_DINHCHI||'</td>
            </tr>
       ');
    END LOOP;
    ---------Tong cong
     FOR item_court IN (
                 SELECT SUM(TP.COUNT_DANOP+TP.COUNT_CHUANOP) ALL_COUNTS,
                 SUM(TP.COUNT_DANOP)COUNT_DANOP,SUM(TP.COUNT_CHUANOP)COUNT_CHUANOP,SUM(TP.VUVIEC_HOANTRA)VUVIEC_HOANTRA,
                 SUM(TP.TIEN_DANOP+TP.TIEN_CHUANOP) ALL_TIEN,SUM(TP.TIEN_DANOP)TIEN_DANOP,SUM(TP.TIEN_CHUANOP)TIEN_CHUANOP,
                 SUM(TP.TIEN_HOANTRA)TIEN_HOANTRA,SUM(TP.COUNT_DINHCHI)COUNT_DINHCHI,SUM(TP.TIEN_DINHCHI)TIEN_DINHCHI
                 -----------
--                 SELECT SUM(TP.COUNT_DANOP+TP.COUNT_CHUANOP) ALL_COUNTS,
--                 SUM(TP.COUNT_DANOP)COUNT_DANOP,SUM(TP.COUNT_CHUANOP)COUNT_CHUANOP,SUM(TP.VUVIEC_HOANTRA)VUVIEC_HOANTRA,
--                 SUM(TP.COUNT_DINHCHI)COUNT_DINHCHI,
--                 TO_CHAR(SUM(TP.TIEN_DANOP+TP.TIEN_CHUANOP),'FM999G999G999G999') ALL_TIEN,
--                 TO_CHAR(SUM(TP.TIEN_DANOP),'FM999G999G999G999')TIEN_DANOP,
--                 TO_CHAR(SUM(TP.TIEN_CHUANOP),'FM999G999G999G999')TIEN_CHUANOP,
--                 TO_CHAR(SUM(TP.TIEN_HOANTRA),'FM999G999G999G999')TIEN_HOANTRA,                 
--                 TO_CHAR(SUM(TP.TIEN_DINHCHI),'FM999G999G999G999')TIEN_DINHCHI
                 ----------
                 FROM TABLE(v_table) TP 
                 INNER JOIN DM_DONVITHIHANHAN TH ON TH.ID=TP.DONVITHA_ID
                 WHERE  TH.LOAITOA='CAPHUYEN'
                 AND ( (V_OPTIONS=1 AND ((instr(','||V_DONVITHA_ID||',',','||TP.DONVITHA_ID||',')>0 AND V_DONVITHA_ID IS NOT NULL) OR (V_DONVITHA_ID IS NULL)))
                        OR (V_OPTIONS=2 AND (TH.CAPCHAID=V_DONVITHA_ID))
                    )
               --  AND  TP.MA_LOAIAN='2'
                )
    LOOP
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="font-weight:bold;">
                <th style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;" colspan="2">Tổng cộng</th>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.ALL_COUNTS||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.VUVIEC_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.COUNT_DINHCHI||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.ALL_TIEN||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_DANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_CHUANOP||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_HOANTRA||'</td>
                <td style="border: 0.1pt solid Black; text-align: right; vertical-align: middle;">'||item_court.TIEN_DINHCHI||'</td>
            </tr>
    ');
    END LOOP;
   END IF;

     --định nghĩa độ rộng của cột
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <tr style="height: 0px;">
                <td style="width: 47px"></td>
                <td style="width: 260px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
            </tr>
   </table>
    ');
     OPEN v_cursor FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN v_cursor;   
END;

FUNCTION GET_BAOCAO_BIENLAIANPHI
(
  V_TT_TRUCTUYEN IN VARCHAR2 DEFAULT NULL, 
  v_Names NVARCHAR2 DEFAULT NULL,
  V_OPTIONS IN NUMBER,
  V_DATE_FROM IN VARCHAR2 DEFAULT NULL,  
  V_DATE_TO IN VARCHAR2 DEFAULT NULL, 
  V_DONVITHA_ID IN NVARCHAR2 DEFAULT NULL,
  V_CAP_THA IN VARCHAR2 DEFAULT NULL
)
RETURN SYS_REFCURSOR IS 
  V_CURSOR sys_refcursor;
  V_EXPORT_TEXT CLOB; v_table TUPHAP_ANPHI_REPORT;
  V_COUNT_ALL NUMBER;V_COUNT_CHUANOP NUMBER;V_COUNT_DANOP NUMBER;
  V_TIEN_ALL NUMBER;V_TIEN_DANOP NUMBER;V_TIEN_CHUANOP NUMBER;V_TIEN_HOANTRA NUMBER:=0;V_VUVIEC_HOANTRA NUMBER:=0;
  V_LOAITOA VARCHAR2(150):=NULL; v_dem_tinh NUMBER:=0; v_dem_huyen NUMBER:=0;
  VV_DATE_FROM VARCHAR2(150):=NULL;VV_DATE_TO VARCHAR2(150):=NULL;V_TUNGAY DATE;V_DENNGAY DATE;
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
 v_table := TUPHAP_ANPHI_REPORT(); --dung bang ding nghia
 -----------------------
     IF(V_DATE_FROM IS NOT NULL) THEN
        V_TUNGAY:=TO_DATE(V_DATE_FROM||'00:00:00','dd/mm/yyyy hh24:mi:ss');
     END IF;
     IF(V_DATE_TO IS NOT NULL)THEN
        V_DENNGAY:=TO_DATE(V_DATE_TO||'23:59:59','dd/mm/yyyy hh24:mi:ss');
     END IF;
 ------------------------
 
 OPEN V_CURSOR FOR
     SELECT 
      SOBIENLAI, 
      NGAYBIENLAI, 
      SOLUONG,
      TAMUNGANPHI, 
      GHICHU_HOANTRA, 
      TENDONVI, 
      DONVIID 
    FROM 
      (
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          ADS_TONGDAT TD 
          INNER JOIN ADS_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN ADS_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN ADS_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              ADS_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi    
          LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID = AI.DUONGSU_ID 
          AND TT.MALOAIVUVIEC = '2' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          AND TA.DUONGSU_ID = TT.DUONGSU_ID 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TA.ANPHIHOANTRA != 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          ADS_TONGDAT TD 
          INNER JOIN ADS_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN ADS_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN ADS_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              ADS_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi    
          LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID = AI.DUONGSU_ID 
          AND TT.MALOAIVUVIEC = '2' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          AND TA.DUONGSU_ID = TT.DUONGSU_ID 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TT.TRANGTHAITHANHTOAN = 1 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) ------
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          ADS_TONGDAT TD 
          INNER JOIN ADS_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN ADS_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN ADS_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          INNER JOIN (
            SELECT 
              QD.DONID 
            FROM 
              ADS_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi    
          LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID = AI.DUONGSU_ID 
          AND TT.MALOAIVUVIEC = '2' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          AND TA.DUONGSU_ID = TT.DUONGSU_ID 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TT.TRANGTHAITHANHTOAN = 1 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          ADS_TONGDAT TD 
          INNER JOIN ADS_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN ADS_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN ADS_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN ADS_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              ADS_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi    
          LEFT JOIN DVCQG_THANH_TOAN TT ON tt.DUONGSU_ID = AI.DUONGSU_ID 
          AND TT.MALOAIVUVIEC = '2' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          AND TA.DUONGSU_ID = TT.DUONGSU_ID 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TT.TRANGTHAITHANHTOAN = 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          AHN_TONGDAT TD 
          INNER JOIN AHN_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN AHN_ANPHI AI ON TD.DONID = AI.DONID 
          LEFT JOIN (
            SELECT 
              LISTAGG(
                'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>', 
                ''
              ) WITHIN GROUP (
                ORDER BY 
                  'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>'
              ) TENDUONGSU, 
              DU.ANPHI_ID 
            FROM 
              AHN_ANPHI_DUONGSU DU 
              LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID = DU.DUONGSU_ID 
            GROUP BY 
              DU.ANPHI_ID
          ) AP ON AP.ANPHI_ID = AI.ID 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN AHN_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              AHN_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '3' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND TA.ANPHIHOANTRA != 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          AHN_TONGDAT TD 
          INNER JOIN AHN_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN AHN_ANPHI AI ON TD.DONID = AI.DONID 
          LEFT JOIN (
            SELECT 
              LISTAGG(
                'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>', 
                ''
              ) WITHIN GROUP (
                ORDER BY 
                  'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>'
              ) TENDUONGSU, 
              DU.ANPHI_ID 
            FROM 
              AHN_ANPHI_DUONGSU DU 
              LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID = DU.DUONGSU_ID 
            GROUP BY 
              DU.ANPHI_ID
          ) AP ON AP.ANPHI_ID = AI.ID 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN AHN_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              AHN_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '3' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND TT.TRANGTHAITHANHTOAN = 1 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          AHN_TONGDAT TD 
          INNER JOIN AHN_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN AHN_ANPHI AI ON TD.DONID = AI.DONID 
          LEFT JOIN (
            SELECT 
              LISTAGG(
                'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>', 
                ''
              ) WITHIN GROUP (
                ORDER BY 
                  'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>'
              ) TENDUONGSU, 
              DU.ANPHI_ID 
            FROM 
              AHN_ANPHI_DUONGSU DU 
              LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID = DU.DUONGSU_ID 
            GROUP BY 
              DU.ANPHI_ID
          ) AP ON AP.ANPHI_ID = AI.ID 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN AHN_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          INNER JOIN (
            SELECT 
              QD.DONID 
            FROM 
              AHN_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '3' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND TT.TRANGTHAITHANHTOAN = 1 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          AHN_TONGDAT TD 
          INNER JOIN AHN_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN AHN_ANPHI AI ON TD.DONID = AI.DONID 
          LEFT JOIN (
            SELECT 
              LISTAGG(
                'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>', 
                ''
              ) WITHIN GROUP (
                ORDER BY 
                  'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>'
              ) TENDUONGSU, 
              DU.ANPHI_ID 
            FROM 
              AHN_ANPHI_DUONGSU DU 
              LEFT JOIN AHN_DON_DUONGSU HN ON HN.ID = DU.DUONGSU_ID 
            GROUP BY 
              DU.ANPHI_ID
          ) AP ON AP.ANPHI_ID = AI.ID 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN AHN_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              AHN_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '3' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND TT.TRANGTHAITHANHTOAN = 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          AKT_TONGDAT TD 
          INNER JOIN AKT_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN AKT_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN AKT_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              AKT_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '4' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TA.ANPHIHOANTRA != 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          AKT_TONGDAT TD 
          INNER JOIN AKT_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN AKT_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN AKT_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              AKT_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '4' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TT.TRANGTHAITHANHTOAN = 1 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          AKT_TONGDAT TD 
          INNER JOIN AKT_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN AKT_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN AKT_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          INNER JOIN (
            SELECT 
              QD.DONID 
            FROM 
              AKT_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '4' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TT.TRANGTHAITHANHTOAN = 1 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          AKT_TONGDAT TD 
          INNER JOIN AKT_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN AKT_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN AKT_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN AKT_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              AKT_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '4' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TT.TRANGTHAITHANHTOAN = 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          ALD_TONGDAT TD 
          INNER JOIN ALD_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN ALD_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN ALD_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              ALD_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '5' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TA.ANPHIHOANTRA != 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          ALD_TONGDAT TD 
          INNER JOIN ALD_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN ALD_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN ALD_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              ALD_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '5' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TT.TRANGTHAITHANHTOAN = 1 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          ALD_TONGDAT TD 
          INNER JOIN ALD_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN ALD_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN ALD_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          INNER JOIN (
            SELECT 
              QD.DONID 
            FROM 
              ALD_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '5' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TT.TRANGTHAITHANHTOAN = 1 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          ALD_TONGDAT TD 
          INNER JOIN ALD_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN ALD_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN ALD_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN ALD_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              ALD_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '5' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TT.TRANGTHAITHANHTOAN = 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          AHC_TONGDAT TD 
          INNER JOIN AHC_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN AHC_ANPHI AI ON TD.DONID = AI.DONID 
          LEFT JOIN (
            SELECT 
              LISTAGG(
                'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>', 
                ''
              ) WITHIN GROUP (
                ORDER BY 
                  'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>'
              ) TENDUONGSU, 
              DU.ANPHI_ID 
            FROM 
              AHC_ANPHI_DUONGSU DU 
              LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID = DU.DUONGSU_ID 
            GROUP BY 
              DU.ANPHI_ID
          ) AP ON AP.ANPHI_ID = AI.ID 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN AHC_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              AHC_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '6' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND TA.ANPHIHOANTRA != 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID = 121 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          AHC_TONGDAT TD 
          INNER JOIN AHC_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN AHC_ANPHI AI ON TD.DONID = AI.DONID 
          LEFT JOIN (
            SELECT 
              LISTAGG(
                'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>', 
                ''
              ) WITHIN GROUP (
                ORDER BY 
                  'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>'
              ) TENDUONGSU, 
              DU.ANPHI_ID 
            FROM 
              AHC_ANPHI_DUONGSU DU 
              LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID = DU.DUONGSU_ID 
            GROUP BY 
              DU.ANPHI_ID
          ) AP ON AP.ANPHI_ID = AI.ID 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN AHC_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              AHC_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '6' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND TT.TRANGTHAITHANHTOAN = 1 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID = 121 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          AHC_TONGDAT TD 
          INNER JOIN AHC_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN AHC_ANPHI AI ON TD.DONID = AI.DONID 
          LEFT JOIN (
            SELECT 
              LISTAGG(
                'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>', 
                ''
              ) WITHIN GROUP (
                ORDER BY 
                  'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>'
              ) TENDUONGSU, 
              DU.ANPHI_ID 
            FROM 
              AHC_ANPHI_DUONGSU DU 
              LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID = DU.DUONGSU_ID 
            GROUP BY 
              DU.ANPHI_ID
          ) AP ON AP.ANPHI_ID = AI.ID 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN AHC_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          INNER JOIN (
            SELECT 
              QD.DONID 
            FROM 
              AHC_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '6' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND TT.TRANGTHAITHANHTOAN = 1 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID = 121 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          AHC_TONGDAT TD 
          INNER JOIN AHC_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN AHC_ANPHI AI ON TD.DONID = AI.DONID 
          LEFT JOIN (
            SELECT 
              LISTAGG(
                'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>', 
                ''
              ) WITHIN GROUP (
                ORDER BY 
                  'Họ tên:<b> ' || HN.TENDUONGSU || '</b><br/> Năm sinh: ' || HN.NAMSINH || '<br/> CCCD: ' || HN.SOCMND || '<br/> Điên thoại: ' || HN.DIENTHOAI || '<br/> Email: ' || HN.EMAIL || '<br/>'
              ) TENDUONGSU, 
              DU.ANPHI_ID 
            FROM 
              AHC_ANPHI_DUONGSU DU 
              LEFT JOIN AHC_DON_DUONGSU HN ON HN.ID = DU.DUONGSU_ID 
            GROUP BY 
              DU.ANPHI_ID
          ) AP ON AP.ANPHI_ID = AI.ID 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN AHC_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              AHC_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '6' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND TT.TRANGTHAITHANHTOAN = 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID = 121 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          APS_TONGDAT TD 
          INNER JOIN APS_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN APS_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id -- INNER JOIN APS_TONGDAT_DOITUONG DO ON DO.DUONGSUID =DU.id
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN APS_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID --                LEFT JOIN APS_FILE FL ON FL.DONID=TD.DONID AND FL.BIEUMAUID=67
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              APS_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '7' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TA.ANPHIHOANTRA != 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          APS_TONGDAT TD 
          INNER JOIN APS_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN APS_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN APS_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              APS_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '7' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TA.ANPHIHOANTRA != 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          APS_TONGDAT TD 
          INNER JOIN APS_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN APS_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN APS_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          INNER JOIN (
            SELECT 
              QD.DONID 
            FROM 
              APS_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '7' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TT.TRANGTHAITHANHTOAN = 1 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          ) 
        UNION ALL 
        SELECT 
          TA.SOBIENLAI, 
          TA.NGAYBIENLAI, 
          AI.TAMUNGANPHI, 
          1 SOLUONG,
          TA.GHICHU_HOANTRA, 
          THA.TEN TENDONVI, 
          THA.ID DONVIID 
        FROM 
          APS_TONGDAT TD 
          INNER JOIN APS_DON DO ON TD.DONID = DO.ID 
          INNER JOIN DM_TOAAN TN ON TN.ID = DO.TOAANID 
          INNER JOIN DM_BIEUMAU BM ON BM.ID = TD.BIEUMAUID 
          INNER JOIN APS_ANPHI AI ON TD.DONID = AI.DONID 
          INNER JOIN APS_DON_DUONGSU DU ON AI.DUONGSU_ID = DU.id 
          INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID = TN.ID 
          LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID = HC.ID 
          LEFT JOIN APS_DON_XULY DX ON DX.DONID = TD.DONID 
          AND DX.LOAIGIAIQUYET = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
          LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID = TD.DONID 
          LEFT JOIN (
            SELECT 
              QD.DONID 
            FROM 
              APS_SOTHAM_QUYETDINH QD 
              INNER JOIN (
                SELECT 
                  QDA.* 
                FROM 
                  DM_QD_QUYETDINH QDA 
                WHERE 
                  QDA.LOAIID = 3
              ) DMQD ON DMQD.ID = QD.QUYETDINHID
          ) DC ON DC.DONID = DO.ID --xac dinh xem co dinh chi nop an phi 
          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.DONID = TD.DONID 
          AND TT.MALOAIVUVIEC = '7' 
          LEFT JOIN (
            select 
              mm.* 
            from 
              dvcqg_thanh_toan_logs mm 
            where 
              mm.ERROR_CODE = 1
          ) gs on gs.MA_THONGBAO = tt.ma_thongbao 
          LEFT JOIN DVCQG_FILE_BIENLAI BL ON BL.TP_THANH_TOAN_ID = TT.ID 
        WHERE 
          (
            V_CAP_THA = 'TH' 
            AND (
              THA.LOAITOA = 'CAPHUYEN' 
              OR THA.LOAITOA = 'CAPTINH'
            )
          ) 
          OR (
            V_CAP_THA = 'T' 
            AND THA.LOAITOA = 'CAPTINH'
          ) 
          OR (
            V_CAP_THA = 'H' 
            AND THA.LOAITOA = 'CAPHUYEN'
          ) 
          AND (
            (
              instr(
                ',' || V_DONVITHA_ID || ',', ',' || THA.ID || ','
              )> 0 
              AND V_DONVITHA_ID IS NOT NULL
            ) 
            OR (V_DONVITHA_ID IS NULL)
          ) 
          AND DU.TUCACHTOTUNG_MA = 'NGUYENDON' 
          AND TT.TRANGTHAITHANHTOAN = 0 
          AND TT.MA_THONGBAO IS NOT NULL 
          AND TD.BIEUMAUID IN(67, 381) 
          AND AI.TAMUNGANPHI != 0 
          AND (
            V_TT_TRUCTUYEN IS NULL 
            OR (TT.TT_TRUCTUYEN = V_TT_TRUCTUYEN)
          ) 
          AND (
            (
              V_TUNGAY IS NULL 
              OR AI.NGAYTHONGBAO >= V_TUNGAY
            ) 
            AND (
              V_DENNGAY IS NULL 
              OR AI.NGAYTHONGBAO <= V_DENNGAY
            )
          )
      ) TB 
      WHERE SOBIENLAI is not null 
    GROUP BY 
      SOBIENLAI, 
      NGAYBIENLAI, 
      TAMUNGANPHI, 
      SOLUONG,
      GHICHU_HOANTRA, 
      TENDONVI, 
      DONVIID;
    ----------------------------   
    RETURN v_cursor;
    END;
END PKG_TUPHAP_REPORT;

/
