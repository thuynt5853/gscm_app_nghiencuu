--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_HCTP_BC_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_HCTP_BC_APP" AS

PROCEDURE DON_SEARCH_DS_TL_MOI_THAMPHAN
( 
  V_BC_NGAYDK VARCHAR2,
  V_BC_Nguoiky VARCHAR2,
  V_BC_SoCV VARCHAR2,
  v_ID_USER VARCHAR2,
  ----------------
  vToaAnID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vSoCMND in varchar2,
  vTuNgay in date,
  vDenNgay in date,
  vHinhThucDon in number,
  vSoHieuDon in varchar2,
  vDiaChiTinh in number,
  vDiaChiHuyen in number,
  vDiaChiCT in varchar2,
  vTraLoidon in number,
  vTrangthai in number,
  vCD_DONVIID in number,
  vNgaychuyenTu in date,
  vNgaychuyenDen in date,
  vArrSelectID in varchar2,
  vIsThuLy in number,
  vSoThuly in varchar2,
  vNgayThulyTu in date,
  vNgayThulyDen in date,  
  vThamphanID in number,
  vLoaiAn in number,
  vCVPC_So in varchar2,
  vCVPC_Ngay in varchar2,
  PageIndex    in    int,
  PageSize    in    int,
  curReturn OUT sys_refcursor
)
IS 
  V_TENPHONGBANGUI varchar2(500);V_TENDONVI varchar2(500);V_TENDONVI_FULL varchar2(250);V_DONVI_CV varchar2(250);
  MININDEX    number;V_EXPORT_TEXT clob; VVNGAYNHAPTU varchar2(250);VVNGAYNHAPDEN varchar2(250);
  MAXINDEX    number; V_TABLE T_DT_NOIBO_DANHSACH;V_BAQD_LOAIAN_NAME clob;V_NOICHUYEN clob;
  V_CD_SOCV varchar2(500);V_CD_NGUOIKY varchar2(250);V_CD_NGAYCV varchar2(250);
  V_CD_SOTOTRINH varchar2(500);V_CD_NGAYTOTRINH varchar2(250);V_SOCV_TEMP varchar2(500);V_CD_NGUOIKY_TEMP varchar2(500);
  V_NGUOIGUI clob;V_TL_SO_TEMP varchar2(500); V_TENTHAMPHAN varchar2(500);
  V_TT NUMBER;V_SODON_TONG NUMBER;V_TENPHONGBANNHAN VARCHAR2(500);V_COUNT NUMBER;
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_NGUOIGUI,true);
 v_table := T_DT_NOIBO_DANHSACH();
 -------

--Lấy danh sách đơn
    FOR item IN (
          SELECT ROW_NUMBER() OVER (ORDER BY D.NGAYTAO DESC) STT,D.ID,D.MADON,D.SOHIEUDON,D.NGUOIGUI_HOTEN,D.SOTHUTUDON,D.NGAYNHANDON,D.LOAIDON,NVL(D.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
      D.NGUOITAO NGUOINHAP,D.DONGKHIEUNAI,D.ISNOTGDTTT,D.NGUOISUA,D.NGAYSUA,
      D.NGAYTAO NGAYNHAP,TL_NGAY,TL_SO,D.CD_SOCV,D.CD_NGAYCV,D.CD_NGUOIKY,D.ISSHOWFULL,
      CASE D.LOAIDON WHEN 1 THEN 'Đơn' WHEN 2 THEN 'Công văn' WHEN 3 THEN 'Đơn + Công văn' END AS HINHTHUC
      ,(CASE WHEN D.NGUOIGUI_HUYENID=981 THEN NGUOIGUI_DIACHI
      ELSE D.NGUOIGUI_DIACHI ||(CASE WHEN (D.NGUOIGUI_DIACHI || ' ')=' '  THEN ' ' ELSE ', ' END) || H.MA_TEN
      END) DIACHIGUI
      ,D.CV_SO,D.NGAYGHITRENDON
      ,(CASE D.BAQD_LOAIQDBA WHEN 1 THEN D.KN_SOQD ELSE DECODE(D.BAQD_CAPXETXU,2,D.BAQD_SO_ST,3,D.BAQD_SO_PT, D.BAQD_SO) END) BAQD_SO
       ,(CASE D.BAQD_LOAIQDBA WHEN 1 THEN ('QĐ: ' || D.KN_SOQD) ELSE DECODE(D.BAQD_CAPXETXU,2,('BA: ' || D.BAQD_SO_ST),3,('BA: ' || D.BAQD_SO_PT), ('BA: ' || D.BAQD_SO)) END) BAQD
        ,D.CV_TENDONVI,(CASE D.BAQD_LOAIQDBA WHEN 1 THEN D.KN_NGAY ELSE DECODE(D.BAQD_CAPXETXU,2,D.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,D.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,(CASE D.BAQD_LOAIQDBA WHEN 1 THEN I.TEN ELSE TXX.MA_TEN END) TOAXX
       ,D.NGUOIKHANGNGHI,D.GHICHU,D.DUNGDONLA,D.NGUOIGUI_GIOITINH
      ,D.CD_TA_LYDO_ISBAQD,D.CD_TA_LYDO_ISXACNHAN,D.CD_TA_LYDO_ISKHAC,D.CV_NGAY,D.CV_DIACHI CVDIACHI,D.CD_TA_LYDO_KHAC,D.CHIDAO_COKHONG,D.CHIDAO_NOIDUNG
      ,(CASE D.CD_LOAI WHEN 0 THEN CAST(PB.TENPHONGBAN AS NVARCHAR2(250))
          WHEN 1 THEN CAST(TK.MA_TEN AS NVARCHAR2(250)) WHEN 2 THEN  CAST(D.CD_NTA_TENDONVI AS NVARCHAR2(250))
          WHEN 3 THEN  CAST('Trả lại đơn' AS NVARCHAR2(250)) WHEN 4 THEN  CAST('Không chuyển' AS NVARCHAR2(250))  END ) NOICHUYEN
      ,(CASE D.CD_TRANGTHAI WHEN 0 THEN 'Chưa chuyển' WHEN 1 THEN  'Đã chuyển' WHEN 2 THEN  'Đã nhận' WHEN 3 THEN  'Bị trả lại' ELSE 'Chưa chuyển'   END ) TRANGTHAICHUYEN
      ,D.BAQD_LOAIAN,D.CD_TRALAI_LYDOID,D.CD_TRALAI_YEUCAU,C.HOTEN TENTHAMPHAN,TRIM(D.NOIDUNGTOMTAT) NOIDUNGTOMTAT,D.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,NSD.GHICHU BIDANH,D.CD_SOTOTRINH,D.CD_NGAYTOTRINH
      ,D.CD_SOTOTRINH||' - '||TO_CHAR(D.CD_NGAYTOTRINH,'dd/MM/yyyy') TOTRINH_SONGAY
      ,D.THAMPHANID
      ,0 SODON
      ,(CASE D.CD_LOAI WHEN 0 THEN 'block' ELSE 'none' END) ISSHOWNB
      ,(CASE D.CD_LOAI WHEN 0 THEN 'none' ELSE 'block' END) ISSHOWTK
      ,(CASE D.CD_TA_TRANGTHAI WHEN 0 THEN 'block' ELSE 'none' END) ISSHOWDDK
      ,(CASE D.CD_TA_TRANGTHAI WHEN 1 THEN 'block' ELSE 'none' END) ISSHOWCDDK
      ,(CASE WHEN D.ISTHULY=1 THEN 'block' WHEN (D.CD_TA_TRANGTHAI=0 AND D.ISTHULY IS NULL) THEN 'block' ELSE 'none' END) ISSHOWTLMOI
      ,(CASE D.ISTHULY WHEN 2 THEN 'block' ELSE 'none' END) ISSHOWDATL

      ,0 ARRCONGVAN
       ,0 ARRDONID
        ,(CASE WHEN D.ISTHULY=2 AND D.CD_LOAI=0 THEN (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || CV.TL_SO || ' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || CTP.HOTEN || ' (' || CV.CD_SOTOTRINH || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY CV.NGAYTAO DESC).GETCLOBVAL(),',') 
           FROM GDTTT_DON CV  LEFT JOIN DM_CANBO CTP ON CV.THAMPHANID=CTP.ID  WHERE CV.ISTHULY=1 AND (CV.ID = D.ID OR CV.DONTRUNGID=D.ID OR ( CV.ID IN ( SELECT ID FROM GDTTT_DON WHERE (DONTRUNGID=D.DONTRUNGID OR ID=D.DONTRUNGID) AND D.DONTRUNGID>0)))
           AND CV.ID<D.ID)  END) ARRTTTL

            , CASE WHEN D.CD_LOAI= 0 --and NVL(d.VuViecId, 0)>0
                  THEN CASE WHEN NVL(VA.GQD_LOAIKETQUA,4)=3 THEN '<b> Xử lý khác ngày '||TO_CHAR(VA.GQD_NGAYPHATHANHCV,'dd/MM/yyyy')||':</b> <span style="color:#000000;">'||TO_CHAR(VA.GQD_KETQUA)||'</span>' --add by anhvh 11/11/2019
                            WHEN NVL(VA.GQD_LOAIKETQUA,4)<>3 
                              THEN (DECODE(NVL(VA.GQD_LOAIKETQUA,4)
                                          , 4, 'Đang giải quyết', 2, u'X\1ebfp \0111\01a1n'  
                                          , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                                          )

                                    || CASE WHEN LENGTH(NVL(VA.GDQ_SO, ''))>0 THEN ' số '||VA.GDQ_SO
                                            ELSE '' END 
                                    || CASE WHEN (LENGTH(NVL(VA.GDQ_NGAY,''))=0 
                                                  OR (TO_CHAR(VA.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) THEN ''
                                            WHEN LENGTH(NVL(VA.GDQ_NGAY,'')) >0 
                                                  THEN ' ngày ' || TO_CHAR(VA.GDQ_NGAY,'dd/MM/yyyy') END 
                                    ) END   
               ELSE '' END KQGQNOIBO
             -- ,MM.CV_TRALOI_NOIDUNG--DECODE(d.DONTRUNGID,NULL,MM.CV_TRALOI_NOIDUNG,d.CV_TRALOI_NOIDUNG)CV_TRALOI_NOIDUNG
              ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,D.NGAYTAO 
        FROM GDTTT_DON D 
       --anhvh add 28-29/05/2020 (đơn chuyển tòa án khác,và ngoài tòa án) lấy kết quả khi thêm mới một đơn trùng,
       --trường hợp list tại danh sách, khi thêm mới một đơn trùng và chưa nhập kết quả thì sẽ hiển thị 1 kết quả của những đơn đã có kết quả
       --(đơn chuyển nội bộ)lấy kết quả khi thêm mới đơn trùng,xử lý trường hợp VUVIECID is null thì lấy 1 VUVIECID mới nhất của nhóm đơn đó,
       --ví dụ thêm mới một đơn vào trong nhóm đơn mà trong nhóm đơn đó đã map vào vụ án thì đơn mới đó sẽ có cùng mã vụ án.
            LEFT JOIN (
                   SELECT DO.DONTRUNGID,
                   RTRIM(SUBSTR(LISTAGG(DO.VUVIECID, '|') WITHIN GROUP (ORDER BY DO.NGAYTAO DESC)||'|',0,INSTR(LISTAGG(DO.VUVIECID, '|') WITHIN GROUP (ORDER BY DO.NGAYTAO DESC)||'|','|',1,1) ),'|')
                    VUVIECID
                   FROM (
                        SELECT DD.ID,DD.DONTRUNGID DONTRUNGIDS,DD.NGAYTAO,DECODE(DD.DONTRUNGID,NULL,DD.ID,0,DD.ID,DD.DONTRUNGID)DONTRUNGID
                        ,DD.CV_TRALOI_NOIDUNG,DD.VUVIECID
                        FROM GDTTT_DON DD 
                    )DO GROUP BY DO.DONTRUNGID
               )MM ON MM.DONTRUNGID=DECODE(D.DONTRUNGID,NULL,D.ID,0,D.ID,D.DONTRUNGID)
         -----
         LEFT JOIN (SELECT ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY,GQD_KETQUA,GQD_NGAYPHATHANHCV FROM GDTTT_VUAN) VA ON VA.ID = DECODE(D.VUVIECID,NULL,MM.VUVIECID,D.VUVIECID) -- Decode này là trường hợp khi thêm mới một đơn mà có VUVIECID is null thì sẽ tìm VUVIECID để thay thế
         -----
         LEFT JOIN (
                 SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                 )LA ON LA.ID=D.BAQD_LOAIAN
         -----
       INNER JOIN
        ((SELECT COUNT(ID) SODONTRUNG,MAX(ID) ID FROM 
                (SELECT DTK.ID,(CASE NVL(DTK.DONTRUNGID,0) WHEN 0 THEN ID ELSE DTK.DONTRUNGID END) DTID
                                            FROM GDTTT_DON DTK 
                                                WHERE DTK.TOAANID=VTOAANID 
                                                  AND 1=(CASE WHEN VISTHULY=-1 THEN 1 
                                                  WHEN VISTHULY=1  AND DTK.ISTHULY=1  THEN 1 
                                                  WHEN VISTHULY=2 AND DTK.ISTHULY=2 THEN 1 
                                                  WHEN VISTHULY=3 AND DTK.ISTHULY=3 THEN 1 
                                                   WHEN (VISTHULY=4 AND ((DTK.ISTHULY=1 AND NVL(DTK.DONTRUNGID,0)=0 )OR DTK.ISTHULY=3)) THEN 1 
                                                  ELSE 0 END)       
                                                    AND 
                                                    1=CASE WHEN VTOARABAQD=0 THEN 1 WHEN DTK.BAQD_TOAANID=VTOARABAQD THEN 1 ELSE 0 END  
                                                   -- and 1=case when vLoaiAn=0 then 1 when dtk.BAQD_LOAIAN=vLoaiAn then 1 else 0 end  
                                                   --anhvh 12/02/2020
                                                   AND (VLOAIAN=0
                                                        OR(DTK.BAQD_LOAIAN=VLOAIAN AND VLOAIAN!=55 AND VLOAIAN!=0)
                                                        OR(VLOAIAN=55 AND DTK.BAQD_LOAIAN IS NULL)
                                                      )
--                                                   and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(dtk.BAQD_SO) like '%' || lower(vSoBAQD) || '%' Or lower(dtk.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
--                                                    and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(dtk.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD Or to_char(dtk.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end 
                                                    AND 1=CASE WHEN VSOBAQD || ' '=' ' THEN 1 WHEN 
                                                                                        (LOWER(DTK.BAQD_SO) LIKE '%' || LOWER(VSOBAQD) || '%'
                                                                                        OR LOWER(DTK.BAQD_SO_PT) LIKE '%' || LOWER(VSOBAQD) || '%'
                                                                                         OR LOWER(DTK.BAQD_SO_ST) LIKE '%' || LOWER(VSOBAQD) || '%' 
                                                                                        OR LOWER(DTK.KN_SOQD) LIKE '%' || LOWER(VSOBAQD) || '%') THEN 1 ELSE 0 END         
                                                    AND  1=CASE WHEN VNGAYBAQD || ' '=' ' THEN 1 WHEN 
                                                                                        (TO_CHAR(DTK.BAQD_NGAYBA,'dd/MM/yyyy')=VNGAYBAQD 
                                                                                        OR TO_CHAR(DTK.BAQD_NGAYBA_PT,'dd/MM/yyyy')=VNGAYBAQD
                                                                                        OR TO_CHAR(DTK.BAQD_NGAYBA_ST,'dd/MM/yyyy')=VNGAYBAQD 
                                                                                        OR TO_CHAR(DTK.KN_NGAY,'dd/MM/yyyy')=VNGAYBAQD) THEN 1 ELSE 0 END  
                                                    AND
                                                    1=CASE WHEN VNGUOIGUI || ' '=' ' THEN 1 WHEN LOWER(DTK.DONGKHIEUNAI) LIKE '%' || LOWER(VNGUOIGUI) || '%' THEN 1 ELSE 0 END
                                                    AND
                                                    1=CASE WHEN VSOCMND || ' '=' ' THEN 1 WHEN DTK.NGUOIGUI_CMND LIKE '%' || VSOCMND || '%' THEN 1 ELSE 0 END
                                                    AND
                                                    1=CASE WHEN VTUNGAY IS NULL THEN 1 WHEN VTUNGAY <= DTK.NGAYNHANDON THEN 1 ELSE 0 END
                                                    AND
                                                    1=CASE WHEN VDENNGAY IS NULL THEN 1 WHEN DTK.NGAYNHANDON <= VDENNGAY THEN 1 ELSE 0 END
                                                    AND
                                                    1=CASE WHEN VHINHTHUCDON=0 THEN 1 WHEN DTK.LOAIDON=VHINHTHUCDON THEN 1 ELSE 0 END
                                                    AND
                                                    1=CASE WHEN VSOHIEUDON || ' '=' ' THEN 1 WHEN (DTK.MADON =VSOHIEUDON OR DTK.SOHIEUDON=VSOHIEUDON) THEN 1 ELSE 0 END
                                                    AND
                                                    1=CASE WHEN VDIACHITINH=0 THEN 1 WHEN DTK.NGUOIGUI_TINHID=VDIACHITINH THEN 1 ELSE 0 END
                                                    AND
                                                    1=CASE WHEN VDIACHIHUYEN=0 THEN 1 WHEN DTK.NGUOIGUI_HUYENID=VDIACHIHUYEN THEN 1 ELSE 0 END
                                                    AND
                                                    1=CASE WHEN VDIACHICT || ' '=' ' THEN 1 WHEN LOWER(DTK.NGUOIGUI_DIACHI) LIKE '%' || LOWER(VDIACHICT) || '%' THEN 1 ELSE 0 END       

                                                   AND
                                                    1=CASE WHEN VCVPC_SO || ' '=' ' THEN 1 WHEN LOWER(DTK.CV_SO) LIKE '%' || LOWER(VCVPC_SO) || '%' THEN 1 ELSE 0 END
                                                    AND
                                                    1=CASE WHEN VCVPC_NGAY || ' '=' ' THEN 1 WHEN TO_CHAR(DTK.CV_NGAY,'dd/MM/yyyy')=VCVPC_NGAY THEN 1 ELSE 0 END

                                                    AND
                                                    1=CASE WHEN VTRALOIDON=0 THEN 1 WHEN DTK.TRALOIDON=VTRALOIDON THEN 1 ELSE 0 END


                                                    AND  1=CASE WHEN VNGAYCHUYENTU IS NULL THEN 1 WHEN VNGAYCHUYENTU <= DTK.CD_NGAYXULY THEN 1 ELSE 0 END
                                                    AND 1=CASE WHEN VNGAYCHUYENDEN IS NULL THEN 1 WHEN DTK.CD_NGAYXULY <= VNGAYCHUYENDEN THEN 1 ELSE 0 END
                                                    AND  1=CASE WHEN VNGAYTHULYTU IS NULL THEN 1 WHEN VNGAYTHULYTU <= DTK.TL_NGAY THEN 1 ELSE 0 END
                                                    AND 1=CASE WHEN VNGAYTHULYDEN IS NULL THEN 1 WHEN DTK.TL_NGAY <= VNGAYTHULYDEN THEN 1 ELSE 0 END
                                                    AND 1=CASE WHEN VSOTHULY || ' '=' ' THEN 1 WHEN LOWER(DTK.TL_SO) LIKE '%' || LOWER(VSOTHULY) || '%' THEN 1 ELSE 0 END
                                                    AND 1=CASE WHEN VARRSELECTID  || ' '=' ' THEN 1 WHEN VARRSELECTID LIKE '%,' || CAST(DTK.ID AS VARCHAR2(10)) || ',%' THEN 1 ELSE 0 END

                                                     AND 1=CASE WHEN VTHAMPHANID=0 THEN 1 WHEN DTK.THAMPHANID=VTHAMPHANID THEN 1 ELSE 0 END


                                            ORDER BY DTK.NGAYTAO DESC
                ) GROUP BY DTID)
         ) G ON G.ID=D.ID
             LEFT JOIN (SELECT ID,MA_TEN FROM DM_HANHCHINH) H ON D.NGUOIGUI_HUYENID=H.ID
            LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TK ON D.CD_TK_DONVIID=TK.ID
            LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TXX ON DECODE(D.BAQD_CAPXETXU,2,D.BAQD_TOAANID_ST,3,D.BAQD_TOAANID_PT,D.BAQD_TOAANID)=TXX.ID
            LEFT JOIN (SELECT ID,TENPHONGBAN FROM DM_PHONGBAN) PB ON D.CD_TA_DONVIID=PB.ID
            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) C ON D.THAMPHANID=C.ID
            LEFT JOIN (SELECT USERNAME,GHICHU FROM QT_NGUOISUDUNG) NSD ON NSD.USERNAME=D.NGUOITAO
            LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) I ON D.NGUOIKHANGNGHI=I.ID 
   )
   LOOP
            DBMS_LOB.CREATETEMPORARY(V_NGUOIGUI,true);
            DBMS_LOB.APPEND(V_NGUOIGUI,item.DONGKHIEUNAI); 
            V_NGUOIGUI:=item.DONGKHIEUNAI;
            IF(item.ARRCONGVAN IS NOT NULL)THEN
            --DBMS_LOB.CREATETEMPORARY(V_NGUOIGUI,true);
            DBMS_LOB.APPEND(V_NGUOIGUI,' (Do ' ||REPLACE(item.ARRCONGVAN,'; )','')||')'); 
            --V_NGUOIGUI:= V_NGUOIGUI||' (Do ' ||REPLACE(item.ARRCONGVAN,'; )','')||')';
            ELSIF(item.LOAIDON=2)THEN
            --DBMS_LOB.CREATETEMPORARY(V_NGUOIGUI,true);
            DBMS_LOB.APPEND(V_NGUOIGUI,' (Công văn số '||item.CV_SO||' ngày '||to_char(item.CV_NGAY,'dd/MM/yyyy')||')'); 
              -- V_NGUOIGUI:= V_NGUOIGUI||' (Công văn số '||item.CV_SO||' ngày '||to_char(item.CV_NGAY,'dd/MM/yyyy')||')';
            ELSIF(item.LOAIDON=3)THEN
            --DBMS_LOB.CREATETEMPORARY(V_NGUOIGUI,true);
            DBMS_LOB.APPEND(V_NGUOIGUI,' (Do ' ||item.CV_TENDONVI||' chuyển đến theo Công văn số '||item.CV_SO  ||' ngày '||TO_CHAR(item.CV_NGAY,'dd/MM/yyyy')||')'); 
            -- V_NGUOIGUI:= V_NGUOIGUI||' (Do ' ||item.CV_TENDONVI||' chuyển đến theo Công văn số '||item.CV_SO  ||' ngày '||TO_CHAR(item.CV_NGAY,'dd/MM/yyyy')||')';
            END IF;
             IF(LENGTH(item.TL_SO)=1)THEN
                 V_TL_SO_TEMP:='0'||item.TL_SO;
                 ELSIF(LENGTH(item.TL_SO)>1)THEN
                 V_TL_SO_TEMP:=item.TL_SO;
                END IF;
            SELECT decode(item.TENTHAMPHAN,NULL,NULL,item.TENTHAMPHAN) INTO V_TENTHAMPHAN FROM DUAL;
            v_table.extend;
                v_table(v_table.count) := R_DT_NOIBO_DANHSACH(
                item.STT,V_NGUOIGUI,item.DIACHIGUI,item.BAQD_SO,TO_CHAR(item.BAQD_NGAYBA,'dd/MM/yyyy'),
                item.TOAXX,NULL,NULL,NULL,item.SODON,
                item.GHICHU,NULL,item.NOICHUYEN,item.CD_SOTOTRINH,NULL,
                NULL,NULL,V_TENTHAMPHAN,V_TL_SO_TEMP,to_char(item.TL_NGAY,'dd/MM/yyyy'),
                to_char(item.NGAYNHANDON,'dd/MM/yyyy'),NULL,NULL,item.CD_NGUOIKY,NULL,
                item.BAQD_LOAIAN,TO_CHAR(item.CD_NGAYTOTRINH,'dd/MM/yyyy'),NULL,item.NGAYTAO,item.CD_SOCV,
                to_char(item.CD_NGAYCV,'dd/MM/yyyy')
                );
   END LOOP;


    ----
    SELECT count(*)into V_COUNT FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
     if(V_COUNT>0)then   
     SELECT PB.TENPHONGBAN,TA.TEN INTO V_TENPHONGBANGUI,V_TENDONVI FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
     end if;
    ----
    SELECT COUNT(*) INTO V_COUNT FROM TABLE(V_TABLE)PA WHERE PA.CD_SOCV IS NOT NULL ;    
    -------
    IF(V_COUNT>0)THEN
       SELECT 
             DECODE(V_BC_SoCV,NULL,PA.CD_SOCV,V_BC_SoCV)CD_SOCV
            ,DECODE(V_BC_NGAYDK,NULL,PA.CD_NGAYCV,V_BC_NGAYDK)CD_NGAYCV
            ,DECODE(V_BC_Nguoiky,NULL,PA.NGUOIKY,V_BC_Nguoiky)NGUOIKY
            ,PA.TENTHAMPHAN
        INTO  V_CD_SOCV,V_CD_NGAYCV,V_CD_NGUOIKY,V_TENTHAMPHAN
        FROM TABLE(V_TABLE)PA WHERE PA.CD_SOCV IS NOT NULL  ORDER BY PA.NGAYTAO DESC
        FETCH FIRST 1 ROWS ONLY;
    END IF;
    -----  
    SELECT SUM(PA.SODON) INTO V_SODON_TONG FROM TABLE(V_TABLE)PA;
    SELECT PA.TENPHONGBANNHAN INTO V_TENPHONGBANNHAN FROM TABLE(V_TABLE)PA  FETCH FIRST 1 ROWS ONLY;
    -----
     SELECT UPPER(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao','TANDCC')),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
     INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL FROM DM_TOAAN TA WHERE TA.ID=vToaAnID;
    -------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
               <tr>
                    <td colspan="4" style="text-align: center; vertical-align: top; font-size: 12pt">'||V_TENDONVI||'</td>
                    <td colspan="2"></td>
                    <th colspan="5" style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                </tr>
                 <tr style="text-align: center;">
                    <th colspan="4" style="vertical-align: top; font-size: 13pt; text-decoration: underline;"></th>
                     <td colspan="2"></td>
                    <th colspan="5" style="vertical-align: top;font-size: 13pt; text-decoration: underline;">Độc lập - Tự do - Hạnh phúc </th>
                </tr>
                <tr><td colspan="11"></td></tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td colspan="11" style="text-align: center; vertical-align: middle; font-size: 14pt;">
                    DANH SÁCH ĐƠN THỤ LÝ MỚI THẨM PHÁN CHUYỂN '||upper(V_TENPHONGBANNHAN)||'
                    <br />
                        <span style="font-size: 14pt; font-weight: normal; font-style: italic;">(Gửi kèm theo Công văn số '||V_CD_SOCV||' ngày '||V_CD_NGAYCV||' của Tòa án nhân dân tối cao)</span>
                    </td>
                </tr>
                 <tr>
                    <td colspan="11" style="height:10px;"></td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">TT</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số Thụ lý</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày thụ lý</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Người đề nghị, kiến nghị, thông báo</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Địa chỉ</td>
                    <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:65px;">QĐ/BA đề nghị xem xét theo thủ tục GĐT/TT</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thẩm phán giải quyết</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số lượng đơn</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ghi chú</td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:65px;">Số BA/QĐ</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày BA/QĐ</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tòa án Xét xử</td>
                </tr>
               ');
               V_TT:=0;
               FOR item IN(
                         SELECT PA.* FROM TABLE(V_TABLE)PA ORDER BY TO_NUMBER(regexp_replace(PA.SOTHULY, '[^[:digit:]]',''))
                         )
                 LOOP
                 V_TT:=V_TT+1;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||V_TT||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||item.SOTHULY||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||item.NGAYTHULY||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.NGUOIGUI||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.DIAPHUONG||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.BA_SO||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.BA_NGAY||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.BA_TOAXX||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.TENTHAMPHAN||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.SODON||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.GHICHU||'</td>
                </tr>
                ');   
                 END LOOP;
               DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                 <tr>
                    <td colspan="11" style="height:10px;"></td>
                </tr>
                 <tr align="center" style="text-align: center;">
                    <td colspan="2" style="vertical-align: top; font-style: italic;">Tổng số:</td>
                    <td colspan="1" style="vertical-align: top; text-align: left; font-weight: bold;">'||V_SODON_TONG||'</td>
                    <td colspan="4" style="vertical-align: top;"><span style="font-weight: bold;">Xác nhận của '||V_TENPHONGBANNHAN||'</span><br />
                        <span style="font-style: italic">(Ký ghi rõ họ tên)</span></td>
                    <td colspan="1" style="vertical-align: top;"></td>
                    <td colspan="3">
                        <p style="font-size: 13pt;">
                            <strong>THẨM PHÁN</strong>
                        </p>
                    </td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td colspan="8" style="vertical-align: top;"></td>
                    <td colspan="3" style="vertical-align: bottom; height: 140px;">
                       <p style="font-size: 13pt;"><strong>'||V_CD_NGUOIKY_TEMP||'</strong></p>
                    </td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 28px"></td>
                    <td style="width: 38px"></td>
                    <td style="width: 70px"></td>
                    <td style="width: 190px"></td>
                    <td style="width: 112px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 42px"></td>
                    <td style="width: 87px"></td>
                    <td style="width: 94px"></td>
                    <td style="width: 50px"></td>
                    <td style="width: 190px"></td>
                </tr>
            </table>
            ');
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);  dbms_lob.freetemporary(V_NGUOIGUI);
END DON_SEARCH_DS_TL_MOI_THAMPHAN;



PROCEDURE DON_SEARCH_DS_TL_MOI
( 
      V_BC_NGAYDK       VARCHAR2,
      V_BC_NGUOIKY      VARCHAR2,
      V_BC_SOCV         VARCHAR2,
      V_ID_USER         VARCHAR2,
      ----------------
      VTOAANID          IN NUMBER,
      VTOARABAQD        IN NUMBER,
      VSOBAQD           IN VARCHAR2,
      VNGAYBAQD         IN VARCHAR2,
      VNGUOIGUI         IN VARCHAR2,
      VSOCMND           IN VARCHAR2,
      VTUNGAY           IN DATE,
      VDENNGAY          IN DATE,
      VHINHTHUCDON      IN NUMBER,
      VSOHIEUDON        IN VARCHAR2,
      VDIACHITINH       IN NUMBER,
      VDIACHIHUYEN      IN NUMBER,
      VDIACHICT         IN VARCHAR2,
      VLOAISOVB          IN     VARCHAR2,
      VSOCONGVAN        IN VARCHAR2,
      VNGAYCONGVAN      IN VARCHAR2,
      VTRALOI           IN NUMBER,
      VNGUOINHAP        IN VARCHAR2,
      VNOICHUYEN        IN NUMBER,
      VTRANGTHAI        IN NUMBER,
      VCD_DONVIID       IN NUMBER,
      VCD_TA_TRANGTHAI  IN NUMBER,
      VCD_TENDONVI      IN VARCHAR2,
      VNGAYCHUYENTU     IN DATE,
      VNGAYCHUYENDEN    IN DATE,
      VARRSELECTID      IN VARCHAR2,
      VISTHULY          IN NUMBER,
      VPHANLOAIXULY     IN NUMBER,
      VNGAYTHULYTU      IN DATE,
      VNGAYTHULYDEN     IN DATE,
      VSOTHULY          IN VARCHAR2,
      VCHIDAO           IN NUMBER,
      VTRAIGIAM         IN NUMBER,
      VTBQUAHAN         IN NUMBER,
      VNGAYQUAHAN       IN DATE,
      VTHAMPHANID       IN NUMBER,
      VTHAMTRAVIENID    IN NUMBER,
      VLOAICVID         IN NUMBER,
      VNGAYNHAPTU       IN DATE,
      VNGAYNHAPDEN      IN DATE,
      VISDONGOC         IN NUMBER,
      VISTUHINH         IN NUMBER,
      VLOAIAN           IN NUMBER,
      VCVPC_SO          IN VARCHAR2,
      VCVPC_NGAY        IN VARCHAR2,
      VCVPC_TENCQ       IN VARCHAR2,
      VGUITOICA_TA      IN NUMBER,
      PAGEINDEX         IN INT,
      PAGESIZE          IN INT,
      CURRETURN         OUT SYS_REFCURSOR
)
IS 
        V_TENPHONGBANGUI      VARCHAR2(500);
        V_TENDONVI            VARCHAR2(500);
        V_TENDONVI_FULL       VARCHAR2(250);
        V_DONVI_CV            VARCHAR2(250);
        MININDEX              NUMBER;
        V_EXPORT_TEXT         CLOB;
        VVNGAYNHAPTU          VARCHAR2(250);
        VVNGAYNHAPDEN         VARCHAR2(250);
        MAXINDEX              NUMBER; 
        V_BAQD_LOAIAN_NAME    CLOB;
        V_NOICHUYEN           CLOB;
        V_CD_SOCV             VARCHAR2(500);
        V_CD_NGUOIKY          VARCHAR2(250);
        V_CD_NGAYCV           VARCHAR2(250);
        V_ID                  NUMBER;
        V_CAPCHAID            NUMBER;
        V_CD_SOTOTRINH        VARCHAR2(500);
        V_CD_NGAYTOTRINH      VARCHAR2(250);
        V_SOCV_TEMP           VARCHAR2(500);
        V_CD_NGUOIKY_TEMP     VARCHAR2(500);
        V_NGUOIGUI            CLOB;
        V_TL_SO_TEMP          VARCHAR2(500);
        V_TENTHAMPHAN         VARCHAR2(500);
        V_TT                  NUMBER;
        V_SODON_TONG          NUMBER;
        V_TENPHONGBANNHAN     VARCHAR2(500);
        V_COUNT               NUMBER;
        VV_NGUOIGUI           VARCHAR2(32000);
        V_TABLE               T_DT_NOIBO_DANHSACH;
BEGIN
        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,TRUE);
        V_TABLE := T_DT_NOIBO_DANHSACH();

        IF(VLOAICVID!=-1 AND VLOAICVID!=0) THEN
            SELECT DT.ID,DT.CAPCHAID INTO V_ID,V_CAPCHAID 
            FROM DM_DATAITEM DT 
            WHERE DT.ID=VLOAICVID; 
        END IF;
        FOR ITEM IN (
          SELECT ROW_NUMBER () OVER (ORDER BY D.NGAYTAO DESC) STT,
            D.ID,D.MADON,D.SOHIEUDON,D.NGUOIGUI_HOTEN,D.SOTHUTUDON,D.NGAYNHANDON,
            D.LOAIDON,NVL (D.BAQD_LOAIQDBA, 0) BAQD_LOAIQDBA,D.NGUOITAO NGUOINHAP,
            Decode(d.loaidon,4,'Viện kiểm sát nhân dân tối cao',D.DONGKHIEUNAI) as DONGKHIEUNAI,
            D.ISNOTGDTTT,D.NGUOISUA,D.NGAYSUA,D.NGAYTAO NGAYNHAP,D.TL_NGAY,D.TL_SO,
            D.CD_SOCV,D.CD_NGAYCV,
            D.ISSHOWFULL,
             CASE D.LOAIDON WHEN 1 THEN 'Đơn' WHEN 2 THEN 'Công văn' WHEN 3 THEN 'Đơn + Công văn'  END AS HINHTHUC             
            ,(CASE  WHEN D.NGUOIGUI_HUYENID = 981 THEN  NGUOIGUI_DIACHI   ELSE  D.NGUOIGUI_DIACHI     || (CASE WHEN (D.NGUOIGUI_DIACHI || ' ') = ' ' THEN  ' '  ELSE  ', ' END) || H.MA_TEN END) DIACHIGUI
            ,D.CV_SO,D.NGAYGHITRENDON
            ,(CASE D.BAQD_LOAIQDBA WHEN 1 THEN D.KN_SOQD  ELSE  DECODE (D.BAQD_CAPXETXU,2, D.BAQD_SO_ST,3, D.BAQD_SO_PT,D.BAQD_SO)END)BAQD_SO
            ,(CASE D.BAQD_LOAIQDBA  WHEN 1 THEN ('QĐ: ' || D.KN_SOQD) ELSE  DECODE (D.BAQD_CAPXETXU,2, ('BA: ' || D.BAQD_SO_ST), 3, ('BA: ' || D.BAQD_SO_PT),('BA: ' || D.BAQD_SO))END)BAQD
            ,(CASE D.BAQD_LOAIQDBA  WHEN 1 THEN D.KN_NGAY  ELSE DECODE (D.BAQD_CAPXETXU,2, D.BAQD_NGAYBA_ST,3, BAQD_NGAYBA_PT,D.BAQD_NGAYBA) END) BAQD_NGAYBA
            ,D.CV_TENDONVI,(CASE D.BAQD_LOAIQDBA WHEN 1 THEN I.TEN  ELSE TXX.MA_TEN END)TOAXX
            ,D.NGUOIKHANGNGHI,D.GHICHU,D.DUNGDONLA,D.NGUOIGUI_GIOITINH,D.CD_TA_LYDO_ISBAQD,D.CD_TA_LYDO_ISXACNHAN,D.CD_TA_LYDO_ISKHAC,D.CV_NGAY,D.CV_DIACHI CVDIACHI,D.CD_TA_LYDO_KHAC
            ,D.CHIDAO_COKHONG,D.CHIDAO_NOIDUNG
            ,(CASE D.CD_LOAI WHEN 0 THEN CAST (PB.TENPHONGBAN AS NVARCHAR2 (250)) WHEN 1  THEN CAST (TK.MA_TEN AS NVARCHAR2 (250)) WHEN 2 THEN CAST(D.CD_NTA_TENDONVI AS NVARCHAR2 (250)) WHEN 3 THEN CAST('Trả lại đơn' AS NVARCHAR2 (250)) WHEN 4 THEN CAST('Không chuyển' AS NVARCHAR2(250)) END)NOICHUYEN
            ,(CASE D.CD_TRANGTHAI WHEN 0 THEN 'Chưa chuyển' WHEN 1 THEN 'Đã chuyển' WHEN 2 THEN 'Đã nhận' WHEN 3 THEN 'Bị trả lại' ELSE 'Chưa chuyển' END)TRANGTHAICHUYEN
            ,D.BAQD_LOAIAN,D.CD_TRALAI_LYDOID,D.CD_TRALAI_YEUCAU,C.HOTEN TENTHAMPHAN,TRIM (D.NOIDUNGTOMTAT) NOIDUNGTOMTAT
            ,D.CD_TRALAI_LYDOKHAC,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,NSD.GHICHU BIDANH
             ,SoTT.SOVB AS CD_SOTOTRINH
            ,SoTT.NGAYVB AS CD_NGAYTOTRINH
            ,SoTT.NGUOIKY AS CD_NGUOIKY
            ,SoTT.CHUCVU 
            ,SoTT.SOVB || ' - '|| TO_CHAR (SoTT.NGAYVB, 'dd/MM/yyyy') AS TOTRINH_SONGAY
            
            ,D.THAMPHANID
            ,(CASE D.CD_LOAI WHEN 0 THEN 'block' ELSE 'none' END)ISSHOWNB
            ,(CASE D.CD_LOAI WHEN 0 THEN 'none' ELSE 'block' END)ISSHOWTK
            ,(CASE D.CD_TA_TRANGTHAI WHEN 0 THEN 'block' ELSE 'none' END)ISSHOWDDK
            ,(CASE D.CD_TA_TRANGTHAI WHEN 1 THEN 'block' ELSE 'none' END)ISSHOWCDDK
            ,(CASE WHEN D.ISTHULY = 1 THEN 'block' WHEN (D.CD_TA_TRANGTHAI = 0 AND D.ISTHULY IS NULL) THEN 'block' ELSE 'none' END)ISSHOWTLMOI
            ,(CASE D.ISTHULY WHEN 2 THEN 'block' ELSE 'none' END)ISSHOWDATL
            ,D.NGAYTAO 
            FROM GDTTT_DON D
             LEFT JOIN (SELECT ID, MA_TEN FROM DM_HANHCHINH) H ON D.NGUOIGUI_HUYENID = H.ID
            LEFT JOIN (SELECT ID, MA_TEN FROM DM_TOAAN) TK ON D.CD_TK_DONVIID = TK.ID
            LEFT JOIN (SELECT ID, MA_TEN FROM DM_TOAAN) TXX ON DECODE (D.BAQD_CAPXETXU,2, D.BAQD_TOAANID_ST,3, D.BAQD_TOAANID_PT,D.BAQD_TOAANID) = TXX.ID
            LEFT JOIN (SELECT ID, TENPHONGBAN FROM DM_PHONGBAN) PB ON D.CD_TA_DONVIID = PB.ID
            LEFT JOIN (SELECT ID, HOTEN FROM DM_CANBO) C ON D.THAMPHANID = C.ID
            LEFT JOIN (SELECT USERNAME, GHICHU FROM QT_NGUOISUDUNG) NSD ON NSD.USERNAME = D.NGUOITAO
            LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) I ON D.NGUOIKHANGNGHI = I.ID
            LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoTT','SoTT_TLL','SoTTXX') )SoTT on SoTT.donid = d.id  
            LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
            WHERE 
            (INSTR(VARRSELECTID,','||D.ID||',')>0)
            AND d.CD_TA_TRANGTHAI=0
            --CD_TA_TRANGTHAI: 1 Đơn chưa đủ điều kiện,0 Đơn đủ điều kiện, 2 chưa đủ điều kiện (chuyển từ chưa đủ đk sang đủ đk), 3 Thêm đơn kèm theo
        )
        LOOP     
            V_NGUOIGUI := ITEM.DONGKHIEUNAI;
         IF (ITEM.LOAIDON = 3)
         THEN
            V_NGUOIGUI :=V_NGUOIGUI|| ' (Do '|| ITEM.CV_TENDONVI|| ' chuyển đến theo Công văn số '|| ITEM.CV_SO|| ' ngày '|| TO_CHAR (ITEM.CV_NGAY, 'dd/MM/yyyy')|| ')';
         ELSIF (ITEM.LOAIDON = 2)
         THEN
            V_NGUOIGUI :=V_NGUOIGUI|| ' (Công văn số '|| ITEM.CV_SO|| ' ngày '|| TO_CHAR (ITEM.CV_NGAY, 'dd/MM/yyyy')|| ')';
         END IF;
         IF (ITEM.ISSHOWTLMOI = 'none')
         THEN
            V_TL_SO_TEMP := NULL;
         ELSE
            IF (LENGTH (ITEM.TL_SO) = 1)
            THEN
               V_TL_SO_TEMP := '0' || ITEM.TL_SO;
            ELSIF (LENGTH (ITEM.TL_SO) > 1)
            THEN
               V_TL_SO_TEMP := ITEM.TL_SO;
            END IF;
         END IF;
         
             SELECT COUNT(*)TONG_SODON INTO V_SODON_TONG
             FROM GDTTT_DON CV  WHERE (CV.ID = ITEM.ID OR (CV.CD_TA_TRANGTHAI  IN (2,3) AND  CV.ARR_DON_ID= ITEM.ID) );
            
             SELECT DECODE(ITEM.TENTHAMPHAN,NULL,NULL,'Thẩm phán '||ITEM.TENTHAMPHAN) INTO V_TENTHAMPHAN FROM DUAL;
            
                V_TABLE.EXTEND;
                V_TABLE(V_TABLE.COUNT) := R_DT_NOIBO_DANHSACH(
                ITEM.STT,V_NGUOIGUI,ITEM.DIACHIGUI,ITEM.BAQD_SO,TO_CHAR(ITEM.BAQD_NGAYBA,'dd/MM/yyyy'),
                ITEM.TOAXX,NULL,NULL,NULL,V_SODON_TONG,
                ITEM.GHICHU,NULL,ITEM.NOICHUYEN,ITEM.CD_SOTOTRINH,NULL,
                NULL,NULL,V_TENTHAMPHAN,V_TL_SO_TEMP,TO_CHAR(ITEM.TL_NGAY,'dd/MM/yyyy'),
                TO_CHAR(ITEM.NGAYNHANDON,'dd/MM/yyyy'),NULL,NULL,ITEM.CD_NGUOIKY,NULL,
                ITEM.BAQD_LOAIAN,TO_CHAR(ITEM.CD_NGAYTOTRINH,'dd/MM/yyyy'),NULL,ITEM.NGAYTAO,ITEM.CD_SOCV,
                TO_CHAR(ITEM.CD_NGAYCV,'dd/MM/yyyy')
                );
        END LOOP;
        
     --Truy vấn tạo dữ liệu báo cáo-------
       IF(VNGAYNHAPTU IS NOT NULL)THEN
        VVNGAYNHAPTU:=' Từ ngày '||TO_CHAR(VNGAYNHAPTU,'dd/MM/yyyy');
      ELSIF(VNGAYNHAPTU IS NULL)THEN    
        VVNGAYNHAPTU:='';
      END IF;
      -------
       IF(VNGAYNHAPDEN IS NOT NULL)THEN
        VVNGAYNHAPDEN:=' đến ngày '||TO_CHAR(VNGAYNHAPDEN,'dd/MM/yyyy');
      ELSIF(VNGAYNHAPDEN IS NULL)THEN
        VVNGAYNHAPDEN:='';
      END IF;
    ----
    SELECT COUNT(*)INTO V_COUNT FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=V_ID_USER);
     IF(V_COUNT>0)THEN   
     SELECT PB.TENPHONGBAN,TA.TEN INTO V_TENPHONGBANGUI,V_TENDONVI FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=V_ID_USER);
     END IF;
    ----
    SELECT COUNT(*) INTO V_COUNT FROM TABLE(V_TABLE)PA WHERE PA.NGUOIKY IS NOT NULL ;    
    -------
    IF(V_COUNT>0)THEN
       SELECT 
             PA.SOTOTRINH CD_SOCV
            ,PA.NGAYTOTRINH CD_NGAYCV
            ,PA.NGUOIKY
            ,PA.TENTHAMPHAN
        INTO  V_CD_SOCV,V_CD_NGAYCV,V_CD_NGUOIKY,V_TENTHAMPHAN
        FROM TABLE(V_TABLE)PA WHERE PA.NGUOIKY IS NOT NULL  ORDER BY PA.NGAYTAO DESC
        FETCH FIRST 1 ROWS ONLY;
    END IF;
    -----  
    SELECT SUM(PA.SODON) INTO V_SODON_TONG FROM TABLE(V_TABLE)PA;
    
    SELECT PA.TENPHONGBANNHAN INTO V_TENPHONGBANNHAN FROM TABLE(V_TABLE)PA  FETCH FIRST 1 ROWS ONLY;
    -----
     SELECT UPPER(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao','TANDCC')),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
     INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
    -------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
               <tr>
                    <td colspan="4" style="text-align: center; vertical-align: top; font-size: 12pt">'||V_TENDONVI||'</td>
                    <td colspan="2"></td>
                    <th colspan="5" style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                </tr>
                 <tr style="text-align: center;">
                    <th colspan="4" style="vertical-align: top; font-size: 13pt; text-decoration: underline;">VĂN PHÒNG</th>
                     <td colspan="2"></td>
                    <th colspan="5" style="vertical-align: top;font-size: 13pt; text-decoration: underline;">Độc lập - Tự do - Hạnh phúc </th>
                </tr>
                <tr><td colspan="11"></td></tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td colspan="11" style="text-align: center; vertical-align: middle; font-size: 14pt;">Danh sách đơn thụ lý '||VVNGAYNHAPTU||VVNGAYNHAPDEN||'
                    <br />
                        của Văn phòng chuyển '||V_TENPHONGBANNHAN||'
                    <br />
                        <span style="font-size: 14pt; font-weight: normal; font-style: italic;">(Gửi kèm theo Tờ trình số '||V_CD_SOCV||'/'||V_DONVI_CV||'-VP ngày '||V_CD_NGAYCV||' của '||V_TENDONVI_FULL||')</span>
                    </td>
                </tr>
                 <tr>
                    <td colspan="11" style="height:10px;"></td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">TT</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số Thụ lý</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày thụ lý</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Người đề nghị, kiến nghị, thông báo</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Địa chỉ</td>
                    <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:65px;">QĐ/BA đề nghị xem xét theo thủ tục GĐT/TT</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thẩm phán giải quyết</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số lượng đơn</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ghi chú</td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:65px;">Số BA/QĐ</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày BA/QĐ</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tòa án Xét xử</td>
                </tr>
               ');
               V_TT:=0;
               FOR ITEM IN(
                         SELECT PA.* FROM TABLE(V_TABLE)PA
                           ORDER BY TO_NUMBER(REGEXP_REPLACE(PA.SOTHULY, '[^[:digit:]]',''))
                         )
                 LOOP
                 V_TT:=V_TT+1;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||V_TT||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.SOTHULY||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.NGAYTHULY||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.NGUOIGUI||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.DIAPHUONG||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.BA_SO||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.BA_NGAY||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.BA_TOAXX||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.TENTHAMPHAN||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.SODON||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.GHICHU||'</td>
                </tr>
                ');   
                 END LOOP;
               DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                 <tr>
                    <td colspan="11" style="height:10px;"></td>
                </tr>
                 <tr align="center" style="text-align: center;">
                    <td colspan="2" style="vertical-align: top; font-style: italic;">Tổng số:</td>
                    <td colspan="1" style="vertical-align: top; text-align: left; font-weight: bold;">'||V_SODON_TONG||'</td>
                    <td colspan="4" style="vertical-align: top;"><span style="font-weight: bold;">Xác nhận của '||V_TENPHONGBANNHAN||'</span><br />
                        <span style="font-style: italic">(Ký ghi rõ họ tên)</span></td>
                    <td colspan="1" style="vertical-align: top;"></td>
                    <td colspan="3">
                        <p style="font-size: 13pt;">
                            <strong>CHÁNH VĂN PHÒNG<br />
                            </strong>
                        </p>
                    </td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td colspan="8" style="vertical-align: top;"></td>
                    <td colspan="3" style="vertical-align: bottom; height: 140px;">
                       <p style="font-size: 13pt;"><strong>'||V_CD_NGUOIKY||'</strong></p>
                    </td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 28px"></td>
                    <td style="width: 38px"></td>
                    <td style="width: 70px"></td>
                    <td style="width: 190px"></td>
                    <td style="width: 112px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 42px"></td>
                    <td style="width: 87px"></td>
                    <td style="width: 94px"></td>
                    <td style="width: 50px"></td>
                    <td style="width: 190px"></td>
                </tr>
            </table>
            ');
    OPEN CURRETURN FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM DUAL;  
        DBMS_LOB.FREETEMPORARY(V_EXPORT_TEXT);  
END DON_SEARCH_DS_TL_MOI;


PROCEDURE DON_SEARCH_TP_GIAI_QUYET
(   V_BC_NGAYDK               VARCHAR2,
    V_BC_NGUOIKY              VARCHAR2,
    V_BC_SOCV                 VARCHAR2,
    V_ID_USER                 VARCHAR2,
    ----------------
    VTOAANID           IN     NUMBER,
    VTOARABAQD         IN     NUMBER,
    VSOBAQD            IN     VARCHAR2,
    VNGAYBAQD          IN     VARCHAR2,
    VNGUOIGUI          IN     VARCHAR2,
    VSOCMND            IN     VARCHAR2,
    VTUNGAY            IN     DATE,
    VDENNGAY           IN     DATE,
    VHINHTHUCDON       IN     NUMBER,
    VSOHIEUDON         IN     VARCHAR2,
    VDIACHITINH        IN     NUMBER,
    VDIACHIHUYEN       IN     NUMBER,
    VDIACHICT          IN     VARCHAR2,
    VLOAISOVB          IN     VARCHAR2,
    VSOCONGVAN         IN     VARCHAR2,
    VNGAYCONGVAN       IN     VARCHAR2,
    VTRALOI            IN     NUMBER,
    VNGUOINHAP         IN     VARCHAR2,
    VNOICHUYEN         IN     NUMBER,
    VTRANGTHAI         IN     NUMBER,
    VCD_DONVIID        IN     NUMBER,
    VCD_TA_TRANGTHAI   IN     NUMBER,
    VCD_TENDONVI       IN     VARCHAR2,
    VNGAYCHUYENTU      IN     DATE,
    VNGAYCHUYENDEN     IN     DATE,
    VARRSELECTID       IN     VARCHAR2,
    VISTHULY           IN     NUMBER,
    VPHANLOAIXULY      IN     NUMBER,
    VNGAYTHULYTU       IN     DATE,
    VNGAYTHULYDEN      IN     DATE,
    VSOTHULY           IN     VARCHAR2,
    VCHIDAO            IN     NUMBER,
    VTRAIGIAM          IN     NUMBER,
    VTBQUAHAN          IN     NUMBER,
    VNGAYQUAHAN        IN     DATE,
    VTHAMPHANID        IN     NUMBER,
    VTHAMTRAVIENID     IN     NUMBER,
    VLOAICVID          IN     NUMBER,
    VNGAYNHAPTU        IN     DATE,
    VNGAYNHAPDEN       IN     DATE,
    VISDONGOC          IN     NUMBER,
    VISTUHINH          IN     NUMBER,
    VLOAIAN            IN     NUMBER,
    VCVPC_SO           IN     VARCHAR2,
    VCVPC_NGAY         IN     VARCHAR2,
    VCVPC_TENCQ        IN     VARCHAR2,
    VGUITOICA_TA       IN     NUMBER,
    PAGEINDEX          IN     INT,
    PAGESIZE           IN     INT,
    CURRETURN          OUT SYS_REFCURSOR)
IS

   V_TENPHONGBANGUI     VARCHAR2 (500);
   V_TENDONVI           VARCHAR2 (500);
   V_TENDONVI_FULL      VARCHAR2(250);
   V_DONVI_CV           VARCHAR2(250);
   MININDEX             NUMBER; 
   V_EXPORT_TEXT        CLOB;
   VVNGAYNHAPTU         VARCHAR2 (250);
   VVNGAYNHAPDEN        VARCHAR2 (250);
   MAXINDEX             NUMBER;
   V_TABLE              T_DON_SEARCH_TP_GIAI_QUYET;
   V_BAQD_LOAIAN_NAME   CLOB;
   V_NOICHUYEN          CLOB;
   V_CD_SOCV            VARCHAR2 (500);
   V_CD_NGUOIKY         VARCHAR2 (250);
   V_CD_NGAYCV          VARCHAR2 (250);
   V_ID                 NUMBER;
   V_CAPCHAID           NUMBER;
   V_CD_SOTOTRINH       VARCHAR2 (500);
   V_CD_NGAYTOTRINH     VARCHAR2 (250);
   V_SOCV_TEMP          VARCHAR2 (500);
   V_CD_NGUOIKY_TEMP    VARCHAR2 (500);
   V_NGUOIGUI           VARCHAR2 (1000);
   V_TL_SO_TEMP         VARCHAR2 (500);
   V_TENTHAMPHAN        VARCHAR2 (500);
   V_LOAIAN             VARCHAR2 (500);
   V_TT                 NUMBER;
   V_TT_TP              NUMBER;
   COUNT_TP             NUMBER;
   V_COUNT              NUMBER;
   V_TONGSODON          NUMBER;


BEGIN
   DBMS_LOB.CREATETEMPORARY (V_EXPORT_TEXT, TRUE);
   V_TABLE := T_DON_SEARCH_TP_GIAI_QUYET ();
   -------
   IF (VLOAICVID != -1 AND VLOAICVID != 0)
   THEN
      SELECT DT.ID, DT.CAPCHAID  INTO V_ID, V_CAPCHAID  FROM DM_DATAITEM DT WHERE DT.ID = VLOAICVID;
   END IF;
     FOR ITEM
     IN (  SELECT ROW_NUMBER () OVER (ORDER BY D.NGAYTAO DESC) STT,
            D.ID,D.MADON,D.SOHIEUDON,D.NGUOIGUI_HOTEN,D.SOTHUTUDON,D.NGAYNHANDON,
            D.LOAIDON,NVL (D.BAQD_LOAIQDBA, 0) BAQD_LOAIQDBA,D.NGUOITAO NGUOINHAP,
            Decode(d.loaidon,4,'Viện kiểm sát nhân dân tối cao',D.DONGKHIEUNAI) as DONGKHIEUNAI,
            D.ISNOTGDTTT,D.NGUOISUA,D.NGAYSUA,D.NGAYTAO NGAYNHAP,D.TL_NGAY,D.TL_SO,
            --D.CD_SOCV,D.CD_NGAYCV,D.CD_NGUOIKY,
            D.ISSHOWFULL,
            CASE D.LOAIDON WHEN 1 THEN 'Đơn' WHEN 2 THEN 'Công văn' WHEN 3 THEN 'Đơn + Công văn'  END AS HINHTHUC             
            ,(CASE  WHEN D.NGUOIGUI_HUYENID = 981 THEN  NGUOIGUI_DIACHI   ELSE  D.NGUOIGUI_DIACHI     || (CASE WHEN (D.NGUOIGUI_DIACHI || ' ') = ' ' THEN  ' '  ELSE  ', ' END) || H.MA_TEN END) DIACHIGUI
            ,D.CV_SO,D.NGAYGHITRENDON
            ,(CASE D.BAQD_LOAIQDBA WHEN 1 THEN D.KN_SOQD  ELSE  DECODE (D.BAQD_CAPXETXU,2, D.BAQD_SO_ST,3, D.BAQD_SO_PT,D.BAQD_SO)END)BAQD_SO
            ,(CASE D.BAQD_LOAIQDBA  WHEN 1 THEN ('QĐ: ' || D.KN_SOQD) ELSE  DECODE (D.BAQD_CAPXETXU,2, ('BA: ' || D.BAQD_SO_ST), 3, ('BA: ' || D.BAQD_SO_PT),('BA: ' || D.BAQD_SO))END)BAQD
            ,(CASE D.BAQD_LOAIQDBA  WHEN 1 THEN D.KN_NGAY  ELSE DECODE (D.BAQD_CAPXETXU,2, D.BAQD_NGAYBA_ST,3, BAQD_NGAYBA_PT,D.BAQD_NGAYBA) END) BAQD_NGAYBA
            ,D.CV_TENDONVI,(CASE D.BAQD_LOAIQDBA WHEN 1 THEN I.TEN  ELSE TXX.MA_TEN END)TOAXX
            ,D.NGUOIKHANGNGHI,D.GHICHU,D.DUNGDONLA,D.NGUOIGUI_GIOITINH,D.CD_TA_LYDO_ISBAQD,D.CD_TA_LYDO_ISXACNHAN,D.CD_TA_LYDO_ISKHAC,D.CV_NGAY,D.CV_DIACHI CVDIACHI,D.CD_TA_LYDO_KHAC
            ,D.CHIDAO_COKHONG,D.CHIDAO_NOIDUNG
            ,(CASE D.CD_LOAI WHEN 0 THEN CAST (PB.TENPHONGBAN AS NVARCHAR2 (250)) WHEN 1  THEN CAST (TK.MA_TEN AS NVARCHAR2 (250)) WHEN 2 THEN CAST(D.CD_NTA_TENDONVI AS NVARCHAR2 (250)) WHEN 3 THEN CAST('Trả lại đơn' AS NVARCHAR2 (250)) WHEN 4 THEN CAST('Không chuyển' AS NVARCHAR2(250)) END)NOICHUYEN
            ,(CASE D.CD_TRANGTHAI WHEN 0 THEN 'Chưa chuyển' WHEN 1 THEN 'Đã chuyển' WHEN 2 THEN 'Đã nhận' WHEN 3 THEN 'Bị trả lại' ELSE 'Chưa chuyển' END)TRANGTHAICHUYEN
            ,D.BAQD_LOAIAN,D.CD_TRALAI_LYDOID,D.CD_TRALAI_YEUCAU,C.HOTEN TENTHAMPHAN,TRIM (D.NOIDUNGTOMTAT) NOIDUNGTOMTAT
            ,D.CD_TRALAI_LYDOKHAC,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,NSD.GHICHU BIDANH
            ,SoTT.SOVB AS CD_SOTOTRINH
            ,SoTT.NGAYVB AS CD_NGAYTOTRINH
            ,SoTT.NGUOIKY AS CD_NGUOIKY
            ,SoTT.CHUCVU 
            ,SoTT.SOVB || ' - '|| TO_CHAR (SoTT.NGAYVB, 'dd/MM/yyyy') AS TOTRINH_SONGAY
            ,D.THAMPHANID
            ,(CASE D.CD_LOAI WHEN 0 THEN 'block' ELSE 'none' END)ISSHOWNB
            ,(CASE D.CD_LOAI WHEN 0 THEN 'none' ELSE 'block' END)ISSHOWTK
            ,(CASE D.CD_TA_TRANGTHAI WHEN 0 THEN 'block' ELSE 'none' END)ISSHOWDDK
            ,(CASE D.CD_TA_TRANGTHAI WHEN 1 THEN 'block' ELSE 'none' END)ISSHOWCDDK
            ,(CASE WHEN D.ISTHULY = 1 THEN 'block' WHEN (D.CD_TA_TRANGTHAI = 0 AND D.ISTHULY IS NULL) THEN 'block' ELSE 'none' END)ISSHOWTLMOI
            ,(CASE D.ISTHULY WHEN 2 THEN 'block' ELSE 'none' END)ISSHOWDATL
   FROM GDTTT_DON D
            -- inner join g on g.ID=d.ID
            LEFT JOIN (SELECT ID, MA_TEN FROM DM_HANHCHINH) H ON D.NGUOIGUI_HUYENID = H.ID
            LEFT JOIN (SELECT ID, MA_TEN FROM DM_TOAAN) TK ON D.CD_TK_DONVIID = TK.ID
            LEFT JOIN (SELECT ID, MA_TEN FROM DM_TOAAN) TXX ON DECODE (D.BAQD_CAPXETXU,2, D.BAQD_TOAANID_ST,3, D.BAQD_TOAANID_PT,D.BAQD_TOAANID) = TXX.ID
            LEFT JOIN (SELECT ID, TENPHONGBAN FROM DM_PHONGBAN) PB ON D.CD_TA_DONVIID = PB.ID
            LEFT JOIN (SELECT ID, HOTEN FROM DM_CANBO) C ON D.THAMPHANID = C.ID
            LEFT JOIN (SELECT USERNAME, GHICHU FROM QT_NGUOISUDUNG) NSD ON NSD.USERNAME = D.NGUOITAO
            LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) I ON D.NGUOIKHANGNGHI = I.ID
            LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoTT','SoTT_TLL','SoTTXX') )SoTT on SoTT.donid = d.id  
            
            LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
        WHERE (INSTR(VARRSELECTID,','||D.ID||',')>0)
                    )
      LOOP
         V_NGUOIGUI := ITEM.DONGKHIEUNAI;
         IF (ITEM.LOAIDON = 3)
         THEN
            V_NGUOIGUI :=V_NGUOIGUI|| ' (Do '|| ITEM.CV_TENDONVI|| ' chuyển đến theo Công văn số '|| ITEM.CV_SO|| ' ngày '|| TO_CHAR (ITEM.CV_NGAY, 'dd/MM/yyyy')|| ')';
         ELSIF (ITEM.LOAIDON = 2)
         THEN
            V_NGUOIGUI :=V_NGUOIGUI|| ' (Công văn số '|| ITEM.CV_SO|| ' ngày '|| TO_CHAR (ITEM.CV_NGAY, 'dd/MM/yyyy')|| ')';
         END IF;
         IF (ITEM.ISSHOWTLMOI = 'none')
         THEN
            V_TL_SO_TEMP := NULL;
         ELSE
            IF (LENGTH (ITEM.TL_SO) = 1)
            THEN
               V_TL_SO_TEMP := '0' || ITEM.TL_SO;
            ELSIF (LENGTH (ITEM.TL_SO) > 1)
            THEN
               V_TL_SO_TEMP := ITEM.TL_SO;
            END IF;
         END IF;
         SELECT DECODE (ITEM.TENTHAMPHAN,NULL, NULL,'Thẩm phán ' || ITEM.TENTHAMPHAN)INTO V_TENTHAMPHAN FROM DUAL;

        V_TONGSODON := 0;   

        SELECT COUNT(*)TONG_SODON INTO V_TONGSODON
        FROM GDTTT_DON CV 
        WHERE (CV.ID = ITEM.ID OR (CV.CD_TA_TRANGTHAI  IN (2,3) AND  CV.ARR_DON_ID= ITEM.ID) );

         V_TABLE.EXTEND;
                V_TABLE(V_TABLE.COUNT) := R_DON_SEARCH_TP_GIAI_QUYET(
                  ITEM.STT,V_NGUOIGUI,ITEM.DIACHIGUI,ITEM.BAQD_SO,TO_CHAR(ITEM.BAQD_NGAYBA,'dd/MM/yyyy'),
                  ITEM.TOAXX,null,null,null,null
                  ,ITEM.GHICHU,NULL,NULL,ITEM.CD_SOTOTRINH,NULL
                  ,NULL,NULL,V_TENTHAMPHAN,V_TL_SO_TEMP,TO_CHAR(ITEM.TL_NGAY,'dd/MM/yyyy')
                  ,TO_CHAR(ITEM.NGAYNHANDON,'dd/MM/yyyy'),NULL,NULL,ITEM.CD_NGUOIKY,ITEM.CHUCVU
                  ,ITEM.BAQD_LOAIAN,TO_CHAR(ITEM.CD_NGAYTOTRINH,'dd/MM/yyyy'),NULL,NULL,NULL
                  ,NULL,ITEM.ID,V_TONGSODON
                );
        END LOOP;

---------------------------------------
    --Truy vấn tạo dữ liệu báo cáo--
    IF(VNGAYNHAPTU IS NOT NULL)THEN
            VVNGAYNHAPTU:=' Từ ngày '||TO_CHAR(VNGAYNHAPTU,'dd/MM/yyyy');
        ELSIF(VNGAYNHAPTU IS NULL)THEN    
            VVNGAYNHAPTU:='';
        END IF;

    IF(VNGAYNHAPDEN IS NOT NULL)THEN
            VVNGAYNHAPDEN:=' đến ngày '||TO_CHAR(VNGAYNHAPDEN,'dd/MM/yyyy');
        ELSIF(VNGAYNHAPDEN IS NULL)THEN
            VVNGAYNHAPDEN:='';
        END IF;


    SELECT COUNT(*)INTO V_COUNT 
    FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
    WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=V_ID_USER);

    IF(V_COUNT>0)THEN   
            SELECT PB.TENPHONGBAN,TA.TEN INTO V_TENPHONGBANGUI,V_TENDONVI 
            FROM DM_PHONGBAN PB
                INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
            WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=V_ID_USER);
        END IF;

    SELECT UPPER(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao','TANDCC')),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
    INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL 
    FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;

    --Insert số trang
    DBMS_LOB.APPEND(V_EXPORT_TEXT,'<div style="mso-element: footer" id="f1">
                                       <w:sdt sdtdocpart="t"
                                       docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
                                       <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
                                       style="mso-element:field-begin"></span><span
                                       style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
                                       </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
                                       style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
                                       style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
                                       </w:sdt>
                                       <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
                                   </div>');

    --THAM PHAN IS NOT NULL
    SELECT COUNT(*) INTO COUNT_TP 
    FROM TABLE(V_TABLE)PA 
    WHERE ((PA.TENTHAMPHAN IS NULL AND VTOAANID=1) OR (PA.TENTHAMPHAN IS NOT NULL AND VTOAANID=6)); 

    IF(VTOAANID = 1) THEN
           SELECT COUNT(*) INTO V_COUNT  FROM TABLE(V_TABLE);
           IF(V_COUNT>0) THEN
                SELECT SOTOTRINH, NGAYTOTRINH INTO V_CD_SOTOTRINH, V_CD_NGAYTOTRINH
                    FROM (  SELECT SOTOTRINH, NGAYTOTRINH
                            FROM TABLE(V_TABLE)
                            )
                    WHERE ROWNUM = 1;
           END IF;
        ELSE
             SELECT DECODE(V_BC_NGUOIKY,NULL,NULL,V_BC_NGUOIKY) NGUOIKY
                    ,NULL --nhiều thẩm phán nên để là null
                    ,DECODE(V_BC_SOCV,NULL,NULL,V_BC_SOCV) SOTOTRINH
                    ,DECODE(V_BC_NGAYDK,NULL,NULL,V_BC_NGAYDK) NGAYTOTRINH
                    INTO  V_CD_NGUOIKY,V_TENTHAMPHAN,V_CD_SOTOTRINH,V_CD_NGAYTOTRINH
             FROM DUAL;
        END IF;


    IF(VTOAANID = 1) THEN
         V_TT_TP:=0;
          SELECT COUNT(*) INTO COUNT_TP FROM 
                (SELECT PS.TENTHAMPHAN FROM TABLE(V_TABLE)PS 
                                    WHERE PS.TENTHAMPHAN IS NOT NULL 
                                    --and PS.LOAIAN IS NOT NULL
                                    --GROUP BY PS.TENTHAMPHAN
                                    )PA; 

               --,PA.LOAIAN
        IF(COUNT_TP>0) THEN
            FOR ITEM_TP IN (SELECT  PA.TENTHAMPHAN,PA.LOAIAN, PA.SOTOTRINH, PA.NGAYTOTRINH, PA.NGUOIKY FROM TABLE(V_TABLE)PA                              
                                    WHERE PA.TENTHAMPHAN IS NOT NULL 
                                    and PA.LOAIAN IS NOT NULL
                                    AND PA.SOTOTRINH IS NOT NULL
                                    AND PA.NGAYTOTRINH IS NOT NULL
                        GROUP BY PA.TENTHAMPHAN,PA.LOAIAN, 
                        PA.SOTOTRINH, PA.NGAYTOTRINH, PA.NGUOIKY  ORDER BY PA.TENTHAMPHAN)
            LOOP 
                     V_TT_TP:=V_TT_TP+1;

                    IF(VTOAANID = 1) THEN
                            IF(ITEM_TP.SOTOTRINH IS NOT NULL) THEN
                                    V_CD_SOCV := ITEM_TP.SOTOTRINH;
                            END IF;

                            IF(ITEM_TP.NGAYTOTRINH IS NOT NULL) THEN
                                    V_CD_NGAYTOTRINH := ITEM_TP.NGAYTOTRINH;
                            END IF;
                            
                            V_CD_NGUOIKY:=ITEM_TP.NGUOIKY;
                           
                    ELSE
                            IF(V_BC_SOCV IS NOT NULL) THEN
                                    V_CD_SOCV:=V_BC_SOCV;
                                ELSIF(V_BC_SOCV IS NULL) THEN
                                    SELECT PA.SOTOTRINH INTO V_CD_SOTOTRINH FROM TABLE(V_TABLE)PA 
                                    WHERE PA.TENTHAMPHAN=ITEM_TP.TENTHAMPHAN 
                                    ORDER BY PA.NGAYTAO DESC 
                                    FETCH FIRST 1 ROWS ONLY;
                                END IF;
                            IF(V_BC_NGAYDK IS NOT NULL) THEN
                                    V_CD_NGAYTOTRINH:=V_BC_NGAYDK;
                                ELSIF(V_BC_NGAYDK IS NULL) THEN
                                    SELECT PA.NGAYTOTRINH INTO V_CD_NGAYTOTRINH FROM TABLE(V_TABLE)PA
                                    WHERE PA.TENTHAMPHAN=ITEM_TP.TENTHAMPHAN
                                    ORDER BY PA.NGAYTAO DESC FETCH FIRST 1 ROWS ONLY;
                                END IF;
                                
                            IF(V_BC_NGUOIKY IS NOT NULL) THEN
                                   V_CD_NGUOIKY:=V_BC_NGUOIKY;
                            ELSIF(V_BC_NGUOIKY IS NULL) THEN
                                   SELECT PA.NGUOIKY INTO V_CD_NGUOIKY FROM TABLE(V_TABLE)PA
                                    WHERE PA.TENTHAMPHAN=ITEM_TP.TENTHAMPHAN
                                   ORDER BY PA.NGAYTAO DESC FETCH FIRST 1 ROWS ONLY;
                            END IF;   
                    END IF;

                    
                      -------------------
                      SELECT PA.TENTHAMPHAN,LA.LOAI_AN_TEN INTO V_TENTHAMPHAN,V_LOAIAN 
                                                FROM TABLE(V_TABLE)PA 
                                                     -----
                                                     LEFT JOIN (
                                                             SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                                                             )LA ON LA.ID=PA.LOAIAN
                                                WHERE PA.TENTHAMPHAN=ITEM_TP.TENTHAMPHAN 
                                                    And PA.LOAIAN = ITEM_TP.LOAIAN
                                                ORDER BY PA.NGAYTAO DESC
                      FETCH FIRST 1 ROWS ONLY;
                      
                      ------------------
           DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                 <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td style="text-align: center; vertical-align: top; font-size: 12pt">'||V_TENDONVI||'</td>
                        <td></td>
                        <th style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                    </tr>
                    <tr style="text-align: center;">
                        <td style="vertical-align: top;font-size: 12pt">
                            <table cellpadding="0" cellspacing="0">
                                <tr style="height: 1pt; padding-bottom: 3px;">
                                    <th style="text-align: right;width: 15px; "><span>V</span></th>
                                    <th style="border-bottom: 1px solid #000000;text-align: left;">
                                        <span>ĂN PHÒN</span>
                                    </th>
                                    <th style="text-align: left;"><span>G</span></th>
                                </tr>
                            </table>
                        </td>
                        <td></td>
                        <td style="vertical-align: top;">
                            <table cellpadding="0" cellspacing="0">
                                <tr style="height: 1pt; padding-bottom: 3px; font-size: 13pt">
                                    <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                                    <th style="border-bottom: 1px solid #000000; text-align: left;">
                                        <span>ộc lập - Tự do - Hạnh phú</span>
                                    </th>
                                    <th style="text-align: left;"><span>c</span></th>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="height: 10px;">
                        <td style="width: 450pt;"></td>
                        <td style="width: 550pt"></td>
                        <td style="width: 650pt"></td>
                    </tr>
             </table>
              <table cellpadding="2" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
                    <tr><td colspan="11"></td></tr>
                    <tr align="center" style="text-align: center; font-weight: bold">
                        <td colspan="11" style="text-align: center; vertical-align: middle; font-size: 14pt;">Danh sách đơn vụ án '||V_LOAIAN ||' thụ lý '||VVNGAYNHAPTU||VVNGAYNHAPDEN||'
                        <br />
                            và phân công '||V_TENTHAMPHAN||' theo dõi, giải quyết
                        <br />
                            <span style="font-size: 14pt; font-weight: normal; font-style: italic;">(Kèm theo tờ trình số  '||ITEM_TP.SOTOTRINH ||'/TTr-'||V_DONVI_CV||'-VP ngày '|| ITEM_TP.NGAYTOTRINH ||' của Văn phòng '||V_TENDONVI_FULL||')</span>
                        </td>
                    </tr>
                    <tr align="center" style="text-align: center; font-weight: bold">
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">TT</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số Thụ lý</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày thụ lý</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Người đề nghị, kiến nghị, thông báo</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Địa chỉ</td>
                        <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:56px;">QĐ/BA đề nghị xem xét theo thủ tục GĐT/TT</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số đơn</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thẩm phán giải quyết</td>
                        ');
--                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Phê duyệt của Chánh án '||V_DONVI_CV||'</td>
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ghi chú</td>
                    </tr>
                    <tr align="center" style="text-align: center; font-weight: bold">
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:82px;">Số BA/QĐ</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày BA/QĐ</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tòa án Xét xử</td>
                    </tr>
                   ');
                     V_TT:=0;
                   FOR ITEM IN(
                             SELECT PA.*, 
                             DECODE(SUBSTR(BA_SO,0,INSTR(BA_SO, '/',1,2)-1),NULL,SUBSTR(BA_SO,0,INSTR(BA_SO, '/',1,1)-1),SUBSTR(BA_SO,0,INSTR(BA_SO, '/',1,2)-1))BA_SO_SUB
                             FROM TABLE(V_TABLE)PA 
                             WHERE 
                                PA.TENTHAMPHAN=ITEM_TP.TENTHAMPHAN 
                                and PA.LOAIAN = ITEM_TP.LOAIAN 
                                AND PA.SOTOTRINH = ITEM_TP.SOTOTRINH
                                AND PA.NGAYTOTRINH =  ITEM_TP.NGAYTOTRINH 
                             ORDER BY CAST(NVL(SOTHULY,'0') AS NUMBER)
                             --ORDER BY regexp_replace(SOTHULY, '[^[:digit:]]', '')
                             )
                     LOOP
                     V_TT:=V_TT+1;

                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr align="center" style="text-align: center;">
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||V_TT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.SOTHULY||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.NGAYTHULY||'</td>
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.NGUOIGUI||'</td>
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.DIAPHUONG||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.BA_SO_SUB||'<br />'||SUBSTR(ITEM.BA_SO,INSTR(ITEM.BA_SO, '/',-1))||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.BA_NGAY||'</td>
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.BA_TOAXX||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.TONG_SODON||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.TENTHAMPHAN||'</td>
                        
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.GHICHU||'</td>
                    </tr>
                    ');   

                     END LOOP;

                   DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                     <tr>
                        <td colspan="11" style="height:10px;"></td>
                    </tr>
                     <tr align="center" style="text-align: center; font-weight: bold">
                        <td colspan="8" style="vertical-align: top;"></td>
                        <td colspan="3">
                            <p style="font-size: 13pt;">
                                <strong>CHÁNH VĂN PHÒNG<br />
                                </strong>
                            </p>
                        </td>
                    </tr>
                    <tr align="center" style="text-align: center; font-weight: bold">
                        <td colspan="8" style="vertical-align: top;"></td>
                        <td colspan="3" style="vertical-align: bottom;height:90px;">
                            <p style="font-size: 13pt;"><strong>'||V_CD_NGUOIKY||'</strong></p>
                        </td>
                    </tr>
                 <tr style="height: 0px;">
                        <td style="width: 26px"></td>
                        <td style="width: 38px"></td>
                        <td style="width: 70px"></td>
                        <td style="width: 153px"></td>
                        <td style="width: 119px"></td>
                        <td style="width: 60px"></td>
                        <td style="width: 69px"></td>
                        <td style="width: 84px"></td>
                        <td style="width: 38px"></td>
                        <td style="width: 100px"></td>
                        <td style="width: 186px"></td>
                    </tr>
                </table>
               ');

               IF(V_TT_TP<COUNT_TP)THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                   <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
                    "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                    mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
                    style="mso-special-character:line-break;page-break-before:always">
                    </span>
                    <p class=MsoNormal><o:p></o:p></p>
                    ');
                END IF;
                
            END LOOP;
            
       END IF;

    ELSE --CAC TOA CAP CAO
        IF(COUNT_TP>0)THEN
           DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td style="text-align: center; vertical-align: top; font-size: 12pt">'||V_TENDONVI||'</td>
                        <td></td>
                        <th style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                    </tr>
                    <tr style="text-align: center;">
                        <td style="vertical-align: top;font-size: 12pt">
                            <table cellpadding="0" cellspacing="0">
                                <tr style="height: 1pt; padding-bottom: 3px;">
                                    <th style="text-align: right;width: 15px; "><span>V</span></th>
                                    <th style="border-bottom: 1px solid #000000;text-align: left;">
                                        <span>ĂN PHÒN</span>
                                    </th>
                                    <th style="text-align: left;"><span>G</span></th>
                                </tr>
                            </table>
                        </td>
                        <td></td>
                        <td style="vertical-align: top;">
                            <table cellpadding="0" cellspacing="0">
                                <tr style="height: 1pt; padding-bottom: 3px; font-size: 13pt">
                                    <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                                    <th style="border-bottom: 1px solid #000000; text-align: left;">
                                        <span>ộc lập - Tự do - Hạnh phú</span>
                                    </th>
                                    <th style="text-align: left;"><span>c</span></th>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="height: 10px;">
                        <td style="width: 450pt;"></td>
                        <td style="width: 600pt"></td>
                        <td style="width: 600pt"></td>
                    </tr>
             </table>
              <table cellpadding="2" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
                    <tr><td colspan="11"></td></tr>
                    <tr align="center" style="text-align: center; font-weight: bold">
                        <td colspan="11" style="text-align: center; vertical-align: middle; font-size: 14pt;">Danh sách đơn thụ lý '||VVNGAYNHAPTU||VVNGAYNHAPDEN||'
                        <br />
                            và phân công '||V_TENTHAMPHAN||' theo dõi, giải quyết
                        <br />
                            <span style="font-size: 14pt; font-weight: normal; font-style: italic;">(Kèm theo tờ trình số  '||V_CD_SOTOTRINH||'/TTr-'||V_DONVI_CV||'-VP ngày '||V_CD_NGAYTOTRINH||' của Văn phòng '||V_TENDONVI_FULL||')</span>
                        </td>
                    </tr>
                    <tr align="center" style="text-align: center; font-weight: bold">
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">TT</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số Thụ lý</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày thụ lý</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Người đề nghị, kiến nghị, thông báo</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Địa chỉ</td>
                        <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:56px;">QĐ/BA đề nghị xem xét theo thủ tục GĐT/TT</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thẩm phán giải quyết</td>
                        
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ghi chú</td>
                    </tr>
                    <tr align="center" style="text-align: center; font-weight: bold">
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:82px;">Số BA/QĐ</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày BA/QĐ</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tòa án Xét xử</td>
                    </tr>
                   ');
                     V_TT:=0;
                   FOR ITEM IN(
                             SELECT PA.* FROM TABLE(V_TABLE)PA WHERE 
                             ((PA.TENTHAMPHAN IS NULL AND VTOAANID=1) OR (PA.TENTHAMPHAN IS NOT NULL AND VTOAANID=6))
                             ORDER BY CAST(NVL(SOTHULY,'0') AS NUMBER)
                             --ORDER BY regexp_replace(SOTHULY, '[^[:digit:]]', '')
                             )
                     LOOP
                     V_TT:=V_TT+1;
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr align="center" style="text-align: center;">
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||V_TT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.SOTHULY||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.NGAYTHULY||'</td>
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.NGUOIGUI||'</td>
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.DIAPHUONG||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||SUBSTR(ITEM.BA_SO,0,INSTR(ITEM.BA_SO, '/',1,2)-1)||'<br />'||SUBSTR(ITEM.BA_SO,INSTR(ITEM.BA_SO, '/',-1))||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.BA_NGAY||'</td>
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.BA_TOAXX||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.TENTHAMPHAN||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.GHICHU||'</td>
                    </tr>
                    ');   
                     END LOOP;
                   DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                     <tr>
                        <td colspan="11" style="height:10px;"></td>
                    </tr>
                     <tr align="center" style="text-align: center; font-weight: bold">
                        <td colspan="8" style="vertical-align: top;"></td>
                        <td colspan="3">
                            <p style="font-size: 13pt;">
                                <strong>KT. CHÁNH VĂN PHÒNG<br />
                                    PHÓ CHÁNH VĂN PHÒNG<br />
                                </strong>
                            </p>
                        </td>
                    </tr>
                    <tr align="center" style="text-align: center; font-weight: bold">
                        <td colspan="8" style="vertical-align: top;"></td>
                        <td colspan="3" style="vertical-align: bottom;height:110px;">
                            <p style="font-size: 13pt;"><strong>'||V_CD_NGUOIKY||'</strong></p>
                        </td>
                    </tr>
                ');

                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr style="height: 0px;">
                        <td style="width: 26px"></td>
                        <td style="width: 38px"></td>
                        <td style="width: 70px"></td>
                        <td style="width: 153px"></td>
                        <td style="width: 119px"></td>
                        <td style="width: 60px"></td>
                        <td style="width: 69px"></td>
                        <td style="width: 84px"></td>
                        <td style="width: 100px"></td>
                        <td style="width: 50px"></td>
                        <td style="width: 186px"></td>
                    </tr>
                </table>
               <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
                "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
                style="mso-special-character:line-break;page-break-before:always">
                </span>
                <p class=MsoNormal><o:p></o:p></p>
                ');
        END IF;

         -----THAM PHAN NOT NULL   
         V_TT_TP:=0;
          SELECT COUNT(*) INTO COUNT_TP FROM 
                (SELECT PS.TENTHAMPHAN FROM TABLE(V_TABLE)PS WHERE PS.TENTHAMPHAN IS NOT NULL GROUP BY PS.TENTHAMPHAN)PA; 


        IF(COUNT_TP>0) THEN
            FOR ITEM_TP IN (SELECT PA.TENTHAMPHAN, PA.SOTOTRINH, PA.NGAYTOTRINH FROM TABLE(V_TABLE)PA WHERE PA.TENTHAMPHAN IS NOT NULL 
                        GROUP BY PA.TENTHAMPHAN, PA.SOTOTRINH, PA.NGAYTOTRINH  ORDER BY PA.TENTHAMPHAN)
            LOOP 
                     V_TT_TP:=V_TT_TP+1;

                    IF(VTOAANID = 1) THEN
                            IF(ITEM_TP.SOTOTRINH IS NOT NULL) THEN
                                    V_CD_SOCV := ITEM_TP.SOTOTRINH;
                                END IF;

                            IF(ITEM_TP.NGAYTOTRINH IS NOT NULL) THEN
                                    V_CD_NGAYTOTRINH := ITEM_TP.NGAYTOTRINH;
                                END IF;
                        ELSE
                            IF(V_BC_SOCV IS NOT NULL) THEN
                                    V_CD_SOCV:=V_BC_SOCV;
                                ELSIF(V_BC_SOCV IS NULL) THEN
                                    SELECT PA.SOTOTRINH INTO V_CD_SOTOTRINH FROM TABLE(V_TABLE)PA 
                                    WHERE PA.TENTHAMPHAN=ITEM_TP.TENTHAMPHAN 
                                    ORDER BY PA.NGAYTAO DESC 
                                    FETCH FIRST 1 ROWS ONLY;
                                END IF;
                            IF(V_BC_NGAYDK IS NOT NULL) THEN
                                    V_CD_NGAYTOTRINH:=V_BC_NGAYDK;
                                ELSIF(V_BC_NGAYDK IS NULL) THEN
                                    SELECT PA.NGAYTOTRINH INTO V_CD_NGAYTOTRINH FROM TABLE(V_TABLE)PA
                                    WHERE PA.TENTHAMPHAN=ITEM_TP.TENTHAMPHAN
                                    ORDER BY PA.NGAYTAO DESC FETCH FIRST 1 ROWS ONLY;
                                END IF;
                        END IF;

                       IF(V_BC_NGUOIKY IS NOT NULL) THEN
                           V_CD_NGUOIKY:=V_BC_NGUOIKY;
                       ELSIF(V_BC_NGUOIKY IS NULL) THEN
                           SELECT PA.NGUOIKY INTO V_CD_NGUOIKY FROM TABLE(V_TABLE)PA
                            WHERE PA.TENTHAMPHAN=ITEM_TP.TENTHAMPHAN
                           ORDER BY PA.NGAYTAO DESC FETCH FIRST 1 ROWS ONLY;
                       END IF;
                      -------------------
                      SELECT PA.TENTHAMPHAN INTO V_TENTHAMPHAN FROM TABLE(V_TABLE)PA WHERE PA.TENTHAMPHAN=ITEM_TP.TENTHAMPHAN  ORDER BY PA.NGAYTAO DESC
                      FETCH FIRST 1 ROWS ONLY;
                  ------------------
           DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                 <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td style="text-align: center; vertical-align: top; font-size: 12pt">'||V_TENDONVI||'</td>
                        <td></td>
                        <th style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                    </tr>
                    <tr style="text-align: center;">
                        <td style="vertical-align: top;font-size: 12pt">
                            <table cellpadding="0" cellspacing="0">
                                <tr style="height: 1pt; padding-bottom: 3px;">
                                    <th style="text-align: right;width: 15px; "><span>V</span></th>
                                    <th style="border-bottom: 1px solid #000000;text-align: left;">
                                        <span>ĂN PHÒN</span>
                                    </th>
                                    <th style="text-align: left;"><span>G</span></th>
                                </tr>
                            </table>
                        </td>
                        <td></td>
                        <td style="vertical-align: top;">
                            <table cellpadding="0" cellspacing="0">
                                <tr style="height: 1pt; padding-bottom: 3px; font-size: 13pt">
                                    <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                                    <th style="border-bottom: 1px solid #000000; text-align: left;">
                                        <span>ộc lập - Tự do - Hạnh phú</span>
                                    </th>
                                    <th style="text-align: left;"><span>c</span></th>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="height: 10px;">
                        <td style="width: 450pt;"></td>
                        <td style="width: 600pt"></td>
                        <td style="width: 600pt"></td>
                    </tr>
             </table>
              <table cellpadding="2" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
                    <tr><td colspan="11"></td></tr>
                    <tr align="center" style="text-align: center; font-weight: bold">
                        <td colspan="11" style="text-align: center; vertical-align: middle; font-size: 14pt;">Danh sách đơn thụ lý '||VVNGAYNHAPTU||VVNGAYNHAPDEN||'
                        <br />
                            và phân công '||V_TENTHAMPHAN||' theo dõi, giải quyết
                        <br />
                            <span style="font-size: 14pt; font-weight: normal; font-style: italic;">(Kèm theo tờ trình số  '||V_CD_SOTOTRINH||'/TTr-'||V_DONVI_CV||'-VP ngày '||V_CD_NGAYTOTRINH||' của Văn phòng '||V_TENDONVI_FULL||')</span>
                        </td>
                    </tr>
                    <tr align="center" style="text-align: center; font-weight: bold">
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">TT</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số Thụ lý</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày thụ lý</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Người đề nghị, kiến nghị, thông báo</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Địa chỉ</td>
                        <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:56px;">QĐ/BA đề nghị xem xét theo thủ tục GĐT/TT</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thẩm phán giải quyết</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Phê duyệt của Chánh án '||V_DONVI_CV||'</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ghi chú</td>
                    </tr>
                    <tr align="center" style="text-align: center; font-weight: bold">
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:82px;">Số BA/QĐ</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày BA/QĐ</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tòa án Xét xử</td>
                    </tr>
                   ');
                     V_TT:=0;
                   FOR ITEM IN(
                             SELECT PA.*, 
                             DECODE(SUBSTR(BA_SO,0,INSTR(BA_SO, '/',1,2)-1),NULL,SUBSTR(BA_SO,0,INSTR(BA_SO, '/',1,1)-1),SUBSTR(BA_SO,0,INSTR(BA_SO, '/',1,2)-1))BA_SO_SUB
                             FROM TABLE(V_TABLE)PA WHERE PA.TENTHAMPHAN=ITEM_TP.TENTHAMPHAN 
                             ORDER BY CAST(NVL(SOTHULY,'0') AS NUMBER)
                             --ORDER BY regexp_replace(SOTHULY, '[^[:digit:]]', '')
                             )
                     LOOP
                     V_TT:=V_TT+1;
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr align="center" style="text-align: center;">
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||V_TT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.SOTHULY||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.NGAYTHULY||'</td>
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.NGUOIGUI||'</td>
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.DIAPHUONG||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.BA_SO_SUB||'<br />'||SUBSTR(ITEM.BA_SO,INSTR(ITEM.BA_SO, '/',-1))||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.BA_NGAY||'</td>
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.BA_TOAXX||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.TENTHAMPHAN||'</td>    
                       
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.GHICHU||'</td>
                    </tr>
                    ');   
                     END LOOP;


                   DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                     <tr>
                        <td colspan="11" style="height:10px;"></td>
                    </tr>
                     <tr align="center" style="text-align: center; font-weight: bold">
                        <td colspan="8" style="vertical-align: top;"></td>
                        <td colspan="3">
                            <p style="font-size: 13pt;">
                                <strong>KT. CHÁNH VĂN PHÒNG<br />
                                    PHÓ CHÁNH VĂN PHÒNG<br />
                                </strong>
                            </p>
                        </td>
                    </tr>
                    <tr align="center" style="text-align: center; font-weight: bold">
                        <td colspan="8" style="vertical-align: top;"></td>
                        <td colspan="3" style="vertical-align: bottom;height:90px;">
                            <p style="font-size: 13pt;"><strong>'||V_CD_NGUOIKY||'</strong></p>
                        </td>
                    </tr>
                 <tr style="height: 0px;">
                        <td style="width: 26px"></td>
                        <td style="width: 38px"></td>
                        <td style="width: 70px"></td>
                        <td style="width: 153px"></td>
                        <td style="width: 119px"></td>
                        <td style="width: 60px"></td>
                        <td style="width: 69px"></td>
                        <td style="width: 84px"></td>
                        <td style="width: 100px"></td>
                        <td style="width: 186px"></td>
                    </tr>
                </table>
               ');

               IF(V_TT_TP<COUNT_TP)THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                   <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
                    "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                    mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
                    style="mso-special-character:line-break;page-break-before:always">
                    </span>
                    <p class=MsoNormal><o:p></o:p></p>
                    ');
                END IF;
            END LOOP;
        END IF;
    END IF;


    OPEN CURRETURN FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM DUAL;  
        DBMS_LOB.FREETEMPORARY(V_EXPORT_TEXT);
      
        
END DON_SEARCH_TP_GIAI_QUYET;

PROCEDURE DON_SEARCH_TONDON
(
    VARRSELECTID       IN     clob,
    CURRETURN          OUT SYS_REFCURSOR
)
IS
     V_DEM NUMBER:=0;
BEGIN
          SELECT /* +PARALLEL(8) */  COUNT(*)TONG_SODON into V_DEM FROM GDTTT_DON d 
          where (INSTR(VARRSELECTID,','||D.ID||',')>0 or (d.CD_TA_TRANGTHAI in (2,3) and  INSTR(VARRSELECTID,','||D.ARR_DON_ID||',')>0) );

--          SELECT COUNT(*)TONG_SODON into V_COUNT FROM GDTTT_DON cv 
--          where (CV.ID = rec.id or (cv.CD_TA_TRANGTHAI in (2,3) and  CV.ARR_DON_ID=rec.id) );
           OPEN CURRETURN FOR
           SELECT V_DEM V_DEM FROM DUAL;  
END;
END PKG_GDTTT_HCTP_BC_APP;

/
