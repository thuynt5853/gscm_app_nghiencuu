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

namespace WEB.GSTP.Danhmuc.ConfigQHPLTK
{
    public partial class Config : System.Web.UI.Page
    {

        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public DataTable tblQHPLTK = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDrop();
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        //--------------------------------
        void LoadDrop()
        {
            LoadDropLoaiAN();
            int LoaiAn = Convert.ToInt16(dropLoai.SelectedValue);
            LoadDropQHPL_TK(LoaiAn, dropQHPLTK_Edit,2);
        }
        void LoadDropQHPL_TK(int LoaiAn, DropDownList drop, int tinhtrang)
        {
            String StrLoaiAn = "", loai_an_name="";
            if (LoaiAn < 10)
                StrLoaiAn = "0" + LoaiAn.ToString();

            //DANSU = 0; HONNHAN_GIADINH = 1; KINHDOANH_THUONGMAI = 2; LAODONG = 3; HANHCHINH = 4; PHASAN = 5; NGANHKINHTE = 15;
            switch(StrLoaiAn)
            {//HINH_SU
                case ENUM_LOAIVUVIEC.AN_HINHSU:
                    LoaiAn = 1; loai_an_name = "HINH_SU";
                    break;
                case ENUM_LOAIVUVIEC.AN_DANSU:
                    LoaiAn = 0;
                    break;
                case ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH:
                    LoaiAn = 1;
                    break;
                case ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI:
                    LoaiAn =2;
                    break;
                case ENUM_LOAIVUVIEC.AN_LAODONG:
                    LoaiAn = 3;
                    break;
                case ENUM_LOAIVUVIEC.AN_HANHCHINH:
                    LoaiAn = 4;
                    break;
                case ENUM_LOAIVUVIEC.AN_PHASAN:
                    LoaiAn =5;
                    break;
            }

            DM_QHPL_TK_BL objBL = new DM_QHPL_TK_BL();
            DataTable tblQHPLTK = objBL.GDTTT_QHPL_TK_GetByLoaiAn(tinhtrang, LoaiAn, loai_an_name);
            if (tblQHPLTK != null && tblQHPLTK.Rows.Count>0)
            {
                drop.Items.Clear();
                drop.DataSource = tblQHPLTK;
                drop.DataTextField = "TenToiDanh";
                drop.DataValueField = "ID";
                drop.DataBind();
                drop.Items.Insert(0, new ListItem("Chọn", "0"));
            }
        }
        void LoadDropLoaiAN()
        {
            dropLoai.Items.Clear();
            //dropLoai.Items.Add(new ListItem("---------- chọn -------------", ""));
            dropLoai.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            dropLoai.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            dropLoai.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            dropLoai.Items.Add(new ListItem("Hôn nhân - Gia đình ", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            dropLoai.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            dropLoai.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));

            //---------------------------------
            dropLoaiAn.Items.Clear();
            //dropLoaiAn.Items.Add(new ListItem("---------- chọn -------------", ""));
            dropLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            dropLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            dropLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            dropLoaiAn.Items.Add(new ListItem("Hôn nhân - Gia đình ", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            dropLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            dropLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
        }
        //--------------------------------
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int CurrID = 0;
            if (hddCurrID.Value != "" && hddCurrID.Value != "0")
                CurrID = Convert.ToInt32(hddCurrID.Value);
            Decimal LoaiAn = Convert.ToDecimal(dropLoai.SelectedValue);
            Decimal QHPLTK_ID = Convert.ToDecimal(dropQHPLTK_Edit.SelectedValue);
            Update_QHPL(0, CurrID, txtTen.Text.Trim(),LoaiAn, QHPLTK_ID, null);

            //------------------------
            hddPageIndex.Value = "1";
            LoadGrid();
            Resetcontrol();
            lbthongbao.Text = "Cập nhật dữ liệu thành công!";
        }

        void Update_QHPL(int type, Decimal QHPL_ID, String TenQHPL, decimal LoaiAn, Decimal QHPLTK_ID, HiddenField hddOldQHPL)
        {
            //type =0--> Update bang form edit, type=1--> update trong ds
            GDTTT_DM_QHPL obj = new GDTTT_DM_QHPL();
            obj = dt.GDTTT_DM_QHPL.Where(x => x.ID == QHPL_ID).FirstOrDefault();
            try
            {
                if (obj == null)
                    obj = new GDTTT_DM_QHPL();
            }
            catch (Exception ex) { obj = new GDTTT_DM_QHPL(); }

            obj.QHPLTK_ID = QHPLTK_ID;
            if (type == 0)
            {
                obj.TENQHPL = TenQHPL;
                obj.LOAIAN = LoaiAn;
            }
            if (QHPL_ID == 0)
                dt.GDTTT_DM_QHPL.Add(obj);
            dt.SaveChanges();
            if(hddOldQHPL != null)
                hddOldQHPL.Value = obj.QHPLTK_ID.ToString();
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            Resetcontrol();
        }
        protected void Resetcontrol()
        {
            hddCurrID.Value = "0";
            txtTen.Text = "";
            dropLoai.SelectedIndex = 0;
        }
        //--------------------------------
     
        protected void cmUpdateConfig_Click(object sender, EventArgs e)
        {
            int IsUpdate = 0;
            foreach(RepeaterItem item in rpt.Items)
            {
                HiddenField hddID = (HiddenField)item.FindControl("hddID");
                Decimal QHPL_ID = Convert.ToDecimal( hddID.Value);

                DropDownList dropQHPLTK = (DropDownList)item.FindControl("dropQHPLTK");
                Decimal QHPLTK_ID = Convert.ToDecimal(dropQHPLTK.SelectedValue);

                HiddenField hddOldQHPL = (HiddenField)item.FindControl("hddOldQHPL");
                Decimal Old_QHPLTK_ID = Convert.ToDecimal(hddOldQHPL.Value);
                
                if(Old_QHPLTK_ID != QHPLTK_ID )
                {
                    Update_QHPL(1, QHPL_ID, "", Convert.ToDecimal(dropLoaiAn.SelectedValue), QHPLTK_ID, hddOldQHPL);
                    IsUpdate++;
                }
            }
            //------------------------
            if (IsUpdate>0)
                lbthongbao.Text = "Cập nhật dữ liệu thành công!";
        }
        
        public void LoadGrid()
        {
            lbthongbao.Text = "";
            string textsearch = txttimkiem.Text.Trim();
            int loai_an = (string.IsNullOrEmpty(dropLoaiAn.SelectedValue)) ? 2 : Convert.ToInt32(dropLoaiAn.SelectedValue);
            int tinhtrang =  Convert.ToInt32(dropIsConfig.SelectedValue);
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            DM_QHPL_TK_BL objBL = new DM_QHPL_TK_BL();
            DataTable tbl = objBL.GDTTT_QHPL_GetByLoaiAn_Paging(textsearch, tinhtrang, loai_an, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pnPagingTop.Visible = false;
                rpt.Visible =pnPagingBottom.Visible =  lstSobanghiB.Visible= true;
            }
            else
            {
                pnPagingTop.Visible = false;
                rpt.Visible = pnPagingBottom.Visible = lstSobanghiB.Visible = false;
                lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                DataRowView dv = (DataRowView)e.Item.DataItem;
                int QHPLTK_ID = (string.IsNullOrEmpty(dv["QHPLTK_ID"] + "")) ? 0 : Convert.ToInt32(dv["QHPLTK_ID"] + "");

                int LoaiAn = Convert.ToInt16(dropLoaiAn.SelectedValue);
                DropDownList dropQHPLTK = (DropDownList)e.Item.FindControl("dropQHPLTK");
                LoadDropQHPL_TK(LoaiAn ,dropQHPLTK, Convert.ToInt32(dropIsConfig.SelectedValue));
                Cls_Comon.SetValueComboBox(dropQHPLTK, QHPLTK_ID);
            }
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "toidanh":
                    Response.Redirect("Edit.aspx?boluatID=" + curr_id);
                    break;
                case "Sua":
                    LoadInfo(curr_id);
                    hddCurrID.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(curr_id);
                    Resetcontrol();
                    break;
            }
        }
        public void LoadInfo(decimal vID)
        {
            GDTTT_DM_QHPL oT = dt.GDTTT_DM_QHPL.Where(x => x.ID == vID).Single();
            if (oT != null)
            {
                Cls_Comon.SetValueComboBox( dropLoai, oT.LOAIAN);
                txtTen.Text = oT.TENQHPL;
                //------Load Ds config-----------------------
                int LoaiAn = Convert.ToInt16(dropLoai.SelectedValue);
                LoadDropQHPL_TK(LoaiAn,dropQHPLTK_Edit,2);
                Cls_Comon.SetValueComboBox(dropQHPLTK_Edit, oT.QHPLTK_ID);
            }
        }
        
        public void xoa(decimal id)
        {
            List<DM_BOLUAT_TOIDANH> lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == id).ToList();
            if (lst.Count > 0)
            {
                lbthongbao.Text = "Nhóm danh mục đã có dữ liệu, không thể xóa được.";
                return;
            }

            DM_BOLUAT oT = dt.DM_BOLUAT.Where(x => x.ID == id).FirstOrDefault();
            dt.DM_BOLUAT.Remove(oT);
            dt.SaveChanges();

            hddPageIndex.Value = "1";
            LoadGrid();
            Resetcontrol();
            lbthongbao.Text = "Xóa thành công!";
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
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
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
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
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
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
        protected void dropLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void dropIsConfig_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void dropLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            int LoaiAn = Convert.ToInt16(dropLoai.SelectedValue);
            LoadDropQHPL_TK(LoaiAn, dropQHPLTK_Edit, 2);
        }
    }
}