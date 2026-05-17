using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BL.GSTP.BANGSETGET;
using DAL.GSTP;

using System.Globalization;
namespace BL.GSTP
{
    public class GDTTT_VUAN_BL
    {
        public bool NHAP_TACH_DONVI_INSERT(decimal _KetQuaQG,decimal _TOAANID, decimal _DONVIMOI, decimal _DONVICU, String _LYDO,
            String _GHICHU, string _DANHSACH, decimal _NGUOITAO, string _TAIKHOANTAO)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_NHAP_TACH_DONVI.NHAP_TACH_DONVI_IN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_KetQuaQG"].Value = _KetQuaQG;
            comm.Parameters["V_TOAANID"].Value = _TOAANID;
            comm.Parameters["V_DONVIMOI"].Value = _DONVIMOI;
            comm.Parameters["V_DONVICU"].Value = _DONVICU;
            comm.Parameters["V_LYDO"].Value = _LYDO;
            comm.Parameters["V_GHICHU"].Value = _GHICHU;
            comm.Parameters["V_DANHSACH"].Value = _DANHSACH;
            comm.Parameters["V_NGUOITAO"].Value = _NGUOITAO;
            comm.Parameters["V_TAIKHOANTAO"].Value = _TAIKHOANTAO;
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

        public DataTable GDTTT_DANHSACH_VUAN_SEARCH(decimal vToaAnID, decimal vPhongBanID,decimal vLoaiAn
           , decimal vKetquathuly, string vSoBA, string vNgayBA
           , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vKetquathuly",vKetquathuly),
                new OracleParameter("vSoBAQD",vSoBA),
                new OracleParameter("vNgayBAQD",vNgayBA),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_NHAP_TACH_DONVI.GDTTT_DANHSACH_VUAN_SEARCH", parameters);
            return tbl;
        }

        public DataTable DANHSACH_VUAN_NHAN(decimal vToaAnID, decimal vPhongBanID
            , decimal vLoaiAn , decimal PageIndex, decimal PageSize)
        {
           
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_NHAP_TACH_DONVI.GDTTT_DANHSACH_VUAN_NHAN", parameters);
            return tbl;
        }


        public void AHS_UpdateListTenDS(decimal VUVIECID)
        {
            OracleParameter[] prm = new OracleParameter[]
                                    {
                                         new OracleParameter("vuviec_id",VUVIECID),
                                         new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                                    };
            Cls_Comon.ExcuteProc("GDTTT_ANHS_UpdateDS", prm);
        }
        public DataTable AHS_GetAllNguoiKN(decimal VUVIECID)
        {
            OracleParameter[] parameters = new OracleParameter[]
                                    {
                                         new OracleParameter("vVuAnID",VUVIECID),
                                         new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_AHS_GetAllNguoiKN", parameters);
            return tbl;
        }

        public DataTable VUAN_RUTKN_SEARCH(decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
                                            , string vNgayBAQD
                                            , string vNguyendon, string vBidon
                                            , decimal vLoaiAn, decimal vThamtravien
                                            , decimal vLanhdao, decimal vThamphan
                                            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly

                                            , int LoaiAnDB, int IsHoanTHA, int IsRutKN
                                            , decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
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
                                                                        new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                         new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                           new OracleParameter("vSoThuly",vSoThuly),
                                                                        new OracleParameter("LoaiAnDB",LoaiAnDB),
                                                                         new OracleParameter("IsHoanTHA",IsHoanTHA),
                                                                          new OracleParameter("vIsRutKN",IsRutKN),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTTT_VuAn_RutKN_Search", parameters);
            return tbl;
        }
        

        public DataTable VUAN_SEARCH(String v_ID_USER, string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
            , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
            , string vNguyendon, string vBidon
            , decimal vLoaiAn, decimal vThamtravien
            , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
            , decimal vTraloidon, decimal vLoaiCVID
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
            , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
            , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB,String LoaiAnDB_TH, int IsHoanTHA
            , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM, decimal _SodonTLM, decimal _LoaiGDT
            ,string vQHPL_TD, decimal vloaingaysearch, DateTime? vNgaySearch_Tu, DateTime? vNgaySearch_Den, decimal PageIndex, decimal PageSize)
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
            String sql_para =
                  "V_ID_USER:='" + v_ID_USER + "'; "
                + "V_CONLAI_:='" + CHK_CONLAI_ + "'; "
                + "V_COLUME:='" + V_COLUME + "'; "
                + "V_ASC_DESC:='" + V_ASC_DESC + "'; "
                + "VTOAANID:=" + vToaAnID + "; "
                + "VPHONGBANID:=" + vPhongBanID + "; "
                + "VTOARABAQD:=" + vToaRaBAQD + "; "
                + "VSOBAQD:='" + vSoBAQD + "'; "
                + "VNGAYBAQD:='" + vNgayBAQD + "'; "
                + "VNGUOIGUI:='" + vNguoiGui + "'; "
                + "VCOQUANCHUYENDON:='" + vCoquanchuyendon + "'; "
                + "VNGUYENDON:='" + vNguyendon + "'; "
                + "VBIDON:='" + vBidon + "'; "
                + "VLOAIAN:=" + vLoaiAn + "; "
                + "VTHAMTRAVIEN:=" + vThamtravien + "; "
                + "VLANHDAO:=" + vLanhdao + "; "
                + "VTHAMPHAN:=" + vThamphan + "; "
                + "VQHPLID:=" + vQHPLID + "; "
                + "VQHPLDNID:=" + vQHPLDNID + "; "
                + "VTRALOIDON:=" + vTraloidon + "; "
                + "VLOAICVID:=" + vLoaiCVID + "; "
                // Xử lý DateTime cho Oracle
                + "VNGAYTHULYTU:=" + (vNgayThulyTu.HasValue ? "TO_DATE('" + vNgayThulyTu.Value.ToString("yyyy-MM-dd HH:mm:ss") + "','YYYY-MM-DD HH24:MI:SS')" : "NULL") + "; "
                + "VNGAYTHULYDEN:=" + (vNgayThulyDen.HasValue ? "TO_DATE('" + vNgayThulyDen.Value.ToString("yyyy-MM-dd HH:mm:ss") + "','YYYY-MM-DD HH24:MI:SS')" : "NULL") + "; "
                + "VSOTHULY:='" + vSoThuly + "'; "
                + "VTRANGTHAI:=" + vTrangthai + "; "
                + "VCAPTRINHTIEP:=" + captrinhtiep_id + "; "
                + "VISDANGKYBC:=" + isdangkybc + "; "
                + "VKETQUATHULY:=" + vKetquathuly + "; "
                + "VKETQUAXETXU:=" + vKetquaxetxu + "; "
                + "ISTTMUONHS:=" + isMuonHoSo + "; "
                + "ISTTTOTRINH:=" + isToTrinh + "; "
                + "ISTTYKIENKLTOTRINH:=" + isYKienKLToTrinh + "; "
                + "ISBUOCTT:=" + isBuocTT + "; "
                + "LOAIANDB:=" + LoaiAnDB + "; "
                + "VLOAIANDB_TH:='" + LoaiAnDB_TH + "'; "
                + "ISHOANTHA:=" + IsHoanTHA + "; "
                + "VTYPETB:=" + typetb + "; "
                + "VTYPEHDTP:=" + type_hoidongtp + "; "
                + "V_ISXINANGIAM:=" + _ISXINANGIAM + "; "
                + "V_GDT_ISXINANGIAM:=" + _GDT_ISXINANGIAM + "; "
                + "V_SODONTLM:=" + _SodonTLM + "; "
                + "V_LOAIGDT:=" + _LoaiGDT + "; "
                + "V_QHPL_TD:='" + vQHPL_TD + "'; "
                + "V_LOAINGAYSEARCH:=" + vloaingaysearch + "; "
                // Xử lý DateTime tiếp theo
                + "V_NGAYSEARCH_TU:=" + (vNgaySearch_Tu.HasValue ? "TO_DATE('" + vNgaySearch_Tu.Value.ToString("yyyy-MM-dd HH:mm:ss") + "','YYYY-MM-DD HH24:MI:SS')" : "NULL") + "; "
                + "V_NGAYSEARCH_DEN:=" + (vNgaySearch_Den.HasValue ? "TO_DATE('" + vNgaySearch_Den.Value.ToString("yyyy-MM-dd HH:mm:ss") + "','YYYY-MM-DD HH24:MI:SS')" : "NULL") + "; "
                + "PAGEINDEX:=" + PageIndex + "; "
                + "PAGESIZE:=" + PageSize + ";";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN.GDTTTT_VUAN_SEARCH", parameters);
            return tbl;
            //
        }

        public DataTable GDTTTT_TRACUU_VUAN_SEARCH(String v_ID_USER, string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN.GDTTTT_TRACUU_VUAN_SEARCH", parameters);
            return tbl;
            //
        }


        public DataTable VUAN_SEARCH_PRINT(string CHK_CONLAI_,string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
           , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
           , string vNguyendon, string vBidon
           , decimal vLoaiAn, decimal vThamtravien
           , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
           , decimal vTraloidon, decimal vLoaiCVID
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
           , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
           , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
           , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM, decimal _SodonTLM, decimal _LoaiGDT
            , string vQHPL_TD, decimal vloaingaysearch, DateTime? vNgaySearch_Tu, DateTime? vNgaySearch_Den
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

                new OracleParameter("v_SodonTLM",_SodonTLM),
                new OracleParameter("v_LoaiGDT",_LoaiGDT),
                new OracleParameter("v_QHPL_TD",vQHPL_TD),

                new OracleParameter("v_loaingaysearch",vloaingaysearch),
                new OracleParameter("v_NgaySearch_Tu",vNgaySearch_Tu),
                new OracleParameter("v_NgaySearch_Den",vNgaySearch_Den),

                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_INBC.GDTTTT_VUAN_SEARCH", parameters);
            return tbl;
            //
        }

        public DataTable VUAN_TRACUU_SEARCH_PRINT(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
           , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
           , string vNguyendon, string vBidon
           , decimal vLoaiAn, decimal vThamtravien
           , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
           , decimal vTraloidon, decimal vLoaiCVID
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
           , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
           , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
           , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM, decimal _SodonTLM, decimal _LoaiGDT
            , string vQHPL_TD, decimal vloaingaysearch, DateTime? vNgaySearch_Tu, DateTime? vNgaySearch_Den
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

                new OracleParameter("v_SodonTLM",_SodonTLM),
                new OracleParameter("v_LoaiGDT",_LoaiGDT),
                new OracleParameter("v_QHPL_TD",vQHPL_TD),

                new OracleParameter("v_loaingaysearch",vloaingaysearch),
                new OracleParameter("v_NgaySearch_Tu",vNgaySearch_Tu),
                new OracleParameter("v_NgaySearch_Den",vNgaySearch_Den),

                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_INBC.VUAN_TRACUU_SEARCH_PRINT", parameters);
            return tbl;
            //
        }


        public DataTable GDTTTT_VUAN_SEARCH_ANQH(string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
            , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
            , string vNguyendon, string vBidon
            , decimal vLoaiAn, decimal vThamtravien
            , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
            , decimal vTraloidon, decimal vLoaiCVID
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
            , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
            , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, int IsHoanTHA
            , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp
            , decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
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
                                                                        new OracleParameter("IsHoanTHA",IsHoanTHA),
                                                                        new OracleParameter("vTypeTB",typetb),
                                                                         new OracleParameter("vTypeHDTP",type_hoidongtp),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTTT_VUAN_SEARCH_ANQH", parameters);
            return tbl;
        }
        public DataTable VUAN_Search_NoPaging(decimal vToaAnID, decimal vPhongBanID
                                   , decimal vToaRaBAQD, string vSoBAQD
                                   , string vNgayBAQD, string vNguoiGui
                                   , string vCoquanchuyendon, string vNguyendon, string vBidon
                                   , decimal vLoaiAn, decimal vThamtravien, decimal vLanhdao, decimal vThamphan
                                   , decimal vQHPLID, decimal vQHPLDNID
                                   , decimal vTraloidon, decimal vLoaiCVID
                                   , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
                                   , string vSoThuly, decimal vTrangthai, decimal vKetquathuly
                                   , decimal vKetquaxetxu
                                   , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
                                   , int LoaiAnDB, int IsHoanTHA
            , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
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
                                                                        new OracleParameter("IsHoanTHA",IsHoanTHA),
                                                                        new OracleParameter("vTypeTB",typetb),

                                                                        new OracleParameter("vTypeHDTP",type_hoidongtp),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = null;
            if (vLoaiCVID == 0)
                tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VUAN_SEARCH_NOPAGING", parameters);
            else
                tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VUAN_SEARCHANQH_NOPAGING", parameters);
            return tbl;
        }


        public DataTable VUAN_TraCuu_Search_NoPaging(decimal vToaAnID, decimal vPhongBanID
                                   , decimal vToaRaBAQD, string vSoBAQD
                                   , string vNgayBAQD, string vNguoiGui
                                   , string vCoquanchuyendon, string vNguyendon, string vBidon
                                   , decimal vLoaiAn, decimal vThamtravien, decimal vLanhdao, decimal vThamphan
                                   , decimal vQHPLID, decimal vQHPLDNID
                                   , decimal vTraloidon, decimal vLoaiCVID
                                   , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
                                   , string vSoThuly, decimal vTrangthai, decimal vKetquathuly
                                   , decimal vKetquaxetxu
                                   , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
                                   , int LoaiAnDB, int IsHoanTHA
            , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
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
                                                                        new OracleParameter("IsHoanTHA",IsHoanTHA),
                                                                        new OracleParameter("vTypeTB",typetb),

                                                                        new OracleParameter("vTypeHDTP",type_hoidongtp),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = null;
            if (vLoaiCVID == 0)
                tbl = Cls_Comon.GetTableByProcedurePaging("VUAN_TraCuu_Search_NoPaging", parameters);
            else
                tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VUAN_SEARCHANQH_NOPAGING", parameters);
            return tbl;
        }


        public DataTable VUAN_PHANCONGTTV(decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD,
          string vNgayBAQD, string vNguyendon, string vBidon,
         decimal vLoaiAn, decimal vThamtravien, decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
          , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vTrangthai, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM,
          decimal vGIAIDOAN, decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
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
                new OracleParameter("vQHPLID",vQHPLID),
                new OracleParameter("vQHPLDNID",vQHPLDNID),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),
                new OracleParameter("v_GIAIDOAN",vGIAIDOAN),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_DON_APP.VUAN_PHANCONGTTV", parameters);
            return tbl;
        }

        public DataTable VUAN_PHANCONGTP(decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD,
          string vNgayBAQD, string vNguyendon, string vBidon,
         decimal vLoaiAn, decimal vThamtravien, decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
          , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vTrangthai, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM,
          decimal vGIAIDOAN, decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
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
                new OracleParameter("vQHPLID",vQHPLID),
                new OracleParameter("vQHPLDNID",vQHPLDNID),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),
                new OracleParameter("v_GIAIDOAN",vGIAIDOAN),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_DON_APP.VUAN_PHANCONGTP", parameters);
            return tbl;
        }

        public DataTable VUAN_TOTRINH(decimal vVuAnID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vVuAnID",vVuAnID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("GDTTT_VUAN_TOTRINH", prm);
        }
        public DataTable VUAN_TOTRINH_TOP1(decimal vVuAnID, decimal vThamPhanID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                
                new OracleParameter("vThamPhanID",vThamPhanID),
                new OracleParameter("vVuAnID",vVuAnID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GDTTT_VUAN_LOAD_TT", prm);
        }
        public DataTable TRALOIDON_DANHSACH(decimal vVuAnID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vVuAnID",vVuAnID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("GDTTT_DonTL_GetAllDS", prm);
        }
        public DataTable GDTTT_XXGDTTT_SearchByTP(decimal vToaAnID, decimal vPhongBanID
            , decimal vLoaiAn, decimal vThamphan
            , DateTime? tungay, DateTime? denngay
            , decimal vTrangthai, decimal vKetquaxetxu)
        {
            if (tungay == DateTime.MinValue) tungay = null;
            if (denngay == DateTime.MinValue) denngay = null;
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                                                        new OracleParameter("vLoaiAn",vLoaiAn),
                                                                         new OracleParameter("vThamphan",vThamphan),

                                                                        new OracleParameter("vTuNgay",tungay),
                                                                        new OracleParameter("vDenNgay",denngay),

                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("vKetquaxetxu",vKetquaxetxu),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GDTTT_XXGDTTT_SEARCHBYTP", parameters);
            return tbl;
        }

        //duongph 21/02/2022
        public DataTable VUAN_XETXU_SEARCH(decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD
            , string vNguyendon, string vBidon, decimal vLoaiAn
            , decimal vThamtravien, decimal vLanhdao, decimal vThamphan
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly
            , decimal vTrangthai, decimal vKetquaxetxu, int thamquyenxx
            , DateTime? NgayXX_TuNgay, DateTime? NgayXX_DenNgay, string SoKhangNghi, DateTime? NgayKN, decimal VIENTRUONGKN_NGUOIKY
            , decimal _LoaiGDT, decimal _QUAHAN_LUATDINH, decimal _Apdung_AnLe
            , decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            if (NgayXX_TuNgay == DateTime.MinValue) NgayXX_TuNgay = null;
            if (NgayXX_DenNgay == DateTime.MinValue) NgayXX_DenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
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

                                                                        new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                        new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                        new OracleParameter("vSoThuly",vSoThuly),

                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("vKetquaxetxu",vKetquaxetxu),
                                                                        new OracleParameter("vThamquyenxx",thamquyenxx),

                                                                        new OracleParameter("vNgayXX_Tu", NgayXX_TuNgay),
                                                                        new OracleParameter("vNgayXX_Den",NgayXX_DenNgay),
                                                                        new OracleParameter("vSoKhangNghi",SoKhangNghi),
                                                                        new OracleParameter("vNgayKhangNghi",NgayKN),
                                                                        new OracleParameter("vVIENTRUONGKN_NGUOIKY",VIENTRUONGKN_NGUOIKY),
                                                                        new OracleParameter("v_LoaiGDT",_LoaiGDT),
                                                                        new OracleParameter("v_QUAHAN_LUATDINH",_QUAHAN_LUATDINH),
                                                                        new OracleParameter("v_Apdung_AnLe",_Apdung_AnLe),

                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VUAN_XETXU_SEARCH", parameters);
            return tbl;
        }

        public DataTable THONGKE_TONGHOP(decimal vToaAnID, decimal vPhongBanID, decimal vLoaiAn, decimal vLanhdaoVu, decimal vThamTraVien)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vLanhdaoVu",vLanhdaoVu),
                new OracleParameter("vThamTraVien",vThamTraVien),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.THONGKE_TONGHOP", prm);
        }     
        public decimal GetNewSoToTrinh(decimal vPhongBanID, DateTime NgayLapToTrinh)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            DateTime tungay, denngay;
            int Year_TL = NgayLapToTrinh.Year;
            int Month_TL = NgayLapToTrinh.Month;
            //if (Month_TL == 12)
            //{
            //    tungay = DateTime.Parse(("1/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            //    denngay = DateTime.Parse(("30/11/" + (Year_TL + 1)), cul, DateTimeStyles.NoCurrentDateDefault);
            //}
            //else
            //{
            //    tungay = DateTime.Parse(("1/12/" + (Year_TL - 1)), cul, DateTimeStyles.NoCurrentDateDefault);
            //    denngay = DateTime.Parse(("30/11/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            //}
            tungay = DateTime.Parse(("1/1/" + (Year_TL)), cul, DateTimeStyles.NoCurrentDateDefault);
            denngay = DateTime.Parse(("31/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vPhongbanid",vPhongBanID),
                                                                        new OracleParameter("tu_ngay", tungay),
                                                                        new OracleParameter("den_ngay",denngay),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VuAn_GetMaxToTrinh", parameters);
            Decimal MaxTT = 0;
            if (tbl != null && tbl.Rows.Count > 0)
                MaxTT = String.IsNullOrEmpty(tbl.Rows[0]["CountAll"] + "") ? 1 : Convert.ToDecimal(tbl.Rows[0]["CountAll"]) + 1;
            else
                MaxTT = 1;
            return MaxTT;
        }
        public DataTable THONGKE_CHUNG(decimal vToaAnID, decimal vPhongBanID, decimal vLoaiAn, decimal vLanhdaoVu, decimal vThamTraVien)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vLanhdaoVu",vLanhdaoVu),
                new OracleParameter("vThamTraVien",vThamTraVien),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.THONGKE_CHUNG", prm);
        }

        public decimal GetLastGQD_SoCV(decimal phongbanid, DateTime NgayPhatHanhCV)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            DateTime tungay, denngay;
            int Year_TL = NgayPhatHanhCV.Year;
            int Month_TL = NgayPhatHanhCV.Month;
            //if (Month_TL == 12)
            //{
            //    tungay = DateTime.Parse(("1/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            //    denngay = DateTime.Parse(("30/11/" + (Year_TL + 1)), cul, DateTimeStyles.NoCurrentDateDefault);
            //}
            //else
            //{
            //    tungay = DateTime.Parse(("1/12/" + (Year_TL - 1)), cul, DateTimeStyles.NoCurrentDateDefault);
            //    denngay = DateTime.Parse(("30/11/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            //}
            tungay = DateTime.Parse(("1/1/" + (Year_TL)), cul, DateTimeStyles.NoCurrentDateDefault);
            denngay = DateTime.Parse(("31/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("phongban_id",phongbanid),
                                                                        new OracleParameter("tu_ngay", tungay),
                                                                        new OracleParameter("den_ngay",denngay),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VuAn_GetLastGQD_SoCV", parameters);
            Decimal MaxTT = 0;
            if (tbl != null && tbl.Rows.Count > 0)
                MaxTT = String.IsNullOrEmpty(tbl.Rows[0]["LastSoCVID"] + "") ? 1 : Convert.ToDecimal(tbl.Rows[0]["LastSoCVID"]) + 1;
            else
                MaxTT = 1;
            return MaxTT;
        }
        public decimal XXGDTTT_GetLastSoQD(decimal phongbanid, DateTime NgayThuLyGDTTT, int Loai)
        {
            try
            {
                CultureInfo cul = new CultureInfo("vi-VN");
                DateTime tungay, denngay;
                int Year_TL = NgayThuLyGDTTT.Year;
                int Month_TL = NgayThuLyGDTTT.Month;
                //if (Month_TL == 12)
                //{
                //    tungay = DateTime.Parse(("1/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
                //    denngay = DateTime.Parse(("30/11/" + (Year_TL + 1)), cul, DateTimeStyles.NoCurrentDateDefault);
                //}
                //else
                //{
                //    tungay = DateTime.Parse(("1/12/" + (Year_TL - 1)), cul, DateTimeStyles.NoCurrentDateDefault);
                //    denngay = DateTime.Parse(("30/11/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
                //}
                tungay = DateTime.Parse(("1/1/" + (Year_TL)), cul, DateTimeStyles.NoCurrentDateDefault);
                denngay = DateTime.Parse(("31/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
                /*Loai =1: VIENTRUONGKN , 2: THU LY XXGDTTT, 3: KET QUA XXGDTTT*/
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("phongban_id",phongbanid),
                                                                        new OracleParameter("loai", Loai),
                                                                        new OracleParameter("tu_ngay", tungay),
                                                                        new OracleParameter("den_ngay",denngay),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_XXGDTT_GetLasSoQD", parameters);
                Decimal MaxTT = 0;
                if (tbl != null && tbl.Rows.Count > 0)
                    MaxTT = String.IsNullOrEmpty(tbl.Rows[0]["LastSoTL"] + "") ? 1 : Convert.ToDecimal(tbl.Rows[0]["LastSoTL"]) + 1;
                else
                    MaxTT = 1;
                return MaxTT;
            }catch(Exception ex)
            {
                return 1;
            }
        }
        public decimal GetLastSoPhieuHS(decimal loaiphieu, DateTime NgayTaoPhieu, decimal donviid, decimal phongbanid)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            DateTime tungay, denngay;
            int Year_TL = NgayTaoPhieu.Year;
            int Month_TL = NgayTaoPhieu.Month;
            //if (Month_TL == 12)
            //{
            //    tungay = DateTime.Parse(("1/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            //    denngay = DateTime.Parse(("30/11/" + (Year_TL + 1)), cul, DateTimeStyles.NoCurrentDateDefault);
            //}
            //else
            //{
            //    tungay = DateTime.Parse(("1/12/" + (Year_TL - 1)), cul, DateTimeStyles.NoCurrentDateDefault);
            //    denngay = DateTime.Parse(("30/11/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            //}
                tungay = DateTime.Parse(("1/1/" + (Year_TL)), cul, DateTimeStyles.NoCurrentDateDefault);
                denngay = DateTime.Parse(("31/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("loaiphieu",loaiphieu),
                                                                        new OracleParameter("tu_ngay", tungay),
                                                                        new OracleParameter("den_ngay",denngay),
                                                                        new OracleParameter("v_donviid",donviid),
                                                                        new OracleParameter("v_phongbanid",phongbanid),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_QLHoSo_GetLastSoPhieuHS", parameters);
            Decimal MaxTT = 0;
            if (tbl != null && tbl.Rows.Count > 0)
                MaxTT = String.IsNullOrEmpty(tbl.Rows[0]["LastSoPhieu"] + "") ? 1 : Convert.ToDecimal(tbl.Rows[0]["LastSoPhieu"]) + 1;
            else
                MaxTT = 1;
            return MaxTT;
        }
        public decimal GetLastSoPhieuRutKN(DateTime NgayTaoPhieu)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            DateTime tungay, denngay;
            int Year_TL = NgayTaoPhieu.Year;
            int Month_TL = NgayTaoPhieu.Month;
            //if (Month_TL == 12)
            //{
            //    tungay = DateTime.Parse(("1/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            //    denngay = DateTime.Parse(("30/11/" + (Year_TL + 1)), cul, DateTimeStyles.NoCurrentDateDefault);
            //}
            //else
            //{
            //    tungay = DateTime.Parse(("1/12/" + (Year_TL - 1)), cul, DateTimeStyles.NoCurrentDateDefault);
            //    denngay = DateTime.Parse(("30/11/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            //}
            tungay = DateTime.Parse(("1/1/" + (Year_TL)), cul, DateTimeStyles.NoCurrentDateDefault);
            denngay = DateTime.Parse(("31/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("tu_ngay", tungay),
                                                                    new OracleParameter("den_ngay",denngay),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VuAn_GetLastSoRutKN", parameters);
            Decimal MaxTT = 0;
            if (tbl != null && tbl.Rows.Count > 0)
                MaxTT = String.IsNullOrEmpty(tbl.Rows[0]["LastSoPhieu"] + "") ? 1 : Convert.ToDecimal(tbl.Rows[0]["LastSoPhieu"]) + 1;
            else
                MaxTT = 1;
            return MaxTT;
        }



        public DataTable GDTTTT_THONGKE_ANQUOCHOI(Decimal vToaAnID, Decimal vPhongBanID, Decimal vLoaiAn
                                                    , decimal vThamtravien, decimal vLanhdao, decimal vThamphan
                                                    , decimal vLoaiCV, decimal vKetquathuly
                                                    , DateTime? vTuNgay, DateTime? vDenNgay
                                                    , string coquanchuyendon)
        {
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                                                        new OracleParameter("vLoaiAn",vLoaiAn),

                                                                        new OracleParameter("vThamtravien",vThamtravien),
                                                                        new OracleParameter("vLanhdao",vLanhdao),
                                                                        new OracleParameter("vThamphan",vThamphan),

                                                                        new OracleParameter("vLoaiCVID",vLoaiCV),
                                                                        new OracleParameter("vKetquathuly",vKetquathuly),

                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vCoQuanCD", coquanchuyendon),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTTT_THONGKE_ANQUOCHOI", parameters);
            return tbl;
        }

        public DataTable GDTTTT_THONGKE_ANTHOIHIEU(Decimal vToaAnID, Decimal vPhongBanID, decimal vLoaiAn
                                              , decimal vThamtravien, decimal vLanhdao, decimal vThamphan
                                              , decimal vThoiHieu, decimal vKetquathuly
                                              , DateTime? vDenNgay)
        {

            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                                                         new OracleParameter("vLoaiAn",vLoaiAn),

                                                                        new OracleParameter("vThamtravien",vThamtravien),
                                                                        new OracleParameter("vLanhdao",vLanhdao),
                                                                        new OracleParameter("vThamphan",vThamphan),

                                                                        new OracleParameter("vThoiHieu",vThoiHieu),
                                                                        new OracleParameter("vKetquathuly",vKetquathuly),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTTT_THONGKE_ANTHOIHIEU", parameters);
            return tbl;
        }

        //-------------------------------------------------------
        public DataTable QLToTrinh_VuAn_Search(decimal vToaAnID, decimal vPhongBanID
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

                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
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
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN.GDTTTT_QLTOTRINH_VUAN_SEARCH", parameters);
            return tbl;
        }

        public DataTable QLToTrinh_VuAnKhangNghi_Search(decimal vToaAnID, decimal vPhongBanID
          , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
          , string vNguyendon, string vBidon, decimal vLoaiAn
          , decimal vThamtravien, decimal vLanhdao, decimal vThamphan

          , DateTime? vTuNgay, DateTime? vDenNgay, string vSoThuly
          , decimal vTrangthai, int captrinhtiep_id, int isdangkybc
          , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
            , int ketquathuly, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
            ,DateTime? vNgayCongVan, string vLoaiSoVB, string vSoVB, string vTrangThaiChuyen
          , decimal PageIndex, decimal PageSize)
        {
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
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

                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
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

                                                                        new OracleParameter("vLoaiSoVB",vLoaiSoVB),
                                                                        new OracleParameter("vSoVB",vSoVB),
                                                                        new OracleParameter("vNgayVB",vNgayCongVan),
                                                                        new OracleParameter("vTrangThaiChuyen",vTrangThaiChuyen),

                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.GDTTTT_QLTOTRINH_VUAN_KHANG_NGHI_SEARCH", parameters);
            return tbl;
        }

        public DataTable QLToTrinh_VuAnKhangNghi_Search_BTP(decimal vToaAnID, decimal vPhongBanID
          , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
          , string vNguyendon, string vBidon, decimal vLoaiAn
          , decimal vThamtravien, decimal vLanhdao, decimal vThamphan

          , DateTime? vTuNgay, DateTime? vDenNgay, string vSoThuly
          , decimal vTrangthai, int captrinhtiep_id, int isdangkybc
          , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
            , int ketquathuly, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
            , DateTime? vNgayCongVan, string vLoaiSoVB, string vSoVB, decimal vTrangThaiChuyen, decimal vTrangThaiPC
          , decimal PageIndex, decimal PageSize)
        {
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
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

                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
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

                                                                        new OracleParameter("vLoaiSoVB",vLoaiSoVB),
                                                                        new OracleParameter("vSoVB",vSoVB),
                                                                        new OracleParameter("vNgayVB",vNgayCongVan),
                                                                        new OracleParameter("vTrangThaiChuyen",vTrangThaiChuyen),
                                                                        new OracleParameter("vTrangThaiPC",vTrangThaiPC),

                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.GDTTTT_QLTOTRINH_VUAN_KHANG_NGHI_BTP_SEARCH", parameters);
            return tbl;
        }

        public DataTable QLToTrinh_VuAnKhangNghi_BTP_Search_Print(decimal vToaAnID, decimal vPhongBanID
         , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
         , string vNguyendon, string vBidon, decimal vLoaiAn
         , decimal vThamtravien, decimal vLanhdao, decimal vThamphan

         , DateTime? vTuNgay, DateTime? vDenNgay, string vSoThuly
         , decimal vTrangthai, int captrinhtiep_id, int isdangkybc
         , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
           , int ketquathuly, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
            , DateTime? vNgayCongVan, string vLoaiSoVB, string vSoVB, string vTrangThaiChuyen
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

            new OracleParameter("vTuNgay",vTuNgay),
            new OracleParameter("vDenNgay",vDenNgay),
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

            new OracleParameter("vLoaiSoVB",vLoaiSoVB),
            new OracleParameter("vSoVB",vSoVB),
            new OracleParameter("vNgayVB",vNgayCongVan),
            new OracleParameter("vTrangThaiChuyen",vTrangThaiChuyen),

            new OracleParameter("PageIndex",PageIndex),
            new OracleParameter("PageSize",PageSize)
           };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.GDTTTT_QLTOTRINH_VUAN_KHANGNGHI_BTP_PRINT", parameters);
            return tbl;
        }

        public DataTable QLToTrinh_VuAnKhangNghi_InPhieu_Chuyen(decimal vToaAnID, decimal vPhongBanID
          , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
          , string vNguyendon, string vBidon, decimal vLoaiAn
          , decimal vThamtravien, decimal vLanhdao, decimal vThamphan

          , DateTime? vTuNgay, DateTime? vDenNgay, string vSoThuly
          , decimal vTrangthai, int captrinhtiep_id, int isdangkybc
          , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
            , int ketquathuly, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
            , DateTime? vNgayCongVan, string vLoaiSoVB, string vSoVB, string vTrangThaiChuyen
          , decimal PageIndex, decimal PageSize)
        {
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
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

                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
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

                                                                        new OracleParameter("vLoaiSoVB",vLoaiSoVB),
                                                                        new OracleParameter("vSoVB",vSoVB),
                                                                        new OracleParameter("vNgayVB",vNgayCongVan),
                                                                        new OracleParameter("vTrangThaiChuyen",vTrangThaiChuyen),

                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.GDTTTT_QLTOTRINH_VAKN_INPHIEU_CHUYEN", parameters);
            return tbl;
        }

        public DataTable QLToTrinh_VuAn_Search_Print(decimal vToaAnID, decimal vPhongBanID
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

            new OracleParameter("vTuNgay",vTuNgay),
            new OracleParameter("vDenNgay",vDenNgay),
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_INBC.GDTTTT_QLTOTRINH_VUAN_SEARCH", parameters);
            return tbl;
        }

        public DataTable QLToTrinh_VuAnKhangNghi_Search_Print(decimal vToaAnID, decimal vPhongBanID
         , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
         , string vNguyendon, string vBidon, decimal vLoaiAn
         , decimal vThamtravien, decimal vLanhdao, decimal vThamphan

         , DateTime? vTuNgay, DateTime? vDenNgay, string vSoThuly
         , decimal vTrangthai, int captrinhtiep_id, int isdangkybc
         , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
           , int ketquathuly, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
            , DateTime? vNgayCongVan, string vLoaiSoVB, string vSoVB, string vTrangThaiChuyen
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

            new OracleParameter("vTuNgay",vTuNgay),
            new OracleParameter("vDenNgay",vDenNgay),
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

            new OracleParameter("vLoaiSoVB",vLoaiSoVB),
            new OracleParameter("vSoVB",vSoVB),
            new OracleParameter("vNgayVB",vNgayCongVan),
            new OracleParameter("vTrangThaiChuyen",vTrangThaiChuyen),

            new OracleParameter("PageIndex",PageIndex),
            new OracleParameter("PageSize",PageSize)
           };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.GDTTTT_QLTOTRINH_VUAN_KHANGNGHI_PRINT", parameters);
            return tbl;
        }

        public DataTable QLToTrinh_VuAn_Search_Print_BC(decimal vToaAnID, decimal vPhongBanID
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_INBC.GDTTTT_QLTOTRINH_BC_SEARCH", parameters);
            return tbl;
        }

        public DataTable QLToTrinh_VuAnKhangNghi_Search_Print_BC(decimal vToaAnID, decimal vPhongBanID
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.GDTTTT_QLTOTRINH_VUAN_KHANGNGHI_BC_SEARCH", parameters);
            return tbl;
        }

        public DataTable QLToTrinh_VuAn_Search_KoToTrinh(decimal vToaAnID, decimal vPhongBanID
          , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
          , string vNguyendon, string vBidon, decimal vLoaiAn
          , decimal vThamtravien, decimal vLanhdao, decimal vThamphan

          , DateTime? vDenNgay, string vSoThuly
          , decimal vTrangthai, int captrinhtiep_id, int isdangkybc
          , int isMuonHoSo, int isYKienKLToTrinh, int isBuocTT
            , int ketquathuly, int LoaiAnDB, int IsHoanTHA
          , decimal PageIndex, decimal PageSize)
        {
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
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

                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vSoThuly",vSoThuly),

                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("vCapTrinhTiep",captrinhtiep_id),
                                                                        new OracleParameter("vIsDangKyBC",isdangkybc),


                                                                        new OracleParameter("isTTMuonHS",isMuonHoSo),
                                                                        new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
                                                                           new OracleParameter("isBuocTT",isBuocTT),
                                                                           new OracleParameter("vKetquathuly",ketquathuly),
                                                                        new OracleParameter("LoaiAnDB",LoaiAnDB),
                                                                        new OracleParameter("IsHoanTHA",IsHoanTHA),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_ToTrinh_Search_KoToTrinh", parameters);
            return tbl;
        }
        //-------------------------------------------------------
        public DataTable QLHOSO_VUAN_SEARCH(decimal vToaAnID, decimal vPhongBanID
            , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
            , string vNguyendon, string vBidon, decimal vLoaiAn
            , decimal vThamtravien, decimal vLanhdao, decimal vThamphan
            , decimal vSophieunhan
            , DateTime? hs_tungay, DateTime? hs_denngay, string vSoThuly, decimal vKetquathuly
            , int isMuonHoSo
            , string vloaiphieu,decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
            , decimal PageIndex, decimal PageSize)
        {
            if (hs_tungay == DateTime.MinValue) hs_tungay = null;
            if (hs_denngay == DateTime.MinValue) hs_denngay = null;
            OracleParameter[] parameters = new OracleParameter[] {
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

                new OracleParameter("vSophieunhan",vSophieunhan),
                new OracleParameter("hs_tungay",hs_tungay),
                new OracleParameter("hs_denngay",hs_denngay),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vKetquathuly",vKetquathuly),

                new OracleParameter("isTTMuonHS",isMuonHoSo),
                new OracleParameter("vLoaiphieu",vloaiphieu),

                 new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_DON_APP.GDTTTT_VUAN_QLHS_SEARCH", parameters);
            return tbl;
        }


        public DataTable GQD_VUAN_SEARCHBYTP(decimal vToaAnID, decimal vPhongBanID
            , decimal vLoaiAn, decimal vThamphan
           , DateTime? vTuNgay, DateTime? vDenNgay, decimal vKetquathuly)
        {

            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                                                        new OracleParameter("vLoaiAn",vLoaiAn),
                                                                        new OracleParameter("vThamphan",vThamphan),

                                                                        new OracleParameter("vGQD_TuNgay",vTuNgay),
                                                                        new OracleParameter("vGQD_DenNgay",vDenNgay),

                                                                        new OracleParameter("vKetquathuly",vKetquathuly),
                                                                         new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GDTTTT_VUAN_GQD_SEARCH_BYTP", parameters);
            return tbl;
        }
        
        //duongph 21/03/2022
        public DataTable GQD_VUAN_SEARCH(decimal vToaAnID, decimal vPhongBanID
           , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
           , string vNguyendon, string vBidon, decimal vLoaiAn
           , decimal vThamtravien, decimal vLanhdao, decimal vThamphan
           , DateTime? vThuLyTuNgay, DateTime? vThuLyDenNgay
           , string vSoThuly
           , int vLoaiNgay, DateTime? NgayGQD_TuNgay, DateTime? NgayGQD_DenNgay
           , decimal vKetquathuly, decimal vKetquaxetxu, decimal vLoaiAnDB, String LoaiAnDB_TH
           , int typetb, decimal _LoaiGDT
           , decimal PageIndex, decimal PageSize)
        {
            if (vThuLyTuNgay == DateTime.MinValue) vThuLyTuNgay = null;
            if (vThuLyDenNgay == DateTime.MinValue) vThuLyDenNgay = null;
            if (NgayGQD_TuNgay == DateTime.MinValue) NgayGQD_TuNgay = null;
            if (NgayGQD_DenNgay == DateTime.MinValue) NgayGQD_DenNgay = null;
            OracleParameter[] parameters = new OracleParameter[] {
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

                new OracleParameter("vNgayThulyTu",vThuLyTuNgay),
                new OracleParameter("vNgayThulyDen",vThuLyDenNgay),
                new OracleParameter("vSoThuly",vSoThuly),

                    new OracleParameter("vLoaiNgay", vLoaiNgay),
                new OracleParameter("vGQD_TuNgay",NgayGQD_TuNgay),
                new OracleParameter("vGQD_DenNgay",NgayGQD_DenNgay),

                new OracleParameter("vKetquathuly",vKetquathuly),
                new OracleParameter("vKetquaxetxu",vKetquaxetxu),
                new OracleParameter("LoaiAnDB", vLoaiAnDB),
                new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                new OracleParameter("vTypeTB",typetb),
                new OracleParameter("v_LoaiGDT",_LoaiGDT),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN.GDTTTT_VUAN_GQD_SEARCH", parameters);
            return tbl;
        }
        
        //duongph 21/03/2022
        public DataTable GQD_VUAN_SEARCH_PRINT(decimal vToaAnID, decimal vPhongBanID
           , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
           , string vNguyendon, string vBidon, decimal vLoaiAn
           , decimal vThamtravien, decimal vLanhdao, decimal vThamphan
           , DateTime? vThuLyTuNgay, DateTime? vThuLyDenNgay
           , string vSoThuly
           , int vLoaiNgay, DateTime? NgayGQD_TuNgay, DateTime? NgayGQD_DenNgay
           , decimal vKetquathuly, decimal vKetquaxetxu, decimal vLoaiAnDB, String LoaiAnDB_TH
           , int typetb, decimal _LoaiGDT
           , decimal PageIndex, decimal PageSize)
        {
            if (vThuLyTuNgay == DateTime.MinValue) vThuLyTuNgay = null;
            if (vThuLyDenNgay == DateTime.MinValue) vThuLyDenNgay = null;
            if (NgayGQD_TuNgay == DateTime.MinValue) NgayGQD_TuNgay = null;
            if (NgayGQD_DenNgay == DateTime.MinValue) NgayGQD_DenNgay = null;
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

                    new OracleParameter("vNgayThulyTu",vThuLyTuNgay),
                    new OracleParameter("vNgayThulyDen",vThuLyDenNgay),
                    new OracleParameter("vSoThuly",vSoThuly),

                        new OracleParameter("vLoaiNgay", vLoaiNgay),
                    new OracleParameter("vGQD_TuNgay",NgayGQD_TuNgay),
                    new OracleParameter("vGQD_DenNgay",NgayGQD_DenNgay),

                    new OracleParameter("vKetquathuly",vKetquathuly),
                    new OracleParameter("vKetquaxetxu",vKetquaxetxu),
                    new OracleParameter("LoaiAnDB", vLoaiAnDB),
                    new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                    new OracleParameter("vTypeTB",typetb),
                    new OracleParameter("v_LoaiGDT",_LoaiGDT),
                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize",PageSize),
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_INBC.GDTTTT_VUAN_GQD_SEARCH", parameters);
            return tbl;
        }

        public DataTable GQD_VUAN_SEARCH_PRINT_BC(decimal vToaAnID, decimal vPhongBanID
           , decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
           , string vNguyendon, string vBidon, decimal vLoaiAn
           , decimal vThamtravien, decimal vLanhdao, decimal vThamphan
           , DateTime? vThuLyTuNgay, DateTime? vThuLyDenNgay
           , string vSoThuly
           , int vLoaiNgay, DateTime? NgayGQD_TuNgay, DateTime? NgayGQD_DenNgay
           , decimal vKetquathuly, decimal vKetquaxetxu, decimal vLoaiAnDB, String LoaiAnDB_TH
           , int typetb, int vThoihieu
           , decimal PageIndex, decimal PageSize)
        {
            if (vThuLyTuNgay == DateTime.MinValue) vThuLyTuNgay = null;
            if (vThuLyDenNgay == DateTime.MinValue) vThuLyDenNgay = null;
            if (NgayGQD_TuNgay == DateTime.MinValue) NgayGQD_TuNgay = null;
            if (NgayGQD_DenNgay == DateTime.MinValue) NgayGQD_DenNgay = null;
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

                    new OracleParameter("vNgayThulyTu",vThuLyTuNgay),
                    new OracleParameter("vNgayThulyDen",vThuLyDenNgay),
                    new OracleParameter("vSoThuly",vSoThuly),

                        new OracleParameter("vLoaiNgay", vLoaiNgay),
                    new OracleParameter("vGQD_TuNgay",NgayGQD_TuNgay),
                    new OracleParameter("vGQD_DenNgay",NgayGQD_DenNgay),

                    new OracleParameter("vKetquathuly",vKetquathuly),
                    new OracleParameter("vKetquaxetxu",vKetquaxetxu),
                    new OracleParameter("LoaiAnDB", vLoaiAnDB),
                    new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                    new OracleParameter("vTypeTB",typetb),
                    new OracleParameter("vThoihieu",vThoihieu),
                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize",PageSize)
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_INBC.GDTTTT_VUAN_GQD_BC_SEARCH", parameters);
            return tbl;
        }
        public Decimal GDTTT_DON_TRALOI_GetLastSo(Decimal VuAnID, DateTime ngay)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            DateTime tungay, denngay;
            int Year_TL = ngay.Year;
            int Month_TL = ngay.Month;
            if (Month_TL == 12)
            {
                tungay = DateTime.Parse(("1/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
                denngay = DateTime.Parse(("30/11/" + (Year_TL + 1)), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            else
            {
                tungay = DateTime.Parse(("1/12/" + (Year_TL - 1)), cul, DateTimeStyles.NoCurrentDateDefault);
                denngay = DateTime.Parse(("30/11/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            }

            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("vuan_id",VuAnID),
                                                                        new OracleParameter("tu_ngay",tungay),
                                                                        new OracleParameter("den_ngay",denngay),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_DONTL_GetLastSoQD", parameters);
            Decimal MaxTT = 0;
            if (tbl != null && tbl.Rows.Count > 0)
                MaxTT = String.IsNullOrEmpty(tbl.Rows[0]["LastSo"] + "") ? 1 : Convert.ToDecimal(tbl.Rows[0]["LastSo"]) + 1;
            else
                MaxTT = 1;
            return MaxTT;
        }
        public DataTable THONGKE_ANQUOCHOI_THOIHIEU_ByThamPhan(decimal vToaAnID, decimal vLoaiAn, decimal vThamphanID, decimal vAnQuocHoi, decimal vAnThoiHieu)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vAnQuocHoi",vAnQuocHoi),
                new OracleParameter("vAnThoiHieu",vAnThoiHieu),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("THONGKE_ANQH_THOIHIEU_THAMPHAN", prm);
        }


        public DataTable KNTP_SEARCH(String v_ID_USER, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
            , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
            , string vNguyendon, string vBidon, decimal vLoaiAn, decimal vThamtravien
            , decimal vLanhdao
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly
            , decimal vTrangthai, decimal vKetquathuly
            , int isMuonHoSo, int LoaiAnDB, String vNoidungKN
            , decimal _SodonTLM
            , decimal vloaingaysearch
            , DateTime? vNgaySearch_Tu
            , DateTime? vNgaySearch_Den
            , decimal PageIndex, decimal PageSize)
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
                    new OracleParameter("vThamtravien",vThamtravien),
                    new OracleParameter("vLanhdao",vLanhdao),
                    new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                    new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                    new OracleParameter("vSoThuly",vSoThuly),
                    new OracleParameter("vTrangthai",vTrangthai),
                    new OracleParameter("vKetquathuly",vKetquathuly),
                    new OracleParameter("isTTMuonHS",isMuonHoSo),
                    new OracleParameter("LoaiAnDB",LoaiAnDB),
                    new OracleParameter("vNoidungKN",vNoidungKN),
                    new OracleParameter("v_SodonTLM",_SodonTLM),
                    new OracleParameter("v_loaingaysearch",vloaingaysearch),
                    new OracleParameter("v_NgaySearch_Tu",vNgaySearch_Tu),
                    new OracleParameter("v_NgaySearch_Den",vNgaySearch_Den),

                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize",PageSize),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTTT_KNTP_CC.GDTTTT_KNTP_SEARCH", parameters);
            return tbl;
            //
        }

        public DataTable KNTP_SEARCH_PRINT(String v_ID_USER, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
           , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
           , decimal vLoaiAn, decimal vThamtravien
           , decimal vLanhdao
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly
           , decimal vTrangthai, decimal vKetquathuly
           , int isMuonHoSo, int LoaiAnDB, String vNoidungKN
           , decimal _SodonTLM
           , decimal vloaingaysearch
           , DateTime? vNgaySearch_Tu
           , DateTime? vNgaySearch_Den)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
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
                    new OracleParameter("vLoaiAn",vLoaiAn),
                    new OracleParameter("vThamtravien",vThamtravien),
                    new OracleParameter("vLanhdao",vLanhdao),
                    new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                    new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                    new OracleParameter("vSoThuly",vSoThuly),
                    new OracleParameter("vTrangthai",vTrangthai),
                    new OracleParameter("vKetquathuly",vKetquathuly),
                    new OracleParameter("isTTMuonHS",isMuonHoSo),
                    new OracleParameter("LoaiAnDB",LoaiAnDB),
                    new OracleParameter("vNoidungKN",vNoidungKN),
                    new OracleParameter("v_SodonTLM",_SodonTLM),
                    new OracleParameter("v_loaingaysearch",vloaingaysearch),
                    new OracleParameter("v_NgaySearch_Tu",vNgaySearch_Tu),
                    new OracleParameter("v_NgaySearch_Den",vNgaySearch_Den)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTTT_KNTP_CC.GDTTT_KNTP_SEARCH_PRINT", parameters);
            return tbl;
            //
        }

        public DataTable GDTTT_GHEPDON_VUAN(decimal vToaAnID, decimal vPhongBanID, string vToaRaBAQD, string vSoBAQD
            , string vNgayBAQD, decimal vLoaiAn, decimal vCapXX, string vKetquathuly,string vVuanid,decimal vDonid)
        {
            
            OracleParameter[] parameters = new OracleParameter[] {
                    
                    new OracleParameter("vToaAnID",vToaAnID),
                    new OracleParameter("vPhongBanID",vPhongBanID),
                    new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                    new OracleParameter("vSoBAQD",vSoBAQD),
                    new OracleParameter("vNgayBAQD",vNgayBAQD),
                    new OracleParameter("vLoaiAn",vLoaiAn),
                    new OracleParameter("vCapXX",vCapXX),
                    new OracleParameter("vKetquathuly",vKetquathuly),
                    new OracleParameter("vVuanid",vVuanid),
                    new OracleParameter("vDonid",vDonid),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN.GDTTTT_GHEPDON_VUAN", parameters);
            return tbl;
            //
        }

        public DataTable GDTTT_HOSO_INPHIEU(decimal vToaAnID, decimal vPhieuID)
        {

            OracleParameter[] parameters = new OracleParameter[] {

                    new OracleParameter("vToaAnID",vToaAnID),
                    new OracleParameter("vPhieuID",vPhieuID),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_CC.GDTTTT_HOSO_INPHIEU", parameters);
            return tbl;
            //
        }


    }
}