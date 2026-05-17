using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Globalization;

namespace BL.GSTP.QLAN
{
    public class DASHBOARD_GDT_BL
    {
        public DataTable MHCA_DANHSACH_THAMPHAN_TOICAO(String vToaAnID, Int32 vThamphan_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vThamphan_id",vThamphan_id),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DASHBOARD.GET_THAMPHAN_TOICAO", parameters);
            return tbl;
        }

        public DataTable MHCA_DANHSACH_SEARCH(String v_ID_USER, string V_COLUME, string V_ASC_DESC
            , decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD, string vNguoiGui
            , string vCoquanchuyendon, string vNguyendon, string vBidon, decimal vLoaiAn, decimal vThamphan
            , decimal vQHPLID, decimal vQHPLDNID, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly
            , decimal vKetquathuly, decimal vKetquaxetxu, int isYKienKLToTrinh, int LoaiAnDB, String LoaiAnDB_TH
            , decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
            , decimal vloaingaysearch, DateTime? vNgaySearch_Tu, DateTime? vNgaySearch_Den, decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_ID_USER",v_ID_USER),
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
                    new OracleParameter("vThamphan",vThamphan),
                    new OracleParameter("vQHPLID",vQHPLID),
                    new OracleParameter("vQHPLDNID",vQHPLDNID),
                    new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                    new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                    new OracleParameter("vSoThuly",vSoThuly),
                    new OracleParameter("vKetquathuly",vKetquathuly),
                    new OracleParameter("vKetquaxetxu",vKetquaxetxu),
                    new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
                    new OracleParameter("LoaiAnDB",LoaiAnDB),
                    new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                    new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                    new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),
                    new OracleParameter("v_loaingaysearch",vloaingaysearch),
                    new OracleParameter("v_NgaySearch_Tu",vNgaySearch_Tu),
                    new OracleParameter("v_NgaySearch_Den",vNgaySearch_Den),
                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize",PageSize),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DASHBOARD_GDT.MHCA_DANHSACH_SEARCH", parameters);
            return tbl;
            //
        }

        public DataTable MHCA_DANHSACH_SEARCH_DON(String v_ID_USER, string V_COLUME, string V_ASC_DESC
            , decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD, string vNguoiGui
            , string vCoquanchuyendon, string vNguyendon, string vBidon, decimal vLoaiAn, decimal vThamphan
            , decimal vQHPLID, decimal vQHPLDNID, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly
            , decimal vKetquathuly, decimal vKetquaxetxu, int isYKienKLToTrinh, int LoaiAnDB, String LoaiAnDB_TH
            , decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
            , decimal vloaingaysearch, DateTime? vNgaySearch_Tu, DateTime? vNgaySearch_Den, decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_ID_USER",v_ID_USER),
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
                    new OracleParameter("vThamphan",vThamphan),
                    new OracleParameter("vQHPLID",vQHPLID),
                    new OracleParameter("vQHPLDNID",vQHPLDNID),
                    new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                    new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                    new OracleParameter("vSoThuly",vSoThuly),
                    new OracleParameter("vKetquathuly",vKetquathuly),
                    new OracleParameter("vKetquaxetxu",vKetquaxetxu),
                    new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
                    new OracleParameter("LoaiAnDB",LoaiAnDB),
                    new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                    new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                    new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),
                    new OracleParameter("v_loaingaysearch",vloaingaysearch),
                    new OracleParameter("v_NgaySearch_Tu",vNgaySearch_Tu),
                    new OracleParameter("v_NgaySearch_Den",vNgaySearch_Den),
                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize",PageSize),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DASHBOARD_GDT_TEST.MHCA_DANHSACH_SEARCH_DON", parameters);
            return tbl;
            //
        }

        public DataTable MHCA_DANHSACH_SEARCH_DON_HS(String v_ID_USER, string V_COLUME, string V_ASC_DESC
            , decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD, string vNguoiGui
            , string vCoquanchuyendon, string vNguyendon, string vBidon, decimal vLoaiAn, decimal vThamphan
            , decimal vQHPLID, decimal vQHPLDNID, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly
            , decimal vKetquathuly, decimal vKetquaxetxu, int isYKienKLToTrinh, int LoaiAnDB, String LoaiAnDB_TH
            , decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
            , decimal vloaingaysearch, DateTime? vNgaySearch_Tu, DateTime? vNgaySearch_Den, decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_ID_USER",v_ID_USER),
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
                    new OracleParameter("vThamphan",vThamphan),
                    new OracleParameter("vQHPLID",vQHPLID),
                    new OracleParameter("vQHPLDNID",vQHPLDNID),
                    new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                    new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                    new OracleParameter("vSoThuly",vSoThuly),
                    new OracleParameter("vKetquathuly",vKetquathuly),
                    new OracleParameter("vKetquaxetxu",vKetquaxetxu),
                    new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
                    new OracleParameter("LoaiAnDB",LoaiAnDB),
                    new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                    new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                    new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),
                    new OracleParameter("v_loaingaysearch",vloaingaysearch),
                    new OracleParameter("v_NgaySearch_Tu",vNgaySearch_Tu),
                    new OracleParameter("v_NgaySearch_Den",vNgaySearch_Den),
                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize",PageSize),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DASHBOARD_GDT_TEST.MHCA_DANHSACH_SEARCH_DON_HS", parameters);
            return tbl;
            //
        }

        public DataTable MHCA_DANHSACH_SEARCH_DON_TP(String v_ID_USER, string V_COLUME, string V_ASC_DESC
            , decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD, string vNguoiGui
            , string vCoquanchuyendon, string vNguyendon, string vBidon, decimal vLoaiAn, decimal vThamphan
            , decimal vQHPLID, decimal vQHPLDNID, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly
            , decimal vKetquathuly, decimal vKetquaxetxu, int isYKienKLToTrinh, int LoaiAnDB, String LoaiAnDB_TH
            , decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
            , decimal vloaingaysearch, DateTime? vNgaySearch_Tu, DateTime? vNgaySearch_Den, decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_ID_USER",v_ID_USER),
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
                    new OracleParameter("vThamphan",vThamphan),
                    new OracleParameter("vQHPLID",vQHPLID),
                    new OracleParameter("vQHPLDNID",vQHPLDNID),
                    new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                    new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                    new OracleParameter("vSoThuly",vSoThuly),
                    new OracleParameter("vKetquathuly",vKetquathuly),
                    new OracleParameter("vKetquaxetxu",vKetquaxetxu),
                    new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
                    new OracleParameter("LoaiAnDB",LoaiAnDB),
                    new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                    new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                    new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),
                    new OracleParameter("v_loaingaysearch",vloaingaysearch),
                    new OracleParameter("v_NgaySearch_Tu",vNgaySearch_Tu),
                    new OracleParameter("v_NgaySearch_Den",vNgaySearch_Den),
                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize",PageSize),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DASHBOARD_GDT_TEST.MHCA_DANHSACH_SEARCH_DON_TP", parameters);
            return tbl;
            //
        }

        public DataTable MHCA_DANHSACH_SEARCH_VUAN(String v_ID_USER, string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
            , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
            , string vNguyendon, string vBidon
            , decimal vLoaiAn, decimal vThamtravien
            , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
            , decimal vTraloidon, decimal vLoaiCVID
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
            , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
            , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
            , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM, decimal _SodonTLM, decimal _LoaiGDT
            , string vQHPL_TD, decimal vloaingaysearch, DateTime? vNgaySearch_Tu, DateTime? vNgaySearch_Den, decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_ID_USER",v_ID_USER),
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
                    new OracleParameter("v_SodonTLM",_SodonTLM),
                    new OracleParameter("v_LoaiGDT",_LoaiGDT),
                    new OracleParameter("v_QHPL_TD",vQHPL_TD),

                    new OracleParameter("v_loaingaysearch",vloaingaysearch),
                    new OracleParameter("v_NgaySearch_Tu",vNgaySearch_Tu),
                    new OracleParameter("v_NgaySearch_Den",vNgaySearch_Den),

                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize",PageSize),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DASHBOARD_GDT_TEST.MHCA_DANHSACH_SEARCH_VUAN", parameters);
            return tbl;
            //
        }

        public DataTable MHCA_DANHSACH_SEARCH_VUAN_THOIHIEU(String v_ID_USER, string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
            , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
            , string vNguyendon, string vBidon
            , decimal vLoaiAn, decimal vThamtravien
            , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
            , decimal vTraloidon, decimal vLoaiCVID
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
            , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
            , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
            , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM, decimal _SodonTLM, decimal _LoaiGDT
            , string vQHPL_TD, decimal vloaingaysearch, DateTime? vNgaySearch_Tu, DateTime? vNgaySearch_Den, decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_ID_USER",v_ID_USER),
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
                    new OracleParameter("v_SodonTLM",_SodonTLM),
                    new OracleParameter("v_LoaiGDT",_LoaiGDT),
                    new OracleParameter("v_QHPL_TD",vQHPL_TD),

                    new OracleParameter("v_loaingaysearch",vloaingaysearch),
                    new OracleParameter("v_NgaySearch_Tu",vNgaySearch_Tu),
                    new OracleParameter("v_NgaySearch_Den",vNgaySearch_Den),

                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize",PageSize),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DASHBOARD_GDT_TEST.MHCA_DANHSACH_SEARCH_VUAN_THOIHIEU", parameters);
            return tbl;
            //
        }

        public DataTable MHCA_DANHSACH_SEARCH_VUAN_TP(String v_ID_USER, string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
            , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
            , string vNguyendon, string vBidon
            , decimal vLoaiAn, decimal vThamtravien
            , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
            , decimal vTraloidon, decimal vLoaiCVID
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
            , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
            , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
            , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM, decimal _SodonTLM, decimal _LoaiGDT
            , string vQHPL_TD, decimal vloaingaysearch, DateTime? vNgaySearch_Tu, DateTime? vNgaySearch_Den, decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_ID_USER",v_ID_USER),
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
                    new OracleParameter("v_SodonTLM",_SodonTLM),
                    new OracleParameter("v_LoaiGDT",_LoaiGDT),
                    new OracleParameter("v_QHPL_TD",vQHPL_TD),

                    new OracleParameter("v_loaingaysearch",vloaingaysearch),
                    new OracleParameter("v_NgaySearch_Tu",vNgaySearch_Tu),
                    new OracleParameter("v_NgaySearch_Den",vNgaySearch_Den),

                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize",PageSize),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DASHBOARD_GDT_TEST.MHCA_DANHSACH_SEARCH_VUAN_TP", parameters);
            return tbl;
            //
        }
    }
}