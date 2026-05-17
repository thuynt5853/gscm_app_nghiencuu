--------------------------------------------------------
--  DDL for Package Body UYTHACTUPHAP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."UYTHACTUPHAP" AS  
   
    FUNCTION UYTHACTUPHAP_DEN_INDANHSACH
(
    vQuocGia NUMBER,
  vLoaiTimKiem number,
  vKetQuaUT number,
  vTuNgay varchar2,
  vDenNgay varchar2,
  vNguoiThucHienUT number
)RETURN SYS_REFCURSOR
AS  
    V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;
   vvTuNgay date;
    vvDenNgay date;
    vDEM NUMBER; 
BEGIN	
DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
if(vTuNgay IS NOT NULL) then  vvTuNgay:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  vvDenNgay:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 
    vDEM:=0;
    -----print dữ liệu----   
          FOR items IN ( 
                 select a.COQUANUT,
                a.ID,
                to_char(a.NGAYNHANUTTP,'dd/MM/yyyy') NGAYNHANUTTP,
                a.VANBANUT,
                (CASE a.KETQUAUT
                  WHEN 1 THEN 'Đã thực hiện'
                  WHEN 2 THEN 'Từ chối thực hiện'
                  WHEN 3 THEN 'Chưa thực hiện'
                  ELSE ''
                END) TENKETQUAUT,
                c.HOTEN TENNGUOITHUCHIENUT,
                to_char(a.NGAYCOKETQUAUT,'dd/MM/yyyy') NGAYCOKETQUAUT,

                b.TEN TENQUOCGIAUT
                from UYTHACTUPHAPDEN a
                left join DM_DATAITEM b on a.QUOCGIAUT = b.ID
                left join DM_CANBO c on a.NGUOITHUCHIENUT=c.ID
                where 
                (vQuocGia=0 or a.QUOCGIAUT=vQuocGia)
                and
                (vTuNgay is null or (a.NGAYNHANUTTP>=vvTuNgay and vLoaiTimKiem=1) or (a.NGAYCOKETQUAUT>=vvTuNgay and vLoaiTimKiem=2))
                and
                (vDenNgay is null or (a.NGAYNHANUTTP<=vvDenNgay and vLoaiTimKiem=1) or (a.NGAYCOKETQUAUT<=vvDenNgay and vLoaiTimKiem=2))
                and
                (vKetQuaUT=0 or a.KETQUAUT=vKetQuaUT)
                and
                (vNguoiThucHienUT=0 or a.NGUOITHUCHIENUT=vNguoiThucHienUT)
               )
               LOOP
                vDEM:=vDEM+1;
                      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                      <tr>
                         <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 70px;">'||vDEM||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"colspan="3">'||items.COQUANUT||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"colspan="2">'||items.TENQUOCGIAUT||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 150px;">'||items.NGAYNHANUTTP||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"colspan="3">'||items.VANBANUT||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan="2">'||items.TENKETQUAUT||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan="2">'||items.NGAYCOKETQUAUT||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"colspan="2">'||items.TENNGUOITHUCHIENUT||'</td>

                      </tr>
                   '); 
               END LOOP;   
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
          <tr>
                <td colspan="15" style="line-height: 100%; font-size: 13pt; text-align: center; height: 26px;"></td>
            </tr>
            <tr>
                <td colspan="15" style="line-height: 100%; font-size: 13pt; text-align: center; height: 40px;"><b>DANH SÁCH ỦY THÁC TƯ PHÁP ĐẾN</b></td>
            </tr>
            <tr>
                <td colspan="15" style="line-height: 100%; font-size: 13pt; text-align: center; height: 26px;"></td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 70px;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan="3">Cơ quan UTTP</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan="2">Quốc gia UTTP</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 150px;">Ngày nhận UTTP</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan="3">Tài liệu yêu cầu UTTP</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan="2">Kết quả UTTP</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan="2">Ngày có kết quả UTTP</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan="2">Người thực hiện</td>
            </tr>
                 '); 
      ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
      DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );

     -----------------------
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <tr style="height: 1px;">
               <td style="width: 30px"></td>
                <td style="width: 150px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 120px"></td>
            </tr>
        </table>
      ');
    ----------------------------

    OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;  

 END UYTHACTUPHAP_DEN_INDANHSACH; 


    FUNCTION GETUTTP_DI_INDANHSACH
(
    vDuongSu in varchar2,
    vSoThuLy in varchar2,
    vNgayThuLy in varchar2,
    vCapXetXu number,
    vLoaiAn   in varchar2,
    vThuKy    number,
    vThamPhan    number,
    vVanBanUT number,
    vDonViUT number,
    vQuocGiaUT number,
    vloaiTimKiem in number,
    vTuNgay in varchar2,
    vDenNgay in varchar2,
    vKetQuaUT in number,
    vDonVi in number
)RETURN SYS_REFCURSOR
IS 
V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;
    vvNgayThuLy date;
    vvTuNgay date;
    vvDenNgay date;
    vDEM NUMBER; 
BEGIN
vDEM:=0;
DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
if(vNgayThuLy IS NOT NULL) then  vvNgayThuLy:=to_date(trim(vNgayThuLy)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
if(vTuNgay IS NOT NULL) then  vvTuNgay:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
if(vDenNgay IS NOT NULL) then  vvDenNgay:=to_date(trim(vDenNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
-----nếu là cấp xét xử sơ thẩm
    FOR items IN (
    select * from (--lấy dân sự
        select ads_dt.NGAYGUI, ads_dt.ID,ads_td.TOAANID,
        ('<div style="text-align:left;">'||ads_ds.TENDUONGSU|| DECODE(ad.QUANHEPHAPLUAT_NAME,'','','-'||ad.QUANHEPHAPLUAT_NAME) || 
        DECODE(DECODE(ads_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Dân sự <br/> Thụ lý số:'||DECODE(ads_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' 
        ngày:'||DECODE(ads_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')
        || DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK)
        )
        ||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT, 
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ads_dt.ID||'_02' DATAID,
        to_char(utd.NGAYCHUYENKQUTVETOACAPDUOI,'dd/MM/yyyy') NGAYCHUYENKQUTVETOACAPDUOI
        from ADS_TONGDAT ads_td
        inner join ADS_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join ADS_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join ADS_SOTHAM_THULY st on ads_td.DONID=st.DONID
        left join ADS_PHUCTHAM_THULY pt on ads_td.DONID=pt.DONID
        left join ADS_DON_GIAIDOAN ads_gd on ads_td.DONID=ads_gd.DONID
        inner join DM_TOAAN t on ads_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ads_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ads_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ads_dt.KETQUAUTTP=q1.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from ADS_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        left join ADS_DON ad  on ads_td.DONID=ad.ID
        where 
        (vDuongSu is null or LOWER(ads_ds.TENDUONGSU) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM ADS_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ads_ds.DONID and PC.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON') )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM ADS_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ads_ds.DONID and TK.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON') )))
        and
        (vVanBanUT=0 or ads_td.BIEUMAUID=vVanBanUT)
        and 
        ((ads_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ads_dt.QUOCGIA=vQuocGiaUT)
        and  
        (vKetQuaUT=0 or ads_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ads_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ads_dt.HINHTHUCGUI=4 ))
        and 
        (vCapXetXu =0 or ads_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ads_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from ADS_DON_GIAIDOAN where DONID=ads_td.DONID))
        and 
        (vLoaiAn='0' or vLoaiAn='02')
        union
        ---lấy hành chính 
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.HOTEN|| DECODE(ad.QUANHEPHAPLUAT_NAME,'','','-'||ad.QUANHEPHAPLUAT_NAME) || DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Hành chính <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK)
        )||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT,
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_06' DATAID,
        to_char(utd.NGAYCHUYENKQUTVETOACAPDUOI,'dd/MM/yyyy') NGAYCHUYENKQUTVETOACAPDUOI

        from AHC_TONGDAT ahc_td
        inner join AHC_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT 
         left join (SELECT ID,TENDUONGSU HOTEN,DONID FROM AHC_DON_DUONGSU Union All SELECT ID,HOTEN,DONID FROM AHC_DON_THAMGIATOTUNG) ahc_ds on ahc_dt.DUONGSUID=ahc_ds.ID
        left join AHC_SOTHAM_THULY st on ahc_td.DONID=st.DONID
        left join AHC_PHUCTHAM_THULY pt on ahc_td.DONID=pt.DONID
        left join AHC_DON_GIAIDOAN ahc_gd on ahc_td.DONID=ahc_gd.DONID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AHC_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        left join AHC_DON ad  on ahc_td.DONID=ad.ID
        where 
        (vDuongSu is null or LOWER(ahc_ds.HOTEN) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM AHC_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID and PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID and PC.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON') )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM AHC_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ahc_ds.DONID and TK.CANBOID = vThuKy  AND TK.DONID=ahc_ds.DONID and TK.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON') )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4)) 
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ahc_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from AHC_DON_GIAIDOAN where DONID=ahc_td.DONID))
        and 
        (vLoaiAn='0' or vLoaiAn='06')
        union
        ---lấy hôn nhân gia đình
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.TENDUONGSU|| DECODE(ad.QUANHEPHAPLUAT_NAME,'','','-'||ad.QUANHEPHAPLUAT_NAME) || DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Hôn nhân gia đình <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK))||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT,
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_03' DATAID,
        to_char(utd.NGAYCHUYENKQUTVETOACAPDUOI,'dd/MM/yyyy') NGAYCHUYENKQUTVETOACAPDUOI

        from AHN_TONGDAT ahc_td
        inner join AHN_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join AHN_DON_DUONGSU ahc_ds on ahc_td.DONID=ahc_ds.DONID and ahc_dt.DUONGSUID=ahc_ds.ID
        left join AHN_SOTHAM_THULY st on ahc_td.DONID=st.DONID
        left join AHN_PHUCTHAM_THULY pt on ahc_td.DONID=pt.DONID
        left join AHN_DON_GIAIDOAN ahc_gd on ahc_td.DONID=ahc_gd.DONID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AHN_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_ds.DONID=tptks.DONIDS  and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        left join AHN_DON ad  on ahc_td.DONID=ad.ID
        where 
        (vDuongSu is null or LOWER(ahc_ds.TENDUONGSU) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM AHN_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM AHN_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ahc_ds.DONID )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4))
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ahc_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from AHN_DON_GIAIDOAN where DONID=ahc_td.DONID))
        and 
        (vLoaiAn='0' or vLoaiAn='03')
        union
        ---lấy kinh doanh thương mại
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.TENDUONGSU || DECODE(ad.QUANHEPHAPLUAT_NAME,'','','-'||ad.QUANHEPHAPLUAT_NAME)|| DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Kinh doanh thương mại <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK))||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT,
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_04' DATAID,
        to_char(utd.NGAYCHUYENKQUTVETOACAPDUOI,'dd/MM/yyyy') NGAYCHUYENKQUTVETOACAPDUOI

        from AKT_TONGDAT ahc_td
        inner join AKT_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT
        inner join AKT_DON_DUONGSU ahc_ds on ahc_td.DONID=ahc_ds.DONID and ahc_dt.DUONGSUID=ahc_ds.ID
        left join AKT_SOTHAM_THULY st on ahc_td.DONID=st.DONID
        left join AKT_PHUCTHAM_THULY pt on ahc_td.DONID=pt.DONID
        left join AKT_DON_GIAIDOAN ahc_gd on ahc_td.DONID=ahc_gd.DONID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AKT_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        left join AKT_DON ad  on ahc_td.DONID=ad.ID
        where 
        (vDuongSu is null or LOWER(ahc_ds.TENDUONGSU) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM AKT_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM AKT_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ahc_ds.DONID )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4))
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ahc_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from AKT_DON_GIAIDOAN where DONID=ahc_td.DONID))
        and 
        (vLoaiAn='0' or vLoaiAn='04')
        union
        ---lấy lao động
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.TENDUONGSU|| DECODE(ad.QUANHEPHAPLUAT_NAME,'','','-'||ad.QUANHEPHAPLUAT_NAME) || DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Lao động <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK))||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT,
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_05' DATAID,
        to_char(utd.NGAYCHUYENKQUTVETOACAPDUOI,'dd/MM/yyyy') NGAYCHUYENKQUTVETOACAPDUOI

        from ALD_TONGDAT ahc_td
        inner join ALD_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join ALD_DON_DUONGSU ahc_ds on ahc_td.DONID=ahc_ds.DONID and ahc_dt.DUONGSUID=ahc_ds.ID
        left join ALD_SOTHAM_THULY st on ahc_td.DONID=st.DONID
        left join ALD_PHUCTHAM_THULY pt on ahc_td.DONID=pt.DONID
        left join ALD_DON_GIAIDOAN ahc_gd on ahc_td.DONID=ahc_gd.DONID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from ALD_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        left join ALD_DON ad  on ahc_td.DONID=ad.ID
        where 
        (vDuongSu is null or LOWER(ahc_ds.TENDUONGSU) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM ALD_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM ALD_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ahc_ds.DONID )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4))
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ahc_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from ALD_DON_GIAIDOAN where DONID=ahc_td.DONID))
        and 
        (vLoaiAn='0' or vLoaiAn='05')
        union
        ---lấy án phá sản
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.TENDUONGSU|| DECODE(ahc_gd.QUANHEPHAPLUAT_NAME,'','','-'||ahc_gd.QUANHEPHAPLUAT_NAME) || DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Phá sản <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK))||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT,
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_07' DATAID,
        to_char(utd.NGAYCHUYENKQUTVETOACAPDUOI,'dd/MM/yyyy') NGAYCHUYENKQUTVETOACAPDUOI

        from APS_TONGDAT ahc_td
        inner join APS_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT
        inner join APS_DON_DUONGSU ahc_ds on ahc_td.DONID=ahc_ds.DONID and ahc_dt.DUONGSUID=ahc_ds.ID
        left join APS_SOTHAM_THULY st on ahc_td.DONID=st.DONID
        left join APS_PHUCTHAM_THULY pt on ahc_td.DONID=pt.DONID
        left join APS_DON ahc_gd on ahc_td.DONID=ahc_gd.ID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
       left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from APS_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (vDuongSu is null or LOWER(ahc_ds.TENDUONGSU) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM APS_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM APS_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ahc_ds.DONID )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4))
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ahc_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from APS_DON where ID=ahc_td.DONID))
        and 
        (vLoaiAn='0' or vLoaiAn='07')
        union
        ---lấy án hình sự
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.HOTEN|| DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Hình sự <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK))||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT,
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_01' DATAID,
        to_char(utd.NGAYCHUYENKQUTVETOACAPDUOI,'dd/MM/yyyy') NGAYCHUYENKQUTVETOACAPDUOI

        from AHS_TONGDAT ahc_td
        inner join AHS_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT 
        left join (SELECT ID,HOTEN FROM AHS_BICANBICAO Union All SELECT ID,HOTEN FROM AHS_NGUOITHAMGIATOTUNG) ahc_ds on ahc_dt.DUONGSUID=ahc_ds.ID
        left join AHS_SOTHAM_THULY st on ahc_td.VUANID=st.VUANID
        left join AHS_PHUCTHAM_THULY pt on ahc_td.VUANID=pt.VUANID
        inner join AHS_VUAN ahc_gd on ahc_td.VUANID=ahc_gd.ID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
        left join (select tptk.VUANID VUANIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AHS_THAMPHANGIAIQUYET tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_td.VUANID=tptks.VUANIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (vDuongSu is null or LOWER(ahc_ds.HOTEN) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC WHERE   PC.CANBOID = vThamPhan  AND PC.VUANID=ahc_td.VUANID )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM AHS_THAMPHANGIAIQUYET TK WHERE   TK.THUKYID = vThuKy  AND TK.VUANID=ahc_td.VUANID )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4))
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ahc_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from AHS_VUAN where ID=ahc_td.VUANID))
        and 
        (vLoaiAn='0' or vLoaiAn='01') 
        /*union
        ---lấy án BPXLHC
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.HOTEN|| DECODE(ahc_gd.QUANHEPHAPLUAT_NAME,'','','-'||ahc_gd.QUANHEPHAPLUAT_NAME) || DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: BPXLHC <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK))||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT, 
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_08' DATAID,
        utd.NGAYCHUYENKQUTVETOACAPDUOI

        from XLHC_TONGDAT ahc_td
        inner join XLHC_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT
        inner join XLHC_DUONGSU ahc_ds on ahc_td.DONID=ahc_ds.DONID and ahc_dt.DUONGSUID=ahc_ds.ID
        left join XLHC_SOTHAM_THULY st on ahc_td.DONID=st.DONID
        left join XLHC_PHUCTHAM_THULY pt on ahc_td.DONID=pt.DONID
        left join XLHC_DON ahc_gd on ahc_td.DONID=ahc_gd.ID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
       left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from XLHC_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (vDuongSu is null or LOWER(ahc_ds.HOTEN) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM XLHC_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM XLHC_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ahc_ds.DONID )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4))
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and 
        (vLoaiAn='0' or vLoaiAn='08')*/)

        order by NGAYGUI desc
        )
        LOOP
            vDEM:=vDEM+1;
                      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                      <tr>
                         <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 70px;">'||vDEM||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"colspan="4">'||items.THONGTINVUAN||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"colspan="3">'||items.NGAYUT_VBUT||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 200px;">'||items.DONVIUTTP||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"colspan="2">'||items.QUOCGIAUTTP||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 150px;">'||items.NGAYCHUYENUTTP||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 200px;">'||items.KETQUAUTTP||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 150px;">'||items.NGAYCHUYENKQUTVETOACAPDUOI||'</td>
                      </tr>
                   '); 

        END LOOP;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
          <tr>
                <td colspan="15" style="line-height: 100%; font-size: 13pt; text-align: center; height: 26px;"></td>
            </tr>
            <tr>
                <td colspan="15" style="line-height: 100%; font-size: 13pt; text-align: center; height: 40px;"><b>DANH SÁCH ỦY THÁC TƯ PHÁP ĐI</b></td>
            </tr>
            <tr>
                <td colspan="15" style="line-height: 100%; font-size: 13pt; text-align: center; height: 26px;"></td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 70px;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan="4">Thông tin vụ án/vụ việc</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan="3">Văn bản UTTP</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 200px;">Đơn vị</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan="2">Quốc gia</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 150px;">Ngày chuyển</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 200px;">Kết quả UTTP</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 150px;">Ngày chuyển KQ về Tòa cấp dưới</td>
            </tr>
                 '); 
      ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
      DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );

     -----------------------
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <tr style="height: 1px;">
               <td style="width: 30px"></td>
                <td style="width: 150px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 120px"></td>
            </tr>
        </table>
      ');
    ----------------------------

    OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;  
END GETUTTP_DI_INDANHSACH;




 PROCEDURE  GETUTTP_DI
(   vDuongSu in varchar2,
    vSoThuLy in varchar2,
    vNgayThuLy in varchar2,
    vCapXetXu number,
    vLoaiAn   in varchar2,
    vThuKy    number,
    vThamPhan    number,
    vVanBanUT number,
    vDonViUT number,
    vQuocGiaUT number,
    vloaiTimKiem in number,
    vTuNgay in varchar2,
    vDenNgay in varchar2,
    vKetQuaUT in number,
    vDonVi in number,
    curReturn    OUT       sys_refcursor
)
IS 
    vvNgayThuLy date;
    vvTuNgay date;
    vvDenNgay date;
BEGIN
if(vNgayThuLy IS NOT NULL) then  vvNgayThuLy:=to_date(trim(vNgayThuLy)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
if(vTuNgay IS NOT NULL) then  vvTuNgay:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
if(vDenNgay IS NOT NULL) then  vvDenNgay:=to_date(trim(vDenNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
-----nếu là cấp xét xử sơ thẩm
    OPEN curReturn FOR
    select * from (--lấy dân sự
        select ads_dt.NGAYGUI, ads_dt.ID,ads_td.TOAANID,
        ('<div style="text-align:left;">'||ads_ds.TENDUONGSU|| DECODE(ad.QUANHEPHAPLUAT_NAME,'','','-'||ad.QUANHEPHAPLUAT_NAME) || 
        DECODE(DECODE(ads_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Dân sự <br/> Thụ lý số:'||DECODE(ads_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' 
        ngày:'||DECODE(ads_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')
        || DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK)
        )
        ||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT, 
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ads_dt.ID||'_02' DATAID,
        utd.NGAYCHUYENKQUTVETOACAPDUOI
        from ADS_TONGDAT ads_td
        inner join ADS_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join ADS_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join ADS_SOTHAM_THULY st on ads_td.DONID=st.DONID
        left join ADS_PHUCTHAM_THULY pt on ads_td.DONID=pt.DONID
        left join ADS_DON_GIAIDOAN ads_gd on ads_td.DONID=ads_gd.DONID
        inner join DM_TOAAN t on ads_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ads_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ads_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ads_dt.KETQUAUTTP=q1.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from ADS_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        left join ADS_DON ad  on ads_td.DONID=ad.ID
        where 
        (vDuongSu is null or LOWER(ads_ds.TENDUONGSU) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM ADS_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ads_ds.DONID and PC.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON') )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM ADS_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ads_ds.DONID and TK.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON') )))
        and
        (vVanBanUT=0 or ads_td.BIEUMAUID=vVanBanUT)
        and 
        ((ads_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ads_dt.QUOCGIA=vQuocGiaUT)
        and  
        (vKetQuaUT=0 or ads_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ads_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ads_dt.HINHTHUCGUI=4 ))
        and 
        (vCapXetXu =0 or ads_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ads_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from ADS_DON_GIAIDOAN where DONID=ads_td.DONID))
        and 
        (vLoaiAn='0' or vLoaiAn='02')
        union
        ---lấy hành chính 
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.HOTEN|| DECODE(ad.QUANHEPHAPLUAT_NAME,'','','-'||ad.QUANHEPHAPLUAT_NAME) || DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Hành chính <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK)
        )||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT,
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_06' DATAID,
        utd.NGAYCHUYENKQUTVETOACAPDUOI

        from AHC_TONGDAT ahc_td
        inner join AHC_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT 
         left join (SELECT ID,TENDUONGSU HOTEN,DONID FROM AHC_DON_DUONGSU Union All SELECT ID,HOTEN,DONID FROM AHC_DON_THAMGIATOTUNG) ahc_ds on ahc_dt.DUONGSUID=ahc_ds.ID
        left join AHC_SOTHAM_THULY st on ahc_td.DONID=st.DONID
        left join AHC_PHUCTHAM_THULY pt on ahc_td.DONID=pt.DONID
        left join AHC_DON_GIAIDOAN ahc_gd on ahc_td.DONID=ahc_gd.DONID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AHC_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        left join AHC_DON ad  on ahc_td.DONID=ad.ID
        where 
        (vDuongSu is null or LOWER(ahc_ds.HOTEN) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM AHC_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID and PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID and PC.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON') )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM AHC_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ahc_ds.DONID and TK.CANBOID = vThuKy  AND TK.DONID=ahc_ds.DONID and TK.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON') )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4)) 
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ahc_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from AHC_DON_GIAIDOAN where DONID=ahc_td.DONID))
        and 
        (vLoaiAn='0' or vLoaiAn='06')
        union
        ---lấy hôn nhân gia đình
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.TENDUONGSU|| DECODE(ad.QUANHEPHAPLUAT_NAME,'','','-'||ad.QUANHEPHAPLUAT_NAME) || DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Hôn nhân gia đình <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK))||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT,
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_03' DATAID,
        utd.NGAYCHUYENKQUTVETOACAPDUOI

        from AHN_TONGDAT ahc_td
        inner join AHN_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join AHN_DON_DUONGSU ahc_ds on ahc_td.DONID=ahc_ds.DONID and ahc_dt.DUONGSUID=ahc_ds.ID
        left join AHN_SOTHAM_THULY st on ahc_td.DONID=st.DONID
        left join AHN_PHUCTHAM_THULY pt on ahc_td.DONID=pt.DONID
        left join AHN_DON_GIAIDOAN ahc_gd on ahc_td.DONID=ahc_gd.DONID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AHN_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_ds.DONID=tptks.DONIDS  and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        left join AHN_DON ad  on ahc_td.DONID=ad.ID
        where 
        (vDuongSu is null or LOWER(ahc_ds.TENDUONGSU) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM AHN_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM AHN_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ahc_ds.DONID )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4))
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ahc_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from AHN_DON_GIAIDOAN where DONID=ahc_td.DONID))
        and 
        (vLoaiAn='0' or vLoaiAn='03')
        union
        ---lấy kinh doanh thương mại
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.TENDUONGSU || DECODE(ad.QUANHEPHAPLUAT_NAME,'','','-'||ad.QUANHEPHAPLUAT_NAME)|| DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Kinh doanh thương mại <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK))||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT,
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_04' DATAID,
        utd.NGAYCHUYENKQUTVETOACAPDUOI

        from AKT_TONGDAT ahc_td
        inner join AKT_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT
        inner join AKT_DON_DUONGSU ahc_ds on ahc_td.DONID=ahc_ds.DONID and ahc_dt.DUONGSUID=ahc_ds.ID
        left join AKT_SOTHAM_THULY st on ahc_td.DONID=st.DONID
        left join AKT_PHUCTHAM_THULY pt on ahc_td.DONID=pt.DONID
        left join AKT_DON_GIAIDOAN ahc_gd on ahc_td.DONID=ahc_gd.DONID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AKT_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        left join AKT_DON ad  on ahc_td.DONID=ad.ID
        where 
        (vDuongSu is null or LOWER(ahc_ds.TENDUONGSU) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM AKT_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM AKT_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ahc_ds.DONID )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4))
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ahc_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from AKT_DON_GIAIDOAN where DONID=ahc_td.DONID))
        and 
        (vLoaiAn='0' or vLoaiAn='04')
        union
        ---lấy lao động
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.TENDUONGSU|| DECODE(ad.QUANHEPHAPLUAT_NAME,'','','-'||ad.QUANHEPHAPLUAT_NAME) || DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Lao động <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK))||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT,
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_05' DATAID,
        utd.NGAYCHUYENKQUTVETOACAPDUOI

        from ALD_TONGDAT ahc_td
        inner join ALD_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join ALD_DON_DUONGSU ahc_ds on ahc_td.DONID=ahc_ds.DONID and ahc_dt.DUONGSUID=ahc_ds.ID
        left join ALD_SOTHAM_THULY st on ahc_td.DONID=st.DONID
        left join ALD_PHUCTHAM_THULY pt on ahc_td.DONID=pt.DONID
        left join ALD_DON_GIAIDOAN ahc_gd on ahc_td.DONID=ahc_gd.DONID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from ALD_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        left join ALD_DON ad  on ahc_td.DONID=ad.ID
        where 
        (vDuongSu is null or LOWER(ahc_ds.TENDUONGSU) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM ALD_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM ALD_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ahc_ds.DONID )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4))
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ahc_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from ALD_DON_GIAIDOAN where DONID=ahc_td.DONID))
        and 
        (vLoaiAn='0' or vLoaiAn='05')
        union
        ---lấy án phá sản
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.TENDUONGSU|| DECODE(ahc_gd.QUANHEPHAPLUAT_NAME,'','','-'||ahc_gd.QUANHEPHAPLUAT_NAME) || DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Phá sản <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK))||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT,
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_07' DATAID,
        utd.NGAYCHUYENKQUTVETOACAPDUOI

        from APS_TONGDAT ahc_td
        inner join APS_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT
        inner join APS_DON_DUONGSU ahc_ds on ahc_td.DONID=ahc_ds.DONID and ahc_dt.DUONGSUID=ahc_ds.ID
        left join APS_SOTHAM_THULY st on ahc_td.DONID=st.DONID
        left join APS_PHUCTHAM_THULY pt on ahc_td.DONID=pt.DONID
        left join APS_DON ahc_gd on ahc_td.DONID=ahc_gd.ID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
       left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from APS_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (vDuongSu is null or LOWER(ahc_ds.TENDUONGSU) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM APS_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM APS_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ahc_ds.DONID )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4))
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ahc_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from APS_DON where ID=ahc_td.DONID))
        and 
        (vLoaiAn='0' or vLoaiAn='07')
        union
        ---lấy án hình sự
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.HOTEN|| DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: Hình sự <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK))||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT,
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_01' DATAID,
        utd.NGAYCHUYENKQUTVETOACAPDUOI

        from AHS_TONGDAT ahc_td
        inner join AHS_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT 
        left join (SELECT ID,HOTEN FROM AHS_BICANBICAO Union All SELECT ID,HOTEN FROM AHS_NGUOITHAMGIATOTUNG) ahc_ds on ahc_dt.DUONGSUID=ahc_ds.ID
        left join AHS_SOTHAM_THULY st on ahc_td.VUANID=st.VUANID
        left join AHS_PHUCTHAM_THULY pt on ahc_td.VUANID=pt.VUANID
        inner join AHS_VUAN ahc_gd on ahc_td.VUANID=ahc_gd.ID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
        left join (select tptk.VUANID VUANIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AHS_THAMPHANGIAIQUYET tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_td.VUANID=tptks.VUANIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (vDuongSu is null or LOWER(ahc_ds.HOTEN) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC WHERE   PC.CANBOID = vThamPhan  AND PC.VUANID=ahc_td.VUANID )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM AHS_THAMPHANGIAIQUYET TK WHERE   TK.THUKYID = vThuKy  AND TK.VUANID=ahc_td.VUANID )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4))
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and
        (ahc_gd.MAGIAIDOAN in (select MAX(MAGIAIDOAN) from AHS_VUAN where ID=ahc_td.VUANID))
        and 
        (vLoaiAn='0' or vLoaiAn='01') 
        /*union
        ---lấy án BPXLHC
        select ahc_dt.NGAYGUI,ahc_dt.ID,ahc_td.TOAANID,('<div style="text-align:left;">'||ahc_ds.HOTEN|| DECODE(ahc_gd.QUANHEPHAPLUAT_NAME,'','','-'||ahc_gd.QUANHEPHAPLUAT_NAME) || DECODE(DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, ''),'',''
        ,'<br/>Loại án: BPXLHC <br/> Thụ lý số:'||DECODE(ahc_gd.MAGIAIDOAN,2, st.SOTHULY,3, pt.SOTHULY, '')||' ngày:'
        ||DECODE(ahc_gd.MAGIAIDOAN,2, to_char(st.NGAYTHULY,'dd/MM/yyyy'),3, to_char(pt.NGAYTHULY,'dd/MM/yyyy'), '')|| DECODE(tptks.HOTENTP,'','','<br/>Thẩm phán:'||tptks.HOTENTP||'<br/>')
        || DECODE(tptks.HOTENTK,'','','Thư ký:'||tptks.HOTENTK))||'</div>') THONGTINVUAN,
        ('<div style="text-align:left">Tên văn bản:'||d.TENBM||'<br/>'||DECODE(to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'),'','','Ngày nhận:'||to_char(utd.NGAYNHANUTTPCAPDUOI,'dd/MM/yyyy'))||'</div>') NGAYUT_VBUT, 
        t.TEN DONVIUTTP,
        q.TEN QUOCGIAUTTP,
        to_char(utd.NGAYCHUYENUTTP,'dd/MM/yyyy') NGAYCHUYENUTTP,
        q1.TEN KETQUAUTTP,
        utd.NGAYSUA,
        ahc_dt.ID||'_08' DATAID,
        utd.NGAYCHUYENKQUTVETOACAPDUOI

        from XLHC_TONGDAT ahc_td
        inner join XLHC_TONGDAT_DOITUONG ahc_dt on ahc_td.ID=ahc_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ahc_dt.ID=utd.IDDOITUONGTONGDAT
        inner join XLHC_DUONGSU ahc_ds on ahc_td.DONID=ahc_ds.DONID and ahc_dt.DUONGSUID=ahc_ds.ID
        left join XLHC_SOTHAM_THULY st on ahc_td.DONID=st.DONID
        left join XLHC_PHUCTHAM_THULY pt on ahc_td.DONID=pt.DONID
        left join XLHC_DON ahc_gd on ahc_td.DONID=ahc_gd.ID
        inner join DM_TOAAN t on ahc_td.TOAANID=t.ID
        inner join DM_BIEUMAU d on ahc_td.BIEUMAUID=d.ID
        left join DM_DATAITEM q on ahc_dt.QUOCGIA=q.ID
        left join DM_DATAITEM q1 on ahc_dt.KETQUAUTTP=q1.ID
       left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from XLHC_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (vDuongSu is null or LOWER(ahc_ds.HOTEN) like ('%' || LOWER(vDuongSu) || '%')) 
        and
        (vSoThuLy is null or LOWER(st.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%') or LOWER(pt.SOTHULY) like ('%' || LOWER(vSoThuLy) || '%'))
        and
        (vNgayThuLy is null or st.NGAYTHULY=vvNgayThuLy or pt.NGAYTHULY=vvNgayThuLy)
        and
        (vThamPhan=0 OR( EXISTS(SELECT 'x' FROM XLHC_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=ahc_ds.DONID )))
        and
        (vThuKy=0 OR( EXISTS(SELECT 'x' FROM XLHC_DON_THAMPHAN TK WHERE   TK.THUKYID = vThuKy  AND TK.DONID=ahc_ds.DONID )))
        and
        (vVanBanUT=0 or ahc_td.BIEUMAUID=vVanBanUT)
        and 
        ((ahc_td.TOAANID in (select a.ID from DM_TOAAN a where ((a.CAPCHAID=vDonVi or a.ID=vDonVi) and vDonViUT=0) or a.ID=vDonViUT )))
        and
        (vQuocGiaUT=0 or ahc_dt.QUOCGIA=vQuocGiaUT)
        and 
        (vKetQuaUT=0 or ahc_dt.KETQUAUTTP=vKetQuaUT)
        and
        (vTuNgay is null or (utd.NGAYNHANUTTPCAPDUOI>=vvTuNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA>=vvTuNgay and vloaiTimKiem=2))
        and
        (vDenNgay is null or (utd.NGAYNHANUTTPCAPDUOI<=vvDenNgay and vloaiTimKiem=0) or (utd.NGAYNHANDUOCKETQUA<=vvDenNgay and vloaiTimKiem=2))
        and
        ((t.LOAITOA='CAPHUYEN' and ahc_dt.HINHTHUCGUI=4) or (t.LOAITOA='CAPTINH' or ahc_dt.HINHTHUCGUI=4))
        and 
        (vCapXetXu =0 or ahc_gd.MAGIAIDOAN=vCapXetXu)
        and 
        (vLoaiAn='0' or vLoaiAn='08')*/)

        order by NGAYGUI desc
        ;


END GETUTTP_DI;


 PROCEDURE  GETTHAMPHANTONGDAT
(   
    vDonVi in number,
    curReturn    OUT       sys_refcursor
)
IS 

BEGIN 
-----nếu là cấp xét xử sơ thẩm
    OPEN curReturn FOR
        select * from (--lấy dân sự
        select 
        tptks.CANBOID ID,tptks.HOTENTP HOTEN
        from ADS_TONGDAT ads_td
        inner join ADS_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join ADS_DON_GIAIDOAN ads_gd on ads_td.DONID=ads_gd.DONID
        inner join ADS_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from ADS_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi))
        union
        ---lấy hành chính 
        select 
        tptks.CANBOID ID,tptks.HOTENTP HOTEN
        from AHC_TONGDAT ads_td
        inner join AHC_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join AHC_DON_GIAIDOAN ads_gd on ads_td.DONID=ads_gd.DONID
        inner join AHC_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AHC_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi))
        union
        ---lấy hôn nhân gia đình
        select 
        tptks.CANBOID ID,tptks.HOTENTP HOTEN
        from AHN_TONGDAT ads_td
        inner join AHN_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join AHN_DON_GIAIDOAN ads_gd on ads_td.DONID=ads_gd.DONID
        inner join AHN_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AHN_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi))
        union
        ---lấy kinh doanh thương mại
        select 
        tptks.CANBOID ID,tptks.HOTENTP HOTEN
        from AKT_TONGDAT ads_td
        inner join AKT_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join AKT_DON_GIAIDOAN ads_gd on ads_td.DONID=ads_gd.DONID
        inner join AKT_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AKT_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi))
        union
        ---lấy lao động
        select 
        tptks.CANBOID ID,tptks.HOTENTP HOTEN
        from ALD_TONGDAT ads_td
        inner join ALD_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join ALD_DON_GIAIDOAN ads_gd on ads_td.DONID=ads_gd.DONID
        inner join ALD_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from ALD_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi))
        union
        ---lấy án phá sản
        select 
        tptks.CANBOID ID,tptks.HOTENTP HOTEN
        from APS_TONGDAT ads_td
        inner join APS_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join APS_DON ads_gd on ads_td.DONID=ads_gd.ID
        inner join APS_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from APS_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi))
        union
        ---lấy án hình sự
        select 
        tptks.CANBOID ID,tptks.HOTENTP HOTEN
                from AHS_TONGDAT ahc_td
                inner join AHS_VUAN ahc_gd on ahc_td.VUANID=ahc_gd.ID
        left join (select tptk.VUANID VUANIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AHS_THAMPHANGIAIQUYET tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_td.VUANID=tptks.VUANIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ahc_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi) )
        union
        ---lấy án BPXLHC
        select 
        tptks.CANBOID ID,tptks.HOTENTP HOTEN
        from XLHC_TONGDAT ads_td
        inner join XLHC_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join XLHC_DON ads_gd on ads_td.DONID=ads_gd.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from XLHC_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_gd.ID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi)));

 END GETTHAMPHANTONGDAT;

  PROCEDURE  GETTHUKYTONGDAT
(   
    vDonVi in number,
    curReturn    OUT       sys_refcursor
)
IS 

BEGIN 
-----nếu là cấp xét xử sơ thẩm
    OPEN curReturn FOR
        select * from (--lấy dân sự
        select 
        tptks.THUKYID ID,tptks.HOTENTK HOTEN
        from ADS_TONGDAT ads_td
        inner join ADS_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join ADS_DON_GIAIDOAN ads_gd on ads_td.DONID=ads_gd.DONID
        inner join ADS_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from ADS_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi))
        union
        ---lấy hành chính 
        select 
        tptks.THUKYID ID,tptks.HOTENTK HOTEN
        from AHC_TONGDAT ads_td
        inner join AHC_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join AHC_DON_GIAIDOAN ads_gd on ads_td.DONID=ads_gd.DONID
        inner join AHC_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AHC_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi))
        union
        ---lấy hôn nhân gia đình
        select 
       tptks.THUKYID ID,tptks.HOTENTK HOTEN
        from AHN_TONGDAT ads_td
        inner join AHN_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join AHN_DON_GIAIDOAN ads_gd on ads_td.DONID=ads_gd.DONID
        inner join AHN_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AHN_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi))
        union
        ---lấy kinh doanh thương mại
        select 
        tptks.THUKYID ID,tptks.HOTENTK HOTEN
        from AKT_TONGDAT ads_td
        inner join AKT_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join AKT_DON_GIAIDOAN ads_gd on ads_td.DONID=ads_gd.DONID
        inner join AKT_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AKT_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi))
        union
        ---lấy lao động
        select 
        tptks.THUKYID ID,tptks.HOTENTK HOTEN
        from ALD_TONGDAT ads_td
        inner join ALD_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join ALD_DON_GIAIDOAN ads_gd on ads_td.DONID=ads_gd.DONID
        inner join ALD_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from ALD_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi))
        union
        ---lấy án phá sản
        select 
        tptks.THUKYID ID,tptks.HOTENTK HOTEN
        from APS_TONGDAT ads_td
        inner join APS_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join APS_DON ads_gd on ads_td.DONID=ads_gd.ID
        inner join APS_DON_DUONGSU ads_ds on ads_td.DONID=ads_ds.DONID and ads_dt.DUONGSUID=ads_ds.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from APS_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_ds.DONID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi))
        union
        ---lấy án hình sự 
        select 
        tptks.THUKYID ID,tptks.HOTENTK HOTEN
                from AHS_TONGDAT ahc_td
                inner join AHS_VUAN ahc_gd on ahc_td.VUANID=ahc_gd.ID
        left join (select tptk.VUANID VUANIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from AHS_THAMPHANGIAIQUYET tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ahc_td.VUANID=tptks.VUANIDS and tptks.MAVAITRO=DECODE(ahc_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ahc_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi) )
        union
        ---lấy án BPXLHC
        select 
        tptks.THUKYID ID,tptks.HOTENTK HOTEN
        from XLHC_TONGDAT ads_td
        inner join XLHC_TONGDAT_DOITUONG ads_dt on ads_td.ID=ads_dt.TONGDATID
        left join UYTHACTUPHAPDI utd on ads_dt.ID=utd.IDDOITUONGTONGDAT 
        inner join XLHC_DON ads_gd on ads_td.DONID=ads_gd.ID
        left join (select tptk.DONID DONIDS, tptk.CANBOID,tptk.THUKYID,tk.HOTEN HOTENTK,tp.HOTEN HOTENTP,tptk.MAVAITRO from XLHC_DON_THAMPHAN tptk 
        left join DM_CANBO tk on tptk.THUKYID=tk.ID
        left join DM_CANBO tp on tptk.CANBOID=tp.ID
        ) tptks on ads_gd.ID=tptks.DONIDS and tptks.MAVAITRO=DECODE(ads_gd.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM', 'VTTP_GIAIQUYETDON')
        where 
        (ads_td.TOAANID in (select a.ID from DM_TOAAN a where a.CAPCHAID=vDonVi or a.ID=vDonVi)));

 END GETTHUKYTONGDAT;

END UYTHACTUPHAP;

/
