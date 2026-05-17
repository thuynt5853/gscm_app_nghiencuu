using BL.GSTP.THA.Model;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.THA
{
    public class DongBoDLDCQG_BL
    {
        public DataTable GetTHAPaging(string v_ma_vu_an, string v_toaan_id, string v_ten_vu_an, string v_QDID, string v_toidanh, string v_bi_can, string v_cccd, string v_so_qd, string V_TUNGAY, string V_DENNGAY, string v_thamphan_id, string V_TRANGTHAIDONGBO
            , string V_LOAIAN_ID, string v_IDQD, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_IDQD",v_IDQD),
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
                        new OracleParameter("v_QDID",v_QDID),
                        new OracleParameter("v_toaan_id",v_toaan_id),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_cccd",v_cccd),
                        new OracleParameter("v_so_qd",v_so_qd),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("V_TRANGTHAIDONGBO",V_TRANGTHAIDONGBO),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_THA.EXT_SEARCH_ALL_QDTHA", parameters);
            return tbl;
        }

        public bool Insert_DuLieu_DongBo(KhoBiAnQuyetDinhModel obj)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                   new OracleParameter("v_SODINHDANH", OracleDbType.Varchar2) { Value = obj.SODINHDANH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_HOVATEN", OracleDbType.Varchar2) { Value = obj.HOVATEN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NGAYSINH", OracleDbType.Date) { Value = obj.NGAYSINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_GIOITINH", OracleDbType.Int32) { Value = obj.GIOITINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOIDKKS", OracleDbType.Varchar2) { Value = obj.NOIDKKS, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOIDKKSMATINH", OracleDbType.Varchar2) { Value = obj.NOIDKKSMATINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOIDKKSTINH", OracleDbType.Varchar2) { Value = obj.NOIDKKSTINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOIDKKSMAXA", OracleDbType.Varchar2) { Value = obj.NOIDKKSMAXA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOIDKKSXA", OracleDbType.Varchar2) { Value = obj.NOIDKKSXA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOICUTRU", OracleDbType.Varchar2) { Value = obj.NOICUTRU, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOICUTRUMATINH", OracleDbType.Varchar2) { Value = obj.NOICUTRUMATINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOICUTRUTINH", OracleDbType.Varchar2) { Value = obj.NOICUTRUTINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOICUTRUMAXA", OracleDbType.Varchar2) { Value = obj.NOICUTRUMAXA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOICUTRUXA", OracleDbType.Varchar2) { Value = obj.NOICUTRUXA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_SOHOCHIEU", OracleDbType.Varchar2) { Value = obj.SOHOCHIEU, Direction = ParameterDirection.Input },
                    new OracleParameter("v_HOTENCHA", OracleDbType.Varchar2) { Value = obj.HOTENCHA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_HOTENME", OracleDbType.Varchar2) { Value = obj.HOTENME, Direction = ParameterDirection.Input },
                    new OracleParameter("v_HOTENVOCHONG", OracleDbType.Varchar2) { Value = obj.HOTENVOCHONG, Direction = ParameterDirection.Input },
                    new OracleParameter("v_IDQD", OracleDbType.Int64) { Value = obj.IDQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_LOAIQUYETDINH", OracleDbType.Int32) { Value = obj.LOAIQUYETDINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_LOAIQUYETDINHTEN", OracleDbType.NVarchar2) { Value = obj.LOAIQUYETDINHTEN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_SOQDINH", OracleDbType.NVarchar2) { Value = obj.SOQDINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NGAYQDINH", OracleDbType.Date) { Value = obj.NGAYQDINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_MADVI", OracleDbType.NVarchar2) { Value = obj.MADVI, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TENDVI", OracleDbType.NVarchar2) { Value = obj.TENDVI, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TRICHYEUNOIDUNG", OracleDbType.NVarchar2) { Value = obj.TRICHYEUNOIDUNG, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TRANGTHAIBAQD", OracleDbType.Int64) { Value = 0, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TAIKHOANTAO", OracleDbType.Varchar2) { Value = obj.TAIKHOANTAO, Direction = ParameterDirection.Input },

                    new OracleParameter("v_SOBANAN", OracleDbType.Varchar2) { Value = obj.SOBANAN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NGAYBANAN", OracleDbType.Date) { Value = obj.NGAYBANAN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_MADONVIBANAN", OracleDbType.Varchar2) { Value = obj.MADONVIBANAN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TENDONVIBANAN", OracleDbType.Varchar2) { Value = obj.TENDONVIBANAN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_DANHSACHTOIDANH", OracleDbType.Varchar2) { Value = obj.DANHSACHTOIDANH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_HINHPHATCHINH", OracleDbType.Varchar2) { Value = obj.HINHPHATCHINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_MAHINHPHATCHINH", OracleDbType.Varchar2) { Value = obj.MAHINHPHATCHINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TENHINHPHATCHINH", OracleDbType.Varchar2) { Value = obj.TENHINHPHATCHINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_THAMSOHINHPHAT", OracleDbType.Varchar2) { Value = obj.THAMSOHINHPHAT, Direction = ParameterDirection.Input },
                    new OracleParameter("v_DANHSACHHINHPHATBS", OracleDbType.Varchar2) { Value = obj.DANHSACHHINHPHATBS, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TINHTRANGTHA", OracleDbType.Varchar2) { Value = obj.TINHTRANGTHA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NGAYTHA", OracleDbType.Date) { Value = obj.NGAYTHA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_MANOITHA", OracleDbType.Varchar2) { Value = obj.MANOITHA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TENNOITHA", OracleDbType.Varchar2) { Value = obj.TENNOITHA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TRANGTHAITHA", OracleDbType.Varchar2) { Value = obj.TRANGTHAITHA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_BIANID", OracleDbType.Decimal) { Value = obj.BIANID, Direction = ParameterDirection.Input },
                    new OracleParameter("v_THABIANID", OracleDbType.Decimal) { Value = obj.THABIANID, Direction = ParameterDirection.Input },
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_DVCQG_DLDCQG_THA.INSERT_DULIEU_DONGBO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool GuiLai_DuLieu_DongBo(KhoBiAnQuyetDinhModel obj)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("p_KHOBIAN_QUYETDINHID", OracleDbType.Decimal) { Value = obj.KHOBIAN_QUYETDINHID, Direction = ParameterDirection.Input },
                   new OracleParameter("v_SODINHDANH", OracleDbType.Varchar2) { Value = obj.SODINHDANH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_HOVATEN", OracleDbType.Varchar2) { Value = obj.HOVATEN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NGAYSINH", OracleDbType.Date) { Value = obj.NGAYSINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_GIOITINH", OracleDbType.Int32) { Value = obj.GIOITINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOIDKKS", OracleDbType.Varchar2) { Value = obj.NOIDKKS, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOIDKKSMATINH", OracleDbType.Varchar2) { Value = obj.NOIDKKSMATINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOIDKKSTINH", OracleDbType.Varchar2) { Value = obj.NOIDKKSTINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOIDKKSMAXA", OracleDbType.Varchar2) { Value = obj.NOIDKKSMAXA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOIDKKSXA", OracleDbType.Varchar2) { Value = obj.NOIDKKSXA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOICUTRU", OracleDbType.Varchar2) { Value = obj.NOICUTRU, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOICUTRUMATINH", OracleDbType.Varchar2) { Value = obj.NOICUTRUMATINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOICUTRUTINH", OracleDbType.Varchar2) { Value = obj.NOICUTRUTINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOICUTRUMAXA", OracleDbType.Varchar2) { Value = obj.NOICUTRUMAXA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NOICUTRUXA", OracleDbType.Varchar2) { Value = obj.NOICUTRUXA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_SOHOCHIEU", OracleDbType.Varchar2) { Value = obj.SOHOCHIEU, Direction = ParameterDirection.Input },
                    new OracleParameter("v_HOTENCHA", OracleDbType.Varchar2) { Value = obj.HOTENCHA, Direction = ParameterDirection.Input },
                    new OracleParameter("v_HOTENME", OracleDbType.Varchar2) { Value = obj.HOTENME, Direction = ParameterDirection.Input },
                    new OracleParameter("v_HOTENVOCHONG", OracleDbType.Varchar2) { Value = obj.HOTENVOCHONG, Direction = ParameterDirection.Input },
                    new OracleParameter("v_IDQD", OracleDbType.Int64) { Value = obj.IDQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_LOAIQUYETDINH", OracleDbType.Int32) { Value = obj.LOAIQUYETDINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_LOAIQUYETDINHTEN", OracleDbType.NVarchar2) { Value = obj.LOAIQUYETDINHTEN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_SOQDINH", OracleDbType.NVarchar2) { Value = obj.SOQDINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NGAYQDINH", OracleDbType.Date) { Value = obj.NGAYQDINH, Direction = ParameterDirection.Input },
                    new OracleParameter("v_MADVI", OracleDbType.NVarchar2) { Value = obj.MADVI, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TENDVI", OracleDbType.NVarchar2) { Value = obj.TENDVI, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TRICHYEUNOIDUNG", OracleDbType.NVarchar2) { Value = obj.TRICHYEUNOIDUNG, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TRANGTHAIBAQD", OracleDbType.Int64) { Value = 0, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TAIKHOANTAO", OracleDbType.NVarchar2) { Value = obj.TAIKHOANTAO, Direction = ParameterDirection.Input },
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_DVCQG_DLDCQG_THA.GUILAI_DULIEU_DONGBO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        //hủy chuyển dữ liệu đồng bộ
        public bool HuyChuyen_DuLieu_DongBo(decimal p_KHOBIAN_QUYETDINHID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                   new OracleParameter("p_KHOBIAN_QUYETDINHID", OracleDbType.Decimal) { Value = p_KHOBIAN_QUYETDINHID, Direction = ParameterDirection.Input },

                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_DVCQG_DLDCQG_THA.HUYCHUYEN_DULIEU_DONGBO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool IsExsistKHOBIANQUYETDINH(string p_ID, string p_LoaiQDID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                   new OracleParameter("p_ID", OracleDbType.Decimal) { Value = p_ID, Direction = ParameterDirection.Input },
                   new OracleParameter("p_LoaiQDID", OracleDbType.Decimal) { Value = p_LoaiQDID, Direction = ParameterDirection.Input },

                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_DVCQG_DLDCQG_THA.KIEMTRA_TONTAI_DULIEU_DONGBO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool ThuHoi_DuLieu_DongBo(decimal p_KHOBIAN_QUYETDINHID, string p_TAIKHOANTAO, string p_LYDO)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                   new OracleParameter("p_KHOBIAN_QUYETDINHID", OracleDbType.Decimal) { Value = p_KHOBIAN_QUYETDINHID, Direction = ParameterDirection.Input },
                   new OracleParameter("p_TAIKHOANTAO", OracleDbType.Varchar2) { Value = p_TAIKHOANTAO, Direction = ParameterDirection.Input },
                   new OracleParameter("p_LYDO", OracleDbType.NVarchar2) { Value = p_LYDO, Direction = ParameterDirection.Input },

                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_DVCQG_DLDCQG_THA.THUHOI_DULIEU_DONGBO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public DataTable GetByIdKHOBIAN_QUYETDINH(string v_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_ID",v_ID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_THA.GET_BY_ID_KHOBIAN_QUYETDINH", parameters);
            return tbl;
        }

        public DataTable GetPagingLichSuDuLieuDongBo(string p_KHOBIAN_QUYETDINHID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("p_KHOBIAN_QUYETDINHID",p_KHOBIAN_QUYETDINHID),
                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_THA.GET_LICH_SU_DULIEU_DONGBO", parameters);
            return tbl;
        }

        public DataTable Tonghophinhphat_ST(Decimal VVUANID, Decimal VBICAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("VVUANID",VVUANID),
                new OracleParameter("VBICAOID",VBICAOID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_THA.AHS_TONGHOPHINHPHAT_ST", parameters);
            return tbl;
        }

        public DataTable Tonghophinhphat_PT(Decimal VVUANID, Decimal VBICAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("VVUANID",VVUANID),
                new OracleParameter("VBICAOID",VBICAOID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_THA.AHS_TONGHOPHINHPHAT_PT", parameters);
            return tbl;
        }
    }
}