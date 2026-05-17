using BL.GSTP.PCTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.PCA
{
    public partial class CapNhatThamPhan : System.Web.UI.Page
    {
        PCANN_BL pca = new PCANN_BL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lbtthongbao.Text = "";
                LoadDropThamphan();
            }
               
        }
        void LoadDropThamphan()
        {
            decimal toa_an_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vID = Convert.ToInt32(Request["pcaid"]);
            //OracleParameter[] pca = new OracleParameter[]
            //   {
            //        new OracleParameter("p_id_pca",vID)                   
            //        , new OracleParameter("p_out",OracleDbType.RefCursor,ParameterDirection.Output)
            //   };
            //DataTable tbpca = Cls_Comon.GetTableByProcedurePaging("PCAConnection", "PCA_PKG.GET_PCA_BYID", pca);
            DataTable tbpca = pca.PCANN_DS_PCA_ID(vID);
            txtTenVuViec.Text = tbpca.Rows[0]["TEN_VU_AN"].ToString();

            //OracleParameter[] prm = new OracleParameter[]
            //   {
            //        new OracleParameter("p_id_toaan",toa_an_id)
            //        , new OracleParameter("p_ID_VU_AN",tbpca.Rows[0]["ID_VU_AN"])
            //        , new OracleParameter("p_loai_an",tbpca.Rows[0]["LOAI_AN"])
            //        , new OracleParameter("p_out",OracleDbType.RefCursor,ParameterDirection.Output)
            //   };
            //DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PCAConnection", "PCA_PKG.DM_TP", prm);
            DataTable tbl = pca.PCANN_DM_THAMPHAN(toa_an_id, Convert.ToDecimal(tbpca.Rows[0]["ID_VU_AN"]), tbpca.Rows[0]["LOAI_AN"].ToString());
            ddlThamphan.DataSource = tbl;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();

            ddlThamphan.SelectedValue = tbpca.Rows[0]["ID_THAM_PHAN_CT"].ToString();
            //ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));            
        }

        protected void lbsua_Click(object sender, EventArgs e)
        {
            lbtthongbao.Text = "";
            decimal pcaID = Convert.ToInt32(Request["pcaid"]);
            decimal user_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID]);
            decimal thamphan_ct = Convert.ToDecimal(ddlThamphan.SelectedValue);
            string lydo = txtLyDo.Text.Trim();
            if (lydo == "")
            {
                lbtthongbao.Text = "Bạn chưa nhập lý do sửa thẩm phán!";
                return;
            }     
            var ql_pca = pca.PCANN_LUUTHAMPHAN(pcaID, user_id, thamphan_ct, lydo);
            if (ql_pca == -1)
            {
                lbtthongbao.Text = "Cập nhật thẩm phán thành công!";
                hddIsReloadParent.Value = "1";
               
 
            }
            else
            {
                lbtthongbao.Text = "Cập nhật thẩm phán thất bại!";
            }
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
    }
}