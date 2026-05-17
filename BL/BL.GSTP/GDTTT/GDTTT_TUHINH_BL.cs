using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using BL.GSTP.BANGSETGET;

namespace BL.GSTP.GDTTT
{
    public class GDTTT_TUHINH_BL
    {
        public bool Gdttt_Tuhinh_Don_Insert_Update(GDTTT_TUHINH_DON obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_TUHINH_APP.GDTTT_TUHINH_DON_INS_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = obj.ID;
            comm.Parameters["V_VUANID"].Value = obj.VUANID;
            comm.Parameters["V_DUONGSUID"].Value = obj.DUONGSUID;
            comm.Parameters["v_hoso_id"].Value = obj.HOSO_ANGIAM_ID;
            comm.Parameters["V_NGUOIGUI"].Value = obj.NGUOIGUI;
            comm.Parameters["V_NGUOIGUI_DIACHI"].Value = obj.NGUOIGUI_DIACHI;
            comm.Parameters["V_NGUOINHAN_ID"].Value = obj.NGUOINHAN_ID;
            comm.Parameters["V_NGAYTRENDON"].Value = obj.NGAYTRENDON;
            comm.Parameters["V_NGAYNHAN"].Value = obj.NGAYNHAN;
            comm.Parameters["V_LOAI"].Value = obj.LOAI;
            comm.Parameters["V_NOIDUNG"].Value = obj.NOIDUNG;
            comm.Parameters["V_NGUOITAO_ID"].Value = obj.NGUOITAO_ID;
            comm.Parameters["V_NGUOITAO"].Value = obj.NGUOITAO;

            
            comm.Parameters["V_LOAIBA"].Value = obj.CAPXX_ID;
            comm.Parameters["V_SOANPHUCTHAM"].Value = obj.SO_BA;
            comm.Parameters["V_NGAYXUPHUCTHAM"].Value = obj.NGAY_BA;
            comm.Parameters["V_TOAPHUCTHAMID"].Value = obj.TOAXX_ID;
            comm.Parameters["V_SOANSOTHAM"].Value = obj.SO_BAST;
            comm.Parameters["V_NGAYXUSOTHAM"].Value = obj.NGAY_BAST;
            comm.Parameters["V_TOAANSOTHAM"].Value = obj.TOAXXST_ID;

            comm.Parameters["V_HOTENBC"].Value = obj.TENBIAN;
            comm.Parameters["V_NAMSINH"].Value = obj.NAMSINH;
            comm.Parameters["V_DIACHI"].Value = obj.DIACHI;
            comm.Parameters["V_TOIDANH_ID"].Value = obj.TOIDANH_ID;
            comm.Parameters["V_TENTOIDANH"].Value = obj.TENTOIDANH;

            comm.Parameters["V_NGAYPHANCONGTTV"].Value = obj.NGAYPHANCONGTTV;
            comm.Parameters["V_THAMTRAVIENID"].Value = obj.THAMTRAVIENID;
            comm.Parameters["V_TENTHAMTRAVIEN"].Value = obj.TENTHAMTRAVIEN;
            comm.Parameters["V_NgayNhanTieuHS"].Value = obj.NgayNhanTieuHS;
            comm.Parameters["V_NgayNhanHS"].Value = obj.NgayNhanHS;
            comm.Parameters["V_LANHDAOVU"].Value = obj.LANHDAOVU;
            comm.Parameters["V_THAMPHAN"].Value = obj.THAMPHAN;
           

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
            }
            finally
            {
                conn.Close();
            }
        }
        public DataTable Gdttt_Tuhinh_Don_Search(decimal Loaidon, decimal Nguoinhan, decimal Loaingay, DateTime? tungay, DateTime? denngay, string nguoigui, string diachi, 
            string soba, DateTime? ngayba, decimal toaxx, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] 
                            {
                            new OracleParameter("v_Loaidon",Loaidon),
                            new OracleParameter("v_nguoinhan",Nguoinhan),
                            new OracleParameter("v_loaingay",Loaingay),
                            new OracleParameter("v_tungay",tungay),
                            new OracleParameter("v_denngay",denngay),
                            new OracleParameter("v_nguoigui",nguoigui),
                            new OracleParameter("v_diachi",diachi),
                            new OracleParameter("v_soba",soba),
                            new OracleParameter("v_ngayba",ngayba),
                            new OracleParameter("v_toaxx",toaxx),
                            new OracleParameter("PageIndex",PageIndex),
                            new OracleParameter("PageSize",PageSize),
                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                            };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TUHINH_APP.GDTTT_TUHINH_DON_SEARCH", parameters);

            return tbl;
            //
        }
        public DataTable Gdttt_Tuhinh_Don_GetByID(Decimal _ID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
            new OracleParameter("V_ID",_ID),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TUHINH_APP.GDTTT_TUHINH_DON_GET_BY_ID", parameters);

            return tbl;

        }
        public Decimal Gdttt_Tuhinh_Don_Delete(String _ID)//,ref Int32 _Dele)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_TUHINH_APP.DELETE_GDTTT_TUHINH_DON", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = _ID;
            comm.Parameters["V_Dele"].Direction = ParameterDirection.Output;

            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();

                
            }
            catch
            {
                tran.Rollback();
            }
            finally
            {
                conn.Close();
            }
            return Convert.ToInt32(comm.Parameters["V_Dele"].Value.ToString());
        }

      
        public DataTable GDTTT_VUAN_GETALLDUONGSU(Decimal v_vuanid, Decimal v_Duongsuid)
        {
            OracleParameter[] pr = new OracleParameter[]
            {
                new OracleParameter("vVuanid",v_vuanid),
                new OracleParameter("vDuongsuid",v_Duongsuid),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TUHINH_APP.GDTTT_VUAN_GETALLDUONGSU", pr);
        }
        public bool Gdttt_Tuhinh_Vuan_Inserts(Decimal _VUAN_ID, Decimal _USER_ID,Decimal _DUONGSU_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_TUHINH_APP.GDTTT_TUHINH_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_USER_ID"].Value = _USER_ID;
            comm.Parameters["V_VUAN_ID"].Value = _VUAN_ID;
            comm.Parameters["V_DUONGSU_ID"].Value = _DUONGSU_ID;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        //-- Qua trinh xin an giam
        public bool GDTTT_TUHINH_GIAIQUYET_INSERT_UPDAT(GDTTT_GIAIQUYET_TUHINH obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_TUHINH.GDTTTT_GIAIQUYET_TUHINH_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_loailuu"].Value = obj.LOAI_UP;
            comm.Parameters["v_ID"].Value = obj.ID;

            //-- QD của CA
            comm.Parameters["v_KETLUAN_CA"].Value = obj.KELUAN_CA;
            comm.Parameters["v_SOQD_CA"].Value = obj.SOQD_CA;
            if (obj.NGAYQD_CA != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["v_NGAYQD_CA"].Value = obj.NGAYQD_CA;
            else
                comm.Parameters["v_NGAYQD_CA"].Value = null;

            comm.Parameters["v_NOIDUNG_QD_CA"].Value = obj.NOIDUNGQD_CA;
            //-- Gui VKS QD của CA

            if (obj.NGAYCV_PH_VKS != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["v_NGAYPHCV_VKS"].Value = obj.NGAYCV_PH_VKS;
            else
                comm.Parameters["v_NGAYPHCV_VKS"].Value = null;
            comm.Parameters["v_GHICHUCV_GUI"].Value = obj.GHICHUCV_GUIVKS;

            ///-- Kết luan cua VKS
            comm.Parameters["v_SOQD_VKS"].Value = obj.SOQD_VKS;
            if (obj.NGAYQD_VK != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["v_NGAYQD_VKS"].Value = obj.NGAYQD_VK;
            else
                comm.Parameters["v_NGAYQD_VKS"].Value = null;

            comm.Parameters["v_KETLUAN_VKS"].Value = obj.KETLUAN_VKS;

            comm.Parameters["v_SOTT_VKS"].Value = obj.SOTT_VKS;
            if (obj.NGAYTT_VKS != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["v_NGAYTT_VKS"].Value = obj.NGAYTT_VKS;
            else
                comm.Parameters["v_NGAYTT_VKS"].Value = null;
            comm.Parameters["v_NOIDUNGTT_VKS"].Value = obj.NOIDUNGTRINH_VKS;

            comm.Parameters["v_GHICHU_VKS_TRA"].Value = obj.GHICHU_VKS_TRA;

            //-- Chuyen VP CTN don xin an giam

            comm.Parameters["v_CTN_SOQĐ"].Value = obj.CTN_SOQD;

            if (obj.CTN_NGAYQD != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["v_CTN_NGAYQD"].Value = obj.CTN_NGAYQD;
            else
                comm.Parameters["v_CTN_NGAYQD"].Value = null;

            comm.Parameters["v_CTN_LOAIQD"].Value = obj.CTN_LOAIQD;

            if (obj.CTN_NGAYTRA != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["v_CTN_NGAYTRA"].Value = obj.CTN_NGAYTRA;
            else
                comm.Parameters["v_CTN_NGAYTRA"].Value = null;

            comm.Parameters["v_CTN_GHICHU"].Value = obj.CTN_GHICHU;

            //--Công Văn xác minh
            comm.Parameters["v_SOCVXM"].Value = obj.SOCVXM;
            if (obj.NGAYCVXM != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["v_NGAYCVXM"].Value = obj.NGAYCVXM;
            else
                comm.Parameters["v_NGAYCVXM"].Value = null;

            comm.Parameters["v_NOIDUNGXM"].Value = obj.NOIDUNGXM;



            //-- Kết quả xác minh
            comm.Parameters["v_LOAIKETQUAXM"].Value = obj.LOAIKETQUAXM;
            if (obj.NGAYKQXM != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["v_NGAYKQXM"].Value = obj.NGAYKQXM;
            else
                comm.Parameters["v_NGAYKQXM"].Value = null;
            comm.Parameters["v_NOIDUNG_KQXM"].Value = obj.NOIDUNG_KQXM;

            ////-- Theo dõi Thi hành án
            comm.Parameters["v_THA_KETQUA"].Value = obj.THA_KETQUA;
            if (obj.THA_NGAY != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["v_THA_NGAY"].Value = obj.THA_NGAY;
            else
                comm.Parameters["v_THA_NGAY"].Value = null;
            comm.Parameters["v_THA_DIADIEM"].Value = obj.THA_DIADIEM;
            comm.Parameters["v_THA_GHICHU"].Value = obj.THA_GHICHU;

            //// -- Lưu Hồ sơ
            if (obj.LUUHS_NGAYCHUYEN != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["v_LUUHS_NGAYCHUYEN"].Value = obj.LUUHS_NGAYCHUYEN;
            else
                comm.Parameters["v_LUUHS_NGAYCHUYEN"].Value = null;

            comm.Parameters["v_LUUHS_NGUOICHUYEN_ID"].Value = obj.LUUHS_NGUOICHUYEN;


            comm.Parameters["v_LUUHS_NGUOINHAN"].Value = obj.LUUHS_NGUOINHAN;
            comm.Parameters["v_LUUHS_DONVINHAN"].Value = obj.LUUHS_DONVINHAN;
            comm.Parameters["v_LUUHS_TINHTRANGHS"].Value = obj.LUUHS_TINHTRANGHS;
            comm.Parameters["v_LUUHS_GHICHU"].Value = obj.LUUHS_GHICHU;
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
            }
            finally
            {
                conn.Close();
            }
        }
        //-- Qua trinh xin an giam
        public bool GDTTT_TOTRINH_TUHINH_INSERT_UPDAT(GDTTT_TOTRINH_TUHINH obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_TUHINH.GDTTTT_TOTRINH_TUHINH", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_USER_ID"].Value = obj.USER_ID;

            comm.Parameters["V_ID"].Value = obj.ID;
            comm.Parameters["V_TUHINH_ID"].Value = obj.TUHINH_ID;


            comm.Parameters["V_SOTT"].Value = obj.SOTT;
            comm.Parameters["V_NGAYTT"].Value = obj.NGAYTT;
            comm.Parameters["V_DX_TTV"].Value = obj.DX_TTV;
            comm.Parameters["V_CAPTRINH"].Value = obj.CAPTRINH;

            comm.Parameters["V_LANHDAOID"].Value = obj.LANHDAOID;
            comm.Parameters["V_NGAYTRINH"].Value = obj.NGAYTRINH;
            if (obj.NGAYDUKIENBC != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["V_NGAYDUKIENBC"].Value = obj.NGAYDUKIENBC;
            else
                comm.Parameters["V_NGAYDUKIENBC"].Value = null;

            if (obj.NGAYNHANTT != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["V_NGAYNHANTT"].Value = obj.NGAYNHANTT;
            else
                comm.Parameters["V_NGAYNHANTT"].Value = null;

            if (obj.NGAYTRATT != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["V_NGAYTRATT"].Value = obj.NGAYTRATT;
            else
                comm.Parameters["V_NGAYTRATT"].Value = null;

            comm.Parameters["V_LOAIYK"].Value = obj.LOAIYK;
            comm.Parameters["V_NOIDUNGYKIEN"].Value = obj.NOIDUNGYKIEN;
            comm.Parameters["V_CAPTRINHTIEP"].Value = obj.CAPTRINHTIEP;
            comm.Parameters["V_TRINHTIEP_LANHDAO_ID"].Value = obj.TRINHTIEP_LANHDAO_ID;
            comm.Parameters["V_GHICHU"].Value = obj.GHICHU;



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
            }
            finally
            {
                conn.Close();
            }
        }


        public bool GDTTT_TOTRINH_TUHINH_DELETE(GDTTT_TOTRINH_TUHINH obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_TUHINH.GDTTTT_DELETE_TTTH", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_id"].Value = obj.ID;
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
            }
            finally
            {
                conn.Close();
            }
        }
        //-- Lay danh sach cac vu an tu hinh vToaAnID       
        public DataTable DUONGSU_TUHINH_SEARCH(string V_COLUME, string V_ASC_DESC, decimal vid, decimal v_Hosoangiam, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD
             , DateTime? vNgayBAQD, decimal vLoaiBanAn, string vBian
             , DateTime? vNgayTaoTu, DateTime? vNgayTaoDen
             , decimal PageIndex, decimal PageSize)
        {

            if (vNgayTaoTu == DateTime.MinValue) vNgayTaoTu = null;
            if (vNgayTaoDen == DateTime.MinValue) vNgayTaoDen = null;

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("v_colume",V_COLUME),
                                                                        new OracleParameter("v_asc_desc",V_ASC_DESC),
                                                                        new OracleParameter("V_ID",vid),
                                                                        new OracleParameter("vHosoangiam",v_Hosoangiam),
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter ("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vLoaiBanAn",vLoaiBanAn),
                                                                        new OracleParameter("vBian",vBian),
                                                                        new OracleParameter("vtungay",vNgayTaoTu),
                                                                        new OracleParameter("vdenngay",vNgayTaoDen),

                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_TUHINH.GDTTTT_DUONGSU_TUHINH_SEARCH", parameters);

            return tbl;

        }
        public DataTable HOSO_TUHINH_SEARCH(string V_COLUME, string V_ASC_DESC, decimal vid, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD
            , DateTime? vNgayBAQD, decimal vLoaiBanAn, string vBian
            , DateTime? vNgayTaoTu, DateTime? vNgayTaoDen
            , decimal PageIndex, decimal PageSize)
        {

            if (vNgayTaoTu == DateTime.MinValue) vNgayTaoTu = null;
            if (vNgayTaoDen == DateTime.MinValue) vNgayTaoDen = null;

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("v_colume",V_COLUME),
                                                                        new OracleParameter("v_asc_desc",V_ASC_DESC),
                                                                        new OracleParameter("V_ID",vid),
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter ("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vLoaiBanAn",vLoaiBanAn),
                                                                        new OracleParameter("vBian",vBian),
                                                                        new OracleParameter("vtungay",vNgayTaoTu),
                                                                        new OracleParameter("vdenngay",vNgayTaoDen),


                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_TUHINH.GDTTTT_HOSO_TUHINH_SEARCH", parameters);

            return tbl;

        }
        /// <summary>
        /// danh sach to trinh
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public DataTable DSTOTRINH_TUHINH(decimal id, decimal hs_id)
        {


            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_ID",id),
                                                                        new OracleParameter("V_HoSo_ID",hs_id),

                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_TUHINH.GDTTTT_DSTOTRINH_TUHINH", parameters);

            return tbl;

        }
        public DataTable VUAN_TUHINH_TOTRINH(decimal vVuAnID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vHosoID",vVuAnID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("GET_GDTTT_TOTRINH_TUHINH", prm);
        }

        public Decimal HOSO_TUHINH_BY_DUONGSUID(decimal vDuongsuID)
        {
            
            int res = 0;
            string query = "SELECT COUNT(*) FROM GDTTT_TUHINH_VUAN WHERE DUONGSU_ID = '" + vDuongsuID + "'";
            OracleConnection conn =  Cls_Comon.OpenConnection();
            try
            {
             
                OracleCommand cmd = new OracleCommand();
                cmd.Connection = conn;
                cmd.CommandText = query;
                cmd.CommandType = CommandType.Text;
                res = int.Parse(cmd.ExecuteScalar().ToString());
                return res;
            }
            catch (Exception ex)
            {
                return res;
            }
            finally
            {
                conn.Close();
            }

        }
        public Decimal HOSO_TUHINH_BY_VUANID(decimal vVuanID)
        {

            int res = 0;
            string query = "select count(*) from gdttt_vuan "+
                "where(EXISTS(select id from GDTTT_TUHINH_VUAN  where VUAN_ID ="+ vVuanID + ")" +
                            "or EXISTS(select id from GDTTT_TUHINH_DON d where d.VUANID = "+ vVuanID + "))"+
                        "and id=" + vVuanID;
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {

                OracleCommand cmd = new OracleCommand();
                cmd.Connection = conn;
                cmd.CommandText = query;
                cmd.CommandType = CommandType.Text;
                res = int.Parse(cmd.ExecuteScalar().ToString());
                return res;
            }
            catch (Exception ex)
            {
                return res;
            }
            finally
            {
                conn.Close();
            }

        }

        public Decimal Gdttt_Tuhinh_HoSo_Delete(decimal _ID)//,ref Int32 _Dele)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_TUHINH.DELETE_GDTTT_TUHINH_VUAN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = _ID;
            comm.Parameters["V_Dele"].Direction = ParameterDirection.Output;

            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();


            }
            catch
            {
                tran.Rollback();
            }
            finally
            {
                conn.Close();
            }
            return Convert.ToInt32(comm.Parameters["V_Dele"].Value.ToString());
        }
        public Decimal Gdttt_Tuhinh_HoSo_Insert(decimal _DUONGSU_ID, decimal _VUANID, decimal _NGUOITAO)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_TUHINH.GDTTT_TUHINH_HOSO_IN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_VUANID"].Value = _VUANID;
            comm.Parameters["v_duongsu_id"].Value = _DUONGSU_ID;
            comm.Parameters["V_NGUOITAO_ID"].Value = _NGUOITAO;
            comm.Parameters["vInsert"].Direction = ParameterDirection.Output;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
            }
            catch (Exception ex)
            {
                tran.Rollback();
            }
            finally
            {
                conn.Close();
            }
            return Convert.ToInt32(comm.Parameters["vInsert"].Value.ToString());
        }

        public DataTable GetDonByDuongsu(decimal _Vuanid,decimal _Duongsuid)
        {

            OracleParameter[] prm = new OracleParameter[]
            {

                new OracleParameter("v_VuAnID",_Vuanid)
                ,new OracleParameter("v_DuongsuID",_Duongsuid)
                ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("GDTTT_DON_GETBYDUONGSU", prm);
        }

        public DataTable GetDonVu1ByDuongsu(decimal _Vuanid, decimal _Duongsuid)
        {

            OracleParameter[] prm = new OracleParameter[]
            {

                new OracleParameter("v_VuAnID",_Vuanid)
                ,new OracleParameter("v_DuongsuID",_Duongsuid)
                ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("GDTTT_DONVU1_GETBYDUONGSU", prm);
        }

        public DataTable SearchDanhSachVuAn(string _SoBA, DateTime _NgayBA, decimal _Toaxx,decimal _LoaiBA)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vLoaiBanAn",_LoaiBA)
                ,new OracleParameter("vSoBAQD",_SoBA)
                ,new OracleParameter("vNgayBAQD",_NgayBA)
                , new OracleParameter("vToaRaBAQD",_Toaxx)
                ,new OracleParameter("PageIndex",1)
                , new OracleParameter("PageSize",20)
                ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_TUHINH.GDTTT_SEARCH_VUAN_TUHINH", prm);
        }

    }
}