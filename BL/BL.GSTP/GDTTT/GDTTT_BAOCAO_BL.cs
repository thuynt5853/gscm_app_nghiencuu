using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
using BL.GSTP.BANGSETGET;
using System.Globalization;

namespace BL.GSTP.GDTTT
{
    public class GDTTT_BAOCAO_BL
    {
        ///-------------------------------------------------
        public DataTable BC_VGDKT_1_PRINT(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
        , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
        , string vNguyendon, string vBidon
        , decimal vLoaiAn, decimal vThamtravien
        , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
        , decimal vTraloidon, decimal vLoaiCVID
        , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
        , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
        , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
        , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
        , decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CONLAI_",CHK_CONLAI_),
                new OracleParameter("V_COLUME",V_COLUME),
                new OracleParameter("V_ASC_DESC",V_ASC_DESC),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vCoquanchuyendon",vCoquanchuyendon),
                new OracleParameter("vNguyendon",vNguyendon),
                new OracleParameter("vBidon",vBidon),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vThamtravien",vThamtravien),
                new OracleParameter("vLanhdao",vLanhdao),
                new OracleParameter("vThamphan",vThamphan),
                new OracleParameter("vQHPLID",vQHPLID),
                new OracleParameter("vQHPLDNID",vQHPLDNID),
                new OracleParameter("vTraloidon",vTraloidon),
                new OracleParameter("vLoaiCVID",vLoaiCVID),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCapTrinhTiep",captrinhtiep_id),
                new OracleParameter("vIsDangKyBC",isdangkybc),
                new OracleParameter("vKetquathuly",vKetquathuly),
                new OracleParameter("vKetquaxetxu",vKetquaxetxu),

                new OracleParameter("isTTMuonHS",isMuonHoSo),
                new OracleParameter("isTTToTrinh", isToTrinh),
                new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
                new OracleParameter("isBuocTT",isBuocTT),
                new OracleParameter("LoaiAnDB",LoaiAnDB),
                new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                new OracleParameter("IsHoanTHA",IsHoanTHA),
                new OracleParameter("vTypeTB",typetb),

                new OracleParameter("vTypeHDTP",type_hoidongtp),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),

                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDTTTT_VUAN_SEARCH_BC1", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_2_PRINT(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
          , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
          , string vNguyendon, string vBidon
          , decimal vLoaiAn, decimal vThamtravien
          , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
          , decimal vTraloidon, decimal vLoaiCVID
          , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
          , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
          , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
          , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
          , decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CONLAI_",CHK_CONLAI_),
                new OracleParameter("V_COLUME",V_COLUME),
                new OracleParameter("V_ASC_DESC",V_ASC_DESC),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vCoquanchuyendon",vCoquanchuyendon),
                new OracleParameter("vNguyendon",vNguyendon),
                new OracleParameter("vBidon",vBidon),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vThamtravien",vThamtravien),
                new OracleParameter("vLanhdao",vLanhdao),
                new OracleParameter("vThamphan",vThamphan),
                new OracleParameter("vQHPLID",vQHPLID),
                new OracleParameter("vQHPLDNID",vQHPLDNID),
                new OracleParameter("vTraloidon",vTraloidon),
                new OracleParameter("vLoaiCVID",vLoaiCVID),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCapTrinhTiep",captrinhtiep_id),
                new OracleParameter("vIsDangKyBC",isdangkybc),
                new OracleParameter("vKetquathuly",vKetquathuly),
                new OracleParameter("vKetquaxetxu",vKetquaxetxu),

                new OracleParameter("isTTMuonHS",isMuonHoSo),
                new OracleParameter("isTTToTrinh", isToTrinh),
                new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
                new OracleParameter("isBuocTT",isBuocTT),
                new OracleParameter("LoaiAnDB",LoaiAnDB),
                new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                new OracleParameter("IsHoanTHA",IsHoanTHA),
                new OracleParameter("vTypeTB",typetb),

                new OracleParameter("vTypeHDTP",type_hoidongtp),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),

                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDTTTT_VUAN_SEARCH_BC2", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_4_PRINT(decimal vToaAnID, decimal vPhongBanID
       , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
        , string vNguyendon, string vBidon, decimal vLoaiAn
        , decimal vThamtravien, decimal vLanhdao, decimal vThamphan

        , DateTime? vTuNgay, DateTime? vDenNgay, string vSoThuly
        , decimal vTrangthai, int captrinhtiep_id, int isdangkybc
        , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
          , int ketquathuly, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
        , decimal PageIndex, decimal PageSize)
        {
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vPhongBanID",vPhongBanID),
            new OracleParameter("vToaRaBAQD",vToaRaBAQD),
            new OracleParameter("vSoBAQD",vSoBAQD),
            new OracleParameter("vNgayBAQD",vNgayBAQD),
            new OracleParameter("vNguyendon",vNguyendon),
            new OracleParameter("vBidon",vBidon),
            new OracleParameter("vLoaiAn",vLoaiAn),

            new OracleParameter("vThamtravien",vThamtravien),
            new OracleParameter("vLanhdao",vLanhdao),
            new OracleParameter("vThamphan",vThamphan),

            new OracleParameter("tt_TuNgay",vTuNgay),
            new OracleParameter("tt_DenNgay",vDenNgay),
            new OracleParameter("vSoThuly",vSoThuly),

            new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("vCapTrinhTiep",captrinhtiep_id),
            new OracleParameter("vIsDangKyBC",isdangkybc),

            new OracleParameter("isTTMuonHS",isMuonHoSo),
            new OracleParameter("isTTToTrinh", isToTrinh),
            new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
            new OracleParameter("isBuocTT",isBuocTT),

            new OracleParameter("vKetquathuly",ketquathuly),
            new OracleParameter("LoaiAnDB",LoaiAnDB),
            new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
            new OracleParameter("IsHoanTHA",IsHoanTHA),
            new OracleParameter("PageIndex",PageIndex),
            new OracleParameter("PageSize",PageSize)
           };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_TT.GDTTTT_QLTOTRINH_BC4", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_6_PRINT(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
          , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
          , string vNguyendon, string vBidon
          , decimal vLoaiAn, decimal vThamtravien
          , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
          , decimal vTraloidon, decimal vLoaiCVID
          , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
          , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
          , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
          , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
          , decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CONLAI_",CHK_CONLAI_),
                new OracleParameter("V_COLUME",V_COLUME),
                new OracleParameter("V_ASC_DESC",V_ASC_DESC),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vCoquanchuyendon",vCoquanchuyendon),
                new OracleParameter("vNguyendon",vNguyendon),
                new OracleParameter("vBidon",vBidon),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vThamtravien",vThamtravien),
                new OracleParameter("vLanhdao",vLanhdao),
                new OracleParameter("vThamphan",vThamphan),
                new OracleParameter("vQHPLID",vQHPLID),
                new OracleParameter("vQHPLDNID",vQHPLDNID),
                new OracleParameter("vTraloidon",vTraloidon),
                new OracleParameter("vLoaiCVID",vLoaiCVID),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCapTrinhTiep",captrinhtiep_id),
                new OracleParameter("vIsDangKyBC",isdangkybc),
                new OracleParameter("vKetquathuly",vKetquathuly),
                new OracleParameter("vKetquaxetxu",vKetquaxetxu),

                new OracleParameter("isTTMuonHS",isMuonHoSo),
                new OracleParameter("isTTToTrinh", isToTrinh),
                new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
                new OracleParameter("isBuocTT",isBuocTT),
                new OracleParameter("LoaiAnDB",LoaiAnDB),
                new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                new OracleParameter("IsHoanTHA",IsHoanTHA),
                new OracleParameter("vTypeTB",typetb),

                new OracleParameter("vTypeHDTP",type_hoidongtp),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),

                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDTTTT_VUAN_SEARCH_BC6", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_8_PRINT_GROUP(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
         , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
         , string vNguyendon, string vBidon
         , decimal vLoaiAn, decimal vThamtravien
         , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
         , decimal vTraloidon, decimal vLoaiCVID
         , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
         , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
         , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
         , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
         , decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CONLAI_",CHK_CONLAI_),
                new OracleParameter("V_COLUME",V_COLUME),
                new OracleParameter("V_ASC_DESC",V_ASC_DESC),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vCoquanchuyendon",vCoquanchuyendon),
                new OracleParameter("vNguyendon",vNguyendon),
                new OracleParameter("vBidon",vBidon),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vThamtravien",vThamtravien),
                new OracleParameter("vLanhdao",vLanhdao),
                new OracleParameter("vThamphan",vThamphan),
                new OracleParameter("vQHPLID",vQHPLID),
                new OracleParameter("vQHPLDNID",vQHPLDNID),
                new OracleParameter("vTraloidon",vTraloidon),
                new OracleParameter("vLoaiCVID",vLoaiCVID),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCapTrinhTiep",captrinhtiep_id),
                new OracleParameter("vIsDangKyBC",isdangkybc),
                new OracleParameter("vKetquathuly",vKetquathuly),
                new OracleParameter("vKetquaxetxu",vKetquaxetxu),

                new OracleParameter("isTTMuonHS",isMuonHoSo),
                new OracleParameter("isTTToTrinh", isToTrinh),
                new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
                new OracleParameter("isBuocTT",isBuocTT),
                new OracleParameter("LoaiAnDB",LoaiAnDB),
                new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                new OracleParameter("IsHoanTHA",IsHoanTHA),
                new OracleParameter("vTypeTB",typetb),

                new OracleParameter("vTypeHDTP",type_hoidongtp),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),

                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDTTTT_VUAN_SEARCH_BC8_GROUP", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_8_PRINT_ALL(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
        , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
        , string vNguyendon, string vBidon
        , decimal vLoaiAn, decimal vThamtravien
        , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
        , decimal vTraloidon, decimal vLoaiCVID
        , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
        , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
        , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
        , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
        , decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CONLAI_",CHK_CONLAI_),
                new OracleParameter("V_COLUME",V_COLUME),
                new OracleParameter("V_ASC_DESC",V_ASC_DESC),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vCoquanchuyendon",vCoquanchuyendon),
                new OracleParameter("vNguyendon",vNguyendon),
                new OracleParameter("vBidon",vBidon),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vThamtravien",vThamtravien),
                new OracleParameter("vLanhdao",vLanhdao),
                new OracleParameter("vThamphan",vThamphan),
                new OracleParameter("vQHPLID",vQHPLID),
                new OracleParameter("vQHPLDNID",vQHPLDNID),
                new OracleParameter("vTraloidon",vTraloidon),
                new OracleParameter("vLoaiCVID",vLoaiCVID),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCapTrinhTiep",captrinhtiep_id),
                new OracleParameter("vIsDangKyBC",isdangkybc),
                new OracleParameter("vKetquathuly",vKetquathuly),
                new OracleParameter("vKetquaxetxu",vKetquaxetxu),

                new OracleParameter("isTTMuonHS",isMuonHoSo),
                new OracleParameter("isTTToTrinh", isToTrinh),
                new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
                new OracleParameter("isBuocTT",isBuocTT),
                new OracleParameter("LoaiAnDB",LoaiAnDB),
                new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                new OracleParameter("IsHoanTHA",IsHoanTHA),
                new OracleParameter("vTypeTB",typetb),

                new OracleParameter("vTypeHDTP",type_hoidongtp),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),

                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDTTTT_VUAN_SEARCH_BC8_ALL", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_9_PRINT(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
          , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
          , string vNguyendon, string vBidon
          , decimal vLoaiAn, decimal vThamtravien
          , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
          , decimal vTraloidon, decimal vLoaiCVID
          , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
          , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
          , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
          , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
          , decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CONLAI_",CHK_CONLAI_),
                new OracleParameter("V_COLUME",V_COLUME),
                new OracleParameter("V_ASC_DESC",V_ASC_DESC),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vCoquanchuyendon",vCoquanchuyendon),
                new OracleParameter("vNguyendon",vNguyendon),
                new OracleParameter("vBidon",vBidon),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vThamtravien",vThamtravien),
                new OracleParameter("vLanhdao",vLanhdao),
                new OracleParameter("vThamphan",vThamphan),
                new OracleParameter("vQHPLID",vQHPLID),
                new OracleParameter("vQHPLDNID",vQHPLDNID),
                new OracleParameter("vTraloidon",vTraloidon),
                new OracleParameter("vLoaiCVID",vLoaiCVID),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCapTrinhTiep",captrinhtiep_id),
                new OracleParameter("vIsDangKyBC",isdangkybc),
                new OracleParameter("vKetquathuly",vKetquathuly),
                new OracleParameter("vKetquaxetxu",vKetquaxetxu),

                new OracleParameter("isTTMuonHS",isMuonHoSo),
                new OracleParameter("isTTToTrinh", isToTrinh),
                new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
                new OracleParameter("isBuocTT",isBuocTT),
                new OracleParameter("LoaiAnDB",LoaiAnDB),
                new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                new OracleParameter("IsHoanTHA",IsHoanTHA),
                new OracleParameter("vTypeTB",typetb),

                new OracleParameter("vTypeHDTP",type_hoidongtp),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),

                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_VA.GDTTTT_VUAN_SEARCH_BC9", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_10_PRINT(decimal vToaAnID, decimal vPhongBanID
       , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
        , string vNguyendon, string vBidon, decimal vLoaiAn
        , decimal vThamtravien, decimal vLanhdao, decimal vThamphan

        , DateTime? vTuNgay, DateTime? vDenNgay, string vSoThuly
        , decimal vTrangthai, int captrinhtiep_id, int isdangkybc
        , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
          , int ketquathuly, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
        , decimal PageIndex, decimal PageSize)
        {
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vPhongBanID",vPhongBanID),
            new OracleParameter("vToaRaBAQD",vToaRaBAQD),
            new OracleParameter("vSoBAQD",vSoBAQD),
            new OracleParameter("vNgayBAQD",vNgayBAQD),
            new OracleParameter("vNguyendon",vNguyendon),
            new OracleParameter("vBidon",vBidon),
            new OracleParameter("vLoaiAn",vLoaiAn),

            new OracleParameter("vThamtravien",vThamtravien),
            new OracleParameter("vLanhdao",vLanhdao),
            new OracleParameter("vThamphan",vThamphan),

            new OracleParameter("tt_TuNgay",vTuNgay),
            new OracleParameter("tt_DenNgay",vDenNgay),
            new OracleParameter("vSoThuly",vSoThuly),

            new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("vCapTrinhTiep",captrinhtiep_id),
            new OracleParameter("vIsDangKyBC",isdangkybc),

            new OracleParameter("isTTMuonHS",isMuonHoSo),
            new OracleParameter("isTTToTrinh", isToTrinh),
            new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
            new OracleParameter("isBuocTT",isBuocTT),

            new OracleParameter("vKetquathuly",ketquathuly),
            new OracleParameter("LoaiAnDB",LoaiAnDB),
            new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
            new OracleParameter("IsHoanTHA",IsHoanTHA),
            new OracleParameter("PageIndex",PageIndex),
            new OracleParameter("PageSize",PageSize)
           };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_TT.GDTTTT_QLTOTRINH_BC10", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_11_PRINT(decimal vToaAnID, decimal vPhongBanID
       , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
        , string vNguyendon, string vBidon, decimal vLoaiAn
        , decimal vThamtravien, decimal vLanhdao, decimal vThamphan

        , DateTime? vTuNgay, DateTime? vDenNgay, string vSoThuly
        , decimal vTrangthai, int captrinhtiep_id, int isdangkybc
        , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
          , int ketquathuly, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
        , decimal PageIndex, decimal PageSize)
        {
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vPhongBanID",vPhongBanID),
            new OracleParameter("vToaRaBAQD",vToaRaBAQD),
            new OracleParameter("vSoBAQD",vSoBAQD),
            new OracleParameter("vNgayBAQD",vNgayBAQD),
            new OracleParameter("vNguyendon",vNguyendon),
            new OracleParameter("vBidon",vBidon),
            new OracleParameter("vLoaiAn",vLoaiAn),

            new OracleParameter("vThamtravien",vThamtravien),
            new OracleParameter("vLanhdao",vLanhdao),
            new OracleParameter("vThamphan",vThamphan),

            new OracleParameter("tt_TuNgay",vTuNgay),
            new OracleParameter("tt_DenNgay",vDenNgay),
            new OracleParameter("vSoThuly",vSoThuly),

            new OracleParameter("vTrangthai",vTrangthai),
            new OracleParameter("vCapTrinhTiep",captrinhtiep_id),
            new OracleParameter("vIsDangKyBC",isdangkybc),

            new OracleParameter("isTTMuonHS",isMuonHoSo),
            new OracleParameter("isTTToTrinh", isToTrinh),
            new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
            new OracleParameter("isBuocTT",isBuocTT),

            new OracleParameter("vKetquathuly",ketquathuly),
            new OracleParameter("LoaiAnDB",LoaiAnDB),
            new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
            new OracleParameter("IsHoanTHA",IsHoanTHA),
            new OracleParameter("PageIndex",PageIndex),
            new OracleParameter("PageSize",PageSize)
           };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_TT.GDTTTT_QLTOTRINH_BC11", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_13_PRINT(String vToaAnID, String vPhongBanID, String vThamphanID, DateTime? vTuNgay, DateTime? vDenNgay)
        {
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_TT.BAOCAO_TH_THULY_GDKT_13", parameters);
            return tbl;
        }
        //--------------------------------------------------
        public DataTable BC_VGDKT_12_PRINT(Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, Decimal vLanhDaoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vLanhDaoID",vLanhDaoID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_VA.GDTTTT_VUAN_SEARCH_BC12", parameters);
            return tbl;
        }
        //--------------------------------------------------
        public DataTable BC_VGDKT_14_PRINT(Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, Decimal vLanhDaoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vLanhDaoID",vLanhDaoID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_VA.GDTTTT_VUAN_SEARCH_BC14", parameters);
            return tbl;
        }
        //--------------------------------------------------
        public DataTable BC_VGDKT_15_PRINT(Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, Decimal vLanhDaoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vLanhDaoID",vLanhDaoID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_VA.GDTTTT_VUAN_SEARCH_BC15", parameters);
            return tbl;
        }
        //--------------------------------------------------
        public DataTable BC_VGDKT_16_PRINT(Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_VA.GDTTTT_VUAN_SEARCH_BC16", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_17_PRINT(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, Decimal vLanhDaoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vLanhDaoID",vLanhDaoID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_VA_CC.GDTTTT_VUAN_SEARCH_BC17", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_18_PRINT(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, Decimal vLanhDaoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vLanhDaoID",vLanhDaoID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_VA_CC.GDTTTT_VUAN_SEARCH_BC18", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_19_PRINT(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, Decimal vLanhDaoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vLanhDaoID",vLanhDaoID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_VA_CC.GDTTTT_VUAN_SEARCH_BC19", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_20_PRINT(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, Decimal vLanhDaoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vLanhDaoID",vLanhDaoID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_VA_CC.GDTTTT_VUAN_SEARCH_BC20", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_21_PRINT(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, Decimal vLanhDaoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vLanhDaoID",vLanhDaoID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_VA_CC.GDTTTT_VUAN_SEARCH_BC21", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_24_PRINT(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, Decimal vLanhDaoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vLanhDaoID",vLanhDaoID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_V2.BC_VGDKT_24V", parameters);
            return tbl;
        }
        public DataTable BC_VGDKT_22_PRINT(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, Decimal vLanhDaoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vLanhDaoID",vLanhDaoID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_V2.BC_VGDKT_22V", parameters);
            return tbl;
        }
        //--------------------------------------------------
        public DataTable GetAll_ThongKeChiTieu(String v_TenPhongban, Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, DateTime? vTuNgay_ky, DateTime? vDenNgay_ky, Decimal vLanhDaoID, Decimal vThamtravienID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                 new OracleParameter("v_TenPhongban",v_TenPhongban),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vTuNgay_ky",vTuNgay_ky),
                new OracleParameter("vDenNgay_ky",vDenNgay_ky),
                new OracleParameter("vLanhDaoID",vLanhDaoID),
                new OracleParameter("vThamtravienID",vThamtravienID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_BAOCAO.BAOCAO_THONGKE_CHITIEU_01", parameters);
            return tbl;

        }
        public DataTable BAOCAO_TK_TP(String VTHAMPHANID_PCA, Decimal vToaAnID, Decimal vThamphanID, DateTime? vTuNgay, DateTime? vDenNgay, String vYears)
        {
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("VTHAMPHANID_PCA",VTHAMPHANID_PCA),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vYears",vYears)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_BAOCAO.BAOCAO_TK_TP_GET", parameters);
            return tbl;
        }
        public DataTable BAOCAO_TK_VU(decimal vToaAnID, decimal vPhongBanID, decimal vLanhdaoVu, decimal vThamTraVien)
        {
            OracleParameter[] prm = new OracleParameter[]
             {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vLanhdaoVu",vLanhdaoVu),
                new OracleParameter("vThamTraVien",vThamTraVien)
             };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_BAOCAO.BAOCAO_TK_VU", prm);
            return tbl;
        }
        public DataTable BaoCao_GQ_DonDN_GDTTT(Decimal vToaAnID, Int32 vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay)
        { //--
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BC_GQ_DONDN_GDTTT.BC_GQ_DONDN_GDTTT", parameters);
            return tbl;
        }
        public DataTable BAOCAO_TH_THULY_TP(String vToaAnID, String vThamphanID, String vThamphanID_Login, DateTime? vTuNgay, DateTime? vDenNgay)
        {
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vThamphanID_Login",vThamphanID_Login),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_BAOCAO.BAOCAO_TH_THULY_TP", parameters);
            return tbl;
        }
        public DataTable BAOCAO_TH_THULY_VU_GDKT(String vToaAnID, String vPhongBanID, String vThamphanID, DateTime? vTuNgay, DateTime? vDenNgay)
        {
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_BAOCAO.BAOCAO_TH_THULY_GDKT", parameters);
            return tbl;
        }
        public DataTable Letters_twcw_8A_Export(String _COURT_EXTID, String v_COURT_NAME, String _COURT_ID, String Time_ID, String Time_ID2)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("V_COURT_EXTID",_COURT_EXTID),
                new OracleParameter("v_COURT_NAME",v_COURT_NAME),
                new OracleParameter("v_COURT_ID",_COURT_ID),
                new OracleParameter("v_REPORT_TIME_ID",Time_ID),
                new OracleParameter("v_REPORT_TIME_ID2",Time_ID2)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_LETTERS_TWCW_8A.BC_LETTERS_8A_EXP", parameters);
            return tbl;

        }
        public DataTable Letters_twcw_2C_Export(String _COURT_EXTID, String v_COURT_NAME, String _COURT_ID, String Time_ID, String Time_ID2)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("V_COURT_EXTID",_COURT_EXTID),
                new OracleParameter("v_COURT_NAME",v_COURT_NAME),
                new OracleParameter("v_COURT_ID",_COURT_ID),
                new OracleParameter("v_REPORT_TIME_ID",Time_ID),
                new OracleParameter("v_REPORT_TIME_ID2",Time_ID2)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_LETTERS_TWCW_8A.BC_LETTERS_2C_EXP", parameters);
            return tbl;

        }

        public DataTable GDT01_Export(String _COURT_ID, String _LOAIAN_ID, String _LOAIXULY, DateTime _TUNGAY, DateTime _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_LOAIXULY",_LOAIXULY),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT01_Export", parameters);
            return tbl;

        }
        public DataTable GDT02_Export(String _COURT_ID, String _PhongbanID, String _LOAIGDT, String _LOAIAN_ID, String _LOAIXULY, DateTime _TUNGAY, DateTime _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_PhongbanID",_PhongbanID),
                new OracleParameter("V_LOAIGDT",_LOAIGDT),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_LOAIXULY",_LOAIXULY),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT02_Export", parameters);
            return tbl;

        }
        public DataTable GDT03_Export(String _COURT_ID, String _PhongbanID, String _LOAIAN_ID, String _LOAIXULY, DateTime _TUNGAY, DateTime _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_PhongbanID",_PhongbanID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_LOAIXULY",_LOAIXULY),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT03_Export", parameters);
            return tbl;

        }
        public DataTable GDT04_Export(String _COURT_ID, String _PhongbanID, String _LOAIAN_ID, String _LOAIXULY, DateTime _TUNGAY, DateTime _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_PhongbanID",_PhongbanID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_LOAIXULY",_LOAIXULY),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT04_Export", parameters);
            return tbl;

        }
        public DataTable GDT05_Export(String _COURT_ID, String _PhongbanID, String _LOAIAN_ID, String _LOAIXULY, DateTime _TUNGAY, DateTime _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_PhongbanID",_PhongbanID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_LOAIXULY",_LOAIXULY),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT05_Export", parameters);
            return tbl;

        }
        public DataTable GDT06_Export(String _COURT_ID, string _Donvi_KNID, String _LOAIAN_ID, String _LOAIXULY, DateTime _TUNGAY, DateTime _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_Donvi_KNID",_Donvi_KNID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_LOAIXULY",_LOAIXULY),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT06_Export", parameters);
            return tbl;

        }
        public DataTable GDT07_Export(String _COURT_ID, String _PhongbanID, String _LOAIAN_ID, String _LOAIXULY, DateTime _TUNGAY, DateTime _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_PhongbanID",_PhongbanID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_LOAIXULY",_LOAIXULY),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT07_Export", parameters);
            return tbl;

        }
        public DataTable GDT08_Export(String _COURT_ID, String _PhongbanID, String _LOAIAN_ID, String _LOAIXULY, DateTime _TUNGAY, DateTime _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_PhongbanID",_PhongbanID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_LOAIXULY",_LOAIXULY),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT08_Export", parameters);
            return tbl;

        }
        public DataTable GDT09_Export(String _COURT_ID, string _Donvi_KNID, String _LOAIAN_ID, String _LOAIXULY, String _TUNGAY, String _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_Donvi_KNID",_Donvi_KNID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_LOAIXULY",_LOAIXULY),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT09_Export", parameters);
            return tbl;

        }
        public DataTable GDT10_Export(String _COURT_ID, string _PHONGBANID, String _LOAIAN_ID, String _THAMPHAN_ID, String _TUNGAY, String _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_PHONGBANID",_PHONGBANID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_THAMPHAN_ID",_THAMPHAN_ID),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT10_Export", parameters);
            return tbl;

        }

        public DataTable GDT10_Export_NEW(String _COURT_ID, string _PHONGBANID, String _LOAIAN_ID, String _THAMPHAN_ID, String _TUNGAY, String _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_PHONGBANID",_PHONGBANID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_THAMPHAN_ID",_THAMPHAN_ID),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT10_Export_NEW", parameters);
            return tbl;

        }

        public DataTable GDT11_Export(String _COURT_ID, string _PHONGBANID, String _LOAIAN_ID, String _THAMTRAVIEN_ID, String _TUNGAY, String _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_PHONGBANID",_PHONGBANID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_THAMTRAVIEN_ID",_THAMTRAVIEN_ID),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT11_Export_NEW", parameters);
            return tbl;

        }
        public DataTable GDT12_Export(String _COURT_ID, String _PhongbanID, String _LOAIAN_ID, String _LOAIXULY, String _TUNGAY, String _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_PhongbanID",_PhongbanID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_LOAIXULY",_LOAIXULY),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT12_Export", parameters);
            return tbl;

        }


        public DataTable GDT13_Export(String _COURT_ID, String _PhongbanID, String _LOAIAN_ID, String _TUNGAY, String _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_PhongbanID",_PhongbanID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.GDT13_Export", parameters);
            return tbl;

        }

        public DataTable GDT14_Export(String _COURT_ID, string _Donvi_KNID, String _LOAIAN_ID, String _LOAIXULY, String _TUNGAY, String _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_Donvi_KNID",_Donvi_KNID),
                new OracleParameter("V_LOAIAN_ID",_LOAIAN_ID),
                new OracleParameter("v_LOAIXULY",_LOAIXULY),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_TUANVNA.GDT14_Export", parameters);
            return tbl;

        }
        public DataTable HCTP_09_Export(String _COURT_ID, String _TUNGAY, String _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDT09_Export_K", parameters);
            return tbl;

        }

        public DataTable TPGQD_Export(String _COURT_ID, String _PhongbanID, String _LOAIGDT, DateTime _TUNGAY, DateTime _DENNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_ToaAnID",_COURT_ID),
                new OracleParameter("V_PhongbanID",_PhongbanID),
                new OracleParameter("V_LOAIGDT",_LOAIGDT),
                new OracleParameter("v_TUNGAY",_TUNGAY),
                new OracleParameter("v_DENNGAY",_DENNGAY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO.TPGQD_Export", parameters);
            return tbl;
        }
        public DataTable TC_LABO_DETAIL_DIS_CW_8A(String V_ToaAnID, String V_PhongbanID, String V_LOAIGDT, String V_LOAIAN_ID, String V_LOAIXULY, DateTime V_NGAY_FROM, DateTime V_NGAY_TO)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_ToaAnID",V_ToaAnID),
                new OracleParameter("V_PhongbanID",V_PhongbanID),
                new OracleParameter("V_LOAIGDT",V_LOAIGDT),
                new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
                new OracleParameter("V_LOAIXULY",V_LOAIXULY),
                new OracleParameter("V_NGAY_FROM",V_NGAY_FROM),
                new OracleParameter("V_NGAY_TO",V_NGAY_TO)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_TK.TC_LABO_DETAIL_DIS_CW_8A", parameters);
            return tbl;
        }
        public static List<T> BC_VGDKT_23_READING<T>(string TuNgay, string DenNgay, string ChucDanhID, string ChucVuID, string PhongBanID) where T : new()
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                OracleCommand cmd = new OracleCommand();
                cmd.Connection = conn;
                cmd.BindByName = true;

                string Query = @" SELECT
                                        CASE
                                        WHEN cv.ID IS NOT NULL THEN cv.TEN || ' ' || c.HOTEN
                                        ELSE cd.TEN || ' ' || c.HOTEN
                                    END AS HoTen,

                                    SUM(CASE WHEN t.NGAYTRA IS NULL THEN 1 ELSE 0 END) AS TrinhMoi,
                                    SUM(CASE WHEN t.NGAYTRA IS NOT NULL AND t.LOAIYKIEN = 0 THEN 1 ELSE 0 END) AS TraLoiDon,
                                    SUM(
                                            CASE
                                                WHEN t.LOAIYKIEN = t.LOAIYKIEN_TTV
                                                THEN 1
                                            END
                                        ) AS KhangNghi,
                                    SUM(
                                        CASE
                                            WHEN t.NGAYTRA IS NULL
                                             AND t.NGAYTRINH <= :DenNgay
                                             AND NOT(
                                                 t.NGAYTRINH >= :TuNgay
                                                 AND t.NGAYTRINH <= :DenNgay
                                             )
                                            THEN 1
                                        END
                                    ) AS ChuaDuyet,
                                    SUM(CASE WHEN t.NGAYTRA IS NOT NULL AND t.LOAIYKIEN = 10 THEN 1 ELSE 0 END) AS SoToBaoCaoLai,
                                    COUNT(td.ID) as SoVuAnThamDu,    
                                    SUM(
                                        CASE
                                            WHEN t.NGAYTRA IS NOT NULL
                                             AND t.TINHTRANGID = 9
                                            THEN 1
                                            ELSE 0
                                        END
                                    ) AS SoVuAnDaBaoCao

                                    FROM GDTTT_TOTRINH t
                                    INNER JOIN DM_CANBO c on c.ID = t.LANHDAOID
                                    LEFT JOIN DM_DATAITEM cd on cd.ID = c.CHUCDANHID
                                    LEFT JOIN DM_DATAITEM cv on cv.ID = c.CHUCVUID
                                    INNER JOIN GDTTT_DM_TINHTRANG d on d.id = t.TINHTRANGID
                                    LEFT JOIN GDTTT_VUAN_XXGDTT_DAIDIEN_VUGDKT td
                                           ON td.DAIDIEN_VUGDKT_ID = t.LANHDAOID
                                    WHERE 1 = 1 ";

                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    Query += " AND t.NGAYTRINH >= :TuNgay AND t.NGAYTRINH <= :DenNgay";
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                }

                if (!string.IsNullOrEmpty(ChucDanhID) || !string.IsNullOrEmpty(ChucVuID))
                {
                    Query += " AND (c.CHUCDANHID = " + ChucDanhID + " OR c.CHUCVUID = " + ChucVuID + ")";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND c.PHONGBANID = " + PhongBanID + "";
                }
                Query += @" GROUP BY CASE
                                WHEN cv.ID IS NOT NULL THEN cv.TEN || ' ' || c.HOTEN
                                ELSE cd.TEN || ' ' || c.HOTEN
                            END ";
                cmd.CommandText = Query;
                OracleDataAdapter adapter = new OracleDataAdapter(cmd);
                DataTable tb = new DataTable();
                adapter.Fill(tb);
                adapter.Dispose();
                conn.Close(); conn.Dispose();
                return DataExtensions.CreateListFromTable<T>(tb);
            }
            catch (Exception ex)
            {
                conn.Close(); conn.Dispose();
                throw (ex);
            }

        }

        public static List<T> BC_VGDKT_25_COUNT<T>(string TuNgay, string DenNgay, string ChucDanhID, string ChucVuID, string PhongBanID, string ToaAnID) where T : new()
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                OracleCommand cmd = new OracleCommand();
                cmd.Connection = conn;
                cmd.BindByName = true;
                
                string Query = @" Select ";
                //kháng nghị của chánh án tòa án tối cao
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NVL(v.IsVienTruongKN,0) = 0
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001'))
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                Query += " AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0) ";
                if (!string.IsNullOrEmpty(TuNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" or(v.XXGDTTT_KETQUAID > 0 and(v.XXGDTTT_NGAYQD > :TuNgay))
                                or(NVL(v.IsRutKN, 0) = 1 and v.ngayrutkn > :TuNgay)
                             ";
                }
                Query +=  ")";
                if (!string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += " AND v.NgayThuLyXXGDT <= :DenNgay";
                }
                Query += " ) AS SoVuAnKhangNghiCATC,";
                //
                //kháng nghị của chánh án cấp cao
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY in (819, 820, 821)
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001'))
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                Query += " AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0) ";
                if (!string.IsNullOrEmpty(TuNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" or(v.XXGDTTT_KETQUAID > 0 and(v.XXGDTTT_NGAYQD > :TuNgay))
                                or(NVL(v.IsRutKN, 0) = 1 and v.ngayrutkn > :TuNgay)
                             ";
                }
                Query += ")";
                if (!string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += " AND v.NgayThuLyXXGDT <= :DenNgay";
                }
                Query += " ) AS SoVuAnKhangNghiCC,";
                //
                //kháng nghị viện trưởng viện ks
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) in (1) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 1
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001'))
                            ";
                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                Query += " AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0) ";
                if (!string.IsNullOrEmpty(TuNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" or(v.XXGDTTT_KETQUAID > 0 and(v.XXGDTTT_NGAYQD > :TuNgay))
                                or(NVL(v.IsRutKN, 0) = 1 and v.ngayrutkn > :TuNgay)
                             ";
                }
                Query += ")";
                if (!string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += " AND v.NgayThuLyXXGDT <= :DenNgay";
                }
                Query += " ) AS SoVuAnKhangNghiVksTC, ";
                //
                //đã xét xử trong năm
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10) 
                                    AND NVL(v.XXGDTTT_ISKETQUA,0)>0
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += " AND v.XXGDTTT_NGAYQD BETWEEN :TuNgay AND :DenNgay";
                }
                Query += " ) AS SoVuAnDaXetXu, ";
                //
                //tổng thụ lý tính đến ngày
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1)                                   
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                Query += @" AND (NOT EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID  
                                                               AND kq.trangthai = 1
                                                               ) ";
                if (!string.IsNullOrEmpty(TuNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" OR 
                                    EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                        WHERE KQ.VUANID = V.ID
                                                        AND kq.trangthai = 1
                                                        AND kq.gdq_ngay > :TuNgay
                                                        )";
                }
                Query += ")";
                Query += " ) AS TongSoVuAnDaThuLy, ";
                //
                //tổng thụ lý phân cho tp tối cao 
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =486 AND (CB.ID=v.THAMPHANID) )--TPTATC
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                Query += @" AND (NOT EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID  
                                                               AND kq.trangthai = 1
                                                               ) ";
                if (!string.IsNullOrEmpty(TuNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" OR 
                                    EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                        WHERE KQ.VUANID = V.ID
                                                        AND kq.trangthai = 1
                                                        AND kq.gdq_ngay > :TuNgay
                                                        )";
                }
                Query += ")";
                Query += " ) AS VuPhanTPTC, ";
                //
                //tổng thụ lý phân cho tp bậc 3 
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =2318 AND (CB.ID=v.THAMPHANID) )--TPTATC
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                Query += @" AND (NOT EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID  
                                                               AND kq.trangthai = 1
                                                               ) ";
                if (!string.IsNullOrEmpty(TuNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" OR 
                                    EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                        WHERE KQ.VUANID = V.ID
                                                        AND kq.trangthai = 1
                                                        AND kq.gdq_ngay > :TuNgay
                                                        )";
                }
                Query += ")";
                Query += " ) AS VuPhanTPB3, ";
                //
                //tổng thụ lý đã giải quyết tính đến ngày 
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1)                                 
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND( EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                               WHERE KQ.VUANID = V.ID
                                               AND kq.trangthai = 1
                                               AND kq.gdq_ngay BETWEEN :TuNgay and :DenNgay 
                                               ) 
                         )";
                }
                Query += " ) AS TongSoVuAnDaThuLyDaGiaiQuyet, ";
                //
                //tổng trả lời đơn trong kỳ 
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1)                                  
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN :TuNgay AND :DenNgay
                                                               AND kq.gqd_loaiketqua = 0
                                                               AND kq.trangthai = 1
                         )";
                }
                Query += " ) AS TongTraLoiDon, ";
                //
                //tổng kháng nghị trong kỳ 
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1)                                  
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN :TuNgay AND :DenNgay
                                                               AND kq.gqd_loaiketqua = 1
                                                               AND kq.trangthai = 1                                                                
                         )";
                }
                Query += " ) AS TongKhangNghi, ";
                //
                //tổng xử lý khác 
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1)                                  
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN :TuNgay AND :DenNgay
                                                               AND kq.gqd_loaiketqua in (2,3,4)
                                                               AND kq.trangthai = 1
                         )";
                }
                Query += " ) AS TongXuLyKhac, ";
                //
                //đang trình
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               )                                   
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN :TuNgay AND :DenNgay
                                                )";
                }
                Query += " ) AS SoVuAnDangTrinh, ";
                //
                //đang trình LDV
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               )                                   
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN :TuNgay AND :DenNgay
                                                    AND TT.TINHTRANGID in (4,5)
                                                )";
                }
                Query += " ) AS SoVuAnDangTrinhLDV, ";
                //
                //đang trình TPB3
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               )                                   
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN :TuNgay AND :DenNgay
                                                    AND TT.TINHTRANGID in (6) --Trinh TP
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =2318 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID))--TPBAC3
                                                )";
                }
                Query += " ) AS SoVuAnDangTrinhTPB3, ";
                //
                //đang trình TPTC
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               )                                   
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN :TuNgay AND :DenNgay
                                                    AND TT.TINHTRANGID in (6) --Trinh TP
                                                    AND EXISTS(SELECT 'X' FROM DM_CANBO CB WHERE cb.chucdanhid =486 AND (CB.ID=TT.LANHDAOID or CB.ID=TT.TRINHTIEP_LANHDAO_ID) )--TPTATC
                                                )";
                }
                Query += " ) AS SoVuAnDangTrinhTPTC, ";
                //
                //đang trình tổ thẩm phán
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               )                                   
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN :TuNgay AND :DenNgay
                                                    AND TT.TINHTRANGID in (9)
                                                )";
                }
                Query += " ) AS SoVuAnDangTrinhToTP, ";
                //
                //đang trình chánh án
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               )                                   
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN :TuNgay AND :DenNgay
                                                    AND TT.TINHTRANGID in (8) --Trinh CA
                                                )";
                }
                Query += " ) AS SoVuAnDangTrinhCA, ";
                //
                //đang trình phó chánh án
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               )                                   
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN :TuNgay AND :DenNgay
                                                    AND TT.TINHTRANGID in (7) --Trinh CA
                                                )";
                }
                Query += " ) AS SoVuAnDangTrinhPCA, ";
                //
                //đang trình dự thảo TLD
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               )                                   
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN :TuNgay AND :DenNgay
                                                    AND TT.TINHTRANGID in (11) 
                                                )";
                }
                Query += " ) AS SoVuAnDangTrinhDuThaoTLD, ";
                //
                //đang trình dự thảo KN
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               )                                   
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN :TuNgay AND :DenNgay
                                                    AND TT.TINHTRANGID in (12) 
                                                )";
                }
                Query += " ) AS SoVuAnDangTrinhDuThaoKN, ";
                //
                //đang nghiên cứu lại
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               )                                   
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN :TuNgay AND :DenNgay
                                                    AND TT.TINHTRANGID in (10) 
                                                )";
                }
                Query += " ) AS SoVuAnDangTrinhNghienCuuLai, ";
                //
                //đang hoàn thiện tờ trình để báo cáo CA pCA
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               )                                   
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                if (!string.IsNullOrEmpty(TuNgay) && !string.IsNullOrEmpty(DenNgay))
                {
                    cmd.Parameters.Add("TuNgay", OracleDbType.Date).Value = DateTime.ParseExact(TuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    cmd.Parameters.Add("DenNgay", OracleDbType.Date).Value = DateTime.ParseExact(DenNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    Query += @" AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN :TuNgay AND :DenNgay
                                                    AND TT.TINHTRANGID in (7) 
                                                )";
                }
                Query += " ) AS SoVuAnDangHoanThienToTrinh, ";
                //
                //đang nghiên cứu chưa có tờ trình
                Query += @" ( select Count(v.ID) 
                                    FROM GDTTT_VUAN v
                                    WHERE NVL(v.truonghopthuly,0) not in (8,10,1) 
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               )    
                                    and  NOT EXISTS ( SELECT 'X' FROM GDTTT_TOTRINH TT WHERE TT.VUANID =V.ID)
                            ";

                if (!string.IsNullOrEmpty(ToaAnID))
                {
                    Query += " AND v.TOAANID = " + ToaAnID + "";
                }
                if (!string.IsNullOrEmpty(PhongBanID))
                {
                    Query += " AND v.PHONGBANID = " + PhongBanID + "";
                }
                Query += " ) AS SoVuAnDangNghienCuu ";
                //
                Query += " From DUAL ";
                cmd.CommandText = Query;
                OracleDataAdapter adapter = new OracleDataAdapter(cmd);
                DataTable tb = new DataTable();
                adapter.Fill(tb);
                adapter.Dispose();
                conn.Close(); conn.Dispose();
                return DataExtensions.CreateListFromTable<T>(tb);
            }
            catch (Exception ex)
            {
                conn.Close(); conn.Dispose();
                throw (ex);
            }
        }

        public DataTable BC_TUAN_VGDKT_3_PRINT(Decimal vToaAnID, Decimal vPhongBanID, string vTuNgay, string vDenNgay)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_DATE_FROM",vTuNgay),
                new OracleParameter("V_DATE_TO",vDenNgay),
                new OracleParameter("V_TOAANID",vToaAnID),
                new OracleParameter("V_PHONGBANID",vPhongBanID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAOCAO_VUGDKT.SOLIEU_VUGDKT3", parameters);
            return tbl;
        }
        public DataTable BC_TUAN_VGDKT_2_PRINT(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, Decimal vLanhDaoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vLanhDaoID",vLanhDaoID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_V2.BC_TUAN_VGDKT_2V", parameters);
            return tbl;
        }
        public DataTable BC_THANG_VGDKT_2_PRINT(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, Decimal vToaAnID, Decimal vPhongBanID, DateTime? vTuNgay, DateTime? vDenNgay, Decimal vLanhDaoID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vLanhDaoID",vLanhDaoID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VGDKT_BAOCAO_V2.BC_THANG_VGDKT_2V", parameters);
            return tbl;
        }
    }
}