using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.XLHC.KCKN;

namespace BL.GSTP
{
    public class XLHC_DON_BL
    {
        GSTPContext dt = new GSTPContext();
        
        public DataTable XLHC_DON_SEARCH(string vDonViID, string vTenViec, string vQuanHePhapLuat, string vMaViec,
            string vDoiTuongApDungBPXLHC, string vCapXetXu, string vToaXetXu, string vTinhTrangThuLy, string vTuNgayThuLy,
            string vDenNgayThuLy, string vSoThuLy, string vTinhTrangGQ, string vTuNgayGQ, string vDenNgayGQ, string vThamPhan, string vVaiTroThamPhan,
            string vThoiHanGQ, string vSoQD, string vNgayQD, string vThuKy, string vPTRutKinhNghiem, decimal V_CHECK_PTQDK, decimal V_AN_KET_THUC, decimal PageIndex, decimal PageSize)
        {
            if (V_CHECK_PTQDK == 0)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                            new OracleParameter("vDonViID",vDonViID),
                                            new OracleParameter("vTenViec",vTenViec),
                                            new OracleParameter("vQuanHePhapLuat",vQuanHePhapLuat),
                                            new OracleParameter("vMaViec",vMaViec),
                                            new OracleParameter("vDoiTuongApDungBPXLHC",vDoiTuongApDungBPXLHC),
                                            new OracleParameter("vCapXetXu",vCapXetXu),
                                            new OracleParameter("vToaXetXu",vToaXetXu),
                                            new OracleParameter("vTinhTrangThuLy",vTinhTrangThuLy),
                                            new OracleParameter("vTuNgayThuLy",vTuNgayThuLy),
                                            new OracleParameter("vDenNgayThuLy",vDenNgayThuLy),
                                            new OracleParameter("vSoThuLy",vSoThuLy),
                                            new OracleParameter("vTinhTrangGQ",vTinhTrangGQ),
                                            new OracleParameter("vTuNgayGQ",vTuNgayGQ),
                                            new OracleParameter("vDenNgayGQ",vDenNgayGQ),
                                            new OracleParameter("vThamPhan",vThamPhan),
                                            new OracleParameter("vVaiTroThamPhan",vVaiTroThamPhan),
                                            new OracleParameter("vThoiHanGQ",vThoiHanGQ),
                                            new OracleParameter("vSoQD",vSoQD),
                                            new OracleParameter("vNgayQD",vNgayQD),
                                            new OracleParameter("vThuKy",vThuKy),
                                            new OracleParameter("vPTRutKinhNghiem",vPTRutKinhNghiem),
                                            new OracleParameter("V_AN_KET_THUC",V_AN_KET_THUC),
                                            new OracleParameter("Page_Index",PageIndex),
                                            new OracleParameter("Page_Size",PageSize),
                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_XLHC.XLHC_DON_SEARCH", parameters);
                return tbl;
            } else
            {
                 OracleParameter[] parameters = new OracleParameter[] {
                                            new OracleParameter("vDonViID",vDonViID),
                                            new OracleParameter("vTenViec",vTenViec),
                                            new OracleParameter("vQuanHePhapLuat",vQuanHePhapLuat),
                                            new OracleParameter("vMaViec",vMaViec),
                                            new OracleParameter("vDoiTuongApDungBPXLHC",vDoiTuongApDungBPXLHC),
                                            new OracleParameter("vCapXetXu",vCapXetXu),
                                            new OracleParameter("vToaXetXu",vToaXetXu),
                                            new OracleParameter("vTinhTrangThuLy",vTinhTrangThuLy),
                                            new OracleParameter("vTuNgayThuLy",vTuNgayThuLy),
                                            new OracleParameter("vDenNgayThuLy",vDenNgayThuLy),
                                            new OracleParameter("vSoThuLy",vSoThuLy),
                                            new OracleParameter("vTinhTrangGQ",vTinhTrangGQ),
                                            new OracleParameter("vTuNgayGQ",vTuNgayGQ),
                                            new OracleParameter("vDenNgayGQ",vDenNgayGQ),
                                            new OracleParameter("vThamPhan",vThamPhan),
                                            new OracleParameter("vVaiTroThamPhan",vVaiTroThamPhan),
                                            new OracleParameter("vThoiHanGQ",vThoiHanGQ),
                                            new OracleParameter("vSoQD",vSoQD),
                                            new OracleParameter("vNgayQD",vNgayQD),
                                            new OracleParameter("vThuKy",vThuKy),
                                            new OracleParameter("vPTRutKinhNghiem",vPTRutKinhNghiem),
                                            new OracleParameter("V_AN_KET_THUC",V_AN_KET_THUC),
                                            new OracleParameter("Page_Index",PageIndex),
                                            new OracleParameter("Page_Size",PageSize),
                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_XLHC.XLHC_DON_SEARCH_PTQDK", parameters);
                return tbl;
            }
        }
        public decimal GETNEWTT(decimal donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_DON_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
        }
        public DataTable XLHC_DON_TGTT_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_DON_TGTT_GETLIST", parameters);
            return tbl;
        }
        public DataTable XLHC_DON_TGTT_GETLIST_V2(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDONID",vDONID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.XLHC_DON_TGTT_GETLIST_V2", parameters);
            return tbl;
        }
        public DataTable XLHC_DON_BanGiaoTaiLieu_GETLIST(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDONID",vDONID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_DON_BGTL_GETLIST", parameters);
            return tbl;
        }
        public DataTable XLHC_DON_BGTT_GETINFO(decimal vDONID, string NguoiGiao, decimal NguoiNhan, string NgayBanGiao)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vNguoiGiao",NguoiGiao),
                                                                        new OracleParameter("vNguoiNhan",NguoiNhan),
                                                                        new OracleParameter("vNgayBanGiao",NgayBanGiao),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_DON_BGTT_GETINFO", parameters);
            return tbl;
        }
        public DataTable XLHC_DON_GETTOAANBYVUVIEC(decimal vDonID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDONID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("XLHC_DON_GETTOAANBYVUVIEC", prm);
        }
        public DataTable XLHC_TONGDAT_DOITUONG_GETBY(decimal vDONID, decimal vTOAANID, decimal vBIEUMAUID, decimal vIsOnlyNKK)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                         new OracleParameter("vTOAANID",vTOAANID),
                                                                          new OracleParameter("vBIEUMAUID",vBIEUMAUID),
                                                                          new OracleParameter("vIsOnlyNKK",vIsOnlyNKK),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_TONGDAT_DOITUONG_GETBY", parameters);
            return tbl;
        }
        public DataTable XLHC_TONGDAT_GETLIST(decimal vDONID, decimal vToaAnID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                         new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_TONGDAT_GETLIST", parameters);
            return tbl;
        }
        public bool DELETE_ALLDATA_BY_VUANID(string donID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("in_VUANID", donID) };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GSTP_DELETE.DELETE_DATA_XLHC_BY_VUANID", parameters);
                return dbl == 1 ? true : false;
            }
            catch { return false; }
        }
        
        //public bool Check_ThuLy(decimal DonID)
        //{
        //    XLHC_SOTHAM_THULY ObjThuLy = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == DonID).FirstOrDefault();
        //    if (ObjThuLy != null)
        //    {
        //        return true;
        //    }
        //    else
        //    {
        //        return false;
        //    }
        //}

        public bool Check_ThuLy(decimal DonID)
        {
            XLHC_DON _don = dt.XLHC_DON.Where(x => x.ID == DonID).FirstOrDefault();
            if (_don != null)
            {
                if (_don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM || _don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO)
                {
                    XLHC_SOTHAM_THULY ObjThuLy = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == DonID).FirstOrDefault();
                    return ObjThuLy != null;
                }
                else if (_don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM)
                {
                    XLHC_PHUCTHAM_THULY ObjThuLy = dt.XLHC_PHUCTHAM_THULY.Where(x => x.DONID == DonID).FirstOrDefault();
                    return ObjThuLy != null;
                }
                else if (_don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                {
                    XLHC_KCKNQDK_PHUCTHAM_THULY ObjThuLy = DataExtensions.GetAllByDonId<XLHC_KCKNQDK_PHUCTHAM_THULY>(DonID).FirstOrDefault();
                    return ObjThuLy != null;
                }
            }

            return false;
        }

        public DataTable XLHC_DUONGSU_GET_BY_ID(Decimal DonID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
            new OracleParameter("VDONID", DonID),
            new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output)
            };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.XLHC_DUONGSU_GET_BY_ID", parameters);
            return tbl;
        }
        public int XLHC_GIAO_NHAN_CHUNG_CU_TAI_LIEU(Dictionary<string, object> parameters)
        {
            try
            {
                List<OracleParameter> paramList = new List<OracleParameter>();

                // Đảm bảo đúng thứ tự & kiểu dữ liệu của 12 tham số IN (p_RESULT là OUT)
                paramList.Add(new OracleParameter("p_ID", OracleDbType.Decimal) { Value = parameters["p_ID"] });
                paramList.Add(new OracleParameter("p_DONID", OracleDbType.Decimal) { Value = parameters["p_DONID"] });
                paramList.Add(new OracleParameter("p_TENTAILIEU", OracleDbType.Varchar2) { Value = parameters["p_TENTAILIEU"] });
                paramList.Add(new OracleParameter("p_NGUONBANGIAO", OracleDbType.Decimal) { Value = parameters["p_NGUONBANGIAO"] });
                paramList.Add(new OracleParameter("p_NGAYBANGIAO", OracleDbType.Date) { Value = parameters["p_NGAYBANGIAO"] });
                paramList.Add(new OracleParameter("p_NGUOIBANGIAO_NEW", OracleDbType.Varchar2) { Value = parameters["p_NGUOIBANGIAO_NEW"] });
                paramList.Add(new OracleParameter("p_NGUOINHANID", OracleDbType.Decimal) { Value = parameters["p_NGUOINHANID"] });
                paramList.Add(new OracleParameter("p_NGUOITHUCHIEN", OracleDbType.Varchar2) { Value = parameters["p_NGUOITHUCHIEN"] });
                paramList.Add(new OracleParameter("p_OPERATION", OracleDbType.Varchar2) { Value = parameters["p_OPERATION"] });
                paramList.Add(new OracleParameter("p_TOA_GIAIQUYET_ID", OracleDbType.Decimal) { Value = parameters["p_TOA_GIAIQUYET_ID"] });

                // BLOB
                paramList.Add(new OracleParameter("p_NOIDUNG", OracleDbType.Blob)
                {
                    Value = parameters.ContainsKey("p_NOIDUNG") ? parameters["p_NOIDUNG"] ?? DBNull.Value : DBNull.Value
                });

                paramList.Add(new OracleParameter("p_TENFILE", OracleDbType.Varchar2)
                {
                    Value = parameters.ContainsKey("p_TENFILE") ? parameters["p_TENFILE"] ?? DBNull.Value : DBNull.Value
                });

                paramList.Add(new OracleParameter("p_LOAIFILE", OracleDbType.Varchar2)
                {
                    Value = parameters.ContainsKey("p_LOAIFILE") ? parameters["p_LOAIFILE"] ?? DBNull.Value : DBNull.Value
                });

                // OUT PARAM
                OracleParameter resultParam = new OracleParameter("p_RESULT", OracleDbType.Int32)
                {
                    Direction = ParameterDirection.Output
                };
                paramList.Add(resultParam);

                // Gọi procedure (chú ý tên procedure đầy đủ kèm package)
                Cls_Comon.GetTableByProcedurePaging("PKG_STPT.XLHC_GIAO_NHAN_CHUNG_CU_TAI_LIEU", paramList.ToArray());

                return Convert.ToInt32(resultParam.Value.ToString());
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Lỗi khi lưu tài liệu giao nhận: " + ex.Message);
                return 0;
            }
        }

        public DataTable XLHC_DON_BanGiaoTaiLieu_GETLIST_V2(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDONID",vDONID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.XLHC_DON_BGTL_GETLIST_V2", parameters);
            return tbl;
        }

    }
}