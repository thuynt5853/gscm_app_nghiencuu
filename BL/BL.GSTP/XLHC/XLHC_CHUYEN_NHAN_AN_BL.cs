using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class XLHC_CHUYEN_NHAN_AN_BL
    {
        GSTPContext dt = new GSTPContext();
        public DataTable XLHC_CHUYEN_NHAN_AN_GETCHUYEN()
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("XLHC_CHUYEN_NHAN_AN_GETCHUYEN", prm);
        }
        
        public string Check_NhanAn_V2(decimal DonID, string Message_Ex)
        {
            string Result = "";
            XLHC_CHUYEN_NHAN_AN ObjNhan = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonID)
                .OrderByDescending(x => x.ID).FirstOrDefault();
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

            //XLHC_CHUYEN_NHAN_AN checkAnGiaoNhanLan2 = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonID)
            //    .OrderByDescending(x => x.ID).FirstOrDefault();
            //if (checkAnGiaoNhanLan2 != null && checkAnGiaoNhanLan2.MAP_VUANID_NEW != null)
            //{
            //    // Result = "Án đã được phúc thẩm trả lại sơ thẩm, không được sửa đổi thông tin!";
            //    Result = "Không được sửa đổi thông tin!";
            //}

            // hoangndh.vnpt: không cho phép nhập lại thông tin ở mục 1 BP XLHC khi xử lý án được chuyển từ PT về ST
            XLHC_CHUYEN_NHAN_AN checkAnGiaoNhanLan2 = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == DonID).FirstOrDefault();
            if (checkAnGiaoNhanLan2 != null)
            {
                Result = "Không được sửa đổi thông tin!";
            }

            return Result;
        }
        public string Check_NhanAn(decimal DonID, string Message_Ex)
        {
            string Result = "";
            XLHC_CHUYEN_NHAN_AN ObjNhan = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonID).FirstOrDefault();
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
        
        public string Check_NhanAn_V2(decimal DonID, string Message_Ex, decimal? toaAnId = null)
        {
            string Result = "";
            XLHC_CHUYEN_NHAN_AN ObjNhan = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonID && (x.TRANGTHAI == 1)).OrderByDescending(x => x.ID).FirstOrDefault();
            if (ObjNhan != null)
            {
                if (toaAnId != null)
                {
                    if (ObjNhan.MAP_VUANID_NEW > 0)
                    {
                        XLHC_CHUYEN_NHAN_AN ObjNhanPTTDC = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == ObjNhan.MAP_VUANID_NEW && x.TRANGTHAI == 1 && x.ID > ObjNhan.ID).FirstOrDefault();
                        if (ObjNhanPTTDC != null)
                        {
                            XLHC_DON donPT = dt.XLHC_DON.Where(x => x.ID == ObjNhan.MAP_VUANID_NEW).FirstOrDefault();
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
                            XLHC_DON donPT = dt.XLHC_DON.Where(x => x.ID == ObjNhan.MAP_VUANID_NEW).FirstOrDefault();
                            // truong hop an TDC
                            if (donPT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                            {
                                Result = "Án đã được ";
                                DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
                                if (ObjToaAn != null)
                                {
                                    Result += ObjToaAn.MA_TEN;
                                }
                                Result += " nhận. " + Message_Ex;
                            } else
                            //  truong hop an thuong 
                            {
                                Result = "Án đã được ";
                                DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault(); //VNPT - Đinh Hoàng Sơn - fix bug lấy sai tên toà -19-09-2025
                                if (ObjToaAn != null)
                                {
                                    Result += ObjToaAn.MA_TEN;
                                }
                                Result += " nhận. " + Message_Ex;
                            }
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
/*                else
                {
                    Result = "Án đã được ";
                    DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == ObjNhan.TOANHANID).FirstOrDefault();
                    if (ObjToaAn != null)
                    {
                        Result += ObjToaAn.MA_TEN;
                    }
                    Result += " nhận. " + Message_Ex;
                }*/
            }
            return Result;

        }

        public bool CheckCoKcKnTamDinhChi(decimal DonId)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_CHUYENAN_XLHC.COUNT_KCKN_TDC", conn);
            comm.CommandType = CommandType.StoredProcedure;
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

        public bool CheckCoKnDuocChapNhan(decimal DonId)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_CHUYENAN_XLHC.COUNT_KN_QUAHAN", conn);
            comm.CommandType = CommandType.StoredProcedure;
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

        public decimal getDonIdOld(decimal donId)
        {
            XLHC_CHUYEN_NHAN_AN xlhc_CHUYEN_NHAN_AN = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == donId).FirstOrDefault();
            if (xlhc_CHUYEN_NHAN_AN != null)
                return xlhc_CHUYEN_NHAN_AN.VUANID.Value;
            return donId;

        }
    }
}