using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System.Data;
using System.Globalization;

namespace BL.GSTP.QLHS
{
    public class QLHS_BL
    {

        CultureInfo cul = new CultureInfo("vi-VN");
        public DataTable GetQLHS(decimal Capxetxu, decimal Loaian, string vNgayThuLy, string vSoBA, string vNgayBA, string vThamPhanChuToa, string vThuKy, string vNguyenDon, string vBiDon, decimal DonViID, string MaVuViec, string TenVuViec, string TuNgay, string DenNgay, decimal TrangThai, List<string> lstTrangThai, int PageIndex, int PageSize)
        {

            DataTable dt = new DataTable();
            if (Loaian == 0 || Loaian == 2)
            {
                var dt_ADS = GetQLHS_ADS(Capxetxu, Loaian, vNgayThuLy, vSoBA, vNgayBA, vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, DonViID, MaVuViec, TenVuViec, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_ADS != null && dt_ADS.Rows.Count > 0)
                {
                    dt.Merge(dt_ADS);
                }
            }

            if (Loaian == 0 || Loaian == 1)
            {

                var dt_AHS = GetQLHS_AHS(Capxetxu, Loaian, vNgayThuLy, vSoBA, vNgayBA, vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, DonViID, MaVuViec, TenVuViec, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_AHS != null && dt_AHS.Rows.Count > 0)
                {
                    dt.Merge(dt_AHS);
                }
            }

            if (Loaian == 0 || Loaian == 6)
            {
                var dt_AHC = GetQLHS_AHC(Capxetxu, Loaian, vNgayThuLy, vSoBA, vNgayBA, vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, DonViID, MaVuViec, TenVuViec, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_AHC != null && dt_AHC.Rows.Count > 0)
                {
                    dt.Merge(dt_AHC);
                }
            }

            if (Loaian == 0 || Loaian == 3)
            {
                var dt_AHN = GetQLHS_AHN(Capxetxu, Loaian, vNgayThuLy, vSoBA, vNgayBA, vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, DonViID, MaVuViec, TenVuViec, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_AHN != null && dt_AHN.Rows.Count > 0)
                {
                    dt.Merge(dt_AHN);
                }
            }

            if (Loaian == 0 || Loaian == 4)
            {
                var dt_AKT = GetQLHS_AKT(Capxetxu, Loaian, vNgayThuLy, vSoBA, vNgayBA, vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, DonViID, MaVuViec, TenVuViec, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_AKT != null && dt_AKT.Rows.Count > 0)
                {
                    dt.Merge(dt_AKT);
                }
            }

            if (Loaian == 0 || Loaian == 5)
            {
                var dt_ALD = GetQLHS_ALD(Capxetxu, Loaian, vNgayThuLy, vSoBA, vNgayBA, vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, DonViID, MaVuViec, TenVuViec, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_ALD != null && dt_ALD.Rows.Count > 0)
                {
                    dt.Merge(dt_ALD);
                }
            }

            if (Loaian == 0 || Loaian == 7)
            {
                var dt_APS = GetQLHS_APS(Capxetxu, Loaian, vNgayThuLy, vSoBA, vNgayBA, vThamPhanChuToa, vThuKy, vNguyenDon, vBiDon, DonViID, MaVuViec, TenVuViec, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_APS != null && dt_APS.Rows.Count > 0)
                {
                    dt.Merge(dt_APS);
                }
            }

            if (dt.Rows.Count > 0)
            {
                dt.Rows[0]["CountAll"] = dt.Rows.Count;
                if (dt.Columns.Contains("STT"))
                {

                    //for (int i = 0; i < dt.Rows.Count; i++)
                    //{ 
                    //    var TRANGTHAIHOSO = "" + dt.Rows[i]["TRANGTHAIHOSO"];

                    //    if (lstTrangThai.Count > 0)
                    //    {
                    //        if (!lstTrangThai.Contains(TRANGTHAIHOSO))
                    //        {
                    //            dt.Rows.RemoveAt(i);

                    //        }
                    //    }
                    //}
                    foreach (DataRow row in dt.Rows)
                    {
                        var TRANGTHAIHOSO = "" + row["TRANGTHAIHOSO"];

                        if (lstTrangThai.Count > 0)
                        {
                            if (!lstTrangThai.Contains(TRANGTHAIHOSO))
                            {
                                row.Delete();

                            }
                        }
                    }
                    dt.AcceptChanges();
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        dt.Rows[i]["CountAll"] = dt.Rows.Count;
                        dt.Rows[i]["STT"] = i + 1;

                        var TRANGTHAI = "" + dt.Rows[i]["TRANGTHAIHOSO"];

                        if (TRANGTHAI != "3")
                        {
                            dt.Rows[i]["NGAYGIAONHANHOSO"] = "";
                            dt.Rows[i]["TENDONVINHANHOSO"] = "";
                        }

                        //< asp:BoundColumn DataField = "NGAYGIAONHANHOSO" HeaderText = "Ngày chuyển" HeaderStyle - HorizontalAlign = "Center" ></ asp:BoundColumn >

                        //                          < asp:BoundColumn DataField = "TENDONVINHANHOSO" HeaderText = "Đơn vị chuyển" HeaderStyle - HorizontalAlign = "Center" ></ asp:BoundColumn >
                    }
                }
                dt.AcceptChanges();
                var pagecur = PageIndex - 1;
                if (pagecur <= 0)
                {
                    pagecur = 0;
                }
                if (dt.Rows.Count > 0)
                {
                    dt = dt.AsEnumerable().Skip(pagecur * PageSize).Take(PageSize).CopyToDataTable();
                }
                else
                {
                    dt = new DataTable();
                }
            }
            try
            {

                if (dt.Rows.Count > 0)
                {
                    DataColumn workCol = dt.Columns.Add("TRANGTHAIHOSO_LICHSU", typeof(Int32));
                    workCol.AllowDBNull = true; 

                    //dt.Columns.Add("LICHSU_TENTRANGTHAIHOSO", typeof(String));
                    //dt.Columns.Add("LICHSU_NGAYGIAONHANHOSO", typeof(String));
                    //dt.Columns.Add("LICHSU_TENDONVINHANHOSO", typeof(String));

                }
                GSTPContext content = new GSTPContext();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dt.Rows[i]["TRANGTHAIHOSO_LICHSU"] = 0;
                    var IDVuViec = decimal.Parse("0" + dt.Rows[i]["ID"]);
                    var LOAIAN = decimal.Parse("0" + dt.Rows[i]["LOAIAN"]);
                    var MAGIAIDOAN = decimal.Parse("0" + dt.Rows[i]["MAGIAIDOAN"]);


                    QLHS_STPT oTSTPT = content.QLHS_STPT.Where(x => x.VUVIECID == IDVuViec && x.LOAIAN == LOAIAN && x.CAPXX == MAGIAIDOAN).FirstOrDefault();

                    if (oTSTPT != null)
                    {
                        //laays trang thai lich su cuoi dung
                        var lichsu = content.QLHS_STPT_LICHSU.Where(t => t.MAHS == oTSTPT.ID).OrderByDescending(t => t.NGAYGIAONHAN).ThenByDescending(t => t.ID).FirstOrDefault();
                        if (lichsu != null && lichsu.TRANGTHAIID == 1) //phieeus muownj
                        {
                            dt.Rows[i]["TRANGTHAIHOSO_LICHSU"] = lichsu.TRANGTHAIID;
                            if (lichsu.NGAYGIAONHAN.HasValue)
                            {
                                dt.Rows[i]["NGAYGIAONHANHOSO"] = lichsu.NGAYGIAONHAN.Value.ToString("dd/MM/yyyy");
                                dt.Rows[i]["TENDONVINHANHOSO"] = lichsu.DONVIMUON;
                            }
                        }
                    } 

                }
            }
            catch
            {

            }

            return dt;
        }
        private DataTable GetQLHS_ADS(decimal Capxetxu, decimal Loaian, string vNgayThuLy, string vSoBA, string vNgayBA, string vThamPhanChuToa, string vThuKy, string vNguyenDon, string vBiDon, decimal DonViID, string MaVuViec, string TenVuViec, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vCapxx",Capxetxu),
                new OracleParameter("vLoaian",Loaian),
                new OracleParameter("vNgayThuLy",vNgayThuLy),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vThamPhanChuToa",vThamPhanChuToa),
                new OracleParameter("vThuKy",vThuKy),
                new OracleParameter("vNguyenDon",vNguyenDon),
                new OracleParameter("vBiDon",vBiDon),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYHOSOAN_ADS", parameter);
            return tbl;
        }
        private DataTable GetQLHS_AHN(decimal Capxetxu, decimal Loaian, string vNgayThuLy, string vSoBA, string vNgayBA, string vThamPhanChuToa, string vThuKy, string vNguyenDon, string vBiDon, decimal DonViID, string MaVuViec, string TenVuViec, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vCapxx",Capxetxu),
                new OracleParameter("vLoaian",Loaian),
                new OracleParameter("vNgayThuLy",vNgayThuLy),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vThamPhanChuToa",vThamPhanChuToa),
                new OracleParameter("vThuKy",vThuKy),
                new OracleParameter("vNguyenDon",vNguyenDon),
                new OracleParameter("vBiDon",vBiDon),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYHOSOAN_AHN", parameter);
            return tbl;
        }
        private DataTable GetQLHS_AKT(decimal Capxetxu, decimal Loaian, string vNgayThuLy, string vSoBA, string vNgayBA, string vThamPhanChuToa, string vThuKy, string vNguyenDon, string vBiDon, decimal DonViID, string MaVuViec, string TenVuViec, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vCapxx",Capxetxu),
                new OracleParameter("vLoaian",Loaian),
                new OracleParameter("vNgayThuLy",vNgayThuLy),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vThamPhanChuToa",vThamPhanChuToa),
                new OracleParameter("vThuKy",vThuKy),
                new OracleParameter("vNguyenDon",vNguyenDon),
                new OracleParameter("vBiDon",vBiDon),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYHOSOAN_AKT", parameter);
            return tbl;
        }
        private DataTable GetQLHS_ALD(decimal Capxetxu, decimal Loaian, string vNgayThuLy, string vSoBA, string vNgayBA, string vThamPhanChuToa, string vThuKy, string vNguyenDon, string vBiDon, decimal DonViID, string MaVuViec, string TenVuViec, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vCapxx",Capxetxu),
                new OracleParameter("vLoaian",Loaian),
                new OracleParameter("vNgayThuLy",vNgayThuLy),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vThamPhanChuToa",vThamPhanChuToa),
                new OracleParameter("vThuKy",vThuKy),
                new OracleParameter("vNguyenDon",vNguyenDon),
                new OracleParameter("vBiDon",vBiDon),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYHOSOAN_ALD", parameter);
            return tbl;
        }
        private DataTable GetQLHS_AHC(decimal Capxetxu, decimal Loaian, string vNgayThuLy, string vSoBA, string vNgayBA, string vThamPhanChuToa, string vThuKy, string vNguyenDon, string vBiDon, decimal DonViID, string MaVuViec, string TenVuViec, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vCapxx",Capxetxu),
                new OracleParameter("vLoaian",Loaian),
                new OracleParameter("vNgayThuLy",vNgayThuLy),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vThamPhanChuToa",vThamPhanChuToa),
                new OracleParameter("vThuKy",vThuKy),
                new OracleParameter("vNguyenDon",vNguyenDon),
                new OracleParameter("vBiDon",vBiDon),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYHOSOAN_AHC", parameter);
            return tbl;
        }
        private DataTable GetQLHS_APS(decimal Capxetxu, decimal Loaian, string vNgayThuLy, string vSoBA, string vNgayBA, string vThamPhanChuToa, string vThuKy, string vNguyenDon, string vBiDon, decimal DonViID, string MaVuViec, string TenVuViec, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vCapxx",Capxetxu),
                new OracleParameter("vLoaian",Loaian),
                new OracleParameter("vNgayThuLy",vNgayThuLy),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vThamPhanChuToa",vThamPhanChuToa),
                new OracleParameter("vThuKy",vThuKy),
                new OracleParameter("vNguyenDon",vNguyenDon),
                new OracleParameter("vBiDon",vBiDon),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYHOSOAN_APS", parameter);
            return tbl;
        }
        private DataTable GetQLHS_AHS(decimal Capxetxu, decimal Loaian, string vNgayThuLy, string vSoBA, string vNgayBA, string vThamPhanChuToa, string vThuKy, string vNguyenDon, string vBiDon, decimal DonViID, string MaVuViec, string TenVuViec, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vCapxx",Capxetxu),
                new OracleParameter("vLoaian",Loaian),
                new OracleParameter("vNgayThuLy",vNgayThuLy),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vThamPhanChuToa",vThamPhanChuToa),
                new OracleParameter("vThuKy",vThuKy),
                new OracleParameter("vNguyenDon",vNguyenDon),
                new OracleParameter("vBiDon",vBiDon),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYHOSOAN_AHS", parameter);
            return tbl;
        }
        public bool QLHOSO_INS_UP(String V_TRANGTHAI, String V_VUVIECID, String v_LOAIAN, String V_NGUOICHUYEN_ID, String V_TENNGUOICHUYEN,
                        String V_NGUOINHAN_ID, String V_TENNGUOINHAN, String V_SOBUTLUC, String V_GHICHU, string V_NGUOITAO, string V_NGUOISUA, ref Decimal V_COUNTS, ref String V_THONGBAO)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_DS.QLHOSO_INS_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TRANGTHAI"].Value = V_TRANGTHAI;
            comm.Parameters["V_VUVIECID"].Value = V_VUVIECID;
            comm.Parameters["v_LOAIAN"].Value = v_LOAIAN;
            comm.Parameters["V_NGUOICHUYEN_ID"].Value = V_NGUOICHUYEN_ID;
            comm.Parameters["V_TENNGUOICHUYEN"].Value = V_TENNGUOICHUYEN;
            comm.Parameters["V_NGUOINHAN_ID"].Value = V_NGUOINHAN_ID;
            comm.Parameters["V_TENNGUOINHAN"].Value = V_TENNGUOINHAN;
            comm.Parameters["V_SOBUTLUC"].Value = V_SOBUTLUC;
            comm.Parameters["V_GHICHU"].Value = V_GHICHU;
            comm.Parameters["V_NGUOITAO"].Value = V_NGUOITAO;
            comm.Parameters["V_NGUOISUA"].Value = V_NGUOISUA;
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
        public void Delete(int id)
        {
        }


        public void InsertHoSoLuTruCoChuyenAn(decimal IDVuViec, string STRLOAIAN, DateTime? NgayGiaoNhan, decimal TrangThaiId, string NguoiTao, decimal NGUOICHUYENID, string TENNGUOICHUYEN, decimal? DONVIID, string TENDONVINHAN)
        {
            try
            {
                decimal? Capxx = 2;

                GSTPContext dt = new GSTPContext();

                var LOAIAN = int.Parse(STRLOAIAN);

                if (LOAIAN == 2)
                {
                    var oDon = dt.ADS_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;
                }

                if (LOAIAN == 1)
                {
                    var oDon = dt.AHS_VUAN.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;
                }

                if (LOAIAN == 6)
                {

                    var oDon = dt.AHC_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;
                }

                if (LOAIAN == 3)
                {
                    var oDon = dt.AHN_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;
                }

                if (LOAIAN == 4)
                {
                    var oDon = dt.AKT_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;

                }

                if (LOAIAN == 5)
                {
                    var oDon = dt.ALD_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;
                }

                if (LOAIAN == 7)
                {
                    var oDon = dt.APS_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;
                }




                QLHS_STPT oT = dt.QLHS_STPT.Where(x => x.VUVIECID == IDVuViec && x.LOAIAN == LOAIAN && x.CAPXX == Capxx).FirstOrDefault();

                if (oT == null)
                {
                    oT = new QLHS_STPT();
                    oT.VUVIECID = IDVuViec;
                    oT.CAPXX = Capxx;
                    oT.LOAIAN = LOAIAN;
                    oT.GHICHU = "Chuyển án";

                    oT.NGAYGIAONHAN = NgayGiaoNhan;


                    oT.TRANGTHAIID = TrangThaiId;
                    oT.NGUOITAO = NguoiTao;
                    // oT.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");

                    oT.NGAYTAO = DateTime.Now;
                    dt.QLHS_STPT.Add(oT);

                    oT.NGUOICHUYENID = NGUOICHUYENID;
                    oT.TENNGUOICHUYEN = TENNGUOICHUYEN;

                    oT.DONVIID = DONVIID;
                    oT.TENDONVI = TENDONVINHAN;

                    oT.NGAYTAO = DateTime.Now;
                    dt.QLHS_STPT.Add(oT);
                    dt.SaveChanges();
                }
            }
            catch
            {


            }

        }


        public void DeleteHoSoLuTruCoChuyenAn(decimal IDVuViec, string STRLOAIAN)
        {
            try
            {
                decimal? Capxx = 2;

                GSTPContext dt = new GSTPContext();

                var LOAIAN = int.Parse(STRLOAIAN);

                if (LOAIAN == 2)
                {
                    var oDon = dt.ADS_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;
                }

                if (LOAIAN == 1)
                {
                    var oDon = dt.AHS_VUAN.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;
                }

                if (LOAIAN == 6)
                {

                    var oDon = dt.AHC_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;
                }

                if (LOAIAN == 3)
                {
                    var oDon = dt.AHN_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;
                }

                if (LOAIAN == 4)
                {
                    var oDon = dt.AKT_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;

                }

                if (LOAIAN == 5)
                {
                    var oDon = dt.ALD_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;
                }

                if (LOAIAN == 7)
                {
                    var oDon = dt.APS_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon != null) Capxx = oDon.MAGIAIDOAN;
                }




                QLHS_STPT oT = dt.QLHS_STPT.Where(x => x.VUVIECID == IDVuViec && x.LOAIAN == LOAIAN && x.CAPXX == Capxx).FirstOrDefault();

                if (oT != null)
                {
                    dt.QLHS_STPT.Remove(oT);
                    dt.SaveChanges();
                }
            }
            catch
            {


            }

        }
    }
}