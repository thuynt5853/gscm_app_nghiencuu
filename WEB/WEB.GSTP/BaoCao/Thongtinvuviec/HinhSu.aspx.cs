using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.QLAN;
using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Linq;
using System.Web.UI.WebControls;

namespace WEB.GSTP.BaoCao.Thongtinvuviec
{
    public partial class HinhSu : System.Web.UI.Page
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
            decimal VuAnID = 0;
            if (Session["GSTP_CALL_VUAN_INFO"] != null)
            {
                VuAnID = Convert.ToDecimal(Session["GSTP_CALL_VUAN_INFO"]);
            }
            else
            {
                VuAnID = Session[ENUM_LOAIAN.AN_HINHSU] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            }
            if (this.hsID != 0)
            {
                VuAnID = this.hsID;
            }
            AHS_VUAN don = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
            if (don != null)
            {
                lblTenVuViec.Text = "<b>Thông tin vụ án: </b>" + don.MAVUAN + " - " + don.TENVUAN;
                hddToaSoTham.Value = don.TOAANID + "" == "" ? "0" : don.TOAANID + "";
                hddToaPhucTham.Value = don.TOAPHUCTHAMID + "" == "" ? "0" : don.TOAPHUCTHAMID + "";
            }
            string XML = "<menuitem value='st' Text='Sơ thẩm'></menuitem>";
            hddGiaiDoan.Value = "st";
            AHS_SOTHAM_THULY st = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).FirstOrDefault<AHS_SOTHAM_THULY>();
            if (st != null)
            {
                XML = "<menuitem value='st' Text='Sơ thẩm " + ((DateTime)st.NGAYTHULY).ToString("dd/MM/yyyy") + "'></menuitem>";
            }
            AHS_PHUCTHAM_THULY pt = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == VuAnID).FirstOrDefault<AHS_PHUCTHAM_THULY>();
            if (pt != null)
            {
                XML += "<menuitem value='pt' Text='Phúc thẩm " + ((DateTime)pt.NGAYTHULY).ToString("dd/MM/yyyy") + "'></menuitem>";
                hddGiaiDoan.Value = "pt";
            }
            // GDTTT chưa xác định được loại vụ án
            //GDTTT_DON_THULY gdt = dt.GDTTT_DON_THULY.Where(x => x.DONID == VuAnID).FirstOrDefault<GDTTT_DON_THULY>();
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
            decimal VuAnID = 0;
            if (Session["GSTP_CALL_VUAN_INFO"] != null)
            {
                VuAnID = Convert.ToDecimal(Session["GSTP_CALL_VUAN_INFO"]);
            }
            else
            {
                VuAnID = Session[ENUM_LOAIAN.AN_HINHSU] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            }
            if (this.hsID != 0)
            {
                VuAnID = this.hsID;
            }
            AHS_SOTHAM_BL oBLST = new AHS_SOTHAM_BL();
            AHS_PHUCTHAM_BL oBLPT = new AHS_PHUCTHAM_BL();
            DataTable oDT = null;
            int total = 0, pageSize = 20;
            //Thụ lý
            if (pnThuLy.Visible)
            {
                AHS_SOTHAM_THULY_BL ThuLyBLST = new AHS_SOTHAM_THULY_BL();
                AHS_PHUCTHAM_THULY_BL ThuLyBLPT = new AHS_PHUCTHAM_THULY_BL();
                if (hddGiaiDoan.Value == "st")
                {
                    oDT = ThuLyBLST.GetByVuAnID(VuAnID);
                }
                else if (hddGiaiDoan.Value == "pt")
                {
                    oDT = ThuLyBLPT.GetByVuAnID(VuAnID);
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
                    oDT = oBLST.AHS_SOTHAM_HDXX_GETLIST(VuAnID);
                }
                else if (hddGiaiDoan.Value == "pt")
                {
                    oDT = oBLPT.AHS_PHUCTHAM_HDXX_GETLIST(VuAnID);
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
                int PageIndex = Convert.ToInt32(hddPageIndex.Value);
                if (hddGiaiDoan.Value == "st")
                {
                    //AHS_BICANBICAO_BL objBL = new AHS_BICANBICAO_BL();
                    //oDT = objBL.GetAllPaging(VuAnID, "", PageIndex, pageSize);
                    STPT_CHITIETVUAN objBL = new STPT_CHITIETVUAN();
                    oDT = objBL.AHS_STPT_CHITIETVUAN_DANHSACHBICAO(2, VuAnID, PageIndex, pageSize);
                }
                else if (hddGiaiDoan.Value == "pt")
                {
                    STPT_CHITIETVUAN objBL = new STPT_CHITIETVUAN();
                    oDT = objBL.AHS_STPT_CHITIETVUAN_DANHSACHBICAO(3,VuAnID, PageIndex, pageSize);
                }
                if (oDT != null && oDT.Rows.Count > 0)
                {
                    if (hddGiaiDoan.Value == "st")
                    {
                        total = Convert.ToInt32(oDT.Rows[0]["CountAll"]);
                        dgListDuongSu.CurrentPageIndex = 0;
                    }
                    else if (hddGiaiDoan.Value == "pt")
                    {
                        total = oDT.Rows.Count;
                        dgListDuongSu.CurrentPageIndex = PageIndex - 1;
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
                    oDT = oBLST.AHS_ST_QD_VUAN_GETLIST(VuAnID);
                }
                else if (hddGiaiDoan.Value == "pt")
                {
                    oDT = oBLPT.AHS_PT_QD_VUAN_GETLIST(VuAnID);
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
                    oDT = oBLST.AHS_SOTHAM_BANAN_CHITIET(VuAnID);
                }
                else if (hddGiaiDoan.Value == "pt")
                {
                    oDT = oBLPT.AHS_PHUCTHAM_BANAN_CHITIET(VuAnID);
                }
                if (oDT != null && oDT.Rows.Count > 0)
                {
                    total = oDT.Rows.Count; pageSize = dgListBanAn.PageSize;
                    dgListBanAn.CurrentPageIndex = Convert.ToInt16(hddPageIndex.Value) - 1;
                    if (hddGiaiDoan.Value == "st")
                    {
                        // ẩn cột kết quả phúc thẩm, lý do
                        dgListBanAn.Columns[6].Visible = true;
                        dgListBanAn.Columns[3].Visible = dgListBanAn.Columns[4].Visible = false;
                    }
                    else if (hddGiaiDoan.Value == "pt")
                    {
                        // ẩn cột quá hạn
                        dgListBanAn.Columns[6].Visible = false;
                        dgListBanAn.Columns[3].Visible = dgListBanAn.Columns[4].Visible = true;
                    }
                }
                dgListBanAn.DataSource = oDT;
                dgListBanAn.DataBind();
            }
            // Kháng cáo
            else if (pnKhangCao.Visible)
            {
                int PageIndex = Convert.ToInt32(hddPageIndex.Value);
                STPT_CHITIETVUAN objBL = new STPT_CHITIETVUAN();
                oDT = objBL.AHS_STPT_CHITIETVUAN_DANHSACHKHANGCAO(2, VuAnID, PageIndex, pageSize);
                DataTable temp = oDT.Clone();
                if (oDT != null /*&& oDT.Select("IsKhangCao='1'").Count() > 0*/ /*&& hddGiaiDoan.Value == "st"*/)
                {
                    temp = oDT/*.Select("IsKhangCao='1'").CopyToDataTable()*/;//kháng cáo
                    total = temp.Rows.Count; pageSize = dgListKhangCao.PageSize;
                    dgListKhangCao.CurrentPageIndex = Convert.ToInt16(hddPageIndex.Value) - 1;
                }
                dgListKhangCao.DataSource = temp;
                dgListKhangCao.DataBind();
            }
            // Kháng nghị
            else if (pnKhangNghi.Visible)
            {
                int PageIndex = Convert.ToInt32(hddPageIndex.Value);
                STPT_CHITIETVUAN objBL = new STPT_CHITIETVUAN();
                oDT = objBL.AHS_STPT_CHITIETVUAN_DANHSACHKHANGNGHI(2, VuAnID, PageIndex, pageSize);
                DataTable temp = oDT.Clone();
                if (oDT != null /*&& oDT.Select("IsKhangCao='2'").Count() > 0*/ /*&& hddGiaiDoan.Value == "st"*/)
                {
                    temp = oDT/*.Select("IsKhangCao='2'").CopyToDataTable()*/;//Kháng nghị
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
        public bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
    }
}