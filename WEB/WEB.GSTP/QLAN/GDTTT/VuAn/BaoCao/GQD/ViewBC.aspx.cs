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
//using WEB.GSTP.QLAN.GDTTT.In.DTGDTTTTableAdapters;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.GQD
{
    public partial class ViewBC : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                   txtTieuDeBC.Text = "Danh sách giải quyết đơn GĐT,TT";
                    try
                    {
                        LoadDropThamphan();
                    }
                    catch (Exception ex) { }
                    SetTieuDeBaoCao();
                    LoadReport();
                }
            }
            catch (Exception ex) { lttMsg.Text = "<div class='msg_error'>" + ex.Message + "</div>"; }
        }

        void LoadDropThamphan()
        {
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            //Load Thẩm phán
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Boolean IsLoadAll = false;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            try
            {
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA == "TPTATC")
                    {
                        ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        //---------------------
                        LoadDropLoaiAn(oCB);
                    }
                    else
                        IsLoadAll = true;
                }
                else
                    IsLoadAll = true;
            }catch(Exception ex) { IsLoadAll = true; }
            if (IsLoadAll)
            {
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
        }
        void LoadDropLoaiAn(DM_CANBO oCB)
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            //if (oCB.ISHINHSU == 1)
            //    ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            //if (oCB.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            //if (oCB.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            //if (oCB.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            //if (oCB.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            //if (oCB.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            //if (oCB.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }

        protected void btnXemBC_Click(object sender, EventArgs e)
        {
            try
            {
                //SetTieuDeBaoCao();
                LoadReport();
            }
            catch (Exception ex) { }
            //lttMsg.Text = "<div class='msg_error'>" + ex.Message+"</div>"; 
        }
        private void LoadReport()
        {
            lttMsg.Text = "";
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DateTime? vNgayTu = txtNgay_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayDen = txtNgay_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            //DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault();
            //string TenPhongBan = oPB.TENPHONGBAN;
            decimal thamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);

            #region Set thoigian
            String ThoiGian = "";
            if (vNgayTu == (DateTime?)null && vNgayDen == (DateTime?)null)
                ThoiGian = "(Tính đến ngày " + DateTime.Now.ToString("dd/MM/yyyy", cul) + ")";
            else
            {
                ThoiGian = "(";
                if (vNgayTu != (DateTime?)null && vNgayDen != (DateTime?)null)
                {
                    ThoiGian += "Từ ngày " + Convert.ToDateTime(vNgayTu).ToString("dd/MM/yyyy", cul);
                    ThoiGian += " đến ngày " + Convert.ToDateTime(vNgayDen).ToString("dd/MM/yyyy", cul);
                }
                else
                {
                    if (vNgayTu != (DateTime?)null)
                    {
                        ThoiGian += "Từ ngày " + Convert.ToDateTime(vNgayTu).ToString("dd/MM/yyyy", cul);
                        ThoiGian = " đến ngày " + DateTime.Now.ToString("dd/MM/yyyy", cul);
                    }
                    else
                        ThoiGian += "Tính đến ngày " + Convert.ToDateTime(vNgayDen).ToString("dd/MM/yyyy", cul);
                }
                ThoiGian += ")";
            }
            #endregion

            String report_name = "";
            decimal LoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            DataTable tblData = GetDsGQD();
            GQD.DSDonGDTTT gqd = new GQD.DSDonGDTTT();
            report_name = (String.IsNullOrEmpty(txtTieuDeBC.Text.Trim()) ? "Danh sách giải quyết đơn GĐT,TT" : txtTieuDeBC.Text.Trim()).ToUpper();
            gqd.Parameters["TieuDeBC"].Value = report_name;
            gqd.Parameters["ThoiGian"].Value = ThoiGian;
            gqd.Parameters["TieuDeTime"].Value = "Hà Nội, ngày " + DateTime.Now.Day + " tháng " + DateTime.Now.Month + " năm " + DateTime.Now.Year.ToString();

            gqd.Parameters["TongSo"].Value = tblData.Rows.Count + " vụ án";
            gqd.DataSource = tblData;
            rptView.OpenReport(gqd);
        }
        private DataTable GetDsGQD()
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();

            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);

            DateTime? vTuNgay = txtNgay_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vDenNgay = txtNgay_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
          
            decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
            DataTable tbl = null;
            tbl = oBL.GQD_VUAN_SEARCHBYTP(vToaAnID, vPhongbanID
                   , vLoaiAn, vThamphan
                   , vTuNgay, vDenNgay, vKetquathuly);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                String  lanhdao = "", ttv = "", machucvu = "", temp = "";
                foreach (DataRow row in tbl.Rows)
                {
                    ttv = row["TENTHAMTRAVIEN"] + "";
                    lanhdao = row["TENLANHDAO"] + "";
                    machucvu = row["MaChucVuLD"] + "";
                    temp = (string.IsNullOrEmpty(lanhdao)) ? "" : lanhdao + (String.IsNullOrEmpty(machucvu) ? "" : "(" + machucvu + ")");
                    temp += ((string.IsNullOrEmpty(temp)) ? "" : ", ") + (string.IsNullOrEmpty(ttv) ? "" : (ttv + "(TTV)"));
                    row["TENLANHDAO"] = temp;
                }
            }
            return tbl;
        }
        void SetTieuDeBaoCao()
        {
            //String KyTuXuongDong = "\r\n";
            string tieudebc = "";
            if (ddlLoaiAn.SelectedValue != "0")
                tieudebc += " là án " + ddlLoaiAn.SelectedItem.Text.ToLower();

            //-------------------------------------

            String canbophutrach = "";
            if (ddlThamphan.SelectedValue != "0")
                canbophutrach = "thẩm phán " + Cls_Comon.FormatTenRieng(ddlThamphan.SelectedItem.Text);
            if (!String.IsNullOrEmpty(canbophutrach))
                canbophutrach += " phụ trách";

            tieudebc += (string.IsNullOrEmpty(canbophutrach)) ? "" : " do " + canbophutrach;
            //-----------------------------------
            if (ddlKetquaThuLy.SelectedValue != "5")
            {
                int kq = Convert.ToInt32(ddlKetquaThuLy.SelectedValue);
                if (kq < 3)
                    tieudebc += " có kết quả giải quyết đơn là";
                //---------------------
                tieudebc += " " + ddlKetquaThuLy.SelectedItem.Text.Replace("...", "").ToLower();
            }
            txtTieuDeBC.Text = "Danh sách giải quyết đơn GĐT,TT " + tieudebc;
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
      
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlKetquaThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
    }
}