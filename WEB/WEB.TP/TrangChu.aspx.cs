using BL.GSTP;
using BL.GSTP.ADS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using WEB.TP.In;
using BL.GSTP.TP_THADS;
using System.Text;
namespace WEB.TP
{
    public partial class TrangChu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            Decimal CurrUser = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUser == 0)
            {
                Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
            }
            if (!IsPostBack)
            {
                 LoadData_ThongBao();
            }
        }
        void LoadData_ThongBao()
        {
            String THAid = "";
            if (Session["LOAITOA"].ToString() != "TOICAO")
            {
                THAid = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
            }
            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = oBL.Get_ThongBaoSoLuong(Session[ENUM_SESSION.SESSION_USERNAME].ToString(), THAid);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                lbl_V_COUNT_ALL.Text = row["V_COUNT_ALL"] + "";
                lbl_V_COUNT_DANOP.Text = row["V_COUNT_DANOP"] + "";
                lbl_V_COUNT_CHUANOP.Text = row["V_COUNT_CHUANOP"] + "";
                lbl_V_VUVIEC_HOANTRA.Text = row["V_VUVIEC_HOANTRA"] + "";
                lbl_V_COUNT_DINHCHI.Text = row["V_COUNT_DINHCHI"] + "";
                lbl_V_TIEN_ALL.Text = row["V_TIEN_ALL"] + " VNĐ";
                lbl_V_TIEN_DANOP.Text = row["V_TIEN_DANOP"] + " VNĐ";
                lbl_V_TIEN_CHUANOP.Text = row["V_TIEN_CHUANOP"] + " VNĐ";
                lbl_V_TIEN_HOANTRA.Text = row["V_TIEN_HOANTRA"] + " VNĐ";
                lbl_V_TIEN_DINHCHI.Text = row["V_TIEN_DINHCHI"] + " VNĐ";
            }
        }
        protected void cmd_load_Click(object sender, ImageClickEventArgs e)
        {
            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            String V_DONVITHA_ID = "";
            V_DONVITHA_ID = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
            if (oBL.GET_SOLUONG_JOB(Session[ENUM_SESSION.SESSION_USERNAME].ToString(),V_DONVITHA_ID) ==true)
            {
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), "Alert", "alert('Bạn đã lấy dữ liệu thành công' )", true);
            }
            LoadData_ThongBao();
        }
    }
}