--------------------------------------------------------
--  DDL for Package Body PKG_VGDKT_BAOCAO_TT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_VGDKT_BAOCAO_TT" AS
FUNCTION BAOCAO_TH_THULY_GDKT_13
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
     v_Tongso1 number;
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
          ------------------Cu con lai
             SELECT COUNT(*)INTO v_Tongso FROM GDTTT_VUAN VA
                WHERE VA.TOAANID=vToaAnID 
                    AND VA.PHONGBANID=item_pb.ID
                    AND VA.THAMPHANID=item_tp.THAMPHANID
                    AND VA.NGAYTAO < vTuNgay
                    And NVL(va.ISVIENTRUONGKN,0) = 0
                    And (VA.GQD_LOAIKETQUA is null Or (VA.GQD_LOAIKETQUA in (0,1,2,3,4)  And VA.GDQ_NGAY >= vTuNgay))
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
                And NVL(va.ISVIENTRUONGKN,0) = 0
               -- And (VA.GQD_LOAIKETQUA is null Or (VA.GQD_LOAIKETQUA in (0,1,2,3,4)  And VA.GDQ_NGAY <= vDenNgay))
                ;
             --
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                        0,v_Tongso,
                        0,0,0,0,0,
                        0,0,0,0,0                      
                        );
         --Đang rút hồ sơ <=>Chưa có hồ sơ 
         --LOAI:0:Phieu muon/1:Phieu Tra/2:Phieu chuyen/3:Phieu nhan
             Select Count(VA.ID) into v_Tongso From GDTTT_VUAN VA
             Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
             And NOT EXISTS (select 'X' from GDTTT_QUANLYHS where VA.ID = VUANID and NGAYTAO is not null And LOAI = 3 And NGAYTAO < vDenNgay)
             And (VA.GQD_LOAIKETQUA is null Or (VA.GQD_LOAIKETQUA in (0,1,2,3,4)  And VA.GDQ_NGAY > vDenNgay))
             AND VA.NGAYTAO < vDenNgay
             And NVL(va.ISVIENTRUONGKN,0) = 0
             AND NOT EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE VA.ID=PA.VUANID);
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
                And EXISTS (select 'X' from GDTTT_QUANLYHS where VA.ID = VUANID and NGAYTAO is not null And LOAI = 3 And NGAYTAO <= vDenNgay)
                And (VA.GQD_LOAIKETQUA is null Or (VA.GQD_LOAIKETQUA in (0,1,2,3,4)  And VA.GDQ_NGAY > vDenNgay))
                AND VA.NGAYTAO<vDenNgay
                And NVL(va.ISVIENTRUONGKN,0) = 0
                AND NOT EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE VA.ID=PA.VUANID);
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
              And (VA.GQD_LOAIKETQUA is null Or (VA.GQD_LOAIKETQUA in (0,1,2,3,4)  And VA.GDQ_NGAY > vDenNgay))
              AND VA.NGAYTAO<vDenNgay
              AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE VA.ID=PA.VUANID AND PA.TINHTRANGID IN (5,101,4,100))
              And NVL(va.ISVIENTRUONGKN,0) = 0;
         
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
                And (VA.GQD_LOAIKETQUA is null Or (VA.GQD_LOAIKETQUA in (0,1,2,3,4)  And VA.GDQ_NGAY > vDenNgay))
                AND VA.NGAYTAO<vDenNgay
                AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE VA.ID=PA.VUANID AND PA.TINHTRANGID=6)
                And NVL(va.ISVIENTRUONGKN,0) = 0;
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
                And (VA.GQD_LOAIKETQUA is null Or (VA.GQD_LOAIKETQUA in (0,1,2,3,4)  And VA.GDQ_NGAY > vDenNgay))
                AND VA.NGAYTAO<vDenNgay
                AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE VA.ID=PA.VUANID AND PA.TINHTRANGID=6 AND PA.NGAYTRA IS NOT NULL)
                And NVL(va.ISVIENTRUONGKN,0) = 0;
          --
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                        0,0,
                        0,0,0,0,v_Tongso,
                        0,0,0,0,0                       
                        );                
          --Xác minh, hop to
          --Yeu cau xac minh tai thoi điểm vDenNgay
         SELECT COUNT(VA.ID) INTO v_Tongso FROM GDTTT_VUAN VA 
          Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
                And (VA.GQD_LOAIKETQUA is null Or (VA.GQD_LOAIKETQUA in (0,1,2,3,4)  And VA.GDQ_NGAY > vDenNgay))
                AND VA.NGAYTAO<vDenNgay
                And NVL(va.ISVIENTRUONGKN,0) = 0
                And EXISTS ( select 'X' from gdttt_totrinh where  vuanid = VA.ID 
                                and loaiykien  = 10   
                                and  ngaytrinh =( select  max(ngaytrinh) from gdttt_totrinh where vuanid =VA.ID  and ngaytra <= vDenNgay))
         ;
         
          --Yeu cau Hop To TP
           SELECT COUNT(VA.ID) INTO v_Tongso1 FROM GDTTT_VUAN VA 
          Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
                And (VA.GQD_LOAIKETQUA is null Or (VA.GQD_LOAIKETQUA in (0,1,2,3,4)  And VA.GDQ_NGAY > vDenNgay))
                AND VA.NGAYTAO<vDenNgay
                And NVL(va.ISVIENTRUONGKN,0) = 0
                And EXISTS ( select 'X' from gdttt_totrinh where  vuanid = VA.ID 
                                and captrinhtiep  = 9   
                                and  ngaytrinh =( select  max(ngaytrinh) from gdttt_totrinh where vuanid =VA.ID  and ngaytra <= vDenNgay))
         ;
          
             v_table.extend;
                 v_table(v_table.count) := R_BC_TP_THULY_GDKT(
                        item_pb.ID,item_pb.TENPHONGBAN,item_tp.THAMPHANID,item_tp.HOTEN,
                        0,0,
                        0,0,0,0,0,
                        v_Tongso + v_Tongso1,0,0,0,0                       
                        );           
           --Trình Dự thảo TLĐ, KN---- 
         SELECT COUNT(VA.ID) INTO v_Tongso FROM GDTTT_VUAN VA 
          Where VA.TOAANID=vToaAnID AND VA.PHONGBANID=item_pb.ID AND VA.THAMPHANID=item_tp.THAMPHANID
                And (VA.GQD_LOAIKETQUA is null Or (VA.GQD_LOAIKETQUA in (0,1,2,3,4)  And VA.GDQ_NGAY > vDenNgay))
                AND VA.NGAYTAO<vDenNgay
                And NVL(va.ISVIENTRUONGKN,0) = 0
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
                AND VA.GQD_LOAIKETQUA in (0,1)  
                And VA.GDQ_NGAY <= vDenNgay And VA.GDQ_NGAY>=vTuNgay
                AND VA.NGAYTAO<vDenNgay
                And NVL(va.ISVIENTRUONGKN,0) = 0
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
                AND VA.gqd_loaiketqua in (2,3,4)
                And VA.GDQ_NGAY <= vDenNgay And VA.GDQ_NGAY>=vTuNgay
                AND VA.NGAYTAO<vDenNgay
                And NVL(va.ISVIENTRUONGKN,0) = 0
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
                <td colspan="14" style="height: 0pt;"></td>
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
                <td colspan="14" style="height: 5pt;"></td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;font-size: 10pt">STT</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Họ và tên
                    <br />
                    Thẩm phán TANDTC</td>
                <td colspan="11" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 20pt;">Số đơn được phân công giải quyết</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            <tr>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 70pt;">Cũ còn lại</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Mới thụ lý</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đang rút HS</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nhận HS/<br/>Nghiên cứu</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Trình LĐ vụ</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Trình TP</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ý kiến TP</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Xác minh/<br />
                    họp tổ/...</td>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Dự thảo TLĐ, KN</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phát hành, TLĐ, KN</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Giải quyết khác</th>
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
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;margin-left:8pt;">'||items.THAMPHAN_TEN||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;margin-left:2pt; height: 20pt;">'||items.COLUMN_1_DON||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;margin-left:2pt;">'||items.COLUMN_1_VU||'</td>
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
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;margin-left:2pt; height: 20pt;">'||items.COLUMN_1_DON||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;margin-left:2pt;">'||items.COLUMN_1_VU||'</td>
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
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
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
                <td style="vertical-align: top;text-align:left;font-size: 10pt;"> NLBC:'||TO_CHAR(sysdate,'dd/MM/yyyy HH24:MI:SS')||'</td>
                <td>
                    <p>
                        <strong>Vụ trưởng</strong>
                        <br />
                        <i style="font-size: 13pt;">(Ký và ghi rõ họ tên)</i>
                    </p>
                   <br /><br /><br /><br /><br />
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
END BAOCAO_TH_THULY_GDKT_13;
FUNCTION  GDTTTT_QLTOTRINH_BC4
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  tt_tungay in date,
  tt_denngay in date,
  vSoThuly in varchar2, 
  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,
  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  vKetquathuly in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vNgayTrinh VARCHAR2(150);vvThamtravien VARCHAR2(150):=NULL;
  vtt_denngay date;vvloaian VARCHAR2(150);vvngaythulyden date;
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvisTTYKienKLTotrinh varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(250);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;v_vLanhdao_ten VARCHAR2(250):=NULL;
   v_ghichu varchar2(2000);
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
   -----
   SELECT DECODE(tt_denngay,null,sysdate,to_date(to_char(tt_denngay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
   -------------------------
  SELECT DECODE(tt_denngay,null,sysdate,tt_denngay) into vtt_denngay from dual;
 v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
  -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,tt_denngay,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,tt_denngay,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
        -----------------------------------------------------------------------------
    FOR item IN (
      select a.*
			from (
            Select  Count(v.ID) OVER () as CountAll ,ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT 
                , NVL(v.TongDon,0 ) as TongDon
                  --anhvh
                ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ,v.NGUYENDON,v.BIDON,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,(SOANPHUCTHAM || chr(10)||DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))) TTBANANPT
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --
                , NVL(qhpl.TENQHPL, Replace(TenVuAn,(NguyenDon ||' - '))) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,ttv.HOTEN as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                 ----------anhvh 12/10/2019 
                ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                 ---------
                , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))
                  end QUATRINH_GHICHU
                ----------------------------------
                , v.GDQ_SO , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID  
                , DECODE(NVL(v.GQD_LOAIKETQUA,5), 4, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3, cast(v.GQD_KETQUA as varchar2(250))) KQ_GQD
                ,CASE WHEN v.GQD_LOAIKETQUA=3 THEN v.GQD_KETQUA
                     else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS              
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, ' (CA)', 1, 'VKS')
                  end LoaiKN  
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  
                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                ,NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
                -------------------------------
                , NVL(v.IsHoSo,0) IsHoSo, v.NGAYTTVNHAN_THS
                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                , GDTTT_ToTrinh_TraToTrinh(v.ID, 'LDVU',0) TraToTrinh
                ------------------------
                , v.SOTHULYXXGDT
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                 , NVL(v.LoaiAn, 0) LoaiAn
                , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
              ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS          
              from GDTTT_VUAN v 
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID

               ----anhvh
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
               --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
             LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
              where v.TOAANID=vToaAnID 
                    And (v.PhongBanID=vPhongBanID OR vPhongBanID=0 or vPhongBanID is null)
                -- Chưa có kết quả đến ngày 
                    And v.NGAYTAO<=vvngaythulyden 
                    And ((v.gqd_loaiketqua in (0,1,2,3,4) and VA.GQD_NGACVS> vvngaythulyden AND VA.GQD_NGACVS IS NOT NULL) 
                         OR v.gqd_loaiketqua IS NULL )
                    And (vloaian = 0 or vloaian = v.LOAIAN ) 

--            -- Trạng thái uyệt dự thảo Trả lời đơn hoặc duyệt dự thảo kháng nghị
                 And ((isTTYKienKLTotrinh = 11 
                        and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  
                                                                and TINHTRANGID >= 6 -- dã có ý kiến TLD từ TP
                                                                and LOAIYKIEN = 0 
                                                                and NGAYTRA is not null
                                                                and NGAYTRA <=vvngaythulyden) )--Trình dự thảo trả lời đơn
                     or (isTTYKienKLTotrinh = 12  
                            and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  
                                                                and TINHTRANGID >= 7 -- dã có ý kiến KN từ PCA, CA, TTP
                                                                and LOAIYKIEN = 1 
                                                                and NGAYTRA is not null
                                                                and NGAYTRA <=vvngaythulyden) ) --Trình dự thảo kháng nghị
                  )  
            )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <!--td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULYDON||'<br/>'||item.NGAYTHULYDON||'</td-->
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'<br/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
         if(vLoaiAn=01)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br/>'||item.BIDON;
                ELSE
                 V_BIDON_CHECK:=replace(item.NGUYENDON||item.BIDON,',','');
                END IF;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;
             IF(ITEM.TRANGTHAIID!=2 AND ITEM.GiaiDoanTrinh=2)THEN--ITEM.TRANGTHAIID=2 phân công thẩm tra viên
                  SELECT TO_CHAR(TTI.NGAYTRINH,'dd/MM/yyyy') INTO vNgayTrinh FROM (
                   SELECT TI.NGAYTRINH  FROM GDTTT_TOTRINH TI WHERE TI.VUANID=ITEM.ID AND (TI.TINHTRANGID=ITEM.TRANGTHAIID OR TI.CAPTRINHTIEP=ITEM.TRANGTHAIID) ORDER BY TI.NGAYTRINH desc
                  )TTI WHERE rownum=1;
             ELSE
                 IF(ITEM.TRANGTHAIID=2 )THEN
                    vNgayTrinh:=ITEM.NGAYPHANCONGTTV|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV;
                 ELSIF(ITEM.TRANGTHAIID!=15 )THEN --THULY_XETXU_GDT
                    IF(ITEM.KQ_GQD_ID<= 2)THEN
                      IF(ITEM.LOAIAN=01)THEN
                       if( ITEM.KQ_GQD_ID!=0) THEN
                       vNgayTrinh:=ITEM.AHS_ThongTinGQD;
                       ELSE
                         vNgayTrinh:=ITEM.GDQ_NGAY|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                       END IF;  
                     ELSE
                      vNgayTrinh:=ITEM.GDQ_NGAY|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                     END IF;
                    ELSE
                      vNgayTrinh:=ITEM.GDQ_NGAY|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                    END IF;
                 ELSE
                      vNgayTrinh:=ITEM.NGAYTHULYXXGDT; 
                 END IF;   
             END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>');
            v_ghichu := null;
       IF(isTTYKienKLToTrinh=12)THEN
          select g.ghichu into v_ghichu  from(
                     select vuanid, LISTAGG(to_char(NGAYTRINH,'dd/MM/yyyy')||
                    ' '||
                    REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án','')||
                    decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,'Chánh án',' TP ')) ||
                    (select hoten from DM_CANBO  where id = lanhdaoid) ||
                    
                    ';'||
                    to_char(NGAYTRA,'dd/MM/yyyy')||
                    decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,'Chánh án',' TP ')) ||
                    (select hoten from DM_CANBO  where id = lanhdaoid) || 
                    decode(loaiykien,1,' duyệt KN ',0,'duyệt TLĐ ',loaiykien)||
                    decode(loaiykien,null,' '||YKIEN,null)                
                    , '; ' ) WITHIN GROUP( ORDER BY  NGAYTRA ) AS GHICHU  
                                from  (SELECT SS.* FROM GDTTT_TOTRINH SS WHERE  SS.VUANID = item.id AND SS.TINHTRANGID>=7
                                                                     and ss.ID >=(SELECT MIN(ID) FROM GDTTT_TOTRINH S WHERE  S.VUANID = item.id  AND S.TINHTRANGID>=7 and s.LoaiYkien = 1)  
                                                          ORDER BY SS.NGAYTRINH ASC) a group by vuanid) g;   
       ELSIF(isTTYKienKLToTrinh=11)THEN
             select g.ghichu into v_ghichu  from(
                     select vuanid, LISTAGG(to_char(NGAYTRINH,'dd/MM/yyyy')||
                    ' '||
                    decode(TINHTRANGID,9,REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),17,REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),REPLACE(REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),'Thẩm phán',''))||
                    decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '),11,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP ')) ||
                    (select hoten from DM_CANBO  where id = lanhdaoid) 
                    ||'; '||
                     
                        to_char(NGAYTRA,'dd/MM/yyyy')||
                        decode(NGAYTRA, null,'',decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '),11,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '))) ||
                        decode(NGAYTRA, null,'',(select hoten from DM_CANBO  where id = lanhdaoid)) || 
                        decode(loaiykien,1,' duyệt KN ',0,' duyệt TLĐ ',loaiykien)||
                        decode(loaiykien,null,' '||YKIEN,null)                 
                        , '; '
                        )
                     WITHIN GROUP( ORDER BY  NGAYTRA ) AS GHICHU  
                                from  (SELECT SS.* FROM GDTTT_TOTRINH SS WHERE  SS.VUANID = item.id AND SS.TINHTRANGID>=6 
                                                        and ss.ID >=(SELECT MIN(ID) FROM GDTTT_TOTRINH S WHERE  S.VUANID = item.id  AND S.TINHTRANGID>=6 and s.LoaiYkien = 0)   
                                                          ORDER BY SS.NGAYTRINH ASC) a group by vuanid) g;
       END IF;                                                   
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'    
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">- '||v_ghichu||'</td>');
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'                
            </tr>
        ');
  END LOOP;
  IF(vLanhdao!=0)THEN
            SELECT '<br/><span style="font-weight:100">Lãnh đạo phụ trách: '||cb.HOTEN||'</span>' INTO v_vLanhdao_ten FROM DM_CANBO cb WHERE ID=vLanhdao;
           -- FETCH FIRST 1 ROWS ONLY;
    END IF;
    -------TẠO BÁO CÁO
    IF(vThamtravien!=0)THEN
        SELECT II.TEN||': '||CB.HOTEN INTO vvThamtravien FROM DM_CANBO CB 
        INNER JOIN (select i.ID, i.TEN from DM_DATAITEM i where i.GROUPID=12)II ON II.ID=CB.CHUCDANHID
        WHERE CB.ID=vThamtravien;
     END IF;
--    SELECT DECODE(isTTYKienKLTotrinh,0,'chưa duyệt',1,'đã duyệt',null) into vvisTTYKienKLTotrinh from dual;
--    SELECT DECODE(vLoaiAn,01,'Tội danh','Quan hệ pháp luật') INTO vLoaiAn_name FROM DUAL;
    -----------
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
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="13" style="height: 0pt;"></td>
            </tr>
            <tr>');
            IF (isTTYKienKLToTrinh = 11) THEN
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                    <td colspan="13" style="line-height: 100%; font-size: 14pt"><b>TỜ TRÌNH ĐÃ DUYỆT TRẢ LỜI ĐƠN '||v_vLanhdao_ten||'</b>');
            ELSE 
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                        <td colspan="13" style="line-height: 100%; font-size: 14pt"><b>TỜ TRÌNH ĐÃ DUYỆT KHÁNG NGHỊ '||v_vLanhdao_ten||'</b>');
            END IF;

            IF (tt_tungay is not null and tt_denngay is not null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br />
                        <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(tt_tungay,'dd/MM/yyyy')||'  đến ngày '||to_char(tt_denngay,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            elsif (tt_tungay is null and tt_denngay is not null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br />
                        <i style="font-size: 12pt;">(Số liệu đến ngày '||to_char(tt_denngay,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            elsif (tt_tungay is not null and tt_denngay is null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br />
                        <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(tt_tungay,'dd/MM/yyyy')||'  đến ngày '||to_char(sysdate,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            else
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br />
                        <i style="font-size: 12pt;">(Số liệu tính đến ngày '||to_char(sysdate,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            end if;
            IF(vThamtravien!=0)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">'||vvThamtravien||'</td>
            </tr>
            ');
            END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">Tổng số tờ trình '||vvisTTYKienKLTotrinh||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bản án
                    <br />
                    số và ngày </td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án xử</td>
                 '); 
            if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị cáo</td>             
            ');   
            ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn/ Người khởi kiện</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn/ Người bị kiện</td>
               ');   
            END IF;

            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            ');  
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="height: 1pt;">
                <td style="width: 20pt"></td> 
                 ');
             if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="width: 100pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 350pt"></td>
                 ');
             else
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'   
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 350pt"></td>
                 ');
             end if;
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'  
            </tr>
        </table>
      ');   
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td style="vertical-align: top;text-align:left;font-size: 10pt;"> NLBC:'||TO_CHAR(sysdate,'dd/MM/yyyy HH24:MI:SS')||'</td>
                        <td>
                            
                        </td>
                    </tr>
                </table> ');
 --------------------------------      
      OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_QLTOTRINH_BC4;
FUNCTION  GDTTTT_QLTOTRINH_BC10
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  tt_tungay in date,
  tt_denngay in date,
  vSoThuly in varchar2, 
  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,
  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  vKetquathuly in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vNgayTrinh VARCHAR2(150);vvThamtravien VARCHAR2(150):=NULL;
  vtt_denngay date;vvloaian VARCHAR2(150);vvngaythulyden date;vvtt_denngay date;
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvisTTYKienKLTotrinh varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(250);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;v_vLanhdao_ten VARCHAR2(250):=NULL;
   v_ghichu varchar2(2000);v_count_yk number;vvloaian_ten VARCHAR2(500);vvloaian_s VARCHAR2(150);V_TEN_PHONGBAN_SUB  VARCHAR2(150);
   V_LANHDAO varchar2(150):=NULL;v_count number;
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
   -----
   SELECT DECODE(tt_denngay,null,sysdate,to_date(to_char(tt_denngay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvtt_denngay from dual;
   -------------------------
 v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
  -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,tt_denngay,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,tt_denngay,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
     -------------------------------------
    FOR item IN (
      select a.*
			from (
            Select  Count(v.ID) OVER () as CountAll ,ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT 
                , NVL(v.TongDon,0 ) as TongDon
                  --anhvh
                ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ,v.NGUYENDON,v.BIDON,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,(SOANPHUCTHAM || chr(10)||DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))) TTBANANPT
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --
                , NVL(qhpl.TENQHPL, Replace(TenVuAn,(NguyenDon ||' - '))) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,ttv.HOTEN as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                 ----------anhvh 12/10/2019 
                ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                 ---------
                , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))
                  end QUATRINH_GHICHU
                ----------------------------------
                , v.GDQ_SO , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID  
                , DECODE(NVL(v.GQD_LOAIKETQUA,5), 4, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3, cast(v.GQD_KETQUA as varchar2(250))) KQ_GQD
                ,CASE WHEN v.GQD_LOAIKETQUA=3 THEN v.GQD_KETQUA
                     else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS              
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, ' (CA)', 1, 'VKS')
                  end LoaiKN  
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  
                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                ,NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
                -------------------------------
                , NVL(v.IsHoSo,0) IsHoSo, v.NGAYTTVNHAN_THS
                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                , GDTTT_ToTrinh_TraToTrinh(v.ID, 'LDVU',0) TraToTrinh
                ------------------------
                , v.SOTHULYXXGDT
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                 , NVL(v.LoaiAn, 0) LoaiAn
                , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
              ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS          
              from GDTTT_VUAN v 
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
               ----anhvh
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
               --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
                LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              ----
              where v.TOAANID=vToaAnID 
                And (NVL(vPhongBanID,0)=0 Or v.PhongBanID=vPhongBanID)
                And NVL(V.ISVIENTRUONGKN,0) = 0
                And (NVL(vloaian,0) = 0 Or vloaian = v.LOAIAN) 
               --Đã đăng ký báo cáo Tổ thẩm phán   
                And EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and TinhTrangID = 9 and ngaytra >= tt_tungay and  ngaytra <= vvtt_denngay)
                -- Chưa có kết quả đến ngày 
                --And v.NGAYTAO<=vvtt_denngay 
                And ((v.gqd_loaiketqua in (0,1,2,3,4) and VA.GQD_NGACVS> vvtt_denngay AND VA.GQD_NGACVS IS NOT NULL) 
                    OR v.gqd_loaiketqua IS NULL ) 
            )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <!--td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULYDON||'<br/>'||item.NGAYTHULYDON||'</td-->
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'<br/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
         if(vLoaiAn=1)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br/>'||item.BIDON;
                ELSE
                 V_BIDON_CHECK:=replace(item.NGUYENDON||item.BIDON,',','');
                END IF;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENLANHDAO||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENTHAMPHAN||'</td>');
       -------------------------     
       select g.ghichu into v_ghichu  from(
             select vuanid, LISTAGG(to_char(NGAYTRINH,'dd/MM/yyyy')||
            ' '||
            REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án','')||
            decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,'Chánh án',' TP ')) ||
            (select hoten from DM_CANBO  where id = lanhdaoid) ||

            ';'||
            to_char(NGAYTRA,'dd/MM/yyyy')||
            decode(NGAYTRA, null,'',decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,'Chánh án',' TP '))) ||
            decode(NGAYTRA, null,'',(select hoten from DM_CANBO  where id = lanhdaoid)) || 
            decode(loaiykien,1,' duyệt KN ',0,'duyệt TLĐ ',loaiykien)||
            decode(loaiykien,null,' '||YKIEN,null)                 
             , '; ' ) WITHIN GROUP( ORDER BY NGAYTRA DESC ) AS GHICHU  
                        from  (SELECT SS.* FROM GDTTT_TOTRINH SS WHERE  SS.VUANID = item.id AND SS.TINHTRANGID>=7
                                                  ORDER BY SS.NGAYTRINH ASC) a group by vuanid) g; 
     ---------------
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'    
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">- '||v_ghichu||'</td>');
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'                
            </tr>
        ');
  END LOOP;
  IF(vLanhdao!=0)THEN
            SELECT '<br/><span style="font-weight:100">Lãnh đạo phụ trách: '||cb.HOTEN||'</span>' INTO v_vLanhdao_ten FROM DM_CANBO cb WHERE ID=vLanhdao;
           -- FETCH FIRST 1 ROWS ONLY;
    END IF;
    ---lấy vụ trưởng,--432 vụ trưởng
   SELECT count(*) INTO v_count FROM DM_CANBO CB WHERE CB.CHUCVUID=432 AND CB.PHONGBANID=vPhongBanID AND CB.HIEULUC=1;
     if(v_count>0)then
      SELECT CB.HOTEN INTO V_LANHDAO FROM DM_CANBO CB WHERE CB.CHUCVUID=432 AND CB.PHONGBANID=vPhongBanID AND CB.HIEULUC=1;
    end if;
   ------Lấy loại án tên cho tiêu đề báo cáo------------
    if(vLoaiAn=0)then
    Select replace(DECODE(c.ISHINHSU,1,','||1||',','')||DECODE(c.ISDANSU,1,','||2||',','')|| DECODE(c.ISHNGD,1,','||3||',','')||DECODE(c.ISKDTM,1,','||4||',','')||DECODE(c.ISHANHCHINH,1,','||6||',','')||DECODE(c.ISLAODONG,1,','||5||',',''),',,',',')
        INTO vvloaian_s From DM_PHONGBAN c where c.id=vPhongBanID;
     ELSE
     vvloaian_s:=','||replace(vLoaiAn,'0')||',';
    END IF;
    SELECT LISTAGG(upper(LA.LOAI_AN_TEN), ', ')  WITHIN GROUP (ORDER BY LA.THUTU) INTO vvloaian_ten
    FROM DM_LOAIAN LA
    WHERE instr(vvloaian_s,','||LA.id||',')>0;
    --------------------
    SELECT DECODE(vPhongBanID,2,'I',3,'II',4,'III',NULL) INTO V_TEN_PHONGBAN_SUB FROM DUAL;
    -------TẠO BÁO CÁO
    IF(vThamtravien!=0)THEN
        SELECT II.TEN||': '||CB.HOTEN INTO vvThamtravien FROM DM_CANBO CB 
        INNER JOIN (select i.ID, i.TEN from DM_DATAITEM i where i.GROUPID=12)II ON II.ID=CB.CHUCDANHID
        WHERE CB.ID=vThamtravien;
     END IF;
--    SELECT DECODE(isTTYKienKLTotrinh,0,'chưa duyệt',1,'đã duyệt',null) into vvisTTYKienKLTotrinh from dual;
--    SELECT DECODE(vLoaiAn,01,'Tội danh','Quan hệ pháp luật') INTO vLoaiAn_name FROM DUAL;
    -----------
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
                            <th style="text-align: left; padding-left: 2px">M TRA '||V_TEN_PHONGBAN_SUB||'</th>
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
         ');
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="15" style="height: 0pt;"></td>
            </tr>
            <tr>');
           DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
            <td colspan="15" style="line-height: 100%; font-size: 14pt"><b>DANH SÁCH CÁC VỤ ÁN '||vvloaian_ten||' ĐĂNG KÝ BÁO CÁO TỔ THẨM PHÁN '||vvloaian_ten||'</b>');


            IF (tt_tungay is not null and tt_denngay is not null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br />
                        <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(tt_tungay,'dd/MM/yyyy')||'  đến ngày '||to_char(tt_denngay,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            elsif (tt_tungay is null and tt_denngay is not null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br />
                        <i style="font-size: 12pt;">(Số liệu đến ngày '||to_char(tt_denngay,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            elsif (tt_tungay is not null and tt_denngay is null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br />
                        <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(tt_tungay,'dd/MM/yyyy')||'  đến ngày '||to_char(sysdate,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            else
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br />
                        <i style="font-size: 12pt;">(Số liệu tính đến ngày '||to_char(sysdate,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            end if;
            IF(vThamtravien!=0)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">'||vvThamtravien||'</td>
            </tr>
            ');
            END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">Tổng số tờ trình '||vvisTTYKienKLTotrinh||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bản án
                    <br />
                    số và ngày </td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án xử</td>
                 '); 
            if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị cáo</td>             
            ');   
            ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn/ Người khởi kiện</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn/ Người bị kiện</td>
               ');   
            END IF;

            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Lãnh đạo vụ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm phán</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            ');  
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="height: 10pt;">
                <td style="width: 20pt"></td> 
                 ');
             if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="width: 100pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 170pt"></td>
                 ');
             else
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'   
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 170pt"></td>
                 ');
             end if;
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'  
            </tr>
        </table>
      ');   
       -----------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="vertical-align: top;text-align:left;font-size: 10pt;"> NLBC:'||TO_CHAR(sysdate,'dd/MM/yyyy HH24:MI:SS')||'</td>
                <td>
                    <p>
                        <strong>Vụ trưởng</strong>
                        <br />
                        <i style="font-size: 13pt;">(Ký và ghi rõ họ tên)</i>
                    </p>
                   <br /><br /><br /><br /><br />
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
        </table> ');
 --------------------------------      
      OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_QLTOTRINH_BC10;
FUNCTION  GDTTTT_QLTOTRINH_BC11
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  tt_tungay in date,
  tt_denngay in date,
  vSoThuly in varchar2, 
  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,
  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  vKetquathuly in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vNgayTrinh VARCHAR2(150);vvThamtravien VARCHAR2(150):=NULL;
  vtt_denngay date;vvloaian VARCHAR2(150);vvngaythulyden date;vvtt_denngay date;
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvisTTYKienKLTotrinh varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(250);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;v_vLanhdao_ten VARCHAR2(250):=NULL;
   v_ghichu varchar2(2000);v_count_yk number;vvloaian_ten VARCHAR2(500);vvloaian_s VARCHAR2(150);V_TEN_PHONGBAN_SUB  VARCHAR2(150);
   V_LANHDAO varchar2(150):=NULL;v_count number;
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
   -----
   SELECT DECODE(tt_denngay,null,sysdate,to_date(to_char(tt_denngay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvtt_denngay from dual;
   -------------------------
 v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
  -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,tt_denngay,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,tt_denngay,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
     -------------------------------------
    FOR item IN (
      select a.*
			from (
            Select  Count(v.ID) OVER () as CountAll ,ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT 
                , NVL(v.TongDon,0 ) as TongDon
                  --anhvh
                ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ,v.NGUYENDON,v.BIDON,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,(SOANPHUCTHAM || chr(10)||DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))) TTBANANPT
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --
                , NVL(qhpl.TENQHPL, Replace(TenVuAn,(NguyenDon ||' - '))) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,ttv.HOTEN as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                 ----------anhvh 12/10/2019 
                ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                 ---------
                , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))
                  end QUATRINH_GHICHU
                ----------------------------------
                , v.GDQ_SO , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID  
                , DECODE(NVL(v.GQD_LOAIKETQUA,5), 4, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3, cast(v.GQD_KETQUA as varchar2(250))) KQ_GQD
                ,CASE WHEN v.GQD_LOAIKETQUA=3 THEN v.GQD_KETQUA
                     else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS              
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, ' (CA)', 1, 'VKS')
                  end LoaiKN  
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  
                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                ,NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
                -------------------------------
                , NVL(v.IsHoSo,0) IsHoSo, v.NGAYTTVNHAN_THS
                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                , GDTTT_ToTrinh_TraToTrinh(v.ID, 'LDVU',0) TraToTrinh
                ------------------------
                , v.SOTHULYXXGDT
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                 , NVL(v.LoaiAn, 0) LoaiAn
                , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
              ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS          
              from GDTTT_VUAN v 
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
               ----anhvh
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
               --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
                LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              ----
              where v.TOAANID=vToaAnID 
                And (NVL(vPhongBanID,0)=0 Or v.PhongBanID=vPhongBanID)
                And NVL(V.ISVIENTRUONGKN,0) = 0
                And (NVL(vloaian,0) = 0 Or vloaian = v.LOAIAN) 
               --Đã đăng ký báo cáo Tổ thẩm phán   TinhTrangID = 8
                And EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and TinhTrangID = 8 and NGAYDK is not null  and NGAYDK <= tt_tungay and  ngaytrinh <= vvtt_denngay )
                -- Chưa có kết quả đến ngày 
                And v.NGAYTAO<=vvtt_denngay 
                And ((v.gqd_loaiketqua in (0,1,2,3,4) and VA.GQD_NGACVS> vvtt_denngay AND VA.GQD_NGACVS IS NOT NULL) 
                    OR v.gqd_loaiketqua IS NULL ) 
            )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <!--td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULYDON||'<br/>'||item.NGAYTHULYDON||'</td-->
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'<br/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
         if(vLoaiAn=1)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br/>'||item.BIDON;
                ELSE
                 V_BIDON_CHECK:=replace(item.NGUYENDON||item.BIDON,',','');
                END IF;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENLANHDAO||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENTHAMPHAN||'</td>');
       -------------------------     
       select g.ghichu into v_ghichu  from(
             select vuanid, LISTAGG(to_char(NGAYTRINH,'dd/MM/yyyy')||
            ' '||
            REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án','')||
            decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,'Chánh án',' TP ')) ||
            (select hoten from DM_CANBO  where id = lanhdaoid) ||

            ';'||
            to_char(NGAYTRA,'dd/MM/yyyy')||
            decode(NGAYTRA, null,'',decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,'Chánh án',' TP '))) ||
            decode(NGAYTRA, null,'',(select hoten from DM_CANBO  where id = lanhdaoid)) || 
            decode(loaiykien,1,' duyệt KN ',0,'duyệt TLĐ ',loaiykien)||
            decode(loaiykien,null,' '||YKIEN,null)                 
            , '; ' ) WITHIN GROUP( ORDER BY NGAYTRINH DESC ) AS GHICHU  
                        from  (SELECT SS.* FROM GDTTT_TOTRINH SS WHERE  SS.VUANID = item.id AND SS.TINHTRANGID>=7
                                                  ORDER BY SS.NGAYTRINH DESC) a group by vuanid) g; 
     ---------------
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'    
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">- '||v_ghichu||'</td>');
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'                
            </tr>
        ');
  END LOOP;
  IF(vLanhdao!=0)THEN
            SELECT '<br/><span style="font-weight:100">Lãnh đạo phụ trách: '||cb.HOTEN||'</span>' INTO v_vLanhdao_ten FROM DM_CANBO cb WHERE ID=vLanhdao;
           -- FETCH FIRST 1 ROWS ONLY;
    END IF;
    ---lấy vụ trưởng,--432 vụ trưởng
   SELECT count(*) INTO v_count FROM DM_CANBO CB WHERE CB.CHUCVUID=432 AND CB.PHONGBANID=vPhongBanID AND CB.HIEULUC=1;
     if(v_count>0)then
      SELECT CB.HOTEN INTO V_LANHDAO FROM DM_CANBO CB WHERE CB.CHUCVUID=432 AND CB.PHONGBANID=vPhongBanID AND CB.HIEULUC=1;
    end if;
    --------------------
    SELECT DECODE(vPhongBanID,2,'I',3,'II',4,'III',NULL) INTO V_TEN_PHONGBAN_SUB FROM DUAL;
    -------TẠO BÁO CÁO
    IF(vThamtravien!=0)THEN
        SELECT II.TEN||': '||CB.HOTEN INTO vvThamtravien FROM DM_CANBO CB 
        INNER JOIN (select i.ID, i.TEN from DM_DATAITEM i where i.GROUPID=12)II ON II.ID=CB.CHUCDANHID
        WHERE CB.ID=vThamtravien;
     END IF;
--    SELECT DECODE(isTTYKienKLTotrinh,0,'chưa duyệt',1,'đã duyệt',null) into vvisTTYKienKLTotrinh from dual;
--    SELECT DECODE(vLoaiAn,01,'Tội danh','Quan hệ pháp luật') INTO vLoaiAn_name FROM DUAL;
    -----------
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
                            <th style="text-align: left; padding-left: 2px">M TRA '||V_TEN_PHONGBAN_SUB||'</th>
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
         ');
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="15" style="height: 0pt;"></td>
            </tr>
            <tr>');
           DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
            <td colspan="15" style="line-height: 100%; font-size: 14pt"><b>DANH SÁCH CÁC VỤ ÁN BÁO CÁO CHÁNH ÁN</b>');


            IF (tt_tungay is not null and tt_denngay is not null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br />
                        <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(tt_tungay,'dd/MM/yyyy')||'  đến ngày '||to_char(tt_denngay,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            elsif (tt_tungay is null and tt_denngay is not null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br />
                        <i style="font-size: 12pt;">(Số liệu đến ngày '||to_char(tt_denngay,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            elsif (tt_tungay is not null and tt_denngay is null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br />
                        <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(tt_tungay,'dd/MM/yyyy')||'  đến ngày '||to_char(sysdate,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            else
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br />
                        <i style="font-size: 12pt;">(Số liệu tính đến ngày '||to_char(sysdate,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            end if;
            IF(vThamtravien!=0)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">'||vvThamtravien||'</td>
            </tr>
            ');
            END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">Tổng số tờ trình '||vvisTTYKienKLTotrinh||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bản án
                    <br />
                    số và ngày </td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án xử</td>
                 '); 
            if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị cáo</td>             
            ');   
            ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn/ Người khởi kiện</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn/ Người bị kiện</td>
               ');   
            END IF;

            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Lãnh đạo vụ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm phán</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            ');  
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="height: 10pt;">
                <td style="width: 20pt"></td> 
                 ');
             if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="width: 100pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 170pt"></td>
                 ');
             else
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'   
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 170pt"></td>
                 ');
             end if;
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'  
            </tr>
        </table>
      ');   
       -----------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="vertical-align: top;text-align:left;font-size: 10pt;"> NLBC:'||TO_CHAR(sysdate,'dd/MM/yyyy HH24:MI:SS')||'</td>
                <td>
                    <p>
                        <strong>Vụ trưởng</strong>
                        <br />
                        <i style="font-size: 13pt;">(Ký và ghi rõ họ tên)</i>
                    </p>
                   <br /><br /><br /><br /><br />
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
        </table> ');
 --------------------------------      
      OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_QLTOTRINH_BC11;
END PKG_VGDKT_BAOCAO_TT;
