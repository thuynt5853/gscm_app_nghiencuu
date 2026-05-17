using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.DKK;

namespace BL.DonKK
{
    public class DonKK_VBTongDat_BL
    {
        public String CurrConnectionString = ENUM_CONNECTION.DonKhoiKien;

        public DataTable GetTopVBByUser(Decimal UserID, int soluong)
        {
            OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("user_id",UserID),
                                                                            new OracleParameter("soluong",soluong),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                          };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_VBTongData_GetTop", parameters);
            return tbl;
        }
        public DataTable GetByDonKKAndVuViec(Decimal DonKKID, Decimal VuViecID)
        {
            OracleParameter[] parameters = new OracleParameter[] {   
                                                                    new OracleParameter("currDonKKID",DonKKID)
                                                                    , new OracleParameter("currVuViecID",VuViecID)
                                                                    , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_VBTongData_GetByDK", parameters);
            return tbl;
        }
        
        public DataTable GetVBTongDatTheoDonKK(Decimal UserID, Decimal DonKKID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {          new OracleParameter("vDonKKID",DonKKID),
                                                                            new OracleParameter("vUserID",UserID),
                                                                            new OracleParameter("PageIndex",PageIndex),
                                                                            new OracleParameter("PageSize", PageSize),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_GETVBTONGDATTHEODONKK", parameters);
            return tbl;
        }
        
        public void UpdateStatusReadVBMoi(Decimal UserID, int trangthai)
        {
            OracleParameter[] parameters = new OracleParameter[] {          new OracleParameter("user_id",UserID),
                                                                            new OracleParameter("trang_thai",trangthai),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            Cls_Comon.ExcuteProc(CurrConnectionString, "VBTongDat_UpdateStatusRead", parameters);
        }
        public DataTable GetAllPaging(Decimal UserID, string vu_viec, decimal toa_an_id, string tucach_ttt, string vhoten, int trangthai, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("user_id",UserID),
                                                                        new OracleParameter("vu_viec",vu_viec),
                                                                        new OracleParameter("toa_an_id",toa_an_id),
                                                                        new OracleParameter("tucach_ttt",tucach_ttt),
                                                                        new OracleParameter("vhoten",vhoten),
                                                                         new OracleParameter("trang_thai",trangthai),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_VBTongDat_GetAllPaging", parameters);
            return tbl;
        }
        public DataTable GetAll_HDAnPhi( int trangthai, string textsearch
                                      , DateTime? tu_ngay, DateTime? den_ngay
                                      , decimal ToaAnID
                                      , decimal PageIndex, decimal PageSize)
        {
            if (tu_ngay == DateTime.MinValue) tu_ngay = null;
            if (den_ngay == DateTime.MinValue) den_ngay = null;
            OracleParameter[] parameters = new OracleParameter[] {          
                                                                            new OracleParameter("trang_thai",trangthai),
                                                                            new OracleParameter("textsearch",textsearch),
                                                                            new OracleParameter("tu_ngay",tu_ngay),
                                                                            new OracleParameter("den_ngay",den_ngay),
                                                                            new OracleParameter("toa_an_id",ToaAnID),                                                                            
                                                                            new OracleParameter("PageIndex",PageIndex),
                                                                            new OracleParameter("PageSize", PageSize),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_VBTongDat_GetHDAnPhi", parameters);
            return tbl;
        }

        
        public DataTable GetVBTheoNgayNhan(Decimal UserID, int trangthai, DateTime ngay, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {          new OracleParameter("user_id",UserID),
                                                                            new OracleParameter("trang_thai",trangthai),
                                                                            new OracleParameter("ngay_nhan",ngay),
                                                                            new OracleParameter("PageIndex",PageIndex),
                                                                            new OracleParameter("PageSize", PageSize),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "VBTongDat_GetAllByNgayNhan", parameters);
            return tbl;
        }
        
        public DataTable CountByTrangThaiDoc(Decimal UserID, int trangthai, int dang_ky_nhanvb)
        {
            //dang_ky_nhanvb =0--> ko dk
            OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("user_id",UserID)
                                                                    , new  OracleParameter("is_dk_nhanvbnew",dang_ky_nhanvb)
                                                                    , new OracleParameter("trang_thai",trangthai)
                                                                    , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_VBTongDat_CountByTT", parameters);
            return tbl;
        }
        public void GuiVBTongDat(int IsDangKyNhanVB,  decimal donkkid,decimal vuviecid
                                    , string maloaivuviec, string tenvb
                                    ,string tenfile, string loaifile , byte[] noidungfile)
        {
            DKKContextContainer dt = new DKKContextContainer();
            DONKK_DON_VBTONGDAT obj = new DONKK_DON_VBTONGDAT();

            obj.ISDKNHANVB = IsDangKyNhanVB; //=1 nếu là đăng ký nhận vb thong bao
            obj.DONKKID = donkkid; 

            obj.VUVIECID = vuviecid; 
            obj.MALOAIVUVIEC = maloaivuviec; //VD: AN_HANHCHINH, AN_HNGD, AN_DANSU, AN_KDTM

            obj.TENVANBAN = tenvb;
            obj.TENFILE = tenfile;
            obj.LOAIFILE = loaifile; //.doc, .xlxs, .png....            
            obj.NOIDUNGFILE = noidungfile;

            obj.NGAYGUI = DateTime.Now;
            obj.ISREAD = 0;

            dt.DONKK_DON_VBTONGDAT.Add(obj);
            dt.SaveChanges();
        }
        
    }
}