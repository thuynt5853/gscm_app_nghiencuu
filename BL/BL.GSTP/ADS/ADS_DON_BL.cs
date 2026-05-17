using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Globalization;
using System.Text;
using BL.GSTP.BANGSETGET.ADS;
using BL.GSTP.BANGSETGET;
using System.Configuration;

namespace BL.GSTP
{
    public class ADS_DON_BL
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        HashSet<DateTime> dsNgayNghi = new HashSet<DateTime>();

        public DataTable DON_SEARCH_PCTP(string V_CAP_XET_XU_LOGIN, string V_TEN_VU_AN, string V_QHPL, string V_MA_VU_AN, string V_TENDUONGSU, string V_CAPXX, string V_TOAAN_ID, string V_TINHTRANG_THULY, string V_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string V_THAMPHAN_ID, string V_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY, string V_KETQUA, string V_SO_QD, string V_NGAY_QD, string V_THUKY_ID, string V_THOIHAN_GQ, string V_LOAIDON, string V_PT_RKINHNGHIEM, string V_GQDON, decimal PageIndex, decimal PageSize)
        {
            V_TEN_VU_AN = V_TEN_VU_AN.Normalize(NormalizationForm.FormC);
            V_QHPL = V_QHPL.Normalize(NormalizationForm.FormC);
            V_MA_VU_AN = V_MA_VU_AN.Normalize(NormalizationForm.FormC);
            V_TENDUONGSU = V_TENDUONGSU.Normalize(NormalizationForm.FormC);
            V_KETQUA = V_KETQUA.Normalize(NormalizationForm.FormC);
            V_SO_QD = V_SO_QD.Normalize(NormalizationForm.FormC);
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("V_TEN_VU_AN",V_TEN_VU_AN),
                        new OracleParameter("V_QHPL",V_QHPL),
                        new OracleParameter("V_MA_VU_AN",V_MA_VU_AN),
                        new OracleParameter("V_TENDUONGSU",V_TENDUONGSU),
                        new OracleParameter("V_CAPXX",V_CAPXX),
                        new OracleParameter("V_TOAAN_ID", V_TOAAN_ID),
                        new OracleParameter("V_TINHTRANG_THULY",V_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("V_SOTHULY",V_SOTHULY),
                        new OracleParameter("V_THAMPHAN_ID",V_THAMPHAN_ID),
                        new OracleParameter("V_TINHTRANG_GIAIQUYET",V_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("V_KETQUA", V_KETQUA),
                        new OracleParameter("V_SO_QD", V_SO_QD),
                        new OracleParameter("V_NGAY_QD", V_NGAY_QD),
                        new OracleParameter("V_THUKY_ID",V_THUKY_ID),
                        new OracleParameter("V_THOIHAN_GQ",V_THOIHAN_GQ),
                        new OracleParameter("V_LOAIDON",V_LOAIDON),
                        new OracleParameter("V_PT_RKINHNGHIEM",V_PT_RKINHNGHIEM),
                        new OracleParameter("V_GQDON",V_GQDON),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_PCTP_DS.DON_SEARCH", parameters);
            return tbl;
        }
        public DataTable DON_SEARCH_PCTP_PRINT(string V_CAP_XET_XU_LOGIN, string V_TEN_VU_AN, string V_QHPL, string V_MA_VU_AN, string V_TENDUONGSU, string V_CAPXX, string V_TOAAN_ID, string V_TINHTRANG_THULY, string V_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string V_THAMPHAN_ID, string V_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY, string V_KETQUA, string V_SO_QD, string V_NGAY_QD, string V_THUKY_ID, string V_THOIHAN_GQ, string V_LOAIDON, string V_PT_RKINHNGHIEM, string V_GQDON, decimal PageIndex, decimal PageSize)
        {
            V_TEN_VU_AN = V_TEN_VU_AN.Normalize(NormalizationForm.FormC);
            V_QHPL = V_QHPL.Normalize(NormalizationForm.FormC);
            V_MA_VU_AN = V_MA_VU_AN.Normalize(NormalizationForm.FormC);
            V_TENDUONGSU = V_TENDUONGSU.Normalize(NormalizationForm.FormC);
            V_KETQUA = V_KETQUA.Normalize(NormalizationForm.FormC);
            V_SO_QD = V_SO_QD.Normalize(NormalizationForm.FormC);
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                         new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("V_TEN_VU_AN",V_TEN_VU_AN),
                        new OracleParameter("V_QHPL",V_QHPL),
                        new OracleParameter("V_MA_VU_AN",V_MA_VU_AN),
                        new OracleParameter("V_TENDUONGSU",V_TENDUONGSU),
                        new OracleParameter("V_CAPXX",V_CAPXX),
                        new OracleParameter("V_TOAAN_ID", V_TOAAN_ID),
                        new OracleParameter("V_TINHTRANG_THULY",V_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("V_SOTHULY",V_SOTHULY),
                        new OracleParameter("V_THAMPHAN_ID",V_THAMPHAN_ID),
                        new OracleParameter("V_TINHTRANG_GIAIQUYET",V_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("V_KETQUA", V_KETQUA),
                        new OracleParameter("V_SO_QD", V_SO_QD),
                        new OracleParameter("V_NGAY_QD", V_NGAY_QD),
                        new OracleParameter("V_THUKY_ID",V_THUKY_ID),
                        new OracleParameter("V_THOIHAN_GQ",V_THOIHAN_GQ),
                        new OracleParameter("V_LOAIDON",V_LOAIDON),
                        new OracleParameter("V_PT_RKINHNGHIEM",V_PT_RKINHNGHIEM),
                        new OracleParameter("V_GQDON",V_GQDON),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize)
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_PCTP_DS.DON_SEARCH_PRINT", parameters);
            return tbl;
        }
        public bool PHANCONGTP_INS_UP(String V_TRANGTHAI, String V_THAMPHANGQ_ID, String V_DONID, String V_NGAYPHANCONGTP, String V_THAM_PHAN_ID, String V_NGAYPHANCONGLD, String V_PHANCONGLD_ID, String V_CAPXX, String V_NGUOITAO, ref Decimal V_COUNTS, ref String V_THONGBAO)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_PCTP_DS.PCTP_INS_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TRANGTHAI"].Value = V_TRANGTHAI;
            comm.Parameters["V_THAMPHANGQ_ID"].Value = V_THAMPHANGQ_ID;
            comm.Parameters["V_DONID"].Value = V_DONID;
            comm.Parameters["V_NGAYPHANCONGTP"].Value = V_NGAYPHANCONGTP;
            comm.Parameters["V_THAM_PHAN_ID"].Value = V_THAM_PHAN_ID;
            comm.Parameters["V_NGAYPHANCONGLD"].Value = V_NGAYPHANCONGLD;
            comm.Parameters["V_PHANCONGLD_ID"].Value = V_PHANCONGLD_ID;
            comm.Parameters["V_CAPXX"].Value = V_CAPXX;
            comm.Parameters["V_NGUOITAO"].Value = V_NGUOITAO;
            comm.Parameters["V_COUNTS"].Direction = ParameterDirection.Output;
            comm.Parameters["V_THONGBAO"].Direction = ParameterDirection.Output;
            //----------
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return false;
                throw ex;
            }
            finally
            {
                V_COUNTS = Convert.ToDecimal(comm.Parameters["V_COUNTS"].Value.ToString());
                V_THONGBAO = Convert.ToString(comm.Parameters["V_THONGBAO"].Value.ToString());
                conn.Close();
            }
        }
        public decimal GETNEWTT(decimal donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;

        }
        public decimal GETFILENEWTT(decimal donviID, decimal vMaGiaiDoan, decimal vNam, decimal vLoaiFile)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                         new OracleParameter("vMaGiaiDoan",vMaGiaiDoan),
                                                                          new OracleParameter("vNam",vNam),
                                                                           new OracleParameter("vLoaiFile",vLoaiFile),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_FILE_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;

        }
        public decimal GET_STB_XLDon_NEW(decimal donviID, string loaian, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_STB_XLDON_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
        }

        public decimal GET_STB_XLDon_NEW_V2(decimal donviID, string loaian, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_STB_XLDON_GETMAXTT_V2", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
        }

        public decimal GET_STB_ANPHI_NEW(decimal donviID, string loaian, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_STB_ANPHI_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
        }

        public decimal CHECKSTT_ADS(decimal donviID, decimal vMaGiaiDoan, decimal vNam, decimal vLoaiFile, decimal vSTT, string vSTB_Phu, decimal vID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("vMaGiaiDoan",vMaGiaiDoan),
                                                                        new OracleParameter("vNam",vNam),
                                                                        new OracleParameter("vLoaiFile",vLoaiFile),
                                                                        new OracleParameter("vSTT",vSTT),
                                                                        new OracleParameter("vSTB_Phu",vSTB_Phu),
                                                                        new OracleParameter("vID",vID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS.ADS_FILE_CHECKSTT_ANPHI", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]);

        }
        public DataTable ADS_FILE_GETBYDON(decimal vDonID, decimal vLoaiAn, decimal vMaGiaiDoan)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vLoaiAn",vLoaiAn),
                                                                        new OracleParameter("vMaGiaiDoan",vMaGiaiDoan),
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.ADS_FILE_GETBYDON", parameters);
            //tbl.DefaultView.Sort = "THUTU ASC";
            return tbl;
        }
        public DataTable ADS_FILE_TONGDAT(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_FILE_TONGDAT", parameters);
            return tbl;
        }
        public DataTable ADS_DON_TGTT_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_TGTT_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_DON_BanGiaoTaiLieu_GETLIST(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDONID",vDONID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_BGTL_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_DON_BGTT_GETINFO(decimal vDONID, string NguoiGiao, decimal NguoiNhan, string NgayBanGiao)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vNguoiGiao",NguoiGiao),
                                                                        new OracleParameter("vNguoiNhan",NguoiNhan),
                                                                        new OracleParameter("vNgayBanGiao",NgayBanGiao),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_BGTT_GETINFO", parameters);
            return tbl;
        }
        public DataTable ADS_DON_GETTOAANBYVUVIEC(decimal vDonID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDONID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("ADS_DON_GETTOAANBYVUVIEC", prm);
        }
        public DataTable ADS_TONGDAT_DOITUONG_GETBY(decimal vDONID, decimal vTOAANID, decimal vBIEUMAUID, decimal vIsOnlyNKK)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                         new OracleParameter("vTOAANID",vTOAANID),
                                                                          new OracleParameter("vBIEUMAUID",vBIEUMAUID),
                                                                          new OracleParameter("vIsOnlyNKK",vIsOnlyNKK),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_TONGDAT_DOITUONG_GETBY", parameters);
            return tbl;
        }
        public DataTable ADS_TONGDAT_GETLIST(decimal vDONID, decimal vToaAnID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_TONGDAT_GETLIST", parameters);
            return tbl;
        }
        public bool HISTORY_ALLDATA_BY_VUANID(decimal vVUANID, decimal vLOAIANID, string vNGUOIXOAID, string vTAIKHOANXOA, string vTENCHUCNANG, string vHANHDONG, string vOBJECT)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("in_VUANID", vVUANID),
                    new OracleParameter("in_LOAIANID", vLOAIANID),
                    new OracleParameter("in_NGUOIXOAID", vNGUOIXOAID),
                    new OracleParameter("in_TAIKHOANXOA", vTAIKHOANXOA),
                    new OracleParameter("in_TENCHUCNANG", vTENCHUCNANG),
                    new OracleParameter("in_HANHDONG", vHANHDONG),
                    new OracleParameter("in_OBJECT",OracleDbType.Clob, vOBJECT,ParameterDirection.Input)
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GSTP_DELETE.HISTORY_DELETE_HOSO_AN_SOTHAM_VUANID", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }
        public bool DELETE_ALLDATA_BY_VUANID(string donID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("in_VUANID", donID) };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GSTP_DELETE.DELETE_DATA_ADS_BY_VUANID", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }
        public bool Check_ThuLy(decimal DonID)
        {
            ADS_DON _don = dt.ADS_DON.Where(x => x.ID == DonID).FirstOrDefault();
            if (_don != null)
            {
                if (_don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM || _don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO)
                {
                    ADS_SOTHAM_THULY ObjThuLy = dt.ADS_SOTHAM_THULY.Where(x => x.DONID == DonID).FirstOrDefault();
                    return ObjThuLy != null;
                }
                else if (_don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM)
                {
                    ADS_PHUCTHAM_THULY ObjThuLy = dt.ADS_PHUCTHAM_THULY.Where(x => x.DONID == DonID).FirstOrDefault();
                    return ObjThuLy != null;
                }
                else if (_don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                {
                    ADS_KCKNQDK_PHUCTHAM_THULY ObjThuLy = DataExtensions.GetAllByDonId<ADS_KCKNQDK_PHUCTHAM_THULY>(DonID).FirstOrDefault();
                    return ObjThuLy != null;
                }
            }
            return false;
        }

        public DataTable STPT_DANHSACH_AN_DANSUMORONG(string V_CAP_XET_XU_LOGIN, string v_ten_vu_an, string v_toidanh, string v_ma_vu_an, string v_bi_can, string v_Capxx, string v_toaan_id, string v_TINHTRANG_THULY, string v_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string v_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY, string v_KETQUA, string v_so_qd, string v_ngay_qd, string v_thamphan_id, string v_thuky_id, string v_THOIHAN_GQ, string v_QD_TAMGIAM, string V_UTTPDI, string V_LOAIAN_ID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_Capxx",v_Capxx),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("v_SOTHULY",v_SOTHULY),
                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_KETQUA", v_KETQUA),
                        new OracleParameter("v_so_qd", v_so_qd),
                        new OracleParameter("v_ngay_qd", v_ngay_qd),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("v_thuky_id",v_thuky_id),
                        new OracleParameter("v_THOIHAN_GQ",v_THOIHAN_GQ),
                        new OracleParameter("v_QD_TAMGIAM",v_QD_TAMGIAM),
                        new OracleParameter("V_UTTP",V_UTTPDI),
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };

            string temp_debug_oracle =
                    "V_CAP_XET_XU_LOGIN := " + ((String.IsNullOrEmpty(V_CAP_XET_XU_LOGIN)) ? " NULL " : "'" + V_CAP_XET_XU_LOGIN + "'") + " ; " +
                    "v_ten_vu_an := " + ((String.IsNullOrEmpty(v_ten_vu_an)) ? " NULL " : "'" + v_ten_vu_an + "'") + " ; " +
                    "v_toidanh := " + ((String.IsNullOrEmpty(v_toidanh)) ? " NULL " : "'" + v_toidanh + "'") + " ; " +
                    "v_ma_vu_an := " + ((String.IsNullOrEmpty(v_ma_vu_an)) ? " NULL " : "'" + v_ma_vu_an + "'") + " ; " +
                    "v_bi_can := " + ((String.IsNullOrEmpty(v_bi_can)) ? " NULL " : "'" + v_bi_can + "'") + " ; " +
                    "v_Capxx := " + ((String.IsNullOrEmpty(v_Capxx)) ? " NULL " : "'" + v_Capxx + "'") + " ; " +
                    "v_toaan_id := " + ((String.IsNullOrEmpty(v_toaan_id)) ? " NULL " : "'" + v_toaan_id + "'") + " ; " +
                    "v_TINHTRANG_THULY := " + ((String.IsNullOrEmpty(v_TINHTRANG_THULY)) ? " NULL " : "'" + v_TINHTRANG_THULY + "'") + " ; " +
                    "V_NGAYTHULY_TU := " + ((String.IsNullOrEmpty(V_NGAYTHULY_TU)) ? " NULL " : "'" + V_NGAYTHULY_TU + "'") + " ; " +
                    "V_NGAYTHULY_DEN := " + ((String.IsNullOrEmpty(V_NGAYTHULY_DEN)) ? " NULL " : "'" + V_NGAYTHULY_DEN + "'") + " ; " +
                    "v_SOTHULY := " + ((String.IsNullOrEmpty(v_SOTHULY)) ? " NULL " : "'" + v_SOTHULY + "'") + " ; " +
                    "v_TINHTRANG_GIAIQUYET := " + ((String.IsNullOrEmpty(v_TINHTRANG_GIAIQUYET)) ? " NULL " : "'" + v_TINHTRANG_GIAIQUYET + "'") + " ; " +
                    "V_TUNGAY := " + ((String.IsNullOrEmpty(V_TUNGAY)) ? " NULL " : "'" + V_TUNGAY + "'") + " ; " +
                    "V_DENNGAY := " + ((String.IsNullOrEmpty(V_DENNGAY)) ? " NULL " : "'" + V_DENNGAY + "'") + " ; " +
                    "v_KETQUA := " + ((String.IsNullOrEmpty(v_KETQUA)) ? " NULL " : "'" + v_KETQUA + "'") + " ; " +
                    "v_so_qd := " + ((String.IsNullOrEmpty(v_so_qd)) ? " NULL " : "'" + v_so_qd + "'") + " ; " +
                    "v_ngay_qd := " + ((String.IsNullOrEmpty(v_ngay_qd)) ? " NULL " : "'" + v_ngay_qd + "'") + " ; " +
                    "v_thamphan_id := " + ((String.IsNullOrEmpty(v_thamphan_id)) ? " NULL " : "'" + v_thamphan_id + "'") + " ; " +
                    "v_thuky_id := " + ((String.IsNullOrEmpty(v_thuky_id)) ? " NULL " : "'" + v_thuky_id + "'") + " ; " +
                    "v_THOIHAN_GQ := " + ((String.IsNullOrEmpty(v_THOIHAN_GQ)) ? " NULL " : "'" + v_THOIHAN_GQ + "'") + " ; " +
                    "v_QD_TAMGIAM := " + ((String.IsNullOrEmpty(v_QD_TAMGIAM)) ? " NULL " : "'" + v_QD_TAMGIAM + "'") + " ; " +
                    "V_UTTP := " + ((String.IsNullOrEmpty(V_UTTPDI)) ? " NULL " : "'" + V_UTTPDI + "'") + " ; " +
                    "V_LOAIAN_ID := " + ((String.IsNullOrEmpty(V_LOAIAN_ID)) ? " NULL " : "'" + V_LOAIAN_ID + "'") + " ; " +
                    "Page_Index := " + ((String.IsNullOrEmpty(PageIndex + "")) ? " NULL " : PageIndex + "") + " ; " +
                    "Page_Size := " + ((String.IsNullOrEmpty(PageSize + "")) ? " NULL " : PageSize + "") + " ; ";

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DANHSACH.DANHSACH_AN_DANSUMORONG", parameters);
            return tbl;
        }

        public DataTable STPT_DANHSACH_AN_PT(string V_CAP_XET_XU_LOGIN, string v_ten_vu_an, string v_toidanh, string v_ma_vu_an, string v_bi_can, string v_Capxx, string v_toaan_id,
            string v_TINHTRANG_THULY, string v_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string v_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY,
            string v_KETQUA, string v_so_qd, string v_ngay_qd, string v_thamphan_id, string V_VAITRO_THAMPHAN, string v_thuky_id, string v_THOIHAN_GQ, string v_QD_TAMGIAM, string V_UTTPDI,
            string V_LOAIAN_ID, decimal V_AN_KET_THUC, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_Capxx",v_Capxx),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("v_SOTHULY",v_SOTHULY),
                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_KETQUA", v_KETQUA),
                        new OracleParameter("v_so_qd", v_so_qd),
                        new OracleParameter("v_ngay_qd", v_ngay_qd),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("V_VAITRO_THAMPHAN",V_VAITRO_THAMPHAN),
                        new OracleParameter("v_thuky_id",v_thuky_id),
                        new OracleParameter("v_THOIHAN_GQ",v_THOIHAN_GQ),
                        new OracleParameter("v_QD_TAMGIAM",v_QD_TAMGIAM),
                        new OracleParameter("V_UTTP",V_UTTPDI),
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
                        new OracleParameter("V_AN_KET_THUC",V_AN_KET_THUC),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_STPT_DANHSACH_PT.DANHSACH_AN_DANSUMORONG", parameters);
            return tbl;
        }
        public DataTable STPT_DANHSACH_AN_ST(string V_CAP_XET_XU_LOGIN, string v_ten_vu_an, string v_toidanh, string v_ma_vu_an, string v_bi_can, string v_Capxx, string v_toaan_id,
            string v_TINHTRANG_THULY, string v_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string v_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY, string v_KETQUA,
            string v_so_qd, string v_ngay_qd, string v_thamphan_id, string V_VAITRO_THAMPHAN, string v_thuky_id, string v_THOIHAN_GQ, string v_QD_TAMGIAM, string V_UTTPDI,
            string V_LOAIAN_ID, decimal V_AN_KET_THUC, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_Capxx",v_Capxx),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("v_SOTHULY",v_SOTHULY),
                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_KETQUA", v_KETQUA),
                        new OracleParameter("v_so_qd", v_so_qd),
                        new OracleParameter("v_ngay_qd", v_ngay_qd),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("V_VAITRO_THAMPHAN",V_VAITRO_THAMPHAN),
                        new OracleParameter("v_thuky_id",v_thuky_id),
                        new OracleParameter("v_THOIHAN_GQ",v_THOIHAN_GQ),
                        new OracleParameter("v_QD_TAMGIAM",v_QD_TAMGIAM),
                        new OracleParameter("V_UTTP",V_UTTPDI),
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
                        new OracleParameter("V_AN_KET_THUC",V_AN_KET_THUC),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_STPT_DANHSACH_ST.DANHSACH_AN_DANSUMORONG", parameters);
            return tbl;
        }

        public DataTable APS_ANPHI_LICHSU_GETBYDONID(decimal donID, decimal anPhiId, int tinhTrang, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrDonID",donID),
                                                                        new OracleParameter("anPhiId", anPhiId),
                                                                        new OracleParameter("V_TINHTRANG",tinhTrang),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_APS.APS_ANPHI_LICHSU_GETBYDONID", parameters);
            return tbl;
        }

        public DataTable ADS_ANPHI_GETBYDONID(decimal donID, int tinhTrang, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrDonID",donID),
                                                                        new OracleParameter("V_TINHTRANG",tinhTrang),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_ANPHI_GETBYDONID", parameters);
            return tbl;
        }

        public DataTable ADS_ANPHI_GETBYDONID_V2(decimal donID, int tinhTrang, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrDonID",donID),
                                                                        new OracleParameter("V_TINHTRANG",tinhTrang),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_ADS.ADS_DON_ANPHI_GETBYDONID_V2", parameters);
            return tbl;
        }

        public DataTable ADS_ANPHI_LICHSU_GETBYDONID( decimal donID, decimal anPhiId, int tinhTrang, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrDonID",donID),
                                                                        new OracleParameter("anPhiId", anPhiId),
                                                                        new OracleParameter("V_TINHTRANG",tinhTrang),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_ADS.ADS_ANPHI_LICHSU_GETBYDONID", parameters);
            return tbl;
        }
        //Em Khai sua
      //  public DataTable DON_SEARCH(string V_CAP_XET_XU_LOGIN, string V_TEN_VU_AN, string V_QHPL, string V_MA_VU_AN, string V_TENDUONGSU, string V_CAPXX, string V_TOAAN_ID, string V_TINHTRANG_THULY, 
      //      string V_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string V_THAMPHAN_ID, string V_VAITROTHAMPHAN_ID, string V_TINHTRANG_GIAIQUYET, 
      //      string V_TUNGAY, string V_DENNGAY, string V_KETQUA, string V_SO_QD, string V_NGAY_QD, string V_THUKY_ID, string V_THOIHAN_GQ, string V_LOAIDON, 
      //      string V_PT_RKINHNGHIEM, string V_GQDON, string V_UTTPDI, decimal vchecktk, decimal trangThaiVuAn, decimal V_CHECK_PTQDK, decimal V_LOAI_TBTL, 
      //      decimal V_MA_THONG_BAO,
      //      decimal PageIndex, decimal PageSize,
      //      decimal? V_CHECK_HOAGIAI = 0, decimal? V_HOAGIAI_TRANGTHAI = 0, string V_HOAGIAI_TUNGAY = null, string V_HOAGIAI_DENNGAY = null)
      //  {
      //      V_TEN_VU_AN = V_TEN_VU_AN.Normalize(NormalizationForm.FormC);
      //      V_QHPL = V_QHPL.Normalize(NormalizationForm.FormC);
      //      V_MA_VU_AN = V_MA_VU_AN.Normalize(NormalizationForm.FormC);
      //      V_TENDUONGSU = V_TENDUONGSU.Normalize(NormalizationForm.FormC);
      //      V_SO_QD = V_SO_QD.Normalize(NormalizationForm.FormC);
      //      if (V_CHECK_PTQDK == 0)
      //      {
      //          OracleParameter[] parameters = new OracleParameter[] {
      //                  new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
      //                  new OracleParameter("V_TEN_VU_AN",V_TEN_VU_AN),
      //                  new OracleParameter("V_QHPL",V_QHPL),
      //                  new OracleParameter("V_MA_VU_AN",V_MA_VU_AN),
      //                  new OracleParameter("V_TENDUONGSU",V_TENDUONGSU),
      //                  new OracleParameter("V_CAPXX",V_CAPXX),
      //                  new OracleParameter("V_TOAAN_ID", V_TOAAN_ID),
      //                  new OracleParameter("V_TINHTRANG_THULY",V_TINHTRANG_THULY),
      //                  new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
      //                  new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
      //                  new OracleParameter("V_SOTHULY_SOTHONGBAO",V_SOTHULY),
      //                  new OracleParameter("V_THAMPHAN_ID",V_THAMPHAN_ID),
      //                  new OracleParameter("V_TINHTRANG_GIAIQUYET",V_TINHTRANG_GIAIQUYET),
      //                  new OracleParameter("V_TUNGAY",V_TUNGAY),
      //                  new OracleParameter("V_DENNGAY",V_DENNGAY),
      //                  new OracleParameter("V_KETQUA", V_KETQUA),
      //                  new OracleParameter("V_SO_QD", V_SO_QD),
      //                  new OracleParameter("V_NGAY_QD", V_NGAY_QD),
      //                  new OracleParameter("V_THUKY_ID",V_THUKY_ID),
      //                  new OracleParameter("V_THOIHAN_GQ",V_THOIHAN_GQ),
      //                  new OracleParameter("V_LOAIDON",V_LOAIDON),
      //                  new OracleParameter("V_PT_RKINHNGHIEM",V_PT_RKINHNGHIEM),
      //                  new OracleParameter("V_GQDON",V_GQDON),
      //                  new OracleParameter("V_UTTP",V_UTTPDI),
      //                  new OracleParameter("vchecktk",vchecktk),
      //                  new OracleParameter("V_TRANGTHAIVUAN",trangThaiVuAn),
      //                  new OracleParameter("V_VAITRO_THAMPHAN",V_VAITROTHAMPHAN_ID),

      //                  new OracleParameter("V_LOAI_TBTL",V_LOAI_TBTL),
      //                  new OracleParameter("V_MA_THONG_BAO",V_MA_THONG_BAO),

      //                  new OracleParameter("V_CHECK_HOAGIAI",V_CHECK_HOAGIAI),
      //                  new OracleParameter("V_HOAGIAI_TRANGTHAI",V_HOAGIAI_TRANGTHAI),
      //                  new OracleParameter("V_HOAGIAI_TUNGAY",V_HOAGIAI_TUNGAY),
      //                  new OracleParameter("V_HOAGIAI_DENNGAY",V_HOAGIAI_DENNGAY),

      //                  new OracleParameter("Page_Index",PageIndex),
      //                  new OracleParameter("Page_Size",PageSize),
      //                  new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
      //                  };

      //          string temp_debug_oracle =
      //              "V_CAP_XET_XU_LOGIN := " + ((String.IsNullOrEmpty(V_CAP_XET_XU_LOGIN)) ? " NULL " : "'" + V_CAP_XET_XU_LOGIN + "'") + " ; " +
      //              "V_TEN_VU_AN := " + ((String.IsNullOrEmpty(V_TEN_VU_AN)) ? " NULL " : "'" + V_TEN_VU_AN + "'") + " ; " +
      //              "V_QHPL := " + ((String.IsNullOrEmpty(V_QHPL)) ? " NULL " : "'" + V_QHPL + "'") + " ; " +
      //              "V_MA_VU_AN := " + ((String.IsNullOrEmpty(V_MA_VU_AN)) ? " NULL " : "'" + V_MA_VU_AN + "'") + " ; " +
      //              "V_TENDUONGSU := " + ((String.IsNullOrEmpty(V_TENDUONGSU)) ? " NULL " : "'" + V_TENDUONGSU + "'") + " ; " +
      //              "V_CAPXX := " + ((String.IsNullOrEmpty(V_CAPXX)) ? " NULL " : "'" + V_CAPXX + "'") + " ; " +
      //              "V_TOAAN_ID := " + ((String.IsNullOrEmpty(V_TOAAN_ID)) ? " NULL " : "'" + V_TOAAN_ID + "'") + " ; " +
      //              "V_TINHTRANG_THULY := " + ((String.IsNullOrEmpty(V_TINHTRANG_THULY)) ? " NULL " : "'" + V_TINHTRANG_THULY + "'") + " ; " +
      //              "V_NGAYTHULY_TU := " + ((String.IsNullOrEmpty(V_NGAYTHULY_TU)) ? " NULL " : "'" + V_NGAYTHULY_TU + "'") + " ; " +
      //              "V_NGAYTHULY_DEN := " + ((String.IsNullOrEmpty(V_NGAYTHULY_DEN)) ? " NULL " : "'" + V_NGAYTHULY_DEN + "'") + " ; " +
      //              "V_SOTHULY_SOTHONGBAO := " + ((String.IsNullOrEmpty(V_SOTHULY)) ? " NULL " : "'" + V_SOTHULY + "'") + " ; " +
      //              "V_THAMPHAN_ID := " + ((String.IsNullOrEmpty(V_THAMPHAN_ID)) ? " NULL " : "'" + V_THAMPHAN_ID + "'") + " ; " +
      //              "V_TINHTRANG_GIAIQUYET := " + ((String.IsNullOrEmpty(V_TINHTRANG_GIAIQUYET)) ? " NULL " : "'" + V_TINHTRANG_GIAIQUYET + "'") + " ; " +
      //              "V_TUNGAY := " + ((String.IsNullOrEmpty(V_TUNGAY)) ? " NULL " : "'" + V_TUNGAY + "'") + " ; " +
      //              "V_DENNGAY := " + ((String.IsNullOrEmpty(V_DENNGAY)) ? " NULL " : "'" + V_DENNGAY + "'") + " ; " +
      //              "V_KETQUA := " + ((String.IsNullOrEmpty(V_KETQUA)) ? " NULL " : "'" + V_KETQUA + "'") + " ; " +
      //              "V_SO_QD := " + ((String.IsNullOrEmpty(V_SO_QD)) ? " NULL " : "'" + V_SO_QD + "'") + " ; " +
      //              "V_NGAY_QD := " + ((String.IsNullOrEmpty(V_NGAY_QD)) ? " NULL " : "'" + V_NGAY_QD + "'") + " ; " +
      //              "V_THUKY_ID := " + ((String.IsNullOrEmpty(V_THUKY_ID)) ? " NULL " : "'" + V_THUKY_ID + "'") + " ; " +
      //              "V_THOIHAN_GQ := " + ((String.IsNullOrEmpty(V_THOIHAN_GQ)) ? " NULL " : "'" + V_THOIHAN_GQ + "'") + " ; " +
      //              "V_LOAIDON := " + ((String.IsNullOrEmpty(V_LOAIDON)) ? " NULL " : "'" + V_LOAIDON + "'") + " ; " +
      //              "V_PT_RKINHNGHIEM := " + ((String.IsNullOrEmpty(V_PT_RKINHNGHIEM)) ? " NULL " : "'" + V_PT_RKINHNGHIEM + "'") + " ; " +
      //              "V_GQDON := " + ((String.IsNullOrEmpty(V_GQDON)) ? " NULL " : "'" + V_GQDON + "'") + " ; " +
      //              "V_UTTP := " + ((String.IsNullOrEmpty(V_UTTPDI)) ? " NULL " : "'" + V_UTTPDI + "'") + " ; " +
      //              "vchecktk := " + ((String.IsNullOrEmpty(vchecktk + "")) ? " NULL " : vchecktk + "") + " ; " +
      //              "V_TRANGTHAIVUAN := " + ((String.IsNullOrEmpty(trangThaiVuAn + "")) ? " NULL " : trangThaiVuAn + "") + " ; " +
      //              "V_VAITRO_THAMPHAN := " + ((String.IsNullOrEmpty(V_VAITROTHAMPHAN_ID)) ? " NULL " : V_VAITROTHAMPHAN_ID + "") + " ; " +
      //              "V_LOAI_TBTL := " + ((String.IsNullOrEmpty(V_LOAI_TBTL + "")) ? " NULL " : V_LOAI_TBTL + "") + " ; " +
      //              "V_MA_THONG_BAO := " + ((String.IsNullOrEmpty(V_MA_THONG_BAO +"")) ? " NULL " : V_MA_THONG_BAO + "") + " ; " +


      //              "V_CHECK_HOAGIAI := " + ((String.IsNullOrEmpty(V_CHECK_HOAGIAI + "")) ? " NULL " : V_CHECK_HOAGIAI + "") + " ; " +
      //              "V_HOAGIAI_TRANGTHAI := " + ((String.IsNullOrEmpty(V_HOAGIAI_TRANGTHAI + "")) ? " NULL " : V_HOAGIAI_TRANGTHAI + "") + " ; " +
      //              "V_HOAGIAI_TUNGAY := " + ((String.IsNullOrEmpty(V_HOAGIAI_TUNGAY + "")) ? " NULL " : V_HOAGIAI_TUNGAY + "") + " ; " +
      //              "V_HOAGIAI_DENNGAY := " + ((String.IsNullOrEmpty(V_HOAGIAI_DENNGAY + "")) ? " NULL " : V_HOAGIAI_DENNGAY + "") + " ; " +




      //              "Page_Index := " + ((String.IsNullOrEmpty(PageIndex + "")) ? " NULL " : PageIndex + "") + " ; " +
      //              "Page_Size := " + ((String.IsNullOrEmpty(PageSize + "")) ? " NULL " : PageSize + "") + " ; ";

      //          DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_ADS_STPT_DS.ADS_DON_SEARCH_TURNING", parameters);
      //          return tbl;
      //      }
      //      else
      //      {
      //          OracleParameter[] parameters = new OracleParameter[] {
      //                  new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
      //                  new OracleParameter("V_TEN_VU_AN",V_TEN_VU_AN),
      //                  new OracleParameter("V_QHPL",V_QHPL),
      //                  new OracleParameter("V_MA_VU_AN",V_MA_VU_AN),
      //                  new OracleParameter("V_TENDUONGSU",V_TENDUONGSU),
      //                  new OracleParameter("V_CAPXX",V_CAPXX),
      //                  new OracleParameter("V_TOAAN_ID", V_TOAAN_ID),
      //                  new OracleParameter("V_TINHTRANG_THULY",V_TINHTRANG_THULY),
      //                  new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
      //                  new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
      //                  new OracleParameter("V_SOTHULY",V_SOTHULY),
      //                  new OracleParameter("V_THAMPHAN_ID",V_THAMPHAN_ID),
      //                  new OracleParameter("V_TINHTRANG_GIAIQUYET",V_TINHTRANG_GIAIQUYET),
      //                  new OracleParameter("V_TUNGAY",V_TUNGAY),
      //                  new OracleParameter("V_DENNGAY",V_DENNGAY),
      //                  new OracleParameter("V_KETQUA", V_KETQUA),
      //                  new OracleParameter("V_SO_QD", V_SO_QD),
      //                  new OracleParameter("V_NGAY_QD", V_NGAY_QD),
      //                  new OracleParameter("V_THUKY_ID",V_THUKY_ID),
      //                  new OracleParameter("V_THOIHAN_GQ",V_THOIHAN_GQ),
      //                  new OracleParameter("V_LOAIDON",V_LOAIDON),
      //                  new OracleParameter("V_PT_RKINHNGHIEM",V_PT_RKINHNGHIEM),
      //                  new OracleParameter("V_GQDON",V_GQDON),
      //                  new OracleParameter("V_UTTP",V_UTTPDI),
      //                  new OracleParameter("vchecktk",vchecktk),
      //                  new OracleParameter("V_CHECK_PTQDK",V_CHECK_PTQDK),
      //                  new OracleParameter("V_VAITRO_THAMPHAN",V_VAITROTHAMPHAN_ID),
      //                  new OracleParameter("V_CHECK_HOAGIAI",V_CHECK_HOAGIAI),
						//new OracleParameter("V_HOAGIAI_TRANGTHAI",V_HOAGIAI_TRANGTHAI),
						//new OracleParameter("V_HOAGIAI_TUNGAY",V_HOAGIAI_TUNGAY),
						//new OracleParameter("V_HOAGIAI_DENNGAY",V_HOAGIAI_DENNGAY),
						//new OracleParameter("Page_Index",PageIndex),
      //                  new OracleParameter("Page_Size",PageSize),
      //                  new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
      //                  };
      //          DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_ADS_GS.DON_SEARCH_PTQDK", parameters);
      //          return tbl;
      //      }
      //  }

        public DataTable DON_SEARCH(string V_CAP_XET_XU_LOGIN, string V_TEN_VU_AN, string V_QHPL, string V_MA_VU_AN, string V_TENDUONGSU, string V_CAPXX, string V_TOAAN_ID, string V_TINHTRANG_THULY,
            string V_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string V_THAMPHAN_ID, string V_VAITROTHAMPHAN_ID, string V_TINHTRANG_GIAIQUYET,
            string V_TUNGAY, string V_DENNGAY, string V_KETQUA, string V_SO_QD, string V_NGAY_QD, string V_THUKY_ID, string V_THOIHAN_GQ, string V_LOAIDON,
            string V_PT_RKINHNGHIEM, string V_GQDON, string V_UTTPDI, decimal vchecktk, decimal trangThaiVuAn, decimal V_CHECK_PTQDK, decimal V_LOAI_TBTL,
            decimal V_MA_THONG_BAO, decimal V_AN_KET_THUC,
            decimal PageIndex, decimal PageSize,
            decimal? V_CHECK_HOAGIAI = 0, decimal? V_HOAGIAI_TRANGTHAI = 0, string V_HOAGIAI_TUNGAY = null, string V_HOAGIAI_DENNGAY = null, string V_QHPLTKID = null)
        {
            V_TEN_VU_AN = V_TEN_VU_AN.Normalize(NormalizationForm.FormC);
            V_QHPL = V_QHPL.Normalize(NormalizationForm.FormC);
            V_MA_VU_AN = V_MA_VU_AN.Normalize(NormalizationForm.FormC);
            V_TENDUONGSU = V_TENDUONGSU.Normalize(NormalizationForm.FormC);
            V_SO_QD = V_SO_QD.Normalize(NormalizationForm.FormC);
            if (V_CHECK_PTQDK == 0)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("V_TEN_VU_AN",V_TEN_VU_AN),
                        new OracleParameter("V_QHPL",V_QHPL),
                        new OracleParameter("V_MA_VU_AN",V_MA_VU_AN),
                        new OracleParameter("V_TENDUONGSU",V_TENDUONGSU),
                        new OracleParameter("V_CAPXX",V_CAPXX),
                        new OracleParameter("V_TOAAN_ID", V_TOAAN_ID),
                        new OracleParameter("V_TINHTRANG_THULY",V_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("V_SOTHULY_SOTHONGBAO",V_SOTHULY),
                        new OracleParameter("V_THAMPHAN_ID",V_THAMPHAN_ID),
                        new OracleParameter("V_TINHTRANG_GIAIQUYET",V_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("V_KETQUA", V_KETQUA),
                        new OracleParameter("V_SO_QD", V_SO_QD),
                        new OracleParameter("V_NGAY_QD", V_NGAY_QD),
                        new OracleParameter("V_THUKY_ID",V_THUKY_ID),
                        new OracleParameter("V_THOIHAN_GQ",V_THOIHAN_GQ),
                        new OracleParameter("V_LOAIDON",V_LOAIDON),
                        new OracleParameter("V_PT_RKINHNGHIEM",V_PT_RKINHNGHIEM),
                        new OracleParameter("V_GQDON",V_GQDON),
                        new OracleParameter("V_UTTP",V_UTTPDI),
                        new OracleParameter("vchecktk",vchecktk),
                        new OracleParameter("V_TRANGTHAIVUAN",trangThaiVuAn),
                        new OracleParameter("V_VAITRO_THAMPHAN",V_VAITROTHAMPHAN_ID),

                        new OracleParameter("V_LOAI_TBTL",V_LOAI_TBTL),
                        new OracleParameter("V_MA_THONG_BAO",V_MA_THONG_BAO),

                        new OracleParameter("V_CHECK_HOAGIAI",V_CHECK_HOAGIAI),
                        new OracleParameter("V_HOAGIAI_TRANGTHAI",V_HOAGIAI_TRANGTHAI),
                        new OracleParameter("V_HOAGIAI_TUNGAY",V_HOAGIAI_TUNGAY),
                        new OracleParameter("V_HOAGIAI_DENNGAY",V_HOAGIAI_DENNGAY),
                        new OracleParameter("V_AN_KET_THUC",V_AN_KET_THUC),
                        new OracleParameter("V_QHPLTKID",V_QHPLTKID),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };

                DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_ADS_STPT_DS.ADS_DON_SEARCH_TURNING", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("V_TEN_VU_AN",V_TEN_VU_AN),
                        new OracleParameter("V_QHPL",V_QHPL),
                        new OracleParameter("V_MA_VU_AN",V_MA_VU_AN),
                        new OracleParameter("V_TENDUONGSU",V_TENDUONGSU),
                        new OracleParameter("V_CAPXX",V_CAPXX),
                        new OracleParameter("V_TOAAN_ID", V_TOAAN_ID),
                        new OracleParameter("V_TINHTRANG_THULY",V_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("V_SOTHULY",V_SOTHULY),
                        new OracleParameter("V_THAMPHAN_ID",V_THAMPHAN_ID),
                        new OracleParameter("V_TINHTRANG_GIAIQUYET",V_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("V_KETQUA", V_KETQUA),
                        new OracleParameter("V_SO_QD", V_SO_QD),
                        new OracleParameter("V_NGAY_QD", V_NGAY_QD),
                        new OracleParameter("V_THUKY_ID",V_THUKY_ID),
                        new OracleParameter("V_THOIHAN_GQ",V_THOIHAN_GQ),
                        new OracleParameter("V_LOAIDON",V_LOAIDON),
                        new OracleParameter("V_PT_RKINHNGHIEM",V_PT_RKINHNGHIEM),
                        new OracleParameter("V_GQDON",V_GQDON),
                        new OracleParameter("V_UTTP",V_UTTPDI),
                        new OracleParameter("vchecktk",vchecktk),
                        new OracleParameter("V_CHECK_PTQDK",V_CHECK_PTQDK),
                        new OracleParameter("V_VAITRO_THAMPHAN",V_VAITROTHAMPHAN_ID),
                        new OracleParameter("V_CHECK_HOAGIAI",V_CHECK_HOAGIAI),
                        new OracleParameter("V_HOAGIAI_TRANGTHAI",V_HOAGIAI_TRANGTHAI),
                        new OracleParameter("V_HOAGIAI_TUNGAY",V_HOAGIAI_TUNGAY),
                        new OracleParameter("V_HOAGIAI_DENNGAY",V_HOAGIAI_DENNGAY),
                        new OracleParameter("V_AN_KET_THUC",V_AN_KET_THUC),
                        new OracleParameter("V_QHPLTKID",V_QHPLTKID),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_STPT_ADS_GS.DON_SEARCH_PTQDK", parameters);
                return tbl;
            }
        }

        public DataTable DON_CON_SEARCH(decimal donIdGoc, string V_CAP_XET_XU_LOGIN, string V_TEN_VU_AN, string V_QHPL, string V_MA_VU_AN, string V_TENDUONGSU, string V_CAPXX, string V_TOAAN_ID, string V_TINHTRANG_THULY, string V_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string V_THAMPHAN_ID, string V_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY, string V_KETQUA, string V_SO_QD, string V_NGAY_QD, string V_THUKY_ID, string V_THOIHAN_GQ, string V_LOAIDON, string V_PT_RKINHNGHIEM, string V_GQDON, string V_UTTPDI, decimal vchecktk, decimal trangThaiVuAn, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_DONID_GOC",donIdGoc),
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("V_TEN_VU_AN",V_TEN_VU_AN),
                        new OracleParameter("V_QHPL",V_QHPL),
                        new OracleParameter("V_MA_VU_AN",V_MA_VU_AN),
                        new OracleParameter("V_TENDUONGSU",V_TENDUONGSU),
                        new OracleParameter("V_CAPXX",V_CAPXX),
                        new OracleParameter("V_TOAAN_ID", V_TOAAN_ID),
                        new OracleParameter("V_TINHTRANG_THULY",V_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("V_SOTHULY",V_SOTHULY),
                        new OracleParameter("V_THAMPHAN_ID",V_THAMPHAN_ID),
                        new OracleParameter("V_TINHTRANG_GIAIQUYET",V_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("V_KETQUA", V_KETQUA),
                        new OracleParameter("V_SO_QD", V_SO_QD),
                        new OracleParameter("V_NGAY_QD", V_NGAY_QD),
                        new OracleParameter("V_THUKY_ID",V_THUKY_ID),
                        new OracleParameter("V_THOIHAN_GQ",V_THOIHAN_GQ),
                        new OracleParameter("V_LOAIDON",V_LOAIDON),
                        new OracleParameter("V_PT_RKINHNGHIEM",V_PT_RKINHNGHIEM),
                        new OracleParameter("V_GQDON",V_GQDON),
                        new OracleParameter("V_UTTP",V_UTTPDI),
                        new OracleParameter("vchecktk",vchecktk),
                        new OracleParameter("V_TRANGTHAIVUAN",trangThaiVuAn),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_ADS_STPT_DS.DON_CON_SEARCH", parameters);
            return tbl;
        }
        public DataTable DON_NHAPTACH_SEARCH(string V_CAP_XET_XU_LOGIN, string V_TEN_VU_AN, string V_QHPL, string V_MA_VU_AN, string V_TENDUONGSU, string V_CAPXX, string V_TOAAN_ID, string V_TINHTRANG_THULY, string V_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string V_THAMPHAN_ID, string V_THUKY_ID, string V_LOAIDON, decimal trangThaiVuAn, decimal loaiAnID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("V_TEN_VU_AN",V_TEN_VU_AN),
                        new OracleParameter("V_QHPL",V_QHPL),
                        new OracleParameter("V_MA_VU_AN",V_MA_VU_AN),
                        new OracleParameter("V_TENDUONGSU",V_TENDUONGSU),
                        new OracleParameter("V_CAPXX",V_CAPXX),
                        new OracleParameter("V_TOAAN_ID", V_TOAAN_ID),
                        new OracleParameter("V_TINHTRANG_THULY",V_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("V_SOTHULY",V_SOTHULY),
                        new OracleParameter("V_THAMPHAN_ID",V_THAMPHAN_ID),
                        new OracleParameter("V_THUKY_ID",V_THUKY_ID),
                        new OracleParameter("V_LOAIDON",V_LOAIDON),
                        new OracleParameter("V_TRANGTHAIVUAN",trangThaiVuAn),
                        new OracleParameter("V_LOAIANID", loaiAnID),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_NHAP_TACH.ADS_DON_SEARCH", parameters);
            return tbl;
        }

        //Lấy danh sách các đơn chưa có quyết định kết thúc
        public DataTable DON_QUAHAN(string V_CAP_XET_XU_LOGIN, string V_TOAAN_ID, string V_DS_DONID, decimal PAGE_INDEX, decimal PAGE_SIZE)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("V_TOAAN_ID",V_TOAAN_ID),
                        new OracleParameter("V_DS_DONID",V_DS_DONID),
                        new OracleParameter("PAGE_INDEX",PAGE_INDEX),
                        new OracleParameter("PAGE_SIZE", PAGE_SIZE),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_ADS_STPT_DS_TKQUAHAN.ADS_DON_QUAHAN", parameters);
            return tbl;
        }

        //Lấy ra chi tiết các đơn quá hạn đã tạo
        public DataTable DON_QUAHAN_CHITIET(string V_CAP_XET_XU_LOGIN, string V_TOAAN_ID, string V_TK_QUAHAN_ID, string V_DS_DONID, decimal PAGE_INDEX, decimal PAGE_SIZE)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("V_TOAAN_ID",V_TOAAN_ID),
                        new OracleParameter("V_TK_QUAHAN_ID",V_TK_QUAHAN_ID),
                        new OracleParameter("V_DS_DONID",V_DS_DONID),
                        new OracleParameter("PAGE_INDEX",PAGE_INDEX),
                        new OracleParameter("PAGE_SIZE", PAGE_SIZE),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_ADS_STPT_DS_TKQUAHAN.ADS_DON_QUAHAN_CHITIET", parameters);
            return tbl;
        }

        public void CAPNHAT_DON_GOC_ID(decimal donGocID, decimal donConID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_DonGocID",donGocID),
                        new OracleParameter("v_DonConID",donConID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            Cls_Comon.GetTableByProcedurePaging("PKG_STPT_NHAPAN.ADS_UPDATE", parameters);
        }

        public bool LaNgayLamViec(DateTime date)
        {
            // Thứ 7, CN
            if (date.DayOfWeek == DayOfWeek.Saturday || date.DayOfWeek == DayOfWeek.Sunday)
                return false;

            // Ngày lễ
            if (dsNgayNghi.Contains(date.Date))
                return false;

            return true;
        }

        public void LoadNgayNghi()
        {

            String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
            using (OracleConnection conn = new OracleConnection())
            {
                conn.ConnectionString = connection_string;
                conn.Open();

                string sql = @"SELECT TRUNC(NGAYNGHI) FROM THONGTINNGHILE";

                using (OracleCommand cmd = new OracleCommand(sql, conn))
                using (OracleDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        dsNgayNghi.Add(Convert.ToDateTime(rd[0]));
                    }
                }

            }
        }
        public DateTime CongNgayLamViec(DateTime ngayVB, int soNgay)
        {
            DateTime result = ngayVB;
            int count = 0;

            while (count < soNgay)
            {
                result = result.AddDays(1);

                if (LaNgayLamViec(result))
                {
                    count++;
                }
            }

            return result;
        }
    }
}