using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using Module.Common;
using Newtonsoft.Json;
using System.Configuration;
using WEB.Service.Service.Auth;

namespace WEB.Service.Controllers
{
    public class VNEID_THONGBAOTA
    {

        public static DataTable THONGBAO_TONGDAT_VNEID_QD_ST_AHS(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HS.THONGBAO_TONGDAT_VNEID_QD_ST", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_VNEID_BANAN_ST_AHS(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HS.THONGBAO_TONGDAT_VNEID_BANAN_ST", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_VNEID_QD_PT_AHS(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HS.THONGBAO_TONGDAT_VNEID_QD_PT", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_VNEID_BANAN_PT_AHS(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HS.THONGBAO_TONGDAT_VNEID_BANAN_PT", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT(decimal loaivuviec,decimal tongdatid, decimal doituongId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID.THONGBAO_TONGDAT_VNEID", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_THULY_AHN(decimal loaivuviec, decimal tongdatid, decimal doituongId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HN.THONGBAO_TONGDAT_VNEID_THULY_HN", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_THULY_AKT(decimal loaivuviec, decimal tongdatid, decimal doituongId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_KT.THONGBAO_TONGDAT_VNEID_THULY_KT", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_THULY_ALD(decimal loaivuviec, decimal tongdatid, decimal doituongId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_LD.THONGBAO_TONGDAT_VNEID_THULY_LD", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_THULY_AHC(decimal loaivuviec, decimal tongdatid, decimal doituongId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HC.THONGBAO_TONGDAT_VNEID_THULY_HC", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_THULY_ADS(decimal loaivuviec, decimal tongdatid,decimal doituongId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_DS.THONGBAO_TONGDAT_VNEID_THULY_DS", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_GIAIQUYETDON_ST_ADS(decimal loaivuviec, decimal tongdatid, decimal doituongId,string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_DS.TONGDAT_VNEID_GIAIQUYETDON_DS", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_QDVUVIEC_ST_ADS(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_DS.THONGBAO_TONGDAT_VNEID_QDVUVIEC_ST_DS", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_THULY_PT_ADS(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_DS.TONGDAT_VNEID_THULY_PT_DS", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_QDVUVIEC_PT_ADS(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_DS.THONGBAO_TONGDAT_VNEID_QDVUVIEC_PT_DS", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_BANAN_PT_ADS(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_DS.THONGBAO_TONGDAT_VNEID_BANAN_PT_DS", parameters);
            return tbl;
        }


        public static DataTable THONGBAO_TONGDAT_VNEID_QUYETDINH_ST_ADS(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_DS.THONGBAO_TONGDAT_VNEID_QUYETDINH_ST_DS", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_VNEID_BANAN_ST_ADS(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_DS.THONGBAO_TONGDAT_VNEID_BANAN_ST_DS", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_VNEID_BANAN_ST_AHN(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HN.THONGBAO_TONGDAT_VNEID_BANAN_ST_HN", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_VNEID_BANAN_ST_AKT(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_KT.THONGBAO_TONGDAT_VNEID_BANAN_ST_KT", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_VNEID_BANAN_ST_ALD(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_LD.THONGBAO_TONGDAT_VNEID_BANAN_ST_LD", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_THONGTINDON_ST_ADS(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_DS.TONGDAT_VNEID_THONGTINDON_DS", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_THONGTINDON_ST_AHN(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HN.TONGDAT_VNEID_THONGTINDON_HN", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_GIAIQUYETDON_ST_AHN(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HN.TONGDAT_VNEID_GIAIQUYETDON_HN", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_QUYETDINH_ST_AHN(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HN.THONGBAO_TONGDAT_VNEID_QUYETDINH_ST_HN", parameters);
            return tbl;
        }


        public static DataTable THONGBAO_TONGDAT_THONGTINDON_ST_AKT(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_KT.TONGDAT_VNEID_THONGTINDON_KT", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_GIAIQUYETDON_ST_AKT(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_KT.TONGDAT_VNEID_GIAIQUYETDON_KT", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_QUYETDINH_ST_AKT(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_KT.THONGBAO_TONGDAT_VNEID_QUYETDINH_ST_KT", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_QDVUVIEC_ST_AHN(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HN.THONGBAO_TONGDAT_VNEID_QDVUVIEC_ST_HN", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_THULY_PT_AHN(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HN.TONGDAT_VNEID_THULY_PT_HN", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_QDVUVIEC_PT_AHN(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HN.THONGBAO_TONGDAT_VNEID_QDVUVIEC_PT_HN", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_BANAN_PT_AHN(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HN.THONGBAO_TONGDAT_VNEID_BANAN_PT_HN", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_QDVUVIEC_ST_AKT(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_KT.THONGBAO_TONGDAT_VNEID_QDVUVIEC_ST_KT", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_THULY_PT_AKT(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_KT.TONGDAT_VNEID_THULY_PT_KT", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_QDVUVIEC_PT_AKT(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_KT.THONGBAO_TONGDAT_VNEID_QDVUVIEC_PT_KT", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_BANAN_PT_AKT(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_KT.THONGBAO_TONGDAT_VNEID_BANAN_PT_KT", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_QDVUVIEC_ST_ALD(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_LD.THONGBAO_TONGDAT_VNEID_QDVUVIEC_ST_LD", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_THULY_PT_ALD(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_LD.TONGDAT_VNEID_THULY_PT_LD", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_QDVUVIEC_PT_ALD(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_LD.THONGBAO_TONGDAT_VNEID_QDVUVIEC_PT_LD", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_BANAN_PT_ALD(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_LD.THONGBAO_TONGDAT_VNEID_BANAN_PT_LD", parameters);
            return tbl;
        }


        public static DataTable THONGBAO_TONGDAT_THONGTINDON_ST_ALD(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_LD.TONGDAT_VNEID_THONGTINDON_LD", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_GIAIQUYETDON_ST_ALD(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_LD.TONGDAT_VNEID_GIAIQUYETDON_LD", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_QUYETDINH_ST_ALD(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_LD.THONGBAO_TONGDAT_VNEID_QUYETDINH_ST_LD", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_QDVUVIEC_ST_AHC(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HC.THONGBAO_TONGDAT_VNEID_QDVUVIEC_ST_HC", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_THULY_PT_AHC(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HC.TONGDAT_VNEID_THULY_PT_HC", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_QDVUVIEC_PT_AHC(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HC.THONGBAO_TONGDAT_VNEID_QDVUVIEC_PT_HC", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_BANAN_PT_AHC(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("V_TONGDAT",tongdatid),
                                                                        new OracleParameter("V_DOITUONGID",doituongId),
                                                                        new OracleParameter("V_FILENAME",fileName),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HC.THONGBAO_TONGDAT_VNEID_BANAN_PT_HC", parameters);
            return tbl;
        }


        public static DataTable THONGBAO_TONGDAT_THONGTINDON_AHC(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HC.TONGDAT_VNEID_THONGTINDON_HC", parameters);
            return tbl;
        }

        public static DataTable THONGBAO_TONGDAT_GIAIQUYETDON_AHC(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HC.TONGDAT_VNEID_GIAIQUYETDON_HC", parameters);
            return tbl;
        }
        public static DataTable THONGBAO_TONGDAT_BANAN_AHC(decimal loaivuviec, decimal tongdatid, decimal doituongId, string fileName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIVUVIEC",loaivuviec),
                new OracleParameter("V_TONGDAT",tongdatid),
                new OracleParameter("V_DOITUONGID",doituongId),
                new OracleParameter("V_FILENAME",fileName),
                new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_VNEID_HC.TONGDAT_VNEID_BANAN_HC", parameters);
            return tbl;
        }
        public static decimal Insert_log(decimal maloi, string loaivuviec, decimal tongdatid,decimal doituongid, DataTable CONTENT_JSON)
        {
            try
            {
                Notification oBody = new Notification();

                foreach (DataRow row in CONTENT_JSON.Rows)
                {
                    //var noteString = row["note"]?.ToString() ?? "[]";  // Nếu 'note' là null hoặc rỗng, gán mảng rỗng
                    var noteString = row["note"]?.ToString()?.Trim() ?? "[]";
                    // Loại bỏ dấu ngoặc kép (dấu escape) trước khi giải mã (nếu có)
                    // Trong trường hợp này, noteString chứa một chuỗi JSON hợp lệ, nên không cần phải làm gì thêm.
                    string innerJsonString = noteString
                       .Replace("\\\"", "\"")  // bỏ escape của dấu "
                       .Trim('"');
                    List<string> noteList = new List<string>();
                    try
                    {
                        // Deserialize chuỗi JSON thành List<string>
                        noteList = JsonConvert.DeserializeObject<List<string>>(innerJsonString);
                    }
                    catch (Exception ex)
                    {
                        // Nếu có lỗi, gán danh sách rỗng và in lỗi
                        noteList = new List<string>();
                        Console.WriteLine($"Error parsing 'note': {ex.Message}");
                    }
                    
                    oBody = new Notification
                    {
                        tongdatId = row["tongdatId"]?.ToString(),
                        notiTypeCode = row["notiTypeCode"]?.ToString(),
                        notiName = row["notiName"]?.ToString(),
                        notiNumber = row["notiNumber"]?.ToString(),
                        sendPlaceCode = row["sendPlaceCode"]?.ToString(),
                        sendPlaceName = row["sendPlaceName"]?.ToString(),
                        citizenNumber = row["citizenNumber"]?.ToString(),
                        citizenName = row["citizenName"]?.ToString(),
                        area = row["area"]?.ToString(),
                        documentNumber = row["documentNumber"]?.ToString(),
                        publishDate = row["publishDate"]?.ToString(),
                        fileId = row["fileId"]?.ToString(),
                        //fileId = Encoding.UTF8.GetString(Encoding.GetEncoding(1252).GetBytes(row["fileId"]?.ToString() ?? "")),
                        //fileId = Encoding.UTF8.GetString(Encoding.GetEncoding(1252).GetBytes(HttpUtility.UrlDecode(row["fileId"]?.ToString() ?? ""))),
                        fileName = row["fileName"]?.ToString(),
                        note = noteList
                    };
                }

                string json = JsonConvert.SerializeObject(oBody, Formatting.Indented);

                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"INSERT INTO VNEID_TOAANNOTIFICATION (STATUS, CREATEDATE,TONGDATID,DOITUONGID,LOAIAN,CONTENT_JSON)
                           VALUES (:STATUS, :CREATEDATE, :TONGDATID,:DOITUONGID, :LOAIAN,:CONTENT_JSON)";
                    //string json = JsonConvert.SerializeObject(CONTENT_JSON);
                    using (OracleCommand cmd = new OracleCommand(sql, conn))
                    {
                        
                        cmd.Parameters.Add(new OracleParameter("STATUS", maloi));
                        cmd.Parameters.Add(new OracleParameter("CREATEDATE", DateTime.Now));
                        cmd.Parameters.Add(new OracleParameter("TONGDATID", tongdatid));
                        cmd.Parameters.Add(new OracleParameter("DOITUONGID", doituongid));
                        cmd.Parameters.Add(new OracleParameter("LOAIAN", loaivuviec));
                        cmd.Parameters.Add(new OracleParameter("CONTENT_JSON", json));

                        int rows = cmd.ExecuteNonQuery();
                        return rows;
                    }
                }
            }
            catch (Exception ex)
            {
                return 0;
            }
           
        }
    }
}