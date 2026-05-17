using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class DM_CANBO_BL
    {
        public DataTable DM_CANBO_GETBYDONVI(decimal donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("donviID",donviID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DM.DM_CANBO_GETBYDONVI_V2", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                String temp = "";
                foreach (DataRow row in tbl.Rows)
                {
                    temp = row["HoTen"] + "";
                    temp += (String.IsNullOrEmpty(row["TENCHUCDANH"] + "")) ? "" : (" - " + row["TENCHUCDANH"]);
                    temp += (String.IsNullOrEmpty(row["TENCHUCVU"] + "")) ? "" : (" - " + row["TENCHUCVU"]);
                    temp += (String.IsNullOrEmpty(row["NGAYSINH"] + "")) ? "" : (" - " + row["NGAYSINH"]);
                    row["MA_TEN"] = temp;
                }
            }
            return tbl;
        }
        public DataTable DM_CANBO_GETTAIKHOAN(string v_CCCD)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("v_CCCD",v_CCCD),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DM.DM_CANBO_GETTAIKHOAN", parameters);
            return tbl;
        }

        public DataTable DM_CANBO_GETBYDONVI_PHONGBAN(decimal DonViID, decimal PhongBanID, decimal PHONGBANID_SUB)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("DonViID",DonViID),
                                                                        new OracleParameter("PhongBanID",PhongBanID),
                                                                        new OracleParameter("PHONGBANID_SUB",PHONGBANID_SUB),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GETBYDONVI_PHONGBAN", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                String temp = "";
                foreach (DataRow row in tbl.Rows)
                {
                    temp = row["HoTen"] + "";
                    temp += (String.IsNullOrEmpty(row["TENCHUCDANH"] + "")) ? "" : (" - " + row["TENCHUCDANH"]);
                    temp += (String.IsNullOrEmpty(row["TENCHUCVU"] + "")) ? "" : (" - " + row["TENCHUCVU"]);
                    row["MA_TEN"] = temp;
                }
            }
            return tbl;
        }

        public DataTable DM_CANBO_PB_CHUCDANH(decimal phongbanid, string MaChucDanh, Decimal LanhDaoID, Decimal ThamTraVienID, int curPageIndex, int pageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vPhongBanID",phongbanid),
                                                                        new OracleParameter("vChucDanh",MaChucDanh),
                                                                        new OracleParameter("vLanhDaoID",LanhDaoID),
                                                                        new OracleParameter("vThamTraVienID",ThamTraVienID),
                                                                        new OracleParameter("CurrPageIndex",curPageIndex),
                                                                        new OracleParameter("PageSize",pageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_PB_CHUCDANH", parameters);
            return tbl;
        }
        /// <summary>
        /// THUONGNX: Lấy danh sách các cán bộ của đơn vị theo mã chức danh
        /// </summary>
        /// <param name="donviID"></param>
        /// <param name="MaChucDanh"></param>
        /// <returns></returns>
        public DataTable DM_CANBO_GETBYDONVI_CHUCDANH(decimal donviID, string MaChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                            new OracleParameter("vChucDanh",MaChucDanh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_CANBO_GETBYDONVI_CHUCDANH", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GETBYDONVI_CHUCDANH_PHONGBAN(decimal donviID, decimal phongBanId, string MaChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                        new OracleParameter("vPhongBanID",phongBanId),
                                                                        new OracleParameter("vChucDanh",MaChucDanh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_CANBO_GETBYDONVI_CHUCDANH_PB", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU(decimal donviID, string MaChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                          new OracleParameter("vChucDanh",MaChucDanh),
                                                                          //new OracleParameter("vChucVu1",vChucVu1),
                                                                          //new OracleParameter("vChucVu2",vChucVu2),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU", parameters);
            return tbl;
        }
        public DataTable CHECK_CHUCDANH_THUKY_USER(decimal donviID, string MaChucDanh, decimal vCanBoID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                          new OracleParameter("vChucDanh",MaChucDanh),
                                                                          new OracleParameter("vCanBoID",vCanBoID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.CHECK_CHUCDANH_THUKY_USER", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_QLHS_PT(string donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonViID",donviID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_HOSO_PT.DM_CANBO_QLHS_PT", parameters);
            return tbl;
        }

        public DataTable SP_CANBO_THULY_PT(string donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonViID",donviID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_HOSO_PT.SP_CANBO_THULY_PT", parameters);
            return tbl;
        }

        /// <summary>
        /// THUONGNX: Lấy danh sách cán bộ của đơn vị theo chức vụ
        /// </summary>
        /// <param name="donviID"></param>
        /// <param name="vChucVu"></param>
        /// <returns></returns>
        public DataTable DM_CANBO_GETBYDONVI_CHUCVU(decimal donviID, string vChucVu)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                          new OracleParameter("vChucVu",vChucVu),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GETBYDONVI_CHUCVU", parameters);
            return tbl;
        }

        public DataTable DM_CANBO_GetAllThuKy_TTV(decimal donviID, string MaChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                        new OracleParameter("vChucDanh",MaChucDanh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GetAllThuKy_TTV", parameters);
            return tbl;
        }
        public DataTable GET_ThuKy_TTVS(string donviID, string MaChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("VDONVIID",donviID),
            new OracleParameter("VCHUCDANH",MaChucDanh),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_CANBO_GETALLTHUKY_TTV", parameters);
            return tbl;
        }
        public DataTable GET_ThuKy_TTVS_CV(string donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("VDONVIID",donviID),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_CANBO_GETALLTHUKY_TTV_CV", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GetAllThuKy(decimal donviID, string MaChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                        new OracleParameter("vChucDanh",MaChucDanh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GetAllThuKy", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GETALL(string donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_CANBO_GETALL", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GetAllVuTruong_PVT(decimal donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GetAllVuTruong_PVT", parameters);
            return tbl;
        }


        public DataTable DM_CANBO_GetByPhongBan(decimal phongbanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vPhongBanID",phongbanid),

                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GetByPhongBan", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GetTTVTheoPhongBan(decimal phongbanid, string chucdanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vPhongBanID",phongbanid),
                                                                        new OracleParameter("vChucDanh",chucdanh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GetTTVTheoPhongBan", parameters);
            return tbl;
        }

        /// <summary>
        /// THUONGNX: Lấy danh sách cán bộ của đơn vị theo 1 trong 2 chức vụ
        /// </summary>
        /// <param name="donviID"></param>
        /// <param name="vChucVu1"></param>
        /// <param name="vChucVu2"></param>
        /// <returns></returns>
        public DataTable DM_CANBO_GETBYDONVI_2CHUCVU(decimal donviID, string vChucVu1, string vChucVu2)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                          new OracleParameter("vChucVu1",vChucVu1),
                                                                          new OracleParameter("vChucVu2",vChucVu2),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_CANBO_GETBYDONVI_2CHUCVU", parameters);
            return tbl;
        }

        #region tamnc
        public DataTable DM_CANBO_GETBYDONVI_3CHUCVU(decimal donviID, string vChucVu1, string vChucVu2, string vChucVu3)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                          new OracleParameter("vChucVu1",vChucVu1),
                                                                          new OracleParameter("vChucVu2",vChucVu2),
                                                                          new OracleParameter("vChucVu3",vChucVu3),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_CANBO_GETBYDONVI_3CHUCVU", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GETBYDONVI_3CHUCVU_HIEULUC(decimal donviID, string vChucVu1, string vChucVu2, string vChucVu3)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                          new OracleParameter("vChucVu1",vChucVu1),
                                                                          new OracleParameter("vChucVu2",vChucVu2),
                                                                          new OracleParameter("vChucVu3",vChucVu3),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_CANBO_GETBYDONVI_3CHUCVU_HIEULUC", parameters);
            return tbl;
        }
        #endregion
        public DataTable DM_CANBO_GETBYDONVI_byCHUCVU(decimal donviID, decimal v_VuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                          new OracleParameter("v_VuAnID",v_VuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_CANBO_GETBYDONVI_byCHUCVU", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GETBYDONVI_THULY(decimal donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("VDONVIID",donviID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_CANBO_GETBYDONVI", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GETBYDONVI_2CHUCVU_HCTP(decimal donviID, string vChucVu1, string vChucVu2)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                          new OracleParameter("vChucVu1",vChucVu1),
                                                                          new OracleParameter("vChucVu2",vChucVu2),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.DM_CANBO_GETBYDONVI_2CHUCVU", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_SEARCH(decimal ToaAnID, decimal vPhongbanID, string VPHONGBANID_SUB, decimal ChucDanhID, decimal ChucVuID, decimal v_TrangThaiCongTac, string GroupChucDanhName, string GroupChucVuName, string KeySearch, int curPageIndex, int pageSize, int SearchAll)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("ToaAID",ToaAnID),
                 new OracleParameter("vPhongbanID",vPhongbanID),
                new OracleParameter("VPHONGBANID_SUB",VPHONGBANID_SUB),
                new OracleParameter("vChucDanhID",ChucDanhID),
                new OracleParameter("vChucVuID",ChucVuID),
                new OracleParameter("v_TrangThaiCongTac",v_TrangThaiCongTac),
                new OracleParameter("GroupChucDanhName",GroupChucDanhName),
                new OracleParameter("GroupChucVuName",GroupChucVuName),
                new OracleParameter("KeySearch",KeySearch),
                new OracleParameter("CurrPageIndex",curPageIndex),
                new OracleParameter("PageSize",pageSize),
                new OracleParameter("v_SearchAll",SearchAll),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_SEARCH", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GETINFOBYID(decimal CanBoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("vCanBoID",CanBoID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GETINFOBYID", parameters);
            return tbl;
        }


        public DataTable DM_CANBO_GETBYDONVI_SEARCHTOP(decimal donviID, string txtKey)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("donviID",donviID),
                                                                    new OracleParameter("txtKey",txtKey),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GETBYDONVI_SEARCHTOP", parameters);
            return tbl;
        }
        public DataTable GetAllChanhAn_PhoCA(decimal donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("vDonViID",donviID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GetCA_PCA", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_CONGTAC_SEARCH(decimal donviID, string vSearch, decimal vNam)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("vDonViID",donviID),
                                                                    new OracleParameter("vNam",vNam),
                                                                    new OracleParameter("vSearch",vSearch),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_CONGTAC_SEARCH", parameters);
            return tbl;
        }
        // Lấy danh sách tòa án biệt phái của cán bộ
        public DataTable DM_TOAAN_BIETPHAI(decimal userID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("vNguoiDungID",userID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_TOAAN_BIETPHAI", parameters);
            return tbl;
        }
        // Lấy danh sách thông tin biệt phái của cán bộ
        public DataTable DM_CANBO_BIETPHAI_SEARCH(decimal canboID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("vCanBoID",canboID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_BIETPHAI_SEARCH", parameters);
            return tbl;
        }
        // Lê Nam: Lấy danh sách các cán bộ Thẩm phán, Hội Thẩm, Thư ký được phân công trong vụ án sơ thẩm
        public DataTable DMCANBO_DUOCPC_BM03HS_ST(decimal ToaAnID, decimal VuAnID, string TuCach)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("v_TOAANID",ToaAnID),
                                                                    new OracleParameter("v_VUANID",VuAnID),
                                                                    new OracleParameter("v_TUCACH",TuCach),
                                                                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DMCANBO_DUOCPC_BM03HS_ST", parameters);
            return tbl;
        }
        // Lê Nam: Lấy danh sách các cán bộ Thẩm phán, Hội Thẩm, Thư ký được phân công trong vụ án phúc thẩm
        public DataTable DMCANBO_DUOCPC_BM03HS_PT(decimal ToaAnID, decimal VuAnID, string TuCach)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("v_TOAANID",ToaAnID),
                                                                    new OracleParameter("v_VUANID",VuAnID),
                                                                    new OracleParameter("v_TUCACH",TuCach),
                                                                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DMCANBO_DUOCPC_BM03HS_PT", parameters);
            return tbl;
        }
        // Lê Nam: Lấy danh sách các cán bộ Thẩm phán, Hội Thẩm, Thư ký bị thay đổi trong vụ án sơ thẩm
        public DataTable DMCANBO_NGUOIBITHAYDOI_TCTT_ST(decimal VuAnID, string TuCach)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("v_VUANID",VuAnID),
                                                                    new OracleParameter("v_TUCACH",TuCach),
                                                                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DMCANBO_NGUOIBITHAYDOI_TCTT_ST", parameters);
            return tbl;
        }
        // Lê Nam: Lấy danh sách các cán bộ Thẩm phán, Hội Thẩm, Thư ký bị thay đổi trong vụ án phúc thẩm
        public DataTable DMCANBO_NGUOIBITHAYDOI_TCTT_PT(decimal VuAnID, string TuCach)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("v_VUANID",VuAnID),
                                                                    new OracleParameter("v_TUCACH",TuCach),
                                                                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DMCANBO_NGUOIBITHAYDOI_TCTT_PT", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GET_THAMPHAN_TEN_DV(string Ten, decimal DonVi, string GroupChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("v_TEN",Ten),
                                                                    new OracleParameter("v_DONVI",DonVi),
                                                                    new OracleParameter("v_GROUPNAME",GroupChucDanh),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GET_THAMPHAN_TEN_DV", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GETCA_PCA_BY_USERID(decimal UserID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("vUserID",UserID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GETCA_PCA_BY_USERID", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_GETTP_BYDONVI(decimal donviID, int PageSize, int PageIndex)
        {
            OracleParameter[] parameters = new OracleParameter[]
                    {
                        new OracleParameter("in_DonVi",donviID),
                        new OracleParameter("in_PageSize",PageSize),
                        new OracleParameter("in_PageIndex",PageIndex),
                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GETTP_BYDONVI", parameters);
            return tbl;
        }
        public DataTable DM_PCA_GetByDONVI(decimal donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vdonviID",donviID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_PCA_BYTOAAN", parameters);
            return tbl;
        }
        public DataTable DM_PCA_AND_DIABAN(decimal donviID, decimal CanBoID, decimal ToaanID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonViID",donviID),
                new OracleParameter("vCanboID",CanBoID),
                new OracleParameter("vToaanID",ToaanID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.PCA_AND_DIABAN", parameters);
            return tbl;
        }
        public void UPDATE_PCA_AND_DIABAN(decimal donviID, decimal CURR_CanBoID, decimal OLD_CanBoID, decimal ToaanID, DateTime NgayPC)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonViID",donviID),
                new OracleParameter("vCurrCanboID",CURR_CanBoID),
                new OracleParameter("vOLDCanboID",OLD_CanBoID),
                new OracleParameter("vToaanID",ToaanID),
                new OracleParameter("vNGAYPC",NgayPC)
            };
            Cls_Comon.GetTableByProcedurePaging("PKG_STPT.PCA_AND_DIABAN_IN_UP", parameters);
        }
        public DataTable DM_CANBO_GETBYDONVI_ARR_CHUCVU(decimal donviID, string vArrChucVu, string vLoaiso)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",donviID),
                                                                        new OracleParameter("vArrChucVu",vArrChucVu),
                                                                        new OracleParameter("vLoaiso",vLoaiso),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.DM_CANBO_GETBYDONVI_ARR_CHUCVU", parameters);
            return tbl;
        }
    }
}