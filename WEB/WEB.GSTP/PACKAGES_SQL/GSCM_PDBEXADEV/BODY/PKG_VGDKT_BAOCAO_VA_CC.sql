--------------------------------------------------------
--  DDL for Package Body PKG_VGDKT_BAOCAO_VA_CC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_VGDKT_BAOCAO_VA_CC" AS
FUNCTION GDTTTT_VUAN_SEARCH_BC17
( 
   V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR
IS 
    V_CURSOR sys_refcursor;
    v_table T_BC_VGDKT_15; V_EXPORT_TEXT CLOB; v_dem NUMBER:=0;V_HANHCHINH_NAME NVARCHAR2(250 CHAR);
    vCount number; vCount1 number; vCount2 number; vtoaan_id number;
    v_DenNgay date; v_TuNgay date;V_CANBO_TK_NAME VARCHAR2(255);V_LANHDAO_TK_NAME VARCHAR2(255);
    v_TenPhongban varchar2(100);v_TenLoaian  varchar2(100);v_TenToaAn   varchar2(100);
    v_itemDV T_BC_VGDKT_15;
BEGIN
    SELECT DECODE(vTuNgay,null,null,to_date(to_char(vTuNgay,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')) into v_TuNgay from dual;
    SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into v_DenNgay from dual;
    SELECT REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),ta.id INTO v_TenToaAn,vtoaan_id FROM DM_TOAAN TA WHERE TA.ID=vToaAnID;
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
      v_table := T_BC_VGDKT_15();

       SELECT HC.TEN INTO V_HANHCHINH_NAME FROM DM_HANHCHINH HC 
      WHERE EXISTS(SELECT 'X' FROM DM_TOAAN TA WHERE TA.ID=vToaAnID AND TA.HANHCHINHID=HC.ID);

      if(V_CANBO_TK_ID is not null)then
        SELECT CB.HOTEN INTO V_CANBO_TK_NAME FROM DM_CANBO CB WHERE CB.ID=V_CANBO_TK_ID;
     else
        V_CANBO_TK_NAME:='';
     end if;
     if(V_LANHDAO_TK_ID is not null)then
         SELECT CB.HOTEN INTO V_LANHDAO_TK_NAME FROM DM_CANBO CB WHERE CB.ID=V_LANHDAO_TK_ID;
      else
        V_LANHDAO_TK_NAME:='';
     end if;
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
       <table cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <td style="text-align: center; vertical-align: middle; height: 25px; font-size: 12pt;" rowspan="3">
                    <p style="margin:3px 3px 3px 3px">TÒA ÁN NHÂN DÂN TỐI CAO</p>
                    <p style="margin:3px 3px 3px 3px"><b>TÒA ÁN NHÂN DÂN CẤP CAO</b></p>
                    <p style="margin:3px 3px 3px 3px"><b> '||v_TenToaAn||'</b></p>
                </td>
                <td></td>
                <th style="text-align: center; vertical-align: middle; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td></td>
                <td>
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 13pt">
                            <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>ộc lập - Tự do - Hạnh ph</span>
                            </th>
                            <th style="text-align: left;"><span>úc</span></th>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 500pt;"></td>
                <td style="width: 300pt;"></td>
                <td style="width: 500pt"></td>
            </tr>
        </table>

        <table cellpadding="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
             <tr style="height: 10px;"><td></td></tr>
            <tr>
                <td colspan="24" style="text-align: center; font-weight: bold;">THÔNG KÊ TÌNH HÌNH THỤ LÝ, GIẢI QUYẾT, XÉT XỬ</td>
            </tr>
            <tr>
                <td colspan="24" style="text-align: center; font-weight: bold;">THEO THỦ TỤC GIÁM ĐỐC THẨM, TÁI THẨM CÁC LOẠI VỤ, VIỆC 6 THÁNG ĐẦU NĂM '||to_char(extract(year from vTuNgay))||' </td>
            </tr>
            <tr>
                <td colspan="24" style="text-align: center; font-style: italic;">(Tính Từ ngày '||TO_CHAR(vTuNgay,'dd/MM/yyyy')||' - Đến ngày '||TO_CHAR(vDenNgay,'dd/MM/yyyy')||')</td>
            </tr>
            <tr style="text-align: center;">
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">TT</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Loại án</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 35px;" colspan="13">CÔNG TÁC GIẢI QUYẾT ĐƠN ĐỀ NGHỊ GIÁM ĐỐC THẨM, TÁI THẨM</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="8">XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Ghi chú</th>
            </tr>
            <tr>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 35px;" colspan="4">Tổng số đơn đã nhận và xử lý</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="3">Số đơn thuộc thẩm quyền giải quyết</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="6">Kết quả giải quyết</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="5">Thụ lý giám đốc thẩm, tái thẩm</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="3">Kết quả giải quyết, xét xử</th>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 150px;">Đơn năm '||EXTRACT(YEAR FROM v_TuNgay)||' còn lại chưa xử lý</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng số đơn đã nhận</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Đơn không thuộc thẩm quyền hoặc trùng lặp</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Đơn còn lại chưa xử lý</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Thụ lý cũ còn lại</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng số</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Thông báo không kháng nghị</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Ban hành QĐ kháng nghị</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Xử lý khác</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng số đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Còn lại</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tỷ lệ giải quyết
                    <br />
                    (%)</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">QĐ kháng nghị cũ chuyển sang</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">QĐ kháng nghị của CA Tòa án cấp cao</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">QĐ kháng nghị của VKS</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">QĐ kháng nghị của Chánh án Tòa án cấp khác</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng cộng</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Còn lại</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tỷ lệ giải quyết</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">1</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">2</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">3</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">4</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">5</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">6</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">7</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">8</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">9</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">10</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">11</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">12</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">13</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">14</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">15</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">16</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">17</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">18</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">19</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">20</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">21</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">22</td>
            </tr>
           ');
        SELECT R_BC_VGDKT_15(row_number() over (order by v.loaian),v.loaian,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
                    ) 
                BULK COLLECT INTO v_table
                from gdttt_vuan v where v.TOAANID=vToaAnID and v.PhongBanID = vPhongBanID and v.Loaian !=0 group by v.loaian;
      --------------
      FOR item IN (
            SELECT T.STT, T.LOAIAN FROM  TABLE(v_table) T 
            )
           LOOP
              --Cot 1 Đơn còn lại chưa xử lý
                  Select Count(d.ID) into vCount1
                    from GDTTT_DON d
                    Where d.CD_TA_DONVIID = vPhongBanID
                        And d.BAQD_LOAIAN = item.LOAIAN
                         AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3  AND DONVI_CHUYEN_ID=vToaAnID)
                         --TRANG_THAI_XLY=3 Chưa xử lý
                         And  d.ngaytao <= v_TuNgay
                         And NVL(d.vuviecid,0) = 0
                         ;
                 v_table(item.STT).COLUMN_1:=vCount1;    
             --Cot 2 Tổng số đơn đã nhận = thụ lý mới + đã thụ lý
                  Select sum(dc.SOLUONGDON) into vCount1
                    from GDTTT_DON_CHUYEN dc
                         inner join GDTTT_DON d on dc.DONID=d.ID 
                    Where d.CD_TRANGTHAI = 2 
                        And d.CD_TA_DONVIID = vPhongBanID
                        And d.BAQD_LOAIAN = item.LOAIAN
                        And  v_TuNgay <= dc.NGAYNHAN 
                        And dc.NGAYNHAN <= v_DenNgay;
                     v_table(item.STT).COLUMN_2:=vCount1;  
             --Cot 3 Đơn không thuộc thẩm quyền hoặc trùng lặp
               -- 3.1 Không thuộc thẩm quyền  = số đơn bị trả lại
              Select Count(d.ID) into vCount1
                    from GDTTT_DON d
                         inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID 
                    Where d.CD_TRANGTHAI = 3
                        And d.CD_TA_DONVIID = vPhongBanID
                        And d.BAQD_LOAIAN = item.LOAIAN
                        And  v_TuNgay <= dc.NGAYNHAN 
                        And dc.NGAYNHAN <= v_DenNgay
                        And upper(dc.GHICHU) like '%KHÔNG THUỘC THẨM QUYỀN%' ;

                -- 3.2 Đơn trùng lặp = số đơn trùng đã nhận                        
                Select sum(dc.SOLUONGDON) into vCount2
                    from GDTTT_DON_CHUYEN dc
                         inner join GDTTT_DON d on dc.DONID=d.ID 
                    Where d.CD_TRANGTHAI = 2
                        And d.CD_TA_DONVIID = vPhongBanID
                        And d.BAQD_LOAIAN = item.LOAIAN
                        And Exists (Select 'X' from GDTTT_DON d2 where d2.isthuly = 2 and d2.id = dc.DONID)
                        And  v_TuNgay <= dc.NGAYNHAN 
                        And dc.NGAYNHAN <= v_DenNgay;

                 v_table(item.STT).COLUMN_3:=vCount1 + vCount2;

                 --Cot 4 Đơn còn lại chưa xử lý=tổng số đơn phải giải quyết
                 v_table(item.STT).COLUMN_4:=NVL(v_table(item.STT).COLUMN_1,0)+  NVL(v_table(item.STT).COLUMN_2,0);  

                --Cot 5 Cũ còn lại phải giải quyết
                    Select Count(d.ID) into vCount1
                    from GDTTT_DON d
                         inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID 
                    Where d.CD_TRANGTHAI = 2-- GDTTT_DON.CD_TRANGTHAI(0,null Chưa chuyển,1 Đã chuyển,2 Đã nhận,3 Bị trả lại)
                        And d.CD_TA_DONVIID = vPhongBanID
                        And d.BAQD_LOAIAN = item.LOAIAN
                        And (NVL(d.ISThuLy, 0)=1 --ISTHULY when 1: 'thu ly moi', 2:'da thu ly'
                            Or (NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1 and Count_DonID_TLMoiChuyenCung(d.ID)>0) ) 
                        And  dc.NGAYNHAN <= v_TuNgay
                        ;
                v_table(item.STT).COLUMN_5:=vCount1;
                --Cot 6 Mới thụ lý Phải giải quyết
                         Select Count(d.ID) into vCount1
                    from GDTTT_DON d
                         inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID 
                    Where d.CD_TRANGTHAI = 2-- GDTTT_DON.CD_TRANGTHAI(0,null Chưa chuyển,1 Đã chuyển,2 Đã nhận,3 Bị trả lại)
                        And d.CD_TA_DONVIID = vPhongBanID
                        And d.BAQD_LOAIAN = item.LOAIAN
                        And NVL(d.ISThuLy, 0)=1 --ISTHULY when 1: 'thu ly moi', 2:'da thu ly'
                        And  dc.NGAYNHAN  between v_TuNgay And v_DenNgay
                        ;
                v_table(item.STT).COLUMN_6:=vCount1;
                ---
                v_table(item.STT).COLUMN_7:=(NVL(v_table(item.STT).COLUMN_5,0)+NVL(v_table(item.STT).COLUMN_6,0));
              --Cột 8 Trả lời đơn
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.GQD_LOAIKETQUA = 0 And v.GDQ_NGAY between v_TuNgay And v_DenNgay)
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                   ;-- And v.ngaytao <= v_DenNgay
                 v_table(item.STT).COLUMN_8:=vCount1;          
                  --Cột 9 - Kháng nghị
               Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.GQD_LOAIKETQUA = 1 And v.GDQ_NGAY between v_TuNgay And v_DenNgay)
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                   ;-- And v.ngaytao <= v_DenNgay
                 v_table(item.STT).COLUMN_9:=vCount1;     
                   --Cột 10 Xử lý khác
               Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA in (2,3,4)  
                    And ((v.GDQ_NGAY is not null and v.GDQ_NGAY between v_TuNgay And v_DenNgay) 
                            Or (v.GQD_NGAYPHATHANHCV  is not null and v.GQD_NGAYPHATHANHCV between v_TuNgay And v_DenNgay) )
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    ;--And v.ngaytao <= v_DenNgay
                    v_table(item.STT).COLUMN_10:=vCount1;  
                   --Cột 11 Tổng số đã giải quyết
                   v_table(item.STT).COLUMN_11:=(NVL(v_table(item.STT).COLUMN_8,0)+NVL(v_table(item.STT).COLUMN_9,0)+NVL(v_table(item.STT).COLUMN_10,0) );  
                   --Cột 12 Tổng số - Còn lại
                   v_table(item.STT).COLUMN_12:= NVL(v_table(item.STT).COLUMN_7,0) - NVL(v_table(item.STT).COLUMN_11,0);
                   --Cột 13 Tỷ lệ giải quyết (%)
                   IF(NVL(v_table(item.STT).COLUMN_7,0)>0)THEN
                    v_table(item.STT).COLUMN_13:=TRUNC((NVL(v_table(item.STT).COLUMN_11,0)/v_table(item.STT).COLUMN_7)*100,2);
                   ELSE
                    v_table(item.STT).COLUMN_13:=0;
                   END IF;
                 --Cot 14 QĐ kháng nghị cũ chuyển sang
                    Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and v.NGAYTHULYXXGDT < v_TuNgay)
                    And (NVL(v.XXGDTTT_ISKETQUA,0) = 0  Or (NVL(v.XXGDTTT_ISKETQUA,0)>0 and v.NGAYTHULYXXGDT is not null and v.NGAYTHULYXXGDT >= v_TuNgay) )
                    And v.GQD_LOAIKETQUA = 1; -- KN
                    -- And (NVL(v.ISVIENTRUONGKN,0) = 0 or  NVL(v.ISVIENTRUONGKN,0) = 1); -- CAKN
                    v_table(item.STT).COLUMN_14:=vCount1;

                     --Cot 15 QĐ kháng nghị của CA Tòa án cấp cao
                   Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and (v.NGAYTHULYXXGDT between v_TuNgay and v_DenNgay))
                    and exists(select 'x' from gdttt_vuan dv where decode(dv.BAQD_CAPXETXU,4,dv.TOAQDID,3,dv.TOAPHUCTHAMID,2,dv.TOAANSOTHAM,dv.TOAPHUCTHAMID) in (4,5,6) 
                                        And dv.PhongBanID = vPhongBanID and dv.id=v.id)
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 0 -- CAKN
                    ;--And v.ngaytao <= v_DenNgay
                   v_table(item.STT).COLUMN_15:=vCount1;

                --Cot 16 QĐ kháng nghị của VKS
                   Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and v.NGAYTHULYXXGDT between v_TuNgay and v_DenNgay)
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 1 -- VTKN
                    ;--And v.ngaytao <= v_DenNgay
                   v_table(item.STT).COLUMN_16:=vCount1; 

                 --Cot 17 QĐ kháng nghị của Chánh án Tòa án cấp khác
                   Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and (v.NGAYTHULYXXGDT between v_TuNgay and v_DenNgay))
                    and not exists(select 'x' from gdttt_vuan dv where decode(dv.BAQD_CAPXETXU,4,dv.TOAQDID,3,dv.TOAPHUCTHAMID,2,dv.TOAANSOTHAM,dv.TOAPHUCTHAMID) in (4,5,6) 
                                        And dv.PhongBanID = vPhongBanID and dv.id=v.id)
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 0 -- CAKN
                    ;--And v.ngaytao <= v_DenNgay
                  v_table(item.STT).COLUMN_17:=vCount1;
                  -----
                  v_table(item.STT).COLUMN_18:=(NVL(v_table(item.STT).COLUMN_14,0)+NVL(v_table(item.STT).COLUMN_15,0)+NVL(v_table(item.STT).COLUMN_16,0)+NVL(v_table(item.STT).COLUMN_17,0));
                  --Cot1 19 CA KN,VT KN đã xử
                    Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And (NVL(v.ISVIENTRUONGKN,0) = 0 OR NVL(v.ISVIENTRUONGKN,0) = 1) 
                    -- And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and (v.NGAYTHULYXXGDT between v_TuNgay and v_DenNgay))
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    --loại bỏ trường hợp hoãn
                    AND EXISTS( SELECT TTS.VUANID FROM (SELECT TT.VUANID FROM (  
                                     SELECT VUANID,ISHOAN,NGAYMOPT,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYMOPT DESC) ID
                                     FROM  GDTTT_VUAN_XETXUGDTTT 
                                      )TT where  TT.ISHOAN=0 AND TT.NGAYMOPT between v_TuNgay and v_DenNgay
                                     GROUP BY TT.VUANID)TTS WHERE TTS.VUANID=v.ID
                                )
                    ;--And v.ngaytao <= v_DenNgay
                   v_table(item.STT).COLUMN_19:=vCount1; 
                  --Cot 20 CA KN Còn lại
                  v_table(item.STT).COLUMN_20:=NVL(v_table(item.STT).COLUMN_18,0) - NVL(v_table(item.STT).COLUMN_19,0);
                 --Cột 21 Tỷ lệ giải quyết (%)
                   IF(NVL(v_table(item.STT).COLUMN_18,0)>0)THEN
                    v_table(item.STT).COLUMN_21:=TRUNC((NVL(v_table(item.STT).COLUMN_19,0)/v_table(item.STT).COLUMN_18)*100,2);
                   ELSE
                    v_table(item.STT).COLUMN_21:=0;
                   END IF;
            -------
           END LOOP;
        --------
        FOR item_loaian IN (
           SELECT JM.* FROM TABLE(v_table) JM ORDER BY JM.Loaian
           )
         LOOP
         -- Lấy ra tên loại án
         select  DECODE(item_loaian.Loaian,1,'Hình sự',2,'Dân sự',3,'HNGD',4,'KDTM',5,'Lao động',6,'Hành chính') into v_TenLoaian from dual;

         DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr> 
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding:5px;">'||item_loaian.stt||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||v_TenLoaian||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_1||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_2||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_3||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_4||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_5||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_6||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_7||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_8||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_9||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_10||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_11||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_12||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||rtrim(to_char(item_loaian.COLUMN_13, 'FM999999999999990.99'), '.')||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_14||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_15||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_16||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_17||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_18||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_19||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_20||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||rtrim(to_char(item_loaian.COLUMN_21, 'FM999999999999990.99'), '.')||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_22||'</td>
            </tr>
       ');
      END LOOP;  
     ------------------
     DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <tr>
                <td colspan="16"></td>
                <td colspan="8" style="text-align: center;height:17pt"><i>'||REPLACE(REPLACE(V_HANHCHINH_NAME,'thành phố','TP.'),'tỉnh','')||', ngày '||TO_CHAR(sysdate, 'DD')||' tháng '||to_char(EXTRACT(month FROM sysdate))||' năm '||to_char(extract(year from sysdate))||'</i></td>
            </tr>
            <tr>
                <td colspan="16"></td>
                <th colspan="8" style="text-align: center; height: 90pt; vertical-align: top;">NGƯỜI BÁO CÁO</th>
            </tr>
             <tr>
               <td colspan="16"></td>
                <th colspan="8" style="text-align: center; vertical-align: top;">'||V_CANBO_TK_NAME||'</th>
            </tr>
    ');  
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <tr style="height: 0px;">
                <td style="width: 60px"></td>
                <td style="width: 120px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 90px"></td>
            </tr>
   </table>
    ');  
 --------------------------------
      OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GDTTTT_VUAN_SEARCH_BC17;
FUNCTION GDTTTT_VUAN_SEARCH_BC18
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR
IS 
    V_CURSOR sys_refcursor;
    v_table T_BC_VGDKT_15; V_EXPORT_TEXT CLOB; v_dem NUMBER:=0;
    vCount number; vCount1 number; vCount2 number; vtoaan_id number;V_HANHCHINH_NAME NVARCHAR2(250 CHAR);
    v_DenNgay date; v_TuNgay date;V_CANBO_TK_NAME VARCHAR2(255);V_LANHDAO_TK_NAME VARCHAR2(255);
    v_TenPhongban varchar2(100);v_TenLoaian  varchar2(100);v_TenToaAn   varchar2(100);
    v_itemDV T_BC_VGDKT_15;
    v_thang_tungay varchar2(255);thang_12 varchar2(100);thang_11 varchar2(100);thang_10 varchar2(100);
    v_DenNgay_t9 date;v_TuNgay_t10 date;v_DenNgay_t10 date;v_TuNgay_t11 date;v_DenNgay_t11 date;vCOLUMN_16total number;
BEGIN
    SELECT DECODE(vTuNgay,null,null,to_date(to_char(vTuNgay,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')) into v_TuNgay from dual;
    SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into v_DenNgay from dual;
    SELECT REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),ta.id INTO v_TenToaAn,vtoaan_id FROM DM_TOAAN TA WHERE TA.ID=vToaAnID;
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
      v_table := T_BC_VGDKT_15();
      ----
     SELECT HC.TEN INTO V_HANHCHINH_NAME FROM DM_HANHCHINH HC 
     WHERE EXISTS(SELECT 'X' FROM DM_TOAAN TA WHERE TA.ID=vToaAnID AND TA.HANHCHINHID=HC.ID);
     ----
      if(V_CANBO_TK_ID is not null)then
        SELECT CB.HOTEN INTO V_CANBO_TK_NAME FROM DM_CANBO CB WHERE CB.ID=V_CANBO_TK_ID;
     else
        V_CANBO_TK_NAME:='';
     end if;
     if(V_LANHDAO_TK_ID is not null)then
         SELECT CB.HOTEN INTO V_LANHDAO_TK_NAME FROM DM_CANBO CB WHERE CB.ID=V_LANHDAO_TK_ID;
      else
        V_LANHDAO_TK_NAME:='';
     end if;
      ---vidu: từ ngày 01/12/2020 đến 31/12/2020
     --dùng để điền vào tiêu đề báo cáo
     v_thang_tungay:=extract(month from v_TuNgay);--lấy tháng của từ ngày trong trường hợp lấy nhiều tháng
     thang_11:=extract(month from add_months(v_TuNgay, -1));--lấy tháng 11 từ  tháng 12-1
     thang_10:=extract(month from add_months(v_TuNgay, -2));--lấy tháng 10 từ  tháng 12-2
     thang_12:=extract(month from v_DenNgay);--lấy tháng 12 của biến đến ngày 31/12/2020 

    if(v_thang_tungay=thang_12)then
      v_thang_tungay:=thang_12||'/'||extract(year from v_TuNgay);
      else
      v_thang_tungay:='<br/>'||v_thang_tungay||' - '||thang_12||'<br/> / <br/>'||extract(year from v_TuNgay);
    end if;


     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
     <table cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <td style="text-align: center; vertical-align: middle; height: 25px; font-size: 12pt;" rowspan="3">
                    <p style="margin: 3px 3px 3px 3px">TÒA ÁN NHÂN DÂN TỐI CAO</p>
                    <p style="margin: 3px 3px 3px 3px"><b>TÒA ÁN NHÂN DÂN CẤP CAO</b></p>
                    <p style="margin: 3px 3px 3px 3px"><b>'||v_TenToaAn||'</b></p>
                </td>
                <td></td>
                <th style="text-align: center; vertical-align: middle; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td></td>
                <td>
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 13pt">
                            <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>ộc lập - Tự do - Hạnh ph</span>
                            </th>
                            <th style="text-align: left;"><span>úc</span></th>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 500pt;"></td>
                <td style="width: 300pt;"></td>
                <td style="width: 500pt"></td>
            </tr>
        </table>
       <table cellpadding="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr style="height: 10px;">
                <td colspan="18"></td>
            </tr>
            <tr>
                <td colspan="18" style="text-align: center; font-weight: bold; font-size: 15pt;">BÁO CÁO</td>
            </tr>
            <tr>
                <td colspan="18" style="text-align: center; font-weight: bold; font-size: 13pt;">Về công tác thụ lý, giải quyết đơn giám đốc thẩm, tái thẩm</td>
            </tr>
            <tr>
                <td colspan="18" style="text-align: center; font-style: italic; font-size: 12pt;">(Tính Từ ngày '||TO_CHAR(vTuNgay,'dd/MM/yyyy')||' - Đến ngày '||TO_CHAR(vDenNgay,'dd/MM/yyyy')||')</td>
            </tr>
            <tr style="text-align: center;">
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">TT</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Loại án</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 35px;" colspan="4">Đơn đã thụ lý</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="10">Số đơn đã giải quyết</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Còn lại</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Tỷ lệ%</th>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 35px;" rowspan="2">Cũ còn lại chuyển</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tháng <br/> '||thang_10||' - '||thang_11||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tháng '||v_thang_tungay||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tổng cộng</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="3">Kháng nghị</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="3">Trả lời đơn</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="3">Xóa thụ lý</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tổng cộng</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 150px;">Tháng <br/>'||thang_10||' - '||thang_11||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tháng '||thang_12||'/'||extract(year from v_TuNgay)||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng cộng</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 150px;">Tháng <br/>'||thang_10||' - '||thang_11||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tháng '||v_thang_tungay||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng cộng</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 150px;">Tháng <br/>'||thang_10||' - '||thang_11||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tháng '||v_thang_tungay||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng cộng</td>

            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">1</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">2</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">3</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">4</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">5</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">6</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">7</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">8</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">9</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">10</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">11</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">12</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">13</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">14</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">15</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">16</td>
            </tr>
           ');

          ---vidu: từ ngày 01/12/2020 đến 31/12/2020
         --dùng làm tham số có hàm tính tổng phía dưới
         v_DenNgay_t9:=last_day(add_months(v_TuNgay, -3));--lấy ngày cuối cùng của tháng 9:=12-3 
         v_TuNgay_t10:=add_months(TRUNC(v_TuNgay,'MM'), -2);--lấy ngày đầu tiên của tháng 10:=12-2
         v_DenNgay_t10:=last_day(add_months(v_TuNgay, -2));--lấy ngày cuối cùng của tháng 10:=12-2  
         v_TuNgay_t11:=add_months(TRUNC(v_TuNgay,'MM'), -1);--lấy ngày đầu tiên của tháng 11:=12-1
         v_DenNgay_t11:=last_day(add_months(v_TuNgay, -1));--lấy ngày cuối cùng của tháng 11:=12-1  

         --mai làm tiếp
        SELECT R_BC_VGDKT_15(row_number() over (order by v.loaian),v.loaian,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
                    ) 
                BULK COLLECT INTO v_table
                from gdttt_vuan v where v.TOAANID=vToaAnID and v.PhongBanID = vPhongBanID and v.Loaian !=0 group by v.loaian;
      --------------
      FOR item IN (
            SELECT T.STT, T.LOAIAN FROM  TABLE(v_table) T 
            )
           LOOP
              --Cot 1 Đơn đã thụ lý Cũ còn lại chuyển
                Select Count(d.ID) into vCount1
                    from GDTTT_DON d
                    inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID 
                    left join GDTTT_VUAN v on v.id=d.vuviecid
                    Where d.CD_TRANGTHAI = 2-- GDTTT_DON.CD_TRANGTHAI(0,null Chưa chuyển,1 Đã chuyển,2 Đã nhận,3 Bị trả lại)
                        And d.CD_TA_DONVIID = vPhongBanID
                        And d.BAQD_LOAIAN = item.LOAIAN
                        And dc.NGAYNHAN <= v_DenNgay_T9 --Mạnh đã hỏi e Lụa tòa cấp cao, sửa ngày nhận thành ngày tạo 29/09/2021 sẽ sửa sau khi chốt với nhóm test
                        and v.GQD_LOAIKETQUA is null
                        ;
                    v_table(item.STT).COLUMN_1:=vCount1;    
             --Cot 2 Đơn đã thụ lý Tháng 10 - 11
             Select Count(d.ID) into vCount1
                    from GDTTT_DON d
                    inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID 
                    Where d.CD_TRANGTHAI = 2-- GDTTT_DON.CD_TRANGTHAI(0,null Chưa chuyển,1 Đã chuyển,2 Đã nhận,3 Bị trả lại)
                    And d.CD_TA_DONVIID = vPhongBanID
                    And d.BAQD_LOAIAN = item.LOAIAN
                    And dc.NGAYNHAN  between v_TuNgay_t10 and v_DenNgay_T11--anhvh đã hỏi manhnd lấy ngày nhận trên form nhận án và thụ lý vụ án
                   ;
                   v_table(item.STT).COLUMN_2:=vCount1; 
             --Cot 3 Đơn đã thụ lý Tháng 12/2020
               Select Count(d.ID) into vCount1
                    from GDTTT_DON d
                    inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID 
                    Where d.CD_TRANGTHAI = 2-- GDTTT_DON.CD_TRANGTHAI(0,null Chưa chuyển,1 Đã chuyển,2 Đã nhận,3 Bị trả lại)
                    And d.CD_TA_DONVIID = vPhongBanID
                    And d.BAQD_LOAIAN = item.LOAIAN
                    And dc.NGAYNHAN  between v_TuNgay and v_DenNgay
                   ;
                 v_table(item.STT).COLUMN_3:=vCount1;
                 --Cot 4 Đơn đã thụ lý Tổng cộng
                 v_table(item.STT).COLUMN_4:=NVL(v_table(item.STT).COLUMN_1,0)+  NVL(v_table(item.STT).COLUMN_2,0)+  NVL(v_table(item.STT).COLUMN_3,0);  
                  --Cot 5 Kháng nghị Tháng 10 - 11
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.GQD_LOAIKETQUA = 1 And v.GDQ_NGAY between v_TuNgay_t10 And v_DenNgay_t11)
                    ;
                 v_table(item.STT).COLUMN_5:=vCount1;
                 --Cot 6 Kháng nghị Tháng 12/2020
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.GQD_LOAIKETQUA = 1 And v.GDQ_NGAY between v_TuNgay And v_DenNgay)
                    ;
                 v_table(item.STT).COLUMN_6:=vCount1;
                 --Cot 7 Tổng cộng
                v_table(item.STT).COLUMN_7:=(NVL(v_table(item.STT).COLUMN_5,0)+NVL(v_table(item.STT).COLUMN_6,0));
                --Cột 8 Trả lời đơn Tháng 10 - 11
                    Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.GQD_LOAIKETQUA = 0 And v.GDQ_NGAY between v_TuNgay_t10 And v_DenNgay_t11)
                    ;
                 v_table(item.STT).COLUMN_8:=vCount1;          
                  --Cột 9 Trả lời đơn Tháng 12/2020
                   Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.GQD_LOAIKETQUA = 0 And v.GDQ_NGAY between v_TuNgay And v_DenNgay)
                    ;
                   v_table(item.STT).COLUMN_9:=vCount1;          
                   --Cột 10 Tổng cộng
                   v_table(item.STT).COLUMN_10:= NVL(v_table(item.STT).COLUMN_8,0) + NVL(v_table(item.STT).COLUMN_9,0);
                    --Cột 14 Tổng cộng
                   v_table(item.STT).COLUMN_14:= NVL(v_table(item.STT).COLUMN_7,0) + NVL(v_table(item.STT).COLUMN_10,0);
                   --Cột 15 Còn lại
                   v_table(item.STT).COLUMN_15:= NVL(v_table(item.STT).COLUMN_4,0) - NVL(v_table(item.STT).COLUMN_14,0);
                   --Cột 16 Tỷ lệ giải quyết (%)
                   IF(NVL(v_table(item.STT).COLUMN_4,0)>0)THEN
                    v_table(item.STT).COLUMN_16:=TRUNC((NVL(v_table(item.STT).COLUMN_14,0)/v_table(item.STT).COLUMN_4)*100,2);
                   ELSE
                    v_table(item.STT).COLUMN_16:=0;
                   END IF;
            -------
           END LOOP;
        --------
        FOR item_loaian IN (
           SELECT JM.* FROM TABLE(v_table) JM ORDER BY JM.Loaian
           )
         LOOP
         -- Lấy ra tên loại án
         select  DECODE(item_loaian.Loaian,1,'Hình sự',2,'Dân sự',3,'HNGD',4,'KDTM',5,'Lao động',6,'Hành chính') into v_TenLoaian from dual;

         DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr> 
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding:5px;">'||item_loaian.stt||'</td>
                <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;">'||v_TenLoaian||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_1||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_2||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_3||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_4||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_5||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_6||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_7||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_8||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_9||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_10||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_11||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_12||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_13||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_14||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_15||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||rtrim(to_char(item_loaian.COLUMN_16, 'FM999999999999990.99'), '.')||'</td>
            </tr>
       ');
      END LOOP;  
      ---in tong cong 
      FOR item_ld IN (
                     SELECT SUM(JM.COLUMN_1) COLUMN_1,SUM(JM.COLUMN_2) COLUMN_2,SUM(JM.COLUMN_3) COLUMN_3,SUM(JM.COLUMN_4) COLUMN_4,
                     SUM(JM.COLUMN_5) COLUMN_5,SUM(JM.COLUMN_6) COLUMN_6,SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_8) COLUMN_8,
                     SUM(JM.COLUMN_9) COLUMN_9,SUM(JM.COLUMN_10) COLUMN_10,SUM(JM.COLUMN_11) COLUMN_11,SUM(JM.COLUMN_12) COLUMN_12
                     ,SUM(JM.COLUMN_13) COLUMN_13 ,SUM(JM.COLUMN_14) COLUMN_14 ,SUM(JM.COLUMN_15) COLUMN_15 
                     ,SUM(JM.COLUMN_16) COLUMN_16,SUM(JM.COLUMN_17) COLUMN_17,SUM(JM.COLUMN_18) COLUMN_18
                     ,SUM(JM.COLUMN_19) COLUMN_19,SUM(JM.COLUMN_20) COLUMN_20,SUM(JM.COLUMN_21) COLUMN_21,SUM(JM.COLUMN_22) COLUMN_22,SUM(JM.COLUMN_23) COLUMN_23
                     FROM TABLE(v_table) JM
                )
      LOOP
      --Cột 16 Tỷ lệ giải quyết (%)
                   IF(NVL(item_ld.COLUMN_4,0)>0)THEN
                    vCOLUMN_16total:=TRUNC((NVL(item_ld.COLUMN_14,0)/item_ld.COLUMN_4)*100,2);
                   ELSE
                   vCOLUMN_16total:=0;
                   END IF;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding:5px;"></td>
                    <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;">Tổng</td>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_1||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_2||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_3||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_4||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_5||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_6||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_7||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_8||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_9||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_10||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_11||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_12||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_13||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_14||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_15||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||rtrim(to_char(vCOLUMN_16total, 'FM999999999999990.99'), '.')||'</th>
                </tr>
       ');
      END LOOP;
     --------
     DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
         <tr>
               <td colspan="11"></td>
                <td colspan="7" style="text-align: center;height:17pt"><i>'||REPLACE(REPLACE(V_HANHCHINH_NAME,'thành phố','TP.'),'tỉnh','')||', ngày '||TO_CHAR(sysdate, 'DD')||' tháng '||to_char(EXTRACT(month FROM sysdate))||' năm '||to_char(extract(year from sysdate))||'</i></td>
            </tr>
            <tr>
                <td colspan="11"></td>
                <th colspan="7" style="text-align: center; height: 90pt; vertical-align: top;">NGƯỜI BÁO CÁO</th>
            </tr>
                <tr>
               <td colspan="11"></td>
                <th colspan="7" style="text-align: center;vertical-align: top;">'||V_CANBO_TK_NAME||'</th>
            </tr>
    ');  
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <tr style="height: 0px;">
                <td style="width: 80px"></td>
                <td style="width: 120px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
            </tr>
   </table>
    ');  
 --------------------------------
      OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GDTTTT_VUAN_SEARCH_BC18;

FUNCTION GDTTTT_VUAN_SEARCH_BC19
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR
IS 
    V_CURSOR sys_refcursor;
    v_table T_BC_VGDKT_15; V_EXPORT_TEXT CLOB; v_dem NUMBER:=0;
    vCount number; vCount1 number; vCount2 number; vtoaan_id number;V_HANHCHINH_NAME NVARCHAR2(250 CHAR);
    v_DenNgay date; v_TuNgay date;V_CANBO_TK_NAME VARCHAR2(255);V_LANHDAO_TK_NAME VARCHAR2(255);
    v_TenPhongban varchar2(100);v_TenLoaian  varchar2(100);v_TenToaAn   varchar2(100);vCOLUMN_13total number;

    v_thang_tungay varchar2(255);thang_12 varchar2(100);thang_11 varchar2(100);thang_10 varchar2(100);
    v_DenNgay_t9 date;v_TuNgay_t10 date;v_DenNgay_t10 date;v_TuNgay_t11 date;v_DenNgay_t11 date;vCOLUMN_16total number;
BEGIN
    SELECT DECODE(vTuNgay,null,null,to_date(to_char(vTuNgay,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')) into v_TuNgay from dual;
    SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into v_DenNgay from dual;
    SELECT REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),ta.id INTO v_TenToaAn,vtoaan_id FROM DM_TOAAN TA WHERE TA.ID=vToaAnID;
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
     v_table := T_BC_VGDKT_15();

     SELECT HC.TEN INTO V_HANHCHINH_NAME FROM DM_HANHCHINH HC 
     WHERE EXISTS(SELECT 'X' FROM DM_TOAAN TA WHERE TA.ID=vToaAnID AND TA.HANHCHINHID=HC.ID);
     ----
      if(V_CANBO_TK_ID is not null)then
        SELECT CB.HOTEN INTO V_CANBO_TK_NAME FROM DM_CANBO CB WHERE CB.ID=V_CANBO_TK_ID;
     else
        V_CANBO_TK_NAME:='';
     end if;
     if(V_LANHDAO_TK_ID is not null)then
         SELECT CB.HOTEN INTO V_LANHDAO_TK_NAME FROM DM_CANBO CB WHERE CB.ID=V_LANHDAO_TK_ID;
      else
        V_LANHDAO_TK_NAME:='';
     end if;
      ---vidu: từ ngày 01/12/2020 đến 31/12/2020
     --dùng để điền vào tiêu đề báo cáo
     v_thang_tungay:=extract(month from v_TuNgay);--lấy tháng của từ ngày trong trường hợp lấy nhiều tháng
     thang_11:=extract(month from add_months(v_TuNgay, -1));--lấy tháng 11 từ  tháng 12-1
     thang_10:=extract(month from add_months(v_TuNgay, -2));--lấy tháng 10 từ  tháng 12-2
     thang_12:=extract(month from v_DenNgay);--lấy tháng 12 của biến đến ngày 31/12/2020 

    if(v_thang_tungay=thang_12)then
      v_thang_tungay:=thang_12||'/'||extract(year from v_TuNgay);
      else
      v_thang_tungay:='<br/>'||v_thang_tungay||' - '||thang_12||'<br/> / <br/>'||extract(year from v_TuNgay);
    end if;

     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
     <table cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <td style="text-align: center; vertical-align: middle; height: 25px; font-size: 12pt;" rowspan="3">
                    <p style="margin:3px 3px 3px 3px">TÒA ÁN NHÂN DÂN TỐI CAO</p>
                    <p style="margin:3px 3px 3px 3px"><b>TÒA ÁN NHÂN DÂN CẤP CAO</b></p>
                    <p style="margin:3px 3px 3px 3px"><b> '||v_TenToaAn||'</b></p>
                </td>
                <td></td>
                <th style="text-align: center; vertical-align: middle; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td></td>
                <td>
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 13pt">
                            <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>ộc lập - Tự do - Hạnh ph</span>
                            </th>
                            <th style="text-align: left;"><span>úc</span></th>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 500pt;"></td>
                <td style="width: 300pt;"></td>
                <td style="width: 500pt"></td>
            </tr>
        </table>
         <table cellpadding="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
             <tr style="height: 10px;"><td></td></tr>
            <tr>
                <td colspan="15" style="text-align: center; font-weight: bold;font-size: 15pt;">BÁO CÁO</td>
            </tr>
            <tr>
                <td colspan="15" style="text-align: center; font-weight: bold;font-size: 13pt;">Về công tác xét xử giám đốc thẩm, tái thẩm</td>
            </tr>
            <tr>
                <td colspan="15" style="text-align: center; font-style: italic;font-size: 12pt;">(Tính Từ ngày '||TO_CHAR(vTuNgay,'dd/MM/yyyy')||' - Đến ngày '||TO_CHAR(vDenNgay,'dd/MM/yyyy')||')</td>
            </tr>
            <tr style="text-align: center;">
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">TT</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Loại án</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 35px;" colspan="4">Thụ lý</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="7">Đã giải quyết</th>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Còn lại</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Tỷ lệ</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 35px;" rowspan="2">Cũ còn lại chuyển</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tháng <br/>'||thang_10||' - '||thang_11||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tháng '||v_thang_tungay||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tổng cộng</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="3">Xét xử</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="3">Rút kháng nghị</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tổng cộng</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 150px;">Tháng <br/>'||thang_10||' - '||thang_11||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tháng '||v_thang_tungay||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng cộng</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tháng '||thang_10||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tháng '||thang_11||'</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng cộng</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">1</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">2</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">3</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">4</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">5</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">6</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">7</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">8</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">9</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">10</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">11</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">12</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; font-style: italic; color: #808080">13</td>
            </tr>
           ');
         ---vidu: từ ngày 01/12/2020 đến 31/12/2020
         --dùng làm tham số có hàm tính tổng phía dưới
         v_DenNgay_t9:=last_day(add_months(v_TuNgay, -3));--lấy ngày cuối cùng của tháng 9:=12-3 
         v_TuNgay_t10:=add_months(TRUNC(v_TuNgay,'MM'), -2);--lấy ngày đầu tiên của tháng 10:=12-2
         v_DenNgay_t10:=last_day(add_months(v_TuNgay, -2));--lấy ngày cuối cùng của tháng 10:=12-2  
         v_TuNgay_t11:=add_months(TRUNC(v_TuNgay,'MM'), -1);--lấy ngày đầu tiên của tháng 11:=12-1
         v_DenNgay_t11:=last_day(add_months(v_TuNgay, -1));--lấy ngày cuối cùng của tháng 11:=12-1  

        SELECT R_BC_VGDKT_15(row_number() over (order by v.loaian),v.loaian,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
                    ) 
                BULK COLLECT INTO v_table
                from gdttt_vuan v where v.TOAANID=vToaAnID and v.PhongBanID = vPhongBanID and v.Loaian !=0 group by v.loaian;
      --------------
      FOR item IN (
            SELECT T.STT, T.LOAIAN FROM  TABLE(v_table) T 
            )
           LOOP
              --Cot 1 Cũ còn lại chuyển
               Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.NGAYTHULYXXGDT is not null 
                    and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')
                    and NVL(v.XXGDTTT_ISKETQUA,0) = 0
                    and v.NGAYTHULYXXGDT <= v_DenNgay_T9
                     and (NVL(v.XXGDTTT_ISKETQUA,0)=0--XXGDTTT_ISKETQUA=0 chưa xét xử, hoặc đang hoãn; XXGDTTT_ISKETQUA=1 đã xét xử
                        Or(NVL(v.XXGDTTT_ISKETQUA,0)>0 and v.NGAYTHULYXXGDT is not null and  v.NGAYTHULYXXGDT >= v_DenNgay_T9)) 
                    ;
                   v_table(item.STT).COLUMN_1:=vCount1;    
              --Cot 2 Tháng 10 - 11
              Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And NVL(v.XXGDTTT_ISKETQUA,0)=0
                    And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and (v.NGAYTHULYXXGDT between v_TuNgay_t10 and v_DenNgay_t11))
                    ;
                    v_table(item.STT).COLUMN_2:=vCount1;  
             --Cot 3 Thang 12
       Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And NVL(v.XXGDTTT_ISKETQUA,0)=0
                    And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and (v.NGAYTHULYXXGDT between v_TuNgay and v_DenNgay))
                    ;
                 v_table(item.STT).COLUMN_3:=vCount1;

                 --Cot 4 Đơn còn lại chưa xử lý=tổng số đơn phải giải quyết
                 v_table(item.STT).COLUMN_4:=NVL(v_table(item.STT).COLUMN_1,0)+  NVL(v_table(item.STT).COLUMN_2,0)+  NVL(v_table(item.STT).COLUMN_3,0);  

                --Cot 5 Tháng 10 - 11
               Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    --lấy 1 bản ghi ngày NGAYMOPT cuối cùng 
                     And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and (v.NGAYTHULYXXGDT between v_TuNgay_t10 and v_DenNgay_t11))
                    --chỉ lấy những trường hợp là xét xử, không lấy trường hợp là hoãn
                    AND EXISTS( SELECT TTS.VUANID FROM (SELECT TT.VUANID FROM (  
                                     SELECT VUANID,ISHOAN,NGAYMOPT,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYMOPT DESC) ID
                                     FROM  GDTTT_VUAN_XETXUGDTTT 
                                      )TT where  TT.ISHOAN=0 AND TT.NGAYMOPT between v_TuNgay_t10 and v_DenNgay_t11
                                     GROUP BY TT.VUANID)TTS WHERE TTS.VUANID=v.ID
                                )
                         ;
                  v_table(item.STT).COLUMN_5:=vCount1;
               --Cot 6 Tháng 12
               Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                     And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and (v.NGAYTHULYXXGDT between v_TuNgay and v_DenNgay))
                    AND EXISTS( SELECT TTS.VUANID FROM (SELECT TT.VUANID FROM (  
                                     SELECT VUANID,ISHOAN,NGAYMOPT,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYMOPT DESC) ID
                                     FROM  GDTTT_VUAN_XETXUGDTTT 
                                      )TT where  TT.ISHOAN=0 AND TT.NGAYMOPT between v_TuNgay and v_DenNgay
                                     GROUP BY TT.VUANID)TTS WHERE TTS.VUANID=v.ID
                                )
                    ;
                v_table(item.STT).COLUMN_6:=vCount1;
                ---
                v_table(item.STT).COLUMN_7:=(NVL(v_table(item.STT).COLUMN_5,0)+NVL(v_table(item.STT).COLUMN_6,0));
              --Cột 8 Tháng 10 rút kháng nghị
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    and NVL(v.IsRutKN,0) =1
                     And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and (v.NGAYTHULYXXGDT between v_TuNgay_t10 and v_DenNgay_t10))
                    and v.NGAYRUTKN between v_TuNgay_t10 and v_DenNgay_t10
                    ;
                 v_table(item.STT).COLUMN_8:=vCount1;          

                 --Cột 9 Tháng 11 rút kháng nghị
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    and NVL(v.IsRutKN,0) =1
                     And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and (v.NGAYTHULYXXGDT between v_TuNgay_t11 and v_DenNgay_t11))
                    and v.NGAYRUTKN between v_TuNgay_t11 and v_DenNgay_t11
                    ;
                 v_table(item.STT).COLUMN_9:=vCount1;     
                 --Cột 10 tổng cộng
                   v_table(item.STT).COLUMN_10:=(NVL(v_table(item.STT).COLUMN_8,0)+NVL(v_table(item.STT).COLUMN_9,0));  
                   --Cột 11 tổng cộng
                   v_table(item.STT).COLUMN_11:=(NVL(v_table(item.STT).COLUMN_7,0)+NVL(v_table(item.STT).COLUMN_10,0));  

                   --Cột 12 Tổng số - Còn lại
                   v_table(item.STT).COLUMN_12:= NVL(v_table(item.STT).COLUMN_4,0) - NVL(v_table(item.STT).COLUMN_11,0);
                   --Cột 13 Tỷ lệ giải quyết (%)
                   IF(NVL(v_table(item.STT).COLUMN_4,0)>0)THEN
                    v_table(item.STT).COLUMN_13:=TRUNC((NVL(v_table(item.STT).COLUMN_11,0)/v_table(item.STT).COLUMN_4)*100,2);
                   ELSE
                    v_table(item.STT).COLUMN_13:=0;
                   END IF;
            -------
           END LOOP;
        --------
        FOR item_loaian IN (
           SELECT JM.* FROM TABLE(v_table) JM ORDER BY JM.Loaian
           )
         LOOP
         -- Lấy ra tên loại án
         select  DECODE(item_loaian.Loaian,1,'Hình sự',2,'Dân sự',3,'HNGD',4,'KDTM',5,'Lao động',6,'Hành chính') into v_TenLoaian from dual;

         DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr> 
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding:5px;">'||item_loaian.stt||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||v_TenLoaian||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_1||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_2||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_3||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_4||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_5||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_6||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_7||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_8||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_9||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_10||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_11||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_12||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||rtrim(to_char(item_loaian.COLUMN_13, 'FM90.99'), '.')||'</td>
            </tr>
       ');
      END LOOP;  
       ---in tong cong 
      FOR item_ld IN (
                     SELECT SUM(JM.COLUMN_1) COLUMN_1,SUM(JM.COLUMN_2) COLUMN_2,SUM(JM.COLUMN_3) COLUMN_3,SUM(JM.COLUMN_4) COLUMN_4,
                     SUM(JM.COLUMN_5) COLUMN_5,SUM(JM.COLUMN_6) COLUMN_6,SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_8) COLUMN_8,
                     SUM(JM.COLUMN_9) COLUMN_9,SUM(JM.COLUMN_10) COLUMN_10,SUM(JM.COLUMN_11) COLUMN_11,SUM(JM.COLUMN_12) COLUMN_12
                     ,SUM(JM.COLUMN_13) COLUMN_13 ,SUM(JM.COLUMN_14) COLUMN_14 ,SUM(JM.COLUMN_15) COLUMN_15 
                     ,SUM(JM.COLUMN_16) COLUMN_16,SUM(JM.COLUMN_17) COLUMN_17,SUM(JM.COLUMN_18) COLUMN_18
                     ,SUM(JM.COLUMN_19) COLUMN_19,SUM(JM.COLUMN_20) COLUMN_20,SUM(JM.COLUMN_21) COLUMN_21,SUM(JM.COLUMN_22) COLUMN_22,SUM(JM.COLUMN_23) COLUMN_23
                     FROM TABLE(v_table) JM
                )
      LOOP
                  --Cột 13 Tỷ lệ giải quyết (%)
                   IF(NVL(item_ld.COLUMN_4,0)>0)THEN
                    vCOLUMN_13total:=TRUNC((NVL(item_ld.COLUMN_11,0)/item_ld.COLUMN_4)*100,2);
                   ELSE
                   vCOLUMN_13total:=0;
                   END IF;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding:5px;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">Tổng</td>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_1||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_2||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_3||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_4||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_5||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_6||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_7||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_8||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_9||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_10||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_11||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_12||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||rtrim(to_char(vCOLUMN_13total, 'FM999999999999990.99'), '.')||'</th>
                </tr>
       ');
      END LOOP;
     --------
     DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
         <tr>
               <td colspan="10"></td>
                <td colspan="5" style="text-align: center;height:17pt"><i>'||REPLACE(REPLACE(V_HANHCHINH_NAME,'thành phố','TP.'),'tỉnh','')||', ngày '||TO_CHAR(sysdate, 'DD')||' tháng '||to_char(EXTRACT(month FROM sysdate))||' năm '||to_char(extract(year from sysdate))||'</i></td>
            </tr>
            <tr>
                <td colspan="10"></td>
                <th colspan="5" style="text-align: center; height: 90pt; vertical-align: top;">NGƯỜI BÁO CÁO</th>
            </tr>
                <tr>
               <td colspan="10"></td>
                <th colspan="5" style="text-align: center;vertical-align: top;">'||V_CANBO_TK_NAME||'</th>
            </tr>
    ');  
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <tr style="height: 0px;">
                <td style="width: 90px"></td>
                <td style="width: 120px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
            </tr>
   </table>
    ');  
 --------------------------------
      OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GDTTTT_VUAN_SEARCH_BC19;

FUNCTION GDTTTT_VUAN_SEARCH_BC20
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR
IS 
    V_CURSOR sys_refcursor;
    v_table T_BC_VGDKT_20; V_EXPORT_TEXT CLOB; v_dem NUMBER:=0;
    vCount number; vCount1 number; vCount2 number; vtoaan_id number;V_HANHCHINH_NAME NVARCHAR2(250 CHAR);
    v_DenNgay date; v_TuNgay date;V_CANBO_TK_NAME VARCHAR2(255);V_LANHDAO_TK_NAME VARCHAR2(255);
    v_TenPhongban varchar2(100);v_TenLoaian  varchar2(100);v_TenToaAn   varchar2(100);vCOLUMN_13total number;
    v_TenLoaian1  varchar2(100);
BEGIN
    SELECT DECODE(vTuNgay,null,null,to_date(to_char(vTuNgay,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')) into v_TuNgay from dual;
    SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into v_DenNgay from dual;
    SELECT REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),ta.id INTO v_TenToaAn,vtoaan_id FROM DM_TOAAN TA WHERE TA.ID=vToaAnID;
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
     v_table := T_BC_VGDKT_20();

     SELECT HC.TEN INTO V_HANHCHINH_NAME FROM DM_HANHCHINH HC 
     WHERE EXISTS(SELECT 'X' FROM DM_TOAAN TA WHERE TA.ID=vToaAnID AND TA.HANHCHINHID=HC.ID);

     -- lay ra ten phong ban
     if (vPhongBanID = 14)then
        v_TenPhongban := 'I';
     elsif (vPhongBanID = 15)then
        v_TenPhongban := 'II';
     elsif (vPhongBanID = 16)then
        v_TenPhongban := 'III';
     end if;

     if (vPhongBanID = 14)then
        v_TenLoaian := 'HÌNH SỰ';
        v_TenLoaian1 := 'HÀNH CHÍNH';
     elsif (vPhongBanID = 15)then
        v_TenLoaian := 'DÂN SỰ';
        v_TenLoaian1 := 'KDTM';
     elsif (vPhongBanID = 16)then
        v_TenLoaian := 'HN và GD';
        v_TenLoaian1 := 'LD';
     end if;

     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
   <table cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <td style="text-align: center; vertical-align: middle; font-size: 12pt;" colspan ="4">
                    <p style="margin:3px 3px 3px 3px">TÒA ÁN NHÂN DÂN CẤP CAO</p>
                </td>
                <td colspan="2"></td>
                <th style="text-align: center; vertical-align: middle; font-size: 12pt;" colspan="8">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; font-size: 12pt;" colspan ="4">
                <p style="margin:3px 3px 3px 3px"> '||v_TenToaAn||'</p></td>
                <td colspan="2"></td>
                <th style="text-align: center; vertical-align: middle; font-size: 12pt;" colspan="8"><span>Độc lập - Tự do - Hạnh phúc</span></th>



            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; font-size: 12pt;" colspan ="4">
                <p style="margin:3px 3px 3px 3px"><b>PHÒNG GIÁM ĐỐC KIỂM TRA '|| v_TenPhongban ||'</b></p>
                </td>
                <td colspan="2"></td>
                <td colspan="8"></td>
            </tr>
            <tr style="height: 0px;">
                <td></td>
                <td></td>
                <td colspan="12"></td>
            </tr>


            <tr>
                <td colspan="14" style="text-align: center; font-weight: bold;font-size: 15pt;">BÁO CÁO KẾT QUẢ GIẢI QUYẾT CỦA THẨM TRA VIÊN</td>
            </tr>
            <tr>
                <td colspan="14" style="text-align: center; font-weight: bold;font-size: 13pt;">Về công tác giải quyết đơn và xét xử giám đốc thẩm, tái thẩm</td>
            </tr>
            <tr>
                <td colspan="14" style="text-align: center; font-style: italic;font-size: 12pt;">(Tính Từ ngày '||TO_CHAR(vTuNgay,'dd/MM/yyyy')||' - Đến ngày '||TO_CHAR(vDenNgay,'dd/MM/yyyy')||')</td>
            </tr>
           <tr style="text-align: center;">
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">TT</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">THẨM TRA VIÊN</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 35px;" colspan="4">'||v_TenLoaian ||'</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 35px;" colspan="4">'||v_TenLoaian1||'</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Loại án khác</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tổng</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Thừa thiếu</th>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Công việc khác</td>

            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 35px;">TLĐ</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">KN</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Xóa TL</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Thư ký GĐT/TT</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">TLĐ</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">KN</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Xóa TL</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Thư ký GĐT/TT</td>

            </tr>
           ');


        SELECT R_BC_VGDKT_20(row_number() over (order by v.thutu),v.ID,v.Hoten,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
                    ) 
                BULK COLLECT INTO v_table
                from (select t.Hoten,t.thutu,t.ID from (
                                    Select c.ID, c.Hoten, 1 HieuLuc, decode (d.ten,'Trưởng phòng',1,'Phó Trưởng phòng',2,3) thutu
                                        From DM_CANBO c
                                         inner join (select i.ID,i.TEN from DM_DATAITEM i 
                                                      where i.GROUPID=12 and i.MA in ('TTV','TTVCC','TTVC','TK1','TK','TKVC','C027','C010','C008','C009')
                                                    ) d1 on d1.ID=c.CHUCDANHID  
                                         left join (select c.ID, c.TEN from DM_DATAITEM c 
                                                  where c.GROUPID=13  and c.Ma in ('VT', 'PVT','041','042')
                                                ) d on d.ID=c.CHUCVUID    
                                        Where c.TOAANID=vToaAnID  and c.Phongbanid=vPhongBanID and c.HieuLuc=1) t 
                                        order by t.thutu) v;

                --from DM_CANBO c where c.TOAANID=vToaAnID and c.PhongBanID = vPhongBanID and c.HieuLuc=1 group by c.loaian;
      --------------
      FOR item IN (
            SELECT T.STT, T.Hoten,T.ID FROM  TABLE(v_table) T
            )
           LOOP
              --Cot 1 TLD by loai an; phong 1(14) - HS; phong 2(15) án Dan su; phong 3 - HNGD
               Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS  NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                        Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID=vPhongBanID 
                        And v.LOAIAN= decode(vPhongBanID,14,1,15,2,16,3)
                        And v.GQD_LOAIKETQUA = 0
                        And v.THAMTRAVIENID = item.ID
                        And (VA.GQD_NGACVS between v_TuNgay And v_DenNgay) 
                        ;
                   v_table(item.STT).COLUMN_1:=vCount1;    
              --Cot 2 KN by loai an; phong 1(14) - HS; phong 2(15) án Dan su; phong 3 - HNGD
              Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS  NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                        Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID=vPhongBanID 
                        And v.LOAIAN= decode(vPhongBanID,14,1,15,2,16,3)
                        And v.GQD_LOAIKETQUA = 1 
                        And v.THAMTRAVIENID = item.ID
                        And (VA.GQD_NGACVS between v_TuNgay And v_DenNgay) 
                    ;
                    v_table(item.STT).COLUMN_2:=vCount1;  
             --Cot 3 Xêp đơn by loai an; phong 1(14) - HS; phong 2(15) án Dan su; phong 3 - HNGD
            Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                             LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS  NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                        Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID=vPhongBanID 
                        And v.LOAIAN= decode(vPhongBanID,14,1,15,2,16,3)
                        And v.GQD_LOAIKETQUA = 2 
                        And v.THAMTRAVIENID = item.ID
                        And (VA.GQD_NGACVS between v_TuNgay And v_DenNgay) 
                    ;
                 v_table(item.STT).COLUMN_3:=vCount1;

                  --Cột 4 TTV được giao giải quyet  án DS
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                        Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID =vPhongBanID 
                         And v.LOAIAN= decode(vPhongBanID,14,1,15,2,16,3)
                        And ((NVL(v.XXGDT_THAMTRAVIENID,0)>0 and v.XXGDT_THAMTRAVIENID = item.ID)
                             Or (NVL(v.XXGDT_THAMTRAVIENID,0)=0 and v.THAMTRAVIENID = item.ID))
                        And v.TrangThaiId = 15
                        And NVL(v.XXGDTTT_ISKETQUA,0)>0
                        And (v.XXGDTTT_NGAYQD is not null and (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') !='01/01/0001') 
                        And (v.XXGDTTT_NGAYQD between v_TuNgay and v_DenNgay)) ;

                 v_table(item.STT).COLUMN_4:=vCount1;          


                 --Cot 5 TLD by loai an theo phong 1(14) - 6-HC; phong 2(15) án 4-KDTM; phong 3 - 5-LD
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                             LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS  NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                        Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID=vPhongBanID 
                        And v.LOAIAN= decode(vPhongBanID,14,6,15,4,16,5)
                        And v.GQD_LOAIKETQUA = 0 
                        And v.THAMTRAVIENID = item.ID
                        And (VA.GQD_NGACVS between v_TuNgay And v_DenNgay)  
                        ;
                 v_table(item.STT).COLUMN_5:= vCount1;  

                --Cot 6 kN by loai an theo phong 1(14) - 6-HC; phong 2(15) án 4-KDTM; phong 3 - 5-LD
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                             LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS  NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                        Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID=vPhongBanID 
                        And v.LOAIAN= decode(vPhongBanID,14,6,15,4,16,5)
                        And v.GQD_LOAIKETQUA = 1 
                        And v.THAMTRAVIENID = item.ID
                        And (VA.GQD_NGACVS between v_TuNgay And v_DenNgay)   
                        ;
                  v_table(item.STT).COLUMN_6:=vCount1;
               --Cot 7 Xep TL by loai an theo phong 1(14) - 6-HC; phong 2(15) án 4-KDTM; phong 3 - 5-LD
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS  NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                        Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID=vPhongBanID 
                        And v.LOAIAN= decode(vPhongBanID,14,6,15,4,16,5)
                        And v.GQD_LOAIKETQUA = 2 
                        And v.THAMTRAVIENID = item.ID
                        And (VA.GQD_NGACVS between v_TuNgay And v_DenNgay)  
                        ;
                v_table(item.STT).COLUMN_7:=vCount1;
                --Cột 8  TTV được giao giải quyet  án KDTM
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                        Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID =vPhongBanID 
                        And v.LOAIAN= decode(vPhongBanID,14,6,15,4,16,5)
                         And ((NVL(v.XXGDT_THAMTRAVIENID,0)>0 and v.XXGDT_THAMTRAVIENID = item.ID)
                             Or (NVL(v.XXGDT_THAMTRAVIENID,0)=0 and v.THAMTRAVIENID = item.ID))
                        And v.TrangThaiId = 15
                        And NVL(v.XXGDTTT_ISKETQUA,0)>0
                        And (v.XXGDTTT_NGAYQD is not null and (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') !='01/01/0001') 
                        And (v.XXGDTTT_NGAYQD between v_TuNgay and v_DenNgay)) ;

                 v_table(item.STT).COLUMN_8:=vCount1; 

                ---Cot 9 Loai án khác không thuộc phòng ban đang công tác
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS  NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                        Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID !=vPhongBanID 
                        And v.GQD_LOAIKETQUA is not null
                        And v.THAMTRAVIENID = item.ID
                        And (VA.GQD_NGACVS between v_TuNgay And v_DenNgay)   
                        ;
                v_table(item.STT).COLUMN_9:=vCount1;

            -------
           END LOOP;
        --------
        FOR item_TTV IN (
           SELECT JM.* FROM TABLE(v_table) JM ORDER BY JM.STT
           )
         LOOP
         -- Lấy ra tên loại án
--         select  DECODE(item_loaian.Loaian,1,'Hình sự',2,'Dân sự',3,'HNGD',4,'KDTM',5,'Lao động',6,'Hành chính') into v_TenLoaian from dual;

         DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <tr> 
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding:5px;">'||item_TTV.stt||'</td>
                <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;">'||item_TTV.HOTEN||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_TTV.COLUMN_1||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_TTV.COLUMN_2||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_TTV.COLUMN_3||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_TTV.COLUMN_4||'</td>
                 <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_TTV.COLUMN_5||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_TTV.COLUMN_6||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_TTV.COLUMN_7||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_TTV.COLUMN_8||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_TTV.COLUMN_9||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
              </tr>
       ');
      END LOOP;  
       ---in tong cong 
      FOR item_ld IN (
                     SELECT SUM(JM.COLUMN_1) COLUMN_1,SUM(JM.COLUMN_2) COLUMN_2,SUM(JM.COLUMN_3) COLUMN_3,SUM(JM.COLUMN_4) COLUMN_4,
                     SUM(JM.COLUMN_5) COLUMN_5,SUM(JM.COLUMN_6) COLUMN_6,SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_8) COLUMN_8,
                     SUM(JM.COLUMN_9) COLUMN_9
                     FROM TABLE(v_table) JM
                )
      LOOP

        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
         <tr>

                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;" colspan="2">Tổng</td>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_1||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_2||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_3||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_4||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_5||'</th>

                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_6||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_7||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_8||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_9||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></th>
                </tr>
       ');
      END LOOP;
     --------

    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
         <tr>
               <td colspan="9"></td>
                <td colspan="5" style="text-align: center;height:17pt"><i>'||REPLACE(REPLACE(V_HANHCHINH_NAME,'thành phố','TP.'),'tỉnh','')||', ngày '||TO_CHAR(sysdate, 'DD')||' tháng '||to_char(EXTRACT(month FROM sysdate))||' năm '||to_char(extract(year from sysdate))||'</i></td>
            </tr>
            <tr>
                <td colspan="9"></td>
                <th colspan="5" style="text-align: center; height: 90pt; vertical-align: top;">NGƯỜI BÁO CÁO</th>
            </tr>
                <tr>
               <td colspan="9"></td>
                <th colspan="5" style="text-align: center;vertical-align: top;">'||V_CANBO_TK_NAME||'</th>
            </tr>
    ');  
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
         <tr style="height: 0px;">
                <td style="width: 60px"></td>
                <td style="width: 180px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 140px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 140px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
            </tr>
   </table>
    ');  
 --------------------------------
      OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GDTTTT_VUAN_SEARCH_BC20;

FUNCTION GDTTTT_VUAN_SEARCH_BC21
( 
    V_CANBO_TK_ID  IN VARCHAR2,
    V_LANHDAO_TK_ID  IN VARCHAR2,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR
IS 

   V_CURSOR sys_refcursor;
    v_table T_BC_VGDKT_20; V_EXPORT_TEXT CLOB; v_dem NUMBER:=0;
    vCount number; vCount1 number; vCount2 number; vtoaan_id number;V_HANHCHINH_NAME NVARCHAR2(250 CHAR);
    v_DenNgay date; v_TuNgay date;V_CANBO_TK_NAME VARCHAR2(255);V_LANHDAO_TK_NAME VARCHAR2(255);
    v_TenPhongban varchar2(100);v_TenLoaian  varchar2(100);v_TenToaAn   varchar2(100);vCOLUMN_13total number;
    v_TenLoaian1  varchar2(100);
BEGIN
    SELECT DECODE(vTuNgay,null,null,to_date(to_char(vTuNgay,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')) into v_TuNgay from dual;
    SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into v_DenNgay from dual;
    SELECT REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),ta.id INTO v_TenToaAn,vtoaan_id FROM DM_TOAAN TA WHERE TA.ID=vToaAnID;
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
     v_table := T_BC_VGDKT_20();

     SELECT HC.TEN INTO V_HANHCHINH_NAME FROM DM_HANHCHINH HC 
     WHERE EXISTS(SELECT 'X' FROM DM_TOAAN TA WHERE TA.ID=vToaAnID AND TA.HANHCHINHID=HC.ID);

     -- lay ra ten phong ban
     if (vPhongBanID = 14)then
        v_TenPhongban := 'I';
     elsif (vPhongBanID = 15)then
        v_TenPhongban := 'II';
     elsif (vPhongBanID = 16)then
        v_TenPhongban := 'III';
     end if;

     if (vPhongBanID = 14)then
        v_TenLoaian := 'HÌNH SỰ';
        v_TenLoaian1 := 'HÀNH CHÍNH';
     elsif (vPhongBanID = 15)then
        v_TenLoaian := 'DÂN SỰ';
        v_TenLoaian1 := 'KDTM';
     elsif (vPhongBanID = 16)then
        v_TenLoaian := 'HN và GD';
        v_TenLoaian1 := 'LD';
     end if;


     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <table cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <td style="text-align: center; vertical-align: middle; font-size: 12pt;" colspan ="2">
                    <p style="margin:3px 3px 3px 3px">TÒA ÁN NHÂN DÂN CẤP CAO</p>
                </td>
                <td></td>
                <th style="text-align: center; vertical-align: middle; font-size: 12pt;" colspan="3">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; font-size: 12pt;" colspan ="2">
                <p style="margin:3px 3px 3px 3px"> '||v_TenToaAn||'</p></td>
                <td></td>
                <th style="text-align: center; vertical-align: middle; font-size: 12pt;" colspan="3"><span>Độc lập - Tự do - Hạnh phúc</span></th>



            </tr>

            <tr style="height: 0px;">

                <td colspan="6"></td>
            </tr>


            <tr>
                <td colspan="6" style="text-align: center; font-weight: bold;font-size: 15pt;">BÁO CÁO SỐ LIỆU ÁN XÉT XỬ GDT,TT; DÂN SỰ, KDTM; CỦA THẨM PHÁN</td>
            </tr>
            <tr>
                <td colspan="6" style="text-align: center; font-weight: bold;font-size: 13pt;">Về công tác giải quyết đơn và xét xử giám đốc thẩm, tái thẩm</td>
            </tr>
            <tr>
                <td colspan="6" style="text-align: center; font-style: italic;font-size: 12pt;">(Thời gian lấy số liệu từ ngày bổ nhiệm đến ngày '||TO_CHAR(vDenNgay,'dd/MM/yyyy')||')</td>
            </tr>

           <tr style="text-align: center;">
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">TT</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">HỌ VÀ TÊN</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 35px;" rowspan="2">THỜI GIAN ĐƯỢC BỔ NHIỆM THẨM PHÁN, CHỨC VỤ</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 35px;" colspan="2">SỐ VỤ, VIỆC GIẢI QUYẾT GĐT</th>
               <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 35px;" rowspan="2">GHI CHÚ</th>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Xét xử Chủ tọa</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Xét xử thành viên</td>

            </tr>
           ');

        SELECT R_BC_VGDKT_20(row_number() over (order by v.thutu),v.ID,v.Hoten,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
                    ) 
                BULK COLLECT INTO v_table
                from (select t.Hoten,t.thutu,t.ID from (
                    Select c.ID, c.Hoten,d.ten,decode(d.Ma,'CA',1, 'PCA',2,3) thutu
                                From DM_CANBO c
                                 inner join (select i.ID,i.TEN from DM_DATAITEM i 
                                              where i.GROUPID=12 and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')
                                            ) d1 on d1.ID=c.CHUCDANHID  
                                 left join (select c.ID, c.TEN,c.Ma from DM_DATAITEM c 
                                          where c.GROUPID=13  and c.Ma in ('CA', 'PCA')
                                        ) d on d.ID=c.CHUCVUID 
                                Where c.TOAANID=TOAANID and c.HieuLuc=1 
                                        and c.ID in (select thamphanid from GDTTT_VUAN
                                            where TOAANID = TOAANID and phongbanid = vPhongBanID and NVL(thamphanid,0)>0 group by thamphanid)
                                )t order by t.thutu)v;
                --from gdttt_vuan v where v.TOAANID=TOAANID and v.PhongBanID = vPhongBanID and v.Loaian !=0 group by v.loaian;
      --------------
      FOR item IN (
            SELECT T.STT, T.Hoten,T.ID FROM  TABLE(v_table) T
            )
           LOOP

                -- cot 1 Tham phan chu toa
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                        Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID =vPhongBanID 
                        And (NVL(v.THAMPHANID,0)=0 and v.THAMPHANID = item.ID)
                        And v.TrangThaiId = 15
                        And NVL(v.XXGDTTT_ISKETQUA,0)>0
                        And (v.XXGDTTT_NGAYQD is not null and (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') !='01/01/0001') 
                        And (v.XXGDTTT_NGAYQD between v_TuNgay and v_DenNgay)) ;

                 v_table(item.STT).COLUMN_8:=vCount1; 

                ---Cot 2 Tham phan thanh VIEN
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS  NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                        Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID !=vPhongBanID 
                        And v.GQD_LOAIKETQUA is not null
                        And v.THAMTRAVIENID = item.ID
                        And (VA.GQD_NGACVS between v_TuNgay And v_DenNgay)   
                        ;
                v_table(item.STT).COLUMN_9:=vCount1;

            -------
           END LOOP;
        --------
        FOR item_TP IN (
           SELECT JM.* FROM TABLE(v_table) JM ORDER BY JM.STT
           )
         LOOP
         DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr> 
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding:5px;">'||item_TP.stt||'</td>
                <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;">'||item_TP.HOTEN||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_TP.COLUMN_1||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_TP.COLUMN_2||'</td>
                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_TP.COLUMN_3||'</td>

                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
              </tr>
       ');
      END LOOP;  


    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
       <tr style="height: 0px;">
                <td style="width: 60px"></td>
                <td style="width: 180px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 140px"></td>

            </tr>
   </table>
    ');  
 --------------------------------
      OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GDTTTT_VUAN_SEARCH_BC21;



END PKG_VGDKT_BAOCAO_VA_CC;

/
