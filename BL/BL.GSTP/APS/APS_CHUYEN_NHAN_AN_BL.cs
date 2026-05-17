using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.APS
{
    public class APS_CHUYEN_NHAN_AN_BL
    {
        GSTPContext dt = new GSTPContext();
        public DataTable APS_CHUYEN_NHAN_AN_GETCHUYEN()
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("APS_CHUYEN_NHAN_AN_GETCHUYEN", prm);
        }
        //public string Check_NhanAn(decimal DonID, string Message_Ex)
        //{
        //    string Result = "";
        //    APS_CHUYEN_NHAN_AN ObjNhan = dt.APS_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonID).FirstOrDefault();
        //    if (ObjNhan != null)
        //    {
        //        if (ObjNhan.TRANGTHAI == 1) // Đã nhận
        //        {
        //            Result = "Án đã được ";
        //            DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
        //            if (ObjToaAn != null)
        //            {
        //                Result += ObjToaAn.MA_TEN;
        //            }
        //            Result += " nhận. " + Message_Ex;
        //        }
        //    }
        //    return Result;
        //}

        public string Check_NhanAn(decimal DonID, string Message_Ex, decimal? toaAnId = null)
        {
            string Result = "";
            APS_CHUYEN_NHAN_AN ObjNhan = dt.APS_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonID && x.TRANGTHAI == 1).OrderByDescending(x => x.ID).FirstOrDefault();
            if (ObjNhan != null)
            {
                if (toaAnId != null)
                {
                    if (ObjNhan.MAP_VUANID_NEW > 0)
                    {
                        APS_CHUYEN_NHAN_AN ObjNhanPTTDC = dt.APS_CHUYEN_NHAN_AN.Where(x => x.VUANID == ObjNhan.MAP_VUANID_NEW && x.TRANGTHAI == 1 && x.ID > ObjNhan.ID).FirstOrDefault();
                        if (ObjNhanPTTDC != null)
                        {
                            APS_DON donPT = dt.APS_DON.Where(x => x.ID == ObjNhan.MAP_VUANID_NEW).FirstOrDefault();
                            if (donPT.MAGIAIDOAN != ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                            {
                                Result = "Án đã được ";
                                DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
                                if (ObjToaAn != null)
                                {
                                    Result += ObjToaAn.MA_TEN;
                                }
                                Result += " nhận. " + Message_Ex;
                            }

                        }
                        else
                        {
                            Result = "Án đã được ";
                            DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
                            if (ObjToaAn != null)
                            {
                                Result += ObjToaAn.MA_TEN;
                            }
                            Result += " nhận. " + Message_Ex;
                        }
                    }
                    else if (ObjNhan.TOANHANID != toaAnId) // Đã nhận
                    {
                        Result = "Án đã được ";
                        DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
                        if (ObjToaAn != null)
                        {
                            Result += ObjToaAn.MA_TEN;
                        }
                        Result += " nhận. " + Message_Ex;
                    }
                    else if (ObjNhan.TRANGTHAI == 0)
                    {
                        Result = "Án đã được ";
                        DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
                        if (ObjToaAn != null)
                        {
                            Result += ObjToaAn.MA_TEN;
                        }
                        Result += " nhận. " + Message_Ex;
                    }

                }
                else
                {
                    Result = "Án đã được ";
                    DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
                    if (ObjToaAn != null)
                    {
                        Result += ObjToaAn.MA_TEN;
                    }
                    Result += " nhận. " + Message_Ex;
                }
            }
            return Result;



        }
        public string Check_ChuyenNhanAn(decimal DonID, string Message_Ex, decimal? toaAnId = null)
        {
            string Result = "";
            APS_CHUYEN_NHAN_AN ObjNhan = dt.APS_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonID && (x.TRANGTHAI == 1 || x.TRANGTHAI == 0)).OrderByDescending(x => x.ID).FirstOrDefault();
            if (ObjNhan != null)
            {
                if (toaAnId != null)
                {
                    if (ObjNhan.MAP_VUANID_NEW > 0)
                    {
                        APS_CHUYEN_NHAN_AN ObjNhanPTTDC = dt.APS_CHUYEN_NHAN_AN.Where(x => x.VUANID == ObjNhan.MAP_VUANID_NEW && x.TRANGTHAI == 1 && x.ID > ObjNhan.ID).FirstOrDefault();
                        if (ObjNhanPTTDC != null)
                        {
                            APS_DON donPT = dt.APS_DON.Where(x => x.ID == ObjNhan.MAP_VUANID_NEW).FirstOrDefault();
                            if (donPT.MAGIAIDOAN != ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                            {
                                Result = "Án đã được ";
                                DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
                                if (ObjToaAn != null)
                                {
                                    Result += ObjToaAn.MA_TEN;
                                }
                                Result += " nhận. " + Message_Ex;
                            }

                        }
                        else
                        {
                            Result = "Án đã được ";
                            DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
                            if (ObjToaAn != null)
                            {
                                Result += ObjToaAn.MA_TEN;
                            }
                            Result += " nhận. " + Message_Ex;
                        }
                    }
                    else if (ObjNhan.TOANHANID != toaAnId) // Đã nhận
                    {
                        Result = "Án đã được ";
                        DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
                        if (ObjToaAn != null)
                        {
                            Result += ObjToaAn.MA_TEN;
                        }
                        Result += " nhận. " + Message_Ex;
                    }
                    else if (ObjNhan.TRANGTHAI == 0)
                    {
                        Result = "Án đã được ";
                        DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
                        if (ObjToaAn != null)
                        {
                            Result += ObjToaAn.MA_TEN;
                        }
                        Result += " nhận. " + Message_Ex;
                    }

                }
                else
                {
                    Result = "Án đã được ";
                    DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
                    if (ObjToaAn != null)
                    {
                        Result += ObjToaAn.MA_TEN;
                    }
                    Result += " nhận. " + Message_Ex;
                }
            }
            return Result;



        }

        public decimal getDonIdOld(decimal donId)
        {
            APS_CHUYEN_NHAN_AN APS_CHUYEN_NHAN_AN = dt.APS_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == donId).FirstOrDefault();
            if (APS_CHUYEN_NHAN_AN != null)
                return APS_CHUYEN_NHAN_AN.VUANID.Value;
            return donId;

        }
        public bool UPDATE_NOIDUNG_CHUYENNHANAN(decimal ChuyenNhanId, string NoiDung, decimal DonId)
        {

            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_APS_GS.UPDATE_NOIDUNG_CHUYENNHANAN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["VNHANANID"].Value = ChuyenNhanId;
            comm.Parameters["VNOIDUNG"].Value = NoiDung;
            comm.Parameters["V_VUANID"].Value = DonId;
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
        public bool CheckCoKcKnTamDinhChi(decimal DonId)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_APS_GS.COUNT_KCKN_TDC", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["VOUT"].Direction = ParameterDirection.Output;
            comm.Parameters["VDONID"].Value = DonId;
            decimal rsCount = 0;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
            }
            catch (Exception e)
            {
                tran.Rollback();
            }
            finally
            {
                rsCount = Convert.ToDecimal(comm.Parameters["VOUT"].Value);
                conn.Close();

            }
            return rsCount > 0 ? true : false;
        }
        public bool CheckIsReadOnlyThuLyST(decimal ThuLyId, decimal DonId, decimal ToaAnId)
        {
            APS_SOTHAM_THULY oThuLyST = dt.APS_SOTHAM_THULY.Where(x => x.ID == ThuLyId).FirstOrDefault();
            APS_CHUYEN_NHAN_AN oChuyenAn = dt.APS_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonId && x.TOACHUYENID == ToaAnId).OrderByDescending(x => x.ID).FirstOrDefault();

            if (oChuyenAn != null && oChuyenAn.NGAYTAO >= oThuLyST.NGAYTAO)
                return true;
            return false;
        }
        public bool CheckIsReadOnlyNguoiTTTTST(decimal Id, decimal DonId, decimal ToaAnId)
        {
            APS_SOTHAM_HDXX oB = dt.APS_SOTHAM_HDXX.Where(x => x.ID == Id).FirstOrDefault();
            APS_CHUYEN_NHAN_AN oChuyenAn = dt.APS_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonId && x.TOACHUYENID == ToaAnId).OrderByDescending(x => x.ID).FirstOrDefault();
            if (oChuyenAn != null && oChuyenAn.NGAYTAO >= oB.NGAYTAO)
                return true;
            return false;
        }
        public bool CheckIsReadOnlyThamPhanST(decimal Id, decimal DonId, decimal ToaAnId)
        {
            APS_DON_THAMPHAN oB = dt.APS_DON_THAMPHAN.Where(x => x.ID == Id).FirstOrDefault();
            APS_CHUYEN_NHAN_AN oChuyenAn = dt.APS_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonId && x.TOACHUYENID == ToaAnId).OrderByDescending(x => x.ID).FirstOrDefault();
            if (oChuyenAn != null && oChuyenAn.NGAYTAO >= oB.NGAYTAO)
                return true;
            return false;
        }
    }
}