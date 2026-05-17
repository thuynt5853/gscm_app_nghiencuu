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

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.XetXuGDT
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
                    txtTieuDeBC.Text = "Danh sách các vụ án tham gia xét xử GĐT,TT";

                    LoadDrop();
                    SetTieuDeBaoCao();
                    LoadReport();
                }
            }
            catch (Exception ex) { lttMsg.Text = "<div class='msg_error'>" + ex.Message + "</div>"; }
        }
        void LoadDrop()
        {
            try
            {
                LoadDropThamphan();
            }
            catch (Exception ex) { }
            //---------------------------
            //Trình trạng thụ lý
            DM_DATAITEM_BL oDMBL = new DM_DATAITEM_BL();
            ddlKetquaXX.DataSource = oDMBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.KETLUANGDTTT);
            ddlKetquaXX.DataTextField = "MA_TEN";
            ddlKetquaXX.DataValueField = "ID";
            ddlKetquaXX.DataBind();
            ddlKetquaXX.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
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
            DataTable tblData = GetDsXX();
            XetXuGDT.DSXX xx = new XetXuGDT.DSXX();
            report_name = (String.IsNullOrEmpty(txtTieuDeBC.Text.Trim()) ? "Danh sách các vụ án tham gia xét xử GĐT,TT" : txtTieuDeBC.Text.Trim()).ToUpper();
            xx.Parameters["TieuDeBC"].Value = report_name;
            xx.Parameters["ThoiGian"].Value = ThoiGian;
            xx.Parameters["TieuDeTime"].Value = "Hà Nội, ngày " + DateTime.Now.Day + " tháng " + DateTime.Now.Month + " năm " + DateTime.Now.Year.ToString();

            xx.Parameters["TongSo"].Value = tblData.Rows.Count + " vụ án";
            xx.DataSource = tblData;
            rptView.OpenReport(xx);
        }
        private DataTable GetDsXX()
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();

            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);

            DateTime? vNgayThulyTu = txtNgay_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtNgay_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            decimal trangthai = Convert.ToDecimal(dropTrangThaiXXGDT.SelectedValue);
            decimal vketquaXX = Convert.ToDecimal(ddlKetquaXX.SelectedValue);
            DataTable tbl = null;
            tbl = oBL.GDTTT_XXGDTTT_SearchByTP(vToaAnID, vPhongbanID
                   , vLoaiAn, vThamphan
                   , vNgayThulyTu, vNgayThulyDen,trangthai, vketquaXX);
            if (tbl != null && tbl.Rows.Count>0)
            {
                int LoaiKN = 0;
                String NgayKN = "", lanhdao ="", ttv="", machucvu="", temp ="";
                foreach(DataRow row in tbl.Rows)
                {
                    LoaiKN = 0;
                    LoaiKN = Convert.ToInt16(row["ISVIENTRUONGKN"] + "");
                    NgayKN = row["GDQ_NGAY"] + "";
                    if (LoaiKN == 0)
                        row["KN_ChanhAn"] = NgayKN;
                    else row["KN_VKS"] = NgayKN;

                    //----------------------
                    ttv = row["TENTHAMTRAVIEN"]+"";
                    lanhdao = row["TENLANHDAO"]+"";
                    machucvu = row["MaChucVuLD"] + "";
                    temp = (string.IsNullOrEmpty(lanhdao)) ? "" : lanhdao + (String.IsNullOrEmpty(machucvu) ?"":"(" +machucvu+")");
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
           
                string temp = "";
                if (dropTrangThaiXXGDT.SelectedValue != "1")
                    temp += "tham gia xét xử GĐT,TT";
                else temp += "đã xét xử GĐT,TT";
                txtTieuDeBC.Text = "Danh sách các vụ án "+ temp + tieudebc;
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
      
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        //protected void ddlKetquaThuLy_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    SetTieuDeBaoCao();
        //}
    }
}