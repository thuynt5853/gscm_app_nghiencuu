--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_BAOCAO
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_BAOCAO" AS
FUNCTION BAOCAO_TH_THULY_GDKT
(
  vToaAnID in VARCHAR2,
  vPhongBanID  in  VARCHAR2,
  vThamphanID  in  VARCHAR2,
  vTuNgay in date,
  vDenNgay in date
)
 RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB; 
    --------------
     V_HOTEN VARCHAR2(150); curr_thamphan_id VARCHAR2(100);
     v_Tongso number;THAMPHANID number;V_LANHDAO varchar2(150):=NULL;dem_ number:=0;v_count number;
     ------------
     v_table_all T_TINHTRANG; v_table T_BC_TP_THULY_GDKT;
     ------------
    LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH  DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER; 
  BEGIN	
    ---lấy vụ trưởng,--432 vụ trưởng
   SELECT count(*) INTO v_count FROM DM_CANBO CB WHERE CB.CHUCVUID=432 AND CB.PHONGBANID=vPhongBanID AND CB.HIEULUC=1;
     if(v_count>0)then
      SELECT CB.HOTEN INTO V_LANHDAO FROM DM_CANBO CB WHERE CB.CHUCVUID=432 AND CB.PHONGBANID=vPhongBanID AND CB.HIEULUC=1;
    end if;
    -----------
     v_table := T_BC_TP_THULY_GDKT(); v_table_all := T_TINHTRANG(); 
    --------------
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
    --------------------------------
    --V_PHONGBANID=1 phòng ban là văn phòng
    FOR item_pb IN (
        Select PB.ID,TENPHONGBAN
        from DM_PHONGBAN pb 
        WHERE ((PB.ID=vPhongBanID AND vPhongBanID IS NOT NULL AND vPhongBanID!='1') OR (vPhongBanID IS NULL OR vPhongBanID='1') )
        AND pb.TOAANID=vToaAnID AND pb.HAUTOCV LIKE 'GĐKT%'
        ORDER BY SUBSTR(pb.TENPHONGBAN,INSTR(pb.TENPHONGBAN,' ',-1)+ 1)
     )
    LOOP
        FOR item_tp IN (
            SELECT V.THAMPHANID,CB.HOTEN FROM GDTTT_VUAN V
            INNER JOIN DM_CANBO CB ON CB.ID=V.THAMPHANID
            WHERE V.TOAANID=vToaAnID AND V.PHONGBANID=item_pb.ID AND V.THAMPHANID!=0 AND V.THAMPHANID IS NOT NULL
            AND ( (V.NGAYTAO>=vTuNgay AND V.NGAYTAO<=vDenNgay and vThamphanID is null) or vThamphanID is not null)
            AND((V.THAMPHANID=vThamphanID AND vThamphanID IS NOT NULL) OR(vThamphanID IS NULL))
            GROUP BY V.THAMPHANID,CB.HOTEN
        )
         LOOP
           ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng v_table_ld
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,item_pb.ID,0,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,vDenNgay,--tt_tungay,tt_denngay
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
    --------------------------------------------------------------------------------------------
          ------------------Mới thụ lý đơn
                SELECT COUNT(*) INTO v_Tongso FROM GDTTT_DON DD 
                WHERE  EXISTS (
                        SELECT 'X' FROM GDTTT_VUAN VA
                         WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID
                         AND VA.NGAYTAO>=vTuNgay AND VA.NGAYTAO<=vDenNgay AND VA.THAMPHANID=item_tp.THAMPHANID
                         and VA.ISVIENTRUONGKN is null
                        AND DD.VUVIECID=VA.ID
                    )
                AND DD.CD_TRANGTHAI =2 
                AND (DD.ISTHULY = 1 or (DD.ISTHULY = 2 and DD.cd_socv ='01012019' and DD.cd_ngaycv = to_date('01/01/2019','dd/mm/yyyy')))
                ;
            --
            v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                        v_Tongso,0,
                        0,0,0,0,0,
                        0,0,0,0,0                       
                        );
           ------------------Mới thụ lý vụ
             SELECT COUNT(*)INTO v_Tongso FROM GDTTT_VUAN VA
             WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
             AND VA.NGAYTAO>=vTuNgay AND VA.NGAYTAO<=vDenNgay
             and VA.ISVIENTRUONGKN is null
             ;
             --
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                        0,v_Tongso,
                        0,0,0,0,0,
                        0,0,0,0,0                       
                        );
         --Đang rút hồ sơ <=>Chưa có hồ sơ và đã có phiếu mượn
         --LOAI:0:Phieu muon/1:Phieu Tra/2:Phieu chuyen/3:Phieu nhan
             Select Count(VA.ID) into v_Tongso From GDTTT_VUAN VA
             Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
             AND NOT EXISTS (select ID from GDTTT_QUANLYHS where VA.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) 
             AND EXISTS(SELECT id FROM GDTTT_QUANLYHS WHERE VA.ID = VUANID and LOAI =0)
             AND (NVL(VA.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND VA.GQD_LOAIKETQUA IS NULL)
             AND VA.NGAYTAO>vTuNgay AND VA.NGAYTAO<vDenNgay
             AND VA.ISVIENTRUONGKN is null;
           --
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                        0,0,
                        v_Tongso,0,0,0,0,
                        0,0,0,0,0                       
                        );
            --Trạng thái hồ sơ,Có hồ sơ        
           Select Count(VA.ID) into v_Tongso From GDTTT_VUAN VA
           Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
           AND EXISTS (select ID from GDTTT_QUANLYHS HS where VA.ID =  HS.VUANID and (  HS.NGAYNHAN is not null or  HS.LOAI = 3 )) 
           AND VA.NGAYTAO>vTuNgay AND VA.NGAYTAO<vDenNgay
           AND VA.ISVIENTRUONGKN is null 
           ;
           --
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                        0,0,
                        0,v_Tongso,0,0,0,
                        0,0,0,0,0                       
                        );
         --Trình lãnh đạo vụ---- 
         SELECT COUNT(VA.ID) INTO v_Tongso FROM GDTTT_VUAN VA 
          Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
          AND (NVL(VA.TRANGTHAIID,0) NOT IN (13,14,15,16,18)  AND VA.GQD_LOAIKETQUA IS NULL)
          AND VA.NGAYTAO>vTuNgay AND VA.NGAYTAO<vDenNgay
         AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE VA.ID=PA.VUANID AND PA.TINHTRANGID IN (5,101,4,100))
         ;
          --
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                        0,0,
                        0,0,v_Tongso,0,0,
                        0,0,0,0,0                       
                        );
           --Trình TP---- 
         SELECT COUNT(VA.ID) INTO v_Tongso FROM GDTTT_VUAN VA 
          Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
          AND (NVL(VA.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND VA.GQD_LOAIKETQUA IS NULL)
          AND VA.NGAYTAO>vTuNgay AND VA.NGAYTAO<vDenNgay
          AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE VA.ID=PA.VUANID AND PA.TINHTRANGID=6)
         ;
          --
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                        0,0,
                        0,0,0,v_Tongso,0,
                        0,0,0,0,0                       
                        );
         --Ý kiến TP---- 
         SELECT COUNT(VA.ID) INTO v_Tongso FROM GDTTT_VUAN VA 
          Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
          AND (NVL(VA.TRANGTHAIID,0) NOT IN (13,14,15,16,18)  AND VA.GQD_LOAIKETQUA IS NULL)
          AND VA.NGAYTAO>vTuNgay AND VA.NGAYTAO<vDenNgay
          AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE VA.ID=PA.VUANID AND PA.TINHTRANGID=6 AND PA.NGAYTRA IS NOT NULL)
         ;
          --
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                        0,0,
                        0,0,0,0,v_Tongso,
                        0,0,0,0,0                       
                        );                
          --Xác minh, họp tổ---- 
         SELECT COUNT(VA.ID) INTO v_Tongso FROM GDTTT_VUAN VA 
          Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
          AND (NVL(VA.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND VA.GQD_LOAIKETQUA IS NULL)
          AND VA.NGAYTAO>vTuNgay AND VA.NGAYTAO<vDenNgay
          AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE VA.ID=PA.VUANID AND instr(',7,8,9,10,17,',','||PA.TINHTRANGID||',')>0)
         ;
          --
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                        0,0,
                        0,0,0,0,0,
                        v_Tongso,0,0,0,0                       
                        );           
           --Trình Dự thảo TLĐ, KN---- 
         SELECT COUNT(VA.ID) INTO v_Tongso FROM GDTTT_VUAN VA 
          Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
          AND (NVL(VA.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND VA.GQD_LOAIKETQUA IS NULL)
          AND VA.NGAYTAO>vTuNgay AND VA.NGAYTAO<vDenNgay
          AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE VA.ID=PA.VUANID AND PA.TINHTRANGID IN (11,12) )
         ;
          --
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                       0,0,
                        0,0,0,0,0,
                        0,v_Tongso,0,0,0                         
                        );        
          --Phát hành TLĐ, KN---- 
          SELECT COUNT(VA.ID) INTO v_Tongso FROM GDTTT_VUAN VA 
          Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
          AND (VA.gqd_loaiketqua = 0 OR VA.gqd_loaiketqua = 1)
          AND VA.NGAYTAO>vTuNgay AND VA.NGAYTAO<vDenNgay
          AND VA.ISVIENTRUONGKN is null
          ;
          --
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                       0,0,
                        0,0,0,0,0,
                        0,0,v_Tongso,0,0                         
                        );   
         --Giải quyết khác---- 
          SELECT COUNT(VA.ID) INTO v_Tongso FROM GDTTT_VUAN VA 
          Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
          AND VA.gqd_loaiketqua = 3
          AND VA.NGAYTAO>vTuNgay AND VA.NGAYTAO<vDenNgay
          ;
          --
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                       0,0,
                        0,0,0,0,0,
                        0,0,0,v_Tongso,0                         
                        );                      
          ----------------------------              
         END LOOP;
    END LOOP;   
    --------------------------------------------------
    --------Tạo dữ liệu -------------------------------
    FOR item_pb IN 
    (
       SELECT PAA.PHONGBANID,PAA.TEN_PHONGBAN,COUNT(PAA.PHONGBANID) OVER() TONG_PB,
         SUBSTR(PAA.TEN_PHONGBAN,INSTR(PAA.TEN_PHONGBAN,' ',-1)+ 1)TEN_PHONGBAN_SUB FROM (
             SELECT PA.PHONGBANID,PA.TEN_PHONGBAN
              FROM TABLE(v_table) PA
              GROUP BY PA.PHONGBANID,PA.TEN_PHONGBAN
              ORDER BY SUBSTR(PA.TEN_PHONGBAN,INSTR(PA.TEN_PHONGBAN,' ',-1)+ 1)  
         )PAA
    )
    LOOP
    -------------- 
      dem_:=dem_+1;
        --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
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
      -------------------
    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <td style="text-align: center; vertical-align: middle; height: 25px; font-size: 12pt">TÒA ÁN NHÂN DÂN TỐI CAO
                </td>
                <th style="text-align: center; vertical-align: middle; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px">
                            <th style="text-align: right; padding-right: 2px;"><span>VỤ GIÁ</span></th>
                            <th style="border-bottom: 1px solid #000000;">
                                <span>M ĐỐC KIỂ</span>
                            </th>
                            <th style="text-align: left; padding-left: 2px">M TRA '||item_pb.TEN_PHONGBAN_SUB||'</th>
                        </tr>
                    </table>
                </td>
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
            <tr style="padding-top: 3px; font-size: 12pt;">
                <td></td>
                <td></td>
            </tr>
            <tr style="font-style: italic; font-size: 12pt;">
                <td></td>
                <td style="font-size: 13pt"><span style="color: #ffffff;">...............</span>Hà Nội, ngày <span>'||to_char(sysdate,'dd')||'</span> tháng <span>'||to_char(sysdate,'MM')||'</span> năm <span>'||to_char(sysdate,'yyyy')||'</span></td>
            </tr>
            <tr style="font-style: italic; font-size: 12pt;">
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 450pt;"></td>
                <td style="width: 450pt"></td>
            </tr>
        </table>
        <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 12pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="13" style="height: 0pt;"></td>
            </tr>
            <tr>
                <td colspan="13" style="line-height: 110%; font-size: 14pt"><b>TỔNG HỢP</b>
                    <br />
                    <b>SỐ LIỆU THỤ LÝ, GIẢI QUYẾT ĐƠN ĐỀ NGHỊ GIÁM ĐỐC THẨM, TÁI THẨM</b>
                    <br />
                    <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(vTuNgay,'dd/MM/yyyy')||' đến '||to_char(vDenNgay,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            <tr>
                <td colspan="13" style="height: 5pt;"></td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-size: 10pt">STT</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Họ và tên
                    <br />
                    Thẩm phán TANDTC</td>
                <td colspan="10" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 20pt;">Số đơn được phân công giải quyết</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 70pt;">Nhận đơn</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đang rút HS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nhận HS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Trình LĐ vụ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Trình TP</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ý kiến TP</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Xác minh/<br />
                    họp tổ/...</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Dự thảo TLĐ, KN</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phát hành, TLĐ, KN</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Giải quyết khác</td>
            </tr>
            <tr style="font-style: italic; font-size: 10px; color: #808080">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">1</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">2</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">3</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">4</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">5</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">6</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">7</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">8</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">9</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">10</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">11</td>
            </tr>
                ');
            FOR items IN 
            (
              SELECT ROW_NUMBER() OVER (ORDER BY PPA.TEN_TP)STT,PPA.* FROM (
                  SELECT SUBSTR(PA.THAMPHAN_TEN,INSTR(PA.THAMPHAN_TEN,' ',-1)+ 1)TEN_TP,PA.ThamPhan_ID,PA.THAMPHAN_TEN,SUM(PA.COLUMN_1_DON)COLUMN_1_DON,SUM(PA.COLUMN_1_VU)COLUMN_1_VU,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
                  ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
                  ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11
                  FROM TABLE(v_table) PA WHERE PA.PHONGBANID=item_pb.PHONGBANID AND((PA.ThamPhan_ID=vThamphanID AND vThamphanID IS NOT NULL) OR(vThamphanID IS NULL))
                  GROUP BY PA.ThamPhan_ID,PA.THAMPHAN_TEN,SUBSTR(PA.THAMPHAN_TEN,INSTR(PA.THAMPHAN_TEN,' ',-1)+ 1)
              )PPA
            )
            LOOP
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <tr style="font-size:11pt;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.STT||'</td>
                    <th style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;margin-left:8pt;">'||items.THAMPHAN_TEN||'</th>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;margin-left:2pt;">'||items.COLUMN_1_DON||' ('||items.COLUMN_1_VU||' vụ)</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_2||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_3||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_4||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_5||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_6||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_7||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_8||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_9||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_10||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                </tr> 
                ');
          END LOOP;
          -- Tổng 
          FOR items IN 
            (
              SELECT SUM(PA.COLUMN_1_DON)COLUMN_1_DON,SUM(PA.COLUMN_1_VU)COLUMN_1_VU,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
              ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
              ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11
              FROM TABLE(v_table) PA WHERE PA.PHONGBANID=item_pb.PHONGBANID AND((PA.ThamPhan_ID=vThamphanID AND vThamphanID IS NOT NULL) OR(vThamphanID IS NULL))
            )
            LOOP
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <tr style="font-size:11pt;font-weight:bold;">
                    <th colspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-size:13pt;">Tổng</th>                    
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;margin-left:2pt;">'||items.COLUMN_1_DON||' ('||items.COLUMN_1_VU||'vụ)</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_2||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_3||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_4||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_5||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_6||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_7||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_8||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_9||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_10||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                </tr> 
                ');
          END LOOP;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <tr style="height: 10pt;">
                <td style="width: 20pt"></td>
                <td style="width: 160pt"></td>
                <td style="width: 120pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 120pt"></td>
            </tr>
        </table>
                     ');
            -----------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="vertical-align: top;"></td>
                <td>
                    <p>
                        <strong>Vụ trưởng</strong>
                        <br />
                        <i style="font-size: 13pt;">(Ký và ghi rõ họ tên)</i>
                    </p>
                   <br /><br /><br /><br />
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                   <p><strong>'||V_LANHDAO||'</strong></p>
                </td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 450pt"></td>
                <td style="width: 450pt;"></td>
            </tr>
        </table>
            ');
            IF(dem_<item_pb.TONG_PB)  THEN --ngắt trang truyển sang trang mới
               DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <span style="font-size:12.0pt;font-family:''Times New Roman'',serif;mso-fareast-font-family:
                ''Times New Roman'';mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                mso-fareast-language:EN-US;mso-bidi-language:AR-SA">
                <br clear=all style="mso-special-character:line-break;page-break-before:always">
                </span>
                ');
            END IF;
   END LOOP;
   ----------------------
        OPEN V_CURSOR FOR
--        SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END BAOCAO_TH_THULY_GDKT;
FUNCTION BAOCAO_TH_THULY_TP
(
  vToaAnID in VARCHAR2,
  vThamphanID  in  VARCHAR2,
  vThamphanID_Login  in  VARCHAR2,
  vTuNgay in date,
  vDenNgay in date
)
 RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB; 
    --------------
     V_HOTEN VARCHAR2(150);ma_chucvu varchar2(50); v_table T_BC_TP_THULY; curr_thamphan_id VARCHAR2(100);
     v_Tongso number;id number;hoten varchar2(150);dem_ number:=0;v_table_all T_TINHTRANG;
     ------------
    LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH  DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER; 
  BEGIN	
     v_table := T_BC_TP_THULY(); v_table_all := T_TINHTRANG(); 
    --------------
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
      --------------------------------
    if(vThamphanID_Login is not null)then--vThamphanID_Login thẩm phán khi đăng nhập
     select b.Ma into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphanID_Login;
    end if;
    curr_thamphan_id:=null;
    if(vThamphanID is null) then --thẩm phán khi chon ở drop
           if(ma_chucvu is null)then 
                curr_thamphan_id:= ','||vThamphanID||',';
              elsif(ma_chucvu='PCA' OR ma_chucvu='CA')then  --nếu là thẩm phán phụ trách hoặc phó chánh án
              -------------
              PKG_GDTTT_GET.GET_PHUTRACH_TP_BC(vThamphanID_Login, V_CURSOR); --lấy những thẩm phán được phụ trách
                   LOOP
                        FETCH V_CURSOR 
                        INTO   id,hoten;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         curr_thamphan_id:=curr_thamphan_id||id||',';
                        END LOOP;    
                        CLOSE V_CURSOR;  
                        curr_thamphan_id:=','||curr_thamphan_id;--tạo thành chuỗi các thẩm phán được phụ trách
              -------------          
            ELSE
                curr_thamphan_id:= ','||vThamphanID||',';
            end if;
      else
        curr_thamphan_id:= ','||vThamphanID||',';
    end if;
    --------------------------------
  FOR item_tp IN 
              (  
                SELECT TP.THAMPHANID,TP.hoten FROM (
                    SELECT V.THAMPHANID,cb.hoten FROM GDTTT_VUAN v 
                    INNER JOIN DM_CanBo cb on cb.id=v.THAMPHANID
                    where v.THAMPHANID is not null and  v.THAMPHANID !=0 
                    and cb.hieuluc=1 and cb.toaanid=vToaAnID and cb.CHUCDANHID=486 --Thẩm phán tối cao
                    group by V.THAMPHANID,cb.hoten
                    ORDER BY SUBSTR(cb.HOTEN,INSTR(cb.HOTEN,' ',-1)+ 1)
                  )TP WHERE ((instr(curr_thamphan_id,','||TP.THAMPHANID||',')>0  AND curr_thamphan_id IS NOT NULL) OR curr_thamphan_id IS NULL)
                )
   LOOP
    --for item Loai an
   FOR item IN (
                SELECT TT.LOAIAN_ID,TT.LOAIAN_TEN FROM (
                            SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                            SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                            DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                            FROM (
                                    SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                    PB WHERE PB.Id = item_tp.THAMPHANID
                                 )
                            UNPIVOT --chuyển từ cột thành dòng
                            (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                            )TT WHERE CHECK_LOAIAN=1 
                        )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                       GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 UNION ALL
                            select  LAS.LOAIAN_ID,LAS.LOAIAN_TEN FROM(
                            select V.LOAIAN LOAIAN_ID,DECODE(V.LOAIAN,1,'HÌNH SỰ',2,'DÂN SỰ',3,'HÔN NHÂN VÀ GIA ĐÌNH',4,'KINH DOANH, THƯƠNG MẠI',5,'LAO ĐỘNG',6,'HÀNH CHÍNH')LOAIAN_TEN From GDTTT_VUAN v 
                            where v.THAMPHANID=item_tp.THAMPHANID AND V.LOAIAN IS NOT NULL 
                            AND ((V.NGAYTAO>=vTuNgay AND V.NGAYTAO<=vDenNgay AND vThamphanID IS NULL) OR (vThamphanID IS NOT NULL))
                            group by V.LOAIAN,DECODE(V.LOAIAN,1,'HÌNH SỰ',2,'DÂN SỰ',3,'HÔN NHÂN VÀ GIA ĐÌNH',4,'KINH DOANH, THƯƠNG MẠI',5,'LAO ĐỘNG',6,'HÀNH CHÍNH')
                           )LAS 
               )TT  GROUP BY TT.LOAIAN_ID,TT.LOAIAN_TEN  ORDER BY TT.LOAIAN_ID
          )       

      LOOP     
       ----------------------------------------------------------------------------------------------------
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              item_tp.THAMPHANID,vToaAnID,0,item.LOAIAN_ID,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,vDenNgay,--tt_tungay,tt_denngay
                                              V_CURSOR);
               LOOP --tạo dữ liệu cho bảng lãnh đạo gồm các trạng thái cuối cùng của thẩm phán đó
                    FETCH V_CURSOR 
                    INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                    EXIT WHEN V_CURSOR%NOTFOUND;
                    v_table_all.extend;
                    v_table_all(v_table_all.count) := R_TINHTRANG( LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH);
                    END LOOP;    
                    CLOSE V_CURSOR;  
         ----------------------------------------------------------------------------------------------------
            --Cũ còn lại của năm trước
             Select Count(v.ID) INTO v_Tongso From GDTTT_VUAN v
              --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phí dưới
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                 Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID
                 AND v.THAMPHANID=item_tp.THAMPHANID
                 AND v.NGAYTAO<vTuNgay
                 AND V.ISVIENTRUONGKN is null
                 AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vTuNgay) )  
                 ;
                  --
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            v_Tongso,0,0,0,0,
                            0,0,0,0,0,
                            0,0,0
                            );
              --Mới thụ lý
              Select Count(v.ID) into v_Tongso From GDTTT_VUAN v
              Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID  AND v.THAMPHANID=item_tp.THAMPHANID
              AND v.NGAYTAO>=vTuNgay AND v.NGAYTAO<=vDenNgay
              AND V.ISVIENTRUONGKN is null
              ;
               --
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            0,v_Tongso,0,0,0,
                            0,0,0,0,0,
                            0,0,0
                            );
              --Tổng số
              SELECT SUM(PA.COLUMN_1+PA.COLUMN_2) INTO v_Tongso
              FROM TABLE(v_table) PA WHERE PA.LoaiAn=item.LOAIAN_ID AND PA.ThamPhan_ID=item_tp.THAMPHANID;
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            0,0,v_Tongso,0,0,
                            0,0,0,0,0,
                            0,0,0
                            );    
           --Đã có hồ sơ        
           Select Count(v.ID) into v_Tongso From GDTTT_VUAN v
           Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID AND v.THAMPHANID=item_tp.THAMPHANID 
           AND EXISTS (select ID from GDTTT_QUANLYHS HS where v.ID =  HS.VUANID and (  HS.NGAYNHAN is not null or  HS.LOAI = 3 )) 
           and v.THAMTRAVIENID IS NOT NULL and v.THAMTRAVIENID != 0
           and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID)
           AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay
           and v.gqd_loaiketqua is null
           AND V.ISVIENTRUONGKN is null; 
            --
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            0,0,0,v_Tongso,0,
                            0,0,0,0,0,
                            0,0,0
                            );
          --Chưa có hồ sơ        
           Select Count(v.ID) into v_Tongso From GDTTT_VUAN v
           Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID AND v.THAMPHANID=item_tp.THAMPHANID 
           AND NOT EXISTS (select ID from GDTTT_QUANLYHS HS where v.ID =  HS.VUANID and (  HS.NGAYNHAN is not null or  HS.LOAI = 3 )) 
           and v.THAMTRAVIENID IS NOT NULL and v.THAMTRAVIENID != 0
           and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID)
           AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay
           and v.gqd_loaiketqua is null
           AND V.ISVIENTRUONGKN is null; 
            --
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            0,0,0,0,v_Tongso,
                            0,0,0,0,0,
                            0,0,0
                            ); 
         --Thẩm phán đang nghiên cứu <=> Giải quyết tờ trình,Chưa có ý kiến       
              Select Count(v.ID) into v_Tongso From GDTTT_VUAN v
              Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID AND v.THAMPHANID=item_tp.THAMPHANID 
              and v.GQD_LOAIKETQUA is null
              AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay
              AND V.ISVIENTRUONGKN is null
              AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=6 AND PA.NGAYTRA IS NULL)
              ;
              --
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            0,0,0,0,0,
                            v_Tongso,0,0,0,0,
                            0,0,0
                            );  
          --Thẩm phán đề nghị xác minh
         SELECT COUNT(V.ID) INTO v_Tongso FROM GDTTT_VUAN V 
         WHERE  v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID AND v.THAMPHANID=item_tp.THAMPHANID 
         and v.GQD_LOAIKETQUA is null
         AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay
         AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))
         --and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10)
         AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=10)
         ;
          --
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            0,0,0,0,0,
                            0,v_Tongso,0,0,0,
                            0,0,0
                            );  
          --Thẩm phán đề nghị họp tổ/xin ý kiến lãnh đạo TATC                  
           SELECT COUNT(*) INTO v_Tongso FROM TABLE(v_table_all) PA 
            INNER JOIN GDTTT_VUAN V ON V.ID=PA.VUANID AND v.LOAIAN =item.LOAIAN_ID 
            WHERE instr(',7,8,9,17,',','||PA.TINHTRANGID||',')>0 
            and v.gqd_loaiketqua is null
            AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay
            AND NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)
            AND V.ISVIENTRUONGKN is null;
             --
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            0,0,0,0,0,
                            0,0,v_Tongso,0,0,
                            0,0,0
                            );   
             --Trả lời đơn-đã phát hành---------------------
             Select Count(v.ID) into v_Tongso From GDTTT_VUAN v
             Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID AND v.THAMPHANID=item_tp.THAMPHANID 
             AND v.gqd_loaiketqua = 0 AND V.ISVIENTRUONGKN is null AND v.GDQ_NGAY IS NOT NULL
             AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay 
             AND V.ISVIENTRUONGKN is null
             ;
              --
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            0,0,0,0,0,
                            0,0,0,v_Tongso,0,
                            0,0,0
                            );   
           --Trả lời đơn-chưa phát hành--------------------
             Select Count(v.ID) into v_Tongso From GDTTT_VUAN v
             Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID AND v.THAMPHANID=item_tp.THAMPHANID 
             AND v.gqd_loaiketqua = 0
             AND v.GDQ_NGAY IS NULL AND v.GQD_NGAYPHATHANHCV IS NOT NULL
             AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay 
             AND V.ISVIENTRUONGKN is null
             ;
              --
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            0,0,0,0,0,
                            0,0,0,0,v_Tongso,
                            0,0,0
                            );  
             --Kháng nghị đã phát hành---
            Select Count(v.ID) into v_Tongso From GDTTT_VUAN v
             Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID AND v.THAMPHANID=item_tp.THAMPHANID 
             AND v.gqd_loaiketqua = 1  AND v.GDQ_NGAY IS NOT NULL
             AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay 
             AND V.ISVIENTRUONGKN is null
            ;
              --
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            v_Tongso,0,0
                            );  
             --Kháng nghị-chưa phát hành--------------------
             Select Count(v.ID) into v_Tongso From GDTTT_VUAN v
             Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID AND v.THAMPHANID=item_tp.THAMPHANID 
             AND v.gqd_loaiketqua = 1 
             AND v.GDQ_NGAY IS NULL AND v.GQD_NGAYPHATHANHCV IS NOT NULL
             AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay 
             AND V.ISVIENTRUONGKN is null
             ;
            --
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,v_Tongso,0
                            );   
          --Xếp đơn or giải quyết khác                
           Select Count(v.ID) into v_Tongso From GDTTT_VUAN v
             Where v.TOAANID=vToaAnID And v.LOAIAN =item.LOAIAN_ID AND v.THAMPHANID=item_tp.THAMPHANID 
             and  (v.gqd_loaiketqua = 2 or v.gqd_loaiketqua = 3) AND V.ISVIENTRUONGKN is null
             AND v.NGAYTAO>vTuNgay AND v.NGAYTAO<vDenNgay    
             ;
             --
                 v_table.extend;--chuyen vao bang dinh nghia
                 v_table(v_table.count) := R_BC_TP_THULY(
                            item.LOAIAN_ID,item.LOAIAN_TEN,item_tp.THAMPHANID,item_tp.HOTEN,
                            0,0,0,0,0,
                            0,0,0,0,0,
                            0,0,v_Tongso
                            );    
    END LOOP;     
    ----------
  END LOOP;   
    ----------------------------------------
    ----------------------------------------
    ----Tạo dữ liệu cho báo cáo của Thẩm phán
    FOR item_tp IN 
    (
       SELECT PAA.ThamPhan_ID,PAA.ThamPhan_TEN,COUNT(PAA.ThamPhan_ID) OVER() TONG_TP FROM (
             SELECT PA.ThamPhan_ID,PA.ThamPhan_TEN
              FROM TABLE(v_table) PA
              GROUP BY PA.ThamPhan_ID,PA.ThamPhan_TEN
              ORDER BY SUBSTR(PA.ThamPhan_TEN,INSTR(PA.ThamPhan_TEN,' ',-1)+ 1)  
         )PAA
    )
    LOOP
      dem_:=dem_+1;
        --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
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
      -------------------
    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr style="text-align: center;">
                    <td style="text-align: center; vertical-align: middle; height: 25px; font-size: 12pt">
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px">
                                <th style="text-align: right; padding-right: 2px;"><span>TÒA ÁN</span></th>
                                <th style="border-bottom: 1px solid #000000;">
                                    <span>NHÂN DÂN</span>
                                </th>
                                <th style="text-align: left; padding-left: 2px">TỐI CAO</th>
                            </tr>
                        </table>
                    </td>
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
                <tr style="padding-top: 3px; font-size: 12pt;">
                    <td></td>
                    <td></td>
                </tr>
                <tr style="font-style: italic; font-size: 12pt;">
                    <td></td>
                    <td style="font-size: 13pt"><span style="color: #ffffff;">...............</span>Hà Nội, ngày <span>'||to_char(sysdate,'dd')||'</span> tháng <span>'||to_char(sysdate,'MM')||'</span> năm <span>'||to_char(sysdate,'yyyy')||'</span></td>
                </tr>
                <tr style="font-style: italic; font-size: 12pt;">
                    <td></td>
                    <td></td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 450pt;"></td>
                    <td style="width: 450pt"></td>
                </tr>
            </table>
            <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="15" style="height: 0pt;"></td>
            </tr>
            <tr>
                <td colspan="15" style="line-height: 110%; font-size: 14pt"><b>TỔNG HỢP</b>
                    <br />
                    <b>SỐ LIỆU THỤ LÝ, GIẢI QUYẾT ĐƠN ĐỀ NGHỊ GIÁM ĐỐC THẨM, TÁI THẨM</b>
                    <br />
                    <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(vTuNgay,'dd/MM/yyyy')||' đến '||to_char(vDenNgay,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            <tr>
                <td colspan="15" style="height: 5pt;"></td>
            </tr>
            <tr>
                <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-size: 10pt;">STT</td>
                <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Loại án</td>
                <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số đơn được phân công giải quyết</td>
                <td colspan="5" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đang giải quyết</td>
                <td colspan="5" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết xong</td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Cũ chuyển sang</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tổng số</td>
                <td colspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Chưa có Tờ trình của vụ GĐKT</td>
                <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã có Tờ trình của vụ GĐKT</td>
                <td colspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Trả lời đơn</td>
                <td colspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Kháng nghị (*)</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Xếp đơn/Giải quyết khác</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã có HS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Chưa có HS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm phán đang nghiên cứu</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm phán đề nghị xác minh</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm phán đề nghị họp tổ/xin ý kiến lãnh đạo TATC</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã phát hành</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Chưa phát hành</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã phát hành</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Chưa phát hành</td>
            </tr>
            <tr style="font-style: italic; font-size: 10px; color: #808080">
                 <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">1</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">2</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">3</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">4</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">5</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">6</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">7</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">8</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">9</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">10</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">11</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">12</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">13</td>
            </tr>
                ');
            FOR items IN 
            (
             SELECT ROW_NUMBER() OVER (ORDER BY PPA.LoaiAn)STT,PPA.* FROM(
                  SELECT PA.LoaiAn,PA.TenLoaiAn,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
                  ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
                  ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13
                  FROM TABLE(v_table) PA WHERE PA.ThamPhan_ID=item_tp.ThamPhan_ID
                  GROUP BY PA.LoaiAn,PA.TenLoaiAn
              )PPA
            )
            LOOP
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <tr style="font-size:10pt;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.STT||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.TenLoaiAn||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_1||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_2||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_3||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_4||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_5||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_6||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_7||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_8||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_9||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_10||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_11||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_12||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_13||'</td>
                </tr> 
                ');
          END LOOP;
          -- Tổng 
          FOR items IN 
            (
              SELECT SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
              ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
              ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13
              FROM TABLE(v_table) PA WHERE PA.ThamPhan_ID=item_tp.ThamPhan_ID
            )
            LOOP
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <tr style="font-size:11pt;font-weight:bold;">
                    <th colspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-size:13pt;">Tổng</th>                    
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_1||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_2||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_3||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_4||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_5||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_6||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_7||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_8||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_9||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_10||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_11||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_12||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||items.COLUMN_13||'</td>
                </tr> 
                ');
          END LOOP;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <tr style="height: 10pt;">
                <td style="width: 20pt"></td>
                <td style="width: 160pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
            </tr>
        </table>
                     ');
            -----------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                  <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="vertical-align: top;">
                        <p style="font-size: 12pt; text-align: left; line-height: 105%;">
                            <i>(*): Cột này do Phó Chánh án cung cấp số liệu</i>
                        </p>
                    </td>
                    <td>
                        <p>
                            <strong>Thẩm phán</strong>
                            <br />
                            <i style="font-size: 13pt;">(Ký và ghi rõ họ tên)</i>
                        </p>
                        <br /><br /><br /><br />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <p><strong>'||item_tp.ThamPhan_TEN||'</strong></p>
                    </td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 450pt"></td>
                    <td style="width: 450pt;"></td>
                </tr>
            </table>
            ');
            IF(dem_<item_tp.TONG_TP)  THEN --ngắt trang truyển sang trang mới
               DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <span style="font-size:12.0pt;font-family:''Times New Roman'',serif;mso-fareast-font-family:
                ''Times New Roman'';mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                mso-fareast-language:EN-US;mso-bidi-language:AR-SA">
                <br clear=all style="mso-special-character:line-break;page-break-before:always">
                </span>
                ');
            END IF;

   END LOOP;
        OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END BAOCAO_TH_THULY_TP;
FUNCTION BAOCAO_TK_TP_GET
(
  VTHAMPHANID_PCA  IN NUMBER,
  vToaAnID in number,
  vThamphanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  vYears in varchar2
)
 RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB; 
    --------------
     V_HOTEN VARCHAR2(150);ma_chucvu varchar2(50); margin_top varchar2(50);height_ varchar2(50);
     type array_t is varray(3) of number;V_CREATE_DATE DATE;v_table T_GDTTT_THONGKE_THAMPHAN;
     array array_t := array_t(0,1,3);V_COUNT_TP NUMBER; V_LOAIAN varchar2(255);
  BEGIN	
    v_table := T_GDTTT_THONGKE_THAMPHAN();
     --------------------
           select COUNT(*)INTO V_COUNT_TP from DM_CANBO a
              inner join (select c.ID,c.TEN from DM_DATAITEM c  where c.GROUPID=12 and c.MA in ('TPTATC')) b on b.ID=a.CHUCDANHID 
              left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=13) d on d.ID=a.CHUCVUID
              where a.TOAANID=1  And a.HIEULUC=1 AND D.ID=74
              AND A.ID=VTHAMPHANID_PCA;
          ------------    

    SELECT UPPER(CB.HOTEN) INTO V_HOTEN FROM DM_CANBO CB WHERE ID=vThamphanID;
    select b.Ma into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphanID;
    --------------
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
    --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
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
    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                     <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
                     ');
  FOR I IN 1..ARRAY.COUNT 
    LOOP --trường hợp array(i)= 0 tất cả,1 án quốc hội, 3 án thời hiệu
           IF(V_COUNT_TP=0 OR VTHAMPHANID_PCA=VTHAMPHANID) THEN
          --------------
         SELECT TT.CREATE_DATE INTO V_CREATE_DATE FROM (
                SELECT TH.CREATE_DATE FROM GDTTT_THONGKE_THAMPHAN TH 
                WHERE TH.THAMPHANID=VTHAMPHANID AND TH.YEAR_BC=VYEARS AND TH.LOAIANDB=ARRAY(I)
                ORDER BY TH.CREATE_DATE DESC
          )TT WHERE ROWNUM=1;
         --------------
              FOR item IN (
                                SELECT  TT.LoaiAn,TT.TenLoaiAn,TT.YEAR_BC,TT.THAMPHANID,TT.LOAIANDB,
                                    TT.COLUMN_1,TT.COLUMN_2,TT.COLUMN_3,TT.COLUMN_4,TT.COLUMN_5,TT.COLUMN_6,TT.COLUMN_7,TT.COLUMN_8,
                                    TT.COLUMN_9,TT.COLUMN_10,TT.COLUMN_11,TT.COLUMN_12,TT.COLUMN_13,TT.COLUMN_14,TT.COLUMN_15,TT.COLUMN_16,
                                    TT.COLUMN_17,TT.COLUMN_18,TT.COLUMN_19,TT.COLUMN_20,TT.COLUMN_21,TT.COLUMN_22,TT.COLUMN_23,TT.COLUMN_24,TT.COLUMN_25
                                    ,TT.CREATE_DATE
                                FROM GDTTT_THONGKE_THAMPHAN TT 
                                WHERE TT.THAMPHANID=VTHAMPHANID AND TT.YEAR_BC=VYEARS  AND TT.LOAIANDB=ARRAY(I) AND CREATE_DATE=V_CREATE_DATE --AND TT.LoaiAn IS NOT NULL
                           )
                    LOOP
                    v_table.extend;--chuyen vao bang dinh nghia
                    v_table(v_table.count) := R_GDTTT_THONGKE_THAMPHAN(
                            item.LOAIAN,item.TENLOAIAN,item.YEAR_BC,item.THAMPHANID,item.LOAIANDB,
                            item.COLUMN_1,item.COLUMN_2,item.COLUMN_3,item.COLUMN_4,item.COLUMN_5,item.COLUMN_6,--dòng dâu tiên có 6 giá trị do thêm cột cũ còn lại
                            item.COLUMN_7,item.COLUMN_8,item.COLUMN_9,item.COLUMN_10,item.COLUMN_11,--5 giá trị
                             item.COLUMN_12,item.COLUMN_13,item.COLUMN_14,item.COLUMN_15,item.COLUMN_17,--5 giá trị
                             item.COLUMN_17,item.COLUMN_18,item.COLUMN_19,item.COLUMN_20,item.COLUMN_21,--5 giá trị
                             item.COLUMN_22,item.COLUMN_23,item.COLUMN_24,item.COLUMN_25,item.CREATE_DATE
                            );
               END LOOP;  
           ELSIF(V_COUNT_TP >0)THEN
            Select replace(DECODE(c.ISHINHSU,1,','||1||',','')||DECODE(c.ISDANSU,1,','||2||',','')|| DECODE(c.ISHNGD,1,','||3||',','')||DECODE(c.ISKDTM,1,','||4||',','')||DECODE(c.ISHANHCHINH,1,','||6||',','')||DECODE(c.ISLAODONG,1,','||5||',',''),',,',',')
            INTO V_LOAIAN From DM_CANBO c where c.id=VTHAMPHANID_PCA;
            ------
              SELECT TT.CREATE_DATE INTO V_CREATE_DATE FROM (
                SELECT TH.CREATE_DATE FROM GDTTT_THONGKE_THAMPHAN TH 
                WHERE TH.THAMPHANID=VTHAMPHANID AND TH.YEAR_BC=VYEARS AND TH.LOAIANDB=ARRAY(I)
                 AND  instr(V_LOAIAN,','||TH.LOAIAN||',')>0 
                ORDER BY TH.CREATE_DATE DESC
          )TT WHERE ROWNUM=1;
         --------------
             FOR item IN (
                                SELECT  TT.LoaiAn,TT.TenLoaiAn,TT.YEAR_BC,TT.THAMPHANID,TT.LOAIANDB,
                                    TT.COLUMN_1,TT.COLUMN_2,TT.COLUMN_3,TT.COLUMN_4,TT.COLUMN_5,TT.COLUMN_6,TT.COLUMN_7,TT.COLUMN_8,
                                    TT.COLUMN_9,TT.COLUMN_10,TT.COLUMN_11,TT.COLUMN_12,TT.COLUMN_13,TT.COLUMN_14,TT.COLUMN_15,TT.COLUMN_16,
                                    TT.COLUMN_17,TT.COLUMN_18,TT.COLUMN_19,TT.COLUMN_20,TT.COLUMN_21,TT.COLUMN_22,TT.COLUMN_23,TT.COLUMN_24,TT.COLUMN_25
                                    ,TT.CREATE_DATE
                                FROM GDTTT_THONGKE_THAMPHAN TT 
                                WHERE TT.THAMPHANID=VTHAMPHANID AND TT.YEAR_BC=VYEARS  
                                AND TT.LOAIANDB=ARRAY(I)
                                AND CREATE_DATE=V_CREATE_DATE
                                AND  instr(V_LOAIAN,','||TT.LOAIAN||',')>0 

                           )
                    LOOP
                    v_table.extend;--chuyen vao bang dinh nghia
                    v_table(v_table.count) := R_GDTTT_THONGKE_THAMPHAN(
                            item.LOAIAN,item.TENLOAIAN,item.YEAR_BC,item.THAMPHANID,item.LOAIANDB,
                            item.COLUMN_1,item.COLUMN_2,item.COLUMN_3,item.COLUMN_4,item.COLUMN_5,item.COLUMN_6,--dòng dâu tiên có 6 giá trị do thêm cột cũ còn lại
                            item.COLUMN_7,item.COLUMN_8,item.COLUMN_9,item.COLUMN_10,item.COLUMN_11,--5 giá trị
                             item.COLUMN_12,item.COLUMN_13,item.COLUMN_14,item.COLUMN_15,item.COLUMN_17,--5 giá trị
                             item.COLUMN_17,item.COLUMN_18,item.COLUMN_19,item.COLUMN_20,item.COLUMN_21,--5 giá trị
                             item.COLUMN_22,item.COLUMN_23,item.COLUMN_24,item.COLUMN_25,item.CREATE_DATE
                            );
               END LOOP;  
               ---SUM
                FOR item IN (
                             SELECT NULL LoaiAn,'<span class="tong_cong_tp">TỔNG CỘNG</span>' TenLoaiAn,
                                 SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
                                ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
                                ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
                                ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17,SUM(PA.COLUMN_18)COLUMN_18,SUM(PA.COLUMN_19)COLUMN_19
                                ,SUM(PA.COLUMN_20)COLUMN_20,SUM(PA.COLUMN_21)COLUMN_21,SUM(PA.COLUMN_22)COLUMN_22,SUM(PA.COLUMN_23)COLUMN_23,SUM(PA.COLUMN_24)COLUMN_24,SUM(PA.COLUMN_25)COLUMN_25
                                FROM TABLE(v_table) PA
                                WHERE PA.THAMPHANID=VTHAMPHANID AND PA.YEAR_BC=VYEARS  
                                AND PA.LOAIANDB=ARRAY(I)
                                AND PA.CREATE_DATE=V_CREATE_DATE
                                AND  instr(V_LOAIAN,','||PA.LOAIAN||',')>0 
                            GROUP BY NULL,'<span class="tong_cong_tp">TỔNG CỘNG</span>'
                           )
                    LOOP
                    v_table.extend;--chuyen vao bang dinh nghia
                    v_table(v_table.count) := R_GDTTT_THONGKE_THAMPHAN(
                             NULL,item.TENLOAIAN,VYEARS,VTHAMPHANID,ARRAY(I),
                             item.COLUMN_1,item.COLUMN_2,item.COLUMN_3,item.COLUMN_4,item.COLUMN_5,item.COLUMN_6,--dòng dâu tiên có 6 giá trị do thêm cột cũ còn lại
                             item.COLUMN_7,item.COLUMN_8,item.COLUMN_9,item.COLUMN_10,item.COLUMN_11,--5 giá trị
                             item.COLUMN_12,item.COLUMN_13,item.COLUMN_14,item.COLUMN_15,item.COLUMN_17,--5 giá trị
                             item.COLUMN_17,item.COLUMN_18,item.COLUMN_19,item.COLUMN_20,item.COLUMN_21,--5 giá trị
                             item.COLUMN_22,item.COLUMN_23,item.COLUMN_24,item.COLUMN_25,V_CREATE_DATE
                            );
               END LOOP; 
          END IF;
            ---------------
              IF(ARRAY(I)= 0) THEN
                      margin_top:='0px';height_:='45px';
                    IF(MA_CHUCVU='CA')THEN  
                           V_HOTEN:='TÌNH HÌNH GIẢI QUYẾT ĐƠN ĐỀ NGHỊ GĐTTT CHÁNH ÁN '||V_HOTEN||' (NĂM '||vYears||')';
                          ELSIF(ma_chucvu='PCA')then  
                             V_HOTEN:='TÌNH HÌNH GIẢI QUYẾT ĐƠN ĐỀ NGHỊ GĐTTT PHÓ CHÁNH ÁN '||V_HOTEN||' (NĂM '||vYears||')';
                          ELSE
                           V_HOTEN:='TÌNH HÌNH GIẢI QUYẾT ĐƠN ĐỀ NGHỊ GĐTTT CỦA THẨM PHÁN '||V_HOTEN||' (NĂM '||vYears||')';
                    END IF;
              ELSIF (ARRAY(I)= 1) THEN
                margin_top:='60px';height_:='100px';
               V_HOTEN:='THỐNG KÊ VỤ ÁN QUỐC HỘI ĐANG GIẢI QUYẾT ';
              ELSIF(ARRAY(I)= 3) THEN 
                margin_top:='60px';height_:='100px';
                V_HOTEN:='THỐNG KÊ VỤ ÁN CÒN THỜI HIỆU GIẢI QUYẾT DƯỚI 3 THÁNG';
              END IF;
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr style="margin-top:'||margin_top||';">
                            <th style="text-align: center; vertical-align: middle; height:'||height_||'; font-size: 14pt;" colspan="26">'||V_HOTEN||'</th>
                    </tr>
                    <tr style="">
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">LOẠI ÁN </th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Cũ còn lại của năm trước</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tổng số vụ việc phải giải quyết trong năm<i style="font-weight:100"> (đã bao gồm số liệu của cột 1)</i></th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">Phân công Thẩm tra viên</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">Trạng thái hồ sơ</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Thẩm tra viên đang nghiên cứu</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="4">Giải quyết tờ trình</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Đã giải quyết xong </th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Còn lại chưa giải quyết <i>(bao gồm dự thảo TLĐ và dự thảo KN)</i></th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="5">Kết quả giải quyết đơn</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="7">Xét xử Giám đốc thẩm</th>

                    </tr>
                    <tr style="">
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Đã phân công</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Chưa phân công</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Có hồ sơ</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Chưa có hồ sơ</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Chưa có ý kiến</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Đã có ý kiến</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Đã đăng ký lịch báo cáo Thẩm phán</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; padding: 5px;">Báo cáo Phó Chánh án, Tổ Thẩm phán, Chánh án, Hội đồng Thẩm phán</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Trả lời đơn</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Kháng nghị</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Xếp đơn</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Đang dự thảo trả lời đơn</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Đang dự thảo kháng nghị</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng số kháng nghị của Chánh án và Viện kiểm sát</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Đã thụ lý xét xử GĐT</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Chưa xét xử </th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Đã xét xử</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Chủ tọa</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Hội đồng toàn thể</th>
                        <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Hội đồng 5</th>
                    </tr>
                   <tr style="font-style: italic; color: #adabab; font-size: 10pt; text-align: center;">
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;height:25px"></td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">1</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">2</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">3</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">4</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">5</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">6</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">7</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">8</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">9</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">10</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">11</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">12</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">13</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">14</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">15</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">16</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">17</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">18</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">19</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">20</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">21</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">22</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">23</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">24</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">25</td>
                        </tr>
                       ');
                 -----------item
                    FOR item IN (
                                SELECT  TT.LoaiAn,TT.TenLoaiAn,TT.YEAR_BC,TT.THAMPHANID,TT.LOAIANDB,
                                    TT.COLUMN_1,TT.COLUMN_2,TT.COLUMN_3,TT.COLUMN_4,TT.COLUMN_5,TT.COLUMN_6,TT.COLUMN_7,TT.COLUMN_8,
                                    TT.COLUMN_9,TT.COLUMN_10,TT.COLUMN_11,TT.COLUMN_12,TT.COLUMN_13,TT.COLUMN_14,TT.COLUMN_15,TT.COLUMN_16,
                                    TT.COLUMN_17,TT.COLUMN_18,TT.COLUMN_19,TT.COLUMN_20,TT.COLUMN_21,TT.COLUMN_22,TT.COLUMN_23,TT.COLUMN_24,TT.COLUMN_25
                                FROM  TABLE(v_table)  TT 
                                WHERE TT.THAMPHANID=VTHAMPHANID AND TT.YEAR_BC=VYEARS  AND TT.LOAIANDB=ARRAY(I) AND TT.LoaiAn IS NOT NULL AND CREATE_DATE=V_CREATE_DATE
                                ORDER BY TT.LOAIAN
                           )
                    LOOP
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                       <tr>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding: 5px;">'||item.TenLoaiAn||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_1||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_2||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_3||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_4||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_5||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_6||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_7||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_8||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_9||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_10||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_11||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_12||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_13||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_14||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_15||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_16||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_17||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_18||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_19||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_20||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_21||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_22||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_23||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_24||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_25||'</td>
                    </tr>
                   ');
                    END LOOP;
                    -----tong
                    FOR item IN (
                      SELECT  TT.LoaiAn,TT.TenLoaiAn,TT.YEAR_BC,TT.THAMPHANID,TT.LOAIANDB,
                                    TT.COLUMN_1,TT.COLUMN_2,TT.COLUMN_3,TT.COLUMN_4,TT.COLUMN_5,TT.COLUMN_6,TT.COLUMN_7,TT.COLUMN_8,
                                    TT.COLUMN_9,TT.COLUMN_10,TT.COLUMN_11,TT.COLUMN_12,TT.COLUMN_13,TT.COLUMN_14,TT.COLUMN_15,TT.COLUMN_16,
                                    TT.COLUMN_17,TT.COLUMN_18,TT.COLUMN_19,TT.COLUMN_20,TT.COLUMN_21,TT.COLUMN_22,TT.COLUMN_23,TT.COLUMN_24,TT.COLUMN_25
                                FROM  TABLE(v_table)  TT 
                                WHERE TT.THAMPHANID=VTHAMPHANID AND TT.YEAR_BC=VYEARS  AND TT.LOAIANDB=ARRAY(I) AND TT.LoaiAn IS NULL AND CREATE_DATE=V_CREATE_DATE
                    )
                    LOOP
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                       <tr style="font-weight:bold;">
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding: 5px;">TỔNG CỘNG</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_1||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_2||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_3||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_4||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_5||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_6||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_7||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_8||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_9||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_10||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_11||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_12||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_13||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_14||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_15||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_16||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_17||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_18||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_19||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_20||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_21||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_22||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_23||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_24||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_25||'</td>
                    </tr>
                   ');
                    END LOOP;
                END LOOP;
                -----------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                      <tr style="height: 0px;">
                        <td style="width: 250px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                    </tr>
               </table>
           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
            style="mso-special-character:line-break;page-break-before:always">
            </span>
            <p class=MsoNormal><o:p></o:p></p>               
        ');
        OPEN V_CURSOR FOR
--      SELECT JM.* FROM TABLE(v_table) JM;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END BAOCAO_TK_TP_GET;
FUNCTION BAOCAO_TK_VU
(
  vToaAnID in number,
  vPhongBanID  in number,
  vLanhdaoVu number,
  vThamTraVien number
)
 RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB; v_table T_THONGKE_TONGHOP;
    --------------
        LoaiAn number;TenLoaiAn varchar2(250);
        COLUMN_1 number;COLUMN_2 number;COLUMN_3 number;COLUMN_4 number;COLUMN_5 number;COLUMN_6 number;COLUMN_7 number;COLUMN_8 number;
        COLUMN_9 number;COLUMN_10 number;COLUMN_11 number;COLUMN_12 number;COLUMN_13 number;COLUMN_14 number;COLUMN_15 number;COLUMN_16 number;
        COLUMN_17 number;
      ------------------------
     V_HOTEN VARCHAR2(150);ma_chucvu varchar2(10); margin_top varchar2(10);height_ varchar2(10);
     type array_t is varray(3) of number;
     array array_t := array_t(0,1,3);   
  BEGIN	
    --------------
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                     <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
                    ');
  FOR I IN 1..ARRAY.COUNT 
    LOOP --trường hợp array(i)= 0 tất cả,1 án quốc hội, 3 án thời hiệu
    ----------------------
                 v_table := T_THONGKE_TONGHOP();
                 PKG_GDTTT_APP.THONGKE_TONGHOP(vToaAnID,vPhongBanID,vLanhdaoVu,vThamTraVien,array(i),V_CURSOR);
                -- V_CURSOR:=V_CURSOR;
                -----------------------
               LOOP 
                FETCH V_CURSOR --chạy từng dòng dữ liệu gán vào các biến
                  INTO  LoaiAn,TenLoaiAn,
                        COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                        COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,COLUMN_13,COLUMN_14,COLUMN_15,COLUMN_16,
                        COLUMN_17;
                EXIT WHEN V_CURSOR%NOTFOUND;
               -------------
                  IF(LoaiAn is not null) THEN--không lấy dòng tổng
                     v_table.extend;--chuyen vao bang dinh nghia - tiện cho việc truy vấn,
                     --trường hợp này có thể không cần dùng v_table, có thể add giao diện trực tiếp tại đây
                     v_table(v_table.count) := R_THONGKE_TONGHOP(
                                LoaiAn,TenLoaiAn,
                                COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                                COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,COLUMN_13,COLUMN_14,COLUMN_15,COLUMN_16,
                                COLUMN_17
                                );
                  END IF;
              END LOOP;
              CLOSE V_CURSOR;
              ---------------
              IF(ARRAY(I)= 0) THEN
                       margin_top:='0px';height_:='45px';
                      V_HOTEN:='THỐNG KÊ VỤ ÁN ĐANG GIẢI QUYẾT ';
              ELSIF (ARRAY(I)= 1) THEN
                     margin_top:='30px';height_:='100px';
                     V_HOTEN:=' <br />THỐNG KÊ VỤ ÁN QUỐC HỘI ĐANG GIẢI QUYẾT <br />';
              ELSIF(ARRAY(I)= 3) THEN 
                    margin_top:='30px';height_:='100px';
                    V_HOTEN:='<br />THỐNG KÊ VỤ ÁN CÒN THỜI HIỆU GIẢI QUYẾT DƯỚI 3 THÁNG<br />';
              END IF;
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <tr style="margin-top:'||margin_top||'">
                            <th style="text-align: center; vertical-align: middle; height:'||height_||'; font-size: 14pt;" colspan="18">'||V_HOTEN||'</th>
                        </tr>
                        <tr  style="">
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">LOẠI ÁN </th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Chưa phân công TTV</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Đã phân công TTV</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;height:30px" colspan="2">Hồ sơ</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="10">Quá trình giải quyết</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">Dự thảo</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Hoãn thi hành án</th>
                        </tr>
                        <tr style="">
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Đã có</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Chưa có</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Chưa có tờ trình<br />
                                <i style="font-weight: 100; text-align: left;">(Đã có hồ sơ)</i></th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Phó Vụ trưởng</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Vụ trưởng</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;height:25px" colspan="2">Thẩm phán</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Xác minh, Bổ sung</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Phó CA</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tổ TP</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Chánh án</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">HĐ Thẩm Phán</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Trả lời đơn</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Kháng nghị</th>
                        </tr>
                        <tr>
                             <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;height:70px;">Chưa có ý kiến</th>
                            <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Đã có ý kiến</th>
                        </tr>
                        <tr style="font-style: italic; color: #adabab; font-size: 10pt; text-align: center;">
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;height:25px"></td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">1</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">2</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">3</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">4</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">5</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">6</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">7</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">8</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">9</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">10</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">11</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">12</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">13</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">14</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">15</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">16</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">17</td>
                        </tr>
                       ');
                 -----------item
                    FOR item IN (
                          SELECT PA.LoaiAn,PA.TenLoaiAn,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
                          ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
                          ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
                          ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17
                          FROM TABLE(v_table) PA
                          GROUP BY PA.LoaiAn,PA.TenLoaiAn ORDER BY PA.LoaiAn
                           )
                    LOOP
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                       <tr>
                        <td style="border: 1pt solid Black; text-align: left; vertical-align: middle; padding: 5px;">'||item.TenLoaiAn||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_1||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_2||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_3||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_4||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_5||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_6||'</td>            
                         <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_7||'</td>
                          <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_8||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_9||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_10||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_11||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_12||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_13||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_14||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_15||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_16||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_17||'</td>
                    </tr>
                   ');
                    END LOOP;
                    -----tong
                    FOR item IN (
                        SELECT SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
                      ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
                      ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
                      ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17
                      FROM TABLE(v_table) PA
                    )
                    LOOP
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                       <tr style="font-weight:bold;">
                        <td style="border: 1pt solid Black; text-align: left; vertical-align: middle; padding: 5px;">TỔNG CỘNG</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_1||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_2||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_3||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_4||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_5||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_6||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_7||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_8||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_9||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_10||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_11||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_12||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_13||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_14||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_15||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_16||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_17||'</td>
                    </tr>
                   ');
                    END LOOP;
                 -----------

  END LOOP;
   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <tr style="height: 0px;">
                <td style="width: 250px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                </tr>
               </table>
                ');
        OPEN V_CURSOR FOR
--      SELECT JM.* FROM TABLE(v_table) JM;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END BAOCAO_TK_VU;
FUNCTION BAOCAO_THONGKE_CHITIEU_01
(
    v_TenPhongban VARCHAR2 DEFAULT NULL,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vTuNgay_ky in date,
    vDenNgay_ky in date,
    vLanhDaoID number,
    vThamtravienID number
)
   RETURN SYS_REFCURSOR
   IS 
   V_CURSOR sys_refcursor;
    v_table T_GDT_CHITIEU_01; V_EXPORT_TEXT CLOB; v_dem NUMBER:=0;
    vCount number; vCount1 number; vCount2 number;
    t_vDenNgay date;
    t_vTuNgay date;
    t_vDenNgay_ky date;
    t_vTuNgay_ky date;
	BEGIN

    SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into t_vDenNgay from dual;
    SELECT DECODE(vTuNgay,null,null,to_date(to_char(vTuNgay,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')) into t_vTuNgay from dual;
    SELECT DECODE(vDenNgay_ky,null,sysdate,to_date(to_char(vDenNgay_ky,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into t_vDenNgay_ky from dual;
    SELECT DECODE(vTuNgay_ky,null,null,to_date(to_char(vTuNgay_ky,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')) into t_vTuNgay_ky from dual;

     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
      v_table := T_GDT_CHITIEU_01();
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
                <tr style="text-align: center;">
                    <th colspan="3" style="text-align: center; vertical-align: middle; height: 25px;">TÒA ÁN NHÂN DÂN TỐI CAO
                    </th>
                    <th colspan="10" style="text-align: center; vertical-align: middle; font-size: 14pt;">THỐNG KÊ CHỈ TIÊU</th>
                    <th colspan="4" style="text-align: center; vertical-align: middle;"></th>
                </tr>
                <tr>
                    <th colspan="3" style="text-align: center; vertical-align: top; height: 20px; font-weight: bold;">'||upper(v_TenPhongban)||'</th>
                    <td colspan="10" style="text-align: center; vertical-align: top; font-style: italic;">Từ ngày '||TO_CHAR(vTuNgay,'dd/MM/yyyy')||' - Đến ngày '||TO_CHAR(vDenNgay,'dd/MM/yyyy')||'</td>
                    <td colspan="4" style="text-align: center; vertical-align: top; font-style: italic;"></td>
                </tr>
                <tr style="mso-yfti-irow:2; height:8.5pt; mso-height-rule:exactly">
                    <td colspan="17" style="padding:0cm 0cm 0cm 0cm;height:8.5pt;mso-height-rule: exactly">
                        <table cellpadding="0" cellspacing="0" align="left">
                            <tr style="height: 1pt; mso-height-rule: exactly">
                                <td style="width: 90px; height: 1px; mso-height-rule: exactly"></td>
                                <td style="border-top: 0px solid #000000;">
                                    <span style="color: #ffffff;">------------</span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
             <tr style="">
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">STT</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">HỌ VÀ TÊN</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 28px;" colspan="3">VỤ, VIỆC ĐƯỢC PHÂN CÔNG</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">ĐÃ TRÌNH</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">ÁN GĐT ĐÃ XỬ</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">CHỈ TIÊU KHÁC</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">TỔNG CHỈ TIÊU</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="4">CÒN LẠI</th>
            </tr>
            <tr style="">
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 100px;">ĐƠN ĐỀ NGHỊ</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">ÁN GĐT</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CỘNG</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CHỈ TIÊU TRONG KỲ TK </th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CHỈ TIÊU TRONG NĂM</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CHỈ TIÊU TRONG KỲ TK </th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CHỈ TIÊU TRONG NĂM</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CHỈ TIÊU TRONG KỲ TK </th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CHỈ TIÊU TRONG NĂM</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CHỈ TIÊU TRONG KỲ TK </th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CHỈ TIÊU TRONG NĂM</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">HỒ SƠ ĐANG NGHIÊN CỨU</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">TIỂU HỒ SƠ</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">ÁN GĐT CHƯA XỬ</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CỘNG</th>
            </tr>
           ');
            SELECT R_GDT_CHITIEU_01( row_number() over (order by ch.ID),ttv.ID,ttv.HOTEN,ldv.HOTEN,ldv.ID,
                                      NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NuLL
                                      ) 
                BULK COLLECT INTO v_table
                FROM GDTTT_CACVU_CAUHINH ch 
                INNER JOIN DM_CANBO ttv ON ttv.ID=ch.THAMTRAVIENID
                INNER JOIN DM_CANBO ldv ON ldv.ID=ch.LANHDAOID
                WHERE ttv.PHONGBANID=vPhongBanID and ch.PHONGBANID=vPhongBanID
                AND ((ch.LANHDAOID=vLanhDaoID AND vLanhDaoID !=0) OR vLanhDaoID=0)
                AND ((ch.THAMTRAVIENID=vThamtravienID AND vThamtravienID!=0) OR vThamtravienID=0);
       -------------------------------------------------- 
    FOR item IN (
        SELECT 
            T.STT, 
            T.CANBOID
        FROM  TABLE(v_table) T 
       ) LOOP
                --Cot 1 Tong vu Phan cong TTV giai quyet don GDT  tu ngay den ngay--
                -- Theo Vụ án
            Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                And v.THAMTRAVIENID=item.CANBOID
                And v.ngaytao between  t_vTuNgay and t_vDenNgay
                ;
                --Theo Don
            Select count(dc.id) into vCount2 from GDTTT_DON_CHUYEN dc 
                    inner join (Select h.ID, h.VUVIECID,h.BAQD_TOAANID, h.isthuly from GDTTT_DON h 
                    inner join GDTTT_VUAN va on va.ID=h.VUVIECID  where va.THAMTRAVIENID=item.CANBOID)d on d.ID=dc.DONID
                    where dc.PHONGBANNHANID=vPhongBanID 
                    and dc.DONVINHANID=vToaAnID 
                    And dc.NGAYNHAN between t_vTuNgay and t_vDenNgay
                    And dc.TRANGTHAI=2
                    And d.isthuly = 1
                    ;

                if vPhongBanID = 3 then
                    v_table(item.STT).COLUMN_1:=vCount1;
                else                   
                    v_table(item.STT).COLUMN_1:=vCount2;
                end if;

                 -- Cot 2 Tong vu da Thu ly xet xu Giam doc tham
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v 
                        Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID=vPhongBanID 
                        And v.THAMTRAVIENID=item.CANBOID 
                        And v.ngaytao <= t_vDenNgay
                        And  v.NGAYTHULYXXGDT between t_vTuNgay and t_vDenNgay
                       ;

                 v_table(item.STT).COLUMN_2:=vCount1;

                --Cot 3 tổng cong--   
                v_table(item.STT).COLUMN_3:=NVL(v_table(item.STT).COLUMN_1,0)+NVL(v_table(item.STT).COLUMN_2,0);

                --Cot 4 đã trình trong tháng--
                Select Count(v.ID) into vCount From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID=vPhongBanID
                        And v.THAMTRAVIENID=item.CANBOID
                        And v.ngaytao <=t_vDenNgay
                        And PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,t_vTuNgay,t_vDenNgay)>0 ;
                v_table(item.STT).COLUMN_4:=vCount;   
                --Cot 6 đã trình trong ky bao cao--
                Select Count(v.ID) into vCount From GDTTT_VUAN v
                        Where v.TOAANID=vToaAnID 
                            and v.PHONGBANID=vPhongBanID
                            And v.THAMTRAVIENID=item.CANBOID
                            And v.ngaytao <= t_vDenNgay_ky
                            And PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,t_vTuNgay_ky,t_vDenNgay_ky)>0 ;
                v_table(item.STT).COLUMN_5:=vCount; 


                --Cot 7 án giam đốc đã xử trong thời gian báo cáo--
                Select Count(v.ID) into vCount From GDTTT_VUAN v
                        Where v.TOAANID=vToaAnID
                        and v.PHONGBANID=vPhongBanID 
                        And v.THAMTRAVIENID=item.CANBOID
                        --And v.TRANGTHAIID =15
                        And v.ngaytao <= t_vDenNgay
                        And ((EXISTS(select 'X' from gdttt_vuan_xetxugdttt where VUANID = v.ID and NGAYMOPT between t_vTuNgay and t_vDenNgay) 
                                                AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                        Or (ISRUTKN = 1 and NGAYRUTKN  between t_vTuNgay and t_vDenNgay));

--                        AND v.ID in (select vuanid from gdttt_vuan_xetxugdttt   
--                                                        where ngaymopt between t_vTuNgay and t_vDenNgay
--                                                        and ISHOAN = 0
--                                                        );
                v_table(item.STT).COLUMN_6:=NVL(vCount,0);  

                --Cot 8 án giam đốc đã xử trong năm--
                Select Count(v.ID) into vCount From GDTTT_VUAN v
                Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID=vPhongBanID 
                        And v.THAMTRAVIENID=item.CANBOID
                        --And v.TRANGTHAIID =15 
                        And v.ngaytao <= t_vDenNgay_ky
                        And ((EXISTS(select 'X' from gdttt_vuan_xetxugdttt where VUANID = v.ID and NGAYMOPT between t_vTuNgay_ky and t_vDenNgay_ky) 
                                                AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                                Or (ISRUTKN = 1 and NGAYRUTKN  between t_vTuNgay_ky and t_vDenNgay_ky)
                             );


                v_table(item.STT).COLUMN_7:=vCount;  
                --Chỉ tiêu khác
                v_table(item.STT).COLUMN_8:=0;
                v_table(item.STT).COLUMN_9:=0;
                --Cot 9 Tổng chỉ tiêu trong thời gian báo cáo
                v_table(item.STT).COLUMN_10:=NVL(v_table(item.STT).COLUMN_4,0)+NVL(v_table(item.STT).COLUMN_6,0);
                --Cot 9 Tổng chỉ tiêu trong thời gian báo cáo
                v_table(item.STT).COLUMN_11:=NVL(v_table(item.STT).COLUMN_5,0)+NVL(v_table(item.STT).COLUMN_7,0); 
                --ĐANG NGHIÊN CỨU Hồ sơ--
            Select Count(v.ID) into vCount From GSCM.GDTTT_VUAN v
                        --left join (select vuanid,ngaytao from GSCM.GDTTT_QUANLYHS where loai = 3) hs on hs.VUANID=v.ID
                        left join GSCM.GDTTT_QUANLYHS hs on hs.VUANID=v.ID
                    Where v.TOAANID=vToaAnID 
                        And hs.loai = 3
                        And hs.ngaytao <= t_vDenNgay
                        and v.PHONGBANID=vPhongBanID 
                        And v.THAMTRAVIENID=item.CANBOID
                        AND  not exists (SELECT 'X' FROM GSCM.GDTTT_TOTRINH SS
                                               WHERE SS.VUANID = v.ID AND SS.TINHTRANGID >= 6
                                             and SS.NGAYTRINH<=t_vDenNgay 
                                            )
                  --      And GSCM.PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKTT(v.ID,t_vDenNgay)=0

                        And v.ngaytao <= t_vDenNgay
                        And (v.GQD_LOAIKETQUA IS NULL or (v.GQD_LOAIKETQUA IS not NULL 
                                                                and decode(v.GQD_NGAYPHATHANHCV,null,v.GDQ_NGAY,v.GQD_NGAYPHATHANHCV) >t_vDenNgay )
                                            )
                        ;


                    --AND hs.NGAYNHAN <= vDenNgay; 
                v_table(item.STT).COLUMN_12:=vCount; 

            Select Count(v.ID) into vCount From GSCM.GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                        and v.PHONGBANID=vPhongBanID 
                        And v.THAMTRAVIENID=item.CANBOID
                        AND  not exists (SELECT 'X' FROM GSCM.GDTTT_TOTRINH SS
                                               WHERE SS.VUANID = v.ID AND SS.TINHTRANGID >= 6
                                             and SS.NGAYTRINH<=t_vDenNgay 
                                            )
                        And not exists (SELECT 'X' from GSCM.GDTTT_QUANLYHS where VUANID=v.ID and loai = 3 and ngaytao <= t_vDenNgay)                         
                        And v.ngaytao <= t_vDenNgay
                        And (v.GQD_LOAIKETQUA IS NULL or (v.GQD_LOAIKETQUA IS not NULL 
                                                                and decode(v.GQD_NGAYPHATHANHCV,null,v.GDQ_NGAY,v.GQD_NGAYPHATHANHCV) >t_vDenNgay )
                                            )
                        ;

                if(vCount is null)then
                    vCount:=0;
                end if;

                v_table(item.STT).COLUMN_13:= vCount; 

                --ÁN GĐT CHƯA XỬ--
            Select Count(v.ID) into vCount From GDTTT_VUAN v
                Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.THAMTRAVIENID=item.CANBOID
                    --and (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001'))
                    And v.NGAYTHULYXXGDT <= t_vDenNgay
                    And (NVL(v.XXGDTTT_ISKETQUA,0) = 0 
                                    or (NVL(v.XXGDTTT_ISKETQUA,0)> 0
                                                And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where VUANID = v.ID and NGAYMOPT > t_vDenNgay) 
                                                AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0
                                                )
                        )
                    And v.ISRUTKN is null
                    ;

                v_table(item.STT).COLUMN_14:=vCount; 
                --cộng
                v_table(item.STT).COLUMN_15:=NVL(v_table(item.STT).COLUMN_12,0)+NVL(v_table(item.STT).COLUMN_13,0)+NVL(v_table(item.STT).COLUMN_14,0);
     END LOOP;
     --in lãnh đạo
      FOR item_ld IN (
                     SELECT JM.LANHDAOID,JM.TENLANHDAO,SUM(JM.COLUMN_1) COLUMN_1,SUM(JM.COLUMN_2) COLUMN_2,SUM(JM.COLUMN_3) COLUMN_3,SUM(JM.COLUMN_4) COLUMN_4,
                     SUM(JM.COLUMN_5) COLUMN_5,SUM(JM.COLUMN_6) COLUMN_6,SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_8) COLUMN_8,
                     SUM(JM.COLUMN_9) COLUMN_9,SUM(JM.COLUMN_10) COLUMN_10,SUM(JM.COLUMN_11) COLUMN_11,SUM(JM.COLUMN_12) COLUMN_12 
                     ,SUM(JM.COLUMN_13) COLUMN_13,SUM(JM.COLUMN_14) COLUMN_14,SUM(JM.COLUMN_15) COLUMN_15
                     FROM TABLE(v_table) JM
                     GROUP BY JM.LANHDAOID,JM.TENLANHDAO 
                     ORDER BY JM.TENLANHDAO
                )
      LOOP
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr>
                    <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;padding:5px; font-weight:bold;" colspan="2">'||item_ld.TENLANHDAO||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                </tr>
       ');
       --in thẩm tra viên
       v_dem:=0;
           FOR item_ttv IN (
           SELECT JM.* FROM TABLE(v_table) JM
                        WHERE JM.LANHDAOID=item_ld.LANHDAOID 
                        ORDER BY JM.HOTEN
           )
         LOOP
           v_dem:=v_dem+1;
           DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <tr>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||v_dem||'</td>
                    <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;padding:5px;">'||item_ttv.HOTEN||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_1||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_2||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_3||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_4||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_5||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_6||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_7||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_8||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_9||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_10||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_11||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_12||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_13||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_14||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_15||'</td>
                </tr>
       ');
         END LOOP;
      END LOOP;
      ---in tong cong 
      FOR item_ld IN (
                     SELECT SUM(JM.COLUMN_1) COLUMN_1,SUM(JM.COLUMN_2) COLUMN_2,SUM(JM.COLUMN_3) COLUMN_3,SUM(JM.COLUMN_4) COLUMN_4,
                     SUM(JM.COLUMN_5) COLUMN_5,SUM(JM.COLUMN_6) COLUMN_6,SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_8) COLUMN_8,
                     SUM(JM.COLUMN_9) COLUMN_9,SUM(JM.COLUMN_10) COLUMN_10,SUM(JM.COLUMN_11) COLUMN_11,SUM(JM.COLUMN_12) COLUMN_12
                     ,SUM(JM.COLUMN_13) COLUMN_13 ,SUM(JM.COLUMN_14) COLUMN_14 ,SUM(JM.COLUMN_15) COLUMN_15 
                     FROM TABLE(v_table) JM
                )
      LOOP
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr>
                    <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;padding:2px; font-weight:bold;height:30px;" colspan="2">Cộng</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_1||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_2||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_3||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_4||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_5||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_6||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_7||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_8||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_9||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_10||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_11||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_12||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_13||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_14||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_15||'</td>
                </tr>
       ');
      END LOOP;

     Select Count(v.ID) into vCount From GDTTT_VUAN v
                        Where v.TOAANID=vToaAnID
                        and v.PHONGBANID=vPhongBanID 
                        And v.ngaytao <= t_vDenNgay
                        And (vThamtravienID =0 or (vThamtravienID>0 and v.THAMTRAVIENID=vThamtravienID))
                        And ISRUTKN = 1 
                        and NGAYRUTKN  between t_vTuNgay and t_vDenNgay;
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' <tr>
                    <th colspan="14" style="text-align: left; vertical-align: middle; height: 20px;"><i>Ghi chú: Có '||vCount||' vụ Rút kháng nghị trong kỳ thống kê</i></th>
                </tr>');
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <tr style="height: 0px;">
                <td style="width: 47px"></td>
                <td style="width: 180px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
            </tr>
   </table>
    ');
     OPEN v_cursor FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN v_cursor;   
END BAOCAO_THONGKE_CHITIEU_01;
END PKG_GDTTT_BAOCAO;

/
