using BL.GSTP.BANGSETGET.AHS;
using BL.GSTP.BANGSETGET;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Linq;
using System.Collections.Generic;

namespace BL.GSTP.AHS
{
    public class AHS_CHUYEN_NHAN_AN_BL
    {
        private GSTPContext dt = new GSTPContext();

        public DataTable AHS_CHUYEN_NHAN_AN_GETCHUYEN()
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("AHS_CHUYEN_NHAN_AN_GETCHUYEN", prm);
        }

        public string Check_NhanAn(decimal VuAnID, string Message_Ex)
        {
            string Result = "";
            AHS_CHUYEN_NHAN_AN ObjNhan = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
            if (ObjNhan != null)
            {
                if (ObjNhan.TRANGTHAI == 1) // Đã nhận
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

        public string Check_NhanAn(decimal VuAnID, string Message_Ex, decimal? toaAnId = null)
        {
            if (VuAnID == 0)
                return "";
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("V_VUANID", VuAnID),
                    new OracleParameter("V_TOAANID", toaAnId),
                    new OracleParameter("V_MESSAGE", Message_Ex),
                };
                string dbl = Cls_Comon.ExcuteProcResultString("PKG_STPT_AHS_GS2.AHS_CHECK_NHAN_AN", parameters);
                return dbl ?? "";
            }
            catch (Exception ex) { return ""; }

            #region for code

            //string Result = "";
            //AHS_CHUYEN_NHAN_AN ObjNhan = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID && x.TRANGTHAI == 1).OrderByDescending(x => x.ID).FirstOrDefault();
            //if (ObjNhan != null)
            //{
            //    if (toaAnId != null)
            //    {
            //        if (ObjNhan.MAP_VUANID_NEW > 0)
            //        {
            //            AHS_CHUYEN_NHAN_AN ObjNhanPTTDC = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == ObjNhan.MAP_VUANID_NEW && x.TRANGTHAI == 1 && x.ID > ObjNhan.ID).FirstOrDefault();
            //            if (ObjNhanPTTDC != null)
            //            {
            //                AHS_VUAN donPT = dt.AHS_VUAN.Where(x => x.ID == ObjNhan.MAP_VUANID_NEW).FirstOrDefault();
            //                if (donPT.MAGIAIDOAN != ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
            //                {
            //                    Result = "Án đã được ";
            //                    DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
            //                    if (ObjToaAn != null)
            //                    {
            //                        Result += ObjToaAn.MA_TEN;
            //                    }
            //                    Result += " nhận. " + Message_Ex;
            //                }
            //            }
            //            else
            //            {
            //                Result = "Án đã được ";
            //                DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
            //                if (ObjToaAn != null)
            //                {
            //                    Result += ObjToaAn.MA_TEN;
            //                }
            //                Result += " nhận. " + Message_Ex;
            //            }
            //        }
            //        else if (ObjNhan.TOANHANID != toaAnId) // Đã nhận
            //        {
            //            Result = "Án đã được ";
            //            DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
            //            if (ObjToaAn != null)
            //            {
            //                Result += ObjToaAn.MA_TEN;
            //            }
            //            Result += " nhận. " + Message_Ex;
            //        }
            //        else if (ObjNhan.TRANGTHAI == 0)
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
            //    else
            //    {
            //        Result = "Án đã được ";
            //        DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
            //        if (ObjToaAn != null)
            //        {
            //            Result += ObjToaAn.MA_TEN;
            //        }
            //        Result += " nhận. " + Message_Ex;
            //    }
            //}
            //return Result;

            #endregion for code
        }

        public decimal getDonIdOld(decimal donId)
        {
            AHS_CHUYEN_NHAN_AN AHS_CHUYEN_NHAN_AN = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == donId).FirstOrDefault();
            if (AHS_CHUYEN_NHAN_AN != null)
                return AHS_CHUYEN_NHAN_AN.VUANID.Value;
            return donId;
        }

        public bool UPDATE_NOIDUNG_CHUYENNHANAN(decimal ChuyenNhanId, string NoiDung, decimal DonId)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_AHS_GS.UPDATE_NOIDUNG_CHUYENNHANAN", conn);
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
            OracleCommand comm = new OracleCommand("PKG_STPT_AHS_GS.COUNT_KCKN_TDC", conn);
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
            AHS_SOTHAM_THULY oThuLyST = dt.AHS_SOTHAM_THULY.Where(x => x.ID == ThuLyId).FirstOrDefault();
            AHS_CHUYEN_NHAN_AN oChuyenAn = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonId && x.TOACHUYENID == ToaAnId).OrderByDescending(x => x.NGAYTAO).FirstOrDefault();

            if (oChuyenAn != null && oChuyenAn.NGAYTAO >= oThuLyST.NGAYTAO)
                return true;
            return false;
        }

        public bool CheckIsReadOnlyNguoiTTTTST(decimal Id, decimal DonId, decimal ToaAnId)
        {
            AHS_SOTHAM_HDXX oB = dt.AHS_SOTHAM_HDXX.Where(x => x.ID == Id).FirstOrDefault();
            AHS_CHUYEN_NHAN_AN oChuyenAn = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonId && x.TOACHUYENID == ToaAnId).OrderByDescending(x => x.NGAYTAO).FirstOrDefault();
            if (oChuyenAn != null && oChuyenAn.NGAYTAO >= oB.NGAYTAO)
                return true;
            return false;
        }

        //public bool CheckIsReadOnlyThamPhanST(decimal Id, decimal DonId, decimal ToaAnId)
        //{
        //    AHS_DON_THAMPHAN oB = dt.AHS_DON_THAMPHAN.Where(x => x.ID == Id).FirstOrDefault();
        //    AHS_CHUYEN_NHAN_AN oChuyenAn = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonId && x.TOACHUYENID == ToaAnId).OrderByDescending(x => x.ID).FirstOrDefault();
        //    if (oChuyenAn != null && oChuyenAn.NGAYTAO >= oB.NGAYTAO)
        //        return true;
        //    return false;
        //}
        public bool Check_ThuLy(decimal VuAnID, decimal vHTC)
        {
            if (vHTC == 0)
            {
                AHS_VUAN _don = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                if (_don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM)
                {
                    AHS_PHUCTHAM_THULY ObjThuLy = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                    return ObjThuLy != null;
                }
                else if (_don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                {
                    //AHS_KCKNQDK_PHUCTHAM_THULY ObjThuLy = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_THULY>($"VUANID={VuAnID}").FirstOrDefault();
                    //return ObjThuLy != null;
                    AHS_CHUYEN_NHAN_AN_BL _chuyenNhanAnBl = new AHS_CHUYEN_NHAN_AN_BL();
                    var oldVuAnId = _chuyenNhanAnBl.getDonIdOld(_don.ID);
                    //lay chuyen an tu st len pt tdc
                    AHS_CHUYEN_NHAN_AN chuyenAnSTlenPTTDC = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == _don.ID).FirstOrDefault();
                    List<AHS_SOTHAM_THULY> oThuLyST = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                    List<AHS_SOTHAM_HDXX> oSTNguoiTienHanhToTung = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                    List<AHS_THAMPHANGIAIQUYET> oThamPhanST = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                    List<AHS_SOTHAM_BANAN> oBanAnST = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                    List<AHS_THAMPHANGIAIQUYET> oQDST = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                    List<AHS_SOTHAM_KHANGCAO> oKCST = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                    List<AHS_SOTHAM_KHANGNGHI> oKNST = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();

                    if ((oThuLyST != null && oThuLyST.Count > 0) ||
                        (oSTNguoiTienHanhToTung != null && oSTNguoiTienHanhToTung.Count > 0) ||
                        (oThamPhanST != null && oThamPhanST.Count > 0) ||
                        (oBanAnST != null && oBanAnST.Count > 0) ||
                        (oQDST != null && oQDST.Count > 0) ||
                        (oKCST != null && oKCST.Count > 0) ||
                        (oKNST != null && oKNST.Count > 0))
                    {
                        return true;
                    }
                    else return false;
                }
                //AHS_PHUCTHAM_THULY ObjThuLy = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                //if (ObjThuLy != null)
                //{
                //    return true;
                //}
                //else
                //{
                //    return false;
                //}
            }
            else
            {
                AHS_VUAN _don = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                if (_don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                {
                    AHS_KCKNQDK_PHUCTHAM_THULY ObjThuLyPT = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_THULY>($"VUANID={VuAnID}").FirstOrDefault();
                    return ObjThuLyPT != null;
                }

                AHS_SOTHAM_THULY ObjThuLy = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                if (ObjThuLy != null)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            return true;

        }

    }
}