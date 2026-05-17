create or replace NONEDITIONABLE PACKAGE BODY PKG_GDTTT_HCTP_BC_CC AS
PROCEDURE DON_GETTHEOKETQUAID
( 
    vToaAnID in number,  
    vKetQuaID in number,
    vToaRaBAQD in number,
    vSoBAQD in varchar2,
    vNgayBAQD in varchar2,
    vNguoiGui in varchar2,
    vNgayThuly in varchar2,
    vSoThuly in varchar2,
    vThamphanID in number,
    curReturn OUT sys_refcursor
)
IS 
    V_TENPHONGBANGUI     VARCHAR2 (500);V_TENDONVI  VARCHAR2 (500);V_TENDONVI_FULL varchar2(250);V_DONVI_CV varchar2(250);
   MININDEX             NUMBER; V_EXPORT_TEXT CLOB;VVNGAYNHAPTU  VARCHAR2 (250);
   VVNGAYNHAPDEN        VARCHAR2 (250);MAXINDEX   NUMBER;V_TABLE  T_DT_NOIBO_DANHSACH;
   V_BAQD_LOAIAN_NAME   CLOB;V_NOICHUYEN  CLOB;V_CD_SOCV  VARCHAR2 (500);
   V_CD_NGUOIKY         VARCHAR2 (250);V_CD_NGAYCV  VARCHAR2 (250);
   V_ID                 NUMBER; V_CAPCHAID  NUMBER;V_CD_SOTOTRINH  VARCHAR2 (500);
   V_CD_NGAYTOTRINH     VARCHAR2 (250);V_SOCV_TEMP  VARCHAR2 (500);
   V_CD_NGUOIKY_TEMP    VARCHAR2 (500);V_NGUOIGUI           VARCHAR2 (500);
   V_TL_SO_TEMP         VARCHAR2 (500);V_TENTHAMPHAN        VARCHAR2 (500);
   V_TT                 NUMBER;V_TT_TP   NUMBER;COUNT_TP   NUMBER;V_COUNT NUMBER;
BEGIN
    DBMS_LOB.CREATETEMPORARY (V_EXPORT_TEXT, TRUE);
    v_table := T_DT_NOIBO_DANHSACH ();
----------------------
   FOR item IN ( Select ROW_NUMBER() OVER (ORDER BY cast(NVL(d.TL_SO,'0') as number)) STT, k.ID,d.NGUOIGUI_HOTEN,d.NGAYNHANDON,d.NGAYGHITRENDON,d.MADON
                , case d.LOAIDON when 1 then 'Đơn' when 2 then 'Đơn tố cáo' when 3 then 'Đơn + Công văn' end as HinhThuc
                ,(Select TENPHONGBAN from DM_PHONGBAN where ID=d.CD_TA_DONVIID) NOICHUYEN
                ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) BAQD
                ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
                ,(Case d.BAQD_LOAIQDBA When 0 then  (Select MA_TEN from DM_TOAAN where ID=decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID))
                Else (Select TEN from DM_DATAITEM where ID=d.NGUOIKHANGNGHI)
                END) TOAXX
                , decode(d.BAQD_SO_ST,null,'',(d.BAQD_SO_ST||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||' '|| txxST.MA_TEN)) Infor_ST
                , decode(d.BAQD_SO_PT,null,'',(d.BAQD_SO_PT||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||' '|| txxPT.MA_TEN)) Infor_PT
                ,d.BAQD_CAPXETXU,d.BAQD_SO_PT,d.BAQD_SO_ST,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
                ,d.CV_TENDONVI,c1.HOTEN TENTHAMPHAN ,c2.HOTEN TENTHAMPHANSUA,d.NGUOIGUI_HUYENID
                ,k.CANBOID,CANBOID_SUA,k.GHICHU
                ,d.TL_SO,d.TL_NGAY, d.CD_SOTOTRINH
                ,decode(d.CD_NGAYTOTRINH,null,null,to_char(d.CD_NGAYTOTRINH,'dd/MM/yyyy')) CD_NGAYTOTRINH
                , decode(k.NGAYPHANCONGTP,null,to_char(kq.NGAYPHANCONG,'dd/MM/yyyy'),to_char(k.NGAYPHANCONGTP,'dd/MM/yyyy')) NGAYPHANCONGTP
                ,GDTTT_PCTP_GetAll_BY_DON(K.DONID) PhanCongTP
                ,(select count(id) from gdttt_vuan where id = d.VUVIECID) CHECK_VUAN
                ------------------------
                ,d.CD_NGUOIKY,d.BAQD_LOAIAN,d.DONGKHIEUNAI,d.LOAIDON,d.CV_SO,d.CV_NGAY
                ,(CASE WHEN d.NGUOIGUI_HUYENID = 981 THEN d.NGUOIGUI_DIACHI ELSE d.NGUOIGUI_DIACHI || (CASE WHEN (d.NGUOIGUI_DIACHI || ' ') = ' ' THEN ' 'ELSE ', 'END)|| h.MA_TEN END)Diachigui
                ,(CASE WHEN d.ISTHULY = 1 THEN 'block' WHEN (d.CD_TA_TRANGTHAI = 0 AND d.ISTHULY IS NULL) THEN 'block' ELSE 'none' END)IsShowTLMOI
      From GDTTT_PCTP_CHITIET k 
            Inner join GDTTT_DON d on k.DONID=d.ID
            LEFT JOIN (SELECT id, MA_TEN FROM DM_HANHCHINH) h  ON d.NGUOIGUI_HUYENID = h.ID
            left join GDTTT_PCTP_KETQUA kq on kq.id = k.KETQUAID
            left join DM_CANBO c1 on c1.ID=k.CANBOID
            left join DM_CANBO c2 on c2.ID=k.CANBOID_SUA
            left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
            left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
            left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
                  WHere k.KETQUAID=vKetQuaID
                        and 1=case when vToaRaBAQD=0 then 1 when (d.BAQD_TOAANID=vToaRaBAQD 
                                                            Or d.BAQD_TOAANID_PT=vToaRaBAQD
                                                            Or d.BAQD_TOAANID_ST=vToaRaBAQD)
                                                        then 1 else 0 end        
                        and 1=case when vSoBAQD || ' '=' ' then 1 when ( lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                                                    Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                                                    Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                                                    Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
                        and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD 
                                                                Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                                Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                                Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end              
                        and 1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
                        and 1=case when vThamphanID=0 then 1 when d.THAMPHANID=vThamphanID then 1 else 0 end
                        and  1=case when vNgayThuly || ' '=' ' then 1 when to_char(d.TL_NGAY,'dd/MM/yyyy')=vNgayThuly  then 1 else 0 end
        )
    LOOP
            V_NGUOIGUI:=item.DONGKHIEUNAI;
            IF(item.LOAIDON=3)THEN
               V_NGUOIGUI:= V_NGUOIGUI||' (Do ' ||item.CV_TENDONVI||' chuyển đến theo Công văn số '||item.CV_SO
               ||' ngày '||TO_CHAR(item.CV_NGAY,'dd/MM/yyyy')||')';
            ELSIF(item.LOAIDON=2)THEN
               V_NGUOIGUI:= V_NGUOIGUI||' (Công văn số '||item.CV_SO||' ngày '||TO_CHAR(item.CV_NGAY,'dd/MM/yyyy')||')';
            END IF;
         -----------
          IF(item.IsShowTLMOI= 'none')THEN
              V_TL_SO_TEMP:='';
            ELSE
                 IF(LENGTH(item.TL_SO)=1)THEN
                     V_TL_SO_TEMP:='0'||item.TL_SO;
                     ELSIF(LENGTH(item.TL_SO)>1)THEN
                     V_TL_SO_TEMP:=item.TL_SO;
                    END IF;
            END IF;
        SELECT DECODE (item.TENTHAMPHAN,NULL, NULL,'TP: <b>'||item.TENTHAMPHAN||'</b>')INTO V_TENTHAMPHAN FROM DUAL;
        -------------
        v_table.EXTEND;
        v_table(v_table.COUNT) := R_DT_NOIBO_DANHSACH(
        item.STT,V_NGUOIGUI,item.DIACHIGUI,item.BAQD,TO_CHAR(item.BAQD_NGAYBA,'dd/MM/yyyy'),
        item.TOAXX,NULL,NULL,NULL,NULL,
        item.GHICHU,NULL,NULL,item.CD_SOTOTRINH,NULL,
        NULL,NULL,V_TENTHAMPHAN,V_TL_SO_TEMP,TO_CHAR(item.TL_NGAY,'dd/MM/yyyy'),
        TO_CHAR(item.NGAYNHANDON,'dd/MM/yyyy'),NULL,NULL,item.CD_NGUOIKY,NULL,
        item.BAQD_LOAIAN,item.CD_NGAYTOTRINH,NULL,NULL,NULL,
        NULL
        );
        -------------
    END LOOP;
--Insert số trang
 SELECT UPPER(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao','TANDCC')),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
     INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL FROM DM_TOAAN TA WHERE TA.ID=vToaAnID;
     
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
       -----THAM PHAN IS NOT NULL
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
                    <td colspan="11" style="text-align: center; vertical-align: middle; font-size: 14pt;">Danh sách đơn thụ lý '||vvNgayNhapTu||vvNgayNhapDen||'
                    <br />
                        và phân công Thẩm phán theo dõi, giải quyết
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
               FOR item IN(
                         SELECT PA.* FROM TABLE(V_TABLE)PA WHERE PA.TENTHAMPHAN IS NOT NULL 
                         ORDER BY cast(NVL(PA.SOTHULY,'0') as number)
                         --ORDER BY regexp_replace(SOTHULY, '[^[:digit:]]', '')
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
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||SUBSTR(item.BA_SO,0,INSTR(item.BA_SO, '/',1,2)-1)||' '||SUBSTR(item.BA_SO,INSTR(item.BA_SO, '/',-1))||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.BA_NGAY||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.BA_TOAXX||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.TENTHAMPHAN||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.GHICHU||'</td>
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
------------------------------------------
       OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
       dbms_lob.freetemporary(V_EXPORT_TEXT);
END DON_GETTHEOKETQUAID;
PROCEDURE DON_SEARCH_DS_VB_CC
(  
    vArrSelectID in varchar2,
    v_ID_USER in NUMBER,
    curReturn OUT sys_refcursor
)
IS 
    V_EXPORT_TEXT CLOB;
    V_TT NUMBER;
    V_TABLE T_NOIBO_DANHSACH_VB_HC_TL;
    V_TENPHONGBAN VARCHAR2(500);
    
    V_VB_SO VARCHAR2(250);
    V_VB_NGAY DATE;
    V_NGUOIGUI VARCHAR2(500);
    V_NGUOIGUI_DIACHI VARCHAR2(500);
    V_NOIDUNGDON VARCHAR2(500);
    V_BAQD_SO VARCHAR2(250);
    V_BAQD_NGAY DATE;
    V_TOAANXX VARCHAR2(500);
    
    V_NGUOITAO VARCHAR2(100);
    V_DONVIID number;
    
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
 V_TABLE := T_NOIBO_DANHSACH_VB_HC_TL();
 
    SELECT DONVIID INTO V_DONVIID FROM QT_NGUOISUDUNG
    WHERE ID = v_ID_USER;
    
IF (vArrSelectID IS NOT NULL) THEN
FOR ITEM IN(SELECT  D.CV_SO, D.CV_NGAY,
                    D.NGUOIGUI_HOTEN,D.NGUOIGUI_DIACHI,D.NGUOIGUI_HUYENID,D.NGUOIGUI_TINHID,DMHANHCHINH.MA_TEN NGUOIGUI_DM_HANHCHINH,
                    D.NOIDUNGDON,
                    D.BAQD_CAPXETXU,D.BAQD_SO_ST, D.BAQD_SO_PT, D.BAQD_SO,
                    D.BAQD_NGAYBA,D.BAQD_NGAYBA_ST,D.BAQD_NGAYBA_PT,
                    TAGGDT.MA_TEN BAQD_TENTOA_GDT,TAGST.MA_TEN BAQD_TENTOA_ST,TAGPT.MA_TEN BAQD_TENTOA_PT,
                    DMPHONGBAN.TENPHONGBAN
            FROM GDTTT_DON D 
                LEFT JOIN (SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU) LA ON LA.ID=D.BAQD_LOAIAN
                LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAGGDT ON TAGGDT.ID = D.BAQD_TOAANID
                LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAGST ON TAGST.ID = D.BAQD_TOAANID_ST
                LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAGPT ON TAGPT.ID = D.BAQD_TOAANID_PT
                LEFT JOIN (SELECT ID,MA_TEN FROM DM_HANHCHINH) DMHANHCHINH ON DMHANHCHINH.ID = D.NGUOIGUI_HUYENID
                LEFT JOIN (SELECT ID,TENPHONGBAN FROM DM_PHONGBAN) DMPHONGBAN ON DMPHONGBAN.ID = D.CD_TA_DONVIID
            WHERE (vArrSelectID  || ' '=' ' Or vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%') 
            ORDER BY D.NGAYTAO desc
        )
LOOP
    V_VB_SO := NULL;
    V_VB_NGAY := NULL;
    V_NGUOIGUI := NULL;
    V_NGUOIGUI_DIACHI := NULL;
    V_NOIDUNGDON := NULL;
    V_BAQD_SO := NULL;
    V_BAQD_NGAY := NULL;
    V_TOAANXX := NULL;
    V_TENPHONGBAN := item.TENPHONGBAN;
         IF (item.CV_SO IS NOT NULL)THEN
              V_VB_SO:= item.CV_SO;
                    END IF;
         IF (item.CV_NGAY IS NOT NULL)THEN
              V_VB_NGAY:= item.CV_NGAY;
              else V_VB_NGAY:= null;
                    END IF;
         IF (item.NGUOIGUI_HOTEN IS NOT NULL)THEN
              V_NGUOIGUI:= item.NGUOIGUI_HOTEN;
                    END IF;
         IF (item.NGUOIGUI_DIACHI IS NOT NULL)THEN
              V_NGUOIGUI_DIACHI:=CONCAT(ITEM.NGUOIGUI_DIACHI,', ');
              V_NGUOIGUI_DIACHI:=CONCAT(V_NGUOIGUI_DIACHI,ITEM.NGUOIGUI_DM_HANHCHINH);
                    END IF;
         IF (item.NOIDUNGDON IS NOT NULL)THEN
              V_NOIDUNGDON:= item.NOIDUNGDON;
                    END IF;                 
         IF (item.BAQD_CAPXETXU = 2) THEN
                        V_BAQD_SO := ITEM.BAQD_SO_ST;
                        V_TOAANXX := REPLACE(item.BAQD_TENTOA_ST,'Tòa án nhân dân','TAND');
                        V_BAQD_NGAY := item.BAQD_NGAYBA_ST;
                    ELSIF (item.BAQD_CAPXETXU = 3) THEN
                        V_BAQD_SO := ITEM.BAQD_SO_PT;
                        V_TOAANXX := REPLACE(item.BAQD_TENTOA_PT,'Tòa án nhân dân','TAND');
                        V_BAQD_NGAY := item.BAQD_NGAYBA_PT;
                    ELSIF (item.BAQD_CAPXETXU = 4) THEN
                        V_BAQD_SO := ITEM.BAQD_SO;
                        V_TOAANXX := REPLACE(item.BAQD_TENTOA_GDT,'Tòa án nhân dân','TAND');
                        V_BAQD_NGAY := item.BAQD_NGAYBA;
                    END IF;   
    V_TABLE.extend;
    V_TABLE(v_table.count) := R_NOIBO_DANHSACH_VB_HC_TL(V_VB_SO,V_VB_NGAY,V_NGUOIGUI,V_NGUOIGUI_DIACHI,V_NOIDUNGDON,V_BAQD_SO,V_BAQD_NGAY,V_TOAANXX);
END LOOP; 
        
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
        <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
            <tr>
                <td colspan="5" style="text-align: center; vertical-align: top; font-size: 12pt"> TANDCC ');
                            IF(V_DONVIID = 4) THEN 
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'TẠI HÀ NỘI');
                                ELSIF(V_DONVIID = 5) THEN 
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'TẠI ĐÀ NẴNG');
                                ELSIF(V_DONVIID = 6) THEN 
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'TẠI THÀNH PHỐ HỒ CHÍ MINH');
                            END IF;
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                </td>
                <td colspan="2"></td>
                <th colspan="5" style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr style="text-align: center;">
                <th colspan="5" style="vertical-align: top; font-size: 13pt; text-decoration: underline;">VĂN PHÒNG</th>
                <td colspan="2"></td>
                <th colspan="5" style="vertical-align: top;font-size: 13pt; text-decoration: underline;">Độc lập - Tự do - Hạnh phúc </th>
            </tr>
            <tr>
                <td colspan="12"></td>
            </tr>
            <tr align="center" style="text-align: center; font-weight: bold">
                <td colspan="12" style="text-align: center; vertical-align: middle; font-size: 14pt;">Danh sách Văn bản hành chính, tài liệu chung
                    <br/> của Văn phòng chuyển '||V_TENPHONGBAN||'
                    <br/>
                        <span style="font-size: 14pt; font-weight: normal; font-style: italic;">(Gửi kèm theo Công văn số /TANDCC-VP ngày của Toà án nhân dân cấp cao tại thành phố Hồ Chí Minh)</span>
                </td>
            </tr>
            <tr>
                <td colspan="12" style="height:10px;"></td>
            </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">TT</td>
                <td colspan="2" rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số/ngày văn bản</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Người gửi/đơn vị gửi</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Địa chỉ</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Nội dung văn bản</td>
                <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:30px;">QĐ/BA đề nghị xem xét</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Người nhận</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ghi chú</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ký nhận</td>
            </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:65px;">Số BA/QĐ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày BA/QĐ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tòa án Xét xử</td>
            </tr>       
        ');
        
        V_TT:=0;
        FOR item IN(SELECT COUNT(*) OVER () as CountAll,PA.*  FROM TABLE(V_TABLE) PA)
        LOOP
        V_TT:=V_TT+1;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr align="center" style="text-align: center;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||V_TT||'</td>
                <td colspan=2 style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.VB_SO||' '||TO_CHAR(item.VB_NGAY,'dd/mm/rrrr')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.NGUOIGUI||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.NGUOIGUI_DIACHI||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.NOIDUNGDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.BAQD_SO||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||TO_CHAR(ITEM.BAQD_NGAY,'dd/mm/rrrr')||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.TOAANXX||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;"></td>
            </tr>
        ');   
        END LOOP;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr>
                <td colspan="11" style="height:10px;"></td>
            </tr>
            <tr align="center" style="text-align: center;">
                <td colspan="3" style="vertical-align: top; font-style: italic;">Tổng số:</td>
                <td colspan="1" style="vertical-align: top; text-align: left; font-weight: bold;">'||V_TT||'</td>
                <td colspan="4" style="vertical-align: top;">
                    <span style="font-weight: bold;">Xác nhận của '||V_TENPHONGBAN||'</span><br/>
                    <span style="font-style: italic">(Ký ghi rõ họ tên)</span>
                </td>
                <td colspan="1" style="vertical-align: top;"></td>
                <td colspan="3">
                    <p style="font-size: 13pt;">
                        <strong>KT. CHÁNH VĂN PHÒNG<br/>
                                PHÓ CHÁNH VĂN PHÒNG<br/>
                        </strong>
                    </p>
                </td>
            </tr>
            
            <tr style="height: 0px;">
                <td style="width: 26px"></td>
                <td style="width: 35px"></td>
                <td style="width: 35px"></td>
                <td style="width: 90px"></td>
                <td style="width: 150px"></td>
                <td style="width: 150px"></td>
                <td style="width: 59px"></td>
                <td style="width: 78px"></td>
                <td style="width: 59px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
                <td style="width: 90px"></td>
            </tr>
        </table>
            ');
    END IF;
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
END DON_SEARCH_DS_VB_CC;

PROCEDURE DON_SEARCH_DS_TL_MOI_CC
( 
  V_BC_NGAYDK       VARCHAR2,
  V_BC_NGUOIKY      VARCHAR2,
  V_BC_SOCV         VARCHAR2,
  V_ID_USER         VARCHAR2,
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
  VLOAISOVB         in varchar2,
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
  PAGEINDEX         IN    INT,
  PAGESIZE          IN    INT,
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
  V_TABLE               T_DT_NOIBO_DANHSACH_CC;
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
  V_NGUOIGUI            VARCHAR2(2000);
  V_TL_SO_TEMP          VARCHAR2(500);
  V_TENTHAMPHAN         VARCHAR2(500);
  V_TT                  NUMBER;
  V_SODON_TONG          NUMBER;
  V_TENPHONGBANNHAN     VARCHAR2(500);
  V_COUNT               NUMBER;   
  V_DONVICHUYEN_HSKN    VARCHAR2(500);
  V_DIAPHUONG           CLOB;
  V_TONGSODON NUMBER;   
  V_QUANHEPHAPLUAT VARCHAR2(2500);

BEGIN
  DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,TRUE);V_TABLE := T_DT_NOIBO_DANHSACH_CC();
  -------
  IF(VLOAICVID!=-1 AND VLOAICVID!=0) THEN
       SELECT DT.ID,DT.CAPCHAID INTO V_ID,V_CAPCHAID FROM DM_DATAITEM DT WHERE DT.ID=VLOAICVID; 
    END IF;  
  FOR ITEM IN (
          SELECT  ROW_NUMBER() OVER (ORDER BY D.NGAYTAO DESC) STT,D.ID
                  ,D.MADON, D.SOHIEUDON, D.NGUOIGUI_HOTEN, D.SOTHUTUDON, D.NGAYNHANDON
                  ,CASE WHEN (LENGTH(NVL(D.BAQD_NGAYBA,''))=0 OR (TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) THEN ''
                        WHEN LENGTH(NVL(D.BAQD_NGAYBA,'')) >0 THEN TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')
                        END  NGAYBA_PT  
                  ,D.LOAIDON,NVL(D.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,D.QHPL_TEXT
                  ,D.NGUOITAO NGUOINHAP,D.DONGKHIEUNAI,D.ISNOTGDTTT,D.NGUOISUA,D.NGAYSUA
                  ,D.NGAYTAO NGAYNHAP,TL_NGAY,TL_SO,D.ISSHOWFULL
                  ,CASE D.LOAIDON WHEN 1 THEN 'Đơn'
                                  WHEN 2 THEN 'Công văn' 
                                  WHEN 3 THEN 'Đơn + Công văn' 
                                  END AS HINHTHUC
                  ,(CASE WHEN D.NGUOIGUI_HUYENID=981 THEN NGUOIGUI_DIACHI ELSE D.NGUOIGUI_DIACHI ||(CASE WHEN (D.NGUOIGUI_DIACHI || ' ')=' '  THEN ' ' ELSE ', ' END) || H.MA_TEN END) DIACHIGUI
                  ,D.CV_SO,D.NGAYGHITRENDON
                  ,(CASE D.BAQD_LOAIQDBA WHEN 1 THEN D.KN_SOQD ELSE DECODE(D.BAQD_CAPXETXU,2,D.BAQD_SO_ST,3,D.BAQD_SO_PT, D.BAQD_SO) END) BAQD_SO
                  ,(CASE D.BAQD_LOAIQDBA WHEN 1 THEN ('QĐ: ' || D.KN_SOQD) ELSE DECODE(D.BAQD_CAPXETXU,2,('BA: ' || D.BAQD_SO_ST),3,('BA: ' || D.BAQD_SO_PT), ('BA: ' || D.BAQD_SO)) END) BAQD
                  ,D.CV_TENDONVI
                  ,(CASE D.BAQD_LOAIQDBA WHEN 1 THEN D.KN_NGAY ELSE DECODE(D.BAQD_CAPXETXU,2,D.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,D.BAQD_NGAYBA) END) BAQD_NGAYBA
                  ,(CASE D.BAQD_LOAIQDBA WHEN 1 THEN I.TEN ELSE TXX.MA_TEN END) TOAXX
                  ,DM_CANBO_TENTOAVT(TXX.MA_TEN) TOAXX_VIETTAT
                  ,D.NGUOIKHANGNGHI,D.GHICHU,D.DUNGDONLA,D.NGUOIGUI_GIOITINH
                  ,D.CD_TA_LYDO_ISBAQD,D.CD_TA_LYDO_ISXACNHAN,D.CD_TA_LYDO_ISKHAC,D.CV_NGAY,D.CV_DIACHI CVDIACHI,D.CD_TA_LYDO_KHAC,D.CHIDAO_COKHONG,D.CHIDAO_NOIDUNG
                  ,(CASE D.CD_LOAI  WHEN 0 THEN CAST(PB.TENPHONGBAN AS NVARCHAR2(250))
                                    WHEN 1 THEN CAST(TK.MA_TEN AS NVARCHAR2(250)) WHEN 2 THEN  CAST(D.CD_NTA_TENDONVI AS NVARCHAR2(250))
                                    WHEN 3 THEN  CAST('Trả lại đơn' AS NVARCHAR2(250))
                                    WHEN 4 THEN  CAST('Không chuyển' AS NVARCHAR2(250))  END ) NOICHUYEN
                  ,(CASE D.CD_TRANGTHAI WHEN 0 THEN 'Chưa chuyển'
                                        WHEN 1 THEN  'Đã chuyển'
                                        WHEN 2 THEN  'Đã nhận' 
                                        WHEN 3 THEN  'Bị trả lại' 
                                        ELSE 'Chưa chuyển'   END ) TRANGTHAICHUYEN
                  ,D.BAQD_LOAIAN,D.CD_TRALAI_LYDOID,D.CD_TRALAI_YEUCAU,C.HOTEN TENTHAMPHAN,TRIM(D.NOIDUNGTOMTAT) NOIDUNGTOMTAT,D.CD_TRALAI_LYDOKHAC
                  ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,NSD.GHICHU BIDANH
                    ,(SoCVC.SOVB || SoCVCN.SOVB) as CD_SOCV
                    ,Decode(SoCVC.NGAYVB,null,SoCVCN.NGAYVB,SoCVC.NGAYVB) as CD_NGAYCV
                    ,(SoCVC.NGUOIKY || SoCVCN.NGUOIKY)as CD_NGUOIKY
                    ,Decode(SOTT.SOVB,null,SOTT_TLL.SOVB,SOTT.SOVB) as CD_SOTOTRINH
                    ,Decode(SOTT.NGAYVB,null,SOTT_TLL.NGAYVB,SOTT.NGAYVB) as CD_NGAYTOTRINH
                    ,Decode(SOTT.SOVB,null,SOTT_TLL.SOVB,SOTT.SOVB) ||' - '||TO_CHAR(Decode(SOTT.NGAYVB,null,SOTT_TLL.NGAYVB,SOTT.NGAYVB),'dd/MM/yyyy')  as TOTRINH_SONGAY
                  ,D.THAMPHANID
                  ,(CASE D.CD_LOAI WHEN 0 THEN 'block' ELSE 'none' END) ISSHOWNB
                  ,(CASE D.CD_LOAI WHEN 0 THEN 'none' ELSE 'block' END) ISSHOWTK
                  ,(CASE D.CD_TA_TRANGTHAI WHEN 0 THEN 'block' ELSE 'none' END) ISSHOWDDK
                  ,(CASE D.CD_TA_TRANGTHAI WHEN 1 THEN 'block' ELSE 'none' END) ISSHOWCDDK
                  ,(CASE WHEN D.ISTHULY=1 THEN 'block' WHEN (D.CD_TA_TRANGTHAI=0 AND D.ISTHULY IS NULL) THEN 'block' ELSE 'none' END) ISSHOWTLMOI
                  ,(CASE D.ISTHULY WHEN 2 THEN 'block' ELSE 'none' END) ISSHOWDATL
                  ,D.PHANLOAIXULY
                  ,NVL(VA.GQD_LOAIKETQUA,4) GQD_LOAIKETQUA
                  ,CASE WHEN D.CD_LOAI= 0 AND NVL(D.VUVIECID, 0)>0 THEN CASE WHEN NVL(VA.GQD_LOAIKETQUA,4)=3 THEN ''
                                                                             WHEN NVL(VA.GQD_LOAIKETQUA,4)<>3 THEN (DECODE(NVL(VA.GQD_LOAIKETQUA,4), 4, 'Đang giải quyết' , 2, u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' )
                                                                                                                            || CASE WHEN LENGTH(NVL(VA.GDQ_SO, ''))>0 THEN ' số '||VA.GDQ_SO ELSE '' END 
                                                                                                                            || CASE WHEN (LENGTH(NVL(VA.GDQ_NGAY,''))=0  OR (TO_CHAR(VA.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) THEN ''
                                                                                                                                    WHEN LENGTH(NVL(VA.GDQ_NGAY,'')) >0  THEN ' ngày ' || TO_CHAR(VA.GDQ_NGAY,'dd/MM/yyyy') END 
                                                                                                                    ) END                      
                                                                   ELSE '' END  KQGQNOIBO,D.CV_TRALOI_NOIDUNG
                  ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,D.NGAYTAO, DONVICHUYEN.TEN DONVICHUYEN_NAME,D.SO_HSKN,D.NGAY_HSKN
                  ,D.NGUOIGUI_DIACHI,D.NGUOIGUI_HUYENID,D.NGUOIGUI_TINHID,DMHANHCHINH.MA_TEN NGUOIGUI_DM_HANHCHINH
                 ,DECODE(LENGTH(NKK.TENDUONGSU) , 0 , '' , 'NKK: ' || NKK.TENDUONGSU || '<br style="mso-data-placement:same-cell;" />') ||
                  DECODE(LENGTH(NBK.TENDUONGSU) , 0 , '' , 'NBK: ' || NBK.TENDUONGSU)
                  AS NKK_NBK
                 ,'' AS LYDOTHULY
                   
          FROM GDTTT_DON D
                 LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVC')SoCVC on SoCVC.donid = d.id 
                LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCN')SoCVCN on SoCVCN.donid = d.id
                LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT')SOTT on SOTT.donid = d.id
                LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT_TLL')SOTT_TLL on SOTT_TLL.donid = d.id
          
                  LEFT JOIN (SELECT T2.DONID, LISTAGG(TENDUONGSU,', ') WITHIN GROUP (ORDER BY T2.HS_BICANDAUVU DESC, T2.ID) AS TENDUONGSU
                             FROM GDTTT_DON_DUONGSU_CC T2
                             WHERE T2.TUCACHTOTUNG LIKE 'BIDON'
                             GROUP BY T2.DONID
                             ) NBK ON NBK.DONID = D.ID
                             
                  LEFT JOIN (SELECT T2.DONID, LISTAGG(TENDUONGSU,', ') WITHIN GROUP (ORDER BY T2.HS_BICANDAUVU DESC, T2.ID) AS TENDUONGSU
                             FROM GDTTT_DON_DUONGSU_CC T2
                             WHERE T2.TUCACHTOTUNG IN ('NGUYENDON','KHAC')
                             GROUP BY T2.DONID
                             ) NKK ON NKK.DONID = D.ID  
                             
                  LEFT JOIN (SELECT ID,MA_TEN FROM DM_HANHCHINH) DMHANHCHINH ON DMHANHCHINH.ID = D.NGUOIGUI_HUYENID
                  LEFT JOIN (SELECT ID,TEN FROM DM_VKS) DONVICHUYEN ON DONVICHUYEN.ID = D.DONVICHUYEN_HSKN
                  LEFT JOIN (SELECT ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY FROM GDTTT_VUAN) VA ON VA.ID = D.VUVIECID
                  LEFT JOIN (SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU )LA ON LA.ID=D.BAQD_LOAIAN
                  LEFT JOIN (SELECT ID,MA_TEN FROM DM_HANHCHINH) H ON D.NGUOIGUI_HUYENID=H.ID
                  LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TK ON D.CD_TK_DONVIID=TK.ID
                  LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TXX ON DECODE(D.BAQD_CAPXETXU,2,D.BAQD_TOAANID_ST,3,D.BAQD_TOAANID_PT,D.BAQD_TOAANID)=TXX.ID
                  LEFT JOIN (SELECT ID,TENPHONGBAN FROM DM_PHONGBAN) PB ON D.CD_TA_DONVIID=PB.ID
                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) C ON D.THAMPHANID=C.ID
                  LEFT JOIN (SELECT USERNAME,GHICHU FROM QT_NGUOISUDUNG) NSD ON NSD.USERNAME=D.NGUOITAO
                  LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) I ON D.NGUOIKHANGNGHI=I.ID
          WHERE (INSTR(VARRSELECTID,','||D.ID||',')>0)
        )
  LOOP
                IF (ITEM.DONVICHUYEN_NAME IS NOT NULL)THEN
                    IF(INSTR(ITEM.DONVICHUYEN_NAME,'Chánh án TANDTC') != 0) THEN
                            V_DONVICHUYEN_HSKN:= ITEM.DONVICHUYEN_NAME;
                        ELSIF(INSTR(ITEM.DONVICHUYEN_NAME,'Viện kiểm sát nhân dân cấp cao') != 0) THEN
                            V_DONVICHUYEN_HSKN:= CONCAT('Viện trưởng ',REPLACE(ITEM.DONVICHUYEN_NAME,'Viện kiểm sát nhân dân cấp cao','VKSNDCC'));
                        ELSIF(INSTR(ITEM.DONVICHUYEN_NAME,'Viện kiểm sát nhân dân tối cao') != 0) THEN
                            V_DONVICHUYEN_HSKN:= CONCAT('Viện trưởng ',ITEM.DONVICHUYEN_NAME);    
                    END IF;
                END IF;  
                 ------------------
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
           -----///26/10/2024
           V_QUANHEPHAPLUAT:='';
           if(ITEM.BAQD_LOAIAN=1) then
            SELECT T2.HS_TENTOIDANH into V_QUANHEPHAPLUAT  FROM (SELECT T2.DONID,T2.HS_TENTOIDANH,ROW_NUMBER() OVER (ORDER BY T2.HS_BICANDAUVU DESC, T2.ID) STT
                                          FROM GDTTT_DON_DUONGSU_CC T2
                                          WHERE T2.TUCACHTOTUNG LIKE 'BIDON' AND T2.DONID = ITEM.ID
                                          ORDER BY T2.HS_BICANDAUVU DESC, T2.ID) T2
                   WHERE t2.STT = 1;
            ELSE
             V_QUANHEPHAPLUAT:= ITEM.QHPL_TEXT;
           end if;               
            V_TONGSODON := 0;   
            SELECT COUNT(*)TONG_SODON INTO V_TONGSODON
            FROM GDTTT_DON CV 
            WHERE (CV.ID = ITEM.ID OR (CV.CD_TA_TRANGTHAI  IN (2,3) AND  CV.ARR_DON_ID= ITEM.ID) );
       ----------------------------- 
      SELECT DECODE(ITEM.TENTHAMPHAN,NULL,NULL,'Thẩm phán '||ITEM.TENTHAMPHAN) INTO V_TENTHAMPHAN FROM DUAL;  
                V_TABLE.EXTEND;
                V_TABLE(V_TABLE.COUNT) := R_DT_NOIBO_DANHSACH_CC(ITEM.STT,V_NGUOIGUI,ITEM.DIACHIGUI,ITEM.BAQD_SO,TO_CHAR(ITEM.BAQD_NGAYBA,'dd/MM/yyyy'),
                                                              ITEM.TOAXX,NULL,NULL,NULL,V_TONGSODON,
                                                              ITEM.GHICHU,NULL,ITEM.NOICHUYEN,ITEM.CD_SOTOTRINH,NULL,
                                                              NULL,NULL,V_TENTHAMPHAN,V_TL_SO_TEMP,TO_CHAR(ITEM.TL_NGAY,'dd/MM/yyyy'),
                                                              TO_CHAR(ITEM.NGAYNHANDON,'dd/MM/yyyy'),NULL,NULL,ITEM.CD_NGUOIKY,NULL,
                                                              ITEM.BAQD_LOAIAN,TO_CHAR(ITEM.CD_NGAYTOTRINH,'dd/MM/yyyy'),NULL,ITEM.NGAYTAO,ITEM.CD_SOCV,
                                                              TO_CHAR(ITEM.CD_NGAYCV,'dd/MM/yyyy'),
                                                              V_DONVICHUYEN_HSKN,ITEM.SO_HSKN,ITEM.NGAY_HSKN,ITEM.SOHIEUDON,
                                                              TO_NUMBER(ITEM.LOAIDON),ITEM.NKK_NBK,V_QUANHEPHAPLUAT,ITEM.LYDOTHULY
                                                              );
    END LOOP;

     --Truy vấn tạo dữ liệu báo cáo-------
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

  SELECT COUNT(*)INTO V_COUNT FROM DM_PHONGBAN PB INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=V_ID_USER);
  IF(V_COUNT>0)THEN   
      SELECT PB.TENPHONGBAN,TA.TEN INTO V_TENPHONGBANGUI,V_TENDONVI FROM DM_PHONGBAN PB INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=V_ID_USER);
    END IF;

  SELECT COUNT(*) INTO V_COUNT FROM TABLE(V_TABLE)PA WHERE PA.CD_SOCV IS NOT NULL ;    

    IF(V_COUNT>0)THEN
        SELECT DECODE(V_BC_SOCV,NULL,          PA.CD_SOCV,   V_BC_SOCV)    CD_SOCV
              ,DECODE(V_BC_NGAYDK,NULL,        PA.CD_NGAYCV, V_BC_NGAYDK)  CD_NGAYCV
              ,DECODE(V_BC_NGUOIKY,NULL,       PA.NGUOIKY,   V_BC_NGUOIKY) NGUOIKY
              ,PA.TENTHAMPHAN INTO V_CD_SOCV
              ,V_CD_NGAYCV
              ,V_CD_NGUOIKY
              ,V_TENTHAMPHAN
        FROM TABLE(V_TABLE)PA 
        WHERE PA.CD_SOCV IS NOT NULL  
        ORDER BY PA.NGAYTAO DESC FETCH FIRST 1 ROWS ONLY;
    END IF;

    SELECT SUM(PA.SODON) INTO V_SODON_TONG FROM TABLE(V_TABLE)PA;
    SELECT PA.TENPHONGBANNHAN INTO V_TENPHONGBANNHAN FROM TABLE(V_TABLE)PA  FETCH FIRST 1 ROWS ONLY;
    
    SELECT UPPER(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao','TANDCC')),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;

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
                        <span style="font-size: 14pt; font-weight: normal; font-style: italic;">(Gửi kèm theo Công văn số '||V_CD_SOCV||'/'||V_DONVI_CV||'-VP ngày '||V_CD_NGAYCV||' của '||V_TENDONVI_FULL||')</span>
                    </td>
                </tr>
                 <tr>
                    <td colspan="11" style="height:10px;"></td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">TT</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số đến</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số Thụ lý</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày thụ lý</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Người đề nghị, kiến nghị, thông báo</td>
                    ');
                IF(VHINHTHUCDON = 4) THEN
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số/ngày QĐKN</td>
                        <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:65px;">QĐ/BA đề nghị xem xét theo thủ tục GĐT/TT</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thẩm phán giải quyết</td>
                        ');
                    ELSE
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                            <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Địa chỉ</td>
                            <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height:65px;">QĐ/BA đề nghị xem xét theo thủ tục GĐT/TT</td>
                            <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Thẩm phán giải quyết</td>
                            ');
                END IF;

                IF(VHINHTHUCDON IN (1,3,6,9,7) AND VTOAANID IN (4,5,6)) THEN -- Theo 39 YC CCHN (được sự đồng ý của cả 3 tòa cấp cao), bổ sung thêm 3 cột cho BM Danh sách thụ lý mới
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Vụ án</td>
                        <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Quan hệ pháp luật</td>');
                END IF;
                
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
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
                         SELECT PA.* FROM TABLE(V_TABLE)PA ORDER BY TO_NUMBER(REGEXP_REPLACE(PA.SOTHULY, '[^[:digit:]]',''))
                         )
                 LOOP
                 V_TT:=V_TT+1;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||V_TT||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.SOHIEUDON||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.SOTHULY||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.NGAYTHULY||'</td>
                    ');
                    IF(VHINHTHUCDON = 4) THEN
                            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.DONVICHUYEN_HSKN||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.SO_HSKN||'<br>'||TO_CHAR(ITEM.NGAY_HSKN,'dd/mm/rrrr')||'</td>
                            ');
                        ELSE
                            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.NGUOIGUI||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.DIAPHUONG||'</td>
                            ');
                    END IF;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.BA_SO||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||ITEM.BA_NGAY||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.BA_TOAXX||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.TENTHAMPHAN||'</td>');
                    
               IF(VHINHTHUCDON IN (1,3,6,9,7) AND VTOAANID IN (4,5,6)) THEN -- Theo 39 YC CCHN (được sự đồng ý của cả 3 tòa cấp cao), bổ sung thêm 3 cột cho BM Danh sách thụ lý mới
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.NKK_NBK||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||ITEM.QUANHEPHAPLUAT||'</td>');
               END IF;
               
               DBMS_LOB.APPEND(V_EXPORT_TEXT,'   
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
                    <td colspan="5" style="vertical-align: top;"><span style="font-weight: bold;">Xác nhận của '||V_TENPHONGBANNHAN||'</span><br />
                        <span style="font-style: italic">(Ký ghi rõ họ tên)</span></td>
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
                    <td colspan="3" style="vertical-align: bottom; height: 140px;">
                       <p style="font-size: 13pt;"><strong>'||V_CD_NGUOIKY||'</strong></p>
                    </td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 28px"></td>
                    <td style="width: 38px"></td>
                    <td style="width: 38px"></td>
                    <td style="width: 70px"></td>
                    <td style="width: 190px"></td>
                    <td style="width: 112px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 42px"></td>
                    <td style="width: 87px"></td>
                    <td style="width: 94px"></td>');
                    
                    IF(VHINHTHUCDON IN (1,3,6,9,7) AND VTOAANID IN (4,5,6)) THEN -- Theo 39 YC CCHN (được sự đồng ý của cả 3 tòa cấp cao), bổ sung thêm 3 cột cho BM Danh sách thụ lý mới
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                    <td style="width: 180px"></td>
                    <td style="width: 170px"></td>');
                    END IF;
                    
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    
                    <td style="width: 50px"></td>
                    <td style="width: 190px"></td>
                </tr>
            </table>
            ');
    OPEN CURRETURN FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM DUAL;  
        DBMS_LOB.FREETEMPORARY(V_EXPORT_TEXT);
END DON_SEARCH_DS_TL_MOI_CC;



PROCEDURE REPORT_TIEUHOSO_CC
( 
    vArrSelectID in varchar2,
    v_ID_USER in NUMBER,
    curReturn OUT sys_refcursor
)
IS 
    V_EXPORT_TEXT clob;
    V_TABLE T_NOIBO_TIEUHOSO;   
    v_dem NUMBER:=0;

    --PHÂN BIỆT DÂN SỰ HÀNH CHÍNH HOẶC HÌNH SỰ ĐỂ IN 
    V_LOAIAN NUMBER:=0; 

    V_LOAIAN_TENHOSO VARCHAR2(250);
    V_LOAIAN_TENBAQD VARCHAR2(250);
    
    V_SO_THULY VARCHAR2(250);
    V_NGAY_THULY VARCHAR2(250):=NULL;
    V_THANG_THULY VARCHAR2(250):=NULL;
    V_NAM_THULY VARCHAR2(250):=NULL;
    
    --BAQĐ CÓ HIỆU LỰC PL/QĐ BỊ KHIẾU NẠI
    V_SO_BAQD VARCHAR2(250);
    V_NGAY_BAQD VARCHAR2(250):=NULL;
    V_THANG_BAQD VARCHAR2(250):=NULL;
    V_NAM_BAQD VARCHAR2(250):=NULL;
    V_TOAAN_GIAIQUYET VARCHAR2(500);
    V_THUTUCXETXU VARCHAR2(500);
    V_GHICHU clob;
    
    --NGUYÊN ĐƠN/NGƯỜI KHỞI KIỆN/BỊ CÁO
    V_DANHSACH1 clob; 
    --BỊ ĐƠN/NGƯỜI BỊ KIỆN/TỘI DANH
    V_DANHSACH2 clob;
    --QUAN HỆ TRANH CHẤP
    V_QHPL_TEXT clob;
    --NGƯỜI ĐỀ NGHỊ-THÔNG BÁO-KIẾN NGHỊ/NGƯỜI KHIẾU NẠI
    V_NGUOI_DNTBKN clob;
    --NGÀY TANDCC NHẬN ĐƠN/NGÀY NHẬN ĐƠN-VĂN BẢN
    V_NGAYNHAN DATE;
    --NỘI DUNG ĐƠN/NỘI DUNG VĂN ĐƠN-VĂN BẢN
    V_NOIDUNG clob;
    --TƯ CÁCH TỐ TỤNG
    V_TUCACHTOTUNG clob;

    V_LIST_DAUVU CLOB;
    V_LIST_BICAN CLOB;
    V_LIST_DAUVU_TOIDANH CLOB;
    V_LIST_BICAN_TOIDANH CLOB;
    
    V_DONVIID NUMBER DEFAULT 0;
BEGIN
if(vArrSelectID is not null) then
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);v_table := T_NOIBO_TIEUHOSO();
    FOR item IN (
        Select D.BAQD_LOAIAN,D.TL_SO,D.TL_NGAY,D.BAQD_CAPXETXU,D.ID,D.LOAIDON
                ,D.BAQD_NGAYBA,D.BAQD_NGAYBA_ST,D.BAQD_NGAYBA_PT
                ,TAGGDT.MA_TEN BAQD_TENTOA_GDT,TAGST.MA_TEN BAQD_TENTOA_ST,TAGPT.MA_TEN BAQD_TENTOA_PT
                ,D.LOAI_GDTTTT, D.GHICHU, D.QHPL_TEXT
                , DECODE(D.LOAIDON,4,D.GHICHU,D.NOIDUNGDON) NOIDUNGDON
                , D.NGAYNHANDON
                , DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,9,d.CV_TENDONVI,d.DONGKHIEUNAI) DONGKHIEUNAI
                , D.BAQD_SO_ST, D.BAQD_SO_PT, D.BAQD_SO
                -- Lấy thông tin hình sự
                ,D.NGUOIGUI_TUCACHTOTUNG
        from GDTTT_DON D 
            LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
            LEFT JOIN (SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU) LA ON LA.ID=D.BAQD_LOAIAN
            LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAGGDT ON TAGGDT.ID = D.BAQD_TOAANID
            LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAGST ON TAGST.ID = D.BAQD_TOAANID_ST
            LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAGPT ON TAGPT.ID = D.BAQD_TOAANID_PT
        WHERE (vArrSelectID  || ' '=' ' Or vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%')
        ORDER BY D.NGAYTAO desc
    )
    LOOP
        v_dem:=v_dem+1;
        
    V_LOAIAN := NULL;     V_LOAIAN_TENHOSO := NULL;    V_LOAIAN_TENBAQD := NULL;    
    V_SO_THULY := NULL;    V_NGAY_THULY := NULL;    V_THANG_THULY := NULL;    V_NAM_THULY := NULL;    
    V_SO_BAQD := NULL;    V_NGAY_BAQD := NULL;    V_THANG_BAQD := NULL;    V_NAM_BAQD := NULL;
    V_TOAAN_GIAIQUYET := NULL;    V_THUTUCXETXU := NULL;    V_GHICHU := NULL;
    V_DANHSACH1 := NULL;     V_DANHSACH2 := NULL;
    V_QHPL_TEXT := NULL;    V_NGUOI_DNTBKN := NULL;    V_NGAYNHAN := NULL;    V_NOIDUNG := NULL;    V_TUCACHTOTUNG := NULL;
    V_LIST_DAUVU := NULL;    V_LIST_BICAN := NULL;    V_LIST_DAUVU_TOIDANH := NULL;    V_LIST_BICAN_TOIDANH := NULL;
    
         if (item.BAQD_LOAIAN = 1)then
                V_LOAIAN_TENHOSO := 'Hình sự';
                V_LOAIAN_TENBAQD := 'hình sự';
                V_LOAIAN := 3;
            elsif (item.BAQD_LOAIAN = 2)then
                V_LOAIAN_TENHOSO := 'Dân sự';
                V_LOAIAN_TENBAQD := 'dân sự';
                V_LOAIAN := 1;
            elsif (item.BAQD_LOAIAN = 3)then
                V_LOAIAN_TENHOSO := 'Hôn nhân và gia đình';
                V_LOAIAN_TENBAQD := 'HNGĐ';
                V_LOAIAN := 1;
            elsif (item.BAQD_LOAIAN = 4)then
                V_LOAIAN_TENHOSO := 'Kinh doanh thương mại';
                V_LOAIAN_TENBAQD := 'KDTM';
                V_LOAIAN := 1;
            elsif (item.BAQD_LOAIAN = 5)then
                V_LOAIAN_TENHOSO := 'Lao động';
                V_LOAIAN_TENBAQD := 'lao động';
                V_LOAIAN := 1;
            elsif (item.BAQD_LOAIAN = 6)then
                V_LOAIAN_TENHOSO := 'Hành chính';
                V_LOAIAN_TENBAQD := 'HC';
                V_LOAIAN := 2;       
             elsif (item.BAQD_LOAIAN = 7)then
                V_LOAIAN_TENHOSO := 'Phá sản';
                V_LOAIAN_TENBAQD := 'PS';
                V_LOAIAN := 1;
            end if;        
        if (item.TL_SO IS NOT NULL) then
            V_SO_THULY := item.TL_SO;
            end if;        
        if (item.TL_NGAY IS NOT NULL) then
            V_NGAY_THULY := EXTRACT (DAY FROM item.TL_NGAY);
            V_THANG_THULY := EXTRACT (MONTH FROM item.TL_NGAY);
            V_NAM_THULY := EXTRACT (YEAR FROM item.TL_NGAY);
            end if;               
--        if (item.BAQD_CAPXETXU = 2) then
--                V_SO_BAQD := ITEM.BAQD_SO_ST;
--                V_TOAAN_GIAIQUYET := REPLACE(item.BAQD_TENTOA_ST,'Tòa án nhân dân','TAND');
--                V_NGAY_BAQD := EXTRACT (DAY FROM item.BAQD_NGAYBA_ST);
--                V_THANG_BAQD := EXTRACT (MONTH FROM item.BAQD_NGAYBA_ST);
--                V_NAM_BAQD := EXTRACT (YEAR FROM item.BAQD_NGAYBA_ST);
--            elsif (item.BAQD_CAPXETXU = 3) then
--                V_SO_BAQD := ITEM.BAQD_SO_PT;
--                V_TOAAN_GIAIQUYET := REPLACE(item.BAQD_TENTOA_PT,'Tòa án nhân dân','TAND');
--                V_NGAY_BAQD := EXTRACT (DAY FROM item.BAQD_NGAYBA_PT);
--                V_THANG_BAQD := EXTRACT (MONTH FROM item.BAQD_NGAYBA_PT);
--                V_NAM_BAQD := EXTRACT (YEAR FROM item.BAQD_NGAYBA_PT);
--            elsif (item.BAQD_CAPXETXU = 4) then
--                V_SO_BAQD := ITEM.BAQD_SO;
--                V_TOAAN_GIAIQUYET := REPLACE(item.BAQD_TENTOA_GDT,'Tòa án nhân dân','TAND');
--                V_NGAY_BAQD := EXTRACT (DAY FROM item.BAQD_NGAYBA);
--                V_THANG_BAQD := EXTRACT (MONTH FROM item.BAQD_NGAYBA);
--                V_NAM_BAQD := EXTRACT (YEAR FROM item.BAQD_NGAYBA);
--            end if;    
--            


        if (ITEM.BAQD_SO is not null or ITEM.BAQD_SO not like '') then
            V_SO_BAQD := ITEM.BAQD_SO;
            V_TOAAN_GIAIQUYET := REPLACE(item.BAQD_TENTOA_GDT,'Tòa án nhân dân','TAND');
            V_NGAY_BAQD := EXTRACT (DAY FROM item.BAQD_NGAYBA);
            V_THANG_BAQD := EXTRACT (MONTH FROM item.BAQD_NGAYBA);
            V_NAM_BAQD := EXTRACT (YEAR FROM item.BAQD_NGAYBA);
        elsif (ITEM.BAQD_SO_PT is not null or ITEM.BAQD_SO_PT not like '') then
            V_SO_BAQD := ITEM.BAQD_SO_PT;
            V_TOAAN_GIAIQUYET := REPLACE(item.BAQD_TENTOA_PT,'Tòa án nhân dân','TAND');
            V_NGAY_BAQD := EXTRACT (DAY FROM item.BAQD_NGAYBA_PT);
            V_THANG_BAQD := EXTRACT (MONTH FROM item.BAQD_NGAYBA_PT);
            V_NAM_BAQD := EXTRACT (YEAR FROM item.BAQD_NGAYBA_PT);
        elsif (ITEM.BAQD_SO_ST is not null or ITEM.BAQD_SO_ST not like '') then
                V_SO_BAQD := ITEM.BAQD_SO_ST;
                V_TOAAN_GIAIQUYET := REPLACE(item.BAQD_TENTOA_ST,'Tòa án nhân dân','TAND');
                V_NGAY_BAQD := EXTRACT (DAY FROM item.BAQD_NGAYBA_ST);
                V_THANG_BAQD := EXTRACT (MONTH FROM item.BAQD_NGAYBA_ST);
                V_NAM_BAQD := EXTRACT (YEAR FROM item.BAQD_NGAYBA_ST);
        end if;      
            
        if (item.LOAI_GDTTTT = '1') then
                v_THUTUCXETXU:= 'Theo thủ tục giám đốc thẩm';
            elsif (item.LOAI_GDTTTT = '2') then
                v_THUTUCXETXU:= 'Theo thủ tục tái thẩm';
            else
                v_THUTUCXETXU:= '';
            end if;
        if (item.GHICHU IS NOT NULL)then
              v_GHICHU:= item.GHICHU;
            end if;
        if (item.QHPL_TEXT IS NOT NULL)then
              v_QHPL_TEXT:= item.QHPL_TEXT;
            end if;
        if (item.NOIDUNGDON IS NOT NULL)then
              V_NOIDUNG:= item.NOIDUNGDON;
            end if;
        if (item.NGAYNHANDON IS NOT NULL)then
              V_NGAYNHAN:= item.NGAYNHANDON;
            end if;
        if (item.BAQD_LOAIAN != 1) THEN
                select listagg(tenduongsu, '<br>') WITHIN GROUP (ORDER BY tenduongsu desc) into V_DANHSACH1
                    from GDTTT_DON_DUONGSU_CC 
                    where DONID = item.ID and tucachtotung like 'NGUYENDON';       
                select listagg(tenduongsu, '<br>') WITHIN GROUP (ORDER BY tenduongsu desc) into V_DANHSACH2
                    from GDTTT_DON_DUONGSU_CC
                    where DONID = item.ID and tucachtotung like 'BIDON';        
            else
                select listagg(TENDUONGSU, ' (Đầu vụ)<br>') WITHIN GROUP (ORDER BY ID desc) INTO V_LIST_DAUVU
                     from GDTTT_DON_DUONGSU_CC 
                     where DONID = item.ID and HS_ISBICAO = 1 AND HS_BICANDAUVU = 1;                    
                 select listagg(TENDUONGSU, '<br>') WITHIN GROUP (ORDER BY ID desc) INTO V_LIST_BICAN
                     from GDTTT_DON_DUONGSU_CC 
                     where DONID = item.ID and HS_ISBICAO = 1 AND HS_BICANDAUVU = 0;                     
                 select listagg(HS_TENTOIDANH, '<br>') WITHIN GROUP (ORDER BY ID desc) INTO V_LIST_DAUVU_TOIDANH
                     from GDTTT_DON_DUONGSU_CC 
                     where DONID = item.ID and HS_ISBICAO = 1 AND HS_BICANDAUVU = 1;                    
                 select listagg(HS_TENTOIDANH, '<br>') WITHIN GROUP (ORDER BY ID desc) INTO V_LIST_BICAN_TOIDANH
                     from GDTTT_DON_DUONGSU_CC 
                     where DONID = item.ID and HS_ISBICAO = 1 AND HS_BICANDAUVU = 0;                           
                 IF(V_LIST_DAUVU IS NOT NULL) THEN
                     V_LIST_DAUVU := CONCAT(TO_CHAR(V_LIST_DAUVU),' (Đầu vụ)<br>');
                     END IF;
                 IF(V_LIST_DAUVU_TOIDANH IS NOT NULL) THEN   
                     V_LIST_DAUVU_TOIDANH := CONCAT(TO_CHAR(V_LIST_DAUVU_TOIDANH),'<br>');
                     END IF;
                 V_DANHSACH1 := CONCAT(V_LIST_DAUVU,TO_CHAR(V_LIST_BICAN));
                 V_DANHSACH2 := CONCAT(V_LIST_DAUVU_TOIDANH,TO_CHAR(V_LIST_BICAN_TOIDANH));
            end if;        
        if(item.NGAYNHANDON IS NOT NULL) then
              V_NGAYNHAN:= item.NGAYNHANDON;
            end if;       
        if(item.DONGKHIEUNAI IS NOT NULL) then
              V_NGUOI_DNTBKN:= REPLACE(item.DONGKHIEUNAI, ',' , '<br>');
            end if;        
        IF(ITEM.NGUOIGUI_TUCACHTOTUNG IS NOT NULL) THEN
            IF(ITEM.LOAIDON = 9 OR ITEM.LOAIDON = 6) THEN
                V_TUCACHTOTUNG := '';
            ELSE
                IF(ITEM.NGUOIGUI_TUCACHTOTUNG = 1) THEN
                        V_TUCACHTOTUNG := 'Bị cáo';
                    ELSIF(ITEM.NGUOIGUI_TUCACHTOTUNG = 2) THEN
                        V_TUCACHTOTUNG := 'Người tham gia tố tụng';
                    ELSIF(ITEM.NGUOIGUI_TUCACHTOTUNG = 3) THEN
                        V_TUCACHTOTUNG := 'Người không liên quan đến vụ án';
                    ELSIF(ITEM.NGUOIGUI_TUCACHTOTUNG = 4) THEN
                        V_TUCACHTOTUNG := 'Khác';
                    END IF;
                END IF;
            END IF;
        v_table.extend;
        v_table(v_table.count) := R_NOIBO_TIEUHOSO(V_LOAIAN,
                                V_LOAIAN_TENHOSO,V_LOAIAN_TENBAQD,
                                V_SO_THULY, V_NGAY_THULY, V_THANG_THULY, V_NAM_THULY,
                                V_SO_BAQD, V_NGAY_BAQD, V_THANG_BAQD, V_NAM_BAQD,
                                V_TOAAN_GIAIQUYET,
                                V_THUTUCXETXU, 
                                V_GHICHU, 
                                V_DANHSACH1, V_DANHSACH2, 
                                V_QHPL_TEXT, V_NGUOI_DNTBKN, V_NGAYNHAN, V_NOIDUNG, V_TUCACHTOTUNG);
    END LOOP;
    v_dem:=0;
    
    SELECT DONVIID INTO V_DONVIID FROM QT_NGUOISUDUNG
    WHERE ID = v_ID_USER;
    
    FOR item in (SELECT COUNT(*) OVER () as CountAll,PA.*  FROM TABLE(V_TABLE) PA)
    LOOP
        v_dem:=v_dem+1;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <table border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=291 valign=top style="width:218.05pt;border:none;padding:0in 5.4pt 0in 5.4pt; height:49.75pt">
                        <p align=center style="text-align:center; margin-bottom: -25px; margin-top: -15px;">TÒA ÁN NHÂN DÂN TỐI CAO</p>
                        <p align=center style="text-align:center; margin-bottom: -25px; margin-top: -15px;">
                            <b style="mso-bidi-font-weight:normal">TÒA ÁN NHÂN DÂN CẤP CAO<o:p></o:p></b></p>
                        <p align=center style="text-align:center; margin-bottom: -25px; margin-top: -15px;">
                            ');
                            IF(V_DONVIID = 4) THEN 
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'<b style="mso-bidi-font-weight:normal"><u>TẠI HÀ NỘI</u><o:p></o:p></b>');
                                ELSIF(V_DONVIID = 5) THEN 
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'<b style="mso-bidi-font-weight:normal"><u>TẠI ĐÀ NẴNG</u><o:p></o:p></b>');
                                ELSIF(V_DONVIID = 6) THEN 
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'<b style="mso-bidi-font-weight:normal">TẠI THÀ<u>NH PHỐ HỒ C</u>HÍ MINH<o:p></o:p></b>');
                            END IF;
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'</p>
                    </td>
                    <td width=454 valign=top style="width:340.2pt;border:none;padding:0in 5.4pt 0in 5.4pt; height:49.75pt">
                        <p align=center style="text-align:center; margin-bottom: -25px; margin-top: -15px;">
                            <b style="mso-bidi-font-weight:normal">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM<o:p></o:p></b>
                        </p>
                        <p align=center style="text-align:center; margin-bottom: -25px; margin-top: -15px;">
                            <b style="mso-bidi-font-weight:normal"><u>Độc lập – Tự do – Hạnh phúc</u></b>
                        </p>
                        <p style="margin-bottom: -25px; margin-top: -15px;"><b style="mso-bidi-font-weight:normal"><o:p>&nbsp;</o:p></b></p>
                    </td>
                </tr>
            </table>
            ');
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <p align=center style="text-align:center;tab-stops:center 99.25pt 404.0pt; margin-bottom: -25px; margin-top: -15px;mso-line-height-rule:exactly;">                
                    ');
                    if(item.LOAIAN_TENHOSO = 'Kinh doanh thương mại') then 
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                            <span style="font-weight: 570;letter-spacing:-4px; font-size:34.0pt;">TIỂU HỒ SƠ '||UPPER(item.LOAIAN_TENHOSO)||'</span>
                            ');
                    else 
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                            <span style="font-weight: 570;letter-spacing:-4px; font-size:36.0pt;">TIỂU HỒ SƠ '||UPPER(item.LOAIAN_TENHOSO)||'</span>
                            ');
                    end if;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            </p>
            <table border=0 cellspacing=0 cellpadding=0 width=718 style="width:538.65pt;margin-left:12.5pt;">
                <tr style="mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes;">
                    <td width=359 valign=top style="width:269.35pt;border:none;padding:0in 5.4pt 0in 5.4pt; height:183.3pt">
                        <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px;  line-height:22.0pt;mso-line-height-rule:exactly; tab-stops:dotted 256.85pt 552.0pt">
            ');
        IF (ITEM.SO_THULY IS NOT NULL) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                    <b style="mso-bidi-font-weight:normal"><span style="font-size:13.0pt">Thụ lý số: '||(item.SO_THULY)||'</span></b>
                                </p>
            ');
            ELSE 
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                    <b style="mso-bidi-font-weight:normal">
                                        <span style="font-size:13.0pt">Thụ lý số:</span>
                                    </b>
                                    <span style="font-size:13.0pt">
                                        <span style="mso-tab-count:1 dotted">.................................................................. </span>
                                        <b style="mso-bidi-font-weight:normal"><o:p></o:p></b>
                                    </span>
                                </p>
            ');
        END IF;
        IF (ITEM.NGAY_THULY IS NOT NULL) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px;  line-height:22.0pt;mso-line-height-rule:exactly; tab-stops:dotted 72.6pt 150.55pt 256.85pt 552.0pt">                           
                                    <b style="mso-bidi-font-weight: normal">
                                        <span style="font-size:13.0pt">Ngày '||(item.NGAY_THULY)||' tháng '||(item.THANG_THULY)||' năm '||(item.NAM_THULY)||'</span>
                                    </b>
                                </p>
            ');
            ELSE 
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px;  line-height:22.0pt;mso-line-height-rule:exactly; tab-stops:dotted 72.6pt 150.55pt 256.85pt 552.0pt">
                                        <span style="font-size:13.0pt; mso-bidi-font-weight: normal"><b>Ngày</b> .............. <b>tháng</b> ............... <b>năm</b> ............... </span>
                                </p>
            ');
        END IF;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px;  line-height:22.0pt;mso-line-height-rule:exactly; tab-stops:dotted 256.85pt 297.7pt 368.55pt 446.55pt 552.85pt">
                            <span style="font-size:13.0pt">Thẩm tra viên:
                                <span style="mso-tab-count:1 dotted">........................................................... </span>
                                <i style="mso-bidi-font-style:normal"><o:p></o:p></i>
                            </span>
                        </p>
                        <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px;  line-height:22.0pt;mso-line-height-rule:exactly; tab-stops:dotted 256.85pt 552.85pt">
                            <span style="font-size:13.0pt">Ngày giao tiểu hồ sơ:
                                <span style="mso-tab-count:1 dotted">............................................... </span>
                                <i style="mso-bidi-font-style:normal"><o:p></o:p></i>
                            </span>
                        </p>
                        <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px;  line-height:22.0pt;mso-line-height-rule:exactly; tab-stops:dotted 256.85pt 552.85pt">
                            <span style="font-size:13.0pt">Kết quả giải quyết:
                                <span style="mso-tab-count:1 dotted">................................................... </span>
                                <i style="mso-bidi-font-style:normal"><o:p></o:p></i>
                            </span>
                        </p>
                        <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px;  line-height:22.0pt;mso-line-height-rule:exactly; tab-stops:dotted 256.85pt 336.0pt 420.0pt 528.0pt 552.85pt">
                            <span style="font-size:13.0pt">Số, ngày VB giải quyết:
                                <span style="mso-tab-count:1 dotted">.......................................... </span>
                                <i style="mso-bidi-font-style:normal"><o:p></o:p></i>
                            </span>
                        </p>
                        <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px;  line-height:22.0pt;mso-line-height-rule:exactly; tab-stops:dotted 256.85pt 552.85pt">
                            <span style="font-size:13.0pt">Người ký VB giải quyết:
                                <span style="mso-tab-count:1 dotted">......................................... </span><o:p></o:p>
                            </span>
                        </p>
                        <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px;  line-height:22.0pt;mso-line-height-rule:exactly; tab-stops:dotted 256.85pt 552.85pt">
                            <span style="font-size:13.0pt">
                                <span style="mso-tab-count:1 dotted">..................................................................................... </span>
                                <i style="mso-bidi-font-style:normal"><o:p></o:p></i>
                            </span>
                        </p>
                    </td>
                    <td width=359 valign=top style="width:269.3pt;border:none;padding:0in 5.4pt 0in 5.4pt; height:183.3pt">
                        <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px; margin-right:-5.4pt; line-height:22.0pt;mso-line-height-rule: exactly;tab-stops:dotted 552.85pt">
                            <i style="mso-bidi-font-style:normal; mso-bidi-font-weight:normal">
                              <span style="font-size:13.0pt;">Bản án/quyết định '||(item.LOAIAN_TENBAQD)||' có hiệu lực pháp luật:<o:p></o:p></span>
                            </i>
                        </p>
                        <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px; margin-right:-5.4pt; line-height:22.0pt;mso-line-height-rule: exactly;tab-stops:dotted 58.4pt 122.2pt 186.0pt 263.9pt 552.85pt">
                            <b style="mso-bidi-font-weight:normal">
                                <i style="mso-bidi-font-style:normal">
            ');
        IF (ITEM.SO_BAQD IS NOT NULL) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                            <span style="font-size:13.0pt">Số '||(item.SO_BAQD)||' ');
            ELSE
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                            <span style="font-size:13.0pt">Số <span style="mso-tab-count:1 dotted">...................... </span>');
        END IF;
        IF (ITEM.NGAY_BAQD IS NOT NULL) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                            <br>Ngày '||(item.NGAY_BAQD)||' tháng '||(item.THANG_BAQD)||' năm '||(item.NAM_BAQD)||'</span>');
            ELSE
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                            <br>Ngày <span style="mso-tab-count:1 dotted">............ </span>
                                            tháng <span style="mso-tab-count:1 dotted">.......... </span>
                                            năm <span style="mso-tab-count:1 dotted">.................. </span><o:p></o:p>
            ');
        END IF;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                            </span>
                                </i>
                            </b>
                        </p>
                        <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px; margin-right:-5.4pt; line-height:22.0pt;mso-line-height-rule: exactly;tab-stops:dotted 263.9pt 362.15pt 552.85pt">
                            <i style="mso-bidi-font-style: normal">
                                <span style="font-size:13.0pt">Tòa án giải quyết:<b> '||(ITEM.TOAAN_GIAIQUYET)||'</b>
            ');
        IF (ITEM.TOAAN_GIAIQUYET IS NULL) THEN
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                    <span style="mso-tab-count:1 dotted">....................................................... </span><o:p></o:p>
                                </span>
                            </i>
                        </p>
                        <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px; margin-right:-5.4pt; line-height:22.0pt;mso-line-height-rule: exactly;tab-stops:dotted 263.9pt 362.15pt 552.85pt">
                            <i style="mso-bidi-font-style: normal">
                                <span style="font-size:13.0pt">
                                    <span style="mso-tab-count:1 dotted">....................................................................................... </span><o:p></o:p>
            ');
        END IF;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                </span>
                            </i>
                        </p>
                        <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px; margin-right:-5.4pt; line-height:22.0pt;mso-line-height-rule: exactly;tab-stops:dotted 263.9pt 362.15pt 552.85pt">
                            <i style="mso-bidi-font-style: normal">
                                <span style="font-size:13.0pt">Thủ tục xét xử:<b> '||(ITEM.THUTUCXETXU)||'</b>
            ');
        IF (ITEM.THUTUCXETXU IS NULL) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                        <span style="mso-tab-count:1 dotted">............................................................. </span><o:p></o:p>
            ');
        END IF;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                    </span>
                                </i>
                            </p>
                            <p class=MsoNormal style=" margin-bottom: 0px; margin-top: 0px; margin-right:-5.4pt; line-height:22.0pt;mso-line-height-rule: exactly;tab-stops:dotted 263.9pt 362.15pt 552.85pt">
                                <b style="mso-bidi-font-weight: normal">
                                    <i style="mso-bidi-font-style:normal">
                                        <span style="font-size:13.0pt">Ghi chú:</span>
                                    </i>
                                </b>
                                <i style="mso-bidi-font-style:normal">
                                    <span style="font-size:13.0pt">
                                        <span style="mso-tab-count:1 dotted">....................................................................... </span><o:p></o:p>
                                        <span style="mso-tab-count:1 dotted">....................................................................................... </span><o:p></o:p>
            ');
        if(LENGTH(ITEM.TOAAN_GIAIQUYET) < 25) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                        <span style="mso-tab-count:1 dotted">....................................................................................... </span><o:p></o:p>           
            ');
        END IF;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                    </span>
                                </i>
                            </p>
                        </td>
                    </tr>
                </table>
                <table class=MsoNormalTable cellspacing=0 cellpadding=0 width=718 style="width:538.65pt;margin-left:12.5pt;border-collapse:collapse;border:none;mso-yfti-tbllook:480;mso-padding-alt: 0in 5.4pt 0in 5.4pt;">
            ');
        
        IF (ITEM.LOAIAN = 1) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr style="mso-yfti-irow:0;mso-yfti-firstrow:yes;height:22.4pt">
                        <td width=359 colspan=2 style="width:269.35pt;border:solid windowtext 1.0pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:22.4pt">
                            <p class=MsoNormal align=center style="text-align:center;tab-stops:3.5in">
                                <b style="mso-bidi-font-weight:normal"><span style="font-size:14.0pt">Nguyên đơn<o:p></o:p></span></b>
                            </p>
                        </td>
                        <td width=359 colspan=2 style="width:269.3pt;border:solid windowtext 1.0pt; border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt: solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:22.4pt">
                            <p class=MsoNormal align=center style="text-align:center;tab-stops:3.5in">
                                <b style="mso-bidi-font-weight:normal"><span style="font-size:14.0pt">Bị đơn<o:p></o:p></span></b>
                            </p>
                        </td>
                    </tr>                                
                ');
            ELSIF(ITEM.LOAIAN = 2) THEN
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr style="mso-yfti-irow:0;mso-yfti-firstrow:yes;height:22.4pt">
                        <td width=359 colspan=2 style="width:269.35pt;border:solid windowtext 1.0pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:22.4pt">
                            <p class=MsoNormal align=center style="text-align:center;tab-stops:3.5in">
                                <b style="mso-bidi-font-weight:normal"><span style="font-size:14.0pt">Người khởi kiện<o:p></o:p></span></b>                            
                            </p>
                        </td>
                        <td width=359 colspan=2 style="width:269.3pt;border:solid windowtext 1.0pt; border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt: solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:22.4pt">
                            <p class=MsoNormal align=center style="text-align:center;tab-stops:3.5in">
                                <b style="mso-bidi-font-weight:normal"><span style="font-size:14.0pt">Người bị kiện<o:p></o:p></span></b>
                            </p>
                        </td>
                    </tr>
                ');
            ELSIF(ITEM.LOAIAN = 3) THEN
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr style="mso-yfti-irow:0;mso-yfti-firstrow:yes;height:22.4pt">
                        <td width=359 colspan=2 style="width:269.35pt;border:solid windowtext 1.0pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:22.4pt">
                            <p class=MsoNormal align=center style="text-align:center;tab-stops:3.5in">
                                <b style="mso-bidi-font-weight:normal"><span style="font-size:14.0pt">Bị cáo<o:p></o:p></span></b>
                            </p>
                        </td>
                        <td width=359 colspan=2 style="width:269.3pt;border:solid windowtext 1.0pt; border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt: solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:22.4pt">
                            <p class=MsoNormal align=center style="text-align:center;tab-stops:3.5in">
                                <b style="mso-bidi-font-weight:normal"><span style="font-size:14.0pt">Tội danh<o:p></o:p></span></b>
                            </p>
                        </td>
                    </tr>
                ');
        END IF;     
        IF (ITEM.LOAIAN = 1 OR ITEM.LOAIAN = 2) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr style="mso-yfti-irow:1;height:177.4pt">
                    <td width=359 colspan=2 valign=top style="width:269.35pt;border:solid windowtext 1.0pt; border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt; padding:0in 5.4pt 0in 5.4pt;height:177.4pt">
                        <p class=MsoNormal align=left style="text-align:left;tab-stops:3.5in">
                            <span style="font-size:14.0pt;mso-bidi-font-weight:normal">'||(ITEM.DANHSACH1)||'</span>
                        </p>
                    </td>
                    <td width=359 colspan=2 valign=top style="width:269.3pt;border-top:none; border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:177.4pt">
                        <p class=MsoNormal align=letf style="text-align:left;tab-stops:3.5in">
                            <span style="font-size:14.0pt;mso-bidi-font-weight:normal">'||(ITEM.DANHSACH2)||'</span>
                        </p>
                    </td>
                </tr>    
                <tr style="mso-yfti-irow:2;height:50.05pt">
                    <td width=718 colspan=4 valign=top style="width:538.65pt;border:solid windowtext 1.0pt; border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt; padding:0in 5.4pt 0in 5.4pt;height:50.05pt">
                        <p class=MsoNormal style="margin-top:6.0pt;tab-stops:3.5in">
                                <span style="font-size:14.0pt"><b style="mso-bidi-font-weight:normal">Quan hệ tranh chấp:</b> '||(ITEM.QHTC)||'</span>
                            <span style="font-size:14.0pt"><o:p></o:p></span>
                        </p>
                    </td>
                </tr>
                <tr style="mso-yfti-irow:3;height:38.65pt">
                    <td width=291 style="width:218.05pt;border:solid windowtext 1.0pt;border-top: none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt; padding:0in 5.4pt 0in 5.4pt;height:38.65pt">
                        <p class=MsoNormal align=center style="margin-right:-2.05pt;text-align:center">
                            <b style="mso-bidi-font-weight:normal">
                                <span style="font-size:14.0pt">Người đề nghị/thông báo/kiến nghị<o:p></o:p></span>
                            </b>
                        </p>
                    </td>
                    <td width=153 colspan=2 style="width:115.05pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:38.65pt">
                        <p class=MsoNormal align=center style="margin-right:-5.4pt;text-align:center">
                            <b style="mso-bidi-font-weight:normal">
                                <span style="font-size:14.0pt">Ngày TANDCC nhận đơn/văn bản<o:p></o:p></span>
                            </b>
                        </p>
                    </td>
                    <td width=274 style="width:205.55pt;border-top:none;border-left:none; border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:38.65pt">
                        <p class=MsoNormal align=center style="margin-right:-5.4pt;text-align:center">
                            <b style="mso-bidi-font-weight:normal">
                                <span style="font-size:14.0pt">Nội dung đơn/văn bản<o:p></o:p></span>
                            </b>
                        </p> 
                    </td>
                </tr>
                <tr style="mso-yfti-irow:4;mso-yfti-lastrow:yes;height:207.45pt">
                    <td width=291 valign=top style="width:218.05pt;border:solid windowtext 1.0pt; border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt; padding:0in 5.4pt 0in 5.4pt;height:207.45pt">
                        <p class=MsoNormal>
                            <span style="font-size:14.0pt">'||ITEM.NGUOI_DNTBKN||'</span>
                        </p>
                    </td>
                    <td width=153 colspan=2 valign=top style="width:115.05pt;border-top:none; border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:207.45pt">
                        <p class=MsoNormal>
                            <span style="font-size:14.0pt">'||TO_CHAR(ITEM.NGAYNHAN,'dd/mm/rrrr') ||'</span>
                        </p>
                    </td>
                    <td width=274 valign=top style="width:205.55pt;border-top:none;border-left: none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:207.45pt">
                        <p class=MsoNormal>
                            <span style="font-size:14.0pt">'||ITEM.NOIDUNG||'</span>
                        </p>
                    </td>
                </tr>
            ');
        ELSIF (ITEM.LOAIAN = 3) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr style="mso-yfti-irow:1;height:177.4pt">
                    <td width=359 colspan=2 valign=top style="width:269.35pt;border:solid windowtext 1.0pt; border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt; padding:0in 5.4pt 0in 5.4pt;height:227.4pt">
                        <p class=MsoNormal align=left style="text-align:left;tab-stops:3.5in">
                            <span style="font-size:14.0pt;mso-bidi-font-weight:normal">'||(ITEM.DANHSACH1)||'</span>
                        </p>
                    </td>
                    <td width=359 colspan=2 valign=top style="width:269.3pt;border-top:none; border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:227.4pt">
                        <p class=MsoNormal align=letf style="text-align:left;tab-stops:3.5in">
                            <span style="font-size:14.0pt;mso-bidi-font-weight:normal">'||(ITEM.DANHSACH2)||'</span>
                        </p>
                    </td>
                </tr>
                    <tr style="mso-yfti-irow:2; height:38.65pt">
                        <td width=265 style="width:198.45pt;border:solid windowtext 1.0pt;border-top: none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt; padding:0in 5.4pt 0in 5.4pt;height:38.65pt">
                            <p class=MsoNormal align=center style="margin-right:-2.05pt;text-align:center">
                                <b style="mso-bidi-font-weight:normal">
                                    <span style="font-size:13.0pt">Người đề nghị/thông báo/kiến nghị<o:p></o:p></span>
                                </b>
                            </p>
                        </td>
                        <td width=95 style="width:70.9pt;border-top:none;border-left:none;border-bottom: solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;mso-border-top-alt: solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;mso-border-alt: solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:38.65pt">
                            <p class=MsoNormal align=center style="margin-right:-5.4pt;text-align:center">
                                <b style="mso-bidi-font-weight:normal">Tư cách <br> tố tụng<o:p></o:p></b>
                            </p>
                        </td>
                        <td width=104 style="width:77.95pt;border-top:none;border-left:none; border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:38.65pt">
                            <p class=MsoNormal align=center style="margin-right:-5.4pt;text-align:center">
                                <b style="mso-bidi-font-weight:normal">Ngày nhận đơn/văn bản<o:p></o:p></b>
                            </p>
                        </td>
                        <td width=255 style="width:191.35pt;border-top:none;border-left:none; border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:38.65pt">
                            <p class=MsoNormal align=center style="margin-right:-5.4pt;text-align:center">
                                <b style="mso-bidi-font-weight:normal"><span style="font-size:13.0pt">Nội dung đơn/văn bản<o:p></o:p></span></b>
                            </p>
                        </td>
                    </tr>
                    <tr style="mso-yfti-irow:3;mso-yfti-lastrow:yes;height:258.5pt">
                        <td width=265 valign=top style="width:198.45pt;border:solid windowtext 1.0pt; border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt; padding:0in 5.4pt 0in 5.4pt;height:258.5pt">
                            <p class=MsoNormal><span style="font-size:14.0pt">'||ITEM.NGUOI_DNTBKN||'</span></p>
                        </td>
                        <td width=95 valign=top style="width:70.9pt;border-top:none;border-left:none; border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:208.5pt">
                            <p class=MsoNormal><span style="font-size:14.0pt">'||ITEM.TUCACHTOTUNG||'</span></p>
                        </td>
                    <td width=104 valign=top style="width:77.95pt;border-top:none;border-left: none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:208.5pt">
                        <p class=MsoNormal><span style="font-size:14.0pt">'||TO_CHAR(ITEM.NGAYNHAN,'dd/mm/rrrr') ||'</span></p>
                    </td>
                    <td width=255 valign=top style="width:191.35pt;border-top:none;border-left: none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt; mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:208.5pt">
                        <p class=MsoNormal><span style="font-size:14.0pt">'||ITEM.NOIDUNG||'</span></p>
                    </td>
                </tr>
            ');
        END IF;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                     <![if !supportMisalignedColumns]>
                     <tr height=0>
                      <td width=291 style="border:none"></td>
                      <td width=68 style="border:none"></td>
                      <td width=85 style="border:none"></td>
                      <td width=274 style="border:none"></td>
                     </tr>
                     <![endif]>
                </table>
        ');
        IF(v_dem<item.CountAll) THEN
        DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <span style="font-size:12.0pt;font-family:''Times New Roman'',serif;mso-fareast-font-family:
                ''Times New Roman'';mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                mso-fareast-language:EN-US;mso-bidi-language:AR-SA">
                <br clear=all style="mso-special-character:line-break;page-break-before:always">
                </span>
        ');
        END IF;
    END LOOP;
    OPEN curReturn FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
end if;
END REPORT_TIEUHOSO_CC;

PROCEDURE REPORT_QDRUT_HOSO_CC
( 
    vArrSelectID in varchar2,
    v_ID_USER in NUMBER,
    V_BC_SoCV in varchar2,
    V_BC_NGAYDK in varchar2,
    V_BC_Nguoiky  in varchar2,
    curReturn OUT sys_refcursor
)
IS 
    V_EXPORT_TEXT clob;
    V_TABLE T_NOIBO_RUTHOSO;   
    v_dem NUMBER:=0;

    --PHÂN BIỆT DÂN SỰ HÀNH CHÍNH HOẶC HÌNH SỰ ĐỂ IN 
    V_LOAIAN NUMBER:=0; 

    V_LOAIAN_TENHOSO VARCHAR2(250);
    V_LOAIAN_TENBAQD VARCHAR2(250);
    
    V_SO_THULY VARCHAR2(250);
    V_NGAY_THULY VARCHAR2(250):=NULL;
    V_THANG_THULY VARCHAR2(250):=NULL;
    V_NAM_THULY VARCHAR2(250):=NULL;
    
    --BAQĐ CÓ HIỆU LỰC PL/QĐ BỊ KHIẾU NẠI
    V_SO_BAQD VARCHAR2(250);
    V_NGAY_BAQD VARCHAR2(250):=NULL;
    V_THANG_BAQD VARCHAR2(250):=NULL;
    V_NAM_BAQD VARCHAR2(250):=NULL;
    V_TOAAN_GIAIQUYET VARCHAR2(500);
    V_THUTUCXETXU VARCHAR2(500);
    v_CAPXETXU VARCHAR2(500);
    V_GHICHU clob;
    
    --NGUYÊN ĐƠN/NGƯỜI KHỞI KIỆN/BỊ CÁO
    V_DANHSACH1 clob; 
    --BỊ ĐƠN/NGƯỜI BỊ KIỆN/TỘI DANH
    V_DANHSACH2 clob;
    --QUAN HỆ TRANH CHẤP
    V_QHPL_TEXT clob;
    --NGƯỜI ĐỀ NGHỊ-THÔNG BÁO-KIẾN NGHỊ/NGƯỜI KHIẾU NẠI
    V_NGUOI_DNTBKN clob;
    --NGÀY TANDCC NHẬN ĐƠN/NGÀY NHẬN ĐƠN-VĂN BẢN
    V_NGAYNHAN DATE;
    --NỘI DUNG ĐƠN/NỘI DUNG VĂN ĐƠN-VĂN BẢN
    V_NOIDUNG clob;
    --TƯ CÁCH TỐ TỤNG
    V_TUCACHTOTUNG clob;

    V_LIST_DAUVU CLOB;
    V_LIST_BICAN CLOB;
    V_LIST_DAUVU_TOIDANH CLOB;
    V_LIST_BICAN_TOIDANH CLOB;
    
    V_DONVIID NUMBER DEFAULT 0;
    V_DONVI_NAME VARCHAR2(200);
    V_DOVIGIAIQUYET VARCHAR2(200);
    
    V_NGAY  VARCHAR2(200);
    V_THANG  VARCHAR2(200);
    V_NAM VARCHAR2(200);
    V_TENPHONGBANGUI varchar2(250);
    V_TENDONVI varchar2(250);V_TENDONVI_FULL varchar2(250);V_DONVI_CV varchar2(250);V_TENDONVI_HC varchar2(250);V_TENDONVI_DIACHI  varchar2(250);
BEGIN
if(vArrSelectID is not null) then
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);v_table := T_NOIBO_RUTHOSO();
    FOR item IN (
        Select D.BAQD_LOAIAN,D.TL_SO,D.TL_NGAY,D.BAQD_CAPXETXU,D.ID,D.LOAIDON
                ,D.BAQD_NGAYBA,D.BAQD_NGAYBA_ST,D.BAQD_NGAYBA_PT
                ,TAGGDT.MA_TEN BAQD_TENTOA_GDT,TAGST.MA_TEN BAQD_TENTOA_ST,TAGPT.MA_TEN BAQD_TENTOA_PT
                ,D.LOAI_GDTTTT, D.GHICHU, D.QHPL_TEXT
                ,D.NOIDUNGDON, D.NGAYNHANDON, D.DONGKHIEUNAI, D.BAQD_SO_ST, D.BAQD_SO_PT, D.BAQD_SO
                -- Lấy thông tin hình sự
                ,D.NGUOIGUI_TUCACHTOTUNG, D.CD_TA_DONVIID
        from GDTTT_DON D 
            LEFT JOIN (SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU) LA ON LA.ID=D.BAQD_LOAIAN
            LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAGGDT ON TAGGDT.ID = D.BAQD_TOAANID
            LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAGST ON TAGST.ID = D.BAQD_TOAANID_ST
            LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAGPT ON TAGPT.ID = D.BAQD_TOAANID_PT
        WHERE (vArrSelectID  || ' '=' ' Or vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%')
        ORDER BY D.NGAYTAO desc
    )
    LOOP
        v_dem:=v_dem+1;
        
    V_LOAIAN := NULL;     V_LOAIAN_TENHOSO := NULL;    V_LOAIAN_TENBAQD := NULL;    
    V_SO_THULY := NULL;    V_NGAY_THULY := NULL;    V_THANG_THULY := NULL;    V_NAM_THULY := NULL;    
    V_SO_BAQD := NULL;    V_NGAY_BAQD := NULL;    V_THANG_BAQD := NULL;    V_NAM_BAQD := NULL;
    V_TOAAN_GIAIQUYET := NULL;    V_THUTUCXETXU := NULL;    V_GHICHU := NULL;
    V_DANHSACH1 := NULL;     V_DANHSACH2 := NULL;
    V_QHPL_TEXT := NULL;    V_NGUOI_DNTBKN := NULL;    V_NGAYNHAN := NULL;    V_NOIDUNG := NULL;    V_TUCACHTOTUNG := NULL;
    V_LIST_DAUVU := NULL;    V_LIST_BICAN := NULL;    V_LIST_DAUVU_TOIDANH := NULL;    V_LIST_BICAN_TOIDANH := NULL;
    
        if (item.BAQD_LOAIAN = 1)then
                V_LOAIAN_TENHOSO := 'Hình sự';
                V_LOAIAN_TENBAQD := 'hình sự';
                V_LOAIAN := 3;
            elsif (item.BAQD_LOAIAN = 2)then
                V_LOAIAN_TENHOSO := 'Dân sự';
                V_LOAIAN_TENBAQD := 'dân sự';
                V_LOAIAN := 1;
            elsif (item.BAQD_LOAIAN = 3)then
                V_LOAIAN_TENHOSO := 'Hôn nhân và gia đình';
                V_LOAIAN_TENBAQD := 'HNGĐ';
                V_LOAIAN := 1;
            elsif (item.BAQD_LOAIAN = 4)then
                V_LOAIAN_TENHOSO := 'Kinh doanh thương mại';
                V_LOAIAN_TENBAQD := 'KDTM';
                V_LOAIAN := 1;
            elsif (item.BAQD_LOAIAN = 5)then
                V_LOAIAN_TENHOSO := 'Lao động';
                V_LOAIAN_TENBAQD := 'lao động';
                V_LOAIAN := 1;
            elsif (item.BAQD_LOAIAN = 6)then
                V_LOAIAN_TENHOSO := 'Hành chính';
                V_LOAIAN_TENBAQD := 'HC';
                V_LOAIAN := 2;
            end if;        
        if (item.TL_SO IS NOT NULL) then
            V_SO_THULY := item.TL_SO;
            end if;        
        if (item.TL_NGAY IS NOT NULL) then
            V_NGAY_THULY := EXTRACT (DAY FROM item.TL_NGAY);
            V_THANG_THULY := EXTRACT (MONTH FROM item.TL_NGAY);
            V_NAM_THULY := EXTRACT (YEAR FROM item.TL_NGAY);
        end if;               
      
        if (ITEM.BAQD_CAPXETXU = 4) then
            V_SO_BAQD := ITEM.BAQD_SO;
            V_TOAAN_GIAIQUYET := item.BAQD_TENTOA_GDT; --REPLACE(item.BAQD_TENTOA_GDT,'Tòa án nhân dân','TAND');
            V_NGAY_BAQD := EXTRACT (DAY FROM item.BAQD_NGAYBA);
            V_THANG_BAQD := EXTRACT (MONTH FROM item.BAQD_NGAYBA);
            V_NAM_BAQD := EXTRACT (YEAR FROM item.BAQD_NGAYBA);
        elsif (ITEM.BAQD_CAPXETXU = 3) then
            V_SO_BAQD := ITEM.BAQD_SO_PT;
            V_TOAAN_GIAIQUYET := item.BAQD_TENTOA_PT; --REPLACE(item.BAQD_TENTOA_PT,'Tòa án nhân dân','TAND');
            V_NGAY_BAQD := EXTRACT (DAY FROM item.BAQD_NGAYBA_PT);
            V_THANG_BAQD := EXTRACT (MONTH FROM item.BAQD_NGAYBA_PT);
            V_NAM_BAQD := EXTRACT (YEAR FROM item.BAQD_NGAYBA_PT);
        elsif (ITEM.BAQD_CAPXETXU = 2) then
                V_SO_BAQD := ITEM.BAQD_SO_ST;
                V_TOAAN_GIAIQUYET := item.BAQD_TENTOA_ST; --REPLACE(item.BAQD_TENTOA_ST,'Tòa án nhân dân','TAND');
                V_NGAY_BAQD := EXTRACT (DAY FROM item.BAQD_NGAYBA_ST);
                V_THANG_BAQD := EXTRACT (MONTH FROM item.BAQD_NGAYBA_ST);
                V_NAM_BAQD := EXTRACT (YEAR FROM item.BAQD_NGAYBA_ST);
        end if;      
            
        if (item.LOAI_GDTTTT = '1') then
            v_THUTUCXETXU:= 'Theo thủ tục giám đốc thẩm';
        elsif (item.LOAI_GDTTTT = '2') then
            v_THUTUCXETXU:= 'Theo thủ tục tái thẩm';
        else
            v_THUTUCXETXU:= '';
        end if;
        if (item.BAQD_CAPXETXU = '4') then
            v_CAPXETXU:= 'giám đốc thẩm';
        elsif (item.BAQD_CAPXETXU = '3') then
            v_CAPXETXU:= 'phúc thẩm';
        else
            v_CAPXETXU:= 'sơ thẩm';
        end if;
        
        
        if (item.GHICHU IS NOT NULL)then
              v_GHICHU:= item.GHICHU;
            end if;
        if (item.QHPL_TEXT IS NOT NULL)then
              v_QHPL_TEXT:= item.QHPL_TEXT;
            end if;
        if (item.NOIDUNGDON IS NOT NULL)then
              V_NOIDUNG:= REPLACE(item.NOIDUNGDON,'TAND','Tòa án nhân dân'); --item.NOIDUNGDON;
            end if;
        if (item.NGAYNHANDON IS NOT NULL)then
              V_NGAYNHAN:= item.NGAYNHANDON;
            end if;
        if (item.BAQD_LOAIAN != 1) THEN
                select listagg(tenduongsu, '<br>') WITHIN GROUP (ORDER BY tenduongsu desc) into V_DANHSACH1
                    from GDTTT_DON_DUONGSU_CC 
                    where DONID = item.ID and tucachtotung like 'NGUYENDON';       
                select listagg(tenduongsu, '<br>') WITHIN GROUP (ORDER BY tenduongsu desc) into V_DANHSACH2
                    from GDTTT_DON_DUONGSU_CC
                    where DONID = item.ID and tucachtotung like 'BIDON';        
            else
                select listagg(TENDUONGSU, ' (Đầu vụ)<br>') WITHIN GROUP (ORDER BY ID desc) INTO V_LIST_DAUVU
                     from GDTTT_DON_DUONGSU_CC 
                     where DONID = item.ID and HS_ISBICAO = 1 AND HS_BICANDAUVU = 1;                    
                 select listagg(TENDUONGSU, '<br>') WITHIN GROUP (ORDER BY ID desc) INTO V_LIST_BICAN
                     from GDTTT_DON_DUONGSU_CC 
                     where DONID = item.ID and HS_ISBICAO = 1 AND HS_BICANDAUVU = 0;                     
                 select listagg(HS_TENTOIDANH, '<br>') WITHIN GROUP (ORDER BY ID desc) INTO V_LIST_DAUVU_TOIDANH
                     from GDTTT_DON_DUONGSU_CC 
                     where DONID = item.ID and HS_ISBICAO = 1 AND HS_BICANDAUVU = 1;                    
                 select listagg(HS_TENTOIDANH, '<br>') WITHIN GROUP (ORDER BY ID desc) INTO V_LIST_BICAN_TOIDANH
                     from GDTTT_DON_DUONGSU_CC 
                     where DONID = item.ID and HS_ISBICAO = 1 AND HS_BICANDAUVU = 0;                           
                 IF(V_LIST_DAUVU IS NOT NULL) THEN
                     --V_LIST_DAUVU := CONCAT(TO_CHAR(V_LIST_DAUVU),' (Đầu vụ)<br>');
                     V_LIST_DAUVU := CONCAT(TO_CHAR(V_LIST_DAUVU),'<br>'); --Khai sua
                     END IF;
                 IF(V_LIST_DAUVU_TOIDANH IS NOT NULL) THEN   
                     V_LIST_DAUVU_TOIDANH := CONCAT(TO_CHAR(V_LIST_DAUVU_TOIDANH),'<br>');
                     END IF;
                 V_DANHSACH1 := CONCAT(V_LIST_DAUVU,TO_CHAR(V_LIST_BICAN));
                 V_DANHSACH2 := CONCAT(V_LIST_DAUVU_TOIDANH,TO_CHAR(V_LIST_BICAN_TOIDANH));
            end if;        
        if(item.NGAYNHANDON IS NOT NULL) then
              V_NGAYNHAN:= item.NGAYNHANDON;
            end if;       
        if(item.DONGKHIEUNAI IS NOT NULL) then
              V_NGUOI_DNTBKN:= REPLACE(item.DONGKHIEUNAI, ',' , '<br>');
            end if;        
        IF(ITEM.NGUOIGUI_TUCACHTOTUNG IS NOT NULL) THEN
            IF(ITEM.LOAIDON = 9 OR ITEM.LOAIDON = 6) THEN
                V_TUCACHTOTUNG := '';
            ELSE
                IF(ITEM.NGUOIGUI_TUCACHTOTUNG = 1) THEN
                        V_TUCACHTOTUNG := 'Bị cáo';
                    ELSIF(ITEM.NGUOIGUI_TUCACHTOTUNG = 2) THEN
                        V_TUCACHTOTUNG := 'Người tham gia tố tụng';
                    ELSIF(ITEM.NGUOIGUI_TUCACHTOTUNG = 3) THEN
                        V_TUCACHTOTUNG := 'Người không liên quan đến vụ án';
                    ELSIF(ITEM.NGUOIGUI_TUCACHTOTUNG = 4) THEN
                        V_TUCACHTOTUNG := 'Khác';
                    END IF;
                END IF;
            END IF;
        IF (ITEM.CD_TA_DONVIID = 6) then
            V_DOVIGIAIQUYET := 'I';
        ElSIF  (ITEM.CD_TA_DONVIID = 7) then
            V_DOVIGIAIQUYET := 'II';
        ELSE
            V_DOVIGIAIQUYET := 'III';
        END IF;
        v_table.extend;
        v_table(v_table.count) := R_NOIBO_RUTHOSO(V_LOAIAN,
                                V_LOAIAN_TENHOSO,V_LOAIAN_TENBAQD,
                                V_SO_THULY, V_NGAY_THULY, V_THANG_THULY, V_NAM_THULY,
                                V_SO_BAQD, V_NGAY_BAQD, V_THANG_BAQD, V_NAM_BAQD,
                                V_TOAAN_GIAIQUYET,
                                V_THUTUCXETXU,
                                V_CAPXETXU,
                                V_GHICHU, 
                                V_DANHSACH1, V_DANHSACH2, 
                                V_QHPL_TEXT, V_NGUOI_DNTBKN, V_NGAYNHAN, V_NOIDUNG, V_TUCACHTOTUNG,V_DOVIGIAIQUYET);
    END LOOP;
    v_dem:=0;
    
    SELECT DONVIID INTO V_DONVIID FROM QT_NGUOISUDUNG
    WHERE ID = v_ID_USER;
    --- TEN DON VI
    SELECT REPLACE(TA.TEN,'Tòa án nhân dân cấp cao',''),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
     ,replace(HC.TEN,'thành phố ',''),TA.DIACHI INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL,V_TENDONVI_HC,V_TENDONVI_DIACHI FROM DM_TOAAN TA 
     LEFT JOIN DM_HANHCHINH HC ON HC.ID=TA.HANHCHINHID
     WHERE TA.ID=V_DONVIID;
    
     IF(V_BC_NGAYDK IS NOT NULL) THEN
            V_NGAY:= EXTRACT (DAY FROM to_date(V_BC_NGAYDK,'dd/MM/yyyy'));
            V_THANG:= EXTRACT (MONTH FROM to_date(V_BC_NGAYDK,'dd/MM/yyyy'));
            V_NAM:= EXTRACT (YEAR FROM to_date(V_BC_NGAYDK,'dd/MM/yyyy'));
     END IF;

    OPEN curReturn FOR
        SELECT COUNT(*) OVER () as CountAll,PA.*  FROM TABLE(V_TABLE) PA;
/*
    FOR item in (SELECT COUNT(*) OVER () as CountAll,PA.*  FROM TABLE(V_TABLE) PA)
    LOOP
        v_dem:=v_dem+1;
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
                    <th style="text-align: center; vertical-align: top; height: 25px; font-size: 12pt">TÒA ÁN NHÂN DÂN CẤP CAO</th>
                    <th style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                </tr>
                <tr>                   
                    <td style="text-align: center; vertical-align: top; height: 25px; font-size: 12pt">
                        <table cellpadding="0" cellspacing="0">');
                        IF(V_DONVIID = 4 or V_DONVIID = 5) THEN
                            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                            <tr style="height: 1pt; padding-bottom: 3px;">
                                <td style="text-align: right; padding-right: 2px; color: #ffffff;"><span>------</span></td>
                                    <th style="border-bottom: 1px solid #000000;">
                                        <span>'||Upper(V_TENDONVI)||'</span>
                                    </th>
                                <td style="text-align: left; padding-left: 2px; color: #ffffff;">-------</td>
                            </tr>');
                                ELSIF (V_DONVIID = 6) THEN
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                    <th style="border-bottom: 1px solid #000000;">
                                        <span>'||Upper(V_TENDONVI)||'</span>
                                    </th>');
                                END IF;

                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        </table>

                    </td>
                    <td>
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px; font-size: 12.5pt">
                                <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                                <th style="border-bottom: 1px solid #000000;">
                                    <span>ộc lập - Tự do - Hạnh ph</span>
                                </th>
                                <th style="text-align: left;"><span>úc</span></th>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr style="padding-top: 3px; font-size: 13pt;">
                    <td style="font-size: 13pt">Số: '||V_BC_SoCV||'/QĐ-TA</td>
                    <td style="font-style: italic; font-size: 13pt;"><span style="color: #ffffff;">........</span>'||V_TENDONVI_HC||', ngày <span>'||V_NGAY||'</span> tháng <span>'||V_THANG||'</span> năm <span>'||V_NAM||'</span></td>  
                </tr>
                <tr style="font-style: italic; font-size: 12pt;">
                    <td></td>
                    <td></td>
                </tr>
                <tr style="">
                    <td></td>
                    <td></td>
                </tr>           
             <tr>
                <td style="height: 20px;" colspan="2"></td>
            </tr>
            <tr>
                <th style="width: 1250px" colspan="2">QUYẾT ĐỊNH</th>
            </tr>          
            tr>
                <th style="width: 1250px" colspan="2">RÚT HỒ SƠ VỤ ÁN '||UPPER(item.LOAIAN_TENHOSO)||'</th>
            </tr>
            <tr>
                <th style="width: 1250px" colspan="2">
                <table cellpadding="0" cellspacing="0">
                    <td style="width: 400px"><span style="color:white;">............</span></td>
                    <th style="border-top: 1px solid #000000;height: 2px;width: 200px;">
                    <td style="width: 400px"><span style="color:white;">............</span></td>
                </table>
                </th>
            </tr>
            <tr>
                <th style="width: 1250px" colspan="2"> '|| UPPER(V_TENDONVI_FULL)||'</th>
            </tr>
        </table>');
        
        IF(V_DONVIID = 4) THEN
            IF (item.LOAIAN = 2) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">............</span>
                Căn cứ vào khoản 2 Điều 29 Luật Tổ chức Tòa án nhân dân, Điều 24 Luật Tố tụng hành chính;</p>
                ');
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">............</span>
                Căn cứ Thông tư liên tịch số 02/2016/TTLT-VKSNDTC-TANDTC ngày 31/08/2016 giữa Tòa án nhân dân tối cao và Viện kiểm sát nhân dân tối cao thi hành một số quy định của Bộ luật Tố tụng dân sự;</p>
                ');
            ELSIF  (item.LOAIAN = 3) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">............</span>
                Căn cứ Điều 376 Bộ luật tố tụng hình sự năm 2015;</p>
                ');
            ELSE
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">............</span>
                Căn cứ vào khoản 2 Điều 29 Luật Tổ chức Tòa án nhân dân, Điều 18 Bộ Luật Tố tụng dân sự;</p>
                ');
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">............</span>
                Căn cứ Thông tư liên tịch số 02/2016/TTLT-VKSNDTC-TANDTC ngày 31/08/2016 giữa Tòa án nhân dân tối cao và Viện kiểm sát nhân dân tối cao thi hành một số quy định của Bộ luật Tố tụng dân sự;</p>
                ');
            END IF;
        ELSE
            IF (item.LOAIAN = 2) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">............</span>
                Căn cứ vào khoản 2 Điều 29 Luật Tổ chức Tòa án nhân dân, Điều 24 Luật Tố tụng hành chính;</p>
                ');
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">............</span>
                Căn cứ Thông tư liên tịch số 02/2016/TTLT-VKSNDTC-TANDTC ngày 31/08/2016 giữa Tòa án nhân dân tối cao và Viện kiểm sát nhân dân tối cao thi hành một số quy định của Bộ luật Tố tụng dân sự;</p>
                ');
            ELSIF  (item.LOAIAN = 3) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">............</span>
                Căn cứ Điều 376 Bộ luật tố tụng hình sự năm 2015;</p>
                ');
            ELSE
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">............</span>
                Căn cứ vào khoản 2 Điều 29 Luật Tổ chức Tòa án nhân dân, Điều 18 Bộ Luật Tố tụng dân sự;</p>
                ');
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">............</span>
                Căn cứ Thông tư liên tịch số 02/2016/TTLT-VKSNDTC-TANDTC ngày 31/08/2016 giữa Tòa án nhân dân tối cao và Viện kiểm sát nhân dân tối cao thi hành một số quy định của Bộ luật Tố tụng dân sự;</p>
                ');
            END IF;
        END IF;
        
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:10pt"><span style="color:white;">............</span>
            Để có tài liệu nghiên cứu, giám đốc thẩm/tái thẩm việc xét xử;</p>
           ');
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
        <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 13pt; text-align: center; border-collapse: collapse;">
            <tr>
                <th style="width: 1250px" colspan="2"> QUYẾT ĐỊNH:</th>
            </tr>
        </table>              
           ');
        
        IF(V_DONVIID = 4) THEN
            IF (item.LOAIAN = 2) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:4pt"><span style="color:white;">............</span>
                <b>Điều 1.</b> Rút hồ sơ vụ án '||LOWER(V_LOAIAN_TENHOSO)||' "'||item.QHTC ||'" do '|| item.TOAAN_GIAIQUYET||' xét xử '||v_CAPXETXU||' tại Bản án '||LOWER(V_LOAIAN_TENHOSO)||'
                '||v_CAPXETXU||' số '||item.SO_BAQD||' ngày '||to_char(to_date(item.NGAY_BAQD||'/'||item.THANG_BAQD||'/'||item.NAM_BAQD, 'dd/MM/yyyy'), 'dd/MM/yyyy')||' của');
                
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' người khởi kiện là '||item.DANHSACH1||' với người bị kiện là '||item.DANHSACH2||'.</p>'); 
            ELSIF  (item.LOAIAN = 3) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:4pt"><span style="color:white;">............</span>
                <b>Điều 1.</b> Rút hồ sơ vụ án '||LOWER(V_LOAIAN_TENHOSO)|| ' ' || item.DANHSACH1 ||' bị kết án về tội "'||REPLACE(SUBSTR(item.DANHSACH2,instr(item.DANHSACH2,'.')+1), ' (BLHS 2017)', '')||'" do '|| item.TOAAN_GIAIQUYET||' xét xử '||v_CAPXETXU||' tại Bản án '||LOWER(V_LOAIAN_TENHOSO)||'
                '||v_CAPXETXU||' số '||item.SO_BAQD||' ngày '||to_char(to_date(item.NGAY_BAQD||'/'||item.THANG_BAQD||'/'||item.NAM_BAQD, 'dd/MM/yyyy'), 'dd/MM/yyyy')||'.');
            ELSE
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:4pt"><span style="color:white;">............</span>
                <b>Điều 1.</b> Rút hồ sơ vụ án '||LOWER(V_LOAIAN_TENHOSO)||' "'||item.QHTC ||'" do '|| item.TOAAN_GIAIQUYET||' xét xử '||v_CAPXETXU||' tại Bản án '||LOWER(V_LOAIAN_TENHOSO)||'
                '||v_CAPXETXU||' số '||item.SO_BAQD||' ngày '||to_char(to_date(item.NGAY_BAQD||'/'||item.THANG_BAQD||'/'||item.NAM_BAQD, 'dd/MM/yyyy'), 'dd/MM/yyyy')||' của');
            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' nguyên đơn là '||item.DANHSACH1||' và bị đơn là '||item.DANHSACH2||'.</p>'); 
            END IF;
        ELSE
            IF (item.LOAIAN = 2) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:4pt"><span style="color:white;">............</span>
                <b>Điều 1.</b> Rút hồ sơ vụ án '||LOWER(V_LOAIAN_TENHOSO)||' "'||item.QHTC ||'" do '|| item.TOAAN_GIAIQUYET||' xét xử '||v_CAPXETXU||' tại Bản án '||LOWER(V_LOAIAN_TENHOSO)||'
                '||v_CAPXETXU||' số '||item.SO_BAQD||' ngày '||to_char(to_date(item.NGAY_BAQD||'/'||item.THANG_BAQD||'/'||item.NAM_BAQD, 'dd/MM/yyyy'), 'dd/MM/yyyy')||' của');
                
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' người khởi kiện là '||item.DANHSACH1||' với người bị kiện là '||item.DANHSACH2||'.</p>'); 
            ELSIF  (item.LOAIAN = 3) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:4pt"><span style="color:white;">............</span>
                <b>Điều 1.</b> Rút hồ sơ vụ án '||LOWER(V_LOAIAN_TENHOSO)|| ' ' || item.DANHSACH1 ||' bị kết án về tội "'||REPLACE(SUBSTR(item.DANHSACH2,instr(item.DANHSACH2,'.')+1), ' (BLHS 2017)', '')||'" do '|| item.TOAAN_GIAIQUYET||' xét xử '||v_CAPXETXU||' tại Bản án '||LOWER(V_LOAIAN_TENHOSO)||'
                '||v_CAPXETXU||' số '||item.SO_BAQD||' ngày '||to_char(to_date(item.NGAY_BAQD||'/'||item.THANG_BAQD||'/'||item.NAM_BAQD, 'dd/MM/yyyy'), 'dd/MM/yyyy')||'.');
            ELSE
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:4pt"><span style="color:white;">............</span>
                <b>Điều 1.</b> Rút hồ sơ vụ án '||LOWER(V_LOAIAN_TENHOSO)||' "'||item.QHTC ||'" do '|| item.TOAAN_GIAIQUYET||' xét xử '||v_CAPXETXU||' tại Bản án '||LOWER(V_LOAIAN_TENHOSO)||'
                '||v_CAPXETXU||' số '||item.SO_BAQD||' ngày '||to_char(to_date(item.NGAY_BAQD||'/'||item.THANG_BAQD||'/'||item.NAM_BAQD, 'dd/MM/yyyy'), 'dd/MM/yyyy')||' của');
            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' nguyên đơn là '||item.DANHSACH1||' và bị đơn là '||item.DANHSACH2||'.</p>'); 
            END IF;
        END IF;
           
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">............</span>
            <b>Điều 2.</b> Đề nghị Chánh án  '||item.TOAAN_GIAIQUYET||' chuyển hồ sơ vụ án nêu trên đến '||V_TENDONVI_FULL ||' trong thời gian 07 ngày kể từ ngày nhận được quyết định này.</p>
           ');
          DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">............</span><i><b>Ghi chú:</b></i></p>
            <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">............</span><i>
            - Đề nghị gửi hồ sơ vụ án theo phương thức yêu cầu giao Bưu điện trực tiếp cho Phòng GĐKT '|| item.DONVIGIAIQUYET||' '||V_TENDONVI_FULL ||', '||V_TENDONVI_DIACHI||'.</i></p>
            <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:16pt"><span style="color:white;">............</span><i>
            - Nếu hồ sơ vụ án đã được chuyển đến các cơ quan khác thì thông báo bằng văn bản cho '||V_TENDONVI_FULL||' để theo dõi.</i></p>
          ');
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                  <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 13pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="vertical-align: top;">
                        <p style="font-size: 11pt; text-align: left; line-height: 105%;">
                            <i><b>Nơi nhận:</b></i><br/>
                            - Như trên;<br />
                            - Chánh án '||V_DONVI_CV||' '||V_TENDONVI||' (để biết);<br/>
                            - '||REPLACE(item.TOAAN_GIAIQUYET, 'Tòa án nhân dân', 'TAND')||' (để thi hành);<br/>
                            - Lưu: VP, Phòng GĐKT '||item.DONVIGIAIQUYET||', hồ sơ GĐT.<br/>
                        </p>
                    </td>
                    <td>
                         <p style="font-size:13pt;">
                              <strong>
                                TL. CHÁNH ÁN<br />
                                KT. CHÁNH VĂN PHÒNG<br />
                                PHÓ CHÁNH VĂN PHÒNG<br />
                            </strong>
                        </p>
                        <br /> <br />
                    </td>
                </tr>
                 <tr>
                    <td style="width: 500pt"></td>
                    <td style="height: 100px;width: 500pt;">
                         <p style="font-size:13pt;margin-top:10pt;"><strong>'||V_BC_Nguoiky||'</strong></p>
                    </td>
                </tr>
            </table>
            ');
            IF(v_dem<item.CountAll) THEN
               DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <span style="font-size:12.0pt;font-family:''Times New Roman'',serif;mso-fareast-font-family:
                ''Times New Roman'';mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                mso-fareast-language:EN-US;mso-bidi-language:AR-SA">
                <br clear=all style="mso-special-character:line-break;page-break-before:always">
                </span>
                ');
            END IF;
        
        
    END LOOP;
    OPEN curReturn FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
*/
end if;
END REPORT_QDRUT_HOSO_CC;

END PKG_GDTTT_HCTP_BC_CC;