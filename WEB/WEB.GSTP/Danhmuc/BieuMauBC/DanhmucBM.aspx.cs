using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System.Web.UI.WebControls;




namespace WEB.GSTP.Danhmuc.BieuMauBC
{
    public partial class Danhmuc : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                loadDrop();
                LoadGrid();

            }
        }
        void loadDrop()
        {
            LoadDropLoai();
            LoadDropHieuLuc();
        }


        void LoadDropLoai()
        {
            droploaian.Items.Clear();
            droploaian.Items.Add(new ListItem("--Loại vụ án--", ""));
            droploaian.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            droploaian.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            droploaian.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            droploaian.Items.Add(new ListItem("Hôn nhân - Gia đình ", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            droploaian.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            droploaian.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            droploaian.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            droploaian.Items.Add(new ListItem("BP XLHC", ENUM_LOAIVUVIEC.BPXLHC));
            droploaian.Items.Add(new ListItem("Thi hành án", ENUM_LOAIVUVIEC.AN_THA));
        }
        void LoadDropHieuLuc()
        {
            dropHieuLuc.Items.Clear();
            dropHieuLuc.Items.Add(new ListItem("--Tình trạng--", "2"));
            dropHieuLuc.Items.Add(new ListItem("Đang sử dụng", "1"));
            dropHieuLuc.Items.Add(new ListItem("Không sử dụng", "0"));

        }
        protected void BtnThemmoi_Click(object sender, EventArgs e)
        {
            Response.Redirect("SuaBM.aspx");
        }


        void LoadGrid()
        {

            lbthongbao.Text = "";
            string textKey = txttimkiem.Text.Trim().ToLower();
            decimal loai = (string.IsNullOrEmpty(droploaian.SelectedValue)) ? 0 : Convert.ToDecimal(droploaian.SelectedValue);
            decimal hieuluc = Convert.ToDecimal(dropHieuLuc.SelectedValue);
            int pageSize = Convert.ToInt32(Hddsize.Value);
            int pageIndex = Convert.ToInt32(hddPageIndex.Value);

            DM_BIEUMAU_BL objBM = new DM_BIEUMAU_BL();
            DataTable tbl = objBM.DM_BIEUMAU_GETALL(textKey, loai, hieuluc, pageIndex, pageSize);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int countall = Convert.ToInt32(tbl.Rows[0]["CountAll"]);
                #region"phân trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(countall, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + countall.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
            dgList.DataSource = tbl;
            dgList.DataBind();



        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        #region
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();


            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }

        }
        #endregion
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        public void xoa(decimal id)
        {
            DM_BIEUMAU BM = dt.DM_BIEUMAU.Where(x => x.ID == id).FirstOrDefault();
            if (BM != null)
            {
                dt.DM_BIEUMAU.Remove(BM);
                dt.SaveChanges();

                hddPageIndex.Value = "1";
                LoadGrid();
                lbthongbao.Text = "Xóa thành công!";
            }
        }
        protected void cmdThutu_Click(object sender, EventArgs e)
        {
            try
            {
                int ColIDIndex = 0;
                decimal loaiID = 0;
                DM_BIEUMAU bm = new DM_BIEUMAU();
                foreach (DataGridItem oItem in dgList.Items)
                {
                    loaiID = Convert.ToDecimal(oItem.Cells[ColIDIndex].Text);
                    bm = dt.DM_BIEUMAU.Where(x => x.ID == loaiID).FirstOrDefault<DM_BIEUMAU>();
                    TextBox textbox = (TextBox)oItem.FindControl("txtThuTu");
                    
                    bm.THUTU = Convert.ToDecimal(textbox.Text.Trim());

                    CheckBox chkHoso = (CheckBox)oItem.FindControl("chkHoso");
                    CheckBox chkSotham = (CheckBox)oItem.FindControl("chkSotham");
                    CheckBox chkPhuctham = (CheckBox)oItem.FindControl("chkPhuctham");
                    CheckBox chkGDT = (CheckBox)oItem.FindControl("chkGDT");
                    CheckBox chkNguyendon = (CheckBox)oItem.FindControl("chkNguyendon");
                    CheckBox chkDuongsu = (CheckBox)oItem.FindControl("chkDuongsu");
                    CheckBox chkVKS = (CheckBox)oItem.FindControl("chkVKS");
                    CheckBox chkHieuluc = (CheckBox)oItem.FindControl("chkHieuluc"); 
                        CheckBox chkPrint = (CheckBox)oItem.FindControl("chkPrint"); 
                    bm.IS_TD_NGUYENDON = chkNguyendon.Checked ? 1 : 0;
                    bm.IS_TD_DUONGSU = chkDuongsu.Checked ? 1 : 0;
                    bm.IS_TD_VKS = chkVKS.Checked ? 1 : 0;

                    bm.ISHOSO = chkHoso.Checked ? 1 : 0;
                    bm.ISSOTHAM = chkSotham.Checked ? 1 : 0;
                    bm.ISPHUCTHAM = chkPhuctham.Checked ? 1 : 0;
                    bm.ISGDTTT = chkGDT.Checked ? 1 : 0;
                    bm.ACTIVE = chkHieuluc.Checked ? 1 : 0;
                    bm.ISPRINT = chkPrint.Checked ? 1 : 0;
                }
                dt.SaveChanges();
                hddPageIndex.Value = "1";
                LoadGrid();
                lbthongbao.Text = "Lưu thông tin thành công.!";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal LoaiBM = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    Response.Redirect("SuaBM.aspx?vID=" + LoaiBM);
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa.!";
                        return;
                    }
                    xoa(LoaiBM);
                    break;
            }
        }

        protected void droploaian_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadGrid();
        }
    }
}