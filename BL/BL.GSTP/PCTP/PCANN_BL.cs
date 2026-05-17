using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.PCTP
{
    public class PCANN_BL
    {
        // danh sách vụ án chờ phân công
        public DataTable PCANN_DS_ANCHOPC(decimal giai_doan, decimal toa_an_id, string tu_ngay, string den_ngay)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("p_giaidoan",giai_doan)
                ,new OracleParameter("p_id_toa_an",toa_an_id)
                , new OracleParameter("p_tu_ngay",tu_ngay)
                 , new OracleParameter("p_den_ngay",den_ngay)
                , new OracleParameter("p_out",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PCA_PKG.GET_DS_AN_CHO_PC", prm);            
        }

        // lưu thông tin lần phân công án 
        public decimal PCANN_LUU_QL_PCA(decimal id_can_bo, string ten_can_bo, string ngaypc, decimal toa_an_id)
        {
            decimal id_ql_pca = 0;
            List<OracleParameter> lstparamql = new List<OracleParameter>();
            lstparamql.Add(new OracleParameter("p_id_can_bo", OracleDbType.Decimal, id_can_bo, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_ten_can_bo", OracleDbType.Varchar2, ten_can_bo, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_ngay_pc", OracleDbType.Varchar2, ngaypc, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_id_toa_an", OracleDbType.Decimal, toa_an_id, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_id_out", OracleDbType.Decimal, ParameterDirection.Output));
            var ql_pca = Cls_Comon.ExecuteProcNonQuery("PCA_PKG.INSERT_QL_PHAN_CONG_AN", lstparamql);
            if (!string.IsNullOrEmpty(lstparamql[lstparamql.Count - 1].Value.ToString()))
            {
                id_ql_pca = Convert.ToDecimal(lstparamql[lstparamql.Count - 1].Value.ToString());
            }
            return id_ql_pca;
        }

        // lưu thông tin lần phân công án 
        public decimal PCANN_PHANCONGTHAMPHAN(string ngaypc, decimal id_vu_an, string loaian, decimal toa_an_id,decimal magiaidoan, string ten_vuan, decimal id_ql_pca, string so_thuly, string ngay_thuly, string rule_id)
        {
            List<OracleParameter> lstparam = new List<OracleParameter>();
            lstparam.Add(new OracleParameter("p_calc_date", OracleDbType.Varchar2, ngaypc, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_ID_VU_AN", OracleDbType.Decimal, id_vu_an, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_loai_an", OracleDbType.Varchar2, loaian, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_id_toa_an", OracleDbType.Decimal, toa_an_id, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_ma_giai_doan", OracleDbType.Decimal, magiaidoan, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_ten_vu_an", OracleDbType.Varchar2, ten_vuan, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_id_ql_pca", OracleDbType.Decimal, id_ql_pca, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_sothuly", OracleDbType.Varchar2, so_thuly, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_ngaythuly", OracleDbType.Varchar2, ngay_thuly, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_rule_id", OracleDbType.Varchar2, rule_id, ParameterDirection.Input));
            var result = Cls_Comon.ExecuteProcNonQuery("PCA_PKG.pr_phan_cong_tham_phan", lstparam);
            return result;
        }

        // danh sách vụ án đã phân công
        public DataTable PCANN_DS_ANDAPC(decimal giai_doan, decimal toa_an_id, string ten_vuan, string ten_thamphan, string tu_ngay, string den_ngay, decimal pageindex, decimal page_size)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("p_giaidoan",giai_doan)
                , new OracleParameter("p_id_toa_an",toa_an_id)
                , new OracleParameter("p_TEN_VU_AN",ten_vuan)
                , new OracleParameter("p_TEN_THAM_PHAN",ten_thamphan)
                , new OracleParameter("p_TU_NGAY",tu_ngay)
                , new OracleParameter("p_DEN_NGAY",den_ngay)
                , new OracleParameter("p_PAGE_INDEX",pageindex)
                , new OracleParameter("p_PAGE_SIZE",page_size)
                , new OracleParameter("p_OUT",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PCA_PKG.PRC_GET_KQ_PCA", prm);           
        }

        // danh sách điểm đã phân công án
        public DataSet PCANN_DS_DIEMDAPC(decimal giai_doan ,decimal toa_an_id, string ten_vuan, string ten_thamphan, string tu_ngay, string den_ngay, decimal pageindex, decimal page_size)
        {
            List<OracleParameter> lstparam = new List<OracleParameter>();
            lstparam.Add(new OracleParameter("p_giaidoan", OracleDbType.Decimal, giai_doan, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_id_toa_an", OracleDbType.Decimal, toa_an_id, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_TEN_VU_AN", OracleDbType.Varchar2, ten_vuan, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_TEN_THAM_PHAN", OracleDbType.Varchar2, ten_thamphan, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_TU_NGAY", OracleDbType.Varchar2, tu_ngay, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_DEN_NGAY", OracleDbType.Varchar2, den_ngay, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_PAGE_INDEX", OracleDbType.Decimal, pageindex, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_PAGE_SIZE", OracleDbType.Decimal, page_size, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_OUT", OracleDbType.RefCursor, ParameterDirection.Output));
            lstparam.Add(new OracleParameter("p_OUT_DIEM_TP", OracleDbType.RefCursor, ParameterDirection.Output));
            var result = Cls_Comon.ExecuteProcDataSet("PCA_PKG.GET_DIEM_PCA", lstparam);
            return result;
        }

        // danh sách phân công án
        public DataTable PCANN_DS_PCA(decimal toa_an_id, string ten_phancong, string tu_ngay, string den_ngay, decimal pageindex, decimal page_size)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("p_id_toa_an",toa_an_id)
                , new OracleParameter("p_TEN_CAN_BO",ten_phancong)
                , new OracleParameter("p_TU_NGAY",tu_ngay)
                , new OracleParameter("p_DEN_NGAY",den_ngay)
                , new OracleParameter("p_PAGE_INDEX",pageindex)
                , new OracleParameter("p_PAGE_SIZE",page_size)
                , new OracleParameter("p_OUT",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PCA_PKG.PRC_GET_QL_PCA", prm);
        }

        // danh sách phân công án
        public DataTable PCANN_DS_TIEUTRI(decimal toa_an_id, decimal pageindex, decimal page_size)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("p_id_toa",toa_an_id)
                ,new OracleParameter("p_PAGE_INDEX",pageindex)
                , new OracleParameter("p_PAGE_SIZE",page_size)
                , new OracleParameter("p_OUT",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PCA_PKG.PRC_GET_TIEU_TRI", prm);
        }

        // lưu thông tin tiêu trí sử dụng
        public decimal PCANN_LUUTIEUTRI(decimal toa_an_id, string ma_donvi, string strchon)
        {
            List<OracleParameter> lstparamql = new List<OracleParameter>();
            lstparamql.Add(new OracleParameter("p_id_toaan", OracleDbType.Decimal, toa_an_id, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_rule_id", OracleDbType.Varchar2, ma_donvi, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_ds_tieutri", OracleDbType.Varchar2, strchon, ParameterDirection.Input));
            var result = Cls_Comon.ExecuteProcNonQuery("PCA_PKG.INSERT_TIEUTRI_SD", lstparamql);
            return result;
        }

        // danh sách thống kê phân công án
        public DataTable PCANN_DS_THONGKE(decimal toa_an_id,string tu_ngay, string den_ngay, decimal pageindex, decimal page_size)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("p_TOA_AN_ID",toa_an_id)
                , new OracleParameter("p_TU_NGAY",tu_ngay)
                , new OracleParameter("p_DEN_NGAY",den_ngay)
                , new OracleParameter("p_PAGE_INDEX",pageindex)
                , new OracleParameter("p_PAGE_SIZE",page_size)
                , new OracleParameter("p_OUT",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PCA_PKG.PRC_BC_KET_QUA_PCA", prm);
        }

        // danh sách tòa án cấu hình
        public DataTable PCANN_DS_TOAAN_CAUHINH(decimal toa_an_id)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("p_id_toaan",toa_an_id)
                , new OracleParameter("p_out",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PCA_PKG.GET_TOAAN_CAUHINH", prm);
        }

        // danh sách thẩm phán cấu hình
        public DataTable PCANN_DS_THAMPHAN_CAUHINH(decimal toa_an_id, string ten_thamphan)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("p_id_toaan",toa_an_id)
                , new OracleParameter("p_tham_phan",ten_thamphan)               
                , new OracleParameter("p_out",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PCA_PKG.GET_DS_TP_CAUHINH", prm);
        }

        // lấy phân công án theo id
        public DataTable PCANN_DS_PCA_ID(decimal vID)
        {
            OracleParameter[] pca = new OracleParameter[]
               {
                    new OracleParameter("p_id_pca",vID)
                    , new OracleParameter("p_out",OracleDbType.RefCursor,ParameterDirection.Output)
               };
            return Cls_Comon.GetTableByProcedurePaging("PCA_PKG.GET_PCA_BYID", pca);
        }

        // lấy DM thẩm phán chờ phân công
        public DataTable PCANN_DM_THAMPHAN(decimal toa_an_id, decimal id_vuan, string loai_an)
        {
            OracleParameter[] prm = new OracleParameter[]
               {
                    new OracleParameter("p_id_toaan",toa_an_id)
                    , new OracleParameter("p_ID_VU_AN",id_vuan)
                    , new OracleParameter("p_loai_an",loai_an)
                    , new OracleParameter("p_out",OracleDbType.RefCursor,ParameterDirection.Output)
               };
            return Cls_Comon.GetTableByProcedurePaging("PCA_PKG.DM_TP", prm);
        }

        // sửa thẩm phán phân công án
        public decimal PCANN_LUUTHAMPHAN(decimal pcaID, decimal user_id, decimal thamphan_ct, string lydo)
        {
            List<OracleParameter> lstparamql = new List<OracleParameter>();
            lstparamql.Add(new OracleParameter("p_id_phan_cong_an", OracleDbType.Decimal, pcaID, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("P_USER_ID", OracleDbType.Decimal, user_id, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_ID_THAM_PHAN_CT", OracleDbType.Decimal, thamphan_ct, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_LY_DO", OracleDbType.Varchar2, lydo, ParameterDirection.Input));
            var result = Cls_Comon.ExecuteProcNonQuery("PCA_PKG.pr_loging_on_QLXX_PHAN_CONG_AN", lstparamql);
            return result;
        }

        // báo cáo kết quả phân công án
        public DataSet PCANN_BAOCAO(decimal vID)
        {
            List<OracleParameter> lstparam = new List<OracleParameter>();
            lstparam.Add(new OracleParameter("p_id_pc", OracleDbType.Decimal, vID, ParameterDirection.Input));
            lstparam.Add(new OracleParameter("p_out_loaian", OracleDbType.RefCursor, ParameterDirection.Output));
            lstparam.Add(new OracleParameter("p_out_anpc", OracleDbType.RefCursor, ParameterDirection.Output));
            var result = Cls_Comon.ExecuteProcDataSet("PCA_PKG.BAO_CAO_KQPC", lstparam);
            return result;
        }

        // cấu hình tòa án
        public decimal PCANN_CAUHINH_TOAAN(decimal id_toaan, decimal pc_don)
        {
            List<OracleParameter> lstparamql = new List<OracleParameter>();
            lstparamql.Add(new OracleParameter("p_id_toaan", OracleDbType.Decimal, id_toaan, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_pc_don", OracleDbType.Decimal, pc_don, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_out", OracleDbType.Varchar2, ParameterDirection.Output));
            var result = Cls_Comon.ExecuteProcNonQuery("PCA_PKG.INSERT_CAUHINH_TOAAN", lstparamql);
            return result;
        }

        // cấu hình thẩm phán
        public decimal PCANN_CAUHINH_TP(decimal id_canbo, decimal id_toaan, decimal pc_don, decimal pc_an)
        {
            List<OracleParameter> lstparamql = new List<OracleParameter>();
            lstparamql.Add(new OracleParameter("p_id_canbo", OracleDbType.Decimal, id_canbo, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_id_toaan", OracleDbType.Decimal, id_toaan, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_pc_don", OracleDbType.Decimal, pc_don, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_pc_an", OracleDbType.Decimal, pc_an, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_out", OracleDbType.Varchar2, ParameterDirection.Output));          
            var result = Cls_Comon.ExecuteProcNonQuery("PCA_PKG.INSERT_CAUHINH_TP", lstparamql);
            return result;
        }

        // xóa thẩm phán cấu hình
        public decimal PCANN_XOA_CAUHINH_TP(decimal id_toaan)
        {
            List<OracleParameter> lstparamql = new List<OracleParameter>();
            lstparamql.Add(new OracleParameter("p_id_toaan", OracleDbType.Decimal, id_toaan, ParameterDirection.Input));         
            lstparamql.Add(new OracleParameter("p_out", OracleDbType.Varchar2, ParameterDirection.Output));
            var result = Cls_Comon.ExecuteProcNonQuery("PCA_PKG.DELETE_CAU_HINH_TP", lstparamql);
            return result;
        }


        // check tòa án có phân công đơn không
        public DataTable PCANN_CHECK_TOA_PCDON(decimal toa_an_id)
        {
            OracleParameter[] prm = new OracleParameter[]
               {
                    new OracleParameter("p_id_toaan",toa_an_id)                    
                    , new OracleParameter("p_out",OracleDbType.RefCursor,ParameterDirection.Output)
               };
            return Cls_Comon.GetTableByProcedurePaging("PCA_PKG.CHECK_TOA_PCDON", prm);
        }

        //thêm ds vụ án đang phân công
        public decimal PCANN_THEM_DSAN_DPC(decimal id_vu_an, string loai_an, decimal id_ql_pca, decimal loai_pc)
        {
            List<OracleParameter> lstparamql = new List<OracleParameter>();
            lstparamql.Add(new OracleParameter("p_id_vu_an", OracleDbType.Decimal, id_vu_an, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_loai_an", OracleDbType.Varchar2, loai_an, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_id_ql_pca", OracleDbType.Decimal, id_ql_pca, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_loai_pc", OracleDbType.Decimal, loai_pc, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_out", OracleDbType.Varchar2, ParameterDirection.Output));
            var result = Cls_Comon.ExecuteProcNonQuery("PCA_PKG.INSERT_DS_AN_DANGPC", lstparamql);
            return result;
        }

        // xóa ds án đang phân phân công khi phân công hoàn thành 
        public decimal PCANN_XOA_DS_AN_DANGPC(decimal id_ql_pca)
        {
            List<OracleParameter> lstparamql = new List<OracleParameter>();
            lstparamql.Add(new OracleParameter("p_id_ql_pca", OracleDbType.Decimal, id_ql_pca, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_out", OracleDbType.Varchar2, ParameterDirection.Output));
            var result = Cls_Comon.ExecuteProcNonQuery("PCA_PKG.DELETE_DS_AN_PC_XONG", lstparamql);
            return result;
        }

        // lịch sử sửa thẩm phán
        public DataTable PCANN_LICHSU_SUATP(decimal pca_id)
        {
            OracleParameter[] prm = new OracleParameter[]
               {
                    new OracleParameter("p_pca",pca_id)
                    , new OracleParameter("p_out",OracleDbType.RefCursor,ParameterDirection.Output)
               };
            return Cls_Comon.GetTableByProcedurePaging("PCA_PKG.GET_LOG_PCA", prm);
        }

        // đồng bộ dữ liệu khi phân công xong 
        public decimal PCANN_DONGBO(decimal id_ql_pca)
        {
            List<OracleParameter> lstparamql = new List<OracleParameter>();
            lstparamql.Add(new OracleParameter("p_ql_pca", OracleDbType.Decimal, id_ql_pca, ParameterDirection.Input));
            lstparamql.Add(new OracleParameter("p_out", OracleDbType.Varchar2, ParameterDirection.Output));
            var result = Cls_Comon.ExecuteProcNonQuery("PCA_PKG.PRC_DONGBO_PCA", lstparamql);
            return result;
        }
    }
}