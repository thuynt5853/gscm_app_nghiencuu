using BL.GSTP;
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
    public partial class ThongKeChiTieu : System.Web.UI.Page
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
                    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                    decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
                    GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
                    //Thẩm tra viên
                    DataTable oTTVDT = oGDTBL.CANBO_GETBYPHONGBAN(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
                    ddlThamtravien.DataSource = oTTVDT;
                    ddlThamtravien.DataTextField = "HOTEN";
                    ddlThamtravien.DataValueField = "ID";
                    ddlThamtravien.DataBind();                   
                    ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

                    //Lãnh đạo
                    DM_CANBO_BL oCBBL = new DM_CANBO_BL();
                    DataTable oTLDDT = oGDTBL.CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PBID, ENUM_CHUCVU.CHUCVU_PVT, ENUM_CHUCVU.CHUCVU_VT);
                    ddlPhoVuTruong.DataSource = oTLDDT;
                    ddlPhoVuTruong.DataTextField = "HOTEN";
                    ddlPhoVuTruong.DataValueField = "ID";
                    ddlPhoVuTruong.DataBind();
                    ddlPhoVuTruong.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

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
            rptThongkeChitieu bc = new rptThongkeChitieu();
            bc.Parameters["TuNgay"].Value = txtNgay_Tu.Text;
            bc.Parameters["DenNgay"].Value = txtNgay_Den.Text;
            bc.Parameters["TenPhongban"].Value = oPB.TENPHONGBAN;
            DTGDTTT._PKG_GDTTT_BAOCAO_THONGKE_CHITIEUDataTable tblDS_ST = new DTGDTTT._PKG_GDTTT_BAOCAO_THONGKE_CHITIEUDataTable();
            PKG_GDTTT_BAOCAO_THONGKE_CHITIEUTableAdapter tblBC = new PKG_GDTTT_BAOCAO_THONGKE_CHITIEUTableAdapter();
            object Result = new object();
            decimal LanhDaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            decimal ThamtraVienID = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            tblDS_ST = tblBC.GetData(ToaAnID, PBID, vNgayTu, vNgayDen, LanhDaoID, ThamtraVienID, out Result);
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