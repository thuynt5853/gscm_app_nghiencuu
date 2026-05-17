using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.DKK;
using DAL.GSTP;

namespace BL.DonKK
{
    public class DONKK_DON_BL
    {
        //CHuoi connection den DB Donkhoikien
        public String CurrConnectionString = ENUM_CONNECTION.DonKhoiKien;
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();

        public DataTable ThongKe( Decimal toa_an_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("toa_an_id",toa_an_id),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_Don_ThongKe", parameters);
            return tbl;
        }
        public DataTable Search(Decimal UserID, int trangthai, Decimal toa_an_id
                                        , string vu_viec, String ten_duong_su
                                        , DateTime? tu_ngay, DateTime? den_ngay
                                        , decimal PageIndex, decimal PageSize)
        {
            if (tu_ngay == DateTime.MinValue) tu_ngay = null;
            if (den_ngay == DateTime.MinValue) den_ngay = null;
            OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("user_id",UserID),
                                                                            new OracleParameter("trang_thai",trangthai),
                                                                            new OracleParameter("toa_an_id",toa_an_id),
                                                                            new OracleParameter("vu_viec",vu_viec),
                                                                            new OracleParameter("ten_duong_su",ten_duong_su),
                                                                            new OracleParameter("tu_ngay",tu_ngay),
                                                                            new OracleParameter("den_ngay",den_ngay),
                                                                            new OracleParameter("PageIndex",PageIndex),
                                                                            new OracleParameter("PageSize", PageSize),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                          };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKhoiKien_Search", parameters);
            return tbl;
        }
        public DataTable SearchByToaAn(int trangthai, Decimal toa_an_id , decimal PageIndex, decimal PageSize)
        {   OracleParameter[] parameters = new OracleParameter[] {  
                                                                            new OracleParameter("trang_thai",trangthai),
                                                                            new OracleParameter("toa_an_id",toa_an_id),
                                                                            new OracleParameter("PageIndex",PageIndex),
                                                                            new OracleParameter("PageSize", PageSize),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                          };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKHOIKIEN_SEARCHBYTOAAN", parameters);
            return tbl;
        }
        public DataTable GET_DONKK_CHUA_PHANLOAI(Decimal v_trang_thai, String v_toa_an_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_trang_thai",v_trang_thai),
                    new OracleParameter("v_toa_an_id",v_toa_an_id),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK.SOLUONGDONKK_CHUAPHANLOAI", parameters);
            return tbl;
        }
        public DataTable GetTopDonDangGiaoDichByUser(Decimal UserID, int soluong)
        {
            OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("user_id",UserID),
                                                                            new OracleParameter("soluong",soluong),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                          };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKhoiKien_GetTopDaGui", parameters);
            return tbl;
        }
      
        
       public void DeleteDonTemp( string UserName)
        {
            DKKContextContainer dt = new DKKContextContainer();
            try
            {
                List<DONKK_DON_DUONGSU> lst = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == 0 && x.NGUOITAO == UserName).ToList<DONKK_DON_DUONGSU>();
                if (lst != null && lst.Count > 0)
                {
                    foreach (DONKK_DON_DUONGSU item in lst)
                        dt.DONKK_DON_DUONGSU.Remove(item);
                }
                dt.SaveChanges();
            }catch (Exception ex) { }
            //--------------------------
            try
            {
                List<DONKK_DON_TAILIEU> lstFile = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == 0 && x.NGUOITAO == UserName).ToList<DONKK_DON_TAILIEU>();
                if (lstFile != null && lstFile.Count > 0)
                {
                    foreach (DONKK_DON_TAILIEU item in lstFile)
                        dt.DONKK_DON_TAILIEU.Remove(item);
                }
                dt.SaveChanges();
            }catch(Exception ex) { }
        }        

        public void UpdateTrangThaiDonKK(int trangthai, String YeuCau, string ma_loai_an, decimal VuAnID)
        {
            DKKContextContainer dt = new DKKContextContainer();
            DONKK_DON obj = dt.DONKK_DON.Where(x => x.VUANID == VuAnID && x.MALOAIVUAN == ma_loai_an).Single<DONKK_DON>();
            if (obj != null )
            {
                obj.TRANGTHAI = trangthai;
                obj.YEUCAU = YeuCau;
                dt.SaveChanges();
            }
        }
        public DataTable CountByTrangThai(Decimal UserID)
        {
            OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("user_id", UserID), new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )};
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_Don_CountByTrangThai", parameters);
            return tbl;
        }
        public DataTable SearchQLAnByTuCachTT(string ten_duong_su, string email_duongsu
            , decimal toa_an_id, string tucachtotung_ma
            , string sothuly,string ngaythuly,string namsinh, string capxetxu,string vcmnd,decimal vduongsuId,string vMaloaivuviec
            , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("ten_duong_su",ten_duong_su),
                                                                    new OracleParameter("email_ds", email_duongsu),
                                                                    new OracleParameter("toa_an_id",toa_an_id),
                                                                    new OracleParameter("tu_cach_tt_ma",tucachtotung_ma),
                                                                    new OracleParameter("sothuly",sothuly),
                                                                    new OracleParameter("ngaythuly",ngaythuly),
                                                                    new OracleParameter("namsinh",namsinh),
                                                                    new OracleParameter("capxetxu",capxetxu),
                                                                    new OracleParameter("vcmnd",vcmnd),
                                                                    new OracleParameter("vduongsuId",vduongsuId),
                                                                    new OracleParameter("vMaloaivuviec",vMaloaivuviec),

                                                                    new OracleParameter("PageIndex",PageIndex),
                                                                    new OracleParameter("PageSize", PageSize),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DKK_DKNhanVB_SearchQLAnByTCTT", parameters);
            return tbl;
        }
        public DataTable GetListThuLyVuViecTheoDonKK(String MaLoaiVuViec, Decimal VuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {          new OracleParameter("MaLoaiVuViec",MaLoaiVuViec),
                                                                            new OracleParameter("CurrVuAnID",VuAnID),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "QLA_GetInfoByLoaiAn", parameters);
            return tbl;
        }

        #region Update donkk sang GSTP
        #region Update QuanLyAn GSTP. duong su
        public void Update_QLAn_DuongSu(String CurrUserName, Decimal VuAnID, Decimal DonKKID, String MaLoaiVuViec)
        {
            Decimal QLA_DuongSuID = 0;
            List<DONKK_DON_DUONGSU> lst = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == DonKKID).ToList<DONKK_DON_DUONGSU>();
            if (lst != null && lst.Count > 0)
            {
                string TuCachToTung_Ma = "", TenDuongSu = "", SoCMND;
                foreach (DONKK_DON_DUONGSU item in lst)
                {
                    QLA_DuongSuID = 0;
                    TuCachToTung_Ma = item.TUCACHTOTUNG_MA;
                    TenDuongSu = item.TENDUONGSU;
                    SoCMND = item.SOCMND;

                    switch (MaLoaiVuViec)
                    {
                        case ENUM_LOAIAN.AN_DANSU:
                            List<ADS_DON_DUONGSU> lstDS = gsdt.ADS_DON_DUONGSU.Where(x => x.DONID == VuAnID
                                                                              && x.TUCACHTOTUNG_MA == TuCachToTung_Ma
                                                                              && x.TENDUONGSU == TenDuongSu
                                                                              && x.SOCMND == SoCMND
                                                                            ).ToList();
                            if (lstDS == null || lstDS.Count == 0)
                                QLA_DuongSuID = ThemDuongSu_AnDanSu(CurrUserName, item, VuAnID);
                            break;
                        case ENUM_LOAIAN.AN_HANHCHINH:
                            List<AHC_DON_DUONGSU> lstHC = gsdt.AHC_DON_DUONGSU.Where(x => x.DONID == VuAnID
                                                                              && x.TUCACHTOTUNG_MA == TuCachToTung_Ma
                                                                              && x.TENDUONGSU == TenDuongSu
                                                                              && x.SOCMND == SoCMND
                                                                            ).ToList();
                            if (lstHC == null || lstHC.Count == 0)
                                QLA_DuongSuID = ThemDuongSu_AnHanhChinh(CurrUserName, item, VuAnID);
                            break;
                        case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                            List<AHN_DON_DUONGSU> lstHN = gsdt.AHN_DON_DUONGSU.Where(x => x.DONID == VuAnID
                                                                              && x.TUCACHTOTUNG_MA == TuCachToTung_Ma
                                                                              && x.TENDUONGSU == TenDuongSu
                                                                              && x.SOCMND == SoCMND
                                                                            ).ToList();
                            if (lstHN == null || lstHN.Count == 0)
                                QLA_DuongSuID = ThemDuongSu_AnHNGD(CurrUserName, item, VuAnID);
                            break;
                        case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                            List<AKT_DON_DUONGSU> lstKT = gsdt.AKT_DON_DUONGSU.Where(x => x.DONID == VuAnID
                                                                              && x.TUCACHTOTUNG_MA == TuCachToTung_Ma
                                                                              && x.TENDUONGSU == TenDuongSu
                                                                              && x.SOCMND == SoCMND
                                                                            ).ToList();
                            if (lstKT == null || lstKT.Count == 0)
                                QLA_DuongSuID = ThemDuongSu_AnKDTM(CurrUserName, item, VuAnID);
                            break;
                        case ENUM_LOAIAN.AN_LAODONG:
                            List<ALD_DON_DUONGSU> lstLD = gsdt.ALD_DON_DUONGSU.Where(x => x.DONID == VuAnID
                                                                              && x.TUCACHTOTUNG_MA == TuCachToTung_Ma
                                                                              && x.TENDUONGSU == TenDuongSu
                                                                              && x.SOCMND == SoCMND
                                                                            ).ToList();
                            if (lstLD == null || lstLD.Count == 0)
                                QLA_DuongSuID = ThemDuongSu_AnLaoDong(CurrUserName, item, VuAnID);
                            break;
                        case ENUM_LOAIAN.AN_PHASAN:
                            List<APS_DON_DUONGSU> lstPS = gsdt.APS_DON_DUONGSU.Where(x => x.DONID == VuAnID
                                                                              && x.TUCACHTOTUNG_MA == TuCachToTung_Ma
                                                                              && x.TENDUONGSU == TenDuongSu
                                                                              && x.SOCMND == SoCMND
                                                                            ).ToList();
                            if (lstPS == null || lstPS.Count == 0)
                                QLA_DuongSuID = ThemDuongSu_AnPhaSan(CurrUserName, item, VuAnID);
                            break;
                    }
                }
            }
        }

        Decimal ThemDuongSu_AnDanSu(String CurrUserName, DONKK_DON_DUONGSU item, Decimal VuAnID)
        {
            ADS_DON_DUONGSU oND = new ADS_DON_DUONGSU();
            oND.DONID = VuAnID;
            oND.TENDUONGSU = item.TENDUONGSU;
            oND.ISDAIDIEN = item.ISDAIDIEN;
            oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
            oND.LOAIDUONGSU = item.LOAIDUONGSU;
            oND.SOCMND = item.SOCMND;
            oND.QUOCTICHID = item.QUOCTICHID;

            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.NAMSINH = item.NAMSINH;
            oND.TUOI = (String.IsNullOrEmpty(oND.NAMSINH + "") || oND.NAMSINH == 0) ? 0 : (DateTime.Now.Year - oND.NAMSINH);

            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            oND.NDD_DIACHIID = item.NDD_DIACHIID;
            oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = CurrUserName;

            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }

            gsdt.ADS_DON_DUONGSU.Add(oND);
            gsdt.SaveChanges();

            //-----Update DonKK_DuongSu.DuongSuID------------
            Decimal QLA_DuongSuID = (decimal)oND.ID;
            item.DUONGSUID = QLA_DuongSuID;
            dt.SaveChanges();
            return oND.ID;
        }
        Decimal ThemDuongSu_AnHanhChinh(String CurrUserName, DONKK_DON_DUONGSU item, Decimal VuAnID)
        {
            AHC_DON_DUONGSU oND = new AHC_DON_DUONGSU();
            oND.DONID = VuAnID;
            oND.TENDUONGSU = item.TENDUONGSU;
            oND.ISDAIDIEN = item.ISDAIDIEN;
            oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
            oND.LOAIDUONGSU = item.LOAIDUONGSU;
            oND.SOCMND = item.SOCMND;
            oND.QUOCTICHID = item.QUOCTICHID;

            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.NAMSINH = item.NAMSINH;
            // oND.TUOI = DateTime.Now.Year - oND.NAMSINH;

            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            oND.NDD_DIACHIID = item.NDD_DIACHIID;
            oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = CurrUserName;

            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }
            gsdt.AHC_DON_DUONGSU.Add(oND);
            gsdt.SaveChanges();

            //-----Update DonKK_DuongSu.DuongSuID------------
            Decimal QLA_DuongSuID = (decimal)oND.ID;
            item.DUONGSUID = QLA_DuongSuID;
            dt.SaveChanges();
            return oND.ID;
        }

        //----------------------------------------
        Decimal ThemDuongSu_AnKDTM(String CurrUserName, DONKK_DON_DUONGSU item, Decimal VuAnID)
        {
            AKT_DON_DUONGSU oND = new AKT_DON_DUONGSU();
            oND.DONID = VuAnID;
            oND.TENDUONGSU = item.TENDUONGSU;
            oND.ISDAIDIEN = item.ISDAIDIEN;
            oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
            oND.LOAIDUONGSU = item.LOAIDUONGSU;
            oND.SOCMND = item.SOCMND;
            oND.QUOCTICHID = item.QUOCTICHID;

            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.NAMSINH = item.NAMSINH;
            //oND.TUOI = DateTime.Now.Year - oND.NAMSINH;

            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            oND.NDD_DIACHIID = item.NDD_DIACHIID;
            oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = CurrUserName;

            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }
            
            // quyennd
            oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(ENUM_SESSION.SESSION_DONVIID);
            
            gsdt.AKT_DON_DUONGSU.Add(oND);
            gsdt.SaveChanges();

            //-----Update DonKK_DuongSu.DuongSuID------------
            Decimal QLA_DuongSuID = (decimal)oND.ID;
            item.DUONGSUID = QLA_DuongSuID;
            dt.SaveChanges();
            return oND.ID;
        }
        Decimal ThemDuongSu_AnHNGD(String CurrUserName, DONKK_DON_DUONGSU item, Decimal VuAnID)
        {
            AHN_DON_DUONGSU oND = new AHN_DON_DUONGSU();
            oND.DONID = VuAnID;
            oND.TENDUONGSU = item.TENDUONGSU;
            oND.ISDAIDIEN = item.ISDAIDIEN;
            oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
            oND.LOAIDUONGSU = item.LOAIDUONGSU;
            oND.SOCMND = item.SOCMND;
            oND.QUOCTICHID = item.QUOCTICHID;

            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.NAMSINH = item.NAMSINH;
            //  oND.TUOI = DateTime.Now.Year - oND.NAMSINH;

            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            oND.NDD_DIACHIID = item.NDD_DIACHIID;
            oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = CurrUserName;

            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }
            gsdt.AHN_DON_DUONGSU.Add(oND);
            gsdt.SaveChanges();
            //-----Update DonKK_DuongSu.DuongSuID------------
            Decimal QLA_DuongSuID = (decimal)oND.ID;
            item.DUONGSUID = QLA_DuongSuID;
            dt.SaveChanges();
            return oND.ID;
        }
        //--------------------------------------
        Decimal ThemDuongSu_AnLaoDong(String CurrUserName, DONKK_DON_DUONGSU item, Decimal VuAnID)
        {
            ALD_DON_DUONGSU oND = new ALD_DON_DUONGSU();
            oND.DONID = VuAnID;
            oND.TENDUONGSU = item.TENDUONGSU;
            oND.ISDAIDIEN = item.ISDAIDIEN;
            oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
            oND.LOAIDUONGSU = item.LOAIDUONGSU;
            oND.SOCMND = item.SOCMND;
            oND.QUOCTICHID = item.QUOCTICHID;

            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.NAMSINH = item.NAMSINH;
            oND.TUOI = (String.IsNullOrEmpty(oND.NAMSINH + "") || oND.NAMSINH == 0) ? 0 : (DateTime.Now.Year - oND.NAMSINH);

            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            oND.NDD_DIACHIID = item.NDD_DIACHIID;
            oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = CurrUserName;

            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }
            gsdt.ALD_DON_DUONGSU.Add(oND);
            gsdt.SaveChanges();
            //-----Update DonKK_DuongSu.DuongSuID------------
            Decimal QLA_DuongSuID = (decimal)oND.ID;
            item.DUONGSUID = QLA_DuongSuID;
            dt.SaveChanges();
            return oND.ID;
        }
        Decimal ThemDuongSu_AnPhaSan(String CurrUserName,DONKK_DON_DUONGSU item, Decimal VuAnID)
        {
            APS_DON_DUONGSU oND = new APS_DON_DUONGSU();
            oND.DONID = VuAnID;
            oND.TENDUONGSU = item.TENDUONGSU;
            oND.ISDAIDIEN = item.ISDAIDIEN;
            oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
            oND.LOAIDUONGSU = item.LOAIDUONGSU;
            oND.SOCMND = item.SOCMND;
            oND.QUOCTICHID = item.QUOCTICHID;

            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.NAMSINH = item.NAMSINH;
            //oND.TUOI = DateTime.Now.Year - oND.NAMSINH;

            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            oND.NDD_DIACHIID = item.NDD_DIACHIID;
            oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = CurrUserName;

            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }
            gsdt.APS_DON_DUONGSU.Add(oND);
            gsdt.SaveChanges();

            //-----Update DonKK_DuongSu.DuongSuID------------
            Decimal QLA_DuongSuID = (decimal)oND.ID;
            item.DUONGSUID = QLA_DuongSuID;
            dt.SaveChanges();
            return oND.ID;
        }
        //------------------------------------
        #endregion

        #region Update QuanLyAn GSTP. TaiLieuBanGiao
        public void Update_QLAn_TaiLieuBanGiao(String CurrUserName, decimal DonKKID, decimal VuAnID, String MaLoaiVuViec)
        {
            DONKK_DON_DUONGSU obj = dt.DONKK_DON_DUONGSU.Where(x => x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON
                                                                && x.DONKKID == DonKKID
                                                                && x.ISDAIDIEN == 1).Single<DONKK_DON_DUONGSU>();

            if (obj != null)
            {
                Decimal QLA_DuongSuId = (Decimal)obj.DUONGSUID;
                switch (MaLoaiVuViec)
                {
                    case ENUM_LOAIAN.AN_DANSU:
                        ADS_File(CurrUserName, obj,  DonKKID, VuAnID, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_HANHCHINH:
                        AHC_File(CurrUserName, obj,  DonKKID, VuAnID, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                        AHN_File(CurrUserName, obj,  DonKKID, VuAnID, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                        AKT_File(CurrUserName, obj,  DonKKID, VuAnID, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_LAODONG:
                        ALD_File(CurrUserName, obj,  DonKKID, VuAnID, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_PHASAN:
                        APS_File(CurrUserName, obj,  DonKKID, VuAnID, QLA_DuongSuId);
                        break;
                }
            }
        }

        void ADS_File(String CurrUserName,DONKK_DON_DUONGSU objDS, decimal DonKKID, decimal VuAnID, Decimal QLA_DuongSuId)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                //------Xoa file cu + dinh kem file moi
                try
                {
                    List<ADS_DON_TAILIEU> lstDS = gsdt.ADS_DON_TAILIEU.Where(x => x.DONID == VuAnID).ToList<ADS_DON_TAILIEU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (ADS_DON_TAILIEU itemOld in lstDS)
                            gsdt.ADS_DON_TAILIEU.Remove(itemOld);
                        gsdt.SaveChanges();
                    }
                }
                catch (Exception ex) { }

                //-------------------------
                ADS_DON_TAILIEU objTL = new ADS_DON_TAILIEU();
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    objTL = new ADS_DON_TAILIEU();
                    objTL.DONID = VuAnID;
                    objTL.BANGIAOID = 0;
                    objTL.LOAIFILE = item.LOAIFILE;
                    objTL.TENFILE = item.TENFILE;
                    objTL.NOIDUNG = item.NOIDUNG;
                    objTL.TENTAILIEU = item.TENTAILIEU;
                    objTL.NGAYBANGIAO = DateTime.Now;

                    //ngay phan loai dkk, nguoi phan loai dkk
                    objTL.NGAYSUA = DateTime.Now;
                    objTL.NGUOISUA = CurrUserName;

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        objTL.NGAYTAO = objDS.NGAYTAO;
                        objTL.NGUOITAO = objDS.NGUOITAO;
                    }
                    catch (Exception ex) { }
                    objTL.NGUOIBANGIAO = QLA_DuongSuId;
                    objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                    objTL.NGUOINHANID = 0;

                    gsdt.ADS_DON_TAILIEU.Add(objTL);
                    gsdt.SaveChanges();
                }

                //------------ban giao tai lieu-------------------------
                try
                {
                    ADS_DON_BANGIAO_TAILIEU objBG = null;
                    List<ADS_DON_BANGIAO_TAILIEU> lstBG = gsdt.ADS_DON_BANGIAO_TAILIEU.Where(x => x.DONID == VuAnID).ToList<ADS_DON_BANGIAO_TAILIEU>();
                    if (lstBG != null && lstBG.Count > 0)
                    {
                        objBG = (ADS_DON_BANGIAO_TAILIEU)lstBG[0];
                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = CurrUserName;
                    }
                    else
                    {
                        objBG = new ADS_DON_BANGIAO_TAILIEU();
                        objBG.DONID = VuAnID;
                        objBG.NGAYBANGIAO = objDS.NGAYTAO;
                        objBG.NGUOIBANGIAO = objDS.NGUOITAO;

                        objBG.NGAYTAO = objDS.NGAYTAO;
                        objBG.NGUOITAO = objDS.NGUOITAO;

                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = CurrUserName;
                        objBG.NGUOINHANID = 0;
                        gsdt.ADS_DON_BANGIAO_TAILIEU.Add(objBG);

                    }
                    gsdt.SaveChanges();
                }
                catch (Exception ex) { }
            }
        }
        void AHC_File(String CurrUserName,DONKK_DON_DUONGSU objDS, decimal DonKKID, decimal VuAnID, Decimal QLA_DuongSuId)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                //------Xoa file cu + dinh kem file moi
                try
                {
                    List<AHC_DON_TAILIEU> lstDS = gsdt.AHC_DON_TAILIEU.Where(x => x.DONID == VuAnID).ToList<AHC_DON_TAILIEU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (AHC_DON_TAILIEU itemOld in lstDS)
                            gsdt.AHC_DON_TAILIEU.Remove(itemOld);
                        gsdt.SaveChanges();
                    }
                }
                catch (Exception ex) { }

                //-------------------------
                AHC_DON_TAILIEU objTL = new AHC_DON_TAILIEU();
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    objTL = new AHC_DON_TAILIEU();
                    objTL.DONID = VuAnID;
                    objTL.BANGIAOID = 0;
                    objTL.LOAIFILE = item.LOAIFILE;
                    objTL.TENFILE = item.TENFILE;
                    objTL.NOIDUNG = item.NOIDUNG;
                    objTL.TENTAILIEU = item.TENTAILIEU;
                    //ngay phan loai dkk, nguoi phan loai dkk
                    objTL.NGAYSUA = DateTime.Now;
                    objTL.NGUOISUA = CurrUserName;

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        objTL.NGAYTAO = objDS.NGAYTAO;
                        objTL.NGUOITAO = objDS.NGUOITAO;
                    }
                    catch (Exception ex) { }
                    objTL.NGUOIBANGIAO = QLA_DuongSuId;
                    objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                    objTL.NGUOINHANID = 0;

                    gsdt.AHC_DON_TAILIEU.Add(objTL);
                    gsdt.SaveChanges();
                }

                //------------ban giao tai lieu-------------------------
                try
                {
                    AHC_DON_BANGIAO_TAILIEU objBG = null;
                    List<AHC_DON_BANGIAO_TAILIEU> lstBG = gsdt.AHC_DON_BANGIAO_TAILIEU.Where(x => x.DONID == VuAnID).ToList<AHC_DON_BANGIAO_TAILIEU>();
                    if (lstBG != null && lstBG.Count > 0)
                    {
                        objBG = (AHC_DON_BANGIAO_TAILIEU)lstBG[0];
                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = CurrUserName;
                    }
                    else
                    {
                        objBG = new AHC_DON_BANGIAO_TAILIEU();
                        objBG.DONID = VuAnID;
                        objBG.NGAYBANGIAO = objDS.NGAYTAO;
                        objBG.NGUOIBANGIAO = objDS.NGUOITAO;

                        objBG.NGAYTAO = objDS.NGAYTAO;
                        objBG.NGUOITAO = objDS.NGUOITAO;

                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = CurrUserName;
                        objBG.NGUOINHANID = 0;
                        gsdt.AHC_DON_BANGIAO_TAILIEU.Add(objBG);

                    }
                    gsdt.SaveChanges();
                }
                catch (Exception ex) { }
            }
        }
        void AHN_File(String CurrUserName,DONKK_DON_DUONGSU objDS, decimal DonKKID, decimal VuAnID, Decimal QLA_DuongSuId)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                //------Xoa file cu + dinh kem file moi
                try
                {
                    List<AHN_DON_TAILIEU> lstDS = gsdt.AHN_DON_TAILIEU.Where(x => x.DONID == VuAnID).ToList<AHN_DON_TAILIEU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (AHN_DON_TAILIEU itemOld in lstDS)
                            gsdt.AHN_DON_TAILIEU.Remove(itemOld);
                        gsdt.SaveChanges();
                    }
                }
                catch (Exception ex) { }

                //-------------------------
                AHN_DON_TAILIEU objTL = new AHN_DON_TAILIEU();
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    objTL = new AHN_DON_TAILIEU();
                    objTL.DONID = VuAnID;
                    objTL.BANGIAOID = 0;
                    objTL.LOAIFILE = item.LOAIFILE;
                    objTL.TENFILE = item.TENFILE;
                    objTL.NOIDUNG = item.NOIDUNG;
                    objTL.TENTAILIEU = item.TENTAILIEU;
                    //ngay phan loai dkk, nguoi phan loai dkk
                    objTL.NGAYSUA = DateTime.Now;
                    objTL.NGUOISUA = CurrUserName;

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        objTL.NGAYTAO = objDS.NGAYTAO;
                        objTL.NGUOITAO = objDS.NGUOITAO;
                    }
                    catch (Exception ex) { }
                    objTL.NGUOIBANGIAO = QLA_DuongSuId;
                    objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                    objTL.NGUOINHANID = 0;

                    gsdt.AHN_DON_TAILIEU.Add(objTL);
                    gsdt.SaveChanges();
                }

                //------------ban giao tai lieu-------------------------
                try
                {
                    AHN_DON_BANGIAO_TAILIEU objBG = null;
                    List<AHN_DON_BANGIAO_TAILIEU> lstBG = gsdt.AHN_DON_BANGIAO_TAILIEU.Where(x => x.DONID == VuAnID).ToList<AHN_DON_BANGIAO_TAILIEU>();
                    if (lstBG != null && lstBG.Count > 0)
                    {
                        objBG = (AHN_DON_BANGIAO_TAILIEU)lstBG[0];
                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = CurrUserName;
                    }
                    else
                    {
                        objBG = new AHN_DON_BANGIAO_TAILIEU();
                        objBG.DONID = VuAnID;

                        objBG.NGAYBANGIAO = objDS.NGAYTAO;
                        objBG.NGUOIBANGIAO = objDS.NGUOITAO;

                        objBG.NGAYTAO = objDS.NGAYTAO;
                        objBG.NGUOITAO = objDS.NGUOITAO;

                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = CurrUserName;

                        objBG.NGUOINHANID = 0;
                        gsdt.AHN_DON_BANGIAO_TAILIEU.Add(objBG);

                    }
                    gsdt.SaveChanges();
                }
                catch (Exception ex) { }
            }
        }
        void ALD_File(String CurrUserName,DONKK_DON_DUONGSU objDS, decimal DonKKID, decimal VuAnID, Decimal QLA_DuongSuId)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                //------Xoa file cu + dinh kem file moi
                try
                {
                    List<ALD_DON_TAILIEU> lstDS = gsdt.ALD_DON_TAILIEU.Where(x => x.DONID == VuAnID).ToList<ALD_DON_TAILIEU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (ALD_DON_TAILIEU itemOld in lstDS)
                            gsdt.ALD_DON_TAILIEU.Remove(itemOld);
                        gsdt.SaveChanges();
                    }
                }
                catch (Exception ex) { }

                //-------------------------
                ALD_DON_TAILIEU objTL = new ALD_DON_TAILIEU();
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    objTL = new ALD_DON_TAILIEU();
                    objTL.DONID = VuAnID;
                    objTL.BANGIAOID = 0;
                    objTL.LOAIFILE = item.LOAIFILE;
                    objTL.TENFILE = item.TENFILE;
                    objTL.NOIDUNG = item.NOIDUNG;
                    objTL.TENTAILIEU = item.TENTAILIEU;
                    //ngay phan loai dkk, nguoi phan loai dkk
                    objTL.NGAYSUA = DateTime.Now;
                    objTL.NGUOISUA = CurrUserName;

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        objTL.NGAYTAO = objDS.NGAYTAO;
                        objTL.NGUOITAO = objDS.NGUOITAO;
                    }
                    catch (Exception ex) { }
                    objTL.NGUOIBANGIAO = QLA_DuongSuId;
                    objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                    objTL.NGUOINHANID = 0;

                    gsdt.ALD_DON_TAILIEU.Add(objTL);
                    gsdt.SaveChanges();
                }

                //------------ban giao tai lieu-------------------------
                try
                {
                    ALD_DON_BANGIAO_TAILIEU objBG = null;
                    List<ALD_DON_BANGIAO_TAILIEU> lstBG = gsdt.ALD_DON_BANGIAO_TAILIEU.Where(x => x.DONID == VuAnID).ToList<ALD_DON_BANGIAO_TAILIEU>();
                    if (lstBG != null && lstBG.Count > 0)
                    {
                        objBG = (ALD_DON_BANGIAO_TAILIEU)lstBG[0];
                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = CurrUserName;
                    }
                    else
                    {
                        objBG = new ALD_DON_BANGIAO_TAILIEU();
                        objBG.DONID = VuAnID;
                        objBG.NGAYBANGIAO = objDS.NGAYTAO;
                        objBG.NGUOIBANGIAO = objDS.NGUOITAO;

                        objBG.NGAYTAO = objDS.NGAYTAO;
                        objBG.NGUOITAO = objDS.NGUOITAO;

                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = CurrUserName;


                        objBG.NGUOINHANID = 0;
                        gsdt.ALD_DON_BANGIAO_TAILIEU.Add(objBG);

                    }
                    gsdt.SaveChanges();
                }
                catch (Exception ex) { }
            }
        }
        void AKT_File(String CurrUserName,DONKK_DON_DUONGSU objDS, decimal DonKKID, decimal VuAnID, Decimal QLA_DuongSuId)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                //------Xoa file cu + dinh kem file moi
                try
                {
                    List<AKT_DON_TAILIEU> lstDS = gsdt.AKT_DON_TAILIEU.Where(x => x.DONID == VuAnID).ToList<AKT_DON_TAILIEU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (AKT_DON_TAILIEU itemOld in lstDS)
                            gsdt.AKT_DON_TAILIEU.Remove(itemOld);
                        gsdt.SaveChanges();
                    }
                }
                catch (Exception ex) { }

                //-------------------------
                AKT_DON_TAILIEU objTL = new AKT_DON_TAILIEU();
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    objTL = new AKT_DON_TAILIEU();
                    objTL.DONID = VuAnID;
                    objTL.BANGIAOID = 0;
                    objTL.LOAIFILE = item.LOAIFILE;
                    objTL.TENFILE = item.TENFILE;
                    objTL.NOIDUNG = item.NOIDUNG;
                    objTL.TENTAILIEU = item.TENTAILIEU;
                    //ngay phan loai dkk, nguoi phan loai dkk
                    objTL.NGAYSUA = DateTime.Now;
                    objTL.NGUOISUA = CurrUserName;

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        objTL.NGAYTAO = objDS.NGAYTAO;
                        objTL.NGUOITAO = objDS.NGUOITAO;
                    }
                    catch (Exception ex) { }
                    objTL.NGUOIBANGIAO = QLA_DuongSuId;
                    objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                    objTL.NGUOINHANID = 0;

                    gsdt.AKT_DON_TAILIEU.Add(objTL);
                    gsdt.SaveChanges();
                }

                //------------ban giao tai lieu-------------------------
                try
                {
                    AKT_DON_BANGIAO_TAILIEU objBG = null;
                    List<AKT_DON_BANGIAO_TAILIEU> lstBG = gsdt.AKT_DON_BANGIAO_TAILIEU.Where(x => x.DONID == VuAnID).ToList<AKT_DON_BANGIAO_TAILIEU>();
                    if (lstBG != null && lstBG.Count > 0)
                    {
                        objBG = (AKT_DON_BANGIAO_TAILIEU)lstBG[0];
                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = CurrUserName;
                    }
                    else
                    {
                        objBG = new AKT_DON_BANGIAO_TAILIEU();
                        objBG.DONID = VuAnID;
                        objBG.NGAYBANGIAO = objDS.NGAYTAO;
                        objBG.NGUOIBANGIAO = objDS.NGUOITAO;

                        objBG.NGAYTAO = objDS.NGAYTAO;
                        objBG.NGUOITAO = objDS.NGUOITAO;

                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = CurrUserName;

                        objBG.NGUOINHANID = 0;
                        gsdt.AKT_DON_BANGIAO_TAILIEU.Add(objBG);

                    }
                    gsdt.SaveChanges();
                }
                catch (Exception ex) { }
            }
        }
        void APS_File(String CurrUserName,DONKK_DON_DUONGSU objDS, decimal DonKKID, decimal VuAnID, Decimal QLA_DuongSuId)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                //------Xoa file cu + dinh kem file moi
                try
                {
                    List<APS_DON_TAILIEU> lstDS = gsdt.APS_DON_TAILIEU.Where(x => x.DONID == VuAnID).ToList<APS_DON_TAILIEU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (APS_DON_TAILIEU itemOld in lstDS)
                            gsdt.APS_DON_TAILIEU.Remove(itemOld);
                        gsdt.SaveChanges();
                    }
                }
                catch (Exception ex) { }

                //-------------------------
                APS_DON_TAILIEU objTL = new APS_DON_TAILIEU();
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    objTL = new APS_DON_TAILIEU();
                    objTL.DONID = VuAnID;
                    objTL.BANGIAOID = 0;
                    objTL.LOAIFILE = item.LOAIFILE;
                    objTL.TENFILE = item.TENFILE;
                    objTL.NOIDUNG = item.NOIDUNG;
                    objTL.TENTAILIEU = item.TENTAILIEU;
                    //ngay phan loai dkk, nguoi phan loai dkk
                    objTL.NGAYSUA = DateTime.Now;
                    objTL.NGUOISUA = CurrUserName;

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        objTL.NGAYTAO = objDS.NGAYTAO;
                        objTL.NGUOITAO = objDS.NGUOITAO;
                    }
                    catch (Exception ex) { }
                    objTL.NGUOIBANGIAO = QLA_DuongSuId;
                    objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                    objTL.NGUOINHANID = 0;

                    gsdt.APS_DON_TAILIEU.Add(objTL);
                    gsdt.SaveChanges();
                }

                //------------ban giao tai lieu-------------------------
                try
                {
                    APS_DON_BANGIAO_TAILIEU objBG = null;
                    List<APS_DON_BANGIAO_TAILIEU> lstBG = gsdt.APS_DON_BANGIAO_TAILIEU.Where(x => x.DONID == VuAnID).ToList<APS_DON_BANGIAO_TAILIEU>();
                    if (lstBG != null && lstBG.Count > 0)
                    {
                        objBG = (APS_DON_BANGIAO_TAILIEU)lstBG[0];
                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = CurrUserName;
                    }
                    else
                    {
                        objBG = new APS_DON_BANGIAO_TAILIEU();
                        objBG.DONID = VuAnID;
                        objBG.NGAYBANGIAO = objDS.NGAYTAO;
                        objBG.NGUOIBANGIAO = objDS.NGUOITAO;

                        objBG.NGAYTAO = objDS.NGAYTAO;
                        objBG.NGUOITAO = objDS.NGUOITAO;

                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = CurrUserName;
                        objBG.NGUOINHANID = 0;
                        gsdt.APS_DON_BANGIAO_TAILIEU.Add(objBG);

                    }
                    gsdt.SaveChanges();
                }
                catch (Exception ex) { }
            }
        }

        #endregion
        #endregion

        public void UpdateGuiYeuCauThayDoi(Decimal userid)
        {
            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("vUSERID", userid) };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK.DANGKYTHAYDOI", parameters);

        }
        public DataTable GetYeuCauThayDoi(Decimal userid)
        {
            OracleParameter[] parameters = new OracleParameter[] 
                                                    {   new OracleParameter("vUSERID", userid),
                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )};
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK.GET_DANGKYTHAYDOI", parameters);
            return tbl;
        }
    }
}
