using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.GSTP.QLAN.GDTTT.In;
using WEB.GSTP.QLAN.GDTTT.In.DTGDTTTTableAdapters;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.Thongke
{
    public partial class ThongKeThuLyGQD_QuocHoi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    txtNgay_Tu.Text = "01/" + string.Format("{0:MM}", DateTime.Today) + "/" + DateTime.Today.Year;
                    txtNgay_Den.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);

                    LoadReport();

                }
            }
            catch (Exception ex) { lblmsg.Text = ex.Message; }
        }


        protected void btnXemBC_Click(object sender, EventArgs e)
        {
            try
            {
                LoadReport();
            }
            catch (Exception ex) { lblmsg.Text = ex.Message; }
        }
        private void LoadReport()
        {
            lblmsg.Text = "";

            if (CheckData() == false)
            {
                return;
            }
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DateTime? vNgayTu = txtNgay_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayDen = txtNgay_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault();
            rptThongKeTLGQDQH bc = new rptThongKeTLGQDQH();
            bc.Parameters["TuNgay"].Value = txtNgay_Tu.Text;
            bc.Parameters["DenNgay"].Value = txtNgay_Den.Text;
            bc.Parameters["TenPhongban"].Value = oPB.TENPHONGBAN;
            DTGDTTT._PKG_GDTTT_BAOCAO_THONGKE_THULY_QHDataTable tblDS_ST = new DTGDTTT._PKG_GDTTT_BAOCAO_THONGKE_THULY_QHDataTable();
            PKG_GDTTT_BAOCAO_THONGKE_THULY_QHTableAdapter tblBC = new PKG_GDTTT_BAOCAO_THONGKE_THULY_QHTableAdapter();
            object Result = new object();
            tblDS_ST = tblBC.GetData(ToaAnID, PBID, vNgayTu, vNgayDen, out Result);
            bc.DataSource = tblDS_ST;
            rptView.OpenReport(bc);
        }
        private bool CheckData()
        {
            string TuNgay = txtNgay_Tu.Text, DenNgay = txtNgay_Den.Text;
            if (TuNgay == "")
            {
                lblmsg.Text = "Chưa nhập từ ngày. Hãy nhập lại!";
                Cls_Comon.SetFocus(this.txtNgay_Tu, this.GetType(), txtNgay_Tu.ClientID);
                return false;
            }
            if (TuNgay != "")
            {
                DateTime Day_TuNgay = DateTime.Now;
                if (DateTime.TryParse(TuNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_TuNgay) == false)
                {
                    lblmsg.Text = "Chưa nhập từ ngày đúng theo định dạng (Ngày / Tháng / Năm). Hãy nhập lại!";
                    Cls_Comon.SetFocus(this.txtNgay_Tu, this.GetType(), txtNgay_Tu.ClientID);
                    return false;
                }
            }
            if (DenNgay == "")
            {
                lblmsg.Text = "Chưa nhập đến ngày. Hãy nhập lại!";
                Cls_Comon.SetFocus(this.txtNgay_Den, this.GetType(), txtNgay_Den.ClientID);
                return false;
            }
            if (DenNgay != "")
            {
                DateTime Day_DenNgay = DateTime.Now;
                if (DateTime.TryParse(DenNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_DenNgay) == false)
                {
                    lblmsg.Text = "Chưa nhập đến ngày đúng theo định dạng (Ngày / Tháng / Năm). Hãy nhập lại!";
                    Cls_Comon.SetFocus(this.txtNgay_Den, this.GetType(), txtNgay_Den.ClientID);
                    return false;
                }
            }
            return true;
        }
    }
}