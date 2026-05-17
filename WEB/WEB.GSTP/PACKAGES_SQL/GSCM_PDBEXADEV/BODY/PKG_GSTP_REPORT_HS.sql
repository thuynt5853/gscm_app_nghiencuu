--------------------------------------------------------
--  DDL for Package Body PKG_GSTP_REPORT_HS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GSTP_REPORT_HS" AS

/* 01_HS */
PROCEDURE AHS_01
	(
		 in_VUANID IN NUMBER,
     in_MAGIAIDOAN IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	) as
    v_ARRAY AHS_T_01_ADD;
    v_TOAANID number;
    v_DIACHI varchar(500);
    v_LOAITOA varchar(50);
    v_TENTOAAN_Templ varchar(500);
    v_TOACAPTREN number;
  BEGIN

    select decode(in_MAGIAIDOAN,2,TOAANID,3,TOAPHUCTHAMID,0) into v_TOAANID from AHS_VUAN where ID=in_VUANID;
    -- Lấy địa điểm
    select LOAITOA,CAPCHAID,TEN,
      decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ','')) 
      into v_LOAITOA,v_TOACAPTREN,v_TENTOAAN_Templ,v_DIACHI
    from DM_TOAAN where ID=v_TOAANID;
    -- Lấy địa điểm với tòa cấp huyện
    if v_LOAITOA='CAPHUYEN' then
      select decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ','')) into v_DIACHI 
      from DM_TOAAN where ID=v_TOACAPTREN;
    end if;
    -- Lấy Tên tòa án
    if instr('CẤP CAO',v_TENTOAAN_Templ)>0 then
      select replace(v_TENTOAAN_Templ,'cấp cao','cấp cao'||chr(10)) into v_TENTOAAN_Templ from sys.dual;
    elsif instr('TỐI CAO',v_TENTOAAN_Templ)=0 then
      select replace(replace(v_TENTOAAN_Templ,'Tòa án nhân dân','Tòa án nhân dân'||chr(10)),',',chr(10)) into v_TENTOAAN_Templ from sys.dual;
    end if;

    SELECT AHS_R_01_ADD(
        v_STT =>row_number() over (order by T2.ID), 
        v_VUANID =>in_VUANID,
        v_TOAANID =>v_TOAANID,
        v_CANBOID =>T2.CANBOID,
        v_TENTOAAN =>upper(v_TENTOAAN_Templ),
        v_SOQD =>T2.SOQD || '/' || to_char(T2.NGAYQD,'yyyy'),
        v_DIADIEM =>v_DIACHI,
        v_NGAYQD =>to_char(T2.NGAYQD,'dd'),
        v_THANGQD =>to_char(T2.NGAYQD,'MM'),
        v_NAMQD =>to_char(T2.NGAYQD,'yyyy'),
        v_VAITRO =>DECODE(T2.MAVAITRO, 'HTND', 'Hội thẩm', 'Thẩm phán'),
        v_CHUCDANH =>regexp_replace(nvl(T4.TEN,''),' trung cấp| sơ cấp| cao cấp| chính| Tòa án| Tòa án ko ÐHL',''),
        v_DIEULUATBOSUNG =>DECODE(T2.MAVAITRO, 'HTND', '46', '45'),
        v_CANBO_TEN =>decode(T3.GIOITINH,1,'Ông ',0,'Bà ','')||T3.HOTEN,
        v_GIAIDOAN =>decode(in_MAGIAIDOAN,2,'sơ thẩm',3,'phúc thẩm',''),
        v_SOTHULY =>NULL,
        v_ISBICAN_BICAO =>NULL,
        v_BICAN_BICAO_TEN =>NULL,
        v_DONVI_TRUYTO_XETXU =>NULL,
        v_TOIDANH =>NULL,
        v_NGUOIPC_CHUCVU =>upper(CD.TEN),
        v_NGUOIPC_KT =>NULL,
        v_NGUOIPC_TEN =>PC.HOTEN,    
        v_THAMPHAN =>NULL,
        v_NOIDUNGKHANGCAO =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHS_SOTHAM_HDXX T2
      LEFT JOIN DM_CANBO T3 on T3.ID=T2.CANBOID
      LEFT JOIN DM_CANBO PC on PC.ID=T2.NGUOIPHANCONGID
      LEFT JOIN DM_DATAITEM CD on CD.ID=PC.CHUCVUID
      --LEFT JOIN DM_CANBOVKS T5 on T5.ID=T2.CANBOID
      LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCDANHID
      --LEFT JOIN DM_DATAITEM T6 on T6.ID=T5.CHUCVUID
      --Khải sửa:
      where T2.VUANID=in_VUANID AND T2.MAVAITRO='THAMPHAN' OR T2.VUANID=in_VUANID AND T2.MAVAITRO='HTND' OR T2.VUANID=in_VUANID AND T2.MAVAITRO='THAMPHANHDXX' OR T2.VUANID=in_VUANID AND T2.MAVAITRO='THAMPHANDUKHUYET'
      --and 1=case when in_MAGIAIDOAN=2 and instr('VTTP_GIAIQUYETSOTHAM',T2.MAVAITRO)>0 then 1
      --when in_MAGIAIDOAN=3 and instr('VTTP_GIAIQUYETPHUCTHAM',T2.MAVAITRO)>0 then 1
      --Khải sửa:
      and 1=case when in_MAGIAIDOAN=2 then 1
      when in_MAGIAIDOAN=3 then 1
      else 0 end;

     if in_MAGIAIDOAN=2 then
      PKG_GSTP_REPORT_HS.AHS_FILL_01_ST(v_ARRAY);
      else
      PKG_GSTP_REPORT_HS.AHS_FILL_01_PT(v_ARRAY);
      end if;

		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);

	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
  END;

PROCEDURE AHS_FILL_01_ST
	(
		v_ARRAY IN OUT AHS_T_01_ADD
	) AS
  t_VUANID number;
	BEGIN
  select T1.v_VUANID into t_VUANID from TABLE(v_ARRAY) T1 where rownum=1;
  /* v_SOTHULY Thông tin thụ lý (Số, ngày tháng năm)*/
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        T2.SOTHULY || '/' || to_char(T2.NGAYTHULY,'yyyy') || '/TLST-HS ' ||
        'ngày ' || to_char(T2.NGAYTHULY,'dd') || ' tháng ' || to_char(T2.NGAYTHULY,'MM') || ' năm ' || to_char(T2.NGAYTHULY,'yyyy')
        v_SOTHULY
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN (select VUANID,NGAYTHULY,SOTHULY from AHS_SOTHAM_THULY 
                    where VUANID=t_VUANID and rownum=1
                    order by NGAYTHULY
                    ) T2 ON T1.v_VUANID=T2.VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_SOTHULY:=ITEM.v_SOTHULY;
		END LOOP;

  /* v_ISBICAN_BICAO Bị can hay bị cáo */
  /* v_BICAN_BICAO_TEN Tên bị can (bị cáo) */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        nvl2(T5.VUANID,'bị can','bị cáo') v_ISBICAN_BICAO,
        nvl2(T6.SoBiCan,T2.HOTEN  || ' và các đồng phạm',T2.HOTEN) v_BICAN_BICAO_TEN
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID and T2.BICANDAUVU=1
        left join (select count(ID) SoBiCan from AHS_BICANBICAO where VUANID=t_VUANID) T6 on T1.v_VUANID=T2.VUANID and T6.SoBiCan>1
        LEFT JOIN (select T3.VUANID from AHS_SOTHAM_QUYETDINH_VUAN T3
                    inner join DM_QD_LOAI T4 on T4.ID=T3.LOAIQDID and T4.HIEULUC=1 and T4.MA='DVARXX'
                    ) T5 on T5.VUANID=T1.v_VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_ISBICAN_BICAO:=ITEM.v_ISBICAN_BICAO;
      v_ARRAY(ITEM.v_STT).v_BICAN_BICAO_TEN:=ITEM.v_BICAN_BICAO_TEN;
		END LOOP;
  /* v_DONVI_TRUYTO_XETXU Đơn vị truy tố (xét xử)*/
    FOR ITEM IN (
			SELECT 
				T1.v_STT,
       CONCAT(nvl2(T4.VUANID,T4.TEN,replace(T4.TEN,'Tòa án','Viện kiểm sát')), ' truy tố') v_DONVI_TRUYTO_XETXU
			FROM 
				TABLE(v_ARRAY) T1 
				LEFT JOIN (select T2.TOAANID,T2.VUANID,T3.TEN from AHS_SOTHAM_BANAN T2
                    inner join DM_TOAAN T3 on T2.TOAANID=T3.ID
                   ) T4 ON T1.v_VUANID=T4.VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_DONVI_TRUYTO_XETXU:=ITEM.v_DONVI_TRUYTO_XETXU;
		END LOOP;

  /* v_TOIDANH Tội danh */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
         LISTAGG(
                cast(T5.ToiDanh as varchar2(4000))
                ,'; '
                ) WITHIN GROUP (ORDER BY T1.v_STT) v_TOIDANH
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN (select distinct T2.VUANID,
                          NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                    from AHS_BICANBICAO T2
                    INNER JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT T3 ON T3.BICANID=T2.ID
                    inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                    where T2.BICANDAUVU=1
                    )T5 on T5.VUANID=T1.v_VUANID
          group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TOIDANH:=ITEM.v_TOIDANH;
		END LOOP;

  /* v_NGUOIPC_CHUCVU Chức danh của người phân công */
  /* v_NGUOIPC_TEN Tên người phân công*/
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        upper(decode(instr(lower(T4.TEN),'phó chánh án'),0,nvl(T4.TEN,''),nvl2(T4.TEN,T4.TEN,''))) v_NGUOIPC_CHUCVU, 
        upper(decode(instr(lower(T4.TEN),'phó chánh án'),0,NULL,nvl2(T4.TEN,'KT.CHÁNH ÁN ',''))) v_NGUOIPC_KT,--anhvh edit them 1 truong ky thay pho chanh an 
        T3.HOTEN v_NGUOIPC_TEN
			FROM 
				TABLE(v_ARRAY) T1 
				---INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID
               LEFT JOIN AHS_THAMPHANGIAIQUYET T2 on T1.v_VUANID=T2.VUANID
        INNER JOIN DM_CANBO T3 on T3.ID=T2.NGUOIPHANCONGID
        LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCVUID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_CHUCVU:=ITEM.v_NGUOIPC_CHUCVU;
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_KT:=ITEM.v_NGUOIPC_KT;
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_TEN:=ITEM.v_NGUOIPC_TEN;
		END LOOP;
    /* v_THAMPHAN Thẩm phán */
    for item in
  (
    SELECT 
      T1.v_STT,
      decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN v_THAMPHAN
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THAMPHAN'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  )loop
    v_ARRAY(ITEM.v_STT).v_THAMPHAN := ITEM.v_THAMPHAN;
  end loop;
  -- v_NOIDUNGKHANGCAO nội dung kc
   for item in
  (
    SELECT 
      T1.v_STT,
      T3.NOIDUNGKHANGCAO v_NOIDUNGKHANGCAO
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_SOTHAM_BANAN T2 on T1.v_VUANID=T2.VUANID
  inner join AHS_SOTHAM_KHANGCAO T3 on T2.VUANID=T3.VUANID
  )loop
    v_ARRAY(ITEM.v_STT).v_NOIDUNGKHANGCAO := ITEM.v_NOIDUNGKHANGCAO;
  end loop;
  END;
PROCEDURE AHS_FILL_01_PT
	(
		v_ARRAY IN OUT AHS_T_01_ADD
	) AS
	t_VUANID number;
	BEGIN
  select T1.v_VUANID into t_VUANID from TABLE(v_ARRAY) T1 where rownum=1;
  /* v_SOTHULY Thông tin thụ lý (Số, ngày tháng năm)*/
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        T2.SOTHULY || '/' || to_char(T2.NGAYTHULY,'yyyy') || '/TLPT-HS ' ||
        'ngày ' || to_char(T2.NGAYTHULY,'dd') || ' tháng ' || to_char(T2.NGAYTHULY,'MM') || ' năm ' || to_char(T2.NGAYTHULY,'yyyy')
        v_SOTHULY
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN (select VUANID,NGAYTHULY,SOTHULY from AHS_PHUCTHAM_THULY 
                    where VUANID=t_VUANID and rownum=1
                    order by NGAYTHULY
                    ) T2 ON T1.v_VUANID=T2.VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_SOTHULY:=ITEM.v_SOTHULY;
		END LOOP;

  /* v_ISBICAN_BICAO Bị can hay bị cáo */
  /* v_BICAN_BICAO_TEN Tên bị can (bị cáo) */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        'bị cáo' v_ISBICAN_BICAO,
        nvl2(T6.SoBiCan,T2.HOTEN  || ' và các đồng phạm',T2.HOTEN) v_BICAN_BICAO_TEN
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID and T2.BICANDAUVU=1
        left join (select count(ID) SoBiCan from AHS_BICANBICAO where VUANID=t_VUANID) T6 on T1.v_VUANID=T2.VUANID and T6.SoBiCan>1
		) LOOP
      v_ARRAY(ITEM.v_STT).v_ISBICAN_BICAO:=ITEM.v_ISBICAN_BICAO;
      v_ARRAY(ITEM.v_STT).v_BICAN_BICAO_TEN:=ITEM.v_BICAN_BICAO_TEN;
		END LOOP;
  /* v_DONVI_TRUYTO_XETXU Đơn vị truy tố (xét xử)*/
    FOR ITEM IN (
			SELECT 
				T1.v_STT,
        CONCAT(T4.TEN, ' xét xử') v_DONVI_TRUYTO_XETXU
			FROM 
				TABLE(v_ARRAY) T1 
				LEFT JOIN (select T2.TOAANID,T2.VUANID,T3.TEN from AHS_SOTHAM_BANAN T2
                    inner join DM_TOAAN T3 on T2.TOAANID=T3.ID
                   ) T4 ON T1.v_VUANID=T4.VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_DONVI_TRUYTO_XETXU:=ITEM.v_DONVI_TRUYTO_XETXU;
		END LOOP;

  /* v_TOIDANH Tội danh */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
         LISTAGG(
                cast(T5.ToiDanh as varchar2(4000))
                ,'; '
                ) WITHIN GROUP (ORDER BY T1.v_STT) v_TOIDANH
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN (select distinct T2.VUANID,
                          NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                    from AHS_BICANBICAO T2
                    INNER JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET T3 ON T3.BICANID=T2.ID
                    inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                    where T2.BICANDAUVU=1
                    )T5 on T5.VUANID=T1.v_VUANID
          group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TOIDANH:=ITEM.v_TOIDANH;
		END LOOP;

  /* v_NGUOIPC_CHUCVU Chức danh của người phân công */
  /* v_NGUOIPC_TEN Tên người phân công*/
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        upper(decode(instr(lower(T4.TEN),'phó chánh án'),0,nvl(T4.TEN,''),nvl2(T4.TEN,'KT.CHÁNH ÁN '||CHR(13)||T4.TEN,''))) v_NGUOIPC_CHUCVU, 
        T3.HOTEN v_NGUOIPC_TEN
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID
        INNER JOIN DM_CANBO T3 on T3.ID=T2.NGUOIPHANCONGID
        LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCVUID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_CHUCVU:=ITEM.v_NGUOIPC_CHUCVU;
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_TEN:=ITEM.v_NGUOIPC_TEN;
		END LOOP;
  END;


/* 02_HS */
PROCEDURE AHS_02
	(
		 in_VUANID IN NUMBER,
     in_MAGIAIDOAN IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	) as
    v_ARRAY AHS_T_02;
    v_TOAANID number;
    v_DIACHI varchar(500);
    v_LOAITOA varchar(50);
    v_TENTOAAN_Templ varchar(500);
    v_TOACAPTREN number;
  BEGIN
    -- v_MAGIAIDOAN: Sơ thẩm=2, Phúc thẩm=3
    -- Lấy Giai đoạn vụ án
    select decode(in_MAGIAIDOAN,2,TOAANID,3,TOAPHUCTHAMID,0) into v_TOAANID from AHS_VUAN where ID=in_VUANID;
    -- Lấy địa điểm
    select LOAITOA,CAPCHAID,TEN,
      decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ','')) 
      into v_LOAITOA,v_TOACAPTREN,v_TENTOAAN_Templ,v_DIACHI
    from DM_TOAAN where ID=v_TOAANID;
    -- Lấy địa điểm với tòa cấp huyện
    if v_LOAITOA='CAPHUYEN' then
      select decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ','')) into v_DIACHI 
      from DM_TOAAN where ID=v_TOACAPTREN;
    end if;
    -- Lấy Tên tòa án
    if instr('CẤP CAO',v_TENTOAAN_Templ)>0 then
      select replace(v_TENTOAAN_Templ,'cấp cao','cấp cao'||chr(10)) into v_TENTOAAN_Templ from sys.dual;
    elsif instr('TỐI CAO',v_TENTOAAN_Templ)=0 then
      select replace(replace(v_TENTOAAN_Templ,'Tòa án nhân dân','Tòa án nhân dân'||chr(10)),',',chr(10)) into v_TENTOAAN_Templ from sys.dual;
    end if;

    if in_MAGIAIDOAN=2 -- Sơ thẩm
    then
    begin
      SELECT AHS_R_02(
        v_STT =>row_number() over (order by T2.ID), 
        v_VUANID =>in_VUANID,
        v_TOAANID =>v_TOAANID,
        v_CANBOID =>T2.CANBOID,
        v_TENTOAAN =>upper(v_TENTOAAN_Templ),
        v_SOQD =>T2.SOQD || '/' || to_char(T2.NGAYQD,'yyyy'),
        v_DIADIEM =>v_DIACHI,
        v_NGAYQD =>to_char(T2.NGAYQD,'dd'),
        v_THANGQD =>to_char(T2.NGAYQD,'MM'),
        v_NAMQD =>to_char(T2.NGAYQD,'yyyy'),
        v_VAITRO =>decode(T2.MAVAITRO,'THAMTRAVIEN','Thẩm tra viên','Thư ký'),
        v_CHUCDANH =>regexp_replace(nvl(T4.TEN,''),' trung cấp| sơ cấp| cao cấp| chính| Tòa án| Tòa án ko ÐHL',''),
        v_DIEULUATBOSUNG =>decode(T2.MAVAITRO,'THAMTRAVIEN','47','48'),
        v_CANBO_TEN =>decode(T3.GIOITINH,1,'Ông ',0,'Bà ','')||T3.HOTEN,
        v_CANBO_NHIEMVU =>decode(T2.MAVAITRO,'THAMTRAVIEN','thẩm tra hồ sơ','tố tụng'),
        v_GIAIDOAN =>'sơ thẩm',
        v_SOTHULY =>NULL,
        v_ISBICAN_BICAO =>NULL,
        v_BICAN_BICAO_TEN =>NULL,
        v_DONVI_TRUYTO_XETXU =>NULL,
        v_TOIDANH =>NULL,
        v_NGUOIPC_CHUCVU =>NULL,
        v_NGUOIPC_TEN =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHS_SOTHAM_HDXX T2
      INNER JOIN DM_CANBO T3 on T3.ID=T2.CANBOID
      LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCDANHID
      where T2.VUANID=in_VUANID and instr('THAMTRAVIEN,THUKY,THUKYDUKHUYET',T2.MAVAITRO)>0;

      PKG_GSTP_REPORT_HS.AHS_FILL_02_ST(v_ARRAY);
    end;
    else
    begin
      SELECT AHS_R_02(
        v_STT =>row_number() over (order by T2.ID), 
        v_VUANID =>in_VUANID,
        v_TOAANID =>v_TOAANID,
        v_CANBOID =>T2.CANBOID,
        v_TENTOAAN =>upper(v_TENTOAAN_Templ),
        v_SOQD =>T2.SOQD || '/' || to_char(T2.NGAYQD,'yyyy'),
        v_DIADIEM =>v_DIACHI,
        v_NGAYQD =>to_char(T2.NGAYQD,'dd'),
        v_THANGQD =>to_char(T2.NGAYQD,'MM'),
        v_NAMQD =>to_char(T2.NGAYQD,'yyyy'),
        v_VAITRO =>decode(T2.MAVAITRO,'THAMTRAVIEN','Thẩm tra viên','Thư ký'),
        v_CHUCDANH =>regexp_replace(nvl(T4.TEN,''),' trung cấp| sơ cấp| cao cấp| chính| Tòa án| Tòa án ko ÐHL',''),
        v_DIEULUATBOSUNG =>decode(T2.MAVAITRO,'THAMTRAVIEN','47','48'),
        v_CANBO_TEN =>decode(T3.GIOITINH,1,'Ông ',0,'Bà ','')||T3.HOTEN,
        v_CANBO_NHIEMVU =>decode(T2.MAVAITRO,'THAMTRAVIEN','thẩm tra hồ sơ','tố tụng'),
        v_GIAIDOAN =>'phúc thẩm',
        v_SOTHULY =>NULL,
        v_ISBICAN_BICAO =>NULL,
        v_BICAN_BICAO_TEN =>NULL,
        v_DONVI_TRUYTO_XETXU =>NULL,
        v_TOIDANH =>NULL,
        v_NGUOIPC_CHUCVU =>NULL,
        v_NGUOIPC_TEN =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHS_PHUCTHAM_HDXX T2
      INNER JOIN DM_CANBO T3 on T3.ID=T2.CANBOID
      LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCDANHID
      where T2.VUANID=in_VUANID and instr('THAMTRAVIEN,THUKY,THUKYDUKHUYET',T2.MAVAITRO)>0;

      PKG_GSTP_REPORT_HS.AHS_FILL_02_PT(v_ARRAY);
    end;
		end if;

		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);

	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
  END;

PROCEDURE AHS_FILL_02_ST
	(
		v_ARRAY IN OUT AHS_T_02
	) AS
  t_VUANID number;
	BEGIN
  select T1.v_VUANID into t_VUANID from TABLE(v_ARRAY) T1 where rownum=1;
  /* v_SOTHULY Thông tin thụ lý (Số, ngày tháng năm)*/
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        T2.SOTHULY || '/' || to_char(T2.NGAYTHULY,'yyyy') || '/TLST-HS ' ||
        'ngày ' || to_char(T2.NGAYTHULY,'dd') || ' tháng ' || to_char(T2.NGAYTHULY,'MM') || ' năm ' || to_char(T2.NGAYTHULY,'yyyy')
        v_SOTHULY
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN (select VUANID,NGAYTHULY,SOTHULY from AHS_SOTHAM_THULY 
                    where VUANID=t_VUANID and rownum=1
                    order by NGAYTHULY
                    ) T2 ON T1.v_VUANID=T2.VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_SOTHULY:=ITEM.v_SOTHULY;
		END LOOP;

  /* v_ISBICAN_BICAO Bị can hay bị cáo */
  /* v_BICAN_BICAO_TEN Tên bị can (bị cáo) */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        nvl2(T5.VUANID,'bị can','bị cáo') v_ISBICAN_BICAO,
        nvl2(T6.SoBiCan,T2.HOTEN  || ' và các đồng phạm',T2.HOTEN) v_BICAN_BICAO_TEN
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID and T2.BICANDAUVU=1
        left join (select count(ID) SoBiCan from AHS_BICANBICAO where VUANID=t_VUANID) T6 on T1.v_VUANID=T2.VUANID and T6.SoBiCan>1
        LEFT JOIN (select T3.VUANID from AHS_SOTHAM_QUYETDINH_VUAN T3
                    inner join DM_QD_LOAI T4 on T4.ID=T3.LOAIQDID and T4.HIEULUC=1 and T4.MA='DVARXX'
                    ) T5 on T5.VUANID=T1.v_VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_ISBICAN_BICAO:=ITEM.v_ISBICAN_BICAO;
      v_ARRAY(ITEM.v_STT).v_BICAN_BICAO_TEN:=ITEM.v_BICAN_BICAO_TEN;
		END LOOP;
  /* v_DONVI_TRUYTO_XETXU Đơn vị truy tố (xét xử)*/
    FOR ITEM IN (
			SELECT 
				T1.v_STT,
        nvl2(T4.VUANID,T4.TEN,replace(T4.TEN,'Tòa án','Viện kiểm sát')) v_DONVI_TRUYTO_XETXU
			FROM 
				TABLE(v_ARRAY) T1 
				LEFT JOIN (select T2.TOAANID,T2.VUANID,T3.TEN from AHS_SOTHAM_BANAN T2
                    inner join DM_TOAAN T3 on T2.TOAANID=T3.ID
                   ) T4 ON T1.v_VUANID=T4.VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_DONVI_TRUYTO_XETXU:=ITEM.v_DONVI_TRUYTO_XETXU;
		END LOOP;

  /* v_TOIDANH Tội danh */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
         LISTAGG(
                cast(T5.ToiDanh as varchar2(4000))
                ,'; '
                ) WITHIN GROUP (ORDER BY T1.v_STT) v_TOIDANH
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN (select distinct T2.VUANID,
                          NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                    from AHS_BICANBICAO T2
                    INNER JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT T3 ON T3.BICANID=T2.ID
                    inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                    where T2.BICANDAUVU=1
                    )T5 on T5.VUANID=T1.v_VUANID
          group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TOIDANH:=ITEM.v_TOIDANH;
		END LOOP;

  /* v_NGUOIPC_CHUCVU Chức danh của người phân công */
  /* v_NGUOIPC_TEN Tên người phân công*/
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        upper(decode(instr(lower(T4.TEN),'phó chánh án'),0,nvl(T4.TEN,''),nvl2(T4.TEN,'KT.CHÁNH ÁN'||CHR(10)||T4.TEN,''))) v_NGUOIPC_CHUCVU, 
        T3.HOTEN v_NGUOIPC_TEN
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID
        INNER JOIN DM_CANBO T3 on T3.ID=T2.NGUOIPHANCONGID
        LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCVUID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_CHUCVU:=ITEM.v_NGUOIPC_CHUCVU;
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_TEN:=ITEM.v_NGUOIPC_TEN;
		END LOOP;

  END;
PROCEDURE AHS_FILL_02_PT
	(
		v_ARRAY IN OUT AHS_T_02
	) AS
	t_VUANID number;
	BEGIN
  select T1.v_VUANID into t_VUANID from TABLE(v_ARRAY) T1 where rownum=1;
  /* v_SOTHULY Thông tin thụ lý (Số, ngày tháng năm)*/
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        T2.SOTHULY || '/' || to_char(T2.NGAYTHULY,'yyyy') || '/TLPT-HS ' ||
        'ngày ' || to_char(T2.NGAYTHULY,'dd') || ' tháng ' || to_char(T2.NGAYTHULY,'MM') || ' năm ' || to_char(T2.NGAYTHULY,'yyyy')
        v_SOTHULY
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN (select VUANID,NGAYTHULY,SOTHULY from AHS_PHUCTHAM_THULY 
                    where VUANID=t_VUANID and rownum=1
                    order by NGAYTHULY
                    ) T2 ON T1.v_VUANID=T2.VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_SOTHULY:=ITEM.v_SOTHULY;
		END LOOP;

  /* v_ISBICAN_BICAO Bị can hay bị cáo */
  /* v_BICAN_BICAO_TEN Tên bị can (bị cáo) */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        'bị cáo' v_ISBICAN_BICAO,
        nvl2(T6.SoBiCan,T2.HOTEN  || ' và các đồng phạm',T2.HOTEN) v_BICAN_BICAO_TEN
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID and T2.BICANDAUVU=1
        left join (select count(ID) SoBiCan from AHS_BICANBICAO where VUANID=t_VUANID) T6 on T1.v_VUANID=T2.VUANID and T6.SoBiCan>1
		) LOOP
      v_ARRAY(ITEM.v_STT).v_ISBICAN_BICAO:=ITEM.v_ISBICAN_BICAO;
      v_ARRAY(ITEM.v_STT).v_BICAN_BICAO_TEN:=ITEM.v_BICAN_BICAO_TEN;
		END LOOP;

  /* v_DONVI_TRUYTO_XETXU Đơn vị truy tố (xét xử)*/
    FOR ITEM IN (
			SELECT 
				T1.v_STT,
        T4.TEN v_DONVI_TRUYTO_XETXU
			FROM 
				TABLE(v_ARRAY) T1 
				LEFT JOIN (select T2.TOAANID,T2.VUANID,T3.TEN from AHS_SOTHAM_BANAN T2
                    inner join DM_TOAAN T3 on T2.TOAANID=T3.ID
                   ) T4 ON T1.v_VUANID=T4.VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_DONVI_TRUYTO_XETXU:=ITEM.v_DONVI_TRUYTO_XETXU;
		END LOOP;

  /* v_TOIDANH Tội danh */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
         LISTAGG(
                cast(T5.ToiDanh as varchar2(4000))
                ,'; '
                ) WITHIN GROUP (ORDER BY T1.v_STT) v_TOIDANH
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN (select distinct T2.VUANID,
                          NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                    from AHS_BICANBICAO T2
                    INNER JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET T3 ON T3.BICANID=T2.ID
                    inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                    where T2.BICANDAUVU=1
                    )T5 on T5.VUANID=T1.v_VUANID
          group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TOIDANH:=ITEM.v_TOIDANH;
		END LOOP;

  /* v_NGUOIPC_CHUCVU Chức danh của người phân công */
  /* v_NGUOIPC_TEN Tên người phân công*/
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        upper(decode(instr(lower(T4.TEN),'phó chánh án'),0,nvl(T4.TEN,''),nvl2(T4.TEN,'KT.CHÁNH ÁN'||CHR(10)||T4.TEN,''))) v_NGUOIPC_CHUCVU, 
        T3.HOTEN v_NGUOIPC_TEN
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID
        INNER JOIN DM_CANBO T3 on T3.ID=T2.NGUOIPHANCONGID
        LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCVUID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_CHUCVU:=ITEM.v_NGUOIPC_CHUCVU;
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_TEN:=ITEM.v_NGUOIPC_TEN;
		END LOOP;
  END;

/* 03_HS */
PROCEDURE AHS_03
	(
		 in_VUANID IN NUMBER,
     in_MAGIAIDOAN IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	) as
    v_ARRAY AHS_T_03;
    v_TOAANID number;
    v_DIACHI varchar(500);
    v_LOAITOA varchar(50);
    v_TENTOAAN_Templ varchar(500);
    v_TOACAPTREN number;
BEGIN
    -- v_MAGIAIDOAN: Sơ thẩm=2, Phúc thẩm=3
    -- Lấy Giai đoạn vụ án
    select decode(in_MAGIAIDOAN,2,TOAANID,3,TOAPHUCTHAMID,0) into v_TOAANID from AHS_VUAN where ID=in_VUANID;
    -- Lấy địa điểm
    select LOAITOA,CAPCHAID,TEN,
      decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ','')) 
      into v_LOAITOA,v_TOACAPTREN,v_TENTOAAN_Templ,v_DIACHI
    from DM_TOAAN where ID=v_TOAANID;
    -- Lấy địa điểm với tòa cấp huyện
    if v_LOAITOA='CAPHUYEN' then
      select decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ','')) into v_DIACHI 
      from DM_TOAAN where ID=v_TOACAPTREN;
    end if;
    -- Lấy Tên tòa án
    if instr('CẤP CAO',v_TENTOAAN_Templ)>0 then
      select replace(v_TENTOAAN_Templ,'cấp cao','cấp cao'||chr(10)) into v_TENTOAAN_Templ from sys.dual;
    elsif instr('TỐI CAO',v_TENTOAAN_Templ)=0 then
      select replace(replace(v_TENTOAAN_Templ,'Tòa án nhân dân','Tòa án nhân dân'||chr(10)),',',chr(10)) into v_TENTOAAN_Templ from sys.dual;
    end if;
    if in_MAGIAIDOAN=2 -- Sơ thẩm
    then
    begin
      SELECT AHS_R_03(
        v_STT =>row_number() over (order by T2.ID),
        v_VUANID =>in_VUANID,
        v_TOAANID =>v_TOAANID,
        v_CANBOBITHAYID =>T2.NGUOIBITHAY,
        v_TENTOAAN_1_4 =>upper(v_TENTOAAN_Templ),
        v_SOQD_2 =>T2.SOQUYETDINH || '/' || to_char(T2.NGAYQD,'yyyy'),
        v_DIADIEM =>v_DIACHI || ', ngày '|| to_char(T2.NGAYQD,'dd') || ' tháng ' || to_char(T2.NGAYQD,'MM') || ' năm ' || to_char(T2.NGAYQD,'yyyy'),
        v_LOAITHAYDOI_3 =>lower(decode(T2.THAYDOITCTT,1,'Thẩm phán',2,'Hội thẩm',3,'Thư ký','')),
        v_DIEULUATBOSUNG_5 =>decode(T2.THAYDOITCTT,1,'53',2,'53',3,'54',''),
        v_LYDO_6 =>T7.TEN,
        v_CANBO_DUOC_PC_7 =>decode(T2.THAYDOITCTT,2,decode(T5.GIOITINH,1,'Ông ',0,'Bà ','')||T5.HOTEN,decode(T3.GIOITINH,1,'Ông ',0,'Bà ','')||T3.HOTEN),
        v_CANBO_DUOC_PC_CHUCDANH_8 =>decode(T2.THAYDOITCTT,2,regexp_replace(nvl(T6.TEN,''),' trung cấp| sơ cấp| cao cấp| chính| Tòa án| Tòa án ko ÐHL',''),regexp_replace(nvl(T4.TEN,''),' trung cấp| sơ cấp| cao cấp| chính| Tòa án| Tòa án ko ÐHL','')),
        v_CANBO_BITHAY_9 =>NULL,
        v_CANBO_BITHAY_CHUCDANH_10 =>NULL,
        v_NHIEMVUCANBO_11 =>decode(T2.THAYDOITCTT,3,'tố tụng','giải quyết, xem xét'),
        v_GIAIDOAN =>'sơ thẩm',
        v_SOTHULY_12 =>NULL,
        v_ISBICANBICAO =>NULL,
        v_BICAN_BICAO_TEN_13 =>NULL,
        v_TOIDANH_14 =>NULL,
        v_QD_BITHAY_16 =>NULL,
        v_NGUOIPC_CHUCVU =>NULL,
        v_NGUOIPC_TEN =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHS_SOTHAM_QUYETDINH_VUAN T2
      LEFT JOIN DM_CANBO T3 on T3.ID=T2.NGUOIDUOCPHANCONG
      LEFT JOIN DM_CANBOVKS T5 on T5.ID=T2.NGUOIDUOCPHANCONG
      LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCDANHID
      LEFT JOIN DM_DATAITEM T6 on T6.ID=T5.CHUCVUID
      LEFT JOIN DM_QD_QUYETDINH_LYDO T7 on T7.ID=T2.LYDOID
      where T2.VUANID=in_VUANID and T2.THAYDOITCTT>0;

      PKG_GSTP_REPORT_HS.AHS_FILL_03_ST(v_ARRAY);
    end;
    else
    begin
      SELECT AHS_R_03(
        v_STT =>row_number() over (order by T2.ID),
        v_VUANID =>in_VUANID,
        v_TOAANID =>v_TOAANID,
        v_CANBOBITHAYID =>T2.NGUOIBITHAY,
        v_TENTOAAN_1_4 =>upper(v_TENTOAAN_Templ),
        v_SOQD_2 =>T2.SOQUYETDINH || '/' || to_char(T2.NGAYQD,'yyyy'),
        v_DIADIEM =>v_DIACHI || ', ngày '|| to_char(T2.NGAYQD,'dd') || ' tháng ' || to_char(T2.NGAYQD,'MM') || ' năm ' || to_char(T2.NGAYQD,'yyyy'),
        v_LOAITHAYDOI_3 =>lower(decode(T2.THAYDOITCTT,1,'Thẩm phán',2,'Hội thẩm',3,'Thư ký','')),
        v_DIEULUATBOSUNG_5 =>decode(T2.THAYDOITCTT,1,'53',2,'53',3,'54',''),
        v_LYDO_6 =>T7.TEN,
        v_CANBO_DUOC_PC_7 =>decode(T2.THAYDOITCTT,2,decode(T5.GIOITINH,1,'Ông ',0,'Bà ','')||T5.HOTEN,decode(T3.GIOITINH,1,'Ông ',0,'Bà ','')||T3.HOTEN),
        v_CANBO_DUOC_PC_CHUCDANH_8 =>decode(T2.THAYDOITCTT,2,regexp_replace(nvl(T6.TEN,''),' trung cấp| sơ cấp| cao cấp| chính| Tòa án| Tòa án ko ÐHL',''),regexp_replace(nvl(T4.TEN,''),' trung cấp| sơ cấp| cao cấp| chính| Tòa án| Tòa án ko ÐHL','')),
        v_CANBO_BITHAY_9 =>NULL,
        v_CANBO_BITHAY_CHUCDANH_10 =>NULL,
        v_NHIEMVUCANBO_11 =>decode(T2.THAYDOITCTT,3,'tố tụng','giải quyết, xem xét'),
        v_GIAIDOAN =>'sơ thẩm',
        v_SOTHULY_12 =>NULL,
        v_ISBICANBICAO =>NULL,
        v_BICAN_BICAO_TEN_13 =>NULL,
        v_TOIDANH_14 =>NULL,
        v_QD_BITHAY_16 =>NULL,
        v_NGUOIPC_CHUCVU =>NULL,
        v_NGUOIPC_TEN =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHS_PHUCTHAM_QUYETDINH_VUAN T2
      LEFT JOIN DM_CANBO T3 on T3.ID=T2.NGUOIDUOCPHANCONG
      LEFT JOIN DM_CANBOVKS T5 on T5.ID=T2.NGUOIDUOCPHANCONG
      LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCDANHID
      LEFT JOIN DM_DATAITEM T6 on T6.ID=T5.CHUCVUID
      LEFT JOIN DM_QD_QUYETDINH_LYDO T7 on T7.ID=T2.LYDOID
      where T2.VUANID=in_VUANID and T2.THAYDOITCTT>0;

      PKG_GSTP_REPORT_HS.AHS_FILL_03_PT(v_ARRAY);
    end;
    end if;

		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);

    EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
END;

PROCEDURE AHS_FILL_03_ST
	(
		v_ARRAY IN OUT AHS_T_03
	) AS
	t_VUANID number;
BEGIN
  select T1.v_VUANID into t_VUANID from TABLE(v_ARRAY) T1 where rownum=1;
  /* v_CANBO_BITHAY_9,v_CANBO_BITHAY_CHUCDANH_10 Tên và chức danh cán bộ bị thay thế 9,10*/
  for item in
  (
    select
      T1.v_STT,
      decode(T2.THAYDOITCTT,2,decode(T5.GIOITINH,1,'Ông ',0,'Bà ','')||T5.HOTEN,decode(T3.GIOITINH,1,'Ông ',0,'Bà ','')||T3.HOTEN) v_CANBO_BITHAY_9,
      decode(T2.THAYDOITCTT,2,regexp_replace(nvl(T6.TEN,''),' trung cấp| sơ cấp| cao cấp| chính| Tòa án| Tòa án ko ÐHL',''),regexp_replace(nvl(T4.TEN,''),' trung cấp| sơ cấp| cao cấp| chính| Tòa án| Tòa án ko ÐHL','')) v_CANBO_BITHAY_CHUCDANH_10
    from table(v_ARRAY) T1
    inner join AHS_SOTHAM_QUYETDINH_VUAN T2 on T2.VUANID=T1.v_VUANID and T2.NGUOIBITHAY=T1.v_CANBOBITHAYID
    LEFT JOIN DM_CANBO T3 on T3.ID=T2.NGUOIBITHAY
    LEFT JOIN DM_CANBOVKS T5 on T5.ID=T2.NGUOIBITHAY
    LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCDANHID
    LEFT JOIN DM_DATAITEM T6 on T6.ID=T5.CHUCVUID
  )loop
    v_ARRAY(item.v_STT).v_CANBO_BITHAY_9 :=item.v_CANBO_BITHAY_9;
    v_ARRAY(item.v_STT).v_CANBO_BITHAY_CHUCDANH_10 :=item.v_CANBO_BITHAY_CHUCDANH_10;
  end loop;

  /* v_SOTHULY_12 Số thụ lý ghi số:…/…/TLST-HS ngày…tháng…năm…; */
  for item in
  (
    select
      T1.v_STT,
      LISTAGG(
        cast(
        T2.SOTHULY || '/' || to_char(T2.NGAYTHULY,'yyyy') || '/TLST-HS ngày ' || to_char(T2.NGAYTHULY,'dd')
        || ' tháng ' || to_char(T2.NGAYTHULY,'MM') || ' năm ' || to_char(T2.NGAYTHULY,'yyyy')
        as varchar2(200))
      ) within group (order by T1.v_STT) v_SOTHULY_12
    from table(v_ARRAY) T1
    inner join (select T3.VUANID,T3.SOTHULY,max(T3.NGAYTHULY) NGAYTHULY 
                from AHS_SOTHAM_THULY T3 
                where rownum<2 and T3.VUANID=t_VUANID
                group by T3.VUANID,T3.SOTHULY
                ) T2 on T1.v_VUANID=T2.VUANID
    GROUP BY T1.v_STT
  ) loop
    v_ARRAY(item.v_STT).v_SOTHULY_12 :=item.v_SOTHULY_12;
  end loop;

  /* v_ISBICANBICAO, v_BICAN_BICAO_TEN_13 */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        nvl2(T5.VUANID,'bị can','bị cáo') v_ISBICANBICAO,
        nvl2(T6.SoBiCan,T2.HOTEN  || ' và các đồng phạm',T2.HOTEN) v_BICAN_BICAO_TEN_13
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID and T2.BICANDAUVU=1
        left join (select count(ID) SoBiCan from AHS_BICANBICAO where VUANID=t_VUANID) T6 on T1.v_VUANID=T2.VUANID and T6.SoBiCan>1
        LEFT JOIN (select T3.VUANID from AHS_SOTHAM_QUYETDINH_VUAN T3
                    inner join DM_QD_LOAI T4 on T4.ID=T3.LOAIQDID and T4.HIEULUC=1 and T4.MA='DVARXX'
                    ) T5 on T5.VUANID=T1.v_VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_ISBICANBICAO:=ITEM.v_ISBICANBICAO;
      v_ARRAY(ITEM.v_STT).v_BICAN_BICAO_TEN_13:=ITEM.v_BICAN_BICAO_TEN_13;
		END LOOP;

  /* v_TOIDANH_14 */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
         LISTAGG(
                cast(T5.ToiDanh as varchar2(4000))
                ,'; '
                ) WITHIN GROUP (ORDER BY T1.v_STT) v_TOIDANH_14
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN (select distinct T2.VUANID,
                          NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                    from AHS_BICANBICAO T2
                    INNER JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT T3 ON T3.BICANID=T2.ID
                    inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                    where T2.BICANDAUVU=1
                    )T5 on T5.VUANID=T1.v_VUANID
          group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TOIDANH_14:=ITEM.v_TOIDANH_14;
  END LOOP;

  /* v_QD_BITHAY_16 Quyết định bị thay thế ví dụ: số 68/2017/QĐ-TA ngày 02 tháng 5 năm 2017*/
   FOR ITEM IN (
			SELECT 
				T1.v_STT,
        LISTAGG(
          cast(
              T2.SOQD || '/' || to_char(T2.NGAYQD,'yyyy') || '/QĐ-TA ngày ' 
              || to_char(T2.NGAYQD,'dd') || ' tháng ' || to_char(T2.NGAYQD,'MM') || ' năm ' || to_char(T2.NGAYQD,'yyyy')
              as varchar2(100)
              )
        )within group (order by T1.v_STT) v_QD_BITHAY_16
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.CANBOID=T1.v_CANBOBITHAYID
        group by T1.v_STT
		) LOOP
      v_ARRAY(ITEM.v_STT).v_QD_BITHAY_16:=ITEM.v_QD_BITHAY_16;
		END LOOP;

  /* v_NGUOIPC_CHUCVU,v_NGUOIPC_TEN */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        upper(decode(instr(lower(T4.TEN),'phó chánh án'),0,nvl(T4.TEN,''),nvl2(T4.TEN,'KT.CHÁNH ÁN'||CHR(10)||T4.TEN,''))) v_NGUOIPC_CHUCVU, 
        T3.HOTEN v_NGUOIPC_TEN
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID
        INNER JOIN DM_CANBO T3 on T3.ID=T2.NGUOIPHANCONGID
        LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCVUID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_CHUCVU:=ITEM.v_NGUOIPC_CHUCVU;
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_TEN:=ITEM.v_NGUOIPC_TEN;
		END LOOP;

END;

PROCEDURE AHS_FILL_03_PT
	(
		v_ARRAY IN OUT AHS_T_03
	) AS
	t_VUANID number;
BEGIN
  select T1.v_VUANID into t_VUANID from TABLE(v_ARRAY) T1 where rownum=1;
  /* v_CANBO_BITHAY_9,v_CANBO_BITHAY_CHUCDANH_10 Tên và chức danh cán bộ bị thay thế 9,10*/
  for item in
  (
    select
      T1.v_STT,
      decode(T2.THAYDOITCTT,2,decode(T5.GIOITINH,1,'Ông ',0,'Bà ','')||T5.HOTEN,decode(T3.GIOITINH,1,'Ông ',0,'Bà ','')||T3.HOTEN) v_CANBO_BITHAY_9,
      decode(T2.THAYDOITCTT,2,regexp_replace(nvl(T6.TEN,''),' trung cấp| sơ cấp| cao cấp| chính| Tòa án| Tòa án ko ÐHL',''),regexp_replace(nvl(T4.TEN,''),' trung cấp| sơ cấp| cao cấp| chính| Tòa án| Tòa án ko ÐHL','')) v_CANBO_BITHAY_CHUCDANH_10
    from table(v_ARRAY) T1
    inner join AHS_PHUCTHAM_QUYETDINH_VUAN T2 on T2.VUANID=T1.v_VUANID and T2.NGUOIBITHAY=T1.v_CANBOBITHAYID
    LEFT JOIN DM_CANBO T3 on T3.ID=T2.NGUOIBITHAY
    LEFT JOIN DM_CANBOVKS T5 on T5.ID=T2.NGUOIBITHAY
    LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCDANHID
    LEFT JOIN DM_DATAITEM T6 on T6.ID=T5.CHUCVUID
  )loop
    v_ARRAY(item.v_STT).v_CANBO_BITHAY_9 :=item.v_CANBO_BITHAY_9;
    v_ARRAY(item.v_STT).v_CANBO_BITHAY_CHUCDANH_10 :=item.v_CANBO_BITHAY_CHUCDANH_10;
  end loop;

  /* v_SOTHULY_12 Số thụ lý ghi số:…/…/TLST-HS ngày…tháng…năm…; */
  for item in
  (
    select
      T1.v_STT,
      LISTAGG(
        cast(
        T2.SOTHULY || '/' || to_char(T2.NGAYTHULY,'yyyy') || '/TLST-HS ngày ' || to_char(T2.NGAYTHULY,'dd')
        || ' tháng ' || to_char(T2.NGAYTHULY,'MM') || ' năm ' || to_char(T2.NGAYTHULY,'yyyy')
        as varchar2(200))
      ) within group (order by T1.v_STT) v_SOTHULY_12
    from table(v_ARRAY) T1
    inner join (select T3.VUANID,T3.SOTHULY,max(T3.NGAYTHULY) NGAYTHULY 
                from AHS_PHUCTHAM_THULY T3 
                where rownum<2 and T3.VUANID=t_VUANID
                group by T3.VUANID,T3.SOTHULY
                ) T2 on T1.v_VUANID=T2.VUANID
    GROUP BY T1.v_STT
  ) loop
    v_ARRAY(item.v_STT).v_SOTHULY_12 :=item.v_SOTHULY_12;
  end loop;

  /* v_ISBICANBICAO, v_BICAN_BICAO_TEN_13 */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        'bị cáo' v_ISBICANBICAO,
        nvl2(T6.SoBiCan,T4.HOTEN  || ' và các đồng phạm',T4.HOTEN) v_BICAN_BICAO_TEN_13
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_PHUCTHAM_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID
        INNER JOIN AHS_BICANBICAO T4 ON T4.ID=T2.BICANID and T4.BICANDAUVU=1
        left join (select count(ID) SoBiCan from AHS_BICANBICAO where VUANID=t_VUANID) T6 on T1.v_VUANID=T2.VUANID and T6.SoBiCan>1
		) LOOP
      v_ARRAY(ITEM.v_STT).v_ISBICANBICAO:=ITEM.v_ISBICANBICAO;
      v_ARRAY(ITEM.v_STT).v_BICAN_BICAO_TEN_13:=ITEM.v_BICAN_BICAO_TEN_13;
		END LOOP;

  /* v_TOIDANH_14 */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
         LISTAGG(
                cast(T5.ToiDanh as varchar2(4000))
                ,'; '
                ) WITHIN GROUP (ORDER BY T1.v_STT) v_TOIDANH_14
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN (select distinct T2.VUANID,
                          NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                    from AHS_BICANBICAO T2
                    INNER JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET T3 ON T3.BICANID=T2.ID
                    inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                    where T2.BICANDAUVU=1
                    )T5 on T5.VUANID=T1.v_VUANID
          group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TOIDANH_14:=ITEM.v_TOIDANH_14;
		END LOOP;

  /* v_QD_BITHAY_16 Quyết định bị thay thế ví dụ: số 68/2017/QĐ-TA ngày 02 tháng 5 năm 2017*/
   FOR ITEM IN (
			SELECT 
				T1.v_STT,
        LISTAGG(
          cast(
              T2.SOQD || '/' || to_char(T2.NGAYQD,'yyyy') || '/QĐ-TA ngày ' 
              || to_char(T2.NGAYQD,'dd') || ' tháng ' || to_char(T2.NGAYQD,'MM') || ' năm ' || to_char(T2.NGAYQD,'yyyy')
              as varchar2(100)
              )
        )within group (order by T1.v_STT) v_QD_BITHAY_16
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.CANBOID=T1.v_CANBOBITHAYID
        group by T1.v_STT
		) LOOP
      v_ARRAY(ITEM.v_STT).v_QD_BITHAY_16:=ITEM.v_QD_BITHAY_16;
		END LOOP;

  /* v_NGUOIPC_CHUCVU,v_NGUOIPC_TEN */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        upper(decode(instr(lower(T4.TEN),'phó chánh án'),0,nvl(T4.TEN,''),nvl2(T4.TEN,'KT.CHÁNH ÁN'||CHR(10)||T4.TEN,''))) v_NGUOIPC_CHUCVU, 
        T3.HOTEN v_NGUOIPC_TEN
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID
        INNER JOIN DM_CANBO T3 on T3.ID=T2.NGUOIPHANCONGID
        LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCVUID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_CHUCVU:=ITEM.v_NGUOIPC_CHUCVU;
      v_ARRAY(ITEM.v_STT).v_NGUOIPC_TEN:=ITEM.v_NGUOIPC_TEN;
		END LOOP;

END;

/* 20-HS*/
PROCEDURE AHS_20
	(
		 in_VUANID IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	)
  AS
    v_ARRAY AHS_T_20;
    v_TOAANID number;
    v_DIACHI varchar(500);
    v_LOAITOA varchar(50);
    v_TENTOAAN_Templ varchar(500);
    v_TOACAPTREN number;
  BEGIN
    select TOAANID into v_TOAANID from AHS_VUAN where ID=in_VUANID;
    -- Lấy địa điểm
    select LOAITOA,CAPCHAID,TEN,
      decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ','')) 
      into v_LOAITOA,v_TOACAPTREN,v_TENTOAAN_Templ,v_DIACHI
    from DM_TOAAN where ID=v_TOAANID;
    -- Lấy địa điểm với tòa cấp huyện
    if v_LOAITOA='CAPHUYEN' then
      select decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ','')) into v_DIACHI 
      from DM_TOAAN where ID=v_TOACAPTREN;
    end if;
    -- Lấy Tên tòa án
    if instr('CẤP CAO',v_TENTOAAN_Templ)>0 then
      select replace(v_TENTOAAN_Templ,'cấp cao','cấp cao'||chr(10)) into v_TENTOAAN_Templ from sys.dual;
    elsif instr('TỐI CAO',v_TENTOAAN_Templ)=0 then
      select replace(replace(v_TENTOAAN_Templ,'Tòa án nhân dân','Tòa án nhân dân'||chr(10)),',',chr(10)) into v_TENTOAAN_Templ from sys.dual;
    end if;
    SELECT AHS_R_20(
        v_STT =>row_number() over (order by T2.ID),
        v_VUANID =>in_VUANID,
        v_TOAANID =>v_TOAANID,
        v_BICAODAUVUID =>T4.ID,
        v_BICAODAUVUHOTEN => T4.HOTEN,
        v_TENTOAAN_1_3 =>upper(v_TENTOAAN_Templ),
        v_TOASOTHAM =>v_TENTOAAN_Templ,
        v_SOQD_2 =>T2.SOQUYETDINH || '/' || to_char(T2.NGAYQD,'yyyy'),
        v_DIADIEM =>v_DIACHI || ', ngày '|| to_char(T2.NGAYQD,'dd') || ' tháng ' || to_char(T2.NGAYQD,'MM') || ' năm ' || to_char(T2.NGAYQD,'yyyy'),
        V_SO_BANAN_ST =>T7.SOBANAN || '/' || to_char(T7.NGAYBANAN,'yyyy')|| '/HS-ST' || ', ngày '|| to_char(T7.NGAYBANAN,'dd') || ' tháng ' || to_char(T7.NGAYBANAN,'MM') || ' năm ' || to_char(T7.NGAYBANAN,'yyyy'),
        v_SOTHULY =>NULL,
        v_NGAY_KC => 'Ngày '|| to_char(T8.NGAYKHANGCAO,'dd') || ' tháng ' || to_char(T8.NGAYKHANGCAO,'MM') || ' năm ' || to_char(T8.NGAYKHANGCAO,'yyyy'),
        v_NGAY_KN => 'Ngày '|| to_char(T10.NGAYKN,'dd') || ' tháng ' || to_char(T10.NGAYKN,'MM') || ' năm ' || to_char(T10.NGAYKN,'yyyy'),
        v_DONVI_KN => DECODE(T10.DONVIKN, 1, 'Viện kiểm sát kháng nghị', 0, 'khác'),
        v_CACBICAO_4 =>NULL,
        v_VKS_TEN_5 =>replace(v_TENTOAAN_Templ,'Tòa án','Viện kiểm sát'),
        v_NGUOI_KC =>DECODE(T9.BICANDAUVU, 0, '(Bị cáo) ', 1, '(Bị cáo đầu vụ) ' , '') || T9.HOTEN,
        v_NDKC =>DECODE(T8.NOIDUNGKHANGCAO, null, '', 'với nội dung ') || T8.NOIDUNGKHANGCAO,
        v_TOIDANH_6 =>NULL,
        v_LYDO_7 =>T5.TEN,
        v_DIEU_KHOAN =>NULL,
        v_TPCT =>NULL,
        v_TPCT_TEN =>PC.HOTEN,
        v_TP_HDXX =>NULL,
        v_TP_DUKHUYET =>NULL,
        v_HTND =>NULL,
        v_HTND_DUKHUYET =>NULL,
        v_THUKY =>NULL,
        v_THUKY_DUKHUYET =>NULL,
        v_KIEMSATVIEN =>NULL,
        v_KIEMSATVIEN_DUKHUYET =>NULL,
        v_NGUOITGTT =>NULL,
        v_ISBICAN_BICAO =>NULL,
        v_BICAN_BICAO_TEN =>NULL,
        v_DONVI_TRUYTO_XETXU =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHS_SOTHAM_QUYETDINH_VUAN T2
      LEFT JOIN DM_QD_QUYETDINH T3 on T3.ID=T2.QUYETDINHID --and T3.MA='20-HS' or T3.MA='39-HS' or T3.MA='40-HS'
      LEFT JOIN AHS_BICANBICAO T4 on T2.VUANID=T4.VUANID and T4.BICANDAUVU=1
      LEFT JOIN DM_QD_QUYETDINH_LYDO T5 on T3.ID=T5.QDID and T5.HIEULUC=1
      LEFT JOIN AHS_SOTHAM_HDXX T6 on T6.VUANID=T2.VUANID and T6.MAVAITRO='THAMPHAN'
      LEFT JOIN DM_CANBO PC on PC.ID=T6.CANBOID
      LEFT JOIN AHS_SOTHAM_BANAN T7 on T7.VUANID=T2.VUANID
      --RIGHT JOIN AHS_SOTHAM_KHANGCAO T8 on T8.VUANID=T2.VUANID
      LEFT JOIN AHS_SOTHAM_KHANGCAO T8 on T8.VUANID=T2.VUANID
      LEFT JOIN AHS_BICANBICAO T9 on T9.VUANID=T2.VUANID
      LEFT JOIN AHS_SOTHAM_KHANGNGHI T10 on T10.VUANID=T2.VUANID
      LEFT JOIN AHS_SOTHAM_RUTKHANGCAO T11 on T11.KHANGCAOID = T8.ID
      
      where T2.VUANID=in_VUANID;

      PKG_GSTP_REPORT_HS.AHS_FILL_20(v_ARRAY);
      -- v_ARRAY.DELETE;
      OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);

      EXCEPTION 
      WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20000, sqlerrm);
  END;

PROCEDURE AHS_FILL_20
	(
		v_ARRAY IN OUT AHS_T_20
	)
  AS
  t_VUANID number;
  t_BICANID number;
  BEGIN
    select T1.v_VUANID,T1.v_BICAODAUVUID into t_VUANID,t_BICANID from TABLE(v_ARRAY) T1 where rownum=1;
    for item in
    (
      select 
        T1.v_STT,
        cast(
          T2.SOTHULY || '/' || to_char(T2.NGAYTHULY,'yyyy') || '/TLST-HS'
          || ' ngày ' || to_char(T2.NGAYTHULY,'dd') || ' tháng ' || to_char(T2.NGAYTHULY,'MM') || ' năm ' || to_char(T2.NGAYTHULY,'yyyy') 
          as varchar2(200)) v_SOTHULY
      from table(v_ARRAY) T1
      inner join (select T3.VUANID,T3.SOTHULY,max(T3.NGAYTHULY) NGAYTHULY 
                  from AHS_SOTHAM_THULY T3 
                  where rownum<2 and T3.VUANID=t_VUANID
                  group by T3.VUANID,T3.SOTHULY
                ) T2 on T1.v_VUANID=T2.VUANID
    )loop 
     v_ARRAY(item.v_STT).v_SOTHULY:=item.v_SOTHULY;
    end loop;

    /* v_CACBICAO_4 Các bị cáo */
    for item in
    (
      select
        T1.v_STT,
        listagg(
          cast(
            decode(T2.LOAIDOITUONG,0,
              '- ' || T2.HOTEN || ', ngày sinh: ' || decode(to_char(T2.NGAYSINH,'dd/MM/yyyy')||' ',' ',to_char(T2.NGAYSINH,'dd/MM/yyyy'),cast(T2.NAMSINH as varchar(5))) 
              || nvl2(T2.KHTTCHITIET,CHR(10) || '   Nơi sinh: ' || T2.KHTTCHITIET,'')
              || nvl2(T3.TEN,CHR(10) || '   Nghề nghiệp: ' || T3.TEN,'')
              || nvl2(T2.TAMTRUCHITIET,CHR(10) || '   Nơi cư trú: ' || T2.TAMTRUCHITIET,'')
              || CHR(10)
              ,
              '- ' || T2.HOTEN
              || nvl2(T2.KHTTCHITIET,CHR(10) || '   Trụ sở chính tại: ' || T2.KHTTCHITIET,'')
              || nvl2(T2.TENKHAC,CHR(10) || '   Người đại diện: ' || T2.TENKHAC,'')
              || CHR(10)
              )
            as varchar2(4000)
          )
        ) within group (order by T1.v_STT) v_CACBICAO_4
      from table(v_ARRAY) T1
      inner join AHS_BICANBICAO T2 on T1.v_VUANID=T2.VUANID
      left join DM_DATAITEM T3 on T2.NGHENGHIEPID=T3.ID
      group by T1.v_STT
    ) loop
      v_ARRAY(item.v_STT).v_CACBICAO_4:=item.v_CACBICAO_4; 
    end loop;
    
  /* v_ISBICAN_BICAO Bị can hay bị cáo */
  /* v_BICAN_BICAO_TEN Tên bị can (bị cáo) */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        nvl2(T5.VUANID,'bị can','bị cáo') v_ISBICAN_BICAO,
        nvl2(T6.SoBiCan,T2.HOTEN  || ' và các đồng phạm',T2.HOTEN) v_BICAN_BICAO_TEN
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID and T2.BICANDAUVU=1
        left join (select count(ID) SoBiCan from AHS_BICANBICAO where VUANID=t_VUANID) T6 on T1.v_VUANID=T2.VUANID and T6.SoBiCan>1
        LEFT JOIN (select T3.VUANID from AHS_SOTHAM_QUYETDINH_VUAN T3
                    inner join DM_QD_LOAI T4 on T4.ID=T3.LOAIQDID and T4.HIEULUC=1 and T4.MA='DVARXX'
                    ) T5 on T5.VUANID=T1.v_VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_ISBICAN_BICAO:=ITEM.v_ISBICAN_BICAO;
      v_ARRAY(ITEM.v_STT).v_BICAN_BICAO_TEN:=ITEM.v_BICAN_BICAO_TEN;
		END LOOP;
  /* v_DONVI_TRUYTO_XETXU Đơn vị truy tố (xét xử)*/
    FOR ITEM IN (
			SELECT 
				T1.v_STT,
       CONCAT(nvl2(T4.VUANID,T4.TEN,replace(T4.TEN,'Tòa án','Viện kiểm sát')), ' truy tố') v_DONVI_TRUYTO_XETXU
			FROM 
				TABLE(v_ARRAY) T1 
				LEFT JOIN (select T2.TOAANID,T2.VUANID,T3.TEN from AHS_SOTHAM_BANAN T2
                    inner join DM_TOAAN T3 on T2.TOAANID=T3.ID
                   ) T4 ON T1.v_VUANID=T4.VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_DONVI_TRUYTO_XETXU:=ITEM.v_DONVI_TRUYTO_XETXU;
		END LOOP;
    
  /* v_TOIDANH_6 Tội danh */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
         LISTAGG(
                cast(T5.ToiDanh as varchar2(4000))
                ,'; '
                ) WITHIN GROUP (ORDER BY T1.v_STT) v_TOIDANH_6
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN (select distinct T2.VUANID,
                          NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                    from AHS_BICANBICAO T2
                    INNER JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT T3 ON T3.BICANID=T2.ID
                    inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                    where T2.BICANDAUVU=1
                    )T5 on T5.VUANID=T1.v_VUANID
          group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TOIDANH_6:=ITEM.v_TOIDANH_6;
  END LOOP;

  /* v_DIEU_KHOAN Điều khoản */
  FOR ITEM IN (
  SELECT 
      T1.v_STT,
      T5.DIEUKHOAN v_DIEU_KHOAN
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN (select 
                T2.VUANID,T2.DIEU,
                LISTAGG(
                  cast(
                    replace(nvl2(T2.DIEM,'Điểm ' || T2.DIEM,'') || ' Khoản ' || T2.KHOAN || ' Điều ' || T2.DIEU,', Khoản',' Khoản')
                  as varchar2(4000)
                  )||'; '
                )within group (order by T2.VUANID,T2.DIEU) as DIEUKHOAN
              from
              (
                select
                  VUANID,c.DIEU,c.KHOAN,
                  LISTAGG(
                    cast(
                     regexp_replace(nvl2(c.DIEM,'Điểm ' || c.DIEM || ',',''),'Điểm ,|Điểm ','')
                    as varchar2(4000)
                    )
                  )within group (order by VUANID,c.DIEU,c.KHOAN) as DIEM
                  from  AHS_SOTHAM_CAOTRANG_DIEULUAT a 
                  inner join DM_BOLUAT_TOIDANH c on a.ToiDanhID = c.ID and c.HIEULUC=1
                  where a.BICANID=t_BICANID and a.VUANID=t_VUANID
                  group by VUANID,c.DIEU,c.KHOAN
                ) T2
                where T2.DIEU is not null and T2.KHOAN is not null
                group by T2.VUANID,T2.DIEU
              )T5 on T5.VUANID=T1.v_VUANID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_DIEU_KHOAN:=ITEM.v_DIEU_KHOAN;
  END LOOP;

/* v_TPCT Thẩm phán chủ tọa */
  for item in
  (
    SELECT 
      T1.v_STT,
      decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN v_TPCT
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THAMPHAN'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  )loop
    v_ARRAY(ITEM.v_STT).v_TPCT:=ITEM.v_TPCT;
  end loop;

/* v_TP_HDXX Thẩm phán (nếu Hội đồng xét xử sơ thẩm gồm có 5 người) */
  for item in
  (
    SELECT 
      T1.v_STT,
      ListAGG(
        cast(
          nvl2(T3.HOTEN,decode(T3.GIOITINH,1,'Ông ','Bà ') || T3.HOTEN || ', ','')
          as varchar2(500)
          )
      )within group (order by T1.v_STT) as v_TP_HDXX
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THAMPHANHDXX'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_TP_HDXX:=ITEM.v_TP_HDXX;
  end loop;

  /* v_TP_DUKHUYET Thẩm phán dự khuyết (nếu có) */
  for item in
  (
    SELECT 
      T1.v_STT,
      listagg(
        cast(
            nvl2(T3.HOTEN,'' || decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ', ','')
            as varchar2(500)
            )
      )within group (order by T1.v_STT) as v_TP_DUKHUYET
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THAMPHANDUKHUYET'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_TP_DUKHUYET:=ITEM.v_TP_DUKHUYET;
  end loop;

  /* v_HTND Các Hội thẩm nhân dân (quân nhân) */
  for item in
  (
    SELECT 
      T1.v_STT,
      listagg(
        cast(
          nvl2(T3.HOTEN,decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ', ','')
          as varchar2(500)
          )
      )within group (order by T1.v_STT) as v_HTND
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='HTND'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_HTND:=ITEM.v_HTND;
  end loop;

  /* v_HTND_DUKHUYET Hội thẩm nhân dân (quân nhân) dự khuyết (nếu có) */
  /* v_THUKY Thư ký phiên tòa */
  for item in
  (
    SELECT 
      T1.v_STT,
      listagg(
        cast(
            nvl2(T3.HOTEN,decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ', ','')
            as varchar2(500)
            )
      )within group (order by T1.v_STT)as v_THUKY
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THUKY'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_THUKY:=ITEM.v_THUKY;
  end loop;

  /* v_THUKY_DUKHUYET Thư ký phiên tòa dự khuyết (nếu có): */
  for item in
  (
    SELECT 
      T1.v_STT,
      listagg(
        cast(
              nvl2(T3.HOTEN,decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ', ','')
            as varchar2(500)
            )
      )within group (order by T1.v_STT)as v_THUKY_DUKHUYET
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THUKYDUKHUYET'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_THUKY_DUKHUYET:=ITEM.v_THUKY_DUKHUYET;
  end loop;

  /* v_KIEMSATVIEN Kiểm sát viên*/
  for item in
  (
    SELECT 
      T1.v_STT,
      listagg(
        cast(
              nvl2(T3.HOTEN,decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ' kiểm sát viên' || CHR(10),'')
            as varchar2(500)
            )
      )within group (order by T1.v_STT) as v_KIEMSATVIEN
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='KSV'
  inner join DM_CANBOVKS T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_KIEMSATVIEN:=ITEM.v_KIEMSATVIEN;
  end loop;

  /* v_KIEMSATVIEN_DUKHUYET Kiểm sát viên dự khuyết*/
  /* v_NGUOITGTT Những người tham gia tố tụng */
  for item in
  (
    SELECT 
      T1.v_STT,
      listagg(
        cast(
              decode(T2.GIOITINH,1,'Ông ',2,'Bà ','') || T2.HOTEN || ', '
            as varchar2(500)
            )
      )within group (order by T1.v_STT) as v_NGUOITGTT
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_NGUOITHAMGIATOTUNG T2 on T1.v_VUANID=T2.VUANID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_NGUOITGTT:=ITEM.v_NGUOITGTT;
  end loop;

  END;
/* 16-HS */
PROCEDURE AHS_16
	(
		 in_VUANID IN NUMBER,
     in_MAGIAIDOAN IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	)
  AS
    v_ARRAY AHS_T_16;
    v_TOAANID number;
    v_DIACHI varchar(500);
    v_LOAITOA varchar(50);
    v_TENTOAAN_Templ varchar(500);
    v_TOACAPTREN number;
    v_GIAIDOAN varchar2(20);
  BEGIN
    select decode(in_MAGIAIDOAN,2,TOAANID,3,TOAPHUCTHAMID,0),decode(in_MAGIAIDOAN,2,'sơ thẩm',3,'phúc thẩm','') into v_TOAANID,v_GIAIDOAN from AHS_VUAN where ID=in_VUANID;
    -- Lấy địa điểm
    select LOAITOA,CAPCHAID,TEN,
      decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ','')) 
      into v_LOAITOA,v_TOACAPTREN,v_TENTOAAN_Templ,v_DIACHI
    from DM_TOAAN where ID=v_TOAANID;
    -- Lấy địa điểm với tòa cấp huyện
    if v_LOAITOA='CAPHUYEN' then
      select decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ','')) into v_DIACHI 
      from DM_TOAAN where ID=v_TOACAPTREN;
    end if;
    -- Lấy Tên tòa án
    if instr('CẤP CAO',v_TENTOAAN_Templ)>0 then
      select replace(v_TENTOAAN_Templ,'cấp cao','cấp cao'||chr(10)) into v_TENTOAAN_Templ from sys.dual;
    elsif instr('TỐI CAO',v_TENTOAAN_Templ)=0 then
      select replace(replace(v_TENTOAAN_Templ,'Tòa án nhân dân','Tòa án nhân dân'||chr(10)),',',chr(10)) into v_TENTOAAN_Templ from sys.dual;
    end if;
    if in_MAGIAIDOAN=2 -- Sơ thẩm
    then
    begin
      SELECT AHS_R_16(
          v_STT =>row_number() over (order by T2.ID),
          v_VUANID =>in_VUANID,
          v_TOAANID =>v_TOAANID,
          v_TENTOAAN_1_3 =>upper(v_TENTOAAN_Templ),
          v_SOQD_2 =>T2.SOQUYETDINH || '/' || to_char(T2.NGAYQD,'yyyy'),
          v_DIADIEM =>v_DIACHI || ', ngày '|| to_char(T2.NGAYQD,'dd') || ' tháng ' || to_char(T2.NGAYQD,'MM') || ' năm ' || to_char(T2.NGAYQD,'yyyy'),
          v_SOTHULY =>T4.SOTHULY||'/'||to_char(T4.NGAYTHULY,'yyyy')||'/TLST-HS ngày '||to_char(T4.NGAYTHULY,'dd')||' tháng '||to_char(T4.NGAYTHULY,'MM')||' năm '||to_char(T4.NGAYTHULY,'yyyy'),
          v_GIAIDOAN =>v_GIAIDOAN,
          v_CHANHAN =>NULL,
          v_TENCHANHAN =>NULL
        )
        BULK COLLECT INTO v_ARRAY
        FROM AHS_SOTHAM_QUYETDINH_VUAN T2
        INNER JOIN DM_QD_QUYETDINH T3 on T3.ID=T2.QUYETDINHID and T3.MA='16-HS'
        inner join AHS_SOTHAM_THULY T4 on T2.VUANID=T4.VUANID
        --inner join DM_CANBO T6 on T2.
        where T2.VUANID=in_VUANID;
      end;
      else
      begin
        SELECT AHS_R_16(
          v_STT =>row_number() over (order by T2.ID),
          v_VUANID =>in_VUANID,
          v_TOAANID =>v_TOAANID,
          v_TENTOAAN_1_3 =>upper(v_TENTOAAN_Templ),
          v_SOQD_2 =>T2.SOQUYETDINH || '/' || to_char(T2.NGAYQD,'yyyy'),
          v_DIADIEM =>v_DIACHI || ', ngày '|| to_char(T2.NGAYQD,'dd') || ' tháng ' || to_char(T2.NGAYQD,'MM') || ' năm ' || to_char(T2.NGAYQD,'yyyy'),
          v_SOTHULY =>T4.SOTHULY||'/'||to_char(T4.NGAYTHULY,'yyyy')||'/TLST-HS ngày '||to_char(T4.NGAYTHULY,'dd')||' tháng '||to_char(T4.NGAYTHULY,'MM')||' năm '||to_char(T4.NGAYTHULY,'yyyy'),
          v_GIAIDOAN =>v_GIAIDOAN,
          v_CHANHAN =>NULL,
          v_TENCHANHAN =>NULL
        )
        BULK COLLECT INTO v_ARRAY
        FROM AHS_SOTHAM_QUYETDINH_VUAN T2
        INNER JOIN DM_QD_QUYETDINH T3 on T3.ID=T2.QUYETDINHID and T3.MA='16-HS'
        inner join AHS_SOTHAM_THULY T4 on T2.VUANID=T4.VUANID
        --inner join DM_CANBO T6 on T2.
        where T2.VUANID=in_VUANID;
      end;
      end if;

      PKG_GSTP_REPORT_HS.AHS_FILL_16(v_ARRAY);
      OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);

      EXCEPTION 
      WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20000, sqlerrm);
  END;
  PROCEDURE AHS_FILL_16
	(
		v_ARRAY IN OUT AHS_T_16
	)
  AS
  BEGIN
  v_ARRAY:= AHS_T_16();
--    FOR ITEM IN (
--			SELECT 
--				T1.v_STT,
--        upper(decode(instr(lower(T4.TEN),'phó chánh án'),0,nvl(T4.TEN,''),nvl2(T4.TEN,'KT.CHÁNH ÁN'||CHR(10)||T4.TEN,''))) v_NGUOIPC_CHUCVU, 
--        T3.HOTEN v_NGUOIPC_TEN
--			FROM 
--				TABLE(v_ARRAY) T1 
--				INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID
--        INNER JOIN DM_CANBO T3 on T3.ID=T2.NGUOIPHANCONGID
--        LEFT JOIN DM_DATAITEM T4 on T4.ID=T3.CHUCVUID
--		) LOOP
--      v_ARRAY(ITEM.v_STT).v_NGUOIPC_CHUCVU:=ITEM.v_NGUOIPC_CHUCVU;
--      v_ARRAY(ITEM.v_STT).v_NGUOIPC_TEN:=ITEM.v_NGUOIPC_TEN;
--		END LOOP;
  END;
/* 21-HS*/
PROCEDURE AHS_21
	(
		 in_VUANID IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	)
  AS
    v_ARRAY AHS_T_21;
    v_TOAANID number;
    v_DIACHI varchar(500);
    v_LOAITOA varchar(50);
    v_TENTOAAN_Templ varchar(500);
    v_TOACAPTREN number;
  BEGIN
    select TOAPHUCTHAMID into v_TOAANID from AHS_VUAN where ID=in_VUANID;
    -- Lấy địa điểm
    select LOAITOA,CAPCHAID,TEN,
      decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ','')) 
      into v_LOAITOA,v_TOACAPTREN,v_TENTOAAN_Templ,v_DIACHI
    from DM_TOAAN where ID=v_TOAANID;
    -- Lấy địa điểm với tòa cấp huyện
    if v_LOAITOA='CAPHUYEN' then
      select decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ','')) into v_DIACHI 
      from DM_TOAAN where ID=v_TOACAPTREN;
    end if;
    -- Lấy Tên tòa án
    if instr('CẤP CAO',v_TENTOAAN_Templ)>0 then
      select replace(v_TENTOAAN_Templ,'cấp cao','cấp cao'||chr(10)) into v_TENTOAAN_Templ from sys.dual;
    elsif instr('TỐI CAO',v_TENTOAAN_Templ)=0 then
      select replace(replace(v_TENTOAAN_Templ,'Tòa án nhân dân','Tòa án nhân dân'||chr(10)),',',chr(10)) into v_TENTOAAN_Templ from sys.dual;
    end if;
    SELECT AHS_R_21(
        v_STT =>row_number() over (order by T2.ID),
        v_VUANID =>in_VUANID,
        v_TOAANID =>v_TOAANID,
        v_BICAODAUVUID =>T4.ID,
        v_TENTOAAN_1_3 =>upper(v_TENTOAAN_Templ),
        v_SOQD_2 =>T2.SOQUYETDINH || '/' || to_char(T2.NGAYQD,'yyyy'),
        v_DIADIEM =>v_DIACHI || ', ngày '|| to_char(T2.NGAYQD,'dd') || ' tháng ' || to_char(T2.NGAYQD,'MM') || ' năm ' || to_char(T2.NGAYQD,'yyyy'),
        v_SOTHULY =>NULL,
        v_CACBICAO_4 =>NULL,
        v_TEN_TOA_SOTHAM_5 =>NULL,
        v_TOIDANH_6 =>NULL,
        v_DIEU_KHOAN =>NULL,
        v_HINHPHAT_7 =>NULL,
        v_KHANGCAO_KHANGNGHI_8 =>NULL,
        v_VKS =>replace(v_TENTOAAN_Templ,'Tòa án','Viện kiểm sát'),
        v_TPCT =>NULL,
        v_TP_HDXX =>NULL,
        v_TP_DUKHUYET =>NULL,
        v_HTND =>NULL,
        v_HTND_DUKHUYET =>NULL,
        v_THUKY =>NULL,
        v_THUKY_DUKHUYET =>NULL,
        v_KIEMSATVIEN =>NULL,
        v_KIEMSATVIEN_DUKHUYET =>NULL,
        v_NGUOITGTT =>NULL,
        --Khải sửa thêm:
        v_SO_BANAN_ST =>T7.SOBANAN || '/' || to_char(T7.NGAYBANAN,'yyyy')|| '/HS-ST' || ', ngày '|| to_char(T7.NGAYBANAN,'dd') || ' tháng ' || to_char(T7.NGAYBANAN,'MM') || ' năm ' || to_char(T7.NGAYBANAN,'yyyy'),
        v_ISBICAN_BICAO =>NULL,
        v_BICAN_BICAO_TEN =>NULL,
        v_TPCT_TEN =>PC.HOTEN,
        v_NGAY_KC =>'Ngày '|| to_char(T8.NGAYKHANGCAO,'dd') || ' tháng ' || to_char(T8.NGAYKHANGCAO,'MM') || ' năm ' || to_char(T8.NGAYKHANGCAO,'yyyy'),
        v_NGUOI_KC =>DECODE(T12.ID, NULL, '', 'Ngày '|| to_char(T12.NGAYRUT,'dd') || ' tháng ' || to_char(T12.NGAYRUT,'MM') || ' năm ' || to_char(T12.NGAYRUT,'yyyy') || ', đã có văn bản về việc rút toàn bộ kháng nghị.'),
        v_NDKC =>DECODE(T8.NOIDUNGKHANGCAO, null, '', 'với nội dung ') || T8.NOIDUNGKHANGCAO,
        v_NGAYRUT_KC => DECODE(T10.ID, NULL, '', 'Ngày '|| to_char(T10.NGAYRUT,'dd') || ' tháng ' || to_char(T10.NGAYRUT,'MM') || ' năm ' || to_char(T10.NGAYRUT,'yyyy') || ', đã có văn bản về việc rút toàn bộ kháng cáo.'),
        v_XET_KC => DECODE(T10.ID, NULL, '', 'Xét thấy: Trước khi mở phiên toà phúc thẩm, người kháng cáo đã rút toàn bộ kháng cáo'),
        v_XET_KN => DECODE(T12.ID, NULL, '', 'Xét thấy: Trước khi mở phiên toà phúc thẩm, Viện kiểm sát kháng nghị đã rút toàn bộ kháng nghị')
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHS_PHUCTHAM_QUYETDINH_VUAN T2
      INNER JOIN DM_QD_QUYETDINH T3 on T3.ID=T2.QUYETDINHID --and T3.MA='21-HS'
      LEFT JOIN AHS_BICANBICAO T4 on T2.VUANID=T4.VUANID and T4.BICANDAUVU=1
      --Khải sửa thêm:
      LEFT JOIN AHS_PHUCTHAM_HDXX T6 on T6.VUANID=T2.VUANID and T6.MAVAITRO='THAMPHAN'
      LEFT JOIN DM_CANBO PC on PC.ID=T6.CANBOID
      LEFT JOIN AHS_SOTHAM_BANAN T7 on T7.VUANID=T2.VUANID
      LEFT JOIN AHS_SOTHAM_KHANGCAO T8 on T8.VUANID=T2.VUANID
      LEFT JOIN AHS_BICANBICAO T9 on T9.ID=T8.NGUOIKCID AND T8.LOAIKHANGCAO = 1
      INNER JOIN AHS_SOTHAM_RUTKHANGCAO T10 on T10.KHANGCAOID=T8.ID AND T10.TINHTRANG = 2
      LEFT JOIN AHS_SOTHAM_KHANGNGHI T11 ON T11.VUANID = T2.VUANID
      LEFT JOIN AHS_SOTHAM_RUTKHANGNGHI T12 ON T12.KHANGNGHIID = T11.ID AND T12.TINHTRANG = 2
      
      where T2.VUANID=in_VUANID;
      PKG_GSTP_REPORT_HS.AHS_FILL_21(v_ARRAY);
      -- v_ARRAY.DELETE;
      OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);

      EXCEPTION 
      WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20000, sqlerrm);
  END;
PROCEDURE AHS_FILL_21
	(
		v_ARRAY IN OUT AHS_T_21
	)
  AS
  t_VUANID number;
  t_BICANID number;
  BEGIN
    select T1.v_VUANID,T1.v_BICAODAUVUID into t_VUANID,t_BICANID from TABLE(v_ARRAY) T1 where rownum=1;
    --v_ARRAY:= AHS_T_21();
    /* v_SOTHULY Thông tin thụ lý (Số, ngày tháng năm)*/
  for item in
    (
      select 
        T1.v_STT,
        cast(
          T2.SOTHULY || '/' || to_char(T2.NGAYTHULY,'yyyy') || '/TLPT-HS'
          || ' ngày ' || to_char(T2.NGAYTHULY,'dd') || ' tháng ' || to_char(T2.NGAYTHULY,'MM') || ' năm ' || to_char(T2.NGAYTHULY,'yyyy') 
          as varchar2(200)) v_SOTHULY
      from table(v_ARRAY) T1
      inner join (select T3.VUANID,T3.SOTHULY,max(T3.NGAYTHULY) NGAYTHULY 
                  from AHS_PHUCTHAM_THULY T3 
                  where rownum<2 and T3.VUANID=t_VUANID
                  group by T3.VUANID,T3.SOTHULY
                ) T2 on T1.v_VUANID=T2.VUANID
    )loop 
     v_ARRAY(item.v_STT).v_SOTHULY:=item.v_SOTHULY;
    end loop;

  /* v_CACBICAO_4 Các bị cáo */
  for item in
    (
      select
        T1.v_STT,
        listagg(
          cast(
            decode(T2.LOAIDOITUONG,0,
              '- ' || T2.HOTEN || ', ngày sinh: ' || decode(to_char(T2.NGAYSINH,'dd/MM/yyyy')||' ',' ',to_char(T2.NGAYSINH,'dd/MM/yyyy'),cast(T2.NAMSINH as varchar(5))) 
              || nvl2(T2.KHTTCHITIET,CHR(10) || '   Nơi sinh: ' || T2.KHTTCHITIET,'')
              || nvl2(T3.TEN,CHR(10) || '   Nghề nghiệp: ' || T3.TEN,'')
              || nvl2(T2.TAMTRUCHITIET,CHR(10) || '   Nơi cư trú: ' || T2.TAMTRUCHITIET,'')
              || CHR(10)
              ,
              '- ' || T2.HOTEN
              || nvl2(T2.KHTTCHITIET,CHR(10) || '   Trụ sở chính tại: ' || T2.KHTTCHITIET,'')
              || nvl2(T2.TENKHAC,CHR(10) || '   Người đại diện: ' || T2.TENKHAC,'')
              || CHR(10)
              )
            as varchar2(4000)
          )
        ) within group (order by T1.v_STT) v_CACBICAO_4
      from table(v_ARRAY) T1
      inner join AHS_BICANBICAO T2 on T1.v_VUANID=T2.VUANID
      inner join AHS_PHUCTHAM_BICANBICAO T4 on T4.BICANID=T2.ID
      left join DM_DATAITEM T3 on T2.NGHENGHIEPID=T3.ID
      group by T1.v_STT
    ) loop
      v_ARRAY(item.v_STT).v_CACBICAO_4:=item.v_CACBICAO_4; 
    end loop;
    
    /* v_ISBICAN_BICAO Bị can hay bị cáo */
  /* v_BICAN_BICAO_TEN Tên bị can (bị cáo) */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
        nvl2(T5.VUANID,'bị can','bị cáo') v_ISBICAN_BICAO,
        nvl2(T6.SoBiCan,T2.HOTEN  || ' và các đồng phạm',T2.HOTEN) v_BICAN_BICAO_TEN
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID and T2.BICANDAUVU=1
        left join (select count(ID) SoBiCan from AHS_BICANBICAO where VUANID=t_VUANID) T6 on T1.v_VUANID=T2.VUANID and T6.SoBiCan>1
        LEFT JOIN (select T3.VUANID from AHS_SOTHAM_QUYETDINH_VUAN T3
                    inner join DM_QD_LOAI T4 on T4.ID=T3.LOAIQDID and T4.HIEULUC=1 and T4.MA='DVARXX'
                    ) T5 on T5.VUANID=T1.v_VUANID
		) LOOP
      v_ARRAY(ITEM.v_STT).v_ISBICAN_BICAO:=ITEM.v_ISBICAN_BICAO;
      v_ARRAY(ITEM.v_STT).v_BICAN_BICAO_TEN:=ITEM.v_BICAN_BICAO_TEN;
		END LOOP;

  /* v_TEN_TOA_SOTHAM_5 Tên Tòa sơ thẩm */
  for item in
  (
    select
      T1.v_STT,
      T4.TEN v_TEN_TOA_SOTHAM_5
    from table(v_ARRAY) T1
    left join (select T2.TOAANID,T2.VUANID,T3.TEN from AHS_SOTHAM_BANAN T2
                    inner join DM_TOAAN T3 on T2.TOAANID=T3.ID
                   ) T4 ON T1.v_VUANID=T4.VUANID
  )loop
    v_ARRAY(item.v_STT).v_TEN_TOA_SOTHAM_5:=item.v_TEN_TOA_SOTHAM_5;
  end loop;

  /* v_TOIDANH_6 Tội danh */
  FOR ITEM IN (
			SELECT 
				T1.v_STT,
         LISTAGG(
                cast(T5.ToiDanh as varchar2(4000))
                ,'; '
                ) WITHIN GROUP (ORDER BY T1.v_STT) v_TOIDANH_6
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN (select distinct T2.VUANID,
                          NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                    from AHS_BICANBICAO T2
                    INNER JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET T3 ON T3.BICANID=T2.ID
                    inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                    where T2.BICANDAUVU=1
                    )T5 on T5.VUANID=T1.v_VUANID
          group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TOIDANH_6:=ITEM.v_TOIDANH_6;
		END LOOP;

  /* v_DIEU_KHOAN Điều khoản */
  FOR ITEM IN (
  SELECT 
      T1.v_STT,
      T5.DIEUKHOAN v_DIEU_KHOAN
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN (select 
                T2.VUANID,T2.DIEU,
                LISTAGG(
                  cast(
                    replace(nvl2(T2.DIEM,'Điểm ' || T2.DIEM,'') || ' Khoản ' || T2.KHOAN || ' Điều ' || T2.DIEU,', Khoản',' Khoản')
                  as varchar2(4000)
                  )||'; '
                )within group (order by T2.VUANID,T2.DIEU) as DIEUKHOAN
              from
              (
                select
                  VUANID,c.DIEU,c.KHOAN,
                  LISTAGG(
                    cast(
                     regexp_replace(nvl2(c.DIEM,'Điểm ' || c.DIEM || ',',''),'Điểm ,|Điểm ','')
                    as varchar2(4000)
                    )
                  )within group (order by VUANID,c.DIEU,c.KHOAN) as DIEM
                  from  AHS_SOTHAM_BANAN_DIEU_CHITIET a 
                  inner join DM_BOLUAT_TOIDANH c on a.ToiDanhID = c.ID and c.HIEULUC=1
                  where a.BICANID=t_BICANID and a.VUANID=t_VUANID
                  group by VUANID,c.DIEU,c.KHOAN
                ) T2
                where T2.DIEU is not null and T2.KHOAN is not null
                group by T2.VUANID,T2.DIEU
              )T5 on T5.VUANID=T1.v_VUANID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_DIEU_KHOAN:=ITEM.v_DIEU_KHOAN;
  END LOOP;

  /* v_HINHPHAT_7 Hình phạt*/
  FOR ITEM IN (
			SELECT
        T1.v_STT,
        T2.HinhPhat v_HINHPHAT_7
			FROM 
				TABLE(v_ARRAY) T1
        inner join (
                     select T9.VUANID,
                        LISTAGG(
                                cast(T7.TENHINHPHAT || 
                                      decode(T8.LOAIHINHPHAT,2,cast(T8.TG_NAM as varchar(5)) || ' năm ' || cast(T8.TG_THANG as varchar(5)) || ' tháng ' || cast(T8.TG_NGAY as varchar(5)) || ' ngày' || decode(T8.ISANTREO,1,' hưởng án treo','')
                                              ,3,replace(to_char(T8.SH_VALUE,'999,999,999,999,999,999'),',','.') || ' VNĐ'
                                              ,'')
                                      as varchar2(4000))
                                , '; '
                                ) WITHIN GROUP (ORDER BY T9.VUANID) HinhPhat
                     from AHS_BICANBICAO T9
                     INNER JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET T8 ON T8.BICANID=T9.ID
                     left join DM_HINHPHAT T7 on T8.HINHPHATID=T7.ID
                     where T9.BICANDAUVU=1
                     group by T9.VUANID
                    ) T2 on T2.VUANID=T1.v_VUANID
      )LOOP
			v_ARRAY(ITEM.v_STT).v_HINHPHAT_7:=ITEM.v_HINHPHAT_7;
		END LOOP;

  /* v_KHANGCAO_KHANGNGHI_8 Kháng cáo, kháng nghị */
  for item in
  (
    select distinct
      T1.v_STT,
      T2.KhangCao || 'có đơn kháng cáo đối với Bản án số ' || T9.SOBANAN || '/' || to_char(T9.NGAYBANAN,'yyyy')|| '/HS-ST' || ', ngày '|| to_char(T9.NGAYBANAN,'dd') || ' tháng ' || to_char(T9.NGAYBANAN,'MM') || ' năm ' || to_char(T9.NGAYBANAN,'yyyy') || decode(T3.CAPKN,0,chr(10) || 'Và quyết định kháng nghị cùng cấp',1,chr(10) || 'Và quyết định kháng nghị cấp trên','') || DECODE(T3.VUANID, NULL, '', ' số ' || T3.SOKN || ' ngày '|| to_char(T3.NGAYKN,'dd') || ' tháng ' || to_char(T3.NGAYKN,'MM') || ' năm ' || to_char(T3.NGAYKN,'yyyy')) v_KHANGCAO_KHANGNGHI_8
    from table(v_ARRAY) T1
    left join (select T4.VUANID,
                  listagg(
                    cast(
                        DECODE(T5.HOTEN, NULL, '', DECODE(T5.BICANDAUVU, 1, 'Bị cáo đầu vụ ', 'Bị cáo ') || T5.HOTEN || '; ') || DECODE(T6.HOTEN, NULL, '', T8.TEN || ' ' || T6.HOTEN || '; ')
                        as varchar2(500)
                        )
                  )within group (order by T4.VUANID) as KhangCao
                from AHS_SOTHAM_KHANGCAO T4
                left join AHS_BICANBICAO T5 on T5.ID=T4.NGUOIKCID AND T4.NGUOIKCLOAI=0
                --Start Khai
                LEFT JOIN AHS_NGUOITHAMGIATOTUNG T6 ON T6.ID = T4.NGUOIKCID AND T4.NGUOIKCLOAI=1
                LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH T7 ON T7.NGUOIID = T6.ID
                LEFT JOIN DM_DATAITEM T8 ON T8.ID = T7.TUCACHID
                --End Khai
                group by T4.VUANID
                ) T2 on T2.VUANID=T1.v_VUANID
    left join AHS_SOTHAM_KHANGNGHI T3 on T3.VUANID=T1.v_VUANID
    LEFT JOIN AHS_SOTHAM_BANAN T9 on T9.VUANID=T1.v_VUANID
  )loop
    v_ARRAY(ITEM.v_STT).v_KHANGCAO_KHANGNGHI_8:=ITEM.v_KHANGCAO_KHANGNGHI_8;
  end loop;

  /* v_TPCT Thẩm phán chủ tọa */
  for item in
  (
    SELECT 
      T1.v_STT,
      decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN v_TPCT
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THAMPHAN'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  )loop
    v_ARRAY(ITEM.v_STT).v_TPCT:=ITEM.v_TPCT;
  end loop;

  /* v_TP_HDXX Thẩm phán (nếu Hội đồng xét xử sơ thẩm gồm có 5 người) */
  for item in
  (
    SELECT 
      T1.v_STT,
      ListAGG(
        cast(
          nvl2(T3.HOTEN,decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ', ','')
          as varchar2(500)
          )
      )within group (order by T1.v_STT) as v_TP_HDXX
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THAMPHANHDXX'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_TP_HDXX:=ITEM.v_TP_HDXX;
  end loop;

  /* v_TP_DUKHUYET Thẩm phán dự khuyết (nếu có) */
  for item in
  (
    SELECT 
      T1.v_STT,
      listagg(
        cast(
            nvl2(T3.HOTEN,'' || decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ', ','')
            as varchar2(500)
            )
      )within group (order by T1.v_STT) as v_TP_DUKHUYET
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THAMPHANDUKHUYET'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_TP_DUKHUYET:=ITEM.v_TP_DUKHUYET;
  end loop;

  /* v_HTND Các Hội thẩm nhân dân (quân nhân) */
  for item in
  (
    SELECT 
      T1.v_STT,
      listagg(
        cast(
          nvl2(T3.HOTEN,decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ', ','')
          as varchar2(500)
          )
      )within group (order by T1.v_STT) as v_HTND
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='HTND'
  inner join DM_CANBOVKS T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_HTND:=ITEM.v_HTND;
  end loop;

  /* v_HTND_DUKHUYET Hội thẩm nhân dân (quân nhân) dự khuyết (nếu có) */
  /* v_THUKY Thư ký phiên tòa */
  for item in
  (
    SELECT 
      T1.v_STT,
      listagg(
        cast(
            nvl2(T3.HOTEN,decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ', ','')
            as varchar2(500)
            )
      )within group (order by T1.v_STT)as v_THUKY
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THUKY'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_THUKY:=ITEM.v_THUKY;
  end loop;

  /* v_THUKY_DUKHUYET Thư ký phiên tòa dự khuyết (nếu có): */
  for item in
  (
    SELECT 
      T1.v_STT,
      listagg(
        cast(
              nvl2(T3.HOTEN,decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ', ','')
            as varchar2(500)
            )
      )within group (order by T1.v_STT)as v_THUKY_DUKHUYET
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THUKYDUKHUYET'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_THUKY_DUKHUYET:=ITEM.v_THUKY_DUKHUYET;
  end loop;

  /* v_KIEMSATVIEN Kiểm sát viên*/
  for item in
  (
    SELECT 
      T1.v_STT,
      listagg(
        cast(
              nvl2(T3.HOTEN,decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ' kiểm sát viên' || CHR(10),'')
            as varchar2(500)
            )
      )within group (order by T1.v_STT) as v_KIEMSATVIEN
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='KSV'
  inner join DM_CANBOVKS T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_KIEMSATVIEN:=ITEM.v_KIEMSATVIEN;
  end loop;

  /* v_KIEMSATVIEN_DUKHUYET Kiểm sát viên dự khuyết*/
  /* v_NGUOITGTT Những người tham gia tố tụng */
  for item in
  (
    SELECT 
      T1.v_STT,
      listagg(
        cast(
              decode(T2.GIOITINH,1,'Ông ',2,'Bà ','') || T2.HOTEN || ', '
            as varchar2(500)
            )
      )within group (order by T1.v_STT) as v_NGUOITGTT
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_NGUOITHAMGIATOTUNG T2 on T1.v_VUANID=T2.VUANID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_NGUOITGTT:=ITEM.v_NGUOITGTT;
  end loop;

  END;

 /* 36_HS*/ 
  PROCEDURE AHS_36
	(
		 in_VUANID IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	)
  AS
    v_ARRAY AHS_T_36;
    v_TOAANID number;
    v_DIACHI varchar(500);
    v_LOAITOA varchar(50);
    v_TENTOAAN_Templ varchar(500);
    v_TOACAPTREN number;
  BEGIN
    select TOAANID into v_TOAANID from AHS_VUAN where ID=in_VUANID;
    -- Lấy địa điểm
    select LOAITOA,CAPCHAID,TEN,
      decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ','')) 
      into v_LOAITOA,v_TOACAPTREN,v_TENTOAAN_Templ,v_DIACHI
    from DM_TOAAN where ID=v_TOAANID;
    -- Lấy địa điểm với tòa cấp huyện
    if v_LOAITOA='CAPHUYEN' then
      select decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ','')) into v_DIACHI 
      from DM_TOAAN where ID=v_TOACAPTREN;
    end if;
    -- Lấy Tên tòa án
    if instr('CẤP CAO',v_TENTOAAN_Templ)>0 then
      select replace(v_TENTOAAN_Templ,'cấp cao','cấp cao'||chr(10)) into v_TENTOAAN_Templ from sys.dual;
    elsif instr('TỐI CAO',v_TENTOAAN_Templ)=0 then
      select replace(replace(v_TENTOAAN_Templ,'Tòa án nhân dân','Tòa án nhân dân'||chr(10)),',',chr(10)) into v_TENTOAAN_Templ from sys.dual;
    end if;
    SELECT AHS_R_36(
        v_STT =>row_number() over (order by T2.ID),
        v_VUANID =>in_VUANID,
        v_TOAANID =>v_TOAANID,
        v_BICAODAUVUID=>T6.ID,
        v_TENTOAAN_1_3 =>upper(v_TENTOAAN_Templ),
        v_SOQD_2 =>T2.SOQUYETDINH || '/' || to_char(T2.NGAYQD,'yyyy'),
        v_DIADIEM =>v_DIACHI || ', ngày '|| to_char(T2.NGAYQD,'dd') || ' tháng ' || to_char(T2.NGAYQD,'MM') || ' năm ' || to_char(T2.NGAYQD,'yyyy'),
        v_SOTHULY =>T4.SOTHULY || '/' || to_char(T4.NGAYTHULY,'yyyy') || '/TLST-HS ngày '||to_char(T4.NGAYTHULY,'dd')||' tháng '||to_char(T4.NGAYTHULY,'MM')||' năm '||to_char(T4.NGAYTHULY,'yyyy'),
        v_LYDO_4 =>T5.TEN,
        v_CACBICAO_5 =>NULL,
        v_VKS_TEN_6 =>replace(v_TENTOAAN_Templ,'Tòa án','Viện kiểm sát'),
        v_TOIDANH_7 =>NULL,
        v_DIEU_KHOAN =>NULL,
        v_THAMPHAN =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHS_SOTHAM_QUYETDINH_VUAN T2
      INNER JOIN DM_QD_QUYETDINH T3 on T3.ID=T2.QUYETDINHID and T3.MA='36-HS'
      INNER JOIN AHS_SOTHAM_THULY T4 on T4.VUANID=T2.VUANID
      LEFT JOIN DM_QD_QUYETDINH_LYDO T5 on T3.ID=T5.QDID and T5.HIEULUC=1
      LEFT JOIN AHS_BICANBICAO T6 on T2.VUANID=T6.VUANID and T6.BICANDAUVU=1
      where T2.VUANID=in_VUANID;

      PKG_GSTP_REPORT_HS.AHS_FILL_36(v_ARRAY);
      -- v_ARRAY.DELETE;
      OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);

      EXCEPTION 
      WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20000, sqlerrm);
  END;
  PROCEDURE AHS_FILL_36
	(
		v_ARRAY IN OUT AHS_T_36
	)
  AS
  t_VUANID number;
  t_BICANID number;
  BEGIN
    select T1.v_VUANID,T1.v_BICAODAUVUID into t_VUANID,t_BICANID from TABLE(v_ARRAY) T1 where rownum=1;
    --v_ARRAY:= AHS_T_36();
    /* v_CACBICAO_5 Các bị cáo */
    for item in
    (
      select
        T1.v_STT,
        listagg(
          cast(
              decode(T2.LOAIDOITUONG,0,
                T2.HOTEN || ', ngày sinh: ' || decode(to_char(T2.NGAYSINH,'dd/MM/yyyy')||' ',' ',to_char(T2.NGAYSINH,'dd/MM/yyyy'),cast(T2.NAMSINH as varchar(5))) 
                || nvl2(T2.KHTTCHITIET,CHR(10) || 'Nơi sinh: ' || T2.KHTTCHITIET,'')
                || nvl2(T3.TEN,CHR(10) || 'Nghề nghiệp: ' || T3.TEN,'')
                || nvl2(T2.TAMTRUCHITIET,CHR(10) || 'Nơi cư trú: ' || T2.TAMTRUCHITIET,'')
                || CHR(10)
                ,
                T2.HOTEN
                || nvl2(T2.KHTTCHITIET,CHR(10) || 'Trụ sở chính tại: ' || T2.KHTTCHITIET,'')
                || nvl2(T2.TENKHAC,CHR(10) || 'Người đại diện: ' || T2.TENKHAC,'')
                || CHR(10)
                )
                ||
                decode(T2.SOBICAN,1,'','và đồng phạm')
            as varchar2(4000)
          )
        ) within group (order by T1.v_STT) v_CACBICAO_5
      from table(v_ARRAY) T1
      inner join (select T4.*,(select count(ID) from AHS_BICANBICAO where VUANID=287) SOBICAN from AHS_BICANBICAO T4
                  where T4.VUANID=t_VUANID and T4.BICANDAUVU=1
                  ) T2 on T1.v_VUANID=T2.VUANID
      left join DM_DATAITEM T3 on T2.NGHENGHIEPID=T3.ID
      group by T1.v_STT
    ) loop
      v_ARRAY(item.v_STT).v_CACBICAO_5:=item.v_CACBICAO_5; 
    end loop;
    /* v_TOIDANH_7 Tội danh */
    FOR ITEM IN (
			SELECT 
				T1.v_STT,
         LISTAGG(
                cast(T5.ToiDanh as varchar2(4000))
                ,'; '
                ) WITHIN GROUP (ORDER BY T1.v_STT) v_TOIDANH_7
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN (select distinct T2.VUANID,
                          NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                    from AHS_BICANBICAO T2
                    INNER JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT T3 ON T3.BICANID=T2.ID
                    inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                    where T2.BICANDAUVU=1
                    )T5 on T5.VUANID=T1.v_VUANID
          group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TOIDANH_7:=ITEM.v_TOIDANH_7;
  END LOOP;

  /* v_DIEU_KHOAN Điều khoản */
  FOR ITEM IN (
  SELECT 
      T1.v_STT,
      T5.DIEUKHOAN v_DIEU_KHOAN
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN (select 
                T2.VUANID,T2.DIEU,
                LISTAGG(
                  cast(
                    replace(nvl2(T2.DIEM,'Điểm ' || T2.DIEM,'') || ' Khoản ' || T2.KHOAN || ' Điều ' || T2.DIEU,', Khoản',' Khoản')
                  as varchar2(4000)
                  )||'; '
                )within group (order by T2.VUANID,T2.DIEU) as DIEUKHOAN
              from
              (
                select
                  VUANID,c.DIEU,c.KHOAN,
                  LISTAGG(
                    cast(
                     regexp_replace(nvl2(c.DIEM,'Điểm ' || c.DIEM || ',',''),'Điểm ,|Điểm ','')
                    as varchar2(4000)
                    )
                  )within group (order by VUANID,c.DIEU,c.KHOAN) as DIEM
                  from  AHS_SOTHAM_CAOTRANG_DIEULUAT a 
                  inner join DM_BOLUAT_TOIDANH c on a.ToiDanhID = c.ID and c.HIEULUC=1
                  where a.BICANID=t_BICANID and a.VUANID=t_VUANID
                  group by VUANID,c.DIEU,c.KHOAN
                ) T2
                where T2.DIEU is not null and T2.KHOAN is not null
                group by T2.VUANID,T2.DIEU
              )T5 on T5.VUANID=T1.v_VUANID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_DIEU_KHOAN:=ITEM.v_DIEU_KHOAN;
  END LOOP;

    /* v_THAMPHAN Thẩm phán */
    for item in
  (
    SELECT 
      T1.v_STT,
      decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN v_THAMPHAN
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THAMPHAN'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  )loop
    v_ARRAY(ITEM.v_STT).v_THAMPHAN:=ITEM.v_THAMPHAN;
  end loop;

  END;

 /* 37_HS*/ 
  PROCEDURE AHS_37
	(
		 in_VUANID IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	)
  AS
    v_ARRAY AHS_T_37;
    v_TOAANID number;
    v_DIACHI varchar(500);
    v_LOAITOA varchar(50);
    v_TENTOAAN_Templ varchar(500);
    v_TOACAPTREN number;
  BEGIN
    select TOAANID into v_TOAANID from AHS_VUAN where ID=in_VUANID;
    -- Lấy địa điểm
    select LOAITOA,CAPCHAID,TEN,
      decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại |cấp cao ','')) 
      into v_LOAITOA,v_TOACAPTREN,v_TENTOAAN_Templ,v_DIACHI
    from DM_TOAAN where ID=v_TOAANID;
    -- Lấy địa điểm với tòa cấp huyện
    if v_LOAITOA='CAPHUYEN' then
      select decode(regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ',''),'Hồ Chí Minh','TP. Hồ Chí Minh',regexp_replace(TEN,'Tòa án nhân dân |tỉnh |Tỉnh |thành phố |Thành phố |tại |Tại ','')) into v_DIACHI 
      from DM_TOAAN where ID=v_TOACAPTREN;
    end if;
    -- Lấy Tên tòa án
    if instr('CẤP CAO',v_TENTOAAN_Templ)>0 then
      select replace(v_TENTOAAN_Templ,'cấp cao','cấp cao'||chr(10)) into v_TENTOAAN_Templ from sys.dual;
    elsif instr('TỐI CAO',v_TENTOAAN_Templ)=0 then
      select replace(replace(v_TENTOAAN_Templ,'Tòa án nhân dân','Tòa án nhân dân'||chr(10)),',',chr(10)) into v_TENTOAAN_Templ from sys.dual;
    end if;
    SELECT AHS_R_37(
        v_STT =>row_number() over (order by T2.ID),
        v_VUANID =>in_VUANID,
        v_TOAANID =>v_TOAANID,
        v_BICAODAUVUID=>T6.ID,
        v_TENTOAAN_1_3 =>upper(v_TENTOAAN_Templ),
        v_SOQD_2 =>T2.SOQUYETDINH || '/' || to_char(T2.NGAYQD,'yyyy'),
        v_DIADIEM =>v_DIACHI || ', ngày '|| to_char(T2.NGAYQD,'dd') || ' tháng ' || to_char(T2.NGAYQD,'MM') || ' năm ' || to_char(T2.NGAYQD,'yyyy'),
        v_SOTHULY =>T4.SOTHULY || '/' || to_char(T4.NGAYTHULY,'yyyy') || '/TLST-HS ngày '||to_char(T4.NGAYTHULY,'dd')||' tháng '||to_char(T4.NGAYTHULY,'MM')||' năm '||to_char(T4.NGAYTHULY,'yyyy'),
        v_TPCT =>NULL,
        v_TP_HDXX =>NULL,
        v_HTND =>NULL,
        v_LYDO_5 =>T5.TEN,
        v_CACBICAO_6 =>NULL,
        v_VKS_TEN_7 =>replace(v_TENTOAAN_Templ,'Tòa án','Viện kiểm sát'),
        v_TOIDANH_8 =>NULL,
        v_DIEU_KHOAN =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHS_SOTHAM_QUYETDINH_VUAN T2
      INNER JOIN DM_QD_QUYETDINH T3 on T3.ID=T2.QUYETDINHID and T3.MA='36-HS'
      INNER JOIN AHS_SOTHAM_THULY T4 on T4.VUANID=T2.VUANID
      LEFT JOIN DM_QD_QUYETDINH_LYDO T5 on T3.ID=T5.QDID and T5.HIEULUC=1
      LEFT JOIN AHS_BICANBICAO T6 on T2.VUANID=T6.VUANID and T6.BICANDAUVU=1
      where T2.VUANID=in_VUANID;

      PKG_GSTP_REPORT_HS.AHS_FILL_37(v_ARRAY);
      -- v_ARRAY.DELETE;
      OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);

      EXCEPTION 
      WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20000, sqlerrm);
  END;
  PROCEDURE AHS_FILL_37
	(
		v_ARRAY IN OUT AHS_T_37
	)
  AS
  t_VUANID number;
  t_BICANID number;
  BEGIN
    select T1.v_VUANID,T1.v_BICAODAUVUID into t_VUANID,t_BICANID from TABLE(v_ARRAY) T1 where rownum=1;
    --v_ARRAY:= AHS_T_37();
    /* v_TPCT Thẩm phán - Chủ tọa phiên tòa */
    for item in
    (
      SELECT 
        T1.v_STT,
        decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN v_TPCT
    FROM
    TABLE(v_ARRAY) T1
    INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THAMPHAN'
    inner join DM_CANBO T3 on T2.CANBOID=T3.ID
    )loop
      v_ARRAY(ITEM.v_STT).v_TPCT:=ITEM.v_TPCT;
    end loop;

    /* v_TP_HDXX Thẩm phán HĐXX */
    for item in
  (
    SELECT 
      T1.v_STT,
      ListAGG(
        cast(
          nvl2(T3.HOTEN,decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ', ','')
          as varchar2(500)
          )
      )within group (order by T1.v_STT) as v_TP_HDXX
  FROM
  TABLE(v_ARRAY) T1
  INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='THAMPHANHDXX'
  inner join DM_CANBO T3 on T2.CANBOID=T3.ID
  group by T1.v_STT
  )loop
    v_ARRAY(ITEM.v_STT).v_TP_HDXX:=ITEM.v_TP_HDXX;
  end loop;

    /* v_HTND Các Hội thẩm nhân dân */
    for item in
    (
      SELECT 
        T1.v_STT,
        listagg(
          cast(
            nvl2(T3.HOTEN,decode(T3.GIOITINH,1,'Ông ',2,'Bà ','') || T3.HOTEN || ', ','')
            as varchar2(500)
            )
        )within group (order by T1.v_STT) as v_HTND
    FROM
    TABLE(v_ARRAY) T1
    INNER JOIN AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID and T2.MAVAITRO='HTND'
    inner join DM_CANBOVKS T3 on T2.CANBOID=T3.ID
    group by T1.v_STT
    )loop
      v_ARRAY(ITEM.v_STT).v_HTND:=ITEM.v_HTND;
    end loop;

    /* v_CACBICAO_6 Các bị cáo */
    for item in
    (
      select
        T1.v_STT,
        listagg(
          cast(
              decode(T2.LOAIDOITUONG,0,
                T2.HOTEN || ', ngày sinh: ' || decode(to_char(T2.NGAYSINH,'dd/MM/yyyy')||' ',' ',to_char(T2.NGAYSINH,'dd/MM/yyyy'),cast(T2.NAMSINH as varchar(5))) 
                || nvl2(T2.KHTTCHITIET,CHR(10) || 'Nơi sinh: ' || T2.KHTTCHITIET,'')
                || nvl2(T3.TEN,CHR(10) || 'Nghề nghiệp: ' || T3.TEN,'')
                || nvl2(T2.TAMTRUCHITIET,CHR(10) || 'Nơi cư trú: ' || T2.TAMTRUCHITIET,'')
                || CHR(10)
                ,
                T2.HOTEN
                || nvl2(T2.KHTTCHITIET,CHR(10) || 'Trụ sở chính tại: ' || T2.KHTTCHITIET,'')
                || nvl2(T2.TENKHAC,CHR(10) || 'Người đại diện: ' || T2.TENKHAC,'')
                || CHR(10)
                )
                ||
                decode(T2.SOBICAN,1,'','và đồng phạm')
            as varchar2(4000)
          )
        ) within group (order by T1.v_STT) v_CACBICAO_6
      from table(v_ARRAY) T1
      inner join (select T4.*,(select count(ID) from AHS_BICANBICAO where VUANID=287) SOBICAN from AHS_BICANBICAO T4
                  where T4.VUANID=t_VUANID and T4.BICANDAUVU=1
                  ) T2 on T1.v_VUANID=T2.VUANID
      left join DM_DATAITEM T3 on T2.NGHENGHIEPID=T3.ID
      group by T1.v_STT
    ) loop
      v_ARRAY(item.v_STT).v_CACBICAO_6:=item.v_CACBICAO_6; 
    end loop;

    /* v_TOIDANH_8 Tội danh */
    FOR ITEM IN (
			SELECT 
				T1.v_STT,
         LISTAGG(
                cast(T5.ToiDanh as varchar2(4000))
                ,'; '
                ) WITHIN GROUP (ORDER BY T1.v_STT) v_TOIDANH_8
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN (select distinct T2.VUANID,
                          NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                    from AHS_BICANBICAO T2
                    INNER JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT T3 ON T3.BICANID=T2.ID
                    inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                    where T2.BICANDAUVU=1
                    )T5 on T5.VUANID=T1.v_VUANID
          group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TOIDANH_8:=ITEM.v_TOIDANH_8;
    END LOOP;

  /* v_DIEU_KHOAN Điều khoản */
    FOR ITEM IN (
    SELECT 
        T1.v_STT,
        T5.DIEUKHOAN v_DIEU_KHOAN
    FROM
    TABLE(v_ARRAY) T1
    INNER JOIN (select 
                  T2.VUANID,T2.DIEU,
                  LISTAGG(
                    cast(
                      replace(nvl2(T2.DIEM,'Điểm ' || T2.DIEM,'') || ' Khoản ' || T2.KHOAN || ' Điều ' || T2.DIEU,', Khoản',' Khoản')
                    as varchar2(4000)
                    )||'; '
                  )within group (order by T2.VUANID,T2.DIEU) as DIEUKHOAN
                from
                (
                  select
                    VUANID,c.DIEU,c.KHOAN,
                    LISTAGG(
                      cast(
                       regexp_replace(nvl2(c.DIEM,'Điểm ' || c.DIEM || ',',''),'Điểm ,|Điểm ','')
                      as varchar2(4000)
                      )
                    )within group (order by VUANID,c.DIEU,c.KHOAN) as DIEM
                    from  AHS_SOTHAM_CAOTRANG_DIEULUAT a 
                    inner join DM_BOLUAT_TOIDANH c on a.ToiDanhID = c.ID and c.HIEULUC=1
                    where a.BICANID=t_BICANID and a.VUANID=t_VUANID
                    group by VUANID,c.DIEU,c.KHOAN
                  ) T2
                  where T2.DIEU is not null and T2.KHOAN is not null
                  group by T2.VUANID,T2.DIEU
                )T5 on T5.VUANID=T1.v_VUANID
      ) LOOP
        v_ARRAY(ITEM.v_STT).v_DIEU_KHOAN:=ITEM.v_DIEU_KHOAN;
    END LOOP;  
  END;

/* -------------------------------------------------------------------------------------- */
PROCEDURE AHS_REPORT_BM01
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN
    select ad.MaGiaiDoan into vMaGiaiDoan from AHS_VUAN ad where ad.ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
          select don.ID, don.TENVUAN, qd_phuctham.SOQUYETDINH SOQD, replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
                  , thamphan_phuctham.HOTEN TENTHAMPHAN, thamphan_phuctham.TEN CHUCVUTHAMPHAN
                  , SoTL_phuctham.SOTHULY, 'phúc thẩm' GIAIDOAN
                  , (case when don.SOBICAN=1 then bicao.HOTEN
                                else ( bicao.HOTEN || ' và các đồng phạm') end) HOTENBICAO

                from AHS_VUAN don 
                inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
                left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID
                                          , phuctham_QD.VUANID, phuctham_QD.SOQUYETDINH from AHS_PHUCTHAM_QUYETDINH_VUAN phuctham_QD
                                          inner join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                                          where DM_QD.MA='1-HS' and phuctham_QD.VUANID=vDonID) where STT<=1
                          ) qd_phuctham on don.ID = qd_phuctham.VUANID
                inner join (select tpgq_phuctham.ID, tpgq_phuctham.VUANID, chucvu.TEN
                                  , DECODE(NVL(dm_canbo.GIOITINH,0) ,0, ('Bà ' || dm_canbo.HOTEN),1, ('Ông ' || dm_canbo.HOTEN)) HOTEN
                                  from AHS_THAMPHANGIAIQUYET tpgq_phuctham 
                                  inner join (select ID, GIOITINH, HOTEN, CHUCVUID from DM_CANBO) dm_canbo on dm_canbo.ID=tpgq_phuctham.CANBOID
                                  left join (select ID, TEN from DM_DATAITEM) chucvu on chucvu.ID=dm_canbo.CHUCVUID
                                  where tpgq_phuctham.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' and tpgq_phuctham.VUANID=vDonID
                            )thamphan_phuctham on thamphan_phuctham.VUANID=don.ID
                left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                              , VUANID, SOTHULY from AHS_PHUCTHAM_THULY where VUANID=vDonID) where STT<=1
                            ) SoTL_phuctham on don.ID = SoTL_phuctham.VUANID
                left join (select ID, VUANID, HOTEN
                           from AHS_BICANBICAO where VUANID=vDonID and BICANDAUVU=1
                          ) bicao  on bicao.VUANID=vDonID
                where don.ID=vDonID;
        ELSE
            open curReturn for
            select don.ID, don.TENVUAN, qd_sotham.SOQUYETDINH SOQD, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
                , thamphan_sotham.HOTEN TENTHAMPHAN, thamphan_sotham.TEN CHUCVUTHAMPHAN
                , SoTL_sotham.SOTHULY, 'sơ thẩm' GIAIDOAN
                , (case when don.SOBICAN=1 then bicao.HOTEN
                              else ( bicao.HOTEN || ' và các đồng phạm') end) HOTENBICAO

              from AHS_VUAN don 
              inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
              left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID
                                        , sotham_QD.VUANID, sotham_QD.SOQUYETDINH from AHS_SOTHAM_QUYETDINH_VUAN sotham_QD
                                        inner join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                                        where DM_QD.MA='1-HS' and sotham_QD.VUANID=vDonID) where STT<=1
                        ) qd_sotham on don.ID = qd_sotham.VUANID
              inner join (select tpgq_sotham.ID, tpgq_sotham.VUANID, chucvu.TEN 
                                , DECODE(NVL(dm_canbo.GIOITINH,0) ,0, ('Bà ' || dm_canbo.HOTEN),1, ('Ông ' || dm_canbo.HOTEN)) HOTEN
                                from AHS_THAMPHANGIAIQUYET tpgq_sotham 
                                inner join (select ID, GIOITINH, HOTEN, CHUCVUID from DM_CANBO) dm_canbo on dm_canbo.ID=tpgq_sotham.CANBOID
                                left join (select ID, TEN from DM_DATAITEM) chucvu on chucvu.ID=dm_canbo.CHUCVUID
                                where tpgq_sotham.MAVAITRO='VTTP_GIAIQUYETSOTHAM' and tpgq_sotham.VUANID=vDonID
                          )thamphan_sotham on thamphan_sotham.VUANID=don.ID
              left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                            , VUANID, SOTHULY from AHS_SOTHAM_THULY where VUANID=vDonID) where STT<=1
                          ) SoTL_sotham on don.ID = SoTL_sotham.VUANID
              left join (select ID, VUANID, HOTEN
                         from AHS_BICANBICAO where VUANID=vDonID and BICANDAUVU=1
                        ) bicao  on bicao.VUANID=vDonID
              where don.ID=vDonID;
          END IF;
  END AHS_REPORT_BM01;

   PROCEDURE AHS_REPORT_BM30
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
        open curReturn for
        select don.ID, don.TENVUAN, qd_sotham.SOQUYETDINH SOQD, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
                , SoTL_sotham.SOTHULY, SoTL_sotham.NGAYTL, SoTL_sotham.THANGTL, SoTL_sotham.NAMTL
                , (case when don.SOBICAN=1 then bicao.HOTEN
                              else ( bicao.HOTEN || ' và các đồng phạm') end) HOTENBICAO

              from AHS_VUAN don 
              inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
              left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID
                                        , sotham_QD.VUANID, sotham_QD.SOQUYETDINH from AHS_SOTHAM_QUYETDINH_VUAN sotham_QD
                                        left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                                        where DM_QD.MA='30-HS' and sotham_QD.VUANID=vDonID) where STT<=1
                        ) qd_sotham on don.ID = qd_sotham.VUANID
              left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                            , VUANID, SOTHULY, TO_CHAR(NGAYTHULY,'dd') NgayTL, TO_CHAR(NGAYTHULY,'MM') ThangTL, TO_CHAR(NGAYTHULY,'yyyy') NamTL from AHS_SOTHAM_THULY where VUANID=vDonID) where STT<=1
                          ) SoTL_sotham on don.ID = SoTL_sotham.VUANID
              left join (select ID, VUANID, HOTEN
                         from AHS_BICANBICAO where VUANID=vDonID and BICANDAUVU=1
                        ) bicao  on bicao.VUANID=vDonID
              where don.ID=vDonID;
  END AHS_REPORT_BM30;

PROCEDURE AHS_REPORT_BM04
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vSoQD nvarchar2(150);
  vSoTL nvarchar2(150);
  vNgayThuLy date;
  BEGIN

        select SOQUYETDINH into vSoQD from  
                     ( select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.VUANID, sotham_QD.SOQUYETDINH 
                              from AHS_SoTham_QuyetDinh_BiCan sotham_QD
                                  inner join (select ID, MA from DM_QD_QUYETDINH where MA='04-HS') DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                              where sotham_QD.VUANID=vDonID) where STT<=1;

        select SOTHULY into vSoTL from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                              , VUANID, SOTHULY, NGAYTHULY
                              from AHS_SOTHAM_THULY where VUANID=vDonID) where STT<=1;

        select NGAYTHULY into vNgayThuLy from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                              , VUANID, SOTHULY, NGAYTHULY
                              from AHS_SOTHAM_THULY where VUANID=vDonID) where STT<=1;


        open curReturn for

        select don.ID, don.TENVUAN, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
                , vSoQD SOQD, vSoTL SOTL, TO_CHAR(vNgayThuLy,'dd') NGAYTL, TO_CHAR(vNgayThuLy,'MM') THANGTL, TO_CHAR(vNgayThuLy,'yyyy') NAMTL
                , bc.HOTEN HOTENBICAO
                , (case when TO_CHAR(bc.NGAYSINH,'ddMMyyyy')='01010001' then ('sinh năm ' || bc.NAMSINH )
                          else ('sinh ngày '|| TO_CHAR(bc.NGAYSINH,'dd') || ' tháng ' || bc.THANGSINH || ' năm ' || bc.NAMSINH ) end) NGAYSINH
                , (case when (dm_thuongtru.MA_TEN|| ' ')=' ' then dm_thuongtru.MA_TEN
                              else ('nơi sinh ' || dm_thuongtru.MA_TEN) end) DIACHITHUONGTRUBICAO
                , (case when (dm_tamtru.MA_TEN|| ' ')=' ' then dm_tamtru.MA_TEN
                              else ('nơi cư trú ' || dm_tamtru.MA_TEN) end) DIACHITAMTRUBICAO
                , (case when (nghenghiep.TEN|| ' ')=' ' then nghenghiep.TEN
                              else ('nghề nghiệp ' || nghenghiep.TEN) end) TENNGHENGHIEP
                , bpnc.NGAYBATDAU
                , (case when TO_CHAR(bpnc.NGAYKETTHUC,'ddMMyyyy')='01010001' then bpnc.NGAYKETTHUC
                        else bpnc.NGAYKETTHUC  end) NGAYKETTHUC
                ,FUN_AHS_TOIDANH(vDonID, bc.ID) TOIDANH
                from AHS_BiCanBiCao bc  
                  inner join (select * from AHS_VUAN where ID =1) don on don.ID = bc.VuAnID
                  inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
                  left join (select ID, MA_TEN from DM_HANHCHINH) dm_thuongtru on dm_thuongtru.ID = bc.HKTT_HUYEN
                  left join (select ID, MA_TEN from DM_HANHCHINH) dm_tamtru on dm_tamtru.ID = bc.TAMTRU_HUYEN
                  left join (select ID, TEN from DM_DATAITEM) nghenghiep on nghenghiep.ID=bc.NGHENGHIEPID
                  left join (select ID, BiCanId, BIENPHAPNGANCHANID, NGAYBATDAU, NGAYKETTHUC from AHS_SOTHAM_BIENPHAPNGANCHAN) bpnc on bpnc.BiCanId = bc.ID
                  inner join (select ID, MA  from DM_DATAITEM where MA='BPNC_03')it on it.ID = bpnc.BIENPHAPNGANCHANID
                where bc.VUANID=vDonID;
  END AHS_REPORT_BM04;

PROCEDURE AHS_REPORT_BM05
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vSoQD nvarchar2(150);
  vSoTL nvarchar2(150);
  vNgayThuLy date;
  BEGIN

        select SOQUYETDINH into vSoQD from  
                     ( select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.VUANID, sotham_QD.SOQUYETDINH 
                              from AHS_SoTham_QuyetDinh_BiCan sotham_QD
                                  inner join (select ID, MA from DM_QD_QUYETDINH where MA='05-HS') DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                              where sotham_QD.VUANID=vDonID) where STT<=1;

        select SOTHULY into vSoTL from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                              , VUANID, SOTHULY, NGAYTHULY
                              from AHS_SOTHAM_THULY where VUANID=vDonID) where STT<=1;

        select NGAYTHULY into vNgayThuLy from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                              , VUANID, SOTHULY, NGAYTHULY
                              from AHS_SOTHAM_THULY where VUANID=vDonID) where STT<=1;


        open curReturn for

        select don.ID, don.TENVUAN, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
                , vSoQD SOQD, vSoTL SOTL, TO_CHAR(vNgayThuLy,'dd') NGAYTL, TO_CHAR(vNgayThuLy,'MM') THANGTL, TO_CHAR(vNgayThuLy,'yyyy') NAMTL
                , bc.HOTEN HOTENBICAO
                , (case when TO_CHAR(bc.NGAYSINH,'ddMMyyyy')='01010001' then ('sinh năm ' || bc.NAMSINH )
                          else ('sinh ngày '|| TO_CHAR(bc.NGAYSINH,'dd') || ' tháng ' || bc.THANGSINH || ' năm ' || bc.NAMSINH ) end) NGAYSINH
                , (case when (dm_thuongtru.MA_TEN|| ' ')=' ' then dm_thuongtru.MA_TEN
                              else ('nơi sinh ' || dm_thuongtru.MA_TEN) end) DIACHITHUONGTRUBICAO
                , (case when (dm_tamtru.MA_TEN|| ' ')=' ' then dm_tamtru.MA_TEN
                              else ('nơi cư trú ' || dm_tamtru.MA_TEN) end) DIACHITAMTRUBICAO
                , (case when (nghenghiep.TEN|| ' ')=' ' then nghenghiep.TEN
                              else ('nghề nghiệp ' || nghenghiep.TEN) end) TENNGHENGHIEP
                , bpnc.NGAYBATDAU
                , (case when TO_CHAR(bpnc.NGAYKETTHUC,'ddMMyyyy')='01010001' then bpnc.NGAYKETTHUC
                        else bpnc.NGAYKETTHUC  end) NGAYKETTHUC
                ,FUN_AHS_TOIDANH(vDonID, bc.ID) TOIDANH
                from AHS_BiCanBiCao bc  
                  inner join (select * from AHS_VUAN where ID =1) don on don.ID = bc.VuAnID
                  inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
                  left join (select ID, MA_TEN from DM_HANHCHINH) dm_thuongtru on dm_thuongtru.ID = bc.HKTT_HUYEN
                  left join (select ID, MA_TEN from DM_HANHCHINH) dm_tamtru on dm_tamtru.ID = bc.TAMTRU_HUYEN
                  left join (select ID, TEN from DM_DATAITEM) nghenghiep on nghenghiep.ID=bc.NGHENGHIEPID
                  left join (select ID, BiCanId, BIENPHAPNGANCHANID, NGAYBATDAU, NGAYKETTHUC from AHS_SOTHAM_BIENPHAPNGANCHAN) bpnc on bpnc.BiCanId = bc.ID
                  inner join (select ID, MA  from DM_DATAITEM where MA='BPNC_03')it on it.ID = bpnc.BIENPHAPNGANCHANID
                where bc.VUANID=vDonID;
  END AHS_REPORT_BM05;

  PROCEDURE AHS_REPORT_BM06
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vSoQD nvarchar2(150);
  vSoTL nvarchar2(150);
  vNgayThuLy date;
  BEGIN

        select SOQUYETDINH into vSoQD from  
                     ( select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.VUANID, sotham_QD.SOQUYETDINH 
                              from AHS_SoTham_QuyetDinh_BiCan sotham_QD
                                  inner join (select ID, MA from DM_QD_QUYETDINH where MA='06-HS') DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                              where sotham_QD.VUANID=vDonID) where STT<=1;

        select SOTHULY into vSoTL from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                              , VUANID, SOTHULY, NGAYTHULY
                              from AHS_SOTHAM_THULY where VUANID=vDonID) where STT<=1;

        select NGAYTHULY into vNgayThuLy from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                              , VUANID, SOTHULY, NGAYTHULY
                              from AHS_SOTHAM_THULY where VUANID=vDonID) where STT<=1;


        open curReturn for

        select don.ID, don.TENVUAN, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
                , vSoQD SOQD, vSoTL SOTL, TO_CHAR(vNgayThuLy,'dd') NGAYTL, TO_CHAR(vNgayThuLy,'MM') THANGTL, TO_CHAR(vNgayThuLy,'yyyy') NAMTL
                , bc.HOTEN HOTENBICAO
                , (case when TO_CHAR(bc.NGAYSINH,'ddMMyyyy')='01010001' then ('sinh năm ' || bc.NAMSINH )
                          else ('sinh ngày '|| TO_CHAR(bc.NGAYSINH,'dd') || ' tháng ' || bc.THANGSINH || ' năm ' || bc.NAMSINH ) end) NGAYSINH
                , (case when (dm_thuongtru.MA_TEN|| ' ')=' ' then dm_thuongtru.MA_TEN
                              else ('nơi sinh ' || dm_thuongtru.MA_TEN) end) DIACHITHUONGTRUBICAO
                , (case when (dm_tamtru.MA_TEN|| ' ')=' ' then dm_tamtru.MA_TEN
                              else ('nơi cư trú ' || dm_tamtru.MA_TEN) end) DIACHITAMTRUBICAO
                , (case when (nghenghiep.TEN|| ' ')=' ' then nghenghiep.TEN
                              else ('nghề nghiệp ' || nghenghiep.TEN) end) TENNGHENGHIEP
                , bpnc.NGAYBATDAU
                , (case when TO_CHAR(bpnc.NGAYKETTHUC,'ddMMyyyy')='01010001' then bpnc.NGAYKETTHUC
                        else bpnc.NGAYKETTHUC  end) NGAYKETTHUC
                ,FUN_AHS_TOIDANH(vDonID, bc.ID) TOIDANH
                from AHS_BiCanBiCao bc  
                  inner join (select * from AHS_VUAN where ID =1) don on don.ID = bc.VuAnID
                  inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
                  left join (select ID, MA_TEN from DM_HANHCHINH) dm_thuongtru on dm_thuongtru.ID = bc.HKTT_HUYEN
                  left join (select ID, MA_TEN from DM_HANHCHINH) dm_tamtru on dm_tamtru.ID = bc.TAMTRU_HUYEN
                  left join (select ID, TEN from DM_DATAITEM) nghenghiep on nghenghiep.ID=bc.NGHENGHIEPID
                  left join (select ID, BiCanId, BIENPHAPNGANCHANID, NGAYBATDAU, NGAYKETTHUC from AHS_SOTHAM_BIENPHAPNGANCHAN) bpnc on bpnc.BiCanId = bc.ID
                  inner join (select ID, MA  from DM_DATAITEM where MA='BPNC_03' or MA='BPNC_01')it on it.ID = bpnc.BIENPHAPNGANCHANID
                where bc.VUANID=vDonID;
  END AHS_REPORT_BM06;

  PROCEDURE AHS_REPORT_BM07
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vSoQD nvarchar2(150);
  vSoTL nvarchar2(150);
  vTENTHAMPHAN nvarchar2(250);
  vTENKY nvarchar2(250);
  vNgayThuLy date;
  BEGIN

        select SOQUYETDINH into vSoQD from  
                     ( select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.VUANID, sotham_QD.SOQUYETDINH 
                              from AHS_SoTham_QuyetDinh_BiCan sotham_QD
                                  inner join (select ID, MA from DM_QD_QUYETDINH where MA='07-HS') DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                              where sotham_QD.VUANID=vDonID) where STT<=1;

        select SOTHULY into vSoTL from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                              , VUANID, SOTHULY, NGAYTHULY
                              from AHS_SOTHAM_THULY where VUANID=vDonID) where STT<=1;

        select NGAYTHULY into vNgayThuLy from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                              , VUANID, SOTHULY, NGAYTHULY
                              from AHS_SOTHAM_THULY where VUANID=vDonID) where STT<=1;

        select cb.HOTEN into vTENKY from AHS_PHUCTHAM_HDXX hdxx_pt 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_pt.CANBOID=cb.ID
                            where hdxx_pt.MAVAITRO='THAMPHAN' and hdxx_pt.VUANID=1 and rownum<=1;

        select DECODE(NVL(cb.GIOITINH,0), 0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN into vTENTHAMPHAN
                            from AHS_PHUCTHAM_HDXX hdxx_pt 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_pt.CANBOID=cb.ID
                            where hdxx_pt.MAVAITRO='THAMPHAN' and hdxx_pt.VUANID=1 and rownum<=1;


        open curReturn for

        select don.ID, don.TENVUAN, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
                , vSoQD SOQD, vSoTL SOTL, vTENKY TENKY, vTENTHAMPHAN TENPHAMPHAN, TO_CHAR(vNgayThuLy,'dd') NGAYTL, TO_CHAR(vNgayThuLy,'MM') THANGTL, TO_CHAR(vNgayThuLy,'yyyy') NAMTL
                , bc.HOTEN HOTENBICAO
                , (case when TO_CHAR(bc.NGAYSINH,'ddMMyyyy')='01010001' then ('sinh năm ' || bc.NAMSINH )
                          else ('sinh ngày '|| TO_CHAR(bc.NGAYSINH,'dd') || ' tháng ' || bc.THANGSINH || ' năm ' || bc.NAMSINH ) end) NGAYSINH
                , (case when (dm_thuongtru.MA_TEN|| ' ')=' ' then dm_thuongtru.MA_TEN
                              else ('nơi sinh ' || dm_thuongtru.MA_TEN) end) DIACHITHUONGTRUBICAO
                , (case when (dm_tamtru.MA_TEN|| ' ')=' ' then dm_tamtru.MA_TEN
                              else ('nơi cư trú ' || dm_tamtru.MA_TEN) end) DIACHITAMTRUBICAO
                , (case when (nghenghiep.TEN|| ' ')=' ' then nghenghiep.TEN
                              else ('nghề nghiệp ' || nghenghiep.TEN) end) TENNGHENGHIEP
                , bpnc.NGAYBATDAU
                , (case when TO_CHAR(bpnc.NGAYKETTHUC,'ddMMyyyy')='01010001' then bpnc.NGAYKETTHUC
                        else bpnc.NGAYKETTHUC  end) NGAYKETTHUC
                ,FUN_AHS_TOIDANH(vDonID, bc.ID) TOIDANH
                from AHS_BiCanBiCao bc  
                  inner join (select * from AHS_VUAN where ID =1) don on don.ID = bc.VuAnID
                  inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
                  left join (select ID, MA_TEN from DM_HANHCHINH) dm_thuongtru on dm_thuongtru.ID = bc.HKTT_HUYEN
                  left join (select ID, MA_TEN from DM_HANHCHINH) dm_tamtru on dm_tamtru.ID = bc.TAMTRU_HUYEN
                  left join (select ID, TEN from DM_DATAITEM) nghenghiep on nghenghiep.ID=bc.NGHENGHIEPID
                  left join (select ID, BiCanId, BIENPHAPNGANCHANID, NGAYBATDAU, NGAYKETTHUC from AHS_SOTHAM_BIENPHAPNGANCHAN) bpnc on bpnc.BiCanId = bc.ID
                  inner join (select ID, MA  from DM_DATAITEM where MA='BPNC_03')it on it.ID = bpnc.BIENPHAPNGANCHANID
                where bc.VUANID=vDonID;
  END AHS_REPORT_BM07;

PROCEDURE AHS_REPORT_BM08
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vSoQD nvarchar2(150);
  vSoTL nvarchar2(150);
  vTENTHAMPHAN nvarchar2(250);
  vTENKY nvarchar2(250);
  vNgayThuLy date;
  BEGIN

        select SOQUYETDINH into vSoQD from  
                     ( select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.VUANID, sotham_QD.SOQUYETDINH 
                              from AHS_SoTham_QuyetDinh_BiCan sotham_QD
                                  inner join (select ID, MA from DM_QD_QUYETDINH where MA='08-HS') DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                              where sotham_QD.VUANID=vDonID) where STT<=1;

        select SOTHULY into vSoTL from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                              , VUANID, SOTHULY, NGAYTHULY
                              from AHS_SOTHAM_THULY where VUANID=vDonID) where STT<=1;

        select NGAYTHULY into vNgayThuLy from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                              , VUANID, SOTHULY, NGAYTHULY
                              from AHS_SOTHAM_THULY where VUANID=vDonID) where STT<=1;

        select cb.HOTEN into vTENKY from AHS_PHUCTHAM_HDXX hdxx_pt 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_pt.CANBOID=cb.ID
                            where hdxx_pt.MAVAITRO='THAMPHAN' and hdxx_pt.VUANID=1 and rownum<=1;

        select DECODE(NVL(cb.GIOITINH,0), 0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN into vTENTHAMPHAN
                            from AHS_PHUCTHAM_HDXX hdxx_pt 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_pt.CANBOID=cb.ID
                            where hdxx_pt.MAVAITRO='THAMPHAN' and hdxx_pt.VUANID=1 and rownum<=1;


        open curReturn for

        select don.ID, don.TENVUAN, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
                , vSoQD SOQD, vSoTL SOTL, vTENKY TENKY, vTENTHAMPHAN TENPHAMPHAN, TO_CHAR(vNgayThuLy,'dd') NGAYTL, TO_CHAR(vNgayThuLy,'MM') THANGTL, TO_CHAR(vNgayThuLy,'yyyy') NAMTL
                , bc.HOTEN HOTENBICAO
                , (case when TO_CHAR(bc.NGAYSINH,'ddMMyyyy')='01010001' then ('sinh năm ' || bc.NAMSINH )
                          else ('sinh ngày '|| TO_CHAR(bc.NGAYSINH,'dd') || ' tháng ' || bc.THANGSINH || ' năm ' || bc.NAMSINH ) end) NGAYSINH
                , (case when (dm_thuongtru.MA_TEN|| ' ')=' ' then dm_thuongtru.MA_TEN
                              else ('nơi sinh ' || dm_thuongtru.MA_TEN) end) DIACHITHUONGTRUBICAO
                , (case when (dm_tamtru.MA_TEN|| ' ')=' ' then dm_tamtru.MA_TEN
                              else ('nơi cư trú ' || dm_tamtru.MA_TEN) end) DIACHITAMTRUBICAO
                , (case when (nghenghiep.TEN|| ' ')=' ' then nghenghiep.TEN
                              else ('nghề nghiệp ' || nghenghiep.TEN) end) TENNGHENGHIEP
                , bpnc.NGAYBATDAU
                , (case when TO_CHAR(bpnc.NGAYKETTHUC,'ddMMyyyy')='01010001' then bpnc.NGAYKETTHUC
                        else bpnc.NGAYKETTHUC  end) NGAYKETTHUC
                ,FUN_AHS_TOIDANH(vDonID, bc.ID) TOIDANH
                from AHS_BiCanBiCao bc  
                  inner join (select * from AHS_VUAN where ID =1) don on don.ID = bc.VuAnID
                  inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
                  left join (select ID, MA_TEN from DM_HANHCHINH) dm_thuongtru on dm_thuongtru.ID = bc.HKTT_HUYEN
                  left join (select ID, MA_TEN from DM_HANHCHINH) dm_tamtru on dm_tamtru.ID = bc.TAMTRU_HUYEN
                  left join (select ID, TEN from DM_DATAITEM) nghenghiep on nghenghiep.ID=bc.NGHENGHIEPID
                  left join (select ID, BiCanId, BIENPHAPNGANCHANID, NGAYBATDAU, NGAYKETTHUC from AHS_SOTHAM_BIENPHAPNGANCHAN) bpnc on bpnc.BiCanId = bc.ID
                  inner join (select ID, MA  from DM_DATAITEM where MA='BPNC_03' or MA='BPNC_01')it on it.ID = bpnc.BIENPHAPNGANCHANID
                where bc.VUANID=vDonID;
  END AHS_REPORT_BM08;

FUNCTION FUN_AHS_TOIDANH 
(
  vDONID NUMBER,
  vBICANID NUMBER
) RETURN NVARCHAR2
AS
vReturn NVARCHAR2(250);
BEGIN
         FOR item IN (select c.TenToiDanh
                        from  AHS_SOTHAM_CAOTRANG_DIEULUAT a 
                          inner join (select Id, Loai from DM_BoLuat  where HieuLuc=1 and Loai =1
                          ) b on a.DieuLuatID = b.ID
                          inner join (select ID, LuatID, TenToiDanh from DM_BoLuat_ToiDanh where HieuLuc=1
                                    ) c on c.LuatID = b.ID and a.ToiDanhID = c.ID
                        where    a.VuAnID = vDONID and BICANID=vBICANID)
         LOOP
              --SET SERVEROUTPUT ON
              IF (vReturn|| ' ')=' ' 
                THEN vReturn:=  item.TenToiDanh;
              ELSE
                vReturn:= (vReturn ||', '|| item.TenToiDanh);
              END IF;          
         END LOOP;
    RETURN vReturn;

END FUN_AHS_TOIDANH;

PROCEDURE AHS_REPORT_ThamPhan
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
        open curReturn for
        select ROW_NUMBER () OVER (ORDER BY NGAYPHANCONG) STT ,sot_hdxx.VuAnID
              , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN 
              from AHS_SOTHAM_HDXX sot_hdxx
              inner join (select ID, GIOITINH, HOTEN from DM_CANBO) cb on sot_hdxx.CANBOID=cb.ID
              where VuAnID=vDonID and MAVAITRO='THAMPHANHDXX';

  END AHS_REPORT_ThamPhan;

  PROCEDURE AHS_REPORT_HoiThamND
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
        open curReturn for
        select ROW_NUMBER () OVER (ORDER BY NGAYPHANCONG) STT ,sot_hdxx.VuAnID
              , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN 
              from AHS_SOTHAM_HDXX sot_hdxx
              inner join (select ID, GIOITINH, HOTEN from DM_CANBO) cb on sot_hdxx.CANBOID=cb.ID
              where VuAnID=vDonID and MAVAITRO='HTND';

  END AHS_REPORT_HoiThamND;
PROCEDURE AHS_GETHINHPHAT_BICAO_ST 
(
  BANANID IN NUMBER 
, BICAOID IN NUMBER
, curReturn OUT sys_refcursor
) AS 
BEGIN
  OPEN curReturn FOR
  select hp.MAHINHPHAT,sum(nvl(bact.TG_NGAY,0)) as TG_NGAY,sum(nvl(bact.TG_THANG,0)) as TG_THANG,
    sum(nvl(bact.TG_NAM,0)) as TG_NAM
  from AHS_SOTHAM_BANAN_DIEU_CHITIET bact
  inner join (select a.ID,a.MAHINHPHAT from DM_HINHPHAT a where a.MAHINHPHAT in ('TUCOTHOIHAN','TUCHUNGTHAN','TUHINH')) hp on hp.ID=bact.HINHPHATID
  where bact.BANANID=BANANID and bact.BICANID=BICAOID
  group by hp.MAHINHPHAT;
END AHS_GETHINHPHAT_BICAO_ST;
PROCEDURE AHS_GETHINHPHAT_BICAO_PT 
(
  BANANID IN NUMBER 
, BICAOID IN NUMBER
, curReturn OUT sys_refcursor
) AS 
BEGIN
  OPEN curReturn FOR
  select hp.MAHINHPHAT,sum(nvl(bact.TG_NGAY,0)) as TG_NGAY,sum(nvl(bact.TG_THANG,0)) as TG_THANG,
    sum(nvl(bact.TG_NAM,0)) as TG_NAM
  from AHS_PHUCTHAM_BANAN_DIEU_CT bact
  inner join (select a.ID,a.MAHINHPHAT from DM_HINHPHAT a where a.MAHINHPHAT in ('TUCOTHOIHAN','TUCHUNGTHAN','TUHINH')) hp on hp.ID=bact.HINHPHATID
  where bact.BANANID=BANANID and bact.BICANID=BICAOID
  group by hp.MAHINHPHAT;
END AHS_GETHINHPHAT_BICAO_PT;
PROCEDURE AHS_GETTOIDANH_BICAO_VKS 
(
  BOLUATID IN NUMBER
, BICAOID IN NUMBER
, curReturn OUT sys_refcursor
) AS 
BEGIN
  OPEN curReturn FOR
  WITH cteData as(
    select distinct td.DIEU from AHS_SOTHAM_CAOTRANG_DIEULUAT bact
    inner join (select a.ID,a.DIEU from DM_BOLUAT_TOIDANH a 
                  where a.LUATID=BOLUATID and a.COHINHPHAT=1
                ) td on td.ID=bact.TOIDANHID
    where bact.BICANID=BICAOID and DIEULUATID=BOLUATID
  )
  select b.TENTOIDANH from cteData a
  inner join (select c.DIEU,c.TENTOIDANH from DM_BOLUAT_TOIDANH c
            where c.LUATID=BOLUATID and ((c.KHOAN is null and c.DIEM is null) or (c.LOAI=2))
            ) b on a.DIEU=b.DIEU;
END AHS_GETTOIDANH_BICAO_VKS;
PROCEDURE AHS_GETTOIDANH_BICAO_ST 
(
  BOLUATID IN NUMBER
, BANANID IN NUMBER 
, BICAOID IN NUMBER
, curReturn OUT sys_refcursor
) AS 
BEGIN
  OPEN curReturn FOR
  WITH cteData as(
    select distinct td.DIEU from AHS_SOTHAM_BANAN_DIEU_CHITIET bact
    inner join (select a.ID,a.DIEU from DM_BOLUAT_TOIDANH a 
                  where a.LUATID=BOLUATID and a.COHINHPHAT=1
                ) td on td.ID=bact.TOIDANHID
    where bact.BANANID=BANANID and bact.BICANID=BICAOID and DIEULUATID=BOLUATID
  )
  select b.TENTOIDANH from cteData a
  inner join (select c.DIEU,c.TENTOIDANH from DM_BOLUAT_TOIDANH c
            where c.LUATID=BOLUATID and ((c.KHOAN is null and c.DIEM is null) or (c.LOAI=2))
            ) b on a.DIEU=b.DIEU;
END AHS_GETTOIDANH_BICAO_ST;
PROCEDURE AHS_GETTOIDANH_BICAO_PT 
(
  BOLUATID IN NUMBER
, BANANID IN NUMBER 
, BICAOID IN NUMBER
, curReturn OUT sys_refcursor
) AS 
BEGIN
  OPEN curReturn FOR
  WITH cteData as(
    select distinct td.DIEU from AHS_PHUCTHAM_BANAN_DIEU_CT bact
    inner join (select a.ID,a.DIEU from DM_BOLUAT_TOIDANH a 
                  where a.LUATID=BOLUATID and a.COHINHPHAT=1
                ) td on td.ID=bact.TOIDANHID
    where bact.BANANID=BANANID and bact.BICANID=BICAOID and DIEULUATID=BOLUATID
  )
  select b.TENTOIDANH from cteData a
  inner join (select c.DIEU,c.TENTOIDANH from DM_BOLUAT_TOIDANH c
            where c.LUATID=BOLUATID and ((c.KHOAN is null and c.DIEM is null) or (c.LOAI=2))
            ) b on a.DIEU=b.DIEU;
END AHS_GETTOIDANH_BICAO_PT;
PROCEDURE AHS_GETDIEUKHOAN_BICAO_ST 
(
  vBoLuatID in number,
  vBanAnID in number,
  vBiCaoID in number,
  curReturn OUT sys_refcursor
) AS 
BEGIN
  OPEN curReturn FOR
  select c.DIEU, c.KHOAN,c.DIEM
  from  AHS_SOTHAM_BANAN_DIEU_CHITIET a 
  inner join (select ID,DIEU,KHOAN,DIEM 
              from DM_BOLUAT_TOIDANH where HIEULUC=1 and LUATID=vBoLuatID) c on a.ToiDanhID = c.ID
  where a.BICANID=vBiCaoID and a.BANANID=vBanAnID and a.DIEULUATID=vBoLuatID order by c.DIEU,c.KHOAN,c.DIEM;
END AHS_GETDIEUKHOAN_BICAO_ST;
PROCEDURE AHS_GETDIEUKHOAN_BICAO_PT 
(
  vBoLuatID in number,
  vBanAnID in number,
  vBiCaoID in number,
  curReturn OUT sys_refcursor
) AS 
BEGIN
  OPEN curReturn FOR
  select c.DIEU, c.KHOAN,c.DIEM
  from  AHS_PHUCTHAM_BANAN_DIEU_CT a 
  inner join (select ID,DIEU,KHOAN,DIEM 
              from DM_BOLUAT_TOIDANH where HIEULUC=1 and LUATID=vBoLuatID) c on a.ToiDanhID = c.ID
  where a.BICANID=vBiCaoID and a.BANANID=vBanAnID and a.DIEULUATID=vBoLuatID order by c.DIEU,c.KHOAN,c.DIEM;
END AHS_GETDIEUKHOAN_BICAO_PT;
END PKG_GSTP_REPORT_HS;

/
