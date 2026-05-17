using BL.GSTP;
using BL.GSTP.AHC;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.BaoCao.Thongtinvuviec
{
    public partial class HanhChinh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        private decimal hsID = 0;
        RSAHelprer rSAHelprer;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Session[ENUM_SESSION.RSA] == null)
                {
                    this.rSAHelprer = new RSAHelprer();
                    Session[ENUM_SESSION.RSA] = this.rSAHelprer;
                }
                else
                {
                    this.rSAHelprer = Session[ENUM_SESSION.RSA] as RSAHelprer;
                }
                string hsID = Request.QueryString["hsID"];
                if (!String.IsNullOrEmpty(hsID))
                {
                    try
                    {
                        this.hsID = Convert.ToDecimal(this.rSAHelprer.Decryption(hsID));
                    }
                    catch
                    {
                        throw new MessageException("Dữ liệu không hợp lệ");
                    }
                }
                if (!IsPostBack)
                {
                    LoadTreeGiaiDoan();
                    SetSelectedNodeInTreView(hddGiaiDoan.Value);
                    cmdThuLy_Click(sender, e);
                    tvOne_SelectedNodeChanged(sender, e);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadTreeGiaiDoan()
        {
            tvOne.Nodes.Clear();
            decimal DonID = 0;
            if (Session["GSTP_CALL_VUAN_INFO"] != null)
            {
                DonID = Convert.ToDecimal(Session["GSTP_CALL_VUAN_INFO"]);
            }
            else
            {
                DonID = Session[ENUM_LOAIAN.AN_HANHCHINH] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH] + "");
            }
            if (this.hsID != 0)
            {
                DonID = this.hsID;
            }
            AHC_DON don = dt.AHC_DON.Where(x => x.ID == DonID).FirstOrDefault<AHC_DON>();
            if (don != null)
            {
                lblTenVuViec.Text = "<b>Thông tin vụ việc: </b>" + don.MAVUVIEC + " - " + don.TENVUVIEC;
                hddToaSoTham.Value = don.TOAANID + "" == "" ? "0" : don.TOAANID + "";
                hddToaPhucTham.Value = don.TOAPHUCTHAMID + "" == "" ? "0" : don.TOAPHUCTHAMID + "";
            }
            string XML = "<menuitem value='st' Text='Sơ thẩm'></menuitem>";
            hddGiaiDoan.Value = "st";
            AHC_SOTHAM_THULY st = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == DonID).FirstOrDefault<AHC_SOTHAM_THULY>();
            if (st != null)
            {
                XML = "<menuitem value='st' Text='Sơ thẩm " + ((DateTime)st.NGAYTHULY).ToString("dd/MM/yyyy") + "'></menuitem>";
            }
            AHC_PHUCTHAM_THULY pt = dt.AHC_PHUCTHAM_THULY.Where(x => x.DONID == DonID).FirstOrDefault<AHC_PHUCTHAM_THULY>();
            if (pt != null)
            {
                XML += "<menuitem value='pt' Text='Phúc thẩm " + ((DateTime)pt.NGAYTHULY).ToString("dd/MM/yyyy") + "'></menuitem>";
                hddGiaiDoan.Value = "pt";
            }
            // GDTTT chưa xác định được loại vụ việc
            //GDTTT_DON_THULY gdt = dt.GDTTT_DON_THULY.Where(x => x.DONID == DonID).FirstOrDefault<GDTTT_DON_THULY>();
            //if (gdt != null)
            //{
            //    XML += "<menuitem value='gdttt' Text='Giám đốc thẩm, tái thẩm " + ((DateTime)gdt.NGAYTHULY).ToString("dd/MM/yyyy") + "'></menuitem>";
            //    hddGiaiDoan.Value = "gdttt";
            //}
            string strCurrentXMLVD = @"<?xml version=""1.0"" encoding=""UTF-8""?><menucha>" + XML + "</menucha>";
            XmlDataSource datasource = new XmlDataSource();
            datasource.Data = strCurrentXMLVD;
            datasource.ID = Guid.NewGuid().ToString();
            datasource.XPath = " menucha/menuitem";
            datasource.DataBind();

            tvOne.DataSource = datasource;
            tvOne.DataBind();
            tvOne.CollapseAll();
        }
        private void LoadData()
        {
            lbthongbao.Text = "";
            decimal DonID = 0;
            if (Session["GSTP_CALL_VUAN_INFO"] != null)
            {
                DonID = Convert.ToDecimal(Session["GSTP_CALL_VUAN_INFO"]);
            }
            else
            {
                DonID = Session[ENUM_LOAIAN.AN_HANHCHINH] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH] + "");
            }
            if (this.hsID != 0)
            {
                DonID = this.hsID;
            }
            AHC_SOTHAM_BL oBLST = new AHC_SOTHAM_BL();
            AHC_PHUCTHAM_BL oBLPT = new AHC_PHUCTHAM_BL();
            DataTable oDT = null;
            int total = 0, pageSize = 20;
            //Thụ lý
            if (pnThuLy.Visible)
            {
                if (hddGiaiDoan.Value == "st")
                {
                    oDT = oBLST.AHC_SOTHAM_THULY_GETLIST(DonID);
                }
                else if (hddGiaiDoan.Value == "pt")
                {
                    oDT = oBLPT.AHC_PHUCTHAM_THULY_GETLIST(DonID);
                }
                if (oDT != null && oDT.Rows.Count > 0)
                {
                    total = oDT.Rows.Count; pageSize = dgListThuLy.PageSize;
                    dgListThuLy.CurrentPageIndex = Convert.ToInt16(hddPageIndex.Value) - 1;
                }
                dgListThuLy.DataSource = oDT;
                dgListThuLy.DataBind();
            }
            // HDXX
            else if (pnHDXX.Visible)
            {
                if (hddGiaiDoan.Value == "st")
                {
                    oDT = oBLST.AHC_SOTHAM_HDXX_GETLIST(DonID);
                }
                else if (hddGiaiDoan.Value == "pt")
                {
                    oDT = oBLPT.AHC_PHUCTHAM_HDXX_GETLIST(DonID);
                }
                if (oDT != null && oDT.Rows.Count > 0)
                {
                    total = oDT.Rows.Count; pageSize = dgListHDXX.PageSize;
                    dgListHDXX.CurrentPageIndex = Convert.ToInt16(hddPageIndex.Value) - 1;
                }
                dgListHDXX.DataSource = oDT;
                dgListHDXX.DataBind();
            }
            // Đương sự
            else if (pnDuongSu.Visible)
            {
                AHC_DON_DUONGSU_BL oBLDS = new AHC_DON_DUONGSU_BL();
                if (hddGiaiDoan.Value == "st")
                {
                    oDT = oBLDS.AHC_DON_DUONGSU_GETBY(DonID);
                }
                else if (hddGiaiDoan.Value == "pt")
                {
                    oDT = oBLDS.AHC_PHUCTHAM_DUONGSU_GETBY(DonID, 0);
                }
                if (oDT != null && oDT.Rows.Count > 0)
                {
                    total = oDT.Rows.Count; pageSize = dgListDuongSu.PageSize;
                    dgListDuongSu.CurrentPageIndex = Convert.ToInt16(hddPageIndex.Value) - 1;
                    if (hddGiaiDoan.Value == "st")
                    {
                        dgListDuongSu.Columns[1].Visible = false;
                    }
                    else if (hddGiaiDoan.Value == "pt")
                    {
                        dgListDuongSu.Columns[1].Visible = true;
                    }
                }
                dgListDuongSu.DataSource = oDT;
                dgListDuongSu.DataBind();
            }
            // Quyết định
            else if (pnQuyetDinh.Visible)
            {
                if (hddGiaiDoan.Value == "st")
                {
                    oDT = oBLST.AHC_SOTHAM_QUYETDINH_GETLIST(DonID);
                }
                else if (hddGiaiDoan.Value == "pt")
                {
                    oDT = oBLPT.AHC_PHUCTHAM_QUYETDINH_GETLIST(DonID);
                }
                if (oDT != null && oDT.Rows.Count > 0)
                {
                    total = oDT.Rows.Count; pageSize = dgListQuyetDinh.PageSize;
                    dgListQuyetDinh.CurrentPageIndex = Convert.ToInt16(hddPageIndex.Value) - 1;
                }
                dgListQuyetDinh.DataSource = oDT;
                dgListQuyetDinh.DataBind();
            }
            // Bản án
            else if (pnBanAn.Visible)
            {
                if (hddGiaiDoan.Value == "st")
                {
                    oDT = oBLST.AHC_SOTHAM_BANAN_CHITIET(DonID);
                }
                else if (hddGiaiDoan.Value == "pt")
                {
                    oDT = oBLPT.AHC_PHUCTHAM_BANAN_CHITIET(DonID);
                }
                if (oDT != null && oDT.Rows.Count > 0)
                {
                    total = oDT.Rows.Count; pageSize = dgListBanAn.PageSize;
                    dgListBanAn.CurrentPageIndex = Convert.ToInt16(hddPageIndex.Value) - 1;
                    if (hddGiaiDoan.Value == "st")
                    {
                        // ẩn cột kết quả phúc thẩm, lý do
                        dgListBanAn.Columns[5].Visible = dgListBanAn.Columns[6].Visible = false;
                    }
                    else
                    {
                        dgListBanAn.Columns[5].Visible = dgListBanAn.Columns[6].Visible = true;
                    }
                }
                dgListBanAn.DataSource = oDT;
                dgListBanAn.DataBind();
            }
            // Kháng cáo
            else if (pnKhangCao.Visible)
            {
                oDT = oBLST.AHC_SOTHAM_KCaoKNghi_GETLIST(DonID);
                DataTable temp = oDT.Clone();
                if (oDT != null && oDT.Select("IsKhangCao='1'").Count() > 0 && hddGiaiDoan.Value == "st")
                {
                    temp = oDT.Select("IsKhangCao='1'").CopyToDataTable();//kháng cáo
                    total = temp.Rows.Count; pageSize = dgListKhangCao.PageSize;
                    dgListKhangCao.CurrentPageIndex = Convert.ToInt16(hddPageIndex.Value) - 1;
                }
                dgListKhangCao.DataSource = temp;
                dgListKhangCao.DataBind();
            }
            // Kháng nghị
            else if (pnKhangNghi.Visible)
            {
                oDT = oBLST.AHC_SOTHAM_KCaoKNghi_GETLIST(DonID);
                DataTable temp = oDT.Clone();
                if (oDT != null && oDT.Select("IsKhangCao='2'").Count() > 0 && hddGiaiDoan.Value == "st")
                {
                    temp = oDT.Select("IsKhangCao='2'").CopyToDataTable();//Kháng nghị
                    total = temp.Rows.Count; pageSize = dgListKhangNghi.PageSize;
                    dgListKhangNghi.CurrentPageIndex = Convert.ToInt16(hddPageIndex.Value) - 1;
                }
                dgListKhangNghi.DataSource = temp;
                dgListKhangNghi.DataBind();
            }
            #region "Xác định số lượng trang"
            hddTotalPage.Value = Cls_Comon.GetTotalPage(total, pageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            #endregion
        }
        #region Phân trang
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void cmdThuLy_Click(object sender, EventArgs e)
        {
            try
            {
                cmdHDXX.CssClass = cmdDuongSu.CssClass = cmdKhangCao.CssClass = cmdKhangNghi.CssClass = cmdQuyetDinh.CssClass = cmdBanAn.CssClass = "menubutton_TTCT";
                pnHDXX.Visible = pnDuongSu.Visible = pnKhangCao.Visible = pnKhangNghi.Visible = pnQuyetDinh.Visible = pnBanAn.Visible = false;
                cmdThuLy.CssClass = "menubuttonActive_TTCT";
                pnThuLy.Visible = true;
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdHDXX_Click(object sender, EventArgs e)
        {
            try
            {
                cmdThuLy.CssClass = cmdDuongSu.CssClass = cmdKhangCao.CssClass = cmdKhangNghi.CssClass = cmdQuyetDinh.CssClass = cmdBanAn.CssClass = "menubutton_TTCT";
                pnThuLy.Visible = pnDuongSu.Visible = pnKhangCao.Visible = pnKhangNghi.Visible = pnQuyetDinh.Visible = pnBanAn.Visible = false;
                cmdHDXX.CssClass = "menubuttonActive_TTCT";
                pnHDXX.Visible = true;
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdDuongSu_Click(object sender, EventArgs e)
        {
            try
            {
                cmdHDXX.CssClass = cmdThuLy.CssClass = cmdKhangCao.CssClass = cmdKhangNghi.CssClass = cmdQuyetDinh.CssClass = cmdBanAn.CssClass = "menubutton_TTCT";
                pnHDXX.Visible = pnThuLy.Visible = pnKhangCao.Visible = pnKhangNghi.Visible = pnQuyetDinh.Visible = pnBanAn.Visible = false;
                cmdDuongSu.CssClass = "menubuttonActive_TTCT";
                pnDuongSu.Visible = true;
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdKhangCao_Click(object sender, EventArgs e)
        {
            try
            {
                cmdHDXX.CssClass = cmdDuongSu.CssClass = cmdThuLy.CssClass = cmdKhangNghi.CssClass = cmdQuyetDinh.CssClass = cmdBanAn.CssClass = "menubutton_TTCT";
                pnHDXX.Visible = pnDuongSu.Visible = pnThuLy.Visible = pnKhangNghi.Visible = pnQuyetDinh.Visible = pnBanAn.Visible = false;
                cmdKhangCao.CssClass = "menubuttonActive_TTCT";
                pnKhangCao.Visible = true;
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdKhangNghi_Click(object sender, EventArgs e)
        {
            try
            {
                cmdHDXX.CssClass = cmdDuongSu.CssClass = cmdKhangCao.CssClass = cmdThuLy.CssClass = cmdQuyetDinh.CssClass = cmdBanAn.CssClass = "menubutton_TTCT";
                pnHDXX.Visible = pnDuongSu.Visible = pnKhangCao.Visible = pnThuLy.Visible = pnQuyetDinh.Visible = pnBanAn.Visible = false;
                cmdKhangNghi.CssClass = "menubuttonActive_TTCT";
                pnKhangNghi.Visible = true;
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdQuyetDinh_Click(object sender, EventArgs e)
        {
            try
            {
                cmdHDXX.CssClass = cmdDuongSu.CssClass = cmdKhangCao.CssClass = cmdKhangNghi.CssClass = cmdThuLy.CssClass = cmdBanAn.CssClass = "menubutton_TTCT";
                pnHDXX.Visible = pnDuongSu.Visible = pnKhangCao.Visible = pnKhangNghi.Visible = pnThuLy.Visible = pnBanAn.Visible = false;
                cmdQuyetDinh.CssClass = "menubuttonActive_TTCT";
                pnQuyetDinh.Visible = true;
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdBanAn_Click(object sender, EventArgs e)
        {
            try
            {
                cmdHDXX.CssClass = cmdDuongSu.CssClass = cmdKhangCao.CssClass = cmdKhangNghi.CssClass = cmdQuyetDinh.CssClass = cmdThuLy.CssClass = "menubutton_TTCT";
                pnHDXX.Visible = pnDuongSu.Visible = pnKhangCao.Visible = pnKhangNghi.Visible = pnQuyetDinh.Visible = pnThuLy.Visible = false;
                cmdBanAn.CssClass = "menubuttonActive_TTCT";
                pnBanAn.Visible = true;
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch { return false; }
        }
        protected void tvOne_SelectedNodeChanged(object sender, EventArgs e)
        {
            hddGiaiDoan.Value = tvOne.SelectedValue;
            lblTenToaAn.Text = "";
            DM_TOAAN ta = null; decimal ToaID = 0;
            if (hddGiaiDoan.Value == "st")
            {
                ToaID = Convert.ToDecimal(hddToaSoTham.Value);
                ta = dt.DM_TOAAN.Where(x => x.ID == ToaID).FirstOrDefault();
                if (ta != null)
                {
                    lblTenToaAn.Text += "<b>Tòa sơ thẩm: </b>" + ta.TEN;
                }
                else
                {
                    lblTenToaAn.Text += "";
                }
            }
            else
            {
                ToaID = Convert.ToDecimal(hddToaPhucTham.Value);
                ta = dt.DM_TOAAN.Where(x => x.ID == ToaID).FirstOrDefault();
                if (ta != null)
                {
                    lblTenToaAn.Text += "<b>Tòa phúc thẩm: </b>" + ta.TEN;
                }
                else
                {
                    lblTenToaAn.Text += "";
                }
            }
            cmdThuLy_Click(sender, e);
        }
        private void SetSelectedNodeInTreView(string strValue)
        {
            foreach (TreeNode node in tvOne.Nodes)
            {
                if (node.Value == strValue)
                {
                    node.Selected = true;
                }
            }
        }
    }
}